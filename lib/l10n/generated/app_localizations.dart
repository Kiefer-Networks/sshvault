import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SSHVault'**
  String get appName;

  /// No description provided for @navHosts.
  ///
  /// In en, this message translates to:
  /// **'Hosts'**
  String get navHosts;

  /// No description provided for @navSnippets.
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get navSnippets;

  /// No description provided for @navFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get navFolders;

  /// No description provided for @navTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get navTags;

  /// No description provided for @navSshKeys.
  ///
  /// In en, this message translates to:
  /// **'SSH Keys'**
  String get navSshKeys;

  /// No description provided for @navExportImport.
  ///
  /// In en, this message translates to:
  /// **'Export / Import'**
  String get navExportImport;

  /// No description provided for @navTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get navTerminal;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navManagement.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get navManagement;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @lockScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'SSHVault is locked'**
  String get lockScreenTitle;

  /// No description provided for @lockScreenUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get lockScreenUnlock;

  /// No description provided for @lockScreenEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get lockScreenEnterPin;

  /// No description provided for @lockScreenLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Try again in {minutes} min.'**
  String lockScreenLockedOut(int minutes);

  /// No description provided for @pinDialogSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set PIN Code'**
  String get pinDialogSetTitle;

  /// No description provided for @pinDialogSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a 6-digit PIN to protect SSHVault'**
  String get pinDialogSetSubtitle;

  /// No description provided for @pinDialogLabel.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pinDialogLabel;

  /// No description provided for @pinDialogHint.
  ///
  /// In en, this message translates to:
  /// **'000000'**
  String get pinDialogHint;

  /// No description provided for @pinDialogConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get pinDialogConfirmLabel;

  /// No description provided for @pinDialogErrorLength.
  ///
  /// In en, this message translates to:
  /// **'PIN must be exactly 6 digits'**
  String get pinDialogErrorLength;

  /// No description provided for @pinDialogErrorMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinDialogErrorMismatch;

  /// No description provided for @pinDialogVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get pinDialogVerifyTitle;

  /// No description provided for @pinDialogWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN. {attempts} attempts remaining.'**
  String pinDialogWrongPin(int attempts);

  /// No description provided for @securityBannerMessage.
  ///
  /// In en, this message translates to:
  /// **'Your SSH credentials are not protected. Set up a PIN or biometric lock in Settings.'**
  String get securityBannerMessage;

  /// No description provided for @securityBannerDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get securityBannerDismiss;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get settingsSectionTerminal;

  /// No description provided for @settingsSectionSshDefaults.
  ///
  /// In en, this message translates to:
  /// **'SSH Defaults'**
  String get settingsSectionSshDefaults;

  /// No description provided for @settingsSectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSectionSecurity;

  /// No description provided for @settingsSectionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get settingsSectionExport;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsTerminalTheme.
  ///
  /// In en, this message translates to:
  /// **'Terminal Theme'**
  String get settingsTerminalTheme;

  /// No description provided for @settingsTerminalThemeDefault.
  ///
  /// In en, this message translates to:
  /// **'Default Dark'**
  String get settingsTerminalThemeDefault;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get settingsFontSize;

  /// No description provided for @settingsFontSizeValue.
  ///
  /// In en, this message translates to:
  /// **'{size} px'**
  String settingsFontSizeValue(int size);

  /// No description provided for @settingsDefaultPort.
  ///
  /// In en, this message translates to:
  /// **'Default Port'**
  String get settingsDefaultPort;

  /// No description provided for @settingsDefaultPortDialog.
  ///
  /// In en, this message translates to:
  /// **'Default SSH Port'**
  String get settingsDefaultPortDialog;

  /// No description provided for @settingsPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get settingsPortLabel;

  /// No description provided for @settingsPortHint.
  ///
  /// In en, this message translates to:
  /// **'22'**
  String get settingsPortHint;

  /// No description provided for @settingsDefaultUsername.
  ///
  /// In en, this message translates to:
  /// **'Default Username'**
  String get settingsDefaultUsername;

  /// No description provided for @settingsDefaultUsernameDialog.
  ///
  /// In en, this message translates to:
  /// **'Default Username'**
  String get settingsDefaultUsernameDialog;

  /// No description provided for @settingsUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get settingsUsernameLabel;

  /// No description provided for @settingsUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'root'**
  String get settingsUsernameHint;

  /// No description provided for @settingsAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-Lock Timeout'**
  String get settingsAutoLock;

  /// No description provided for @settingsAutoLockDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsAutoLockDisabled;

  /// No description provided for @settingsAutoLockMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String settingsAutoLockMinutes(int minutes);

  /// No description provided for @settingsAutoLockOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsAutoLockOff;

  /// No description provided for @settingsAutoLock1Min.
  ///
  /// In en, this message translates to:
  /// **'1 min'**
  String get settingsAutoLock1Min;

  /// No description provided for @settingsAutoLock5Min.
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get settingsAutoLock5Min;

  /// No description provided for @settingsAutoLock15Min.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get settingsAutoLock15Min;

  /// No description provided for @settingsAutoLock30Min.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get settingsAutoLock30Min;

  /// No description provided for @settingsBiometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Unlock'**
  String get settingsBiometricUnlock;

  /// No description provided for @settingsBiometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get settingsBiometricNotAvailable;

  /// No description provided for @settingsBiometricError.
  ///
  /// In en, this message translates to:
  /// **'Error checking biometrics'**
  String get settingsBiometricError;

  /// No description provided for @settingsBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to enable biometric unlock'**
  String get settingsBiometricReason;

  /// No description provided for @settingsBiometricRequiresPin.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN first to enable biometric unlock'**
  String get settingsBiometricRequiresPin;

  /// No description provided for @settingsPinCode.
  ///
  /// In en, this message translates to:
  /// **'PIN Code'**
  String get settingsPinCode;

  /// No description provided for @settingsPinIsSet.
  ///
  /// In en, this message translates to:
  /// **'PIN is set'**
  String get settingsPinIsSet;

  /// No description provided for @settingsPinNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'No PIN configured'**
  String get settingsPinNotConfigured;

  /// No description provided for @settingsPinRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get settingsPinRemove;

  /// No description provided for @settingsPinRemoveWarning.
  ///
  /// In en, this message translates to:
  /// **'Removing PIN will decrypt all database fields and disable biometric unlock. Continue?'**
  String get settingsPinRemoveWarning;

  /// No description provided for @settingsPinRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get settingsPinRemoveTitle;

  /// No description provided for @settingsPreventScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Prevent Screenshots'**
  String get settingsPreventScreenshots;

  /// No description provided for @settingsPreventScreenshotsDescription.
  ///
  /// In en, this message translates to:
  /// **'Block screenshots and screen recording'**
  String get settingsPreventScreenshotsDescription;

  /// No description provided for @settingsEncryptExport.
  ///
  /// In en, this message translates to:
  /// **'Encrypt Exports by Default'**
  String get settingsEncryptExport;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About SSHVault'**
  String get settingsAbout;

  /// No description provided for @settingsAboutLegalese.
  ///
  /// In en, this message translates to:
  /// **'by Kiefer Networks'**
  String get settingsAboutLegalese;

  /// No description provided for @settingsAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Secure, Self-Hosted SSH Client'**
  String get settingsAboutDescription;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageDe.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get settingsLanguageDe;

  /// No description provided for @settingsLanguageEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get settingsLanguageEs;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @serverListTitle.
  ///
  /// In en, this message translates to:
  /// **'Hosts'**
  String get serverListTitle;

  /// No description provided for @serverListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No servers yet'**
  String get serverListEmpty;

  /// No description provided for @serverListEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first SSH server to get started.'**
  String get serverListEmptySubtitle;

  /// No description provided for @serverAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get serverAddButton;

  /// No description provided for @serverDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Server duplicated'**
  String get serverDuplicated;

  /// No description provided for @serverDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Server'**
  String get serverDeleteTitle;

  /// No description provided for @serverDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String serverDeleteMessage(String name);

  /// No description provided for @serverDeleteShort.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String serverDeleteShort(String name);

  /// No description provided for @serverConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get serverConnect;

  /// No description provided for @serverDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get serverDetails;

  /// No description provided for @serverDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get serverDuplicate;

  /// No description provided for @serverActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get serverActive;

  /// No description provided for @serverNoFolder.
  ///
  /// In en, this message translates to:
  /// **'No Folder'**
  String get serverNoFolder;

  /// No description provided for @serverFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Server'**
  String get serverFormTitleEdit;

  /// No description provided for @serverFormTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get serverFormTitleAdd;

  /// No description provided for @serverFormUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Server'**
  String get serverFormUpdateButton;

  /// No description provided for @serverFormAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get serverFormAddButton;

  /// No description provided for @serverFormPublicKeyExtracted.
  ///
  /// In en, this message translates to:
  /// **'Public key extracted successfully'**
  String get serverFormPublicKeyExtracted;

  /// No description provided for @serverFormPublicKeyError.
  ///
  /// In en, this message translates to:
  /// **'Could not extract public key: {message}'**
  String serverFormPublicKeyError(String message);

  /// No description provided for @serverFormKeyGenerated.
  ///
  /// In en, this message translates to:
  /// **'{type} key pair generated'**
  String serverFormKeyGenerated(String type);

  /// No description provided for @serverDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Details'**
  String get serverDetailTitle;

  /// No description provided for @serverDetailDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get serverDetailDeleteMessage;

  /// No description provided for @serverDetailConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get serverDetailConnection;

  /// No description provided for @serverDetailHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get serverDetailHost;

  /// No description provided for @serverDetailPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get serverDetailPort;

  /// No description provided for @serverDetailUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get serverDetailUsername;

  /// No description provided for @serverDetailFolder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get serverDetailFolder;

  /// No description provided for @serverDetailTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get serverDetailTags;

  /// No description provided for @serverDetailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get serverDetailNotes;

  /// No description provided for @serverDetailInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get serverDetailInfo;

  /// No description provided for @serverDetailCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get serverDetailCreated;

  /// No description provided for @serverDetailUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get serverDetailUpdated;

  /// No description provided for @serverDetailDistro.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get serverDetailDistro;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @serverFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Server Name'**
  String get serverFormNameLabel;

  /// No description provided for @serverFormHostnameLabel.
  ///
  /// In en, this message translates to:
  /// **'Hostname / IP'**
  String get serverFormHostnameLabel;

  /// No description provided for @serverFormPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get serverFormPortLabel;

  /// No description provided for @serverFormUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get serverFormUsernameLabel;

  /// No description provided for @serverFormPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get serverFormPasswordLabel;

  /// No description provided for @serverFormUseManagedKey.
  ///
  /// In en, this message translates to:
  /// **'Use Managed Key'**
  String get serverFormUseManagedKey;

  /// No description provided for @serverFormManagedKeySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select from centrally managed SSH keys'**
  String get serverFormManagedKeySubtitle;

  /// No description provided for @serverFormDirectKeySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Paste key directly into this server'**
  String get serverFormDirectKeySubtitle;

  /// No description provided for @serverFormGenerateKey.
  ///
  /// In en, this message translates to:
  /// **'Generate SSH Key Pair'**
  String get serverFormGenerateKey;

  /// No description provided for @serverFormPrivateKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get serverFormPrivateKeyLabel;

  /// No description provided for @serverFormPrivateKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Paste SSH private key...'**
  String get serverFormPrivateKeyHint;

  /// No description provided for @serverFormExtractPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Extract Public Key'**
  String get serverFormExtractPublicKey;

  /// No description provided for @serverFormPublicKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get serverFormPublicKeyLabel;

  /// No description provided for @serverFormPublicKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Auto-generated from private key if empty'**
  String get serverFormPublicKeyHint;

  /// No description provided for @serverFormPassphraseLabel.
  ///
  /// In en, this message translates to:
  /// **'Key Passphrase (optional)'**
  String get serverFormPassphraseLabel;

  /// No description provided for @serverFormNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get serverFormNotesLabel;

  /// No description provided for @searchServers.
  ///
  /// In en, this message translates to:
  /// **'Search servers...'**
  String get searchServers;

  /// No description provided for @filterAllFolders.
  ///
  /// In en, this message translates to:
  /// **'All Folders'**
  String get filterAllFolders;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @filterInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get filterInactive;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get filterClear;

  /// No description provided for @folderListTitle.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folderListTitle;

  /// No description provided for @folderListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No folders yet'**
  String get folderListEmpty;

  /// No description provided for @folderListEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create folders to organize your servers.'**
  String get folderListEmptySubtitle;

  /// No description provided for @folderAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Folder'**
  String get folderAddButton;

  /// No description provided for @folderDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder'**
  String get folderDeleteTitle;

  /// No description provided for @folderDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? Servers become unorganized.'**
  String folderDeleteMessage(String name);

  /// No description provided for @folderServerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 server} other{{count} servers}}'**
  String folderServerCount(int count);

  /// No description provided for @folderCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get folderCollapse;

  /// No description provided for @folderShowHosts.
  ///
  /// In en, this message translates to:
  /// **'Show hosts'**
  String get folderShowHosts;

  /// No description provided for @folderConnectAll.
  ///
  /// In en, this message translates to:
  /// **'Connect All'**
  String get folderConnectAll;

  /// No description provided for @folderFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Folder'**
  String get folderFormTitleEdit;

  /// No description provided for @folderFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get folderFormTitleNew;

  /// No description provided for @folderFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get folderFormNameLabel;

  /// No description provided for @folderFormParentLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent Folder'**
  String get folderFormParentLabel;

  /// No description provided for @folderFormParentNone.
  ///
  /// In en, this message translates to:
  /// **'None (Root)'**
  String get folderFormParentNone;

  /// No description provided for @tagListTitle.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagListTitle;

  /// No description provided for @tagListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tags yet'**
  String get tagListEmpty;

  /// No description provided for @tagListEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create tags to label and filter your servers.'**
  String get tagListEmptySubtitle;

  /// No description provided for @tagAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Tag'**
  String get tagAddButton;

  /// No description provided for @tagDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Tag'**
  String get tagDeleteTitle;

  /// No description provided for @tagDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? It will be removed from all servers.'**
  String tagDeleteMessage(String name);

  /// No description provided for @tagFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Tag'**
  String get tagFormTitleEdit;

  /// No description provided for @tagFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Tag'**
  String get tagFormTitleNew;

  /// No description provided for @tagFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Tag Name'**
  String get tagFormNameLabel;

  /// No description provided for @sshKeyListTitle.
  ///
  /// In en, this message translates to:
  /// **'SSH Keys'**
  String get sshKeyListTitle;

  /// No description provided for @sshKeyListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No SSH keys yet'**
  String get sshKeyListEmpty;

  /// No description provided for @sshKeyListEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate or import SSH keys to manage them centrally'**
  String get sshKeyListEmptySubtitle;

  /// No description provided for @sshKeyCannotDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot Delete'**
  String get sshKeyCannotDeleteTitle;

  /// No description provided for @sshKeyCannotDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete \"{name}\". Used by {count} server(s). Unlink from all servers first.'**
  String sshKeyCannotDeleteMessage(String name, int count);

  /// No description provided for @sshKeyDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete SSH Key'**
  String get sshKeyDeleteTitle;

  /// No description provided for @sshKeyDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String sshKeyDeleteMessage(String name);

  /// No description provided for @sshKeyAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add SSH Key'**
  String get sshKeyAddButton;

  /// No description provided for @sshKeyFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit SSH Key'**
  String get sshKeyFormTitleEdit;

  /// No description provided for @sshKeyFormTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add SSH Key'**
  String get sshKeyFormTitleAdd;

  /// No description provided for @sshKeyFormTabGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get sshKeyFormTabGenerate;

  /// No description provided for @sshKeyFormTabImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get sshKeyFormTabImport;

  /// No description provided for @sshKeyFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Key Name'**
  String get sshKeyFormNameLabel;

  /// No description provided for @sshKeyFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My Production Key'**
  String get sshKeyFormNameHint;

  /// No description provided for @sshKeyFormKeyType.
  ///
  /// In en, this message translates to:
  /// **'Key Type'**
  String get sshKeyFormKeyType;

  /// No description provided for @sshKeyFormKeySize.
  ///
  /// In en, this message translates to:
  /// **'Key Size'**
  String get sshKeyFormKeySize;

  /// No description provided for @sshKeyFormKeySizeBit.
  ///
  /// In en, this message translates to:
  /// **'{bits} bit'**
  String sshKeyFormKeySizeBit(int bits);

  /// No description provided for @sshKeyFormCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get sshKeyFormCommentLabel;

  /// No description provided for @sshKeyFormCommentHint.
  ///
  /// In en, this message translates to:
  /// **'user@host or description'**
  String get sshKeyFormCommentHint;

  /// No description provided for @sshKeyFormCommentOptional.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get sshKeyFormCommentOptional;

  /// No description provided for @sshKeyFormImportFromFile.
  ///
  /// In en, this message translates to:
  /// **'Import from File'**
  String get sshKeyFormImportFromFile;

  /// No description provided for @sshKeyFormPrivateKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get sshKeyFormPrivateKeyLabel;

  /// No description provided for @sshKeyFormPrivateKeyHint.
  ///
  /// In en, this message translates to:
  /// **'Paste SSH private key or use button above...'**
  String get sshKeyFormPrivateKeyHint;

  /// No description provided for @sshKeyFormPassphraseLabel.
  ///
  /// In en, this message translates to:
  /// **'Passphrase (optional)'**
  String get sshKeyFormPassphraseLabel;

  /// No description provided for @sshKeyFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get sshKeyFormNameRequired;

  /// No description provided for @sshKeyFormPrivateKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Private key is required'**
  String get sshKeyFormPrivateKeyRequired;

  /// No description provided for @sshKeyFormFileReadError.
  ///
  /// In en, this message translates to:
  /// **'Could not read the selected file'**
  String get sshKeyFormFileReadError;

  /// No description provided for @sshKeyFormInvalidFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid key file — expected PEM format (-----BEGIN ...)'**
  String get sshKeyFormInvalidFormat;

  /// No description provided for @sshKeyFormFileError.
  ///
  /// In en, this message translates to:
  /// **'Failed to read file: {message}'**
  String sshKeyFormFileError(String message);

  /// No description provided for @sshKeyFormSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get sshKeyFormSaving;

  /// No description provided for @sshKeySelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'SSH Key'**
  String get sshKeySelectorLabel;

  /// No description provided for @sshKeySelectorNone.
  ///
  /// In en, this message translates to:
  /// **'No managed key'**
  String get sshKeySelectorNone;

  /// No description provided for @sshKeySelectorManage.
  ///
  /// In en, this message translates to:
  /// **'Manage Keys...'**
  String get sshKeySelectorManage;

  /// No description provided for @sshKeySelectorError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load SSH keys'**
  String get sshKeySelectorError;

  /// No description provided for @sshKeyTileCopyPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Copy public key'**
  String get sshKeyTileCopyPublicKey;

  /// No description provided for @sshKeyTilePublicKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'Public key copied'**
  String get sshKeyTilePublicKeyCopied;

  /// No description provided for @sshKeyTileLinkedServers.
  ///
  /// In en, this message translates to:
  /// **'Used by {count} server(s)'**
  String sshKeyTileLinkedServers(int count);

  /// No description provided for @sshKeyTileUnlinkFirst.
  ///
  /// In en, this message translates to:
  /// **'Unlink from all servers first'**
  String get sshKeyTileUnlinkFirst;

  /// No description provided for @exportImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export / Import'**
  String get exportImportTitle;

  /// No description provided for @exportSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportSectionTitle;

  /// No description provided for @exportJsonButton.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON (no credentials)'**
  String get exportJsonButton;

  /// No description provided for @exportZipButton.
  ///
  /// In en, this message translates to:
  /// **'Export Encrypted ZIP (with credentials)'**
  String get exportZipButton;

  /// No description provided for @importSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importSectionTitle;

  /// No description provided for @importButton.
  ///
  /// In en, this message translates to:
  /// **'Import from File'**
  String get importButton;

  /// No description provided for @importSupportedFormats.
  ///
  /// In en, this message translates to:
  /// **'Supports JSON (plain) and ZIP (encrypted) files.'**
  String get importSupportedFormats;

  /// No description provided for @exportedTo.
  ///
  /// In en, this message translates to:
  /// **'Exported to: {path}'**
  String exportedTo(String path);

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @importResult.
  ///
  /// In en, this message translates to:
  /// **'Imported {servers} servers, {groups} groups, {tags} tags. {skipped} skipped.'**
  String importResult(int servers, int groups, int tags, int skipped);

  /// No description provided for @importPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get importPasswordTitle;

  /// No description provided for @importPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Export Password'**
  String get importPasswordLabel;

  /// No description provided for @importPasswordDecrypt.
  ///
  /// In en, this message translates to:
  /// **'Decrypt'**
  String get importPasswordDecrypt;

  /// No description provided for @exportPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Export Password'**
  String get exportPasswordTitle;

  /// No description provided for @exportPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'This password will be used to encrypt your export file including credentials.'**
  String get exportPasswordDescription;

  /// No description provided for @exportPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get exportPasswordLabel;

  /// No description provided for @exportPasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get exportPasswordConfirmLabel;

  /// No description provided for @exportPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get exportPasswordMismatch;

  /// No description provided for @exportPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Encrypt & Export'**
  String get exportPasswordButton;

  /// No description provided for @importConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Handle Conflicts'**
  String get importConflictTitle;

  /// No description provided for @importConflictDescription.
  ///
  /// In en, this message translates to:
  /// **'How should existing entries be handled during import?'**
  String get importConflictDescription;

  /// No description provided for @importConflictSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip Existing'**
  String get importConflictSkip;

  /// No description provided for @importConflictRename.
  ///
  /// In en, this message translates to:
  /// **'Rename New'**
  String get importConflictRename;

  /// No description provided for @importConflictOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get importConflictOverwrite;

  /// No description provided for @confirmDeleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get confirmDeleteLabel;

  /// No description provided for @keyGenTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate SSH Key Pair'**
  String get keyGenTitle;

  /// No description provided for @keyGenKeyType.
  ///
  /// In en, this message translates to:
  /// **'Key Type'**
  String get keyGenKeyType;

  /// No description provided for @keyGenKeySize.
  ///
  /// In en, this message translates to:
  /// **'Key Size'**
  String get keyGenKeySize;

  /// No description provided for @keyGenComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get keyGenComment;

  /// No description provided for @keyGenCommentHint.
  ///
  /// In en, this message translates to:
  /// **'user@host or description'**
  String get keyGenCommentHint;

  /// No description provided for @keyGenKeySizeBit.
  ///
  /// In en, this message translates to:
  /// **'{bits} bit'**
  String keyGenKeySizeBit(int bits);

  /// No description provided for @keyGenGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get keyGenGenerating;

  /// No description provided for @keyGenGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get keyGenGenerate;

  /// No description provided for @keyGenResultTitle.
  ///
  /// In en, this message translates to:
  /// **'{type} Key Generated'**
  String keyGenResultTitle(String type);

  /// No description provided for @keyGenPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get keyGenPublicKey;

  /// No description provided for @keyGenPrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get keyGenPrivateKey;

  /// No description provided for @keyGenCommentInfo.
  ///
  /// In en, this message translates to:
  /// **'Comment: {comment}'**
  String keyGenCommentInfo(String comment);

  /// No description provided for @keyGenAnother.
  ///
  /// In en, this message translates to:
  /// **'Generate Another'**
  String get keyGenAnother;

  /// No description provided for @keyGenUseThisKey.
  ///
  /// In en, this message translates to:
  /// **'Use This Key'**
  String get keyGenUseThisKey;

  /// No description provided for @keyGenCopyTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get keyGenCopyTooltip;

  /// No description provided for @keyGenCopied.
  ///
  /// In en, this message translates to:
  /// **'{label} copied'**
  String keyGenCopied(String label);

  /// No description provided for @colorPickerLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorPickerLabel;

  /// No description provided for @iconPickerLabel.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get iconPickerLabel;

  /// No description provided for @tagSelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagSelectorLabel;

  /// No description provided for @tagSelectorEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tags yet'**
  String get tagSelectorEmpty;

  /// No description provided for @tagSelectorError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tags'**
  String get tagSelectorError;

  /// No description provided for @snippetListTitle.
  ///
  /// In en, this message translates to:
  /// **'Snippets'**
  String get snippetListTitle;

  /// No description provided for @snippetSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search snippets...'**
  String get snippetSearchHint;

  /// No description provided for @snippetListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No snippets yet'**
  String get snippetListEmpty;

  /// No description provided for @snippetListEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create reusable code snippets and commands.'**
  String get snippetListEmptySubtitle;

  /// No description provided for @snippetAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Snippet'**
  String get snippetAddButton;

  /// No description provided for @snippetDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Snippet'**
  String get snippetDeleteTitle;

  /// No description provided for @snippetDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This cannot be undone.'**
  String snippetDeleteMessage(String name);

  /// No description provided for @snippetFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Snippet'**
  String get snippetFormTitleEdit;

  /// No description provided for @snippetFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Snippet'**
  String get snippetFormTitleNew;

  /// No description provided for @snippetFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get snippetFormNameLabel;

  /// No description provided for @snippetFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Docker cleanup'**
  String get snippetFormNameHint;

  /// No description provided for @snippetFormLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get snippetFormLanguageLabel;

  /// No description provided for @snippetFormContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get snippetFormContentLabel;

  /// No description provided for @snippetFormContentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your snippet code...'**
  String get snippetFormContentHint;

  /// No description provided for @snippetFormDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get snippetFormDescriptionLabel;

  /// No description provided for @snippetFormDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional description...'**
  String get snippetFormDescriptionHint;

  /// No description provided for @snippetFormFolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get snippetFormFolderLabel;

  /// No description provided for @snippetFormNoFolder.
  ///
  /// In en, this message translates to:
  /// **'No Folder'**
  String get snippetFormNoFolder;

  /// No description provided for @snippetFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get snippetFormNameRequired;

  /// No description provided for @snippetFormContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Content is required'**
  String get snippetFormContentRequired;

  /// No description provided for @snippetFormUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Snippet'**
  String get snippetFormUpdateButton;

  /// No description provided for @snippetFormCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Snippet'**
  String get snippetFormCreateButton;

  /// No description provided for @snippetDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Snippet Details'**
  String get snippetDetailTitle;

  /// No description provided for @snippetDetailDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Snippet'**
  String get snippetDetailDeleteTitle;

  /// No description provided for @snippetDetailDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get snippetDetailDeleteMessage;

  /// No description provided for @snippetDetailContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get snippetDetailContent;

  /// No description provided for @snippetDetailFillVariables.
  ///
  /// In en, this message translates to:
  /// **'Fill Variables'**
  String get snippetDetailFillVariables;

  /// No description provided for @snippetDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get snippetDetailDescription;

  /// No description provided for @snippetDetailVariables.
  ///
  /// In en, this message translates to:
  /// **'Variables'**
  String get snippetDetailVariables;

  /// No description provided for @snippetDetailTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get snippetDetailTags;

  /// No description provided for @snippetDetailInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get snippetDetailInfo;

  /// No description provided for @snippetDetailCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get snippetDetailCreated;

  /// No description provided for @snippetDetailUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get snippetDetailUpdated;

  /// No description provided for @variableEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Template Variables'**
  String get variableEditorTitle;

  /// No description provided for @variableEditorAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get variableEditorAdd;

  /// No description provided for @variableEditorEmpty.
  ///
  /// In en, this message translates to:
  /// **'No variables. Use curly-brace syntax in content to reference them.'**
  String get variableEditorEmpty;

  /// No description provided for @variableEditorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get variableEditorNameLabel;

  /// No description provided for @variableEditorNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. hostname'**
  String get variableEditorNameHint;

  /// No description provided for @variableEditorDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get variableEditorDefaultLabel;

  /// No description provided for @variableEditorDefaultHint.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get variableEditorDefaultHint;

  /// No description provided for @variableFillTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill Variables'**
  String get variableFillTitle;

  /// No description provided for @variableFillHint.
  ///
  /// In en, this message translates to:
  /// **'Enter value for {name}'**
  String variableFillHint(String name);

  /// No description provided for @variableFillPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get variableFillPreview;

  /// No description provided for @terminalTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get terminalTitle;

  /// No description provided for @terminalEmpty.
  ///
  /// In en, this message translates to:
  /// **'No active sessions'**
  String get terminalEmpty;

  /// No description provided for @terminalEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to a host to open a terminal session.'**
  String get terminalEmptySubtitle;

  /// No description provided for @terminalGoToHosts.
  ///
  /// In en, this message translates to:
  /// **'Go to Hosts'**
  String get terminalGoToHosts;

  /// No description provided for @terminalCloseAll.
  ///
  /// In en, this message translates to:
  /// **'Close All Sessions'**
  String get terminalCloseAll;

  /// No description provided for @terminalCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close Session'**
  String get terminalCloseTitle;

  /// No description provided for @terminalCloseMessage.
  ///
  /// In en, this message translates to:
  /// **'Close the active connection to \"{title}\"?'**
  String terminalCloseMessage(String title);

  /// No description provided for @connectionAuthenticating.
  ///
  /// In en, this message translates to:
  /// **'Authenticating...'**
  String get connectionAuthenticating;

  /// No description provided for @connectionConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {name}...'**
  String connectionConnecting(String name);

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @connectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get connectionLost;

  /// No description provided for @connectionReconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get connectionReconnect;

  /// No description provided for @snippetQuickPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Insert Snippet'**
  String get snippetQuickPanelTitle;

  /// No description provided for @snippetQuickPanelSearch.
  ///
  /// In en, this message translates to:
  /// **'Search snippets...'**
  String get snippetQuickPanelSearch;

  /// No description provided for @snippetQuickPanelEmpty.
  ///
  /// In en, this message translates to:
  /// **'No snippets available'**
  String get snippetQuickPanelEmpty;

  /// No description provided for @snippetQuickPanelNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No matching snippets'**
  String get snippetQuickPanelNoMatch;

  /// No description provided for @snippetQuickPanelInsertTooltip.
  ///
  /// In en, this message translates to:
  /// **'Insert Snippet'**
  String get snippetQuickPanelInsertTooltip;

  /// No description provided for @terminalThemePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal Theme'**
  String get terminalThemePickerTitle;

  /// No description provided for @validatorHostnameRequired.
  ///
  /// In en, this message translates to:
  /// **'Hostname is required'**
  String get validatorHostnameRequired;

  /// No description provided for @validatorHostnameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid hostname or IP address'**
  String get validatorHostnameInvalid;

  /// No description provided for @validatorPortRequired.
  ///
  /// In en, this message translates to:
  /// **'Port is required'**
  String get validatorPortRequired;

  /// No description provided for @validatorPortRange.
  ///
  /// In en, this message translates to:
  /// **'Port must be between 1 and 65535'**
  String get validatorPortRange;

  /// No description provided for @validatorUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get validatorUsernameRequired;

  /// No description provided for @validatorUsernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid username format'**
  String get validatorUsernameInvalid;

  /// No description provided for @validatorServerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Server name is required'**
  String get validatorServerNameRequired;

  /// No description provided for @validatorServerNameLength.
  ///
  /// In en, this message translates to:
  /// **'Server name must be 100 characters or less'**
  String get validatorServerNameLength;

  /// No description provided for @validatorSshKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid SSH key format'**
  String get validatorSshKeyInvalid;

  /// No description provided for @validatorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validatorPasswordRequired;

  /// No description provided for @validatorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validatorPasswordLength;

  /// No description provided for @authMethodPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authMethodPassword;

  /// No description provided for @authMethodKey.
  ///
  /// In en, this message translates to:
  /// **'SSH Key'**
  String get authMethodKey;

  /// No description provided for @authMethodBoth.
  ///
  /// In en, this message translates to:
  /// **'Password + Key'**
  String get authMethodBoth;

  /// No description provided for @serverCopySuffix.
  ///
  /// In en, this message translates to:
  /// **'(Copy)'**
  String get serverCopySuffix;

  /// No description provided for @settingsDownloadLogs.
  ///
  /// In en, this message translates to:
  /// **'Download Logs'**
  String get settingsDownloadLogs;

  /// No description provided for @settingsSendLogs.
  ///
  /// In en, this message translates to:
  /// **'Send Logs to Support'**
  String get settingsSendLogs;

  /// No description provided for @settingsLogsSaved.
  ///
  /// In en, this message translates to:
  /// **'Logs saved successfully'**
  String get settingsLogsSaved;

  /// No description provided for @settingsLogsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No log entries available'**
  String get settingsLogsEmpty;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegister;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPassword;

  /// No description provided for @authWhyLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in to enable encrypted cloud sync across all your devices. The app works fully offline without an account.'**
  String get authWhyLogin;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authEmailRequired;

  /// No description provided for @authEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get authEmailInvalid;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordMismatch;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account?'**
  String get authNoAccount;

  /// No description provided for @authHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHasAccount;

  /// No description provided for @authSelfHosted.
  ///
  /// In en, this message translates to:
  /// **'Self-Hosted Server'**
  String get authSelfHosted;

  /// No description provided for @authResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, a reset link has been sent to your email.'**
  String get authResetEmailSent;

  /// No description provided for @authResetDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get authResetDescription;

  /// No description provided for @authSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLink;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get authBackToLogin;

  /// No description provided for @syncPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Password'**
  String get syncPasswordTitle;

  /// No description provided for @syncPasswordTitleCreate.
  ///
  /// In en, this message translates to:
  /// **'Set Sync Password'**
  String get syncPasswordTitleCreate;

  /// No description provided for @syncPasswordTitleEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter Sync Password'**
  String get syncPasswordTitleEnter;

  /// No description provided for @syncPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a separate password to encrypt your vault data. This password never leaves your device — the server only stores encrypted data.'**
  String get syncPasswordDescription;

  /// No description provided for @syncPasswordHintEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter the password you set when creating your account.'**
  String get syncPasswordHintEnter;

  /// No description provided for @syncPasswordWarning.
  ///
  /// In en, this message translates to:
  /// **'If you forget this password, your synced data cannot be recovered. There is no reset option.'**
  String get syncPasswordWarning;

  /// No description provided for @syncPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Sync Password'**
  String get syncPasswordLabel;

  /// No description provided for @syncPasswordWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong password. Please try again.'**
  String get syncPasswordWrong;

  /// No description provided for @firstSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Existing Data Found'**
  String get firstSyncTitle;

  /// No description provided for @firstSyncMessage.
  ///
  /// In en, this message translates to:
  /// **'This device has existing data and the server has a vault. How should we proceed?'**
  String get firstSyncMessage;

  /// No description provided for @firstSyncMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge (server wins)'**
  String get firstSyncMerge;

  /// No description provided for @firstSyncOverwriteLocal.
  ///
  /// In en, this message translates to:
  /// **'Overwrite local data'**
  String get firstSyncOverwriteLocal;

  /// No description provided for @firstSyncKeepLocal.
  ///
  /// In en, this message translates to:
  /// **'Keep local & push'**
  String get firstSyncKeepLocal;

  /// No description provided for @firstSyncDeleteLocal.
  ///
  /// In en, this message translates to:
  /// **'Delete local & pull'**
  String get firstSyncDeleteLocal;

  /// No description provided for @changeEncryptionPassword.
  ///
  /// In en, this message translates to:
  /// **'Change encryption password'**
  String get changeEncryptionPassword;

  /// No description provided for @changeEncryptionWarning.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out on all other devices.'**
  String get changeEncryptionWarning;

  /// No description provided for @changeEncryptionOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get changeEncryptionOldPassword;

  /// No description provided for @changeEncryptionNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get changeEncryptionNewPassword;

  /// No description provided for @changeEncryptionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully.'**
  String get changeEncryptionSuccess;

  /// No description provided for @logoutAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Log out from all devices'**
  String get logoutAllDevices;

  /// No description provided for @logoutAllDevicesConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will revoke all active sessions. You will need to log in again on all devices.'**
  String get logoutAllDevicesConfirm;

  /// No description provided for @logoutAllDevicesSuccess.
  ///
  /// In en, this message translates to:
  /// **'All devices logged out.'**
  String get logoutAllDevicesSuccess;

  /// No description provided for @syncSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Settings'**
  String get syncSettingsTitle;

  /// No description provided for @syncAutoSync.
  ///
  /// In en, this message translates to:
  /// **'Auto-Sync'**
  String get syncAutoSync;

  /// No description provided for @syncAutoSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically sync when the app starts'**
  String get syncAutoSyncDescription;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @syncSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncSyncing;

  /// No description provided for @syncSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync completed'**
  String get syncSuccess;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error'**
  String get syncError;

  /// No description provided for @syncServerUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Server not reachable'**
  String get syncServerUnreachable;

  /// No description provided for @syncServerUnreachableHint.
  ///
  /// In en, this message translates to:
  /// **'The sync server could not be reached. Check your internet connection and server URL.'**
  String get syncServerUnreachableHint;

  /// No description provided for @syncNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Connection to server failed. Please check your internet connection or try again later.'**
  String get syncNetworkError;

  /// No description provided for @syncNeverSynced.
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get syncNeverSynced;

  /// No description provided for @syncVaultVersion.
  ///
  /// In en, this message translates to:
  /// **'Vault Version'**
  String get syncVaultVersion;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncTitle;

  /// No description provided for @settingsSectionNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network & DNS'**
  String get settingsSectionNetwork;

  /// No description provided for @settingsDnsServers.
  ///
  /// In en, this message translates to:
  /// **'DNS-over-HTTPS Servers'**
  String get settingsDnsServers;

  /// No description provided for @settingsDnsDefault.
  ///
  /// In en, this message translates to:
  /// **'Default (Quad9 + Mullvad)'**
  String get settingsDnsDefault;

  /// No description provided for @settingsDnsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter custom DoH server URLs, separated by commas. At least 2 servers are needed for cross-check verification.'**
  String get settingsDnsHint;

  /// No description provided for @settingsDnsLabel.
  ///
  /// In en, this message translates to:
  /// **'DoH Server URLs'**
  String get settingsDnsLabel;

  /// No description provided for @settingsDnsReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get settingsDnsReset;

  /// No description provided for @settingsSectionSync.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get settingsSectionSync;

  /// No description provided for @settingsSyncAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSyncAccount;

  /// No description provided for @settingsSyncNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get settingsSyncNotLoggedIn;

  /// No description provided for @settingsSyncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get settingsSyncStatus;

  /// No description provided for @settingsSyncServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get settingsSyncServerUrl;

  /// No description provided for @settingsSyncDefaultServer.
  ///
  /// In en, this message translates to:
  /// **'Default (sshvault.app)'**
  String get settingsSyncDefaultServer;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @accountNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get accountNotLoggedIn;

  /// No description provided for @accountVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get accountVerified;

  /// No description provided for @accountMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get accountMemberSince;

  /// No description provided for @accountDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get accountDevices;

  /// No description provided for @accountNoDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices registered'**
  String get accountNoDevices;

  /// No description provided for @accountLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get accountLastSync;

  /// No description provided for @accountChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountChangePassword;

  /// No description provided for @accountOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get accountOldPassword;

  /// No description provided for @accountNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get accountNewPassword;

  /// No description provided for @accountDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountDeleteAccount;

  /// No description provided for @accountDeleteWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all synced data. This cannot be undone.'**
  String get accountDeleteWarning;

  /// No description provided for @accountLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get accountLogout;

  /// No description provided for @serverConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Configuration'**
  String get serverConfigTitle;

  /// No description provided for @serverConfigSelfHosted.
  ///
  /// In en, this message translates to:
  /// **'Self-Hosted'**
  String get serverConfigSelfHosted;

  /// No description provided for @serverConfigSelfHostedDescription.
  ///
  /// In en, this message translates to:
  /// **'Use your own SSHVault server'**
  String get serverConfigSelfHostedDescription;

  /// No description provided for @serverConfigUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverConfigUrlLabel;

  /// No description provided for @serverConfigTest.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get serverConfigTest;

  /// No description provided for @auditLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get auditLogTitle;

  /// No description provided for @auditLogAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get auditLogAll;

  /// No description provided for @auditLogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activity logs found'**
  String get auditLogEmpty;

  /// No description provided for @navSftp.
  ///
  /// In en, this message translates to:
  /// **'SFTP'**
  String get navSftp;

  /// No description provided for @sftpTitle.
  ///
  /// In en, this message translates to:
  /// **'File Manager'**
  String get sftpTitle;

  /// No description provided for @sftpLocalDevice.
  ///
  /// In en, this message translates to:
  /// **'Local Device'**
  String get sftpLocalDevice;

  /// No description provided for @sftpSelectServer.
  ///
  /// In en, this message translates to:
  /// **'Select server...'**
  String get sftpSelectServer;

  /// No description provided for @sftpConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get sftpConnecting;

  /// No description provided for @sftpEmptyDirectory.
  ///
  /// In en, this message translates to:
  /// **'This directory is empty'**
  String get sftpEmptyDirectory;

  /// No description provided for @sftpNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No server connected'**
  String get sftpNoConnection;

  /// No description provided for @sftpPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get sftpPathLabel;

  /// No description provided for @sftpUpload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get sftpUpload;

  /// No description provided for @sftpDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get sftpDownload;

  /// No description provided for @sftpDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get sftpDelete;

  /// No description provided for @sftpRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get sftpRename;

  /// No description provided for @sftpNewFolder.
  ///
  /// In en, this message translates to:
  /// **'New Folder'**
  String get sftpNewFolder;

  /// No description provided for @sftpNewFolderName.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get sftpNewFolderName;

  /// No description provided for @sftpChmod.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get sftpChmod;

  /// No description provided for @sftpChmodTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Permissions'**
  String get sftpChmodTitle;

  /// No description provided for @sftpChmodOctal.
  ///
  /// In en, this message translates to:
  /// **'Octal'**
  String get sftpChmodOctal;

  /// No description provided for @sftpChmodOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get sftpChmodOwner;

  /// No description provided for @sftpChmodGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get sftpChmodGroup;

  /// No description provided for @sftpChmodOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sftpChmodOther;

  /// No description provided for @sftpChmodRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get sftpChmodRead;

  /// No description provided for @sftpChmodWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get sftpChmodWrite;

  /// No description provided for @sftpChmodExecute.
  ///
  /// In en, this message translates to:
  /// **'Execute'**
  String get sftpChmodExecute;

  /// No description provided for @sftpCreateSymlink.
  ///
  /// In en, this message translates to:
  /// **'Create Symlink'**
  String get sftpCreateSymlink;

  /// No description provided for @sftpSymlinkTarget.
  ///
  /// In en, this message translates to:
  /// **'Target path'**
  String get sftpSymlinkTarget;

  /// No description provided for @sftpSymlinkName.
  ///
  /// In en, this message translates to:
  /// **'Link name'**
  String get sftpSymlinkName;

  /// No description provided for @sftpFilePreview.
  ///
  /// In en, this message translates to:
  /// **'File Preview'**
  String get sftpFilePreview;

  /// No description provided for @sftpFileInfo.
  ///
  /// In en, this message translates to:
  /// **'File Info'**
  String get sftpFileInfo;

  /// No description provided for @sftpFileSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sftpFileSize;

  /// No description provided for @sftpFileModified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get sftpFileModified;

  /// No description provided for @sftpFilePermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get sftpFilePermissions;

  /// No description provided for @sftpFileOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get sftpFileOwner;

  /// No description provided for @sftpFileType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get sftpFileType;

  /// No description provided for @sftpFileLinkTarget.
  ///
  /// In en, this message translates to:
  /// **'Link target'**
  String get sftpFileLinkTarget;

  /// No description provided for @sftpTransfers.
  ///
  /// In en, this message translates to:
  /// **'Transfers'**
  String get sftpTransfers;

  /// No description provided for @sftpTransferProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String sftpTransferProgress(int current, int total);

  /// No description provided for @sftpTransferQueued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get sftpTransferQueued;

  /// No description provided for @sftpTransferActive.
  ///
  /// In en, this message translates to:
  /// **'Transferring...'**
  String get sftpTransferActive;

  /// No description provided for @sftpTransferPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get sftpTransferPaused;

  /// No description provided for @sftpTransferCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get sftpTransferCompleted;

  /// No description provided for @sftpTransferFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get sftpTransferFailed;

  /// No description provided for @sftpTransferCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get sftpTransferCancelled;

  /// No description provided for @sftpPauseTransfer.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get sftpPauseTransfer;

  /// No description provided for @sftpResumeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get sftpResumeTransfer;

  /// No description provided for @sftpCancelTransfer.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get sftpCancelTransfer;

  /// No description provided for @sftpClearCompleted.
  ///
  /// In en, this message translates to:
  /// **'Clear completed'**
  String get sftpClearCompleted;

  /// No description provided for @sftpTransferCount.
  ///
  /// In en, this message translates to:
  /// **'{active} of {total} transfers'**
  String sftpTransferCount(int active, int total);

  /// No description provided for @sftpTransferCountActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active} other{{count} active}}'**
  String sftpTransferCountActive(int count);

  /// No description provided for @sftpTransferCountCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 completed} other{{count} completed}}'**
  String sftpTransferCountCompleted(int count);

  /// No description provided for @sftpTransferCountFailed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 failed} other{{count} failed}}'**
  String sftpTransferCountFailed(int count);

  /// No description provided for @sftpCopyToOtherPane.
  ///
  /// In en, this message translates to:
  /// **'Copy to other pane'**
  String get sftpCopyToOtherPane;

  /// No description provided for @sftpConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} items?'**
  String sftpConfirmDelete(int count);

  /// No description provided for @sftpConfirmDeleteSingle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String sftpConfirmDeleteSingle(String name);

  /// No description provided for @sftpDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get sftpDeleteSuccess;

  /// No description provided for @sftpRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get sftpRenameTitle;

  /// No description provided for @sftpRenameLabel.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get sftpRenameLabel;

  /// No description provided for @sftpSortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sftpSortByName;

  /// No description provided for @sftpSortBySize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get sftpSortBySize;

  /// No description provided for @sftpSortByDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sftpSortByDate;

  /// No description provided for @sftpSortByType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get sftpSortByType;

  /// No description provided for @sftpShowHidden.
  ///
  /// In en, this message translates to:
  /// **'Show hidden files'**
  String get sftpShowHidden;

  /// No description provided for @sftpHideHidden.
  ///
  /// In en, this message translates to:
  /// **'Hide hidden files'**
  String get sftpHideHidden;

  /// No description provided for @sftpSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get sftpSelectAll;

  /// No description provided for @sftpDeselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get sftpDeselectAll;

  /// No description provided for @sftpItemsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String sftpItemsSelected(int count);

  /// No description provided for @sftpRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get sftpRefresh;

  /// No description provided for @sftpConnectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {message}'**
  String sftpConnectionError(String message);

  /// No description provided for @sftpPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get sftpPermissionDenied;

  /// No description provided for @sftpOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed: {message}'**
  String sftpOperationFailed(String message);

  /// No description provided for @sftpOverwriteTitle.
  ///
  /// In en, this message translates to:
  /// **'File already exists'**
  String get sftpOverwriteTitle;

  /// No description provided for @sftpOverwriteMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{fileName}\" already exists. Overwrite?'**
  String sftpOverwriteMessage(String fileName);

  /// No description provided for @sftpOverwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get sftpOverwrite;

  /// No description provided for @sftpTransferStarted.
  ///
  /// In en, this message translates to:
  /// **'Transfer started: {fileName}'**
  String sftpTransferStarted(String fileName);

  /// No description provided for @sftpNoPaneSelected.
  ///
  /// In en, this message translates to:
  /// **'Select a destination in the other pane first'**
  String get sftpNoPaneSelected;

  /// No description provided for @sftpDirectoryTransferNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Directory transfer coming soon'**
  String get sftpDirectoryTransferNotSupported;

  /// No description provided for @sftpSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get sftpSelect;

  /// No description provided for @sftpOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get sftpOpen;

  /// No description provided for @sftpExtractArchive.
  ///
  /// In en, this message translates to:
  /// **'Extract Here'**
  String get sftpExtractArchive;

  /// No description provided for @sftpExtractSuccess.
  ///
  /// In en, this message translates to:
  /// **'Archive extracted'**
  String get sftpExtractSuccess;

  /// No description provided for @sftpExtractFailed.
  ///
  /// In en, this message translates to:
  /// **'Extraction failed: {message}'**
  String sftpExtractFailed(String message);

  /// No description provided for @sftpExtractUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Unsupported archive format'**
  String get sftpExtractUnsupported;

  /// No description provided for @sftpExtracting.
  ///
  /// In en, this message translates to:
  /// **'Extracting...'**
  String get sftpExtracting;

  /// No description provided for @sftpUploadStarted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Upload started} other{{count} uploads started}}'**
  String sftpUploadStarted(int count);

  /// No description provided for @sftpDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Download started} other{{count} downloads started}}'**
  String sftpDownloadStarted(int count);

  /// No description provided for @sftpDownloadComplete.
  ///
  /// In en, this message translates to:
  /// **'\"{fileName}\" downloaded'**
  String sftpDownloadComplete(String fileName);

  /// No description provided for @sftpSavedToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Saved to Downloads/SSHVault'**
  String get sftpSavedToDownloads;

  /// No description provided for @sftpSaveToFiles.
  ///
  /// In en, this message translates to:
  /// **'Save to Files'**
  String get sftpSaveToFiles;

  /// No description provided for @sftpFileSaved.
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get sftpFileSaved;

  /// No description provided for @notificationTerminalTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{SSH session active} other{{count} SSH sessions active}}'**
  String notificationTerminalTitle(int count);

  /// No description provided for @notificationTerminalTap.
  ///
  /// In en, this message translates to:
  /// **'Tap to open terminal'**
  String get notificationTerminalTap;

  /// No description provided for @settingsAccountAndSync.
  ///
  /// In en, this message translates to:
  /// **'Account & Sync'**
  String get settingsAccountAndSync;

  /// No description provided for @settingsAccountSubtitleAuth.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get settingsAccountSubtitleAuth;

  /// No description provided for @settingsAccountSubtitleUnauth.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get settingsAccountSubtitleUnauth;

  /// No description provided for @settingsSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-Lock, Biometrics, PIN'**
  String get settingsSecuritySubtitle;

  /// No description provided for @settingsSshSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Port 22, User root'**
  String get settingsSshSubtitle;

  /// No description provided for @settingsAppearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Theme, Language, Terminal'**
  String get settingsAppearanceSubtitle;

  /// No description provided for @settingsNetworkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'DNS-over-HTTPS'**
  String get settingsNetworkSubtitle;

  /// No description provided for @settingsExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted export defaults'**
  String get settingsExportSubtitle;

  /// No description provided for @settingsAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version, Licenses'**
  String get settingsAboutSubtitle;

  /// No description provided for @settingsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search settings...'**
  String get settingsSearchHint;

  /// No description provided for @settingsSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No settings found'**
  String get settingsSearchNoResults;

  /// No description provided for @aboutDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developed by Kiefer Networks'**
  String get aboutDeveloper;

  /// No description provided for @aboutDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get aboutDonate;

  /// No description provided for @aboutOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutOpenSourceLicenses;

  /// No description provided for @aboutWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get aboutWebsite;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// No description provided for @aboutBuild.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get aboutBuild;

  /// No description provided for @settingsDohDescription.
  ///
  /// In en, this message translates to:
  /// **'DNS-over-HTTPS encrypts DNS queries and prevents DNS spoofing. SSHVault checks hostnames against multiple providers to detect attacks.'**
  String get settingsDohDescription;

  /// No description provided for @settingsDnsAddServer.
  ///
  /// In en, this message translates to:
  /// **'Add DNS Server'**
  String get settingsDnsAddServer;

  /// No description provided for @settingsDnsServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get settingsDnsServerUrl;

  /// No description provided for @settingsDnsDefaultBadge.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get settingsDnsDefaultBadge;

  /// No description provided for @settingsDnsResetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get settingsDnsResetDefaults;

  /// No description provided for @settingsDnsInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid HTTPS URL'**
  String get settingsDnsInvalidUrl;

  /// No description provided for @settingsDefaultAuthMethod.
  ///
  /// In en, this message translates to:
  /// **'Authentication Method'**
  String get settingsDefaultAuthMethod;

  /// No description provided for @settingsAuthPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get settingsAuthPassword;

  /// No description provided for @settingsAuthKey.
  ///
  /// In en, this message translates to:
  /// **'SSH Key'**
  String get settingsAuthKey;

  /// No description provided for @settingsConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection Timeout'**
  String get settingsConnectionTimeout;

  /// No description provided for @settingsConnectionTimeoutValue.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String settingsConnectionTimeoutValue(int seconds);

  /// No description provided for @settingsKeepaliveInterval.
  ///
  /// In en, this message translates to:
  /// **'Keep-Alive Interval'**
  String get settingsKeepaliveInterval;

  /// No description provided for @settingsKeepaliveIntervalValue.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String settingsKeepaliveIntervalValue(int seconds);

  /// No description provided for @settingsCompression.
  ///
  /// In en, this message translates to:
  /// **'Compression'**
  String get settingsCompression;

  /// No description provided for @settingsCompressionDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable zlib compression for SSH connections'**
  String get settingsCompressionDescription;

  /// No description provided for @settingsTerminalType.
  ///
  /// In en, this message translates to:
  /// **'Terminal Type'**
  String get settingsTerminalType;

  /// No description provided for @settingsSectionConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get settingsSectionConnection;

  /// No description provided for @settingsClipboardAutoClear.
  ///
  /// In en, this message translates to:
  /// **'Clipboard Auto-Clear'**
  String get settingsClipboardAutoClear;

  /// No description provided for @settingsClipboardAutoClearOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsClipboardAutoClearOff;

  /// No description provided for @settingsClipboardAutoClearValue.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String settingsClipboardAutoClearValue(int seconds);

  /// No description provided for @settingsSessionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Session Timeout'**
  String get settingsSessionTimeout;

  /// No description provided for @settingsSessionTimeoutOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsSessionTimeoutOff;

  /// No description provided for @settingsSessionTimeoutValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String settingsSessionTimeoutValue(int minutes);

  /// No description provided for @settingsDuressPin.
  ///
  /// In en, this message translates to:
  /// **'Duress PIN'**
  String get settingsDuressPin;

  /// No description provided for @settingsDuressPinDescription.
  ///
  /// In en, this message translates to:
  /// **'A separate PIN that wipes all data when entered'**
  String get settingsDuressPinDescription;

  /// No description provided for @settingsDuressPinSet.
  ///
  /// In en, this message translates to:
  /// **'Duress PIN is set'**
  String get settingsDuressPinSet;

  /// No description provided for @settingsDuressPinNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get settingsDuressPinNotSet;

  /// No description provided for @settingsDuressPinWarning.
  ///
  /// In en, this message translates to:
  /// **'Entering this PIN will permanently delete all local data including credentials, keys, and settings. This cannot be undone.'**
  String get settingsDuressPinWarning;

  /// No description provided for @settingsKeyRotationReminder.
  ///
  /// In en, this message translates to:
  /// **'Key Rotation Reminder'**
  String get settingsKeyRotationReminder;

  /// No description provided for @settingsKeyRotationOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsKeyRotationOff;

  /// No description provided for @settingsKeyRotationValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String settingsKeyRotationValue(int days);

  /// No description provided for @settingsFailedAttempts.
  ///
  /// In en, this message translates to:
  /// **'Failed PIN Attempts'**
  String get settingsFailedAttempts;

  /// No description provided for @settingsSectionAppLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get settingsSectionAppLock;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsSectionReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsSectionReminders;

  /// No description provided for @settingsSectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get settingsSectionStatus;

  /// No description provided for @settingsExportBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export, Import & Backup'**
  String get settingsExportBackupSubtitle;

  /// No description provided for @settingsExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get settingsExportJson;

  /// No description provided for @settingsExportEncrypted.
  ///
  /// In en, this message translates to:
  /// **'Export Encrypted'**
  String get settingsExportEncrypted;

  /// No description provided for @settingsImportFile.
  ///
  /// In en, this message translates to:
  /// **'Import from File'**
  String get settingsImportFile;

  /// No description provided for @settingsSectionImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settingsSectionImport;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Servers'**
  String get filterTitle;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get filterApply;

  /// No description provided for @filterClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get filterClearAll;

  /// No description provided for @filterActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 filter active} other{{count} filters active}}'**
  String filterActiveCount(int count);

  /// No description provided for @filterFolder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get filterFolder;

  /// No description provided for @filterTags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get filterTags;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get filterStatus;

  /// No description provided for @variablePreviewResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved Preview'**
  String get variablePreviewResolved;

  /// No description provided for @variableInsert.
  ///
  /// In en, this message translates to:
  /// **'Insert'**
  String get variableInsert;

  /// No description provided for @tagServerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 server} other{{count} servers}}'**
  String tagServerCount(int count);

  /// No description provided for @logoutAllDevicesSuccessCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session revoked.} other{{count} sessions revoked.}} You have been logged out.'**
  String logoutAllDevicesSuccessCount(int count);

  /// No description provided for @keyGenPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get keyGenPassphrase;

  /// No description provided for @keyGenPassphraseHint.
  ///
  /// In en, this message translates to:
  /// **'Optional — protects the private key'**
  String get keyGenPassphraseHint;

  /// No description provided for @settingsDnsDefaultQuad9Mullvad.
  ///
  /// In en, this message translates to:
  /// **'Default (Quad9 + Mullvad)'**
  String get settingsDnsDefaultQuad9Mullvad;

  /// No description provided for @sshKeyDuplicate.
  ///
  /// In en, this message translates to:
  /// **'A key with the same fingerprint already exists: \"{name}\". Each SSH key must be unique.'**
  String sshKeyDuplicate(String name);

  /// No description provided for @sshKeyFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get sshKeyFingerprint;

  /// No description provided for @sshKeyPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get sshKeyPublicKey;

  /// No description provided for @jumpHost.
  ///
  /// In en, this message translates to:
  /// **'Jump Host'**
  String get jumpHost;

  /// No description provided for @jumpHostNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get jumpHostNone;

  /// No description provided for @jumpHostLabel.
  ///
  /// In en, this message translates to:
  /// **'Connect via jump host'**
  String get jumpHostLabel;

  /// No description provided for @jumpHostSelfError.
  ///
  /// In en, this message translates to:
  /// **'A server cannot be its own jump host'**
  String get jumpHostSelfError;

  /// No description provided for @jumpHostConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting to jump host…'**
  String get jumpHostConnecting;

  /// No description provided for @jumpHostCircularError.
  ///
  /// In en, this message translates to:
  /// **'Circular jump host chain detected'**
  String get jumpHostCircularError;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete all local data? Servers, SSH keys, snippets, and settings will be removed from this device.'**
  String get logoutDialogMessage;

  /// No description provided for @logoutOnly.
  ///
  /// In en, this message translates to:
  /// **'Log out only'**
  String get logoutOnly;

  /// No description provided for @logoutAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Log out & delete data'**
  String get logoutAndDelete;

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get changeAvatar;

  /// No description provided for @removeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Remove Avatar'**
  String get removeAvatar;

  /// No description provided for @avatarUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload avatar'**
  String get avatarUploadFailed;

  /// No description provided for @avatarTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image is too large'**
  String get avatarTooLarge;

  /// No description provided for @deviceLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get deviceLastSeen;

  /// No description provided for @deviceIpAddress.
  ///
  /// In en, this message translates to:
  /// **'IP'**
  String get deviceIpAddress;

  /// No description provided for @serverUrlLockedWhileLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Server URL cannot be changed while logged in. Log out first.'**
  String get serverUrlLockedWhileLoggedIn;

  /// No description provided for @serverListNoFolder.
  ///
  /// In en, this message translates to:
  /// **'Uncategorized'**
  String get serverListNoFolder;

  /// No description provided for @autoSyncInterval.
  ///
  /// In en, this message translates to:
  /// **'Sync Interval'**
  String get autoSyncInterval;

  /// No description provided for @autoSyncIntervalValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String autoSyncIntervalValue(int minutes);

  /// No description provided for @proxySettings.
  ///
  /// In en, this message translates to:
  /// **'Proxy Settings'**
  String get proxySettings;

  /// No description provided for @proxyType.
  ///
  /// In en, this message translates to:
  /// **'Proxy Type'**
  String get proxyType;

  /// No description provided for @proxyNone.
  ///
  /// In en, this message translates to:
  /// **'No Proxy'**
  String get proxyNone;

  /// No description provided for @proxySocks5.
  ///
  /// In en, this message translates to:
  /// **'SOCKS5'**
  String get proxySocks5;

  /// No description provided for @proxyHttpConnect.
  ///
  /// In en, this message translates to:
  /// **'HTTP CONNECT'**
  String get proxyHttpConnect;

  /// No description provided for @proxyHost.
  ///
  /// In en, this message translates to:
  /// **'Proxy Host'**
  String get proxyHost;

  /// No description provided for @proxyPort.
  ///
  /// In en, this message translates to:
  /// **'Proxy Port'**
  String get proxyPort;

  /// No description provided for @proxyUsername.
  ///
  /// In en, this message translates to:
  /// **'Proxy Username'**
  String get proxyUsername;

  /// No description provided for @proxyPassword.
  ///
  /// In en, this message translates to:
  /// **'Proxy Password'**
  String get proxyPassword;

  /// No description provided for @proxyUseGlobal.
  ///
  /// In en, this message translates to:
  /// **'Use Global Proxy'**
  String get proxyUseGlobal;

  /// No description provided for @proxyGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get proxyGlobal;

  /// No description provided for @proxyServerSpecific.
  ///
  /// In en, this message translates to:
  /// **'Server-specific'**
  String get proxyServerSpecific;

  /// No description provided for @proxyTestConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get proxyTestConnection;

  /// No description provided for @proxyTestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Proxy reachable'**
  String get proxyTestSuccess;

  /// No description provided for @proxyTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Proxy not reachable'**
  String get proxyTestFailed;

  /// No description provided for @proxyDefaultProxy.
  ///
  /// In en, this message translates to:
  /// **'Default Proxy'**
  String get proxyDefaultProxy;

  /// No description provided for @vpnRequired.
  ///
  /// In en, this message translates to:
  /// **'VPN Required'**
  String get vpnRequired;

  /// No description provided for @vpnRequiredTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show warning when connecting without active VPN'**
  String get vpnRequiredTooltip;

  /// No description provided for @vpnActive.
  ///
  /// In en, this message translates to:
  /// **'VPN Active'**
  String get vpnActive;

  /// No description provided for @vpnInactive.
  ///
  /// In en, this message translates to:
  /// **'VPN Inactive'**
  String get vpnInactive;

  /// No description provided for @vpnWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'VPN Not Active'**
  String get vpnWarningTitle;

  /// No description provided for @vpnWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'This server is marked as requiring a VPN connection, but no VPN is currently active. Do you want to connect anyway?'**
  String get vpnWarningMessage;

  /// No description provided for @vpnConnectAnyway.
  ///
  /// In en, this message translates to:
  /// **'Connect Anyway'**
  String get vpnConnectAnyway;

  /// No description provided for @postConnectCommands.
  ///
  /// In en, this message translates to:
  /// **'Post-Connect Commands'**
  String get postConnectCommands;

  /// No description provided for @postConnectCommandsHint.
  ///
  /// In en, this message translates to:
  /// **'cd /var/log\ntail -f syslog'**
  String get postConnectCommandsHint;

  /// No description provided for @postConnectCommandsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Commands executed automatically after connection (one per line)'**
  String get postConnectCommandsSubtitle;

  /// No description provided for @dashboardFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get dashboardFavorites;

  /// No description provided for @dashboardRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get dashboardRecent;

  /// No description provided for @dashboardActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get dashboardActiveSessions;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @noRecentConnections.
  ///
  /// In en, this message translates to:
  /// **'No recent connections'**
  String get noRecentConnections;

  /// No description provided for @terminalSplit.
  ///
  /// In en, this message translates to:
  /// **'Split View'**
  String get terminalSplit;

  /// No description provided for @terminalUnsplit.
  ///
  /// In en, this message translates to:
  /// **'Close Split'**
  String get terminalUnsplit;

  /// No description provided for @terminalSelectSession.
  ///
  /// In en, this message translates to:
  /// **'Select session for split view'**
  String get terminalSelectSession;

  /// No description provided for @knownHostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Known Hosts'**
  String get knownHostsTitle;

  /// No description provided for @knownHostsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage trusted server fingerprints'**
  String get knownHostsSubtitle;

  /// No description provided for @hostKeyNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Host'**
  String get hostKeyNewTitle;

  /// No description provided for @hostKeyNewMessage.
  ///
  /// In en, this message translates to:
  /// **'First connection to {hostname}:{port}. Verify the fingerprint before connecting.'**
  String hostKeyNewMessage(String hostname, int port);

  /// No description provided for @hostKeyChangedTitle.
  ///
  /// In en, this message translates to:
  /// **'Host Key Changed!'**
  String get hostKeyChangedTitle;

  /// No description provided for @hostKeyChangedMessage.
  ///
  /// In en, this message translates to:
  /// **'The host key for {hostname}:{port} has changed. This could indicate a security threat.'**
  String hostKeyChangedMessage(String hostname, int port);

  /// No description provided for @hostKeyFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get hostKeyFingerprint;

  /// No description provided for @hostKeyType.
  ///
  /// In en, this message translates to:
  /// **'Key Type'**
  String get hostKeyType;

  /// No description provided for @hostKeyTrustConnect.
  ///
  /// In en, this message translates to:
  /// **'Trust & Connect'**
  String get hostKeyTrustConnect;

  /// No description provided for @hostKeyAcceptNew.
  ///
  /// In en, this message translates to:
  /// **'Accept New Key'**
  String get hostKeyAcceptNew;

  /// No description provided for @hostKeyReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get hostKeyReject;

  /// No description provided for @hostKeyPreviousFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Previous Fingerprint'**
  String get hostKeyPreviousFingerprint;

  /// No description provided for @hostKeyDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All Known Hosts'**
  String get hostKeyDeleteAll;

  /// No description provided for @hostKeyDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all known hosts? You will be prompted again on next connection.'**
  String get hostKeyDeleteConfirm;

  /// No description provided for @hostKeyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No known hosts yet'**
  String get hostKeyEmpty;

  /// No description provided for @hostKeyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Host fingerprints will be stored here after your first connection'**
  String get hostKeyEmptySubtitle;

  /// No description provided for @hostKeyFirstSeen.
  ///
  /// In en, this message translates to:
  /// **'First seen'**
  String get hostKeyFirstSeen;

  /// No description provided for @hostKeyLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get hostKeyLastSeen;

  /// No description provided for @sshConfigImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import SSH Config'**
  String get sshConfigImportTitle;

  /// No description provided for @sshConfigImportPickFile.
  ///
  /// In en, this message translates to:
  /// **'Select SSH Config File'**
  String get sshConfigImportPickFile;

  /// No description provided for @sshConfigImportOrPaste.
  ///
  /// In en, this message translates to:
  /// **'Or paste config content'**
  String get sshConfigImportOrPaste;

  /// No description provided for @sshConfigImportParsed.
  ///
  /// In en, this message translates to:
  /// **'{count} hosts found'**
  String sshConfigImportParsed(int count);

  /// No description provided for @sshConfigImportButton.
  ///
  /// In en, this message translates to:
  /// **'Import Selected'**
  String get sshConfigImportButton;

  /// No description provided for @sshConfigImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'{count} servers imported'**
  String sshConfigImportSuccess(int count);

  /// No description provided for @sshConfigImportDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Already exists'**
  String get sshConfigImportDuplicate;

  /// No description provided for @sshConfigImportNoHosts.
  ///
  /// In en, this message translates to:
  /// **'No hosts found in config'**
  String get sshConfigImportNoHosts;

  /// No description provided for @sftpBookmarkAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get sftpBookmarkAdd;

  /// No description provided for @sftpBookmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get sftpBookmarkLabel;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @reportAndDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Report & Disconnect'**
  String get reportAndDisconnect;

  /// No description provided for @continueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Continue Anyway'**
  String get continueAnyway;

  /// No description provided for @insertSnippet.
  ///
  /// In en, this message translates to:
  /// **'Insert Snippet'**
  String get insertSnippet;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @heartbeatLostMessage.
  ///
  /// In en, this message translates to:
  /// **'The server could not be reached after multiple attempts. For your security, the session has been terminated.'**
  String get heartbeatLostMessage;

  /// No description provided for @attestationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Verification Failed'**
  String get attestationFailedTitle;

  /// No description provided for @attestationFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'The server could not be verified as a legitimate SSHVault backend. This may indicate a man-in-the-middle attack or a misconfigured server.'**
  String get attestationFailedMessage;

  /// No description provided for @sectionLinks.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get sectionLinks;

  /// No description provided for @sectionDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get sectionDeveloper;

  /// No description provided for @sectionDnsOverHttps.
  ///
  /// In en, this message translates to:
  /// **'DNS-over-HTTPS'**
  String get sectionDnsOverHttps;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @connectionTestSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connection successful'**
  String get connectionTestSuccess;

  /// No description provided for @connectionTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {message}'**
  String connectionTestFailed(String message);

  /// No description provided for @serverVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Server verification failed'**
  String get serverVerificationFailed;

  /// No description provided for @importSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccessful;

  /// No description provided for @hintExampleServerUrl.
  ///
  /// In en, this message translates to:
  /// **'https://your-server.example.com'**
  String get hintExampleServerUrl;

  /// No description provided for @hintExampleDohUrl.
  ///
  /// In en, this message translates to:
  /// **'https://dns.example.com/dns-query'**
  String get hintExampleDohUrl;

  /// No description provided for @hintExampleProxyHost.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.1'**
  String get hintExampleProxyHost;

  /// No description provided for @hintExampleProxyPort.
  ///
  /// In en, this message translates to:
  /// **'1080'**
  String get hintExampleProxyPort;

  /// No description provided for @hintExampleTimeoutSeconds.
  ///
  /// In en, this message translates to:
  /// **'30'**
  String get hintExampleTimeoutSeconds;

  /// No description provided for @hintExampleKeepaliveSeconds.
  ///
  /// In en, this message translates to:
  /// **'15'**
  String get hintExampleKeepaliveSeconds;

  /// No description provided for @jumpHostEntryLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} ({hostname})'**
  String jumpHostEntryLabel(String name, String hostname);

  /// No description provided for @sshKeyEntryLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} ({keyType})'**
  String sshKeyEntryLabel(String name, String keyType);

  /// No description provided for @hostPortLabel.
  ///
  /// In en, this message translates to:
  /// **'{hostname}:{port}'**
  String hostPortLabel(String hostname, int port);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
