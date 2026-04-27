[Setup]
AppId={{DE-KIEFER-NETWORKS-SSHVAULT}
AppName=SSHVault
AppVersion={#AppVersion}
AppVerName=SSHVault {#AppVersion}
AppPublisher=Kiefer Networks
AppPublisherURL=https://kiefer-networks.de
AppSupportURL=https://github.com/Kiefer-Networks/sshvault/issues
DefaultDirName={autopf}\SSHVault
DefaultGroupName=SSHVault
DisableProgramGroupPage=yes
OutputDir=..\installer-output
OutputBaseFilename=SSHVault-{#AppVersion}-windows-setup
SetupIconFile=runner\resources\app_icon.ico
UninstallDisplayIcon={app}\sshvault.exe
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "swedish"; MessagesFile: "compiler:Languages\Swedish.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\SSHVault"; Filename: "{app}\sshvault.exe"
Name: "{group}\{cm:UninstallProgram,SSHVault}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\SSHVault"; Filename: "{app}\sshvault.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\sshvault.exe"; Description: "{cm:LaunchProgram,SSHVault}"; Flags: nowait postinstall skipifsilent

; --------------------------------------------------------------------------
; URL scheme handlers (ssh://, sftp://) and file associations (.pub, .pem,
; .ppk). All entries land under HKCU\Software\Classes so the installer can
; run with PrivilegesRequired=lowest (no UAC). `uninsdeletekey` makes the
; uninstaller clean every key we created so users can revert the integration.
; The runtime registrar in `lib/core/services/windows_protocol_registrar.dart`
; writes the same keys for portable / zip distributions that bypass Inno.
; --------------------------------------------------------------------------
[Registry]
; ----- ssh:// URL scheme -----
Root: HKCU; Subkey: "Software\Classes\ssh"; ValueType: string; ValueName: ""; ValueData: "URL:Secure Shell"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\ssh"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\ssh\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\sshvault.exe,0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\ssh\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\sshvault.exe"" ""%1"""; Flags: uninsdeletekey

; ----- sftp:// URL scheme -----
Root: HKCU; Subkey: "Software\Classes\sftp"; ValueType: string; ValueName: ""; ValueData: "URL:SSH File Transfer Protocol"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\sftp"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\sftp\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\sshvault.exe,0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\sftp\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\sshvault.exe"" ""%1"""; Flags: uninsdeletekey

; ----- File extension -> ProgID mappings -----
Root: HKCU; Subkey: "Software\Classes\.pub"; ValueType: string; ValueName: ""; ValueData: "SSHVault.PublicKey"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\.pem"; ValueType: string; ValueName: ""; ValueData: "SSHVault.PEMKey"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\.ppk"; ValueType: string; ValueName: ""; ValueData: "SSHVault.PPKKey"; Flags: uninsdeletekey

; ----- ProgIDs and their open commands (--import-keys) -----
Root: HKCU; Subkey: "Software\Classes\SSHVault.PublicKey"; ValueType: string; ValueName: ""; ValueData: "SSH public key"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SSHVault.PublicKey\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\sshvault.exe,0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SSHVault.PublicKey\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\sshvault.exe"" --import-keys ""%1"""; Flags: uninsdeletekey

Root: HKCU; Subkey: "Software\Classes\SSHVault.PEMKey"; ValueType: string; ValueName: ""; ValueData: "PEM-encoded private key"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SSHVault.PEMKey\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\sshvault.exe,0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SSHVault.PEMKey\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\sshvault.exe"" --import-keys ""%1"""; Flags: uninsdeletekey

Root: HKCU; Subkey: "Software\Classes\SSHVault.PPKKey"; ValueType: string; ValueName: ""; ValueData: "PuTTY private key"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SSHVault.PPKKey\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\sshvault.exe,0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\SSHVault.PPKKey\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\sshvault.exe"" --import-keys ""%1"""; Flags: uninsdeletekey

; ----- AppUserModelID for native toast notifications -----
; Registers `de.kiefer_networks.SSHVault` so toasts produced by
; `WindowsNotificationService` (Windows.UI.Notifications) resolve back to
; the SSHVault icon + display name in the Action Center, and persist there
; after dismissal. The AUMID string MUST stay in sync with `kSshVaultAumid`
; in `lib/core/services/windows_notification_service.dart` and the runtime
; call to `windowManager.setAppUserModelId` in `lib/main.dart`.
Root: HKCU; Subkey: "Software\Classes\AppUserModelId\de.kiefer_networks.SSHVault"; ValueType: string; ValueName: "DisplayName"; ValueData: "SSHVault"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\AppUserModelId\de.kiefer_networks.SSHVault"; ValueType: string; ValueName: "IconUri"; ValueData: "{app}\sshvault.exe,0"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\AppUserModelId\de.kiefer_networks.SSHVault"; ValueType: string; ValueName: "IconBackgroundColor"; ValueData: "FF1E1E2E"; Flags: uninsdeletekey

; ----- Auto-start (Run key) -----
; The setting is owned by the runtime AutostartService — the installer
; does NOT pre-create the value, but it MUST clean it up on uninstall so
; the Run entry doesn't survive removal and trigger a missing-EXE error
; at next login. `uninsdeletevalue` removes ONLY this single value (not
; the parent Run key, which is shared with other apps).
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: none; ValueName: "SSHVault"; Flags: uninsdeletevalue

; --------------------------------------------------------------------------
; Windows Defender folder-exclusion opt-in
; --------------------------------------------------------------------------
; Real-time AV scanning slows down vault DB writes, key generation and SSH
; session handshakes. We OFFER (never silently apply) a folder exclusion via
; Add-MpPreference. The user must explicitly opt-in on the custom wizard page
; below; uninstall offers symmetric removal with a confirmation prompt. Every
; action is appended to {app}\unins-log.txt so behaviour is auditable.
; --------------------------------------------------------------------------
[Code]
var
  DefenderPage: TInputOptionWizardPage;
  DefenderExclusionRequested: Boolean;

procedure AppendUninsLog(const Line: string);
var
  LogPath: string;
  Existing, Stamped: AnsiString;
begin
  LogPath := ExpandConstant('{app}\unins-log.txt');
  Stamped := AnsiString(GetDateTimeString('yyyy-mm-dd hh:nn:ss', '-', ':') + '  ' + Line + #13#10);
  if FileExists(LogPath) then
  begin
    if LoadStringFromFile(LogPath, Existing) then
      SaveStringToFile(LogPath, Existing + Stamped, False)
    else
      SaveStringToFile(LogPath, Stamped, True);
  end
  else
    SaveStringToFile(LogPath, Stamped, False);
end;

procedure InitializeWizard();
var
  IntroLbl: TNewStaticText;
begin
  DefenderPage := CreateInputOptionPage(
    wpSelectTasks,
    'Performance options',
    'Optional Windows Defender exclusion',
    'SSHVault performs frequent encrypted reads/writes against its vault DB and ' +
    'generates SSH key material at runtime. Real-time antivirus scanning of the ' +
    'install folder can noticeably slow these operations. You may choose to add a ' +
    'Windows Defender folder exclusion now. This is fully optional and reversible.',
    False, False);

  DefenderPage.Add('Add SSHVault folder to Windows Defender exclusions (recommended for vault performance)');
  DefenderPage.Values[0] := False; { default unchecked - explicit opt-in }

  IntroLbl := TNewStaticText.Create(DefenderPage);
  IntroLbl.Parent := DefenderPage.Surface;
  IntroLbl.Top := DefenderPage.CheckListBox.Top + DefenderPage.CheckListBox.Height + ScaleY(8);
  IntroLbl.Left := DefenderPage.CheckListBox.Left + ScaleX(20);
  IntroLbl.Width := DefenderPage.SurfaceWidth - ScaleX(40);
  IntroLbl.AutoSize := False;
  IntroLbl.Height := ScaleY(60);
  IntroLbl.WordWrap := True;
  IntroLbl.Caption :=
    'Selecting this option runs PowerShell''s Add-MpPreference -ExclusionPath against ' +
    'your install directory. Adding/removing exclusions requires administrator rights; ' +
    'if Defender refuses, a friendly notice will be shown and you can add the path ' +
    'manually via Windows Security -> Virus & threat protection -> Exclusions.';
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = DefenderPage.ID then
    DefenderExclusionRequested := DefenderPage.Values[0];
end;

procedure RunDefenderAdd();
var
  ResultCode: Integer;
  InstallPath, PsCmd, TmpOut, OutText, SuccessStr: string;
  OutAnsi: AnsiString;
  Success: Boolean;
begin
  InstallPath := ExpandConstant('{app}');
  TmpOut := ExpandConstant('{tmp}\defender-add.log');
  { Single-quote the path; escape any embedded single quotes for PowerShell. }
  PsCmd := '-NoProfile -ExecutionPolicy Bypass -Command "try { Add-MpPreference -ExclusionPath ''' +
           InstallPath + ''' -ErrorAction Stop; Write-Output OK } catch { Write-Output (''ERR: '' + $_.Exception.Message); exit 1 }"';

  AppendUninsLog('install: user opted-in to Defender exclusion for ' + InstallPath);

  Success := Exec(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'),
                  PsCmd + ' > "' + TmpOut + '" 2>&1',
                  '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  if FileExists(TmpOut) and LoadStringFromFile(TmpOut, OutAnsi) then
    OutText := string(OutAnsi)
  else
    OutText := '<no output captured>';

  if Success then
    SuccessStr := 'True'
  else
    SuccessStr := 'False';
  AppendUninsLog('install: powershell exit=' + IntToStr(ResultCode) + ' success=' +
                 SuccessStr + ' output=' + OutText);

  if (not Success) or (ResultCode <> 0) then
  begin
    MsgBox(
      'Defender exclusion needs admin' + #13#10 + #13#10 +
      'SSHVault could not add a Windows Defender exclusion for:' + #13#10 +
      '  ' + InstallPath + #13#10 + #13#10 +
      'Please re-run the installer with elevated rights, or add the exclusion manually:' + #13#10 +
      '  Windows Security -> Virus & threat protection -> Manage settings ->' + #13#10 +
      '  Exclusions -> Add or remove exclusions -> Add an exclusion -> Folder.',
      mbInformation, MB_OK);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    if DefenderExclusionRequested then
      RunDefenderAdd
    else
      AppendUninsLog('install: user declined Defender exclusion (no action taken)');
  end;
end;

procedure RunDefenderRemove();
var
  ResultCode: Integer;
  InstallPath, PsCmd, TmpOut, OutText, SuccessStr: string;
  OutAnsi: AnsiString;
  Success: Boolean;
begin
  InstallPath := ExpandConstant('{app}');
  TmpOut := ExpandConstant('{tmp}\defender-remove.log');
  PsCmd := '-NoProfile -ExecutionPolicy Bypass -Command "try { Remove-MpPreference -ExclusionPath ''' +
           InstallPath + ''' -ErrorAction Stop; Write-Output OK } catch { Write-Output (''ERR: '' + $_.Exception.Message); exit 1 }"';

  AppendUninsLog('uninstall: user confirmed Defender exclusion removal for ' + InstallPath);

  Success := Exec(ExpandConstant('{sys}\WindowsPowerShell\v1.0\powershell.exe'),
                  PsCmd + ' > "' + TmpOut + '" 2>&1',
                  '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  if FileExists(TmpOut) and LoadStringFromFile(TmpOut, OutAnsi) then
    OutText := string(OutAnsi)
  else
    OutText := '<no output captured>';

  if Success then
    SuccessStr := 'True'
  else
    SuccessStr := 'False';
  AppendUninsLog('uninstall: powershell exit=' + IntToStr(ResultCode) + ' success=' +
                 SuccessStr + ' output=' + OutText);

  if (not Success) or (ResultCode <> 0) then
  begin
    MsgBox(
      'Defender exclusion removal needs admin' + #13#10 + #13#10 +
      'SSHVault could not remove the Windows Defender exclusion for:' + #13#10 +
      '  ' + InstallPath + #13#10 + #13#10 +
      'Please remove it manually via Windows Security -> Virus & threat protection -> ' +
      'Exclusions, or re-run the uninstaller as administrator.',
      mbInformation, MB_OK);
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  Answer: Integer;
begin
  if CurUninstallStep = usUninstall then
  begin
    Answer := MsgBox(
      'Remove the SSHVault folder from Windows Defender exclusions?' + #13#10 + #13#10 +
      'Choose Yes only if you previously asked the installer to add it (or added ' +
      'it manually). Choose No to leave Defender settings untouched.',
      mbConfirmation, MB_YESNO or MB_DEFBUTTON2);
    if Answer = IDYES then
      RunDefenderRemove
    else
      AppendUninsLog('uninstall: user declined Defender exclusion removal (no action taken)');
  end;
end;
