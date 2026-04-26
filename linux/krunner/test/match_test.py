#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Unit tests for the KRunner matcher.

These tests cover the side-effect-free matching logic in
``de.kiefer_networks.sshvault-runner.py``. They deliberately avoid
loading the D-Bus parts of the runner so they can run on machines that
don't have ``dbus-python`` / ``PyGObject`` installed (CI minimal images,
macOS dev boxes, etc.).

Run with:

    python3 linux/krunner/test/match_test.py
"""

from __future__ import annotations

import importlib.util
import os
import sys
import types
import unittest


# --------------------------------------------------------------------------- #
# Load the runner module under a synthetic name, stubbing out the D-Bus and
# GObject imports so the module's top-level `import dbus` / `from gi.repository
# import GLib` lines don't blow up in environments without those packages.
# --------------------------------------------------------------------------- #

def _install_dbus_stubs() -> None:
    """Inject lightweight fakes for dbus / gi so the runner imports cleanly."""
    if "dbus" not in sys.modules:
        dbus_mod = types.ModuleType("dbus")

        class _Base:
            pass

        # Type tags used by the _coerce() helper. We only need isinstance()
        # checks against them to pass — the test suite never feeds real D-Bus
        # values through, so an empty class is sufficient.
        for name in ("String", "Int16", "Int32", "Int64", "UInt16", "UInt32",
                     "UInt64", "Byte", "Boolean", "Double", "Array",
                     "Dictionary"):
            setattr(dbus_mod, name, type(name, (_Base,), {}))

        class _SessionBus:
            pass

        dbus_mod.SessionBus = _SessionBus

        service_mod = types.ModuleType("dbus.service")

        class _Object:
            def __init__(self, *args, **kwargs):
                pass

        class _BusName:
            def __init__(self, *args, **kwargs):
                pass

        def _method(**_kwargs):
            def deco(fn):
                return fn
            return deco

        service_mod.Object = _Object
        service_mod.BusName = _BusName
        service_mod.method = _method
        dbus_mod.service = service_mod

        mainloop_mod = types.ModuleType("dbus.mainloop")
        glib_mainloop_mod = types.ModuleType("dbus.mainloop.glib")

        def _DBusGMainLoop(**_kwargs):
            return None

        glib_mainloop_mod.DBusGMainLoop = _DBusGMainLoop
        mainloop_mod.glib = glib_mainloop_mod
        dbus_mod.mainloop = mainloop_mod

        exceptions_mod = types.ModuleType("dbus.exceptions")

        class _DBusException(Exception):
            pass

        exceptions_mod.DBusException = _DBusException
        dbus_mod.exceptions = exceptions_mod
        dbus_mod.Interface = lambda *a, **k: None

        sys.modules["dbus"] = dbus_mod
        sys.modules["dbus.service"] = service_mod
        sys.modules["dbus.mainloop"] = mainloop_mod
        sys.modules["dbus.mainloop.glib"] = glib_mainloop_mod
        sys.modules["dbus.exceptions"] = exceptions_mod

    if "gi" not in sys.modules:
        gi_mod = types.ModuleType("gi")
        repo_mod = types.ModuleType("gi.repository")

        class _GLibStub:
            class MainLoop:
                def run(self):
                    pass

                def quit(self):
                    pass

        repo_mod.GLib = _GLibStub
        gi_mod.repository = repo_mod
        sys.modules["gi"] = gi_mod
        sys.modules["gi.repository"] = repo_mod


def _load_runner():
    _install_dbus_stubs()
    here = os.path.dirname(os.path.abspath(__file__))
    runner_path = os.path.join(
        here, os.pardir, "de.kiefer_networks.sshvault-runner.py"
    )
    spec = importlib.util.spec_from_file_location(
        "sshvault_krunner_runner", runner_path
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


runner = _load_runner()


# --------------------------------------------------------------------------- #
# Sample fixture used by every test. Mirrors the shape of dicts the SSHVault
# D-Bus service is expected to return from ListHosts().
# --------------------------------------------------------------------------- #

FAKE_HOSTS = [
    {"id": "1", "name": "production-web", "user": "deploy",
     "host": "web1.prod.example.com"},
    {"id": "2", "name": "staging-db", "user": "ops",
     "host": "db.staging.example.com"},
    {"id": "3", "name": "edge-cache", "user": "root",
     "host": "10.0.0.7"},
    {"id": "4", "name": "Production-Backup", "user": "backup",
     "host": "bak.prod.example.com"},
    # Entry with no user — exercises the "address only" subtext branch.
    {"id": "5", "name": "lab", "host": "lab.local"},
]


class ParseQueryTests(unittest.TestCase):
    def test_returns_none_for_non_ssh_query(self):
        self.assertIsNone(runner.parse_query("firefox"))
        self.assertIsNone(runner.parse_query(""))
        self.assertIsNone(runner.parse_query(None))

    def test_bare_trigger_returns_empty_needle(self):
        self.assertEqual(runner.parse_query("ssh"), "")
        self.assertEqual(runner.parse_query("SSH"), "")
        self.assertEqual(runner.parse_query("  ssh  "), "")

    def test_extracts_needle_after_trigger(self):
        self.assertEqual(runner.parse_query("ssh prod"), "prod")
        self.assertEqual(runner.parse_query("SSH prod"), "prod")
        self.assertEqual(runner.parse_query("ssh   web1.prod"), "web1.prod")

    def test_rejects_trigger_without_separator(self):
        # "sshfoo" is not a runner query for us — KRunner shouldn't be triggered
        # in the first place because the trigger word matches whole tokens, but
        # parse_query is the second line of defence.
        self.assertIsNone(runner.parse_query("sshfoo"))


class FilterHostsTests(unittest.TestCase):
    def test_empty_needle_returns_all_hosts(self):
        result = runner.filter_hosts(FAKE_HOSTS, "")
        self.assertEqual(len(result), len(FAKE_HOSTS))
        # All scores should be the neutral 0.5 for an empty needle.
        for _host, score in result:
            self.assertAlmostEqual(score, 0.5)

    def test_substring_match_on_name(self):
        result = runner.filter_hosts(FAKE_HOSTS, "edge")
        names = [h["name"] for h, _ in result]
        self.assertEqual(names, ["edge-cache"])

    def test_case_insensitive(self):
        result = runner.filter_hosts(FAKE_HOSTS, "PROD")
        names = {h["name"] for h, _ in result}
        # Both "production-web" and "Production-Backup" should match,
        # plus the staging-db / web1.prod / bak.prod address fragments.
        self.assertIn("production-web", names)
        self.assertIn("Production-Backup", names)

    def test_match_on_user_at_host(self):
        result = runner.filter_hosts(FAKE_HOSTS, "deploy@web1")
        names = [h["name"] for h, _ in result]
        self.assertEqual(names, ["production-web"])

    def test_match_on_address_only(self):
        result = runner.filter_hosts(FAKE_HOSTS, "10.0.0.7")
        names = [h["name"] for h, _ in result]
        self.assertEqual(names, ["edge-cache"])

    def test_prefix_match_outranks_substring(self):
        # "production-web" name starts with "prod" -> 1.0
        # "Production-Backup" name starts with "Prod" too (case-insensitive) -> 1.0
        # "staging-db" only matches via address (web1.prod, bak.prod, etc.) -> 0.7
        result = runner.filter_hosts(FAKE_HOSTS, "prod")
        # Top two should both be the prefix matches.
        top_two_scores = [score for _, score in result[:2]]
        self.assertEqual(top_two_scores, [1.0, 1.0])
        # And anything below them should have a lower score.
        for _, score in result[2:]:
            self.assertLess(score, 1.0)

    def test_no_match_returns_empty(self):
        self.assertEqual(runner.filter_hosts(FAKE_HOSTS, "nonexistent"), [])

    def test_results_sorted_by_score_then_name(self):
        # All FAKE_HOSTS share "e" via various paths; this exercises the
        # tiebreaker. We just assert that the list is sorted descending by
        # score and ascending by name within each score bucket.
        result = runner.filter_hosts(FAKE_HOSTS, "e")
        prev_score = float("inf")
        prev_name_in_bucket = ""
        for host, score in result:
            self.assertLessEqual(score, prev_score)
            if score == prev_score:
                self.assertGreaterEqual(host["name"], prev_name_in_bucket)
            else:
                prev_name_in_bucket = ""
            prev_score = score
            prev_name_in_bucket = host["name"]


class BuildMatchTupleTests(unittest.TestCase):
    def test_tuple_shape(self):
        host = FAKE_HOSTS[0]
        match_id, text, icon, mtype, relevance, props = (
            runner.build_match_tuple(host, 1.0)
        )
        self.assertEqual(match_id, "1")
        self.assertIn("production-web", text)
        self.assertIn("deploy@web1.prod.example.com", text)
        self.assertEqual(icon, runner.ICON_NAME)
        self.assertEqual(mtype, runner.MATCH_TYPE_EXACT)
        self.assertEqual(relevance, 1.0)
        self.assertEqual(props["subtext"], "deploy@web1.prod.example.com")
        self.assertEqual(props["category"], "SSHVault")

    def test_partial_match_is_possible_match_type(self):
        host = FAKE_HOSTS[0]
        _, _, _, mtype, _, _ = runner.build_match_tuple(host, 0.7)
        self.assertEqual(mtype, runner.MATCH_TYPE_POSSIBLE)

    def test_address_only_subtext(self):
        host = FAKE_HOSTS[4]  # 'lab' — no user
        _, text, _, _, _, props = runner.build_match_tuple(host, 0.7)
        self.assertEqual(props["subtext"], "lab.local")
        self.assertIn("lab.local", text)

    def test_falls_back_to_id_when_name_missing(self):
        host = {"id": "abc", "host": "x.example"}
        match_id, text, _, _, _, _ = runner.build_match_tuple(host, 0.7)
        self.assertEqual(match_id, "abc")
        self.assertIn("abc", text)


if __name__ == "__main__":
    unittest.main()
