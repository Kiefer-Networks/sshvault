// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SSH Vault';

  @override
  String get navHosts => 'Hosts';

  @override
  String get navSnippets => 'Snippets';

  @override
  String get navFolders => 'Folders';

  @override
  String get navTags => 'Tags';

  @override
  String get navSshKeys => 'SSH Keys';

  @override
  String get navExportImport => 'Export / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'More';

  @override
  String get navManagement => 'Management';

  @override
  String get navSettings => 'Settings';

  @override
  String get navAbout => 'About';

  @override
  String get lockScreenTitle => 'SSH Vault is locked';

  @override
  String get lockScreenUnlock => 'Unlock';

  @override
  String get lockScreenEnterPin => 'Enter PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Too many failed attempts. Try again in $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Set PIN Code';

  @override
  String get pinDialogSetSubtitle => 'Enter a 6-digit PIN to protect SSH Vault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Confirm PIN';

  @override
  String get pinDialogErrorLength => 'PIN must be exactly 6 digits';

  @override
  String get pinDialogErrorMismatch => 'PINs do not match';

  @override
  String get pinDialogVerifyTitle => 'Enter PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Wrong PIN. $attempts attempts remaining.';
  }

  @override
  String get securityBannerMessage =>
      'Your SSH credentials are not protected. Set up a PIN or biometric lock in Settings.';

  @override
  String get securityBannerDismiss => 'Dismiss';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'SSH Defaults';

  @override
  String get settingsSectionSecurity => 'Security';

  @override
  String get settingsSectionExport => 'Export';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsTerminalTheme => 'Terminal Theme';

  @override
  String get settingsTerminalThemeDefault => 'Default Dark';

  @override
  String get settingsFontSize => 'Font Size';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Default Port';

  @override
  String get settingsDefaultPortDialog => 'Default SSH Port';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Default Username';

  @override
  String get settingsDefaultUsernameDialog => 'Default Username';

  @override
  String get settingsUsernameLabel => 'Username';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Auto-Lock Timeout';

  @override
  String get settingsAutoLockDisabled => 'Disabled';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get settingsAutoLockOff => 'Off';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Biometric Unlock';

  @override
  String get settingsBiometricNotAvailable => 'Not available on this device';

  @override
  String get settingsBiometricError => 'Error checking biometrics';

  @override
  String get settingsBiometricReason =>
      'Verify your identity to enable biometric unlock';

  @override
  String get settingsBiometricRequiresPin =>
      'Set a PIN first to enable biometric unlock';

  @override
  String get settingsPinCode => 'PIN Code';

  @override
  String get settingsPinIsSet => 'PIN is set';

  @override
  String get settingsPinNotConfigured => 'No PIN configured';

  @override
  String get settingsPinRemove => 'Remove';

  @override
  String get settingsPinRemoveWarning =>
      'Removing PIN will decrypt all database fields and disable biometric unlock. Continue?';

  @override
  String get settingsPinRemoveTitle => 'Remove PIN';

  @override
  String get settingsPreventScreenshots => 'Prevent Screenshots';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Block screenshots and screen recording';

  @override
  String get settingsEncryptExport => 'Encrypt Exports by Default';

  @override
  String get settingsAbout => 'About SSH Vault';

  @override
  String get settingsAboutLegalese => 'by Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Secure, Self-Hosted SSH Client';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageDe => 'Deutsch';

  @override
  String get settingsLanguageEs => 'Español';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get update => 'Update';

  @override
  String get create => 'Create';

  @override
  String get retry => 'Retry';

  @override
  String get copy => 'Copy';

  @override
  String get edit => 'Edit';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get serverListTitle => 'Hosts';

  @override
  String get serverListEmpty => 'No servers yet';

  @override
  String get serverListEmptySubtitle =>
      'Add your first SSH server to get started.';

  @override
  String get serverAddButton => 'Add Server';

  @override
  String get serverDuplicated => 'Server duplicated';

  @override
  String get serverDeleteTitle => 'Delete Server';

  @override
  String serverDeleteMessage(String name) {
    return 'Are you sure you want to delete \"$name\"? This action cannot be undone.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get serverConnect => 'Connect';

  @override
  String get serverDetails => 'Details';

  @override
  String get serverDuplicate => 'Duplicate';

  @override
  String get serverActive => 'Active';

  @override
  String get serverNoFolder => 'No Folder';

  @override
  String get serverFormTitleEdit => 'Edit Server';

  @override
  String get serverFormTitleAdd => 'Add Server';

  @override
  String get serverFormUpdateButton => 'Update Server';

  @override
  String get serverFormAddButton => 'Add Server';

  @override
  String get serverFormPublicKeyExtracted =>
      'Public key extracted successfully';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Could not extract public key: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type key pair generated';
  }

  @override
  String get serverDetailTitle => 'Server Details';

  @override
  String get serverDetailDeleteMessage => 'This action cannot be undone.';

  @override
  String get serverDetailConnection => 'Connection';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Username';

  @override
  String get serverDetailFolder => 'Folder';

  @override
  String get serverDetailTags => 'Tags';

  @override
  String get serverDetailNotes => 'Notes';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Created';

  @override
  String get serverDetailUpdated => 'Updated';

  @override
  String get serverDetailDistro => 'System';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get serverFormNameLabel => 'Server Name';

  @override
  String get serverFormHostnameLabel => 'Hostname / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Username';

  @override
  String get serverFormPasswordLabel => 'Password';

  @override
  String get serverFormUseManagedKey => 'Use Managed Key';

  @override
  String get serverFormManagedKeySubtitle =>
      'Select from centrally managed SSH keys';

  @override
  String get serverFormDirectKeySubtitle =>
      'Paste key directly into this server';

  @override
  String get serverFormGenerateKey => 'Generate SSH Key Pair';

  @override
  String get serverFormPrivateKeyLabel => 'Private Key';

  @override
  String get serverFormPrivateKeyHint => 'Paste SSH private key...';

  @override
  String get serverFormExtractPublicKey => 'Extract Public Key';

  @override
  String get serverFormPublicKeyLabel => 'Public Key';

  @override
  String get serverFormPublicKeyHint =>
      'Auto-generated from private key if empty';

  @override
  String get serverFormPassphraseLabel => 'Key Passphrase (optional)';

  @override
  String get serverFormNotesLabel => 'Notes (optional)';

  @override
  String get searchServers => 'Search servers...';

  @override
  String get filterAllFolders => 'All Folders';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterInactive => 'Inactive';

  @override
  String get filterClear => 'Clear';

  @override
  String get folderListTitle => 'Folders';

  @override
  String get folderListEmpty => 'No folders yet';

  @override
  String get folderListEmptySubtitle =>
      'Create folders to organize your servers.';

  @override
  String get folderAddButton => 'Add Folder';

  @override
  String get folderDeleteTitle => 'Delete Folder';

  @override
  String folderDeleteMessage(String name) {
    return 'Delete \"$name\"? Servers become unorganized.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servers',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Collapse';

  @override
  String get folderShowHosts => 'Show hosts';

  @override
  String get folderConnectAll => 'Connect All';

  @override
  String get folderFormTitleEdit => 'Edit Folder';

  @override
  String get folderFormTitleNew => 'New Folder';

  @override
  String get folderFormNameLabel => 'Folder Name';

  @override
  String get folderFormParentLabel => 'Parent Folder';

  @override
  String get folderFormParentNone => 'None (Root)';

  @override
  String get tagListTitle => 'Tags';

  @override
  String get tagListEmpty => 'No tags yet';

  @override
  String get tagListEmptySubtitle =>
      'Create tags to label and filter your servers.';

  @override
  String get tagAddButton => 'Add Tag';

  @override
  String get tagDeleteTitle => 'Delete Tag';

  @override
  String tagDeleteMessage(String name) {
    return 'Delete \"$name\"? It will be removed from all servers.';
  }

  @override
  String get tagFormTitleEdit => 'Edit Tag';

  @override
  String get tagFormTitleNew => 'New Tag';

  @override
  String get tagFormNameLabel => 'Tag Name';

  @override
  String get sshKeyListTitle => 'SSH Keys';

  @override
  String get sshKeyListEmpty => 'No SSH keys yet';

  @override
  String get sshKeyListEmptySubtitle =>
      'Generate or import SSH keys to manage them centrally';

  @override
  String get sshKeyCannotDeleteTitle => 'Cannot Delete';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Cannot delete \"$name\". Used by $count server(s). Unlink from all servers first.';
  }

  @override
  String get sshKeyDeleteTitle => 'Delete SSH Key';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get sshKeyAddButton => 'Add SSH Key';

  @override
  String get sshKeyFormTitleEdit => 'Edit SSH Key';

  @override
  String get sshKeyFormTitleAdd => 'Add SSH Key';

  @override
  String get sshKeyFormTabGenerate => 'Generate';

  @override
  String get sshKeyFormTabImport => 'Import';

  @override
  String get sshKeyFormNameLabel => 'Key Name';

  @override
  String get sshKeyFormNameHint => 'e.g. My Production Key';

  @override
  String get sshKeyFormKeyType => 'Key Type';

  @override
  String get sshKeyFormKeySize => 'Key Size';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Comment';

  @override
  String get sshKeyFormCommentHint => 'user@host or description';

  @override
  String get sshKeyFormCommentOptional => 'Comment (optional)';

  @override
  String get sshKeyFormImportFromFile => 'Import from File';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Private Key';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Paste SSH private key or use button above...';

  @override
  String get sshKeyFormPassphraseLabel => 'Passphrase (optional)';

  @override
  String get sshKeyFormNameRequired => 'Name is required';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Private key is required';

  @override
  String get sshKeyFormFileReadError => 'Could not read the selected file';

  @override
  String get sshKeyFormInvalidFormat =>
      'Invalid key file — expected PEM format (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Failed to read file: $message';
  }

  @override
  String get sshKeyFormSaving => 'Saving...';

  @override
  String get sshKeySelectorLabel => 'SSH Key';

  @override
  String get sshKeySelectorNone => 'No managed key';

  @override
  String get sshKeySelectorManage => 'Manage Keys...';

  @override
  String get sshKeySelectorError => 'Failed to load SSH keys';

  @override
  String get sshKeyTileCopyPublicKey => 'Copy public key';

  @override
  String get sshKeyTilePublicKeyCopied => 'Public key copied';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Used by $count server(s)';
  }

  @override
  String get sshKeyTileUnlinkFirst => 'Unlink from all servers first';

  @override
  String get exportImportTitle => 'Export / Import';

  @override
  String get exportSectionTitle => 'Export';

  @override
  String get exportJsonButton => 'Export as JSON (no credentials)';

  @override
  String get exportZipButton => 'Export Encrypted ZIP (with credentials)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Import from File';

  @override
  String get importSupportedFormats =>
      'Supports JSON (plain) and ZIP (encrypted) files.';

  @override
  String exportedTo(String path) {
    return 'Exported to: $path';
  }

  @override
  String get share => 'Share';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Imported $servers servers, $groups groups, $tags tags. $skipped skipped.';
  }

  @override
  String get importPasswordTitle => 'Enter Password';

  @override
  String get importPasswordLabel => 'Export Password';

  @override
  String get importPasswordDecrypt => 'Decrypt';

  @override
  String get exportPasswordTitle => 'Set Export Password';

  @override
  String get exportPasswordDescription =>
      'This password will be used to encrypt your export file including credentials.';

  @override
  String get exportPasswordLabel => 'Password';

  @override
  String get exportPasswordConfirmLabel => 'Confirm Password';

  @override
  String get exportPasswordMismatch => 'Passwords do not match';

  @override
  String get exportPasswordButton => 'Encrypt & Export';

  @override
  String get importConflictTitle => 'Handle Conflicts';

  @override
  String get importConflictDescription =>
      'How should existing entries be handled during import?';

  @override
  String get importConflictSkip => 'Skip Existing';

  @override
  String get importConflictRename => 'Rename New';

  @override
  String get importConflictOverwrite => 'Overwrite';

  @override
  String get confirmDeleteLabel => 'Delete';

  @override
  String get keyGenTitle => 'Generate SSH Key Pair';

  @override
  String get keyGenKeyType => 'Key Type';

  @override
  String get keyGenKeySize => 'Key Size';

  @override
  String get keyGenComment => 'Comment';

  @override
  String get keyGenCommentHint => 'user@host or description';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Generating...';

  @override
  String get keyGenGenerate => 'Generate';

  @override
  String keyGenResultTitle(String type) {
    return '$type Key Generated';
  }

  @override
  String get keyGenPublicKey => 'Public Key';

  @override
  String get keyGenPrivateKey => 'Private Key';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Comment: $comment';
  }

  @override
  String get keyGenAnother => 'Generate Another';

  @override
  String get keyGenUseThisKey => 'Use This Key';

  @override
  String get keyGenCopyTooltip => 'Copy to clipboard';

  @override
  String keyGenCopied(String label) {
    return '$label copied';
  }

  @override
  String get colorPickerLabel => 'Color';

  @override
  String get iconPickerLabel => 'Icon';

  @override
  String get tagSelectorLabel => 'Tags';

  @override
  String get tagSelectorEmpty => 'No tags yet';

  @override
  String get tagSelectorError => 'Failed to load tags';

  @override
  String get snippetListTitle => 'Snippets';

  @override
  String get snippetSearchHint => 'Search snippets...';

  @override
  String get snippetListEmpty => 'No snippets yet';

  @override
  String get snippetListEmptySubtitle =>
      'Create reusable code snippets and commands.';

  @override
  String get snippetAddButton => 'Add Snippet';

  @override
  String get snippetDeleteTitle => 'Delete Snippet';

  @override
  String snippetDeleteMessage(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get snippetFormTitleEdit => 'Edit Snippet';

  @override
  String get snippetFormTitleNew => 'New Snippet';

  @override
  String get snippetFormNameLabel => 'Name';

  @override
  String get snippetFormNameHint => 'e.g. Docker cleanup';

  @override
  String get snippetFormLanguageLabel => 'Language';

  @override
  String get snippetFormContentLabel => 'Content';

  @override
  String get snippetFormContentHint => 'Enter your snippet code...';

  @override
  String get snippetFormDescriptionLabel => 'Description';

  @override
  String get snippetFormDescriptionHint => 'Optional description...';

  @override
  String get snippetFormFolderLabel => 'Folder';

  @override
  String get snippetFormNoFolder => 'No Folder';

  @override
  String get snippetFormNameRequired => 'Name is required';

  @override
  String get snippetFormContentRequired => 'Content is required';

  @override
  String get snippetFormUpdateButton => 'Update Snippet';

  @override
  String get snippetFormCreateButton => 'Create Snippet';

  @override
  String get snippetDetailTitle => 'Snippet Details';

  @override
  String get snippetDetailDeleteTitle => 'Delete Snippet';

  @override
  String get snippetDetailDeleteMessage => 'This action cannot be undone.';

  @override
  String get snippetDetailContent => 'Content';

  @override
  String get snippetDetailFillVariables => 'Fill Variables';

  @override
  String get snippetDetailDescription => 'Description';

  @override
  String get snippetDetailVariables => 'Variables';

  @override
  String get snippetDetailTags => 'Tags';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Created';

  @override
  String get snippetDetailUpdated => 'Updated';

  @override
  String get variableEditorTitle => 'Template Variables';

  @override
  String get variableEditorAdd => 'Add';

  @override
  String get variableEditorEmpty =>
      'No variables. Use curly-brace syntax in content to reference them.';

  @override
  String get variableEditorNameLabel => 'Name';

  @override
  String get variableEditorNameHint => 'e.g. hostname';

  @override
  String get variableEditorDefaultLabel => 'Default';

  @override
  String get variableEditorDefaultHint => 'optional';

  @override
  String get variableFillTitle => 'Fill Variables';

  @override
  String variableFillHint(String name) {
    return 'Enter value for $name';
  }

  @override
  String get variableFillPreview => 'Preview';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'No active sessions';

  @override
  String get terminalEmptySubtitle =>
      'Connect to a host to open a terminal session.';

  @override
  String get terminalGoToHosts => 'Go to Hosts';

  @override
  String get terminalCloseAll => 'Close All Sessions';

  @override
  String get terminalCloseTitle => 'Close Session';

  @override
  String terminalCloseMessage(String title) {
    return 'Close the active connection to \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Authenticating...';

  @override
  String connectionConnecting(String name) {
    return 'Connecting to $name...';
  }

  @override
  String get connectionError => 'Connection Error';

  @override
  String get connectionLost => 'Connection Lost';

  @override
  String get connectionReconnect => 'Reconnect';

  @override
  String get snippetQuickPanelTitle => 'Insert Snippet';

  @override
  String get snippetQuickPanelSearch => 'Search snippets...';

  @override
  String get snippetQuickPanelEmpty => 'No snippets available';

  @override
  String get snippetQuickPanelNoMatch => 'No matching snippets';

  @override
  String get snippetQuickPanelInsertTooltip => 'Insert Snippet';

  @override
  String get terminalThemePickerTitle => 'Terminal Theme';

  @override
  String get validatorHostnameRequired => 'Hostname is required';

  @override
  String get validatorHostnameInvalid => 'Invalid hostname or IP address';

  @override
  String get validatorPortRequired => 'Port is required';

  @override
  String get validatorPortRange => 'Port must be between 1 and 65535';

  @override
  String get validatorUsernameRequired => 'Username is required';

  @override
  String get validatorUsernameInvalid => 'Invalid username format';

  @override
  String get validatorServerNameRequired => 'Server name is required';

  @override
  String get validatorServerNameLength =>
      'Server name must be 100 characters or less';

  @override
  String get validatorSshKeyInvalid => 'Invalid SSH key format';

  @override
  String get validatorPasswordRequired => 'Password is required';

  @override
  String get validatorPasswordLength =>
      'Password must be at least 8 characters';

  @override
  String get authMethodPassword => 'Password';

  @override
  String get authMethodKey => 'SSH Key';

  @override
  String get authMethodBoth => 'Password + Key';

  @override
  String get serverCopySuffix => '(Copy)';

  @override
  String get settingsDownloadLogs => 'Download Logs';

  @override
  String get settingsSendLogs => 'Send Logs to Support';

  @override
  String get settingsLogsSaved => 'Logs saved successfully';

  @override
  String get settingsLogsEmpty => 'No log entries available';

  @override
  String get authLogin => 'Login';

  @override
  String get authRegister => 'Register';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authWhyLogin =>
      'Sign in to enable encrypted cloud sync across all your devices. The app works fully offline without an account.';

  @override
  String authPricingInfo(String price) {
    return 'Cloud sync for all your devices — $price/year';
  }

  @override
  String get authPricingHint =>
      'One subscription, unlimited devices. Cancel anytime.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'Email is required';

  @override
  String get authEmailInvalid => 'Invalid email address';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authPasswordMismatch => 'Passwords do not match';

  @override
  String get authNoAccount => 'No account?';

  @override
  String get authHasAccount => 'Already have an account?';

  @override
  String get authSelfHosted => 'Self-Hosted Server';

  @override
  String get authResetEmailSent =>
      'If an account exists, a reset link has been sent to your email.';

  @override
  String get authResetDescription =>
      'Enter your email address and we will send you a link to reset your password.';

  @override
  String get authSendResetLink => 'Send Reset Link';

  @override
  String get authBackToLogin => 'Back to Login';

  @override
  String get syncPasswordTitle => 'Sync Password';

  @override
  String get syncPasswordTitleCreate => 'Set Sync Password';

  @override
  String get syncPasswordTitleEnter => 'Enter Sync Password';

  @override
  String get syncPasswordDescription =>
      'Set a separate password to encrypt your vault data. This password never leaves your device — the server only stores encrypted data.';

  @override
  String get syncPasswordHintEnter =>
      'Enter the password you set when creating your account.';

  @override
  String get syncPasswordWarning =>
      'If you forget this password, your synced data cannot be recovered. There is no reset option.';

  @override
  String get syncPasswordLabel => 'Sync Password';

  @override
  String get syncPasswordWrong => 'Wrong password. Please try again.';

  @override
  String get firstSyncTitle => 'Existing Data Found';

  @override
  String get firstSyncMessage =>
      'This device has existing data and the server has a vault. How should we proceed?';

  @override
  String get firstSyncMerge => 'Merge (server wins)';

  @override
  String get firstSyncOverwriteLocal => 'Overwrite local data';

  @override
  String get firstSyncKeepLocal => 'Keep local & push';

  @override
  String get firstSyncDeleteLocal => 'Delete local & pull';

  @override
  String get changeEncryptionPassword => 'Change encryption password';

  @override
  String get changeEncryptionWarning =>
      'You will be logged out on all other devices.';

  @override
  String get changeEncryptionOldPassword => 'Current password';

  @override
  String get changeEncryptionNewPassword => 'New password';

  @override
  String get changeEncryptionSuccess => 'Password changed successfully.';

  @override
  String get logoutAllDevices => 'Log out from all devices';

  @override
  String get logoutAllDevicesConfirm =>
      'This will revoke all active sessions. You will need to log in again on all devices.';

  @override
  String get logoutAllDevicesSuccess => 'All devices logged out.';

  @override
  String get syncSettingsTitle => 'Sync Settings';

  @override
  String get syncAutoSync => 'Auto-Sync';

  @override
  String get syncAutoSyncDescription =>
      'Automatically sync when the app starts';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get syncSyncing => 'Syncing...';

  @override
  String get syncSuccess => 'Sync completed';

  @override
  String get syncError => 'Sync error';

  @override
  String get syncServerUnreachable => 'Server not reachable';

  @override
  String get syncServerUnreachableHint =>
      'The sync server could not be reached. Check your internet connection and server URL.';

  @override
  String get syncNetworkError =>
      'Connection to server failed. Please check your internet connection or try again later.';

  @override
  String get syncNeverSynced => 'Never synced';

  @override
  String get syncVaultVersion => 'Vault Version';

  @override
  String get syncTitle => 'Sync';

  @override
  String accountActivateSyncPrice(String price) {
    return 'Activate Sync — $price/year';
  }

  @override
  String get accountStoreFeeNote =>
      'Price on mobile & macOS includes App Store / Play Store fees.';

  @override
  String get accountManageSubscription => 'Manage Subscription & Invoices';

  @override
  String get settingsSectionNetwork => 'Network & DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS Servers';

  @override
  String get settingsDnsDefault => 'Default (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Enter custom DoH server URLs, separated by commas. At least 2 servers are needed for cross-check verification.';

  @override
  String get settingsDnsLabel => 'DoH Server URLs';

  @override
  String get settingsDnsReset => 'Reset to Default';

  @override
  String get settingsSectionSync => 'Synchronization';

  @override
  String get settingsSyncAccount => 'Account';

  @override
  String get settingsSyncNotLoggedIn => 'Not logged in';

  @override
  String get settingsSyncStatus => 'Sync';

  @override
  String get settingsSyncServerUrl => 'Server URL';

  @override
  String get settingsSyncDefaultServer => 'Default (sshvault.app)';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountNotLoggedIn => 'Not logged in';

  @override
  String get accountVerified => 'Verified';

  @override
  String get accountMemberSince => 'Member since';

  @override
  String get accountPaymentStatus => 'Payment';

  @override
  String get accountPaymentActive => 'Sync active (yearly subscription)';

  @override
  String get accountPaymentInactive => 'Sync not yet purchased';

  @override
  String get accountUnlockSync => 'Activate Sync';

  @override
  String get accountDevices => 'Devices';

  @override
  String get accountNoDevices => 'No devices registered';

  @override
  String get accountLastSync => 'Last sync';

  @override
  String get accountChangePassword => 'Change Password';

  @override
  String get accountOldPassword => 'Current Password';

  @override
  String get accountNewPassword => 'New Password';

  @override
  String get accountDeleteAccount => 'Delete Account';

  @override
  String get accountDeleteWarning =>
      'This will permanently delete your account and all synced data. This cannot be undone.';

  @override
  String get accountLogout => 'Log Out';

  @override
  String get serverConfigTitle => 'Server Configuration';

  @override
  String get serverConfigSelfHosted => 'Self-Hosted';

  @override
  String get serverConfigSelfHostedDescription =>
      'Use your own ShellVault server';

  @override
  String get serverConfigUrlLabel => 'Server URL';

  @override
  String get serverConfigTest => 'Test Connection';

  @override
  String get auditLogTitle => 'Activity Log';

  @override
  String get auditLogAll => 'All';

  @override
  String get auditLogEmpty => 'No activity logs found';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'File Manager';

  @override
  String get sftpLocalDevice => 'Local Device';

  @override
  String get sftpSelectServer => 'Select server...';

  @override
  String get sftpConnecting => 'Connecting...';

  @override
  String get sftpEmptyDirectory => 'This directory is empty';

  @override
  String get sftpNoConnection => 'No server connected';

  @override
  String get sftpPathLabel => 'Path';

  @override
  String get sftpUpload => 'Upload';

  @override
  String get sftpDownload => 'Download';

  @override
  String get sftpDelete => 'Delete';

  @override
  String get sftpRename => 'Rename';

  @override
  String get sftpNewFolder => 'New Folder';

  @override
  String get sftpNewFolderName => 'Folder name';

  @override
  String get sftpChmod => 'Permissions';

  @override
  String get sftpChmodTitle => 'Change Permissions';

  @override
  String get sftpChmodOctal => 'Octal';

  @override
  String get sftpChmodOwner => 'Owner';

  @override
  String get sftpChmodGroup => 'Group';

  @override
  String get sftpChmodOther => 'Other';

  @override
  String get sftpChmodRead => 'Read';

  @override
  String get sftpChmodWrite => 'Write';

  @override
  String get sftpChmodExecute => 'Execute';

  @override
  String get sftpCreateSymlink => 'Create Symlink';

  @override
  String get sftpSymlinkTarget => 'Target path';

  @override
  String get sftpSymlinkName => 'Link name';

  @override
  String get sftpFilePreview => 'File Preview';

  @override
  String get sftpFileInfo => 'File Info';

  @override
  String get sftpFileSize => 'Size';

  @override
  String get sftpFileModified => 'Modified';

  @override
  String get sftpFilePermissions => 'Permissions';

  @override
  String get sftpFileOwner => 'Owner';

  @override
  String get sftpFileType => 'Type';

  @override
  String get sftpFileLinkTarget => 'Link target';

  @override
  String get sftpTransfers => 'Transfers';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get sftpTransferQueued => 'Queued';

  @override
  String get sftpTransferActive => 'Transferring...';

  @override
  String get sftpTransferPaused => 'Paused';

  @override
  String get sftpTransferCompleted => 'Completed';

  @override
  String get sftpTransferFailed => 'Failed';

  @override
  String get sftpTransferCancelled => 'Cancelled';

  @override
  String get sftpPauseTransfer => 'Pause';

  @override
  String get sftpResumeTransfer => 'Resume';

  @override
  String get sftpCancelTransfer => 'Cancel';

  @override
  String get sftpClearCompleted => 'Clear completed';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active of $total transfers';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active',
      one: '1 active',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count completed',
      one: '1 completed',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count failed',
      one: '1 failed',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Copy to other pane';

  @override
  String sftpConfirmDelete(int count) {
    return 'Delete $count items?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Deleted successfully';

  @override
  String get sftpRenameTitle => 'Rename';

  @override
  String get sftpRenameLabel => 'New name';

  @override
  String get sftpSortByName => 'Name';

  @override
  String get sftpSortBySize => 'Size';

  @override
  String get sftpSortByDate => 'Date';

  @override
  String get sftpSortByType => 'Type';

  @override
  String get sftpShowHidden => 'Show hidden files';

  @override
  String get sftpHideHidden => 'Hide hidden files';

  @override
  String get sftpSelectAll => 'Select all';

  @override
  String get sftpDeselectAll => 'Deselect all';

  @override
  String sftpItemsSelected(int count) {
    return '$count selected';
  }

  @override
  String get sftpRefresh => 'Refresh';

  @override
  String sftpConnectionError(String message) {
    return 'Connection failed: $message';
  }

  @override
  String get sftpPermissionDenied => 'Permission denied';

  @override
  String sftpOperationFailed(String message) {
    return 'Operation failed: $message';
  }

  @override
  String get sftpOverwriteTitle => 'File already exists';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" already exists. Overwrite?';
  }

  @override
  String get sftpOverwrite => 'Overwrite';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Transfer started: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Select a destination in the other pane first';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Directory transfer coming soon';

  @override
  String get sftpSelect => 'Select';

  @override
  String get sftpOpen => 'Open';

  @override
  String get sftpExtractArchive => 'Extract Here';

  @override
  String get sftpExtractSuccess => 'Archive extracted';

  @override
  String sftpExtractFailed(String message) {
    return 'Extraction failed: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Unsupported archive format';

  @override
  String get sftpExtracting => 'Extracting...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uploads started',
      one: 'Upload started',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads started',
      one: 'Download started',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" downloaded';
  }

  @override
  String get sftpSavedToDownloads => 'Saved to Downloads/ShellVault';

  @override
  String get sftpSaveToFiles => 'Save to Files';

  @override
  String get sftpFileSaved => 'File saved';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH sessions active',
      one: 'SSH session active',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Tap to open terminal';

  @override
  String get settingsAccountAndSync => 'Account & Sync';

  @override
  String get settingsAccountSubtitleAuth => 'Signed in';

  @override
  String get settingsAccountSubtitleUnauth => 'Not signed in';

  @override
  String get settingsSecuritySubtitle => 'Auto-Lock, Biometrics, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, User root';

  @override
  String get settingsAppearanceSubtitle => 'Theme, Language, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Encrypted export defaults';

  @override
  String get settingsAboutSubtitle => 'Version, Licenses';

  @override
  String get settingsSearchHint => 'Search settings...';

  @override
  String get settingsSearchNoResults => 'No settings found';

  @override
  String get aboutDeveloper => 'Developed by Kiefer Networks';

  @override
  String get aboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutTermsOfService => 'Terms of Service';

  @override
  String get aboutOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get aboutWebsite => 'Website';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS encrypts DNS queries and prevents DNS spoofing. ShellVault checks hostnames against multiple providers to detect attacks.';

  @override
  String get settingsDnsAddServer => 'Add DNS Server';

  @override
  String get settingsDnsServerUrl => 'Server URL';

  @override
  String get settingsDnsDefaultBadge => 'Default';

  @override
  String get settingsDnsResetDefaults => 'Reset to Defaults';

  @override
  String get settingsDnsInvalidUrl => 'Please enter a valid HTTPS URL';

  @override
  String get settingsDefaultAuthMethod => 'Authentication Method';

  @override
  String get settingsAuthPassword => 'Password';

  @override
  String get settingsAuthKey => 'SSH Key';

  @override
  String get settingsConnectionTimeout => 'Connection Timeout';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Keep-Alive Interval';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Compression';

  @override
  String get settingsCompressionDescription =>
      'Enable zlib compression for SSH connections';

  @override
  String get settingsTerminalType => 'Terminal Type';

  @override
  String get settingsSectionConnection => 'Connection';

  @override
  String get settingsClipboardAutoClear => 'Clipboard Auto-Clear';

  @override
  String get settingsClipboardAutoClearOff => 'Off';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Session Timeout';

  @override
  String get settingsSessionTimeoutOff => 'Off';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'Duress PIN';

  @override
  String get settingsDuressPinDescription =>
      'A separate PIN that wipes all data when entered';

  @override
  String get settingsDuressPinSet => 'Duress PIN is set';

  @override
  String get settingsDuressPinNotSet => 'Not configured';

  @override
  String get settingsDuressPinWarning =>
      'Entering this PIN will permanently delete all local data including credentials, keys, and settings. This cannot be undone.';

  @override
  String get settingsKeyRotationReminder => 'Key Rotation Reminder';

  @override
  String get settingsKeyRotationOff => 'Off';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days days';
  }

  @override
  String get settingsFailedAttempts => 'Failed PIN Attempts';

  @override
  String get settingsSectionAppLock => 'App Lock';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsSectionReminders => 'Reminders';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle => 'Export, Import & Backup';

  @override
  String get settingsExportJson => 'Export as JSON';

  @override
  String get settingsExportEncrypted => 'Export Encrypted';

  @override
  String get settingsImportFile => 'Import from File';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Filter Servers';

  @override
  String get filterApply => 'Apply Filters';

  @override
  String get filterClearAll => 'Clear All';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filters active',
      one: '1 filter active',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Folder';

  @override
  String get filterTags => 'Tags';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Resolved Preview';

  @override
  String get variableInsert => 'Insert';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servers',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get accountDeleteSubscriptionWarning =>
      'Your subscription must be cancelled manually in the App Store / Play Store. Deleting your account does not automatically cancel mobile subscriptions.';

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions revoked.',
      one: '1 session revoked.',
    );
    return '$_temp0 You have been logged out.';
  }

  @override
  String get keyGenPassphrase => 'Passphrase';

  @override
  String get keyGenPassphraseHint => 'Optional — protects the private key';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Default (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'A key with the same fingerprint already exists: \"$name\". Each SSH key must be unique.';
  }

  @override
  String get sshKeyFingerprint => 'Fingerprint';

  @override
  String get sshKeyPublicKey => 'Public Key';

  @override
  String get jumpHost => 'Jump Host';

  @override
  String get jumpHostNone => 'None';

  @override
  String get jumpHostLabel => 'Connect via jump host';

  @override
  String get jumpHostSelfError => 'A server cannot be its own jump host';

  @override
  String get jumpHostConnecting => 'Connecting to jump host…';

  @override
  String get jumpHostCircularError => 'Circular jump host chain detected';

  @override
  String get logoutDialogTitle => 'Log Out';

  @override
  String get logoutDialogMessage =>
      'Do you want to delete all local data? Servers, SSH keys, snippets, and settings will be removed from this device.';

  @override
  String get logoutOnly => 'Log out only';

  @override
  String get logoutAndDelete => 'Log out & delete data';

  @override
  String get couponTitle => 'Redeem Coupon';

  @override
  String get couponInputLabel => 'Coupon Code';

  @override
  String get couponInputHint => 'Enter your coupon code';

  @override
  String get couponRedeemButton => 'Redeem';

  @override
  String get couponSuccess => 'Coupon redeemed successfully';

  @override
  String subscriptionExpiresOn(String date) {
    return 'Renews on $date';
  }

  @override
  String get changeAvatar => 'Change Avatar';

  @override
  String get removeAvatar => 'Remove Avatar';

  @override
  String get avatarUploadFailed => 'Failed to upload avatar';

  @override
  String get avatarTooLarge => 'Image is too large';

  @override
  String get deviceLastSeen => 'Last seen';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Server URL cannot be changed while logged in. Log out first.';

  @override
  String get serverListNoFolder => 'Uncategorized';

  @override
  String get autoSyncInterval => 'Sync Interval';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Proxy Settings';

  @override
  String get proxyType => 'Proxy Type';

  @override
  String get proxyNone => 'No Proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxy Host';

  @override
  String get proxyPort => 'Proxy Port';

  @override
  String get proxyUsername => 'Proxy Username';

  @override
  String get proxyPassword => 'Proxy Password';

  @override
  String get proxyUseGlobal => 'Use Global Proxy';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Server-specific';

  @override
  String get proxyTestConnection => 'Test Connection';

  @override
  String get proxyTestSuccess => 'Proxy reachable';

  @override
  String get proxyTestFailed => 'Proxy not reachable';

  @override
  String get proxyDefaultProxy => 'Default Proxy';

  @override
  String get vpnRequired => 'VPN Required';

  @override
  String get vpnRequiredTooltip =>
      'Show warning when connecting without active VPN';

  @override
  String get vpnActive => 'VPN Active';

  @override
  String get vpnInactive => 'VPN Inactive';

  @override
  String get vpnWarningTitle => 'VPN Not Active';

  @override
  String get vpnWarningMessage =>
      'This server is marked as requiring a VPN connection, but no VPN is currently active. Do you want to connect anyway?';

  @override
  String get vpnConnectAnyway => 'Connect Anyway';

  @override
  String get postConnectCommands => 'Post-Connect Commands';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Commands executed automatically after connection (one per line)';

  @override
  String get dashboardFavorites => 'Favorites';

  @override
  String get dashboardRecent => 'Recent';

  @override
  String get dashboardActiveSessions => 'Active Sessions';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String get noRecentConnections => 'No recent connections';

  @override
  String get terminalSplit => 'Split View';

  @override
  String get terminalUnsplit => 'Close Split';

  @override
  String get terminalSelectSession => 'Select session for split view';
}
