#!/usr/bin/env bash
# Installs the SSHVault KRunner integration into the user's home directory.
#
# Targets (per-user, no sudo required):
#
#   ~/.local/share/krunner/dbusplugins/   <- KRunner plugin .desktop file
#   ~/.local/share/dbus-1/services/       <- D-Bus session service file
#   ~/.local/share/sshvault/krunner/      <- Python runner script
#
# The script is idempotent: re-running it overwrites the previously installed
# files, so it doubles as an "update" command after pulling new SSHVault
# releases. To remove the integration, delete the three files listed by the
# final "Installed:" output.

set -euo pipefail

SOURCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DESKTOP_FILE="de.kiefer_networks.sshvault-runner.desktop"
SERVICE_FILE="de.kiefer_networks.SshvaultKRunner.service"
RUNNER_FILE="de.kiefer_networks.sshvault-runner.py"

PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/krunner/dbusplugins"
DBUS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dbus-1/services"
RUNNER_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/sshvault/krunner"

mkdir -p "$PLUGIN_DIR" "$DBUS_DIR" "$RUNNER_DIR"

# 1. Copy the Python runner to a stable per-user location.
install -m 0755 "$SOURCE_DIR/$RUNNER_FILE" "$RUNNER_DIR/$RUNNER_FILE"

# 2. Rewrite the D-Bus service file's Exec= line to point at the per-user
#    install location (the file in the repo uses /usr/share/... for system
#    packages; per-user installs need an absolute path under $HOME).
sed -e "s|^Exec=.*$|Exec=/usr/bin/python3 $RUNNER_DIR/$RUNNER_FILE|" \
    "$SOURCE_DIR/$SERVICE_FILE" > "$DBUS_DIR/$SERVICE_FILE"
chmod 0644 "$DBUS_DIR/$SERVICE_FILE"

# 3. Drop the KRunner plugin descriptor in place.
install -m 0644 "$SOURCE_DIR/$DESKTOP_FILE" "$PLUGIN_DIR/$DESKTOP_FILE"

# 4. Ask kbuildsycoca to refresh KRunner's plugin cache so the new runner
#    appears immediately. Best-effort: if the binary isn't present (Plasma 6
#    builds, non-KDE machines) we skip silently.
if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
elif command -v kbuildsycoca5 >/dev/null 2>&1; then
    kbuildsycoca5 --noincremental >/dev/null 2>&1 || true
fi

# 5. If KRunner is already running, ask it to reload runners. Again best-effort.
if command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.krunner /App org.kde.krunner.App.reloadConfig >/dev/null 2>&1 || true
elif command -v qdbus >/dev/null 2>&1; then
    qdbus org.kde.krunner /App org.kde.krunner.App.reloadConfig >/dev/null 2>&1 || true
fi

cat <<EOF
SSHVault KRunner integration installed.

Installed:
  $PLUGIN_DIR/$DESKTOP_FILE
  $DBUS_DIR/$SERVICE_FILE
  $RUNNER_DIR/$RUNNER_FILE

Open KRunner (Alt+Space) and type:  ssh <hostname>
Make sure the SSHVault application is running so its D-Bus service is up.
EOF
