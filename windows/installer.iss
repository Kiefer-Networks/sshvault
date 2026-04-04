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
