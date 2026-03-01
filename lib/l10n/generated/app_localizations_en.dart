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
  String get navGroups => 'Groups';

  @override
  String get navTags => 'Tags';

  @override
  String get navSshKeys => 'SSH Keys';

  @override
  String get navExportImport => 'Export / Import';

  @override
  String get navTerminal => 'Terminal';

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
  String get serverNoGroup => 'No Group';

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
  String get serverDetailGroup => 'Group';

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
  String get filterAllGroups => 'All Groups';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterInactive => 'Inactive';

  @override
  String get filterClear => 'Clear';

  @override
  String get groupListTitle => 'Groups';

  @override
  String get groupListEmpty => 'No groups yet';

  @override
  String get groupListEmptySubtitle =>
      'Create groups to organize your servers.';

  @override
  String get groupAddButton => 'Add Group';

  @override
  String get groupDeleteTitle => 'Delete Group';

  @override
  String groupDeleteMessage(String name) {
    return 'Delete \"$name\"? Servers in this group will become ungrouped.';
  }

  @override
  String groupServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servers',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get groupCollapse => 'Collapse';

  @override
  String get groupShowHosts => 'Show hosts';

  @override
  String get groupConnectAll => 'Connect All';

  @override
  String get groupFormTitleEdit => 'Edit Group';

  @override
  String get groupFormTitleNew => 'New Group';

  @override
  String get groupFormNameLabel => 'Group Name';

  @override
  String get groupFormParentLabel => 'Parent Group';

  @override
  String get groupFormParentNone => 'None (Root)';

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
  String get snippetFormGroupLabel => 'Group';

  @override
  String get snippetFormNoGroup => 'No Group';

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
  String get settingsSectionSupport => 'Support';

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
  String get authOrContinueWith => 'or continue with';

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
  String get syncPasswordDescription =>
      'Set a separate password to encrypt your vault data. This password never leaves your device — the server only stores encrypted data.';

  @override
  String get syncPasswordWarning =>
      'If you forget this password, your synced data cannot be recovered. There is no reset option.';

  @override
  String get syncPasswordLabel => 'Sync Password';

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
  String get syncNeverSynced => 'Never synced';

  @override
  String get syncVaultVersion => 'Vault Version';

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
  String get settingsSyncDefaultServer => 'Default (shellvault.app)';

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
  String get accountPaymentActive => 'Sync unlocked (one-time purchase)';

  @override
  String get accountPaymentInactive => 'Sync not yet purchased';

  @override
  String get accountUnlockSync => 'Unlock Sync';

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
  String get donationTitle => 'Support ShellVault';

  @override
  String get donationDescription =>
      'If you enjoy ShellVault, consider making a donation to support development.';

  @override
  String get donationButton => 'Donate';
}
