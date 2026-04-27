#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Validate the SSHVault AppArmor profile syntax WITHOUT loading it into the
# kernel. Run this from CI (or locally) before shipping a release.
#
# Exit codes:
#   0 — profile parses cleanly
#   1 — apparmor_parser missing (CI image needs the package)
#   2 — profile failed to parse (syntax error, dangling include, etc.)
# ---------------------------------------------------------------------------
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="${SCRIPT_DIR}/de.kiefer_networks.sshvault"

if [[ ! -f "${PROFILE}" ]]; then
  echo "FAIL: profile not found at ${PROFILE}" >&2
  exit 2
fi

if ! command -v apparmor_parser >/dev/null 2>&1; then
  echo "SKIP: apparmor_parser not installed."
  echo "      Install with:"
  echo "        Debian/Ubuntu: sudo apt install apparmor-utils"
  echo "        OpenSUSE:      sudo zypper install apparmor-parser"
  echo "        Fedora:        sudo dnf install apparmor-parser"
  exit 1
fi

echo "==> Parsing ${PROFILE} (no kernel load)"

# -Q / --skip-kernel-load: parse + validate but never push to the kernel.
# -K          : skip cache read so we always re-parse the actual file.
# -T          : skip cache write (CI should not pollute /var/cache).
# -p          : preprocess only — flushes resolved policy to stdout, which
#               is handy for diffing changes between releases.
if apparmor_parser -Q -K -T --debug "${PROFILE}" >/tmp/sshvault-aa-parsed 2>&1; then
  echo "PASS: AppArmor profile parses cleanly."
  echo "      ($(wc -l < "${PROFILE}") lines, $(wc -c < "${PROFILE}") bytes)"
  rm -f /tmp/sshvault-aa-parsed
  exit 0
else
  rc=$?
  echo "FAIL: apparmor_parser rejected the profile (exit ${rc})." >&2
  echo "----- parser output -----" >&2
  cat /tmp/sshvault-aa-parsed >&2 || true
  echo "-------------------------" >&2
  rm -f /tmp/sshvault-aa-parsed
  exit 2
fi
