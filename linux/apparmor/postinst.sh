#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Post-install hook invoked by Debian (postinst), RPM (%post) and OpenSUSE
# packaging glue. Copies the SSHVault AppArmor profile into /etc/apparmor.d/
# and reloads it so it takes effect immediately, without a reboot.
#
# Idempotent: safe to run on upgrades. No-op on systems where AppArmor is
# either not installed or not enabled in the kernel.
# ---------------------------------------------------------------------------
set -eu

SRC_PROFILE="${1:-/usr/share/sshvault/apparmor/de.kiefer_networks.sshvault}"
DST_PROFILE="/etc/apparmor.d/de.kiefer_networks.sshvault"

# Skip silently if AppArmor isn't available (e.g. SELinux-only systems).
if ! command -v apparmor_parser >/dev/null 2>&1; then
  exit 0
fi
if [ ! -d /sys/kernel/security/apparmor ]; then
  exit 0
fi

install -Dm644 "${SRC_PROFILE}" "${DST_PROFILE}"

# -r: replace (load if missing, reload if already loaded).
# Failure here is non-fatal — packaging shouldn't abort the whole install.
apparmor_parser -r -W "${DST_PROFILE}" || \
  echo "warning: failed to reload AppArmor profile ${DST_PROFILE}" >&2

exit 0
