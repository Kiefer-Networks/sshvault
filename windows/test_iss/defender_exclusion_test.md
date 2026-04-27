# Manual test plan: Windows Defender folder-exclusion opt-in

Inno Setup scripts cannot be unit-tested, but the `[Code]` fragment in
`windows/installer.iss` (procedures `InitializeWizard`, `NextButtonClick`,
`RunDefenderAdd`, `CurStepChanged`, `RunDefenderRemove`,
`CurUninstallStepChanged`, helper `AppendUninsLog`) can be reviewed visually
and exercised through the steps below.

## Prerequisites

- Windows 10/11 host with Microsoft Defender enabled (default state).
- Inno Setup 6.x compiler (`ISCC.exe`) available.
- A built Flutter Windows release (`flutter build windows --release`) so the
  `..\build\windows\x64\runner\Release\*` source pattern resolves.
- PowerShell 5.1+ available at `%SystemRoot%\System32\WindowsPowerShell\v1.0`.
- Two test accounts:
  - **A**: standard non-admin user (UAC will deny Defender writes).
  - **B**: local administrator (or ability to elevate the installer).

## Build

```powershell
cd windows
ISCC.exe /DAppVersion=0.0.0-test installer.iss
```

The compiled installer drops in `..\installer-output\`.

---

## TC-1 — Wizard page shows up and defaults to unchecked

1. Run the installer normally.
2. Click through Welcome -> License (if any) -> Select Tasks.
3. **Expected:** A new wizard page titled **"Performance options"** appears
   immediately *after* the Select Tasks page with:
   - Subtitle: "Optional Windows Defender exclusion".
   - Intro paragraph explaining vault DB writes / SSH key generation impact.
   - One checkbox: "Add SSHVault folder to Windows Defender exclusions
     (recommended for vault performance)" — **unchecked by default**.
   - Smaller explanatory paragraph below the checkbox describing the
     `Add-MpPreference` call, admin requirement and manual fallback path.
4. Continue without ticking. Finish the install.
5. **Expected:** `{app}\unins-log.txt` exists and contains a line like
   `... install: user declined Defender exclusion (no action taken)`.

## TC-2 — Opt-in succeeds when installer runs elevated (account B)

1. Right-click installer -> **Run as administrator**.
2. On the "Performance options" page, **tick** the checkbox. Continue.
3. Wait for install to complete.
4. **Expected:**
   - No error dialog appears.
   - `{app}\unins-log.txt` contains:
     - `install: user opted-in to Defender exclusion for <install path>`
     - `install: powershell exit=0 success=True output=OK ...`
   - `Get-MpPreference | Select-Object -ExpandProperty ExclusionPath`
     in an admin PowerShell lists the install folder.

## TC-3 — Opt-in is denied gracefully without admin (account A)

1. Run the installer as the standard user; choose "Install for me only" if
   prompted (PrivilegesRequiredOverridesAllowed=dialog).
2. Tick the Defender checkbox; continue and finish the install.
3. **Expected:**
   - A friendly dialog appears stating
     "Defender exclusion needs admin — re-run installer with elevated rights
     or add exclusion manually via Defender settings".
   - `unins-log.txt` records a non-zero `exit=` and the captured PowerShell
     `ERR: ...` message.
   - `Get-MpPreference` does **not** list the install folder.
   - The rest of the install (files, shortcuts, registry) succeeds.

## TC-4 — Uninstall prompts for removal (Yes path)

Precondition: TC-2 left the exclusion in place.

1. Launch Add/Remove Programs -> SSHVault -> Uninstall (as admin).
2. **Expected:** Confirmation dialog
   "Remove the SSHVault folder from Windows Defender exclusions?" with
   Yes/No buttons (default = No).
3. Click **Yes**.
4. **Expected:**
   - PowerShell runs `Remove-MpPreference -ExclusionPath '<app>'`.
   - `unins-log.txt` records `uninstall: ... success=True output=OK`.
   - `Get-MpPreference` no longer lists the path.
   - Uninstall completes normally.

## TC-5 — Uninstall, user declines removal (No path)

1. Reinstall with the exclusion enabled (as in TC-2).
2. Uninstall and answer **No** to the confirmation dialog.
3. **Expected:**
   - `unins-log.txt` records
     `uninstall: user declined Defender exclusion removal (no action taken)`.
   - The Defender exclusion is **still present** after uninstall.
   - Uninstall otherwise completes normally.

## TC-6 — Uninstall removal denied without admin

1. Reinstall with the exclusion enabled (as admin).
2. Uninstall as a standard user (no elevation), answer **Yes** to the prompt.
3. **Expected:**
   - Friendly fallback dialog
     "Defender exclusion removal needs admin ..." appears.
   - `unins-log.txt` records the failure with captured stderr.
   - Uninstall otherwise completes normally.

---

## Code-review checklist for `[Code]` block

- [ ] Checkbox default is `False` (line: `DefenderPage.Values[0] := False;`).
- [ ] No registry / Defender call happens unless
      `DefenderExclusionRequested` is `True`.
- [ ] `RunDefenderAdd` only fires from `ssPostInstall`, never earlier.
- [ ] `CurUninstallStepChanged` always asks via `MsgBox` before mutating.
- [ ] PowerShell command single-quotes the path and uses
      `-ExecutionPolicy Bypass -NoProfile`.
- [ ] stdout+stderr are redirected (`> ... 2>&1`) into `{tmp}\defender-*.log`
      and appended to `{app}\unins-log.txt`.
- [ ] Failure paths surface a user-readable `MsgBox` and do not abort
      install/uninstall.
- [ ] No silent registry writes are made anywhere in this script.
