// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'होस्ट';

  @override
  String get navSnippets => 'स्निपेट';

  @override
  String get navFolders => 'फ़ोल्डर';

  @override
  String get navTags => 'टैग';

  @override
  String get navSshKeys => 'SSH कुंजियाँ';

  @override
  String get navExportImport => 'निर्यात / आयात';

  @override
  String get navTerminal => 'टर्मिनल';

  @override
  String get navMore => 'और';

  @override
  String get navManagement => 'प्रबंधन';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get navAbout => 'परिचय';

  @override
  String get lockScreenTitle => 'SSHVault लॉक है';

  @override
  String get lockScreenUnlock => 'अनलॉक करें';

  @override
  String get lockScreenEnterPin => 'PIN दर्ज करें';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'बहुत अधिक असफल प्रयास। $minutes मिनट बाद पुनः प्रयास करें।';
  }

  @override
  String get pinDialogSetTitle => 'PIN कोड सेट करें';

  @override
  String get pinDialogSetSubtitle =>
      'SSHVault की सुरक्षा के लिए 6 अंकों का PIN दर्ज करें';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'PIN की पुष्टि करें';

  @override
  String get pinDialogErrorLength => 'PIN ठीक 6 अंकों का होना चाहिए';

  @override
  String get pinDialogErrorMismatch => 'PIN मेल नहीं खाते';

  @override
  String get pinDialogVerifyTitle => 'PIN दर्ज करें';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'गलत PIN। $attempts प्रयास शेष।';
  }

  @override
  String get securityBannerMessage =>
      'आपके SSH क्रेडेंशियल सुरक्षित नहीं हैं। सेटिंग्स में PIN या बायोमेट्रिक लॉक सेट करें।';

  @override
  String get securityBannerDismiss => 'खारिज करें';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsSectionAppearance => 'दिखावट';

  @override
  String get settingsSectionTerminal => 'टर्मिनल';

  @override
  String get settingsSectionSshDefaults => 'SSH डिफ़ॉल्ट';

  @override
  String get settingsSectionSecurity => 'सुरक्षा';

  @override
  String get settingsSectionExport => 'निर्यात';

  @override
  String get settingsSectionAbout => 'परिचय';

  @override
  String get settingsTheme => 'थीम';

  @override
  String get settingsThemeSystem => 'सिस्टम';

  @override
  String get settingsThemeLight => 'लाइट';

  @override
  String get settingsThemeDark => 'डार्क';

  @override
  String get settingsTerminalTheme => 'टर्मिनल थीम';

  @override
  String get settingsTerminalThemeDefault => 'डिफ़ॉल्ट डार्क';

  @override
  String get settingsFontSize => 'फ़ॉन्ट साइज़';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'डिफ़ॉल्ट पोर्ट';

  @override
  String get settingsDefaultPortDialog => 'डिफ़ॉल्ट SSH पोर्ट';

  @override
  String get settingsPortLabel => 'पोर्ट';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'डिफ़ॉल्ट उपयोगकर्ता नाम';

  @override
  String get settingsDefaultUsernameDialog => 'डिफ़ॉल्ट उपयोगकर्ता नाम';

  @override
  String get settingsUsernameLabel => 'उपयोगकर्ता नाम';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'ऑटो-लॉक टाइमआउट';

  @override
  String get settingsAutoLockDisabled => 'अक्षम';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get settingsAutoLockOff => 'बंद';

  @override
  String get settingsAutoLock1Min => '1 मिनट';

  @override
  String get settingsAutoLock5Min => '5 मिनट';

  @override
  String get settingsAutoLock15Min => '15 मिनट';

  @override
  String get settingsAutoLock30Min => '30 मिनट';

  @override
  String get settingsBiometricUnlock => 'बायोमेट्रिक अनलॉक';

  @override
  String get settingsBiometricNotAvailable => 'इस डिवाइस पर उपलब्ध नहीं';

  @override
  String get settingsBiometricError => 'बायोमेट्रिक्स जाँचने में त्रुटि';

  @override
  String get settingsBiometricReason =>
      'बायोमेट्रिक अनलॉक सक्षम करने के लिए अपनी पहचान सत्यापित करें';

  @override
  String get settingsBiometricRequiresPin =>
      'बायोमेट्रिक अनलॉक सक्षम करने के लिए पहले PIN सेट करें';

  @override
  String get settingsPinCode => 'PIN कोड';

  @override
  String get settingsPinIsSet => 'PIN सेट है';

  @override
  String get settingsPinNotConfigured => 'कोई PIN कॉन्फ़िगर नहीं है';

  @override
  String get settingsPinRemove => 'हटाएँ';

  @override
  String get settingsPinRemoveWarning =>
      'PIN हटाने से सभी डेटाबेस फ़ील्ड डिक्रिप्ट हो जाएँगे और बायोमेट्रिक अनलॉक अक्षम हो जाएगा। जारी रखें?';

  @override
  String get settingsPinRemoveTitle => 'PIN हटाएँ';

  @override
  String get settingsPreventScreenshots => 'स्क्रीनशॉट रोकें';

  @override
  String get settingsPreventScreenshotsDescription =>
      'स्क्रीनशॉट और स्क्रीन रिकॉर्डिंग ब्लॉक करें';

  @override
  String get settingsEncryptExport => 'डिफ़ॉल्ट रूप से निर्यात एन्क्रिप्ट करें';

  @override
  String get settingsAbout => 'SSHVault के बारे में';

  @override
  String get settingsAboutLegalese => 'Kiefer Networks द्वारा';

  @override
  String get settingsAboutDescription => 'सुरक्षित, सेल्फ़-होस्टेड SSH क्लाइंट';

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get settingsLanguageSystem => 'सिस्टम';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageDe => 'Deutsch';

  @override
  String get settingsLanguageEs => 'Español';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguagePt => 'Português';

  @override
  String get settingsLanguageIt => 'Italiano';

  @override
  String get settingsLanguageRu => 'Русский';

  @override
  String get settingsLanguageUk => 'Українська';

  @override
  String get settingsLanguagePl => 'Polski';

  @override
  String get settingsLanguageJa => '日本語';

  @override
  String get settingsLanguageKo => '한국어';

  @override
  String get settingsLanguageZh => '中文';

  @override
  String get settingsLanguageAr => 'العربية';

  @override
  String get settingsLanguageHi => 'हिन्दी';

  @override
  String get settingsLanguageTr => 'Türkçe';

  @override
  String get settingsLanguageSv => 'Svenska';

  @override
  String get settingsLanguageNb => 'Norsk bokmål';

  @override
  String get settingsLanguageDa => 'Dansk';

  @override
  String get settingsLanguageFi => 'Suomi';

  @override
  String get settingsLanguageCs => 'Čeština';

  @override
  String get settingsLanguageHu => 'Magyar';

  @override
  String get settingsLanguageRo => 'Română';

  @override
  String get settingsLanguageTh => 'ไทย';

  @override
  String get settingsLanguageVi => 'Tiếng Việt';

  @override
  String get settingsLanguageNl => 'Nederlands';

  @override
  String get settingsLanguageId => 'Bahasa Indonesia';

  @override
  String get settingsLanguageEl => 'Ελληνικά';

  @override
  String get settingsLanguageHe => 'עברית';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get close => 'बंद करें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get create => 'बनाएँ';

  @override
  String get retry => 'पुनः प्रयास';

  @override
  String get copy => 'कॉपी';

  @override
  String get edit => 'संपादित करें';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get serverListTitle => 'होस्ट';

  @override
  String get serverListEmpty => 'अभी कोई सर्वर नहीं';

  @override
  String get serverListEmptySubtitle =>
      'शुरू करने के लिए अपना पहला SSH सर्वर जोड़ें।';

  @override
  String get serverAddButton => 'सर्वर जोड़ें';

  @override
  String get sshConfigImportTitle => 'SSH कॉन्फ़िग आयात करें';

  @override
  String sshConfigImportMessage(int count) {
    return '~/.ssh/config में $count होस्ट मिले। आयात करें?';
  }

  @override
  String get sshConfigImportButton => 'चयनित आयात करें';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count सर्वर आयात किए गए';
  }

  @override
  String get sshConfigNotFound => 'SSH कॉन्फ़िग फ़ाइल नहीं मिली';

  @override
  String get sshConfigEmpty => 'SSH कॉन्फ़िग में कोई होस्ट नहीं मिले';

  @override
  String get sshConfigAddManually => 'मैन्युअल रूप से जोड़ें';

  @override
  String get sshConfigImportAgain => 'SSH कॉन्फ़िग फिर से आयात करें?';

  @override
  String get sshConfigImportKeys =>
      'चयनित होस्ट द्वारा संदर्भित SSH कुंजियाँ आयात करें?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH कुंजी(याँ) आयात की गईं';
  }

  @override
  String get serverDuplicated => 'सर्वर डुप्लिकेट किया गया';

  @override
  String get serverDeleteTitle => 'सर्वर हटाएँ';

  @override
  String serverDeleteMessage(String name) {
    return 'क्या आप वाकई \"$name\" को हटाना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।';
  }

  @override
  String serverDeleteShort(String name) {
    return '\"$name\" हटाएँ?';
  }

  @override
  String get serverConnect => 'कनेक्ट करें';

  @override
  String get serverDetails => 'विवरण';

  @override
  String get serverDuplicate => 'डुप्लिकेट';

  @override
  String get serverActive => 'सक्रिय';

  @override
  String get serverNoFolder => 'कोई फ़ोल्डर नहीं';

  @override
  String get serverFormTitleEdit => 'सर्वर संपादित करें';

  @override
  String get serverFormTitleAdd => 'सर्वर जोड़ें';

  @override
  String get serverFormUpdateButton => 'सर्वर अपडेट करें';

  @override
  String get serverFormAddButton => 'सर्वर जोड़ें';

  @override
  String get serverFormPublicKeyExtracted =>
      'सार्वजनिक कुंजी सफलतापूर्वक निकाली गई';

  @override
  String serverFormPublicKeyError(String message) {
    return 'सार्वजनिक कुंजी नहीं निकाली जा सकी: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type कुंजी जोड़ी जनरेट की गई';
  }

  @override
  String get serverDetailTitle => 'सर्वर विवरण';

  @override
  String get serverDetailDeleteMessage => 'यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get serverDetailConnection => 'कनेक्शन';

  @override
  String get serverDetailHost => 'होस्ट';

  @override
  String get serverDetailPort => 'पोर्ट';

  @override
  String get serverDetailUsername => 'उपयोगकर्ता नाम';

  @override
  String get serverDetailFolder => 'फ़ोल्डर';

  @override
  String get serverDetailTags => 'टैग';

  @override
  String get serverDetailNotes => 'नोट्स';

  @override
  String get serverDetailInfo => 'जानकारी';

  @override
  String get serverDetailCreated => 'बनाया गया';

  @override
  String get serverDetailUpdated => 'अपडेट किया गया';

  @override
  String get serverDetailDistro => 'सिस्टम';

  @override
  String get copiedToClipboard => 'क्लिपबोर्ड पर कॉपी किया गया';

  @override
  String get serverFormNameLabel => 'सर्वर का नाम';

  @override
  String get serverFormHostnameLabel => 'होस्टनाम / IP';

  @override
  String get serverFormPortLabel => 'पोर्ट';

  @override
  String get serverFormUsernameLabel => 'उपयोगकर्ता नाम';

  @override
  String get serverFormPasswordLabel => 'पासवर्ड';

  @override
  String get serverFormUseManagedKey => 'प्रबंधित कुंजी का उपयोग करें';

  @override
  String get serverFormManagedKeySubtitle =>
      'केंद्रीय रूप से प्रबंधित SSH कुंजियों से चुनें';

  @override
  String get serverFormDirectKeySubtitle =>
      'इस सर्वर में सीधे कुंजी पेस्ट करें';

  @override
  String get serverFormGenerateKey => 'SSH कुंजी जोड़ी जनरेट करें';

  @override
  String get serverFormPrivateKeyLabel => 'निजी कुंजी';

  @override
  String get serverFormPrivateKeyHint => 'SSH निजी कुंजी पेस्ट करें...';

  @override
  String get serverFormExtractPublicKey => 'सार्वजनिक कुंजी निकालें';

  @override
  String get serverFormPublicKeyLabel => 'सार्वजनिक कुंजी';

  @override
  String get serverFormPublicKeyHint =>
      'खाली होने पर निजी कुंजी से स्वतः जनरेट';

  @override
  String get serverFormPassphraseLabel => 'कुंजी पासफ़्रेज़ (वैकल्पिक)';

  @override
  String get serverFormNotesLabel => 'नोट्स (वैकल्पिक)';

  @override
  String get searchServers => 'सर्वर खोजें...';

  @override
  String get filterAllFolders => 'सभी फ़ोल्डर';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterActive => 'सक्रिय';

  @override
  String get filterInactive => 'निष्क्रिय';

  @override
  String get filterClear => 'साफ़ करें';

  @override
  String get folderListTitle => 'फ़ोल्डर';

  @override
  String get folderListEmpty => 'अभी कोई फ़ोल्डर नहीं';

  @override
  String get folderListEmptySubtitle =>
      'अपने सर्वर व्यवस्थित करने के लिए फ़ोल्डर बनाएँ।';

  @override
  String get folderAddButton => 'फ़ोल्डर जोड़ें';

  @override
  String get folderDeleteTitle => 'फ़ोल्डर हटाएँ';

  @override
  String folderDeleteMessage(String name) {
    return '\"$name\" हटाएँ? सर्वर असंगठित हो जाएँगे।';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सर्वर',
      one: '1 सर्वर',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'संक्षिप्त करें';

  @override
  String get folderShowHosts => 'होस्ट दिखाएँ';

  @override
  String get folderConnectAll => 'सभी से कनेक्ट करें';

  @override
  String get folderFormTitleEdit => 'फ़ोल्डर संपादित करें';

  @override
  String get folderFormTitleNew => 'नया फ़ोल्डर';

  @override
  String get folderFormNameLabel => 'फ़ोल्डर का नाम';

  @override
  String get folderFormParentLabel => 'पैरेंट फ़ोल्डर';

  @override
  String get folderFormParentNone => 'कोई नहीं (रूट)';

  @override
  String get tagListTitle => 'टैग';

  @override
  String get tagListEmpty => 'अभी कोई टैग नहीं';

  @override
  String get tagListEmptySubtitle =>
      'अपने सर्वर को लेबल और फ़िल्टर करने के लिए टैग बनाएँ।';

  @override
  String get tagAddButton => 'टैग जोड़ें';

  @override
  String get tagDeleteTitle => 'टैग हटाएँ';

  @override
  String tagDeleteMessage(String name) {
    return '\"$name\" हटाएँ? यह सभी सर्वर से हटा दिया जाएगा।';
  }

  @override
  String get tagFormTitleEdit => 'टैग संपादित करें';

  @override
  String get tagFormTitleNew => 'नया टैग';

  @override
  String get tagFormNameLabel => 'टैग का नाम';

  @override
  String get sshKeyListTitle => 'SSH कुंजियाँ';

  @override
  String get sshKeyListEmpty => 'अभी कोई SSH कुंजियाँ नहीं';

  @override
  String get sshKeyListEmptySubtitle =>
      'SSH कुंजियाँ केंद्रीय रूप से प्रबंधित करने के लिए जनरेट या आयात करें';

  @override
  String get sshKeyCannotDeleteTitle => 'हटाया नहीं जा सकता';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return '\"$name\" हटाया नहीं जा सकता। $count सर्वर द्वारा उपयोग किया जा रहा है। पहले सभी सर्वर से अनलिंक करें।';
  }

  @override
  String get sshKeyDeleteTitle => 'SSH कुंजी हटाएँ';

  @override
  String sshKeyDeleteMessage(String name) {
    return '\"$name\" हटाएँ? यह पूर्ववत नहीं किया जा सकता।';
  }

  @override
  String get sshKeyAddButton => 'SSH कुंजी जोड़ें';

  @override
  String get sshKeyFormTitleEdit => 'SSH कुंजी संपादित करें';

  @override
  String get sshKeyFormTitleAdd => 'SSH कुंजी जोड़ें';

  @override
  String get sshKeyFormTabGenerate => 'जनरेट करें';

  @override
  String get sshKeyFormTabImport => 'आयात करें';

  @override
  String get sshKeyFormNameLabel => 'कुंजी का नाम';

  @override
  String get sshKeyFormNameHint => 'उदा. मेरी प्रोडक्शन कुंजी';

  @override
  String get sshKeyFormKeyType => 'कुंजी का प्रकार';

  @override
  String get sshKeyFormKeySize => 'कुंजी का आकार';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits बिट';
  }

  @override
  String get sshKeyFormCommentLabel => 'टिप्पणी';

  @override
  String get sshKeyFormCommentHint => 'user@host या विवरण';

  @override
  String get sshKeyFormCommentOptional => 'टिप्पणी (वैकल्पिक)';

  @override
  String get sshKeyFormImportFromFile => 'फ़ाइल से आयात करें';

  @override
  String get sshKeyFormPrivateKeyLabel => 'निजी कुंजी';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'SSH निजी कुंजी पेस्ट करें या ऊपर के बटन का उपयोग करें...';

  @override
  String get sshKeyFormPassphraseLabel => 'पासफ़्रेज़ (वैकल्पिक)';

  @override
  String get sshKeyFormNameRequired => 'नाम आवश्यक है';

  @override
  String get sshKeyFormPrivateKeyRequired => 'निजी कुंजी आवश्यक है';

  @override
  String get sshKeyFormFileReadError => 'चयनित फ़ाइल पढ़ नहीं सकी';

  @override
  String get sshKeyFormInvalidFormat =>
      'अमान्य कुंजी फ़ाइल — PEM प्रारूप अपेक्षित (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'फ़ाइल पढ़ने में विफल: $message';
  }

  @override
  String get sshKeyFormSaving => 'सहेजा जा रहा है...';

  @override
  String get sshKeySelectorLabel => 'SSH कुंजी';

  @override
  String get sshKeySelectorNone => 'कोई प्रबंधित कुंजी नहीं';

  @override
  String get sshKeySelectorManage => 'कुंजियाँ प्रबंधित करें...';

  @override
  String get sshKeySelectorError => 'SSH कुंजियाँ लोड करने में विफल';

  @override
  String get sshKeyTileCopyPublicKey => 'सार्वजनिक कुंजी कॉपी करें';

  @override
  String get sshKeyTilePublicKeyCopied => 'सार्वजनिक कुंजी कॉपी की गई';

  @override
  String sshKeyTileLinkedServers(int count) {
    return '$count सर्वर द्वारा उपयोग किया जा रहा है';
  }

  @override
  String get sshKeyTileUnlinkFirst => 'पहले सभी सर्वर से अनलिंक करें';

  @override
  String get exportImportTitle => 'निर्यात / आयात';

  @override
  String get exportSectionTitle => 'निर्यात';

  @override
  String get exportJsonButton =>
      'JSON के रूप में निर्यात करें (क्रेडेंशियल के बिना)';

  @override
  String get exportZipButton =>
      'एन्क्रिप्टेड ZIP निर्यात करें (क्रेडेंशियल सहित)';

  @override
  String get importSectionTitle => 'आयात';

  @override
  String get importButton => 'फ़ाइल से आयात करें';

  @override
  String get importSupportedFormats =>
      'JSON (सादा) और ZIP (एन्क्रिप्टेड) फ़ाइलें समर्थित हैं।';

  @override
  String exportedTo(String path) {
    return 'निर्यात किया गया: $path';
  }

  @override
  String get share => 'साझा करें';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers सर्वर, $groups समूह, $tags टैग आयात किए गए। $skipped छोड़े गए।';
  }

  @override
  String get importPasswordTitle => 'पासवर्ड दर्ज करें';

  @override
  String get importPasswordLabel => 'निर्यात पासवर्ड';

  @override
  String get importPasswordDecrypt => 'डिक्रिप्ट करें';

  @override
  String get exportPasswordTitle => 'निर्यात पासवर्ड सेट करें';

  @override
  String get exportPasswordDescription =>
      'यह पासवर्ड आपकी निर्यात फ़ाइल को क्रेडेंशियल सहित एन्क्रिप्ट करने के लिए उपयोग किया जाएगा।';

  @override
  String get exportPasswordLabel => 'पासवर्ड';

  @override
  String get exportPasswordConfirmLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get exportPasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get exportPasswordButton => 'एन्क्रिप्ट करें और निर्यात करें';

  @override
  String get importConflictTitle => 'विरोध संभालें';

  @override
  String get importConflictDescription =>
      'आयात के दौरान मौजूदा प्रविष्टियों को कैसे संभालना चाहिए?';

  @override
  String get importConflictSkip => 'मौजूदा छोड़ें';

  @override
  String get importConflictRename => 'नए का नाम बदलें';

  @override
  String get importConflictOverwrite => 'ओवरराइट करें';

  @override
  String get confirmDeleteLabel => 'हटाएँ';

  @override
  String get keyGenTitle => 'SSH कुंजी जोड़ी जनरेट करें';

  @override
  String get keyGenKeyType => 'कुंजी का प्रकार';

  @override
  String get keyGenKeySize => 'कुंजी का आकार';

  @override
  String get keyGenComment => 'टिप्पणी';

  @override
  String get keyGenCommentHint => 'user@host या विवरण';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits बिट';
  }

  @override
  String get keyGenGenerating => 'जनरेट हो रहा है...';

  @override
  String get keyGenGenerate => 'जनरेट करें';

  @override
  String keyGenResultTitle(String type) {
    return '$type कुंजी जनरेट की गई';
  }

  @override
  String get keyGenPublicKey => 'सार्वजनिक कुंजी';

  @override
  String get keyGenPrivateKey => 'निजी कुंजी';

  @override
  String keyGenCommentInfo(String comment) {
    return 'टिप्पणी: $comment';
  }

  @override
  String get keyGenAnother => 'एक और जनरेट करें';

  @override
  String get keyGenUseThisKey => 'यह कुंजी उपयोग करें';

  @override
  String get keyGenCopyTooltip => 'क्लिपबोर्ड पर कॉपी करें';

  @override
  String keyGenCopied(String label) {
    return '$label कॉपी किया गया';
  }

  @override
  String get colorPickerLabel => 'रंग';

  @override
  String get iconPickerLabel => 'आइकन';

  @override
  String get tagSelectorLabel => 'टैग';

  @override
  String get tagSelectorEmpty => 'अभी कोई टैग नहीं';

  @override
  String get tagSelectorError => 'टैग लोड करने में विफल';

  @override
  String get snippetListTitle => 'स्निपेट';

  @override
  String get snippetSearchHint => 'स्निपेट खोजें...';

  @override
  String get snippetListEmpty => 'अभी कोई स्निपेट नहीं';

  @override
  String get snippetListEmptySubtitle =>
      'पुन: उपयोग योग्य कोड स्निपेट और कमांड बनाएँ।';

  @override
  String get snippetAddButton => 'स्निपेट जोड़ें';

  @override
  String get snippetDeleteTitle => 'स्निपेट हटाएँ';

  @override
  String snippetDeleteMessage(String name) {
    return '\"$name\" हटाएँ? यह पूर्ववत नहीं किया जा सकता।';
  }

  @override
  String get snippetFormTitleEdit => 'स्निपेट संपादित करें';

  @override
  String get snippetFormTitleNew => 'नया स्निपेट';

  @override
  String get snippetFormNameLabel => 'नाम';

  @override
  String get snippetFormNameHint => 'उदा. Docker क्लीनअप';

  @override
  String get snippetFormLanguageLabel => 'भाषा';

  @override
  String get snippetFormContentLabel => 'सामग्री';

  @override
  String get snippetFormContentHint => 'अपना स्निपेट कोड दर्ज करें...';

  @override
  String get snippetFormDescriptionLabel => 'विवरण';

  @override
  String get snippetFormDescriptionHint => 'वैकल्पिक विवरण...';

  @override
  String get snippetFormFolderLabel => 'फ़ोल्डर';

  @override
  String get snippetFormNoFolder => 'कोई फ़ोल्डर नहीं';

  @override
  String get snippetFormNameRequired => 'नाम आवश्यक है';

  @override
  String get snippetFormContentRequired => 'सामग्री आवश्यक है';

  @override
  String get snippetFormUpdateButton => 'स्निपेट अपडेट करें';

  @override
  String get snippetFormCreateButton => 'स्निपेट बनाएँ';

  @override
  String get snippetDetailTitle => 'स्निपेट विवरण';

  @override
  String get snippetDetailDeleteTitle => 'स्निपेट हटाएँ';

  @override
  String get snippetDetailDeleteMessage => 'यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get snippetDetailContent => 'सामग्री';

  @override
  String get snippetDetailFillVariables => 'चर भरें';

  @override
  String get snippetDetailDescription => 'विवरण';

  @override
  String get snippetDetailVariables => 'चर';

  @override
  String get snippetDetailTags => 'टैग';

  @override
  String get snippetDetailInfo => 'जानकारी';

  @override
  String get snippetDetailCreated => 'बनाया गया';

  @override
  String get snippetDetailUpdated => 'अपडेट किया गया';

  @override
  String get variableEditorTitle => 'टेम्पलेट चर';

  @override
  String get variableEditorAdd => 'जोड़ें';

  @override
  String get variableEditorEmpty =>
      'कोई चर नहीं। सामग्री में कर्ली-ब्रेस सिंटैक्स का उपयोग करके उन्हें संदर्भित करें।';

  @override
  String get variableEditorNameLabel => 'नाम';

  @override
  String get variableEditorNameHint => 'उदा. hostname';

  @override
  String get variableEditorDefaultLabel => 'डिफ़ॉल्ट';

  @override
  String get variableEditorDefaultHint => 'वैकल्पिक';

  @override
  String get variableFillTitle => 'चर भरें';

  @override
  String variableFillHint(String name) {
    return '$name के लिए मान दर्ज करें';
  }

  @override
  String get variableFillPreview => 'पूर्वावलोकन';

  @override
  String get terminalTitle => 'टर्मिनल';

  @override
  String get terminalEmpty => 'कोई सक्रिय सत्र नहीं';

  @override
  String get terminalEmptySubtitle =>
      'टर्मिनल सत्र खोलने के लिए होस्ट से कनेक्ट करें।';

  @override
  String get terminalGoToHosts => 'होस्ट पर जाएँ';

  @override
  String get terminalCloseAll => 'सभी सत्र बंद करें';

  @override
  String get terminalCloseTitle => 'सत्र बंद करें';

  @override
  String terminalCloseMessage(String title) {
    return '\"$title\" से सक्रिय कनेक्शन बंद करें?';
  }

  @override
  String get connectionAuthenticating => 'प्रमाणीकरण हो रहा है...';

  @override
  String connectionConnecting(String name) {
    return '$name से कनेक्ट हो रहा है...';
  }

  @override
  String get connectionError => 'कनेक्शन त्रुटि';

  @override
  String get connectionLost => 'कनेक्शन खो गया';

  @override
  String get connectionReconnect => 'पुनः कनेक्ट करें';

  @override
  String get snippetQuickPanelTitle => 'स्निपेट डालें';

  @override
  String get snippetQuickPanelSearch => 'स्निपेट खोजें...';

  @override
  String get snippetQuickPanelEmpty => 'कोई स्निपेट उपलब्ध नहीं';

  @override
  String get snippetQuickPanelNoMatch => 'कोई मिलता-जुलता स्निपेट नहीं';

  @override
  String get snippetQuickPanelInsertTooltip => 'स्निपेट डालें';

  @override
  String get terminalThemePickerTitle => 'टर्मिनल थीम';

  @override
  String get validatorHostnameRequired => 'होस्टनाम आवश्यक है';

  @override
  String get validatorHostnameInvalid => 'अमान्य होस्टनाम या IP पता';

  @override
  String get validatorPortRequired => 'पोर्ट आवश्यक है';

  @override
  String get validatorPortRange => 'पोर्ट 1 और 65535 के बीच होना चाहिए';

  @override
  String get validatorUsernameRequired => 'उपयोगकर्ता नाम आवश्यक है';

  @override
  String get validatorUsernameInvalid => 'अमान्य उपयोगकर्ता नाम प्रारूप';

  @override
  String get validatorServerNameRequired => 'सर्वर का नाम आवश्यक है';

  @override
  String get validatorServerNameLength =>
      'सर्वर का नाम 100 अक्षर या कम होना चाहिए';

  @override
  String get validatorSshKeyInvalid => 'अमान्य SSH कुंजी प्रारूप';

  @override
  String get validatorPasswordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get validatorPasswordLength =>
      'पासवर्ड कम से कम 8 अक्षर का होना चाहिए';

  @override
  String get authMethodPassword => 'पासवर्ड';

  @override
  String get authMethodKey => 'SSH कुंजी';

  @override
  String get authMethodBoth => 'पासवर्ड + कुंजी';

  @override
  String get serverCopySuffix => '(कॉपी)';

  @override
  String get settingsDownloadLogs => 'लॉग डाउनलोड करें';

  @override
  String get settingsSendLogs => 'सपोर्ट को लॉग भेजें';

  @override
  String get settingsLogsSaved => 'लॉग सफलतापूर्वक सहेजे गए';

  @override
  String get settingsLogsEmpty => 'कोई लॉग प्रविष्टियाँ उपलब्ध नहीं';

  @override
  String get authLogin => 'लॉगिन';

  @override
  String get authRegister => 'रजिस्टर करें';

  @override
  String get authForgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get authWhyLogin =>
      'अपने सभी उपकरणों पर एन्क्रिप्टेड क्लाउड सिंक सक्षम करने के लिए साइन इन करें। ऐप बिना अकाउंट के पूरी तरह ऑफ़लाइन काम करता है।';

  @override
  String get authEmailLabel => 'ईमेल';

  @override
  String get authEmailRequired => 'ईमेल आवश्यक है';

  @override
  String get authEmailInvalid => 'अमान्य ईमेल पता';

  @override
  String get authPasswordLabel => 'पासवर्ड';

  @override
  String get authConfirmPasswordLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get authPasswordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get authNoAccount => 'अकाउंट नहीं है?';

  @override
  String get authHasAccount => 'पहले से अकाउंट है?';

  @override
  String get authSelfHosted => 'सेल्फ़-होस्टेड सर्वर';

  @override
  String get authResetEmailSent =>
      'यदि अकाउंट मौजूद है, तो आपके ईमेल पर रीसेट लिंक भेजा गया है।';

  @override
  String get authResetDescription =>
      'अपना ईमेल पता दर्ज करें और हम आपको पासवर्ड रीसेट करने का लिंक भेजेंगे।';

  @override
  String get authSendResetLink => 'रीसेट लिंक भेजें';

  @override
  String get authBackToLogin => 'लॉगिन पर वापस जाएँ';

  @override
  String get syncPasswordTitle => 'सिंक पासवर्ड';

  @override
  String get syncPasswordTitleCreate => 'सिंक पासवर्ड सेट करें';

  @override
  String get syncPasswordTitleEnter => 'सिंक पासवर्ड दर्ज करें';

  @override
  String get syncPasswordDescription =>
      'अपने वॉल्ट डेटा को एन्क्रिप्ट करने के लिए एक अलग पासवर्ड सेट करें। यह पासवर्ड कभी भी आपका डिवाइस नहीं छोड़ता — सर्वर केवल एन्क्रिप्टेड डेटा संग्रहीत करता है।';

  @override
  String get syncPasswordHintEnter =>
      'अकाउंट बनाते समय सेट किया गया पासवर्ड दर्ज करें।';

  @override
  String get syncPasswordWarning =>
      'यदि आप यह पासवर्ड भूल जाते हैं, तो आपका सिंक किया गया डेटा पुनर्प्राप्त नहीं किया जा सकता। कोई रीसेट विकल्प नहीं है।';

  @override
  String get syncPasswordLabel => 'सिंक पासवर्ड';

  @override
  String get syncPasswordWrong => 'गलत पासवर्ड। कृपया पुनः प्रयास करें।';

  @override
  String get firstSyncTitle => 'मौजूदा डेटा मिला';

  @override
  String get firstSyncMessage =>
      'इस डिवाइस पर मौजूदा डेटा है और सर्वर पर वॉल्ट है। कैसे आगे बढ़ें?';

  @override
  String get firstSyncMerge => 'मर्ज करें (सर्वर प्राथमिक)';

  @override
  String get firstSyncOverwriteLocal => 'स्थानीय डेटा ओवरराइट करें';

  @override
  String get firstSyncKeepLocal => 'स्थानीय रखें और पुश करें';

  @override
  String get firstSyncDeleteLocal => 'स्थानीय हटाएँ और पुल करें';

  @override
  String get changeEncryptionPassword => 'एन्क्रिप्शन पासवर्ड बदलें';

  @override
  String get changeEncryptionWarning =>
      'आप अन्य सभी उपकरणों से लॉग आउट हो जाएँगे।';

  @override
  String get changeEncryptionOldPassword => 'वर्तमान पासवर्ड';

  @override
  String get changeEncryptionNewPassword => 'नया पासवर्ड';

  @override
  String get changeEncryptionSuccess => 'पासवर्ड सफलतापूर्वक बदला गया।';

  @override
  String get logoutAllDevices => 'सभी उपकरणों से लॉग आउट करें';

  @override
  String get logoutAllDevicesConfirm =>
      'यह सभी सक्रिय सत्रों को रद्द कर देगा। आपको सभी उपकरणों पर फिर से लॉगिन करना होगा।';

  @override
  String get logoutAllDevicesSuccess => 'सभी उपकरणों से लॉग आउट किया गया।';

  @override
  String get syncSettingsTitle => 'सिंक सेटिंग्स';

  @override
  String get syncAutoSync => 'ऑटो-सिंक';

  @override
  String get syncAutoSyncDescription =>
      'ऐप शुरू होने पर स्वचालित रूप से सिंक करें';

  @override
  String get syncNow => 'अभी सिंक करें';

  @override
  String get syncSyncing => 'सिंक हो रहा है...';

  @override
  String get syncSuccess => 'सिंक पूर्ण';

  @override
  String get syncError => 'सिंक त्रुटि';

  @override
  String get syncServerUnreachable => 'सर्वर पहुँच योग्य नहीं';

  @override
  String get syncServerUnreachableHint =>
      'सिंक सर्वर तक नहीं पहुँचा जा सका। अपना इंटरनेट कनेक्शन और सर्वर URL जाँचें।';

  @override
  String get syncNetworkError =>
      'सर्वर से कनेक्शन विफल। कृपया अपना इंटरनेट कनेक्शन जाँचें या बाद में पुनः प्रयास करें।';

  @override
  String get syncNeverSynced => 'कभी सिंक नहीं किया गया';

  @override
  String get syncVaultVersion => 'वॉल्ट संस्करण';

  @override
  String get syncTitle => 'सिंक';

  @override
  String get settingsSectionNetwork => 'नेटवर्क और DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS सर्वर';

  @override
  String get settingsDnsDefault => 'डिफ़ॉल्ट (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'कस्टम DoH सर्वर URL दर्ज करें, कॉमा से अलग। क्रॉस-चेक सत्यापन के लिए कम से कम 2 सर्वर आवश्यक हैं।';

  @override
  String get settingsDnsLabel => 'DoH सर्वर URL';

  @override
  String get settingsDnsReset => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get settingsSectionSync => 'सिंक्रोनाइज़ेशन';

  @override
  String get settingsSyncAccount => 'अकाउंट';

  @override
  String get settingsSyncNotLoggedIn => 'लॉगिन नहीं है';

  @override
  String get settingsSyncStatus => 'सिंक';

  @override
  String get settingsSyncServerUrl => 'सर्वर URL';

  @override
  String get settingsSyncDefaultServer => 'डिफ़ॉल्ट (sshvault.app)';

  @override
  String get accountTitle => 'अकाउंट';

  @override
  String get accountNotLoggedIn => 'लॉगिन नहीं है';

  @override
  String get accountVerified => 'सत्यापित';

  @override
  String get accountMemberSince => 'सदस्य';

  @override
  String get accountDevices => 'उपकरण';

  @override
  String get accountNoDevices => 'कोई उपकरण पंजीकृत नहीं';

  @override
  String get accountLastSync => 'अंतिम सिंक';

  @override
  String get accountChangePassword => 'पासवर्ड बदलें';

  @override
  String get accountOldPassword => 'वर्तमान पासवर्ड';

  @override
  String get accountNewPassword => 'नया पासवर्ड';

  @override
  String get accountDeleteAccount => 'अकाउंट हटाएँ';

  @override
  String get accountDeleteWarning =>
      'यह आपके अकाउंट और सभी सिंक किए गए डेटा को स्थायी रूप से हटा देगा। यह पूर्ववत नहीं किया जा सकता।';

  @override
  String get accountLogout => 'लॉग आउट';

  @override
  String get serverConfigTitle => 'सर्वर कॉन्फ़िगरेशन';

  @override
  String get serverConfigSelfHosted => 'सेल्फ़-होस्टेड';

  @override
  String get serverConfigSelfHostedDescription =>
      'अपना SSHVault सर्वर उपयोग करें';

  @override
  String get serverConfigUrlLabel => 'सर्वर URL';

  @override
  String get serverConfigTest => 'कनेक्शन टेस्ट करें';

  @override
  String get auditLogTitle => 'गतिविधि लॉग';

  @override
  String get auditLogAll => 'सभी';

  @override
  String get auditLogEmpty => 'कोई गतिविधि लॉग नहीं मिले';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'फ़ाइल प्रबंधक';

  @override
  String get sftpLocalDevice => 'स्थानीय डिवाइस';

  @override
  String get sftpSelectServer => 'सर्वर चुनें...';

  @override
  String get sftpConnecting => 'कनेक्ट हो रहा है...';

  @override
  String get sftpEmptyDirectory => 'यह डायरेक्टरी खाली है';

  @override
  String get sftpNoConnection => 'कोई सर्वर कनेक्ट नहीं है';

  @override
  String get sftpPathLabel => 'पथ';

  @override
  String get sftpUpload => 'अपलोड';

  @override
  String get sftpDownload => 'डाउनलोड';

  @override
  String get sftpDelete => 'हटाएँ';

  @override
  String get sftpRename => 'नाम बदलें';

  @override
  String get sftpNewFolder => 'नया फ़ोल्डर';

  @override
  String get sftpNewFolderName => 'फ़ोल्डर का नाम';

  @override
  String get sftpChmod => 'अनुमतियाँ';

  @override
  String get sftpChmodTitle => 'अनुमतियाँ बदलें';

  @override
  String get sftpChmodOctal => 'ऑक्टल';

  @override
  String get sftpChmodOwner => 'स्वामी';

  @override
  String get sftpChmodGroup => 'समूह';

  @override
  String get sftpChmodOther => 'अन्य';

  @override
  String get sftpChmodRead => 'पढ़ना';

  @override
  String get sftpChmodWrite => 'लिखना';

  @override
  String get sftpChmodExecute => 'निष्पादन';

  @override
  String get sftpCreateSymlink => 'सिमलिंक बनाएँ';

  @override
  String get sftpSymlinkTarget => 'लक्ष्य पथ';

  @override
  String get sftpSymlinkName => 'लिंक का नाम';

  @override
  String get sftpFilePreview => 'फ़ाइल पूर्वावलोकन';

  @override
  String get sftpFileInfo => 'फ़ाइल जानकारी';

  @override
  String get sftpFileSize => 'आकार';

  @override
  String get sftpFileModified => 'संशोधित';

  @override
  String get sftpFilePermissions => 'अनुमतियाँ';

  @override
  String get sftpFileOwner => 'स्वामी';

  @override
  String get sftpFileType => 'प्रकार';

  @override
  String get sftpFileLinkTarget => 'लिंक लक्ष्य';

  @override
  String get sftpTransfers => 'स्थानांतरण';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$total में से $current';
  }

  @override
  String get sftpTransferQueued => 'कतार में';

  @override
  String get sftpTransferActive => 'स्थानांतरित हो रहा है...';

  @override
  String get sftpTransferPaused => 'रुका हुआ';

  @override
  String get sftpTransferCompleted => 'पूर्ण';

  @override
  String get sftpTransferFailed => 'विफल';

  @override
  String get sftpTransferCancelled => 'रद्द किया गया';

  @override
  String get sftpPauseTransfer => 'रोकें';

  @override
  String get sftpResumeTransfer => 'फिर से शुरू करें';

  @override
  String get sftpCancelTransfer => 'रद्द करें';

  @override
  String get sftpClearCompleted => 'पूर्ण साफ़ करें';

  @override
  String sftpTransferCount(int active, int total) {
    return '$total में से $active स्थानांतरण';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय',
      one: '1 सक्रिय',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count पूर्ण',
      one: '1 पूर्ण',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count विफल',
      one: '1 विफल',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'दूसरे पैनल में कॉपी करें';

  @override
  String sftpConfirmDelete(int count) {
    return '$count आइटम हटाएँ?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return '\"$name\" हटाएँ?';
  }

  @override
  String get sftpDeleteSuccess => 'सफलतापूर्वक हटाया गया';

  @override
  String get sftpRenameTitle => 'नाम बदलें';

  @override
  String get sftpRenameLabel => 'नया नाम';

  @override
  String get sftpSortByName => 'नाम';

  @override
  String get sftpSortBySize => 'आकार';

  @override
  String get sftpSortByDate => 'तारीख';

  @override
  String get sftpSortByType => 'प्रकार';

  @override
  String get sftpShowHidden => 'छिपी फ़ाइलें दिखाएँ';

  @override
  String get sftpHideHidden => 'छिपी फ़ाइलें छिपाएँ';

  @override
  String get sftpSelectAll => 'सभी चुनें';

  @override
  String get sftpDeselectAll => 'सभी अचयनित करें';

  @override
  String sftpItemsSelected(int count) {
    return '$count चयनित';
  }

  @override
  String get sftpRefresh => 'रिफ़्रेश';

  @override
  String sftpConnectionError(String message) {
    return 'कनेक्शन विफल: $message';
  }

  @override
  String get sftpPermissionDenied => 'अनुमति अस्वीकृत';

  @override
  String sftpOperationFailed(String message) {
    return 'ऑपरेशन विफल: $message';
  }

  @override
  String get sftpOverwriteTitle => 'फ़ाइल पहले से मौजूद है';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" पहले से मौजूद है। ओवरराइट करें?';
  }

  @override
  String get sftpOverwrite => 'ओवरराइट करें';

  @override
  String sftpTransferStarted(String fileName) {
    return 'स्थानांतरण शुरू: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'पहले दूसरे पैनल में गंतव्य चुनें';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'डायरेक्टरी स्थानांतरण जल्द उपलब्ध';

  @override
  String get sftpSelect => 'चुनें';

  @override
  String get sftpOpen => 'खोलें';

  @override
  String get sftpExtractArchive => 'यहाँ निकालें';

  @override
  String get sftpExtractSuccess => 'आर्काइव निकाला गया';

  @override
  String sftpExtractFailed(String message) {
    return 'निकालना विफल: $message';
  }

  @override
  String get sftpExtractUnsupported => 'असमर्थित आर्काइव प्रारूप';

  @override
  String get sftpExtracting => 'निकाला जा रहा है...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अपलोड शुरू',
      one: 'अपलोड शुरू',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count डाउनलोड शुरू',
      one: 'डाउनलोड शुरू',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" डाउनलोड किया गया';
  }

  @override
  String get sftpSavedToDownloads => 'Downloads/SSHVault में सहेजा गया';

  @override
  String get sftpSaveToFiles => 'फ़ाइलों में सहेजें';

  @override
  String get sftpFileSaved => 'फ़ाइल सहेजी गई';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH सत्र सक्रिय',
      one: 'SSH सत्र सक्रिय',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'टर्मिनल खोलने के लिए टैप करें';

  @override
  String get settingsAccountAndSync => 'अकाउंट और सिंक';

  @override
  String get settingsAccountSubtitleAuth => 'साइन इन है';

  @override
  String get settingsAccountSubtitleUnauth => 'साइन इन नहीं है';

  @override
  String get settingsSecuritySubtitle => 'ऑटो-लॉक, बायोमेट्रिक्स, PIN';

  @override
  String get settingsSshSubtitle => 'पोर्ट 22, उपयोगकर्ता root';

  @override
  String get settingsAppearanceSubtitle => 'थीम, भाषा, टर्मिनल';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'एन्क्रिप्टेड निर्यात डिफ़ॉल्ट';

  @override
  String get settingsAboutSubtitle => 'संस्करण, लाइसेंस';

  @override
  String get settingsSearchHint => 'सेटिंग्स खोजें...';

  @override
  String get settingsSearchNoResults => 'कोई सेटिंग्स नहीं मिलीं';

  @override
  String get aboutDeveloper => 'Kiefer Networks द्वारा विकसित';

  @override
  String get aboutDonate => 'दान करें';

  @override
  String get aboutOpenSourceLicenses => 'ओपन सोर्स लाइसेंस';

  @override
  String get aboutWebsite => 'वेबसाइट';

  @override
  String get aboutVersion => 'संस्करण';

  @override
  String get aboutBuild => 'बिल्ड';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS DNS क्वेरीज़ को एन्क्रिप्ट करता है और DNS स्पूफ़िंग को रोकता है। SSHVault हमलों का पता लगाने के लिए कई प्रदाताओं के विरुद्ध होस्टनाम की जाँच करता है।';

  @override
  String get settingsDnsAddServer => 'DNS सर्वर जोड़ें';

  @override
  String get settingsDnsServerUrl => 'सर्वर URL';

  @override
  String get settingsDnsDefaultBadge => 'डिफ़ॉल्ट';

  @override
  String get settingsDnsResetDefaults => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get settingsDnsInvalidUrl => 'कृपया एक वैध HTTPS URL दर्ज करें';

  @override
  String get settingsDefaultAuthMethod => 'प्रमाणीकरण विधि';

  @override
  String get settingsAuthPassword => 'पासवर्ड';

  @override
  String get settingsAuthKey => 'SSH कुंजी';

  @override
  String get settingsConnectionTimeout => 'कनेक्शन टाइमआउट';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Keep-Alive अंतराल';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'संपीड़न';

  @override
  String get settingsCompressionDescription =>
      'SSH कनेक्शन के लिए zlib संपीड़न सक्षम करें';

  @override
  String get settingsTerminalType => 'टर्मिनल प्रकार';

  @override
  String get settingsSectionConnection => 'कनेक्शन';

  @override
  String get settingsClipboardAutoClear => 'क्लिपबोर्ड ऑटो-क्लीयर';

  @override
  String get settingsClipboardAutoClearOff => 'बंद';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'सत्र टाइमआउट';

  @override
  String get settingsSessionTimeoutOff => 'बंद';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get settingsDuressPin => 'आपातकालीन PIN';

  @override
  String get settingsDuressPinDescription =>
      'एक अलग PIN जो दर्ज करने पर सभी डेटा मिटा देता है';

  @override
  String get settingsDuressPinSet => 'आपातकालीन PIN सेट है';

  @override
  String get settingsDuressPinNotSet => 'कॉन्फ़िगर नहीं है';

  @override
  String get settingsDuressPinWarning =>
      'यह PIN दर्ज करने से क्रेडेंशियल, कुंजियाँ और सेटिंग्स सहित सभी स्थानीय डेटा स्थायी रूप से हटा दिया जाएगा। यह पूर्ववत नहीं किया जा सकता।';

  @override
  String get settingsKeyRotationReminder => 'कुंजी रोटेशन अनुस्मारक';

  @override
  String get settingsKeyRotationOff => 'बंद';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days दिन';
  }

  @override
  String get settingsFailedAttempts => 'विफल PIN प्रयास';

  @override
  String get settingsSectionAppLock => 'ऐप लॉक';

  @override
  String get settingsSectionPrivacy => 'गोपनीयता';

  @override
  String get settingsSectionReminders => 'अनुस्मारक';

  @override
  String get settingsSectionStatus => 'स्थिति';

  @override
  String get settingsExportBackupSubtitle => 'निर्यात, आयात और बैकअप';

  @override
  String get settingsExportJson => 'JSON के रूप में निर्यात करें';

  @override
  String get settingsExportEncrypted => 'एन्क्रिप्टेड निर्यात करें';

  @override
  String get settingsImportFile => 'फ़ाइल से आयात करें';

  @override
  String get settingsSectionImport => 'आयात';

  @override
  String get filterTitle => 'सर्वर फ़िल्टर करें';

  @override
  String get filterApply => 'फ़िल्टर लागू करें';

  @override
  String get filterClearAll => 'सभी साफ़ करें';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count फ़िल्टर सक्रिय',
      one: '1 फ़िल्टर सक्रिय',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'फ़ोल्डर';

  @override
  String get filterTags => 'टैग';

  @override
  String get filterStatus => 'स्थिति';

  @override
  String get variablePreviewResolved => 'हल किया गया पूर्वावलोकन';

  @override
  String get variableInsert => 'डालें';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सर्वर',
      one: '1 सर्वर',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सत्र रद्द किए गए।',
      one: '1 सत्र रद्द किया गया।',
    );
    return '$_temp0 आपको लॉग आउट कर दिया गया है।';
  }

  @override
  String get keyGenPassphrase => 'पासफ़्रेज़';

  @override
  String get keyGenPassphraseHint => 'वैकल्पिक — निजी कुंजी की सुरक्षा करता है';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'डिफ़ॉल्ट (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'समान फ़िंगरप्रिंट वाली कुंजी पहले से मौजूद है: \"$name\"। प्रत्येक SSH कुंजी अद्वितीय होनी चाहिए।';
  }

  @override
  String get sshKeyFingerprint => 'फ़िंगरप्रिंट';

  @override
  String get sshKeyPublicKey => 'सार्वजनिक कुंजी';

  @override
  String get jumpHost => 'जम्प होस्ट';

  @override
  String get jumpHostNone => 'कोई नहीं';

  @override
  String get jumpHostLabel => 'जम्प होस्ट के माध्यम से कनेक्ट करें';

  @override
  String get jumpHostSelfError => 'सर्वर अपना स्वयं का जम्प होस्ट नहीं हो सकता';

  @override
  String get jumpHostConnecting => 'जम्प होस्ट से कनेक्ट हो रहा है…';

  @override
  String get jumpHostCircularError => 'चक्रीय जम्प होस्ट श्रृंखला पाई गई';

  @override
  String get logoutDialogTitle => 'लॉग आउट';

  @override
  String get logoutDialogMessage =>
      'क्या आप सभी स्थानीय डेटा हटाना चाहते हैं? सर्वर, SSH कुंजियाँ, स्निपेट और सेटिंग्स इस डिवाइस से हटा दिए जाएँगे।';

  @override
  String get logoutOnly => 'केवल लॉग आउट करें';

  @override
  String get logoutAndDelete => 'लॉग आउट करें और डेटा हटाएँ';

  @override
  String get changeAvatar => 'अवतार बदलें';

  @override
  String get removeAvatar => 'अवतार हटाएँ';

  @override
  String get avatarUploadFailed => 'अवतार अपलोड करने में विफल';

  @override
  String get avatarTooLarge => 'छवि बहुत बड़ी है';

  @override
  String get deviceLastSeen => 'अंतिम बार देखा गया';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'लॉगिन होने पर सर्वर URL नहीं बदला जा सकता। पहले लॉग आउट करें।';

  @override
  String get serverListNoFolder => 'अवर्गीकृत';

  @override
  String get autoSyncInterval => 'सिंक अंतराल';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get proxySettings => 'प्रॉक्सी सेटिंग्स';

  @override
  String get proxyType => 'प्रॉक्सी प्रकार';

  @override
  String get proxyNone => 'कोई प्रॉक्सी नहीं';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'प्रॉक्सी होस्ट';

  @override
  String get proxyPort => 'प्रॉक्सी पोर्ट';

  @override
  String get proxyUsername => 'प्रॉक्सी उपयोगकर्ता नाम';

  @override
  String get proxyPassword => 'प्रॉक्सी पासवर्ड';

  @override
  String get proxyUseGlobal => 'वैश्विक प्रॉक्सी उपयोग करें';

  @override
  String get proxyGlobal => 'वैश्विक';

  @override
  String get proxyServerSpecific => 'सर्वर-विशिष्ट';

  @override
  String get proxyTestConnection => 'कनेक्शन टेस्ट करें';

  @override
  String get proxyTestSuccess => 'प्रॉक्सी पहुँच योग्य';

  @override
  String get proxyTestFailed => 'प्रॉक्सी पहुँच योग्य नहीं';

  @override
  String get proxyDefaultProxy => 'डिफ़ॉल्ट प्रॉक्सी';

  @override
  String get vpnRequired => 'VPN आवश्यक';

  @override
  String get vpnRequiredTooltip =>
      'सक्रिय VPN के बिना कनेक्ट करते समय चेतावनी दिखाएँ';

  @override
  String get vpnActive => 'VPN सक्रिय';

  @override
  String get vpnInactive => 'VPN निष्क्रिय';

  @override
  String get vpnWarningTitle => 'VPN सक्रिय नहीं';

  @override
  String get vpnWarningMessage =>
      'यह सर्वर VPN कनेक्शन आवश्यक के रूप में चिह्नित है, लेकिन वर्तमान में कोई VPN सक्रिय नहीं है। क्या आप फिर भी कनेक्ट करना चाहते हैं?';

  @override
  String get vpnConnectAnyway => 'फिर भी कनेक्ट करें';

  @override
  String get postConnectCommands => 'कनेक्शन के बाद कमांड';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'कनेक्शन के बाद स्वचालित रूप से निष्पादित होने वाली कमांड (प्रति पंक्ति एक)';

  @override
  String get dashboardFavorites => 'पसंदीदा';

  @override
  String get dashboardRecent => 'हाल के';

  @override
  String get dashboardActiveSessions => 'सक्रिय सत्र';

  @override
  String get addToFavorites => 'पसंदीदा में जोड़ें';

  @override
  String get removeFromFavorites => 'पसंदीदा से हटाएँ';

  @override
  String get noRecentConnections => 'कोई हाल के कनेक्शन नहीं';

  @override
  String get terminalSplit => 'विभाजित दृश्य';

  @override
  String get terminalUnsplit => 'विभाजन बंद करें';

  @override
  String get terminalSelectSession => 'विभाजित दृश्य के लिए सत्र चुनें';

  @override
  String get knownHostsTitle => 'ज्ञात होस्ट';

  @override
  String get knownHostsSubtitle => 'विश्वसनीय सर्वर फ़िंगरप्रिंट प्रबंधित करें';

  @override
  String get hostKeyNewTitle => 'नया होस्ट';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return '$hostname:$port से पहला कनेक्शन। कनेक्ट करने से पहले फ़िंगरप्रिंट सत्यापित करें।';
  }

  @override
  String get hostKeyChangedTitle => 'होस्ट कुंजी बदली!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return '$hostname:$port की होस्ट कुंजी बदल गई है। यह सुरक्षा खतरे का संकेत हो सकता है।';
  }

  @override
  String get hostKeyFingerprint => 'फ़िंगरप्रिंट';

  @override
  String get hostKeyType => 'कुंजी प्रकार';

  @override
  String get hostKeyTrustConnect => 'विश्वास करें और कनेक्ट करें';

  @override
  String get hostKeyAcceptNew => 'नई कुंजी स्वीकार करें';

  @override
  String get hostKeyReject => 'अस्वीकार करें';

  @override
  String get hostKeyPreviousFingerprint => 'पिछला फ़िंगरप्रिंट';

  @override
  String get hostKeyDeleteAll => 'सभी ज्ञात होस्ट हटाएँ';

  @override
  String get hostKeyDeleteConfirm =>
      'क्या आप वाकई सभी ज्ञात होस्ट हटाना चाहते हैं? अगले कनेक्शन पर आपसे फिर पूछा जाएगा।';

  @override
  String get hostKeyEmpty => 'अभी कोई ज्ञात होस्ट नहीं';

  @override
  String get hostKeyEmptySubtitle =>
      'आपके पहले कनेक्शन के बाद होस्ट फ़िंगरप्रिंट यहाँ संग्रहीत किए जाएँगे';

  @override
  String get hostKeyFirstSeen => 'पहली बार देखा गया';

  @override
  String get hostKeyLastSeen => 'अंतिम बार देखा गया';

  @override
  String get sshConfigImportPickFile => 'SSH कॉन्फ़िग फ़ाइल चुनें';

  @override
  String get sshConfigImportOrPaste => 'या कॉन्फ़िग सामग्री पेस्ट करें';

  @override
  String sshConfigImportParsed(int count) {
    return '$count होस्ट मिले';
  }

  @override
  String get sshConfigImportDuplicate => 'पहले से मौजूद है';

  @override
  String get sshConfigImportNoHosts => 'कॉन्फ़िग में कोई होस्ट नहीं मिले';

  @override
  String get sftpBookmarkAdd => 'बुकमार्क जोड़ें';

  @override
  String get sftpBookmarkLabel => 'लेबल';

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String get reportAndDisconnect => 'रिपोर्ट करें और डिस्कनेक्ट करें';

  @override
  String get continueAnyway => 'फिर भी जारी रखें';

  @override
  String get insertSnippet => 'स्निपेट डालें';

  @override
  String get seconds => 'सेकंड';

  @override
  String get heartbeatLostMessage =>
      'कई प्रयासों के बाद सर्वर तक नहीं पहुँचा जा सका। आपकी सुरक्षा के लिए, सत्र समाप्त कर दिया गया है।';

  @override
  String get attestationFailedTitle => 'सर्वर सत्यापन विफल';

  @override
  String get attestationFailedMessage =>
      'सर्वर को वैध SSHVault बैकएंड के रूप में सत्यापित नहीं किया जा सका। यह मैन-इन-द-मिडल हमले या गलत कॉन्फ़िगर किए गए सर्वर का संकेत हो सकता है।';

  @override
  String get attestationKeyChangedTitle => 'सर्वर अटेस्टेशन कुंजी बदली';

  @override
  String get attestationKeyChangedMessage =>
      'प्रारंभिक कनेक्शन के बाद से सर्वर की अटेस्टेशन कुंजी बदल गई है। यह मैन-इन-द-मिडल हमले का संकेत हो सकता है। जब तक सर्वर प्रशासक ने कुंजी रोटेशन की पुष्टि नहीं की है, तब तक जारी न रखें।';

  @override
  String get sectionLinks => 'लिंक';

  @override
  String get sectionDeveloper => 'डेवलपर';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'पृष्ठ नहीं मिला';

  @override
  String get connectionTestSuccess => 'कनेक्शन सफल';

  @override
  String connectionTestFailed(String message) {
    return 'कनेक्शन विफल: $message';
  }

  @override
  String get serverVerificationFailed => 'सर्वर सत्यापन विफल';

  @override
  String get importSuccessful => 'आयात सफल';

  @override
  String get hintExampleServerUrl => 'https://your-server.example.com';

  @override
  String get hintExampleDohUrl => 'https://dns.example.com/dns-query';

  @override
  String get hintExampleProxyHost => '192.168.1.1';

  @override
  String get hintExampleProxyPort => '1080';

  @override
  String get hintExampleTimeoutSeconds => '30';

  @override
  String get hintExampleKeepaliveSeconds => '15';

  @override
  String jumpHostEntryLabel(String name, String hostname) {
    return '$name ($hostname)';
  }

  @override
  String sshKeyEntryLabel(String name, String keyType) {
    return '$name ($keyType)';
  }

  @override
  String hostPortLabel(String hostname, int port) {
    return '$hostname:$port';
  }
}
