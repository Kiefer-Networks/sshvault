# SSHVault KRunner Integration

Quick-connect to SSHVault hosts straight from KDE Plasma's KRunner /
Application Launcher. Type `ssh <name-or-host>`, hit Enter, and SSHVault
opens an SSH session to the matching entry.

## Architecture

```
KRunner ──D-Bus──▶ de.kiefer_networks.SshvaultKRunner   (this Python script)
                              │
                              └──D-Bus──▶ de.kiefer_networks.SSHVault   (the
                                                                         SSHVault
                                                                         desktop
                                                                         app)
```

* `de.kiefer_networks.sshvault-runner.py` — implements
  `org.kde.krunner1`. It calls `ListHosts()` on the SSHVault application
  service for every keystroke and forwards `Connect(host_id)` when the
  user picks a match.
* `de.kiefer_networks.sshvault-runner.desktop` — the KRunner plugin
  descriptor. Registered under `~/.local/share/krunner/dbusplugins/`.
* `de.kiefer_networks.SshvaultKRunner.service` — the D-Bus session
  service file. Lets the bus auto-start the runner on demand.

## Requirements

* KDE Plasma 5.27+ or Plasma 6.x with KRunner.
* Python 3.9+ with `dbus-python` and `PyGObject` (system packages):
  * Fedora/openSUSE: `python3-dbus`, `python3-gobject`
  * Debian/Ubuntu: `python3-dbus`, `python3-gi`
  * Arch: `python-dbus`, `python-gobject`
* SSHVault must be running for the runner to return any results — the
  runner does **not** auto-start the app (that would launch a full
  Flutter desktop window from inside a launcher search, which is not
  what users want).

## Install (per user)

```sh
./install.sh
```

This drops three files into your `~/.local/share/`:

| File | Path |
| --- | --- |
| Python runner | `~/.local/share/sshvault/krunner/de.kiefer_networks.sshvault-runner.py` |
| KRunner plugin | `~/.local/share/krunner/dbusplugins/de.kiefer_networks.sshvault-runner.desktop` |
| D-Bus service | `~/.local/share/dbus-1/services/de.kiefer_networks.SshvaultKRunner.service` |

The script is idempotent — run it again to upgrade. It also asks
`kbuildsycoca` to refresh KRunner's cache so the runner appears without
a logout.

## Install (system-wide)

For distribution packages, copy to:

| File | Path |
| --- | --- |
| Python runner | `/usr/share/kservices5/de.kiefer_networks.sshvault-runner.py` |
| KRunner plugin | `/usr/share/krunner/dbusplugins/de.kiefer_networks.sshvault-runner.desktop` |
| D-Bus service | `/usr/share/dbus-1/services/de.kiefer_networks.SshvaultKRunner.service` |

The CMake target under `linux/CMakeLists.txt` does this automatically
when building outside of Flatpak.

## Usage

1. Launch SSHVault (so its D-Bus service is registered).
2. Open KRunner: `Alt+Space` (or whatever you've bound).
3. Type:
   * `ssh ` — list all hosts.
   * `ssh prod` — substring match against host names and `user@host`.
4. Enter on a result connects via SSHVault.

## Flatpak note

The Flatpak build is sandboxed and **cannot** publish the runner script
to the host's `~/.local/share/krunner/`. If you want KRunner integration
on a Flatpak install of SSHVault, run `install.sh` from this repository
manually — the runner only needs `dbus-python` and a working session
bus, both of which are standard on KDE installations.

## Uninstall

```sh
rm ~/.local/share/krunner/dbusplugins/de.kiefer_networks.sshvault-runner.desktop
rm ~/.local/share/dbus-1/services/de.kiefer_networks.SshvaultKRunner.service
rm -r ~/.local/share/sshvault/krunner
kbuildsycoca6 --noincremental 2>/dev/null || kbuildsycoca5 --noincremental 2>/dev/null || true
```

## Testing

A pure-Python unit test for the matcher (no D-Bus required) lives at
`test/match_test.py`:

```sh
python3 test/match_test.py
```
