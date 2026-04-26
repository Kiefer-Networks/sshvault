#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SSHVault KRunner integration.

This script implements the ``org.kde.krunner1`` D-Bus interface for KDE
Plasma's KRunner / Application Launcher (krunner). It exposes SSHVault
hosts as quick-connect entries: when the user types ``ssh <query>`` into
KRunner, this runner asks the SSHVault application's own D-Bus service
(``de.kiefer_networks.SSHVault``) for the host list, filters it locally
and forwards a ``Connect(host_id)`` call when an entry is activated.

The runner is registered with KRunner via a ``.desktop`` plugin file
(``X-Plasma-API=DBus``) and bus-activated through a standard
``dbus-1/services/`` service file. Both are shipped alongside this
script — see ``install.sh`` and ``README.md``.

Design notes
------------
* The runner deliberately keeps no persistent state. Each ``Match`` call
  re-fetches the host list. SSHVault's own service caches its data, so
  this is cheap and avoids stale results when the user adds or removes
  hosts in the SSHVault UI.
* If the SSHVault service isn't running, ``Match`` returns an empty list
  rather than raising — KRunner ignores empty results gracefully and we
  don't want to spam the user with errors for a perfectly normal
  "app not started yet" situation.
* Matching is case-insensitive substring against both the host's display
  name and ``user@host`` form. Relevance is a simple heuristic that
  prefers prefix matches on the name.
