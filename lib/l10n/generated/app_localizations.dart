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
  /// **'SSH Vault'**
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

  /// No description provided for @navGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get navGroups;

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
  /// **'SSH Vault is locked'**
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

  /// No description provided for @pinDialogSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Set PIN Code'**
  String get pinDialogSetTitle;

  /// No description provided for @pinDialogSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a 6-digit PIN to protect SSH Vault'**
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
  /// **'Wrong PIN ({attempts}/5)'**
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

  /// No description provided for @settingsEncryptExport.
  ///
  /// In en, this message translates to:
  /// **'Encrypt Exports by Default'**
  String get settingsEncryptExport;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About SSH Vault'**
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

  /// No description provided for @serverNoGroup.
  ///
  /// In en, this message translates to:
  /// **'No Group'**
  String get serverNoGroup;

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

  /// No description provided for @filterAllGroups.
  ///
  /// In en, this message translates to:
  /// **'All Groups'**
  String get filterAllGroups;

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

  /// No description provided for @groupListTitle.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupListTitle;

  /// No description provided for @groupListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get groupListEmpty;

  /// No description provided for @groupListEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create groups to organize your servers.'**
  String get groupListEmptySubtitle;

  /// No description provided for @groupAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add Group'**
  String get groupAddButton;

  /// No description provided for @groupDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get groupDeleteTitle;

  /// No description provided for @groupDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? Servers in this group will become ungrouped.'**
  String groupDeleteMessage(String name);

  /// No description provided for @groupCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get groupCollapse;

  /// No description provided for @groupShowHosts.
  ///
  /// In en, this message translates to:
  /// **'Show hosts'**
  String get groupShowHosts;

  /// No description provided for @groupFormTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get groupFormTitleEdit;

  /// No description provided for @groupFormTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get groupFormTitleNew;

  /// No description provided for @groupFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupFormNameLabel;

  /// No description provided for @groupFormParentLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent Group'**
  String get groupFormParentLabel;

  /// No description provided for @groupFormParentNone.
  ///
  /// In en, this message translates to:
  /// **'None (Root)'**
  String get groupFormParentNone;

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

  /// No description provided for @snippetFormGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get snippetFormGroupLabel;

  /// No description provided for @snippetFormNoGroup.
  ///
  /// In en, this message translates to:
  /// **'No Group'**
  String get snippetFormNoGroup;

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