"""

from __future__ import annotations

import sys
from typing import Any, Iterable, List, Sequence, Tuple

import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib


# --------------------------------------------------------------------------- #
# Constants
# --------------------------------------------------------------------------- #

# This runner's own bus name / object path, referenced from the .desktop file
# (X-Plasma-DBusRunner-Service / X-Plasma-DBusRunner-Path).
RUNNER_BUS_NAME = "de.kiefer_networks.SshvaultKRunner"
RUNNER_OBJECT_PATH = "/SshvaultKRunner"
RUNNER_IFACE = "org.kde.krunner1"

# SSHVault's main application D-Bus service. Implemented by the SSHVault
# Flutter app itself (see the parallel DBus-service work).
SSHVAULT_BUS_NAME = "de.kiefer_networks.SSHVault"
SSHVAULT_OBJECT_PATH = "/de/kiefer_networks/SSHVault"
SSHVAULT_IFACE = "de.kiefer_networks.SSHVault"

# Trigger keyword. Queries that don't start with this (followed by a space, or
# the bare word) are ignored. Matches X-Plasma-Runner-Trigger-Words.
TRIGGER = "ssh"

# Icon shipped with SSHVault; see linux/icons/.
ICON_NAME = "de.kiefer_networks.sshvault"

# Result type constants from the KRunner specification. 100 = ExactMatch,
# 80 = PossibleMatch, 10 = InformationalMatch.
MATCH_TYPE_EXACT = 100
MATCH_TYPE_POSSIBLE = 80


# --------------------------------------------------------------------------- #
# Matching logic (kept side-effect-free so it's unit-testable)
# --------------------------------------------------------------------------- #

def parse_query(raw: str) -> str | None:
    """Return the search needle for *raw* or ``None`` if the query is not for us.

    KRunner forwards every keystroke; we only want to act on queries that
    begin with the trigger word ``ssh``. ``"ssh"`` alone (no needle) is
    treated as "show all hosts".
    """
    if raw is None:
        return None
    stripped = raw.strip()
    if not stripped:
        return None
    lower = stripped.lower()
    if lower == TRIGGER:
        return ""
    if lower.startswith(TRIGGER + " "):
        return stripped[len(TRIGGER) + 1:].strip()
    return None


def _host_haystack(host: dict) -> str:
    """Build the lowercased string we search against for a host entry."""
    name = str(host.get("name", "") or "")
    user = str(host.get("user", "") or "")
    address = str(host.get("host", "") or host.get("address", "") or "")
    user_at_host = f"{user}@{address}" if user and address else address
    return f"{name} {user_at_host}".lower()


def _score(host: dict, needle: str) -> float:
    """Compute relevance for *host* against *needle* in [0.0, 1.0].

    * Empty needle -> 0.5 (everything is equally relevant).
    * Prefix match on name -> 1.0.
    * Substring match -> 0.7.
    * No match -> 0.0 (caller should drop these).
    """
    if not needle:
        return 0.5
    needle_l = needle.lower()
    name_l = str(host.get("name", "") or "").lower()
    if name_l.startswith(needle_l):
        return 1.0
    if needle_l in _host_haystack(host):
        return 0.7
    return 0.0


def filter_hosts(hosts: Iterable[dict], needle: str) -> List[Tuple[dict, float]]:
    """Return ``(host, score)`` pairs sorted by descending score.

    Pure function — no D-Bus, no globals. Exposed for the unit test in
    ``test/match_test.py``.
    """
    scored: List[Tuple[dict, float]] = []
    for host in hosts:
        s = _score(host, needle)
        if s > 0.0:
            scored.append((host, s))
    scored.sort(key=lambda pair: (-pair[1], str(pair[0].get("name", ""))))
    return scored


def build_match_tuple(host: dict, score: float) -> Tuple[str, str, str, int, float, dict]:
    """Build a single KRunner match tuple for *host*.

    KRunner expects ``(id, text, icon, type, relevance, properties)``.
    The ``properties`` dict can carry a ``subtext`` field for the
    second-line description shown in the launcher.
    """
    host_id = str(host.get("id", "") or host.get("name", ""))
    name = str(host.get("name", "") or host_id)
    user = str(host.get("user", "") or "")
    address = str(host.get("host", "") or host.get("address", "") or "")
    if user and address:
        subtext = f"{user}@{address}"
    else:
        subtext = address or "SSHVault host"
    text = f"{name}  ({subtext})" if subtext else name
    match_type = MATCH_TYPE_EXACT if score >= 1.0 else MATCH_TYPE_POSSIBLE
    properties = {
        "subtext": subtext,
        "category": "SSHVault",
    }
    return (host_id, text, ICON_NAME, match_type, float(score), properties)


# --------------------------------------------------------------------------- #
# D-Bus runner service
# --------------------------------------------------------------------------- #

class SshvaultRunner(dbus.service.Object):
    """Implements the ``org.kde.krunner1`` interface for SSHVault."""

    def __init__(self, bus: dbus.SessionBus) -> None:
        bus_name = dbus.service.BusName(RUNNER_BUS_NAME, bus=bus)
        super().__init__(bus_name, RUNNER_OBJECT_PATH)
        self._bus = bus

    # -- helpers ------------------------------------------------------------ #

    def _sshvault_proxy(self) -> dbus.Interface | None:
        """Return a proxy to the SSHVault app service, or ``None`` if absent.

        We don't auto-start SSHVault: KRunner queries fire on every keystroke
        and starting a full Flutter desktop app from inside a launcher would
        be obnoxious. The user can launch SSHVault manually; once it's up,
        the runner will start returning results.
        """
        try:
            obj = self._bus.get_object(SSHVAULT_BUS_NAME, SSHVAULT_OBJECT_PATH)
            return dbus.Interface(obj, SSHVAULT_IFACE)
        except dbus.exceptions.DBusException:
            return None

    def _fetch_hosts(self) -> List[dict]:
        """Fetch the host list from SSHVault, returning ``[]`` on failure."""
        proxy = self._sshvault_proxy()
        if proxy is None:
            return []
        try:
            raw = proxy.ListHosts()
        except dbus.exceptions.DBusException:
            return []
        # The SSHVault service returns an array of dicts (a{sv}). dbus-python
        # presents these as dbus.Dictionary; normalise to plain dicts of str
        # keys / str values so the matching logic stays simple and testable.
        hosts: List[dict] = []
        for entry in raw or []:
            try:
                hosts.append({str(k): _coerce(v) for k, v in entry.items()})
            except AttributeError:
                # Defensive: skip malformed entries rather than blowing up.
                continue
        return hosts

    # -- org.kde.krunner1 methods ------------------------------------------ #

    @dbus.service.method(
        dbus_interface=RUNNER_IFACE,
        in_signature="s",
        out_signature="a(sssida{sv})",
    )
    def Match(self, query: str) -> Sequence[Any]:
        needle = parse_query(query)
        if needle is None:
            return []
        scored = filter_hosts(self._fetch_hosts(), needle)
        return [build_match_tuple(h, s) for h, s in scored]

    @dbus.service.method(
        dbus_interface=RUNNER_IFACE,
        in_signature="",
        out_signature="a(sss)",
    )
    def Actions(self) -> Sequence[Any]:
        # Tuple format: (id, text, icon-name). KRunner shows these as the
        # secondary action buttons next to a match. We only expose
        # "Connect" — Run() defaults to it when no action_id is given.
        return [("connect", "Connect", ICON_NAME)]

    @dbus.service.method(
        dbus_interface=RUNNER_IFACE,
        in_signature="ss",
        out_signature="",
    )
    def Run(self, match_id: str, action_id: str) -> None:
        # action_id is empty when the user just hits Enter on the match.
        # We treat that as "connect" — there's only one action anyway.
        proxy = self._sshvault_proxy()
        if proxy is None:
            return
        try:
            proxy.Connect(str(match_id))
        except dbus.exceptions.DBusException:
            # Silently swallow: the user will see SSHVault either pop up or
            # fail to do so; surfacing a Python traceback into KRunner's log
            # has no useful audience.
            return


# --------------------------------------------------------------------------- #
# Utilities
# --------------------------------------------------------------------------- #

def _coerce(value: Any) -> Any:
    """Convert dbus typed values to plain Python primitives recursively."""
    if isinstance(value, dbus.String):
        return str(value)
    if isinstance(value, (dbus.Int16, dbus.Int32, dbus.Int64,
                          dbus.UInt16, dbus.UInt32, dbus.UInt64,
                          dbus.Byte)):
        return int(value)
    if isinstance(value, dbus.Boolean):
        return bool(value)
    if isinstance(value, dbus.Double):
        return float(value)
    if isinstance(value, dbus.Array):
        return [_coerce(v) for v in value]
    if isinstance(value, dbus.Dictionary):
        return {str(k): _coerce(v) for k, v in value.items()}
    return value


# --------------------------------------------------------------------------- #
# Entry point
# --------------------------------------------------------------------------- #

def main() -> int:
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SessionBus()
    SshvaultRunner(bus)
    loop = GLib.MainLoop()
    try:
        loop.run()
    except KeyboardInterrupt:
        loop.quit()
    return 0


if __name__ == "__main__":
    sys.exit(main())
