// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Διακομιστές';

  @override
  String get navSnippets => 'Αποσπάσματα';

  @override
  String get navFolders => 'Φάκελοι';

  @override
  String get navTags => 'Ετικέτες';

  @override
  String get navSshKeys => 'Κλειδιά SSH';

  @override
  String get navExportImport => 'Εξαγωγή / Εισαγωγή';

  @override
  String get navTerminal => 'Τερματικό';

  @override
  String get navMore => 'Περισσότερα';

  @override
  String get navManagement => 'Διαχείριση';

  @override
  String get navSettings => 'Ρυθμίσεις';

  @override
  String get navAbout => 'Σχετικά';

  @override
  String get lockScreenTitle => 'Το SSHVault είναι κλειδωμένο';

  @override
  String get lockScreenUnlock => 'Ξεκλείδωμα';

  @override
  String get lockScreenEnterPin => 'Εισάγετε PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Πάρα πολλές αποτυχημένες προσπάθειες. Δοκιμάστε ξανά σε $minutes λεπτά.';
  }

  @override
  String get pinDialogSetTitle => 'Ορισμός κωδικού PIN';

  @override
  String get pinDialogSetSubtitle =>
      'Εισάγετε ένα 6-ψήφιο PIN για την προστασία του SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Επιβεβαίωση PIN';

  @override
  String get pinDialogErrorLength => 'Το PIN πρέπει να είναι ακριβώς 6 ψηφία';

  @override
  String get pinDialogErrorMismatch => 'Τα PIN δεν ταιριάζουν';

  @override
  String get pinDialogVerifyTitle => 'Εισάγετε PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Λάθος PIN. $attempts προσπάθειες απομένουν.';
  }

  @override
  String get securityBannerMessage =>
      'Τα διαπιστευτήρια SSH δεν προστατεύονται. Ρυθμίστε ένα PIN ή βιομετρικό κλείδωμα στις Ρυθμίσεις.';

  @override
  String get securityBannerDismiss => 'Απόρριψη';

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get settingsSectionAppearance => 'Εμφάνιση';

  @override
  String get settingsSectionTerminal => 'Τερματικό';

  @override
  String get settingsSectionSshDefaults => 'Προεπιλογές SSH';

  @override
  String get settingsSectionSecurity => 'Ασφάλεια';

  @override
  String get settingsSectionExport => 'Εξαγωγή';

  @override
  String get settingsSectionAbout => 'Σχετικά';

  @override
  String get settingsTheme => 'Θέμα';

  @override
  String get settingsThemeSystem => 'Σύστημα';

  @override
  String get settingsThemeLight => 'Φωτεινό';

  @override
  String get settingsThemeDark => 'Σκοτεινό';

  @override
  String get settingsTerminalTheme => 'Θέμα τερματικού';

  @override
  String get settingsTerminalThemeDefault => 'Προεπιλεγμένο σκοτεινό';

  @override
  String get settingsFontSize => 'Μέγεθος γραμματοσειράς';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Προεπιλεγμένη θύρα';

  @override
  String get settingsDefaultPortDialog => 'Προεπιλεγμένη θύρα SSH';

  @override
  String get settingsPortLabel => 'Θύρα';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Προεπιλεγμένο όνομα χρήστη';

  @override
  String get settingsDefaultUsernameDialog => 'Προεπιλεγμένο όνομα χρήστη';

  @override
  String get settingsUsernameLabel => 'Όνομα χρήστη';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Αυτόματο κλείδωμα';

  @override
  String get settingsAutoLockDisabled => 'Απενεργοποιημένο';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes λεπτά';
  }

  @override
  String get settingsAutoLockOff => 'Ανενεργό';

  @override
  String get settingsAutoLock1Min => '1 λεπτό';

  @override
  String get settingsAutoLock5Min => '5 λεπτά';

  @override
  String get settingsAutoLock15Min => '15 λεπτά';

  @override
  String get settingsAutoLock30Min => '30 λεπτά';

  @override
  String get settingsBiometricUnlock => 'Βιομετρικό ξεκλείδωμα';

  @override
  String get settingsBiometricNotAvailable => 'Μη διαθέσιμο σε αυτή τη συσκευή';

  @override
  String get settingsBiometricError => 'Σφάλμα κατά τον έλεγχο βιομετρικών';

  @override
  String get settingsBiometricReason =>
      'Επαληθεύστε την ταυτότητά σας για να ενεργοποιήσετε το βιομετρικό ξεκλείδωμα';

  @override
  String get settingsBiometricRequiresPin =>
      'Ορίστε πρώτα ένα PIN για να ενεργοποιήσετε το βιομετρικό ξεκλείδωμα';

  @override
  String get settingsPinCode => 'Κωδικός PIN';

  @override
  String get settingsPinIsSet => 'Το PIN έχει οριστεί';

  @override
  String get settingsPinNotConfigured => 'Δεν έχει διαμορφωθεί PIN';

  @override
  String get settingsPinRemove => 'Αφαίρεση';

  @override
  String get settingsPinRemoveWarning =>
      'Η αφαίρεση του PIN θα αποκρυπτογραφήσει όλα τα πεδία βάσης δεδομένων και θα απενεργοποιήσει το βιομετρικό ξεκλείδωμα. Συνέχεια;';

  @override
  String get settingsPinRemoveTitle => 'Αφαίρεση PIN';

  @override
  String get settingsPreventScreenshots => 'Αποτροπή στιγμιότυπων οθόνης';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Αποκλεισμός στιγμιότυπων οθόνης και εγγραφής οθόνης';

  @override
  String get settingsEncryptExport => 'Κρυπτογράφηση εξαγωγών από προεπιλογή';

  @override
  String get settingsAbout => 'Σχετικά με το SSHVault';

  @override
  String get settingsAboutLegalese => 'από Kiefer Networks';

  @override
  String get settingsAboutDescription =>
      'Ασφαλής, αυτο-φιλοξενούμενος πελάτης SSH';

  @override
  String get settingsLanguage => 'Γλώσσα';

  @override
  String get settingsLanguageSystem => 'Σύστημα';

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
  String get cancel => 'Ακύρωση';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get update => 'Ενημέρωση';

  @override
  String get create => 'Δημιουργία';

  @override
  String get retry => 'Επανάληψη';

  @override
  String get copy => 'Αντιγραφή';

  @override
  String get edit => 'Επεξεργασία';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Σφάλμα: $message';
  }

  @override
  String get serverListTitle => 'Διακομιστές';

  @override
  String get serverListEmpty => 'Δεν υπάρχουν διακομιστές ακόμα';

  @override
  String get serverListEmptySubtitle =>
      'Προσθέστε τον πρώτο σας διακομιστή SSH για να ξεκινήσετε.';

  @override
  String get serverAddButton => 'Προσθήκη διακομιστή';

  @override
  String sshConfigImportMessage(int count) {
    return 'Βρέθηκαν $count host(s) στο ~/.ssh/config. Εισαγωγή;';
  }

  @override
  String get sshConfigNotFound => 'Δεν βρέθηκε αρχείο ρύθμισης SSH';

  @override
  String get sshConfigEmpty => 'Δεν βρέθηκαν hosts στη ρύθμιση SSH';

  @override
  String get sshConfigAddManually => 'Χειροκίνητη προσθήκη';

  @override
  String get sshConfigImportAgain => 'Εισαγωγή ρύθμισης SSH ξανά;';

  @override
  String get sshConfigImportKeys =>
      'Εισαγωγή κλειδιών SSH που αναφέρονται από τους επιλεγμένους hosts;';

  @override
  String sshConfigKeysImported(int count) {
    return '$count κλειδιά SSH εισήχθησαν';
  }

  @override
  String get serverDuplicated => 'Ο διακομιστής αντιγράφηκε';

  @override
  String get serverDeleteTitle => 'Διαγραφή διακομιστή';

  @override
  String serverDeleteMessage(String name) {
    return 'Είστε σίγουροι ότι θέλετε να διαγράψετε \"$name\"; Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Διαγραφή \"$name\";';
  }

  @override
  String get serverConnect => 'Σύνδεση';

  @override
  String get serverDetails => 'Λεπτομέρειες';

  @override
  String get serverDuplicate => 'Αντιγραφή';

  @override
  String get serverActive => 'Ενεργός';

  @override
  String get serverNoFolder => 'Χωρίς φάκελο';

  @override
  String get serverFormTitleEdit => 'Επεξεργασία διακομιστή';

  @override
  String get serverFormTitleAdd => 'Προσθήκη διακομιστή';

  @override
  String get serverSaved => 'Ο διακομιστής αποθηκεύτηκε';

  @override
  String get serverFormUpdateButton => 'Ενημέρωση διακομιστή';

  @override
  String get serverFormAddButton => 'Προσθήκη διακομιστή';

  @override
  String get serverFormPublicKeyExtracted =>
      'Το δημόσιο κλειδί εξήχθη επιτυχώς';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Αδυναμία εξαγωγής δημόσιου κλειδιού: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Ζεύγος κλειδιών $type δημιουργήθηκε';
  }

  @override
  String get serverDetailTitle => 'Λεπτομέρειες διακομιστή';

  @override
  String get serverDetailDeleteMessage =>
      'Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get serverDetailConnection => 'Σύνδεση';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Θύρα';

  @override
  String get serverDetailUsername => 'Όνομα χρήστη';

  @override
  String get serverDetailFolder => 'Φάκελος';

  @override
  String get serverDetailTags => 'Ετικέτες';

  @override
  String get serverDetailNotes => 'Σημειώσεις';

  @override
  String get serverDetailInfo => 'Πληροφορίες';

  @override
  String get serverDetailCreated => 'Δημιουργήθηκε';

  @override
  String get serverDetailUpdated => 'Ενημερώθηκε';

  @override
  String get serverDetailDistro => 'Σύστημα';

  @override
  String get copiedToClipboard => 'Αντιγράφηκε στο πρόχειρο';

  @override
  String get serverFormNameLabel => 'Όνομα διακομιστή';

  @override
  String get serverFormHostnameLabel => 'Hostname / IP';

  @override
  String get serverFormPortLabel => 'Θύρα';

  @override
  String get serverFormUsernameLabel => 'Όνομα χρήστη';

  @override
  String get serverFormPasswordLabel => 'Κωδικός πρόσβασης';

  @override
  String get serverFormUseManagedKey => 'Χρήση διαχειριζόμενου κλειδιού';

  @override
  String get serverFormManagedKeySubtitle =>
      'Επιλογή από κεντρικά διαχειριζόμενα κλειδιά SSH';

  @override
  String get serverFormDirectKeySubtitle =>
      'Επικόλληση κλειδιού απευθείας σε αυτόν τον διακομιστή';

  @override
  String get serverFormGenerateKey => 'Δημιουργία ζεύγους κλειδιών SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Ιδιωτικό κλειδί';

  @override
  String get serverFormPrivateKeyHint => 'Επικολλήστε ιδιωτικό κλειδί SSH...';

  @override
  String get serverFormExtractPublicKey => 'Εξαγωγή δημόσιου κλειδιού';

  @override
  String get serverFormPublicKeyLabel => 'Δημόσιο κλειδί';

  @override
  String get serverFormPublicKeyHint =>
      'Αυτόματη δημιουργία από ιδιωτικό κλειδί αν είναι κενό';

  @override
  String get serverFormPassphraseLabel => 'Φράση κλειδιού (προαιρετικό)';

  @override
  String get serverFormNotesLabel => 'Σημειώσεις (προαιρετικό)';

  @override
  String get searchServers => 'Αναζήτηση διακομιστών...';

  @override
  String get filterAllFolders => 'Όλοι οι φάκελοι';

  @override
  String get filterAll => 'Όλα';

  @override
  String get filterActive => 'Ενεργοί';

  @override
  String get filterInactive => 'Ανενεργοί';

  @override
  String get filterClear => 'Εκκαθάριση';

  @override
  String get folderListTitle => 'Φάκελοι';

  @override
  String get folderListEmpty => 'Δεν υπάρχουν φάκελοι ακόμα';

  @override
  String get folderListEmptySubtitle =>
      'Δημιουργήστε φακέλους για να οργανώσετε τους διακομιστές σας.';

  @override
  String get folderAddButton => 'Προσθήκη φακέλου';

  @override
  String get folderDeleteTitle => 'Διαγραφή φακέλου';

  @override
  String folderDeleteMessage(String name) {
    return 'Διαγραφή \"$name\"; Οι διακομιστές θα γίνουν ακατηγοριοποίητοι.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count διακομιστές',
      one: '1 διακομιστής',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Σύμπτυξη';

  @override
  String get folderShowHosts => 'Εμφάνιση hosts';

  @override
  String get folderConnectAll => 'Σύνδεση όλων';

  @override
  String get folderFormTitleEdit => 'Επεξεργασία φακέλου';

  @override
  String get folderFormTitleNew => 'Νέος φάκελος';

  @override
  String get folderFormNameLabel => 'Όνομα φακέλου';

  @override
  String get folderFormParentLabel => 'Γονικός φάκελος';

  @override
  String get folderFormParentNone => 'Κανένας (Ριζικός)';

  @override
  String get tagListTitle => 'Ετικέτες';

  @override
  String get tagListEmpty => 'Δεν υπάρχουν ετικέτες ακόμα';

  @override
  String get tagListEmptySubtitle =>
      'Δημιουργήστε ετικέτες για να επισημάνετε και να φιλτράρετε τους διακομιστές σας.';

  @override
  String get tagAddButton => 'Προσθήκη ετικέτας';

  @override
  String get tagDeleteTitle => 'Διαγραφή ετικέτας';

  @override
  String tagDeleteMessage(String name) {
    return 'Διαγραφή \"$name\"; Θα αφαιρεθεί από όλους τους διακομιστές.';
  }

  @override
  String get tagFormTitleEdit => 'Επεξεργασία ετικέτας';

  @override
  String get tagFormTitleNew => 'Νέα ετικέτα';

  @override
  String get tagFormNameLabel => 'Όνομα ετικέτας';

  @override
  String get sshKeyListTitle => 'Κλειδιά SSH';

  @override
  String get sshKeyListEmpty => 'Δεν υπάρχουν κλειδιά SSH ακόμα';

  @override
  String get sshKeyListEmptySubtitle =>
      'Δημιουργήστε ή εισαγάγετε κλειδιά SSH για κεντρική διαχείριση';

  @override
  String get sshKeyCannotDeleteTitle => 'Αδυναμία διαγραφής';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Αδυναμία διαγραφής \"$name\". Χρησιμοποιείται από $count διακομιστή(-ές). Αποσυνδέστε πρώτα από όλους τους διακομιστές.';
  }

  @override
  String get sshKeyDeleteTitle => 'Διαγραφή κλειδιού SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Διαγραφή \"$name\"; Αυτό δεν μπορεί να αναιρεθεί.';
  }

  @override
  String get sshKeyAddButton => 'Προσθήκη κλειδιού SSH';

  @override
  String get sshKeyFormTitleEdit => 'Επεξεργασία κλειδιού SSH';

  @override
  String get sshKeyFormTitleAdd => 'Προσθήκη κλειδιού SSH';

  @override
  String get sshKeyFormTabGenerate => 'Δημιουργία';

  @override
  String get sshKeyFormTabImport => 'Εισαγωγή';

  @override
  String get sshKeyFormNameLabel => 'Όνομα κλειδιού';

  @override
  String get sshKeyFormNameHint => 'π.χ. Κλειδί παραγωγής μου';

  @override
  String get sshKeyFormKeyType => 'Τύπος κλειδιού';

  @override
  String get sshKeyFormKeySize => 'Μέγεθος κλειδιού';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Σχόλιο';

  @override
  String get sshKeyFormCommentHint => 'χρήστης@host ή περιγραφή';

  @override
  String get sshKeyFormCommentOptional => 'Σχόλιο (προαιρετικό)';

  @override
  String get sshKeyFormImportFromFile => 'Εισαγωγή από αρχείο';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Ιδιωτικό κλειδί';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Επικολλήστε ιδιωτικό κλειδί SSH ή χρησιμοποιήστε το κουμπί παραπάνω...';

  @override
  String get sshKeyFormPassphraseLabel => 'Φράση πρόσβασης (προαιρετικό)';

  @override
  String get sshKeyFormNameRequired => 'Το όνομα είναι υποχρεωτικό';

  @override
  String get sshKeyFormPrivateKeyRequired =>
      'Το ιδιωτικό κλειδί είναι υποχρεωτικό';

  @override
  String get sshKeyFormFileReadError =>
      'Δεν ήταν δυνατή η ανάγνωση του επιλεγμένου αρχείου';

  @override
  String get sshKeyFormInvalidFormat =>
      'Μη έγκυρη μορφή κλειδιού — αναμενόμενη μορφή PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Αποτυχία ανάγνωσης αρχείου: $message';
  }

  @override
  String get sshKeyFormSaving => 'Αποθήκευση...';

  @override
  String get sshKeySelectorLabel => 'Κλειδί SSH';

  @override
  String get sshKeySelectorNone => 'Χωρίς διαχειριζόμενο κλειδί';

  @override
  String get sshKeySelectorManage => 'Διαχείριση κλειδιών...';

  @override
  String get sshKeySelectorError => 'Αποτυχία φόρτωσης κλειδιών SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Αντιγραφή δημόσιου κλειδιού';

  @override
  String get sshKeyTilePublicKeyCopied => 'Το δημόσιο κλειδί αντιγράφηκε';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Χρησιμοποιείται από $count διακομιστή(-ές)';
  }

  @override
  String get sshKeySavedSuccess => 'Το κλειδί SSH αποθηκεύτηκε';

  @override
  String get sshKeyDeletedSuccess => 'Το κλειδί SSH διαγράφηκε';

  @override
  String get tagSavedSuccess => 'Η ετικέτα αποθηκεύτηκε';

  @override
  String get tagDeletedSuccess => 'Η ετικέτα διαγράφηκε';

  @override
  String get folderDeletedSuccess => 'Ο φάκελος διαγράφηκε';

  @override
  String get sshKeyTileUnlinkFirst =>
      'Αποσυνδέστε πρώτα από όλους τους διακομιστές';

  @override
  String get exportImportTitle => 'Εξαγωγή / Εισαγωγή';

  @override
  String get exportSectionTitle => 'Εξαγωγή';

  @override
  String get exportJsonButton => 'Εξαγωγή ως JSON (χωρίς διαπιστευτήρια)';

  @override
  String get exportZipButton =>
      'Εξαγωγή κρυπτογραφημένου ZIP (με διαπιστευτήρια)';

  @override
  String get importSectionTitle => 'Εισαγωγή';

  @override
  String get importButton => 'Εισαγωγή από αρχείο';

  @override
  String get importSupportedFormats =>
      'Υποστηρίζει αρχεία JSON (απλά) και ZIP (κρυπτογραφημένα).';

  @override
  String exportedTo(String path) {
    return 'Εξαγωγή σε: $path';
  }

  @override
  String get share => 'Κοινοποίηση';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Εισήχθησαν $servers διακομιστές, $groups ομάδες, $tags ετικέτες. $skipped παραλείφθηκαν.';
  }

  @override
  String get importPasswordTitle => 'Εισαγωγή κωδικού';

  @override
  String get importPasswordLabel => 'Κωδικός εξαγωγής';

  @override
  String get importPasswordDecrypt => 'Αποκρυπτογράφηση';

  @override
  String get exportPasswordTitle => 'Ορισμός κωδικού εξαγωγής';

  @override
  String get exportPasswordDescription =>
      'Αυτός ο κωδικός θα χρησιμοποιηθεί για την κρυπτογράφηση του αρχείου εξαγωγής σας συμπεριλαμβανομένων των διαπιστευτηρίων.';

  @override
  String get exportPasswordLabel => 'Κωδικός';

  @override
  String get exportPasswordConfirmLabel => 'Επιβεβαίωση κωδικού';

  @override
  String get exportPasswordMismatch => 'Οι κωδικοί δεν ταιριάζουν';

  @override
  String get exportPasswordButton => 'Κρυπτογράφηση & Εξαγωγή';

  @override
  String get importConflictTitle => 'Διαχείριση συγκρούσεων';

  @override
  String get importConflictDescription =>
      'Πώς πρέπει να αντιμετωπιστούν οι υπάρχουσες εγγραφές κατά την εισαγωγή;';

  @override
  String get importConflictSkip => 'Παράλειψη υπαρχόντων';

  @override
  String get importConflictRename => 'Μετονομασία νέων';

  @override
  String get importConflictOverwrite => 'Αντικατάσταση';

  @override
  String get confirmDeleteLabel => 'Διαγραφή';

  @override
  String get keyGenTitle => 'Δημιουργία ζεύγους κλειδιών SSH';

  @override
  String get keyGenKeyType => 'Τύπος κλειδιού';

  @override
  String get keyGenKeySize => 'Μέγεθος κλειδιού';

  @override
  String get keyGenComment => 'Σχόλιο';

  @override
  String get keyGenCommentHint => 'χρήστης@host ή περιγραφή';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Δημιουργία...';

  @override
  String get keyGenGenerate => 'Δημιουργία';

  @override
  String keyGenResultTitle(String type) {
    return 'Κλειδί $type δημιουργήθηκε';
  }

  @override
  String get keyGenPublicKey => 'Δημόσιο κλειδί';

  @override
  String get keyGenPrivateKey => 'Ιδιωτικό κλειδί';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Σχόλιο: $comment';
  }

  @override
  String get keyGenAnother => 'Δημιουργία άλλου';

  @override
  String get keyGenUseThisKey => 'Χρήση αυτού του κλειδιού';

  @override
  String get keyGenCopyTooltip => 'Αντιγραφή στο πρόχειρο';

  @override
  String keyGenCopied(String label) {
    return '$label αντιγράφηκε';
  }

  @override
  String get colorPickerLabel => 'Χρώμα';

  @override
  String get iconPickerLabel => 'Εικονίδιο';

  @override
  String get tagSelectorLabel => 'Ετικέτες';

  @override
  String get tagSelectorEmpty => 'Δεν υπάρχουν ετικέτες ακόμα';

  @override
  String get tagSelectorError => 'Αποτυχία φόρτωσης ετικετών';

  @override
  String get snippetListTitle => 'Αποσπάσματα';

  @override
  String get snippetSearchHint => 'Αναζήτηση αποσπασμάτων...';

  @override
  String get snippetListEmpty => 'Δεν υπάρχουν αποσπάσματα ακόμα';

  @override
  String get snippetListEmptySubtitle =>
      'Δημιουργήστε επαναχρησιμοποιήσιμα αποσπάσματα κώδικα και εντολές.';

  @override
  String get snippetAddButton => 'Προσθήκη αποσπάσματος';

  @override
  String get snippetDeleteTitle => 'Διαγραφή αποσπάσματος';

  @override
  String snippetDeleteMessage(String name) {
    return 'Διαγραφή \"$name\"; Αυτό δεν μπορεί να αναιρεθεί.';
  }

  @override
  String get snippetFormTitleEdit => 'Επεξεργασία αποσπάσματος';

  @override
  String get snippetFormTitleNew => 'Νέο απόσπασμα';

  @override
  String get snippetFormNameLabel => 'Όνομα';

  @override
  String get snippetFormNameHint => 'π.χ. Καθαρισμός Docker';

  @override
  String get snippetFormLanguageLabel => 'Γλώσσα';

  @override
  String get snippetFormContentLabel => 'Περιεχόμενο';

  @override
  String get snippetFormContentHint => 'Εισάγετε τον κώδικα αποσπάσματος...';

  @override
  String get snippetFormDescriptionLabel => 'Περιγραφή';

  @override
  String get snippetFormDescriptionHint => 'Προαιρετική περιγραφή...';

  @override
  String get snippetFormFolderLabel => 'Φάκελος';

  @override
  String get snippetFormNoFolder => 'Χωρίς φάκελο';

  @override
  String get snippetFormNameRequired => 'Το όνομα είναι υποχρεωτικό';

  @override
  String get snippetFormContentRequired => 'Το περιεχόμενο είναι υποχρεωτικό';

  @override
  String get snippetFormSaved => 'Το snippet αποθηκεύτηκε';

  @override
  String get snippetFormUpdateButton => 'Ενημέρωση αποσπάσματος';

  @override
  String get snippetFormCreateButton => 'Δημιουργία αποσπάσματος';

  @override
  String get snippetDetailTitle => 'Λεπτομέρειες αποσπάσματος';

  @override
  String get snippetDetailDeleteTitle => 'Διαγραφή αποσπάσματος';

  @override
  String get snippetDetailDeleteMessage =>
      'Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get snippetDetailContent => 'Περιεχόμενο';

  @override
  String get snippetDetailFillVariables => 'Συμπλήρωση μεταβλητών';

  @override
  String get snippetDetailDescription => 'Περιγραφή';

  @override
  String get snippetDetailVariables => 'Μεταβλητές';

  @override
  String get snippetDetailTags => 'Ετικέτες';

  @override
  String get snippetDetailInfo => 'Πληροφορίες';

  @override
  String get snippetDetailCreated => 'Δημιουργήθηκε';

  @override
  String get snippetDetailUpdated => 'Ενημερώθηκε';

  @override
  String get variableEditorTitle => 'Μεταβλητές προτύπου';

  @override
  String get variableEditorAdd => 'Προσθήκη';

  @override
  String get variableEditorEmpty =>
      'Χωρίς μεταβλητές. Χρησιμοποιήστε σύνταξη αγκυλών στο περιεχόμενο για αναφορά σε αυτές.';

  @override
  String get variableEditorNameLabel => 'Όνομα';

  @override
  String get variableEditorNameHint => 'π.χ. hostname';

  @override
  String get variableEditorDefaultLabel => 'Προεπιλογή';

  @override
  String get variableEditorDefaultHint => 'προαιρετικό';

  @override
  String get variableFillTitle => 'Συμπλήρωση μεταβλητών';

  @override
  String variableFillHint(String name) {
    return 'Εισάγετε τιμή για $name';
  }

  @override
  String get variableFillPreview => 'Προεπισκόπηση';

  @override
  String get terminalTitle => 'Τερματικό';

  @override
  String get terminalEmpty => 'Δεν υπάρχουν ενεργές συνεδρίες';

  @override
  String get terminalEmptySubtitle =>
      'Συνδεθείτε σε έναν host για να ανοίξετε μια συνεδρία τερματικού.';

  @override
  String get terminalGoToHosts => 'Μετάβαση σε hosts';

  @override
  String get terminalCloseAll => 'Κλείσιμο όλων των συνεδριών';

  @override
  String get terminalCloseTitle => 'Κλείσιμο συνεδρίας';

  @override
  String terminalCloseMessage(String title) {
    return 'Κλείσιμο της ενεργής σύνδεσης στο \"$title\";';
  }

  @override
  String get connectionAuthenticating => 'Πιστοποίηση...';

  @override
  String connectionConnecting(String name) {
    return 'Σύνδεση σε $name...';
  }

  @override
  String get connectionError => 'Σφάλμα σύνδεσης';

  @override
  String get connectionLost => 'Η σύνδεση χάθηκε';

  @override
  String get connectionReconnect => 'Επανασύνδεση';

  @override
  String get snippetQuickPanelTitle => 'Εισαγωγή αποσπάσματος';

  @override
  String get snippetQuickPanelSearch => 'Αναζήτηση αποσπασμάτων...';

  @override
  String get snippetQuickPanelEmpty => 'Δεν υπάρχουν διαθέσιμα αποσπάσματα';

  @override
  String get snippetQuickPanelNoMatch => 'Δεν βρέθηκαν αποσπάσματα';

  @override
  String get snippetQuickPanelInsertTooltip => 'Εισαγωγή αποσπάσματος';

  @override
  String get terminalThemePickerTitle => 'Θέμα τερματικού';

  @override
  String get validatorHostnameRequired => 'Το hostname είναι υποχρεωτικό';

  @override
  String get validatorHostnameInvalid => 'Μη έγκυρο hostname ή διεύθυνση IP';

  @override
  String get validatorPortRequired => 'Η θύρα είναι υποχρεωτική';

  @override
  String get validatorPortRange => 'Η θύρα πρέπει να είναι μεταξύ 1 και 65535';

  @override
  String get validatorUsernameRequired => 'Το όνομα χρήστη είναι υποχρεωτικό';

  @override
  String get validatorUsernameInvalid => 'Μη έγκυρη μορφή ονόματος χρήστη';

  @override
  String get validatorServerNameRequired =>
      'Το όνομα διακομιστή είναι υποχρεωτικό';

  @override
  String get validatorServerNameLength =>
      'Το όνομα διακομιστή πρέπει να είναι 100 χαρακτήρες ή λιγότεροι';

  @override
  String get validatorSshKeyInvalid => 'Μη έγκυρη μορφή κλειδιού SSH';

  @override
  String get validatorPasswordRequired => 'Ο κωδικός είναι υποχρεωτικός';

  @override
  String get validatorPasswordLength =>
      'Ο κωδικός πρέπει να έχει τουλάχιστον 8 χαρακτήρες';

  @override
  String get authMethodPassword => 'Κωδικός';

  @override
  String get authMethodKey => 'Κλειδί SSH';

  @override
  String get authMethodBoth => 'Κωδικός + Κλειδί';

  @override
  String get serverCopySuffix => '(Αντίγραφο)';

  @override
  String get settingsDownloadLogs => 'Λήψη αρχείων καταγραφής';

  @override
  String get settingsSendLogs => 'Αποστολή αρχείων καταγραφής στην υποστήριξη';

  @override
  String get settingsLogsSaved => 'Τα αρχεία καταγραφής αποθηκεύτηκαν επιτυχώς';

  @override
  String get settingsUpdated => 'Η ρύθμιση ενημερώθηκε';

  @override
  String get settingsThemeChanged => 'Το θέμα άλλαξε';

  @override
  String get settingsLanguageChanged => 'Η γλώσσα άλλαξε';

  @override
  String get settingsPinSetSuccess => 'Το PIN ορίστηκε';

  @override
  String get settingsPinRemovedSuccess => 'Το PIN αφαιρέθηκε';

  @override
  String get settingsDuressPinSetSuccess => 'Το PIN εξαναγκασμού ορίστηκε';

  @override
  String get settingsDuressPinRemovedSuccess =>
      'Το PIN εξαναγκασμού αφαιρέθηκε';

  @override
  String get settingsBiometricEnabled => 'Βιομετρικό ξεκλείδωμα ενεργοποιήθηκε';

  @override
  String get settingsBiometricDisabled =>
      'Βιομετρικό ξεκλείδωμα απενεργοποιήθηκε';

  @override
  String get settingsDnsServerAdded => 'Προστέθηκε διακομιστής DNS';

  @override
  String get settingsDnsServerRemoved => 'Αφαιρέθηκε διακομιστής DNS';

  @override
  String get settingsDnsResetSuccess => 'Επαναφορά διακομιστών DNS';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Μείωση γραμματοσειράς';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Αύξηση γραμματοσειράς';

  @override
  String get settingsDnsRemoveServerTooltip => 'Αφαίρεση διακομιστή DNS';

  @override
  String get settingsLogsEmpty => 'Δεν υπάρχουν διαθέσιμες εγγραφές καταγραφής';

  @override
  String get authLogin => 'Σύνδεση';

  @override
  String get authRegister => 'Εγγραφή';

  @override
  String get authForgotPassword => 'Ξεχάσατε τον κωδικό;';

  @override
  String get authWhyLogin =>
      'Συνδεθείτε για να ενεργοποιήσετε την κρυπτογραφημένη συγχρονισμό cloud σε όλες τις συσκευές σας. Η εφαρμογή λειτουργεί πλήρως χωρίς σύνδεση χωρίς λογαριασμό.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'Το email είναι υποχρεωτικό';

  @override
  String get authEmailInvalid => 'Μη έγκυρη διεύθυνση email';

  @override
  String get authPasswordLabel => 'Κωδικός';

  @override
  String get authConfirmPasswordLabel => 'Επιβεβαίωση κωδικού';

  @override
  String get authPasswordMismatch => 'Οι κωδικοί δεν ταιριάζουν';

  @override
  String get authNoAccount => 'Δεν έχετε λογαριασμό;';

  @override
  String get authHasAccount => 'Έχετε ήδη λογαριασμό;';

  @override
  String get authResetEmailSent =>
      'Εάν υπάρχει λογαριασμός, ένας σύνδεσμος επαναφοράς έχει σταλεί στο email σας.';

  @override
  String get authResetDescription =>
      'Εισάγετε τη διεύθυνση email σας και θα σας στείλουμε σύνδεσμο για επαναφορά του κωδικού σας.';

  @override
  String get authSendResetLink => 'Αποστολή συνδέσμου επαναφοράς';

  @override
  String get authBackToLogin => 'Επιστροφή στη σύνδεση';

  @override
  String get syncPasswordTitle => 'Κωδικός συγχρονισμού';

  @override
  String get syncPasswordTitleCreate => 'Ορισμός κωδικού συγχρονισμού';

  @override
  String get syncPasswordTitleEnter => 'Εισαγωγή κωδικού συγχρονισμού';

  @override
  String get syncPasswordDescription =>
      'Ορίστε ξεχωριστό κωδικό για κρυπτογράφηση των δεδομένων vault. Αυτός ο κωδικός δεν φεύγει ποτέ από τη συσκευή σας — ο διακομιστής αποθηκεύει μόνο κρυπτογραφημένα δεδομένα.';

  @override
  String get syncPasswordHintEnter =>
      'Εισάγετε τον κωδικό που ορίσατε κατά τη δημιουργία του λογαριασμού σας.';

  @override
  String get syncPasswordWarning =>
      'Εάν ξεχάσετε αυτόν τον κωδικό, τα συγχρονισμένα δεδομένα σας δεν μπορούν να ανακτηθούν. Δεν υπάρχει επιλογή επαναφοράς.';

  @override
  String get syncPasswordLabel => 'Κωδικός συγχρονισμού';

  @override
  String get syncPasswordWrong => 'Λάθος κωδικός. Παρακαλώ δοκιμάστε ξανά.';

  @override
  String get firstSyncTitle => 'Βρέθηκαν υπάρχοντα δεδομένα';

  @override
  String get firstSyncMessage =>
      'Αυτή η συσκευή έχει υπάρχοντα δεδομένα και ο διακομιστής έχει vault. Πώς θα προχωρήσουμε;';

  @override
  String get firstSyncMerge => 'Συγχώνευση (κερδίζει ο διακομιστής)';

  @override
  String get firstSyncOverwriteLocal => 'Αντικατάσταση τοπικών δεδομένων';

  @override
  String get firstSyncKeepLocal => 'Διατήρηση τοπικών & push';

  @override
  String get firstSyncDeleteLocal => 'Διαγραφή τοπικών & pull';

  @override
  String get changeEncryptionPassword => 'Αλλαγή κωδικού κρυπτογράφησης';

  @override
  String get changeEncryptionWarning =>
      'Θα αποσυνδεθείτε από όλες τις άλλες συσκευές.';

  @override
  String get changeEncryptionOldPassword => 'Τρέχων κωδικός';

  @override
  String get changeEncryptionNewPassword => 'Νέος κωδικός';

  @override
  String get changeEncryptionSuccess => 'Ο κωδικός άλλαξε επιτυχώς.';

  @override
  String get logoutAllDevices => 'Αποσύνδεση από όλες τις συσκευές';

  @override
  String get logoutAllDevicesConfirm =>
      'Αυτό θα ανακαλέσει όλες τις ενεργές συνεδρίες. Θα χρειαστεί να συνδεθείτε ξανά σε όλες τις συσκευές.';

  @override
  String get logoutAllDevicesSuccess => 'Αποσύνδεση από όλες τις συσκευές.';

  @override
  String get syncSettingsTitle => 'Ρυθμίσεις συγχρονισμού';

  @override
  String get syncAutoSync => 'Αυτόματος συγχρονισμός';

  @override
  String get syncAutoSyncDescription =>
      'Αυτόματος συγχρονισμός κατά την εκκίνηση της εφαρμογής';

  @override
  String get syncNow => 'Συγχρονισμός τώρα';

  @override
  String get syncSyncing => 'Συγχρονισμός...';

  @override
  String get syncSuccess => 'Ο συγχρονισμός ολοκληρώθηκε';

  @override
  String get syncError => 'Σφάλμα συγχρονισμού';

  @override
  String get syncServerUnreachable => 'Ο διακομιστής δεν είναι προσβάσιμος';

  @override
  String get syncServerUnreachableHint =>
      'Ο διακομιστής συγχρονισμού δεν ήταν προσβάσιμος. Ελέγξτε τη σύνδεση στο διαδίκτυο και το URL του διακομιστή.';

  @override
  String get syncNetworkError =>
      'Η σύνδεση στον διακομιστή απέτυχε. Ελέγξτε τη σύνδεσή σας στο διαδίκτυο ή δοκιμάστε ξανά αργότερα.';

  @override
  String get syncNeverSynced => 'Δεν έχει συγχρονιστεί ποτέ';

  @override
  String get syncVaultVersion => 'Έκδοση Vault';

  @override
  String get syncTitle => 'Συγχρονισμός';

  @override
  String get settingsSectionNetwork => 'Δίκτυο & DNS';

  @override
  String get settingsDnsServers => 'Διακομιστές DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Προεπιλογή (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Εισάγετε προσαρμοσμένα URL διακομιστών DoH, χωρισμένα με κόμματα. Απαιτούνται τουλάχιστον 2 διακομιστές για διασταυρούμενη επαλήθευση.';

  @override
  String get settingsDnsLabel => 'URL διακομιστών DoH';

  @override
  String get settingsDnsReset => 'Επαναφορά σε προεπιλογή';

  @override
  String get settingsSectionSync => 'Συγχρονισμός';

  @override
  String get settingsSyncAccount => 'Λογαριασμός';

  @override
  String get settingsSyncNotLoggedIn => 'Δεν έχετε συνδεθεί';

  @override
  String get settingsSyncStatus => 'Συγχρονισμός';

  @override
  String get settingsSyncServerUrl => 'URL διακομιστή';

  @override
  String get settingsSyncDefaultServer => 'Προεπιλογή (sshvault.app)';

  @override
  String get accountTitle => 'Λογαριασμός';

  @override
  String get accountNotLoggedIn => 'Δεν έχετε συνδεθεί';

  @override
  String get accountVerified => 'Επαληθευμένος';

  @override
  String get accountMemberSince => 'Μέλος από';

  @override
  String get accountDevices => 'Συσκευές';

  @override
  String get accountNoDevices => 'Δεν υπάρχουν εγγεγραμμένες συσκευές';

  @override
  String get accountLastSync => 'Τελευταίος συγχρονισμός';

  @override
  String get accountChangePassword => 'Αλλαγή κωδικού';

  @override
  String get accountOldPassword => 'Τρέχων κωδικός';

  @override
  String get accountNewPassword => 'Νέος κωδικός';

  @override
  String get accountDeleteAccount => 'Διαγραφή λογαριασμού';

  @override
  String get accountDeleteWarning =>
      'Αυτό θα διαγράψει μόνιμα τον λογαριασμό σας και όλα τα συγχρονισμένα δεδομένα. Αυτό δεν μπορεί να αναιρεθεί.';

  @override
  String get accountLogout => 'Αποσύνδεση';

  @override
  String get serverConfigTitle => 'Ρύθμιση διακομιστή';

  @override
  String get serverConfigUrlLabel => 'URL διακομιστή';

  @override
  String get serverConfigTest => 'Δοκιμή σύνδεσης';

  @override
  String get serverSetupTitle => 'Ρύθμιση διακομιστή';

  @override
  String get serverSetupInfoCard =>
      'Το ShellVault απαιτεί αυτο-φιλοξενούμενο διακομιστή για κρυπτογραφημένο συγχρονισμό από άκρο σε άκρο. Αναπτύξτε τη δική σας παρουσία για να ξεκινήσετε.';

  @override
  String get serverSetupRepoLink => 'Προβολή στο GitHub';

  @override
  String get serverSetupContinue => 'Συνέχεια';

  @override
  String get settingsServerNotConfigured => 'Δεν έχει ρυθμιστεί διακομιστής';

  @override
  String get settingsSetupSync =>
      'Ρυθμίστε τον συγχρονισμό για δημιουργία αντιγράφων ασφαλείας';

  @override
  String get settingsChangeServer => 'Αλλαγή διακομιστή';

  @override
  String get settingsChangeServerConfirm =>
      'Η αλλαγή διακομιστή θα σας αποσυνδέσει. Συνέχεια;';

  @override
  String get auditLogTitle => 'Αρχείο δραστηριότητας';

  @override
  String get auditLogAll => 'Όλα';

  @override
  String get auditLogEmpty => 'Δεν βρέθηκαν αρχεία δραστηριότητας';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Διαχείριση αρχείων';

  @override
  String get sftpLocalDevice => 'Τοπική συσκευή';

  @override
  String get sftpSelectServer => 'Επιλογή διακομιστή...';

  @override
  String get sftpConnecting => 'Σύνδεση...';

  @override
  String get sftpEmptyDirectory => 'Αυτός ο κατάλογος είναι κενός';

  @override
  String get sftpNoConnection => 'Δεν υπάρχει συνδεδεμένος διακομιστής';

  @override
  String get sftpPathLabel => 'Διαδρομή';

  @override
  String get sftpUpload => 'Μεταφόρτωση';

  @override
  String get sftpDownload => 'Λήψη';

  @override
  String get sftpDelete => 'Διαγραφή';

  @override
  String get sftpRename => 'Μετονομασία';

  @override
  String get sftpNewFolder => 'Νέος φάκελος';

  @override
  String get sftpNewFolderName => 'Όνομα φακέλου';

  @override
  String get sftpChmod => 'Δικαιώματα';

  @override
  String get sftpChmodTitle => 'Αλλαγή δικαιωμάτων';

  @override
  String get sftpChmodOctal => 'Οκταδικό';

  @override
  String get sftpChmodOwner => 'Ιδιοκτήτης';

  @override
  String get sftpChmodGroup => 'Ομάδα';

  @override
  String get sftpChmodOther => 'Άλλοι';

  @override
  String get sftpChmodRead => 'Ανάγνωση';

  @override
  String get sftpChmodWrite => 'Εγγραφή';

  @override
  String get sftpChmodExecute => 'Εκτέλεση';

  @override
  String get sftpCreateSymlink => 'Δημιουργία Symlink';

  @override
  String get sftpSymlinkTarget => 'Διαδρομή στόχου';

  @override
  String get sftpSymlinkName => 'Όνομα συνδέσμου';

  @override
  String get sftpFilePreview => 'Προεπισκόπηση αρχείου';

  @override
  String get sftpFileInfo => 'Πληροφορίες αρχείου';

  @override
  String get sftpFileSize => 'Μέγεθος';

  @override
  String get sftpFileModified => 'Τροποποιήθηκε';

  @override
  String get sftpFilePermissions => 'Δικαιώματα';

  @override
  String get sftpFileOwner => 'Ιδιοκτήτης';

  @override
  String get sftpFileType => 'Τύπος';

  @override
  String get sftpFileLinkTarget => 'Στόχος συνδέσμου';

  @override
  String get sftpTransfers => 'Μεταφορές';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current από $total';
  }

  @override
  String get sftpTransferQueued => 'Σε ουρά';

  @override
  String get sftpTransferActive => 'Μεταφορά...';

  @override
  String get sftpTransferPaused => 'Σε παύση';

  @override
  String get sftpTransferCompleted => 'Ολοκληρώθηκε';

  @override
  String get sftpTransferFailed => 'Απέτυχε';

  @override
  String get sftpTransferCancelled => 'Ακυρώθηκε';

  @override
  String get sftpPauseTransfer => 'Παύση';

  @override
  String get sftpResumeTransfer => 'Συνέχιση';

  @override
  String get sftpCancelTransfer => 'Ακύρωση';

  @override
  String get sftpClearCompleted => 'Εκκαθάριση ολοκληρωμένων';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active από $total μεταφορές';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ενεργές',
      one: '1 ενεργή',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ολοκληρωμένες',
      one: '1 ολοκληρωμένη',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count αποτυχημένες',
      one: '1 αποτυχημένη',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Αντιγραφή στο άλλο πάνελ';

  @override
  String sftpConfirmDelete(int count) {
    return 'Διαγραφή $count αντικειμένων;';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Διαγραφή \"$name\";';
  }

  @override
  String get sftpDeleteSuccess => 'Διαγράφηκε επιτυχώς';

  @override
  String get sftpRenameTitle => 'Μετονομασία';

  @override
  String get sftpRenameLabel => 'Νέο όνομα';

  @override
  String get sftpSortByName => 'Όνομα';

  @override
  String get sftpSortBySize => 'Μέγεθος';

  @override
  String get sftpSortByDate => 'Ημερομηνία';

  @override
  String get sftpSortByType => 'Τύπος';

  @override
  String get sftpShowHidden => 'Εμφάνιση κρυφών αρχείων';

  @override
  String get sftpHideHidden => 'Απόκρυψη κρυφών αρχείων';

  @override
  String get sftpSelectAll => 'Επιλογή όλων';

  @override
  String get sftpDeselectAll => 'Αποεπιλογή όλων';

  @override
  String sftpItemsSelected(int count) {
    return '$count επιλεγμένα';
  }

  @override
  String get sftpRefresh => 'Ανανέωση';

  @override
  String sftpConnectionError(String message) {
    return 'Η σύνδεση απέτυχε: $message';
  }

  @override
  String get sftpPermissionDenied => 'Άρνηση πρόσβασης';

  @override
  String sftpOperationFailed(String message) {
    return 'Η λειτουργία απέτυχε: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Το αρχείο υπάρχει ήδη';

  @override
  String sftpOverwriteMessage(String fileName) {
    return 'Το \"$fileName\" υπάρχει ήδη. Αντικατάσταση;';
  }

  @override
  String get sftpOverwrite => 'Αντικατάσταση';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Η μεταφορά ξεκίνησε: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'Επιλέξτε πρώτα προορισμό στο άλλο πάνελ';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Η μεταφορά φακέλων θα είναι σύντομα διαθέσιμη';

  @override
  String get sftpSelect => 'Επιλογή';

  @override
  String get sftpOpen => 'Άνοιγμα';

  @override
  String get sftpExtractArchive => 'Εξαγωγή εδώ';

  @override
  String get sftpExtractSuccess => 'Το αρχείο εξήχθη';

  @override
  String sftpExtractFailed(String message) {
    return 'Η εξαγωγή απέτυχε: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Μη υποστηριζόμενη μορφή αρχείου';

  @override
  String get sftpExtracting => 'Εξαγωγή...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count μεταφορτώσεις ξεκίνησαν',
      one: 'Η μεταφόρτωση ξεκίνησε',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λήψεις ξεκίνησαν',
      one: 'Η λήψη ξεκίνησε',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return 'Το \"$fileName\" λήφθηκε';
  }

  @override
  String get sftpSavedToDownloads => 'Αποθηκεύτηκε στο Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Αποθήκευση σε αρχεία';

  @override
  String get sftpFileSaved => 'Το αρχείο αποθηκεύτηκε';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ενεργές συνεδρίες SSH',
      one: 'Ενεργή συνεδρία SSH',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Πατήστε για άνοιγμα τερματικού';

  @override
  String get settingsAccountAndSync => 'Λογαριασμός & Συγχρονισμός';

  @override
  String get settingsAccountSubtitleAuth => 'Συνδεδεμένος';

  @override
  String get settingsAccountSubtitleUnauth => 'Μη συνδεδεμένος';

  @override
  String get settingsSecuritySubtitle => 'Αυτόματο κλείδωμα, Βιομετρικά, PIN';

  @override
  String get settingsSshSubtitle => 'Θύρα 22, Χρήστης root';

  @override
  String get settingsAppearanceSubtitle => 'Θέμα, Γλώσσα, Τερματικό';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Προεπιλογές κρυπτογραφημένης εξαγωγής';

  @override
  String get settingsAboutSubtitle => 'Έκδοση, Άδειες';

  @override
  String get settingsSearchHint => 'Αναζήτηση ρυθμίσεων...';

  @override
  String get settingsSearchNoResults => 'Δεν βρέθηκαν ρυθμίσεις';

  @override
  String get aboutDeveloper => 'Αναπτύχθηκε από Kiefer Networks';

  @override
  String get aboutDonate => 'Δωρεά';

  @override
  String get aboutOpenSourceLicenses => 'Άδειες ανοιχτού κώδικα';

  @override
  String get aboutWebsite => 'Ιστοσελίδα';

  @override
  String get aboutVersion => 'Έκδοση';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'Το DNS-over-HTTPS κρυπτογραφεί τα ερωτήματα DNS και αποτρέπει την πλαστογράφηση DNS. Το SSHVault ελέγχει τα hostnames σε πολλαπλούς παρόχους για ανίχνευση επιθέσεων.';

  @override
  String get settingsDnsAddServer => 'Προσθήκη διακομιστή DNS';

  @override
  String get settingsDnsServerUrl => 'URL διακομιστή';

  @override
  String get settingsDnsDefaultBadge => 'Προεπιλογή';

  @override
  String get settingsDnsResetDefaults => 'Επαναφορά σε προεπιλογές';

  @override
  String get settingsDnsInvalidUrl => 'Εισάγετε ένα έγκυρο URL HTTPS';

  @override
  String get settingsDefaultAuthMethod => 'Μέθοδος πιστοποίησης';

  @override
  String get settingsAuthPassword => 'Κωδικός';

  @override
  String get settingsAuthKey => 'Κλειδί SSH';

  @override
  String get settingsConnectionTimeout => 'Χρονικό όριο σύνδεσης';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$secondsδ';
  }

  @override
  String get settingsKeepaliveInterval => 'Διάστημα Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$secondsδ';
  }

  @override
  String get settingsCompression => 'Συμπίεση';

  @override
  String get settingsCompressionDescription =>
      'Ενεργοποίηση συμπίεσης zlib για συνδέσεις SSH';

  @override
  String get settingsTerminalType => 'Τύπος τερματικού';

  @override
  String get settingsSectionConnection => 'Σύνδεση';

  @override
  String get settingsClipboardAutoClear => 'Αυτόματη εκκαθάριση πρόχειρου';

  @override
  String get settingsClipboardAutoClearOff => 'Ανενεργό';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$secondsδ';
  }

  @override
  String get settingsSessionTimeout => 'Χρονικό όριο συνεδρίας';

  @override
  String get settingsSessionTimeoutOff => 'Ανενεργό';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes λεπτά';
  }

  @override
  String get settingsDuressPin => 'PIN εξαναγκασμού';

  @override
  String get settingsDuressPinDescription =>
      'Ξεχωριστό PIN που διαγράφει όλα τα δεδομένα όταν εισαχθεί';

  @override
  String get settingsDuressPinSet => 'Το PIN εξαναγκασμού έχει οριστεί';

  @override
  String get settingsDuressPinNotSet => 'Δεν έχει διαμορφωθεί';

  @override
  String get settingsDuressPinWarning =>
      'Η εισαγωγή αυτού του PIN θα διαγράψει μόνιμα όλα τα τοπικά δεδομένα συμπεριλαμβανομένων διαπιστευτηρίων, κλειδιών και ρυθμίσεων. Αυτό δεν μπορεί να αναιρεθεί.';

  @override
  String get settingsKeyRotationReminder => 'Υπενθύμιση εναλλαγής κλειδιών';

  @override
  String get settingsKeyRotationOff => 'Ανενεργό';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days ημέρες';
  }

  @override
  String get settingsFailedAttempts => 'Αποτυχημένες προσπάθειες PIN';

  @override
  String get settingsSectionAppLock => 'Κλείδωμα εφαρμογής';

  @override
  String get settingsSectionPrivacy => 'Απόρρητο';

  @override
  String get settingsSectionReminders => 'Υπενθυμίσεις';

  @override
  String get settingsSectionStatus => 'Κατάσταση';

  @override
  String get settingsExportBackupSubtitle =>
      'Εξαγωγή, Εισαγωγή & Αντίγραφο ασφαλείας';

  @override
  String get settingsExportJson => 'Εξαγωγή ως JSON';

  @override
  String get settingsExportEncrypted => 'Κρυπτογραφημένη εξαγωγή';

  @override
  String get settingsImportFile => 'Εισαγωγή από αρχείο';

  @override
  String get settingsSectionImport => 'Εισαγωγή';

  @override
  String get filterTitle => 'Φιλτράρισμα διακομιστών';

  @override
  String get filterApply => 'Εφαρμογή φίλτρων';

  @override
  String get filterClearAll => 'Εκκαθάριση όλων';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count φίλτρα ενεργά',
      one: '1 φίλτρο ενεργό',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Φάκελος';

  @override
  String get filterTags => 'Ετικέτες';

  @override
  String get filterStatus => 'Κατάσταση';

  @override
  String get variablePreviewResolved => 'Επιλυμένη προεπισκόπηση';

  @override
  String get variableInsert => 'Εισαγωγή';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count διακομιστές',
      one: '1 διακομιστής',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count συνεδρίες ανακλήθηκαν.',
      one: '1 συνεδρία ανακλήθηκε.',
    );
    return '$_temp0 Αποσυνδεθήκατε.';
  }

  @override
  String get keyGenPassphrase => 'Φράση πρόσβασης';

  @override
  String get keyGenPassphraseHint =>
      'Προαιρετικό — προστατεύει το ιδιωτικό κλειδί';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Προεπιλογή (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Ένα κλειδί με το ίδιο αποτύπωμα υπάρχει ήδη: \"$name\". Κάθε κλειδί SSH πρέπει να είναι μοναδικό.';
  }

  @override
  String get sshKeyFingerprint => 'Αποτύπωμα';

  @override
  String get sshKeyPublicKey => 'Δημόσιο κλειδί';

  @override
  String get jumpHost => 'Jump Host';

  @override
  String get jumpHostNone => 'Κανένας';

  @override
  String get jumpHostLabel => 'Σύνδεση μέσω jump host';

  @override
  String get jumpHostSelfError =>
      'Ένας διακομιστής δεν μπορεί να είναι ο δικός του jump host';

  @override
  String get jumpHostConnecting => 'Σύνδεση στον jump host...';

  @override
  String get jumpHostCircularError => 'Εντοπίστηκε κυκλική αλυσίδα jump host';

  @override
  String get logoutDialogTitle => 'Αποσύνδεση';

  @override
  String get logoutDialogMessage =>
      'Θέλετε να διαγράψετε όλα τα τοπικά δεδομένα; Διακομιστές, κλειδιά SSH, αποσπάσματα και ρυθμίσεις θα αφαιρεθούν από αυτή τη συσκευή.';

  @override
  String get logoutOnly => 'Μόνο αποσύνδεση';

  @override
  String get logoutAndDelete => 'Αποσύνδεση & διαγραφή δεδομένων';

  @override
  String get changeAvatar => 'Αλλαγή avatar';

  @override
  String get removeAvatar => 'Αφαίρεση avatar';

  @override
  String get avatarUploadFailed => 'Αποτυχία μεταφόρτωσης avatar';

  @override
  String get avatarTooLarge => 'Η εικόνα είναι πολύ μεγάλη';

  @override
  String get deviceLastSeen => 'Τελευταία εμφάνιση';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Το URL διακομιστή δεν μπορεί να αλλάξει ενώ είστε συνδεδεμένοι. Αποσυνδεθείτε πρώτα.';

  @override
  String get serverListNoFolder => 'Ακατηγοριοποίητο';

  @override
  String get autoSyncInterval => 'Διάστημα συγχρονισμού';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes λεπτά';
  }

  @override
  String get proxySettings => 'Ρυθμίσεις Proxy';

  @override
  String get proxyType => 'Τύπος Proxy';

  @override
  String get proxyNone => 'Χωρίς Proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Host Proxy';

  @override
  String get proxyPort => 'Θύρα Proxy';

  @override
  String get proxyUsername => 'Όνομα χρήστη Proxy';

  @override
  String get proxyPassword => 'Κωδικός Proxy';

  @override
  String get proxyUseGlobal => 'Χρήση καθολικού Proxy';

  @override
  String get proxyGlobal => 'Καθολικό';

  @override
  String get proxyServerSpecific => 'Ειδικό για διακομιστή';

  @override
  String get proxyTestConnection => 'Δοκιμή σύνδεσης';

  @override
  String get proxyTestSuccess => 'Το Proxy είναι προσβάσιμο';

  @override
  String get proxyTestFailed => 'Το Proxy δεν είναι προσβάσιμο';

  @override
  String get proxyDefaultProxy => 'Προεπιλεγμένο Proxy';

  @override
  String get vpnRequired => 'Απαιτείται VPN';

  @override
  String get vpnRequiredTooltip =>
      'Εμφάνιση προειδοποίησης κατά τη σύνδεση χωρίς ενεργό VPN';

  @override
  String get vpnActive => 'VPN ενεργό';

  @override
  String get vpnInactive => 'VPN ανενεργό';

  @override
  String get vpnWarningTitle => 'Το VPN δεν είναι ενεργό';

  @override
  String get vpnWarningMessage =>
      'Αυτός ο διακομιστής απαιτεί σύνδεση VPN, αλλά δεν υπάρχει ενεργό VPN αυτή τη στιγμή. Θέλετε να συνδεθείτε ούτως ή άλλως;';

  @override
  String get vpnConnectAnyway => 'Σύνδεση ούτως ή άλλως';

  @override
  String get postConnectCommands => 'Εντολές μετά τη σύνδεση';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Εντολές που εκτελούνται αυτόματα μετά τη σύνδεση (μία ανά γραμμή)';

  @override
  String get dashboardFavorites => 'Αγαπημένα';

  @override
  String get dashboardRecent => 'Πρόσφατα';

  @override
  String get dashboardActiveSessions => 'Ενεργές συνεδρίες';

  @override
  String get addToFavorites => 'Προσθήκη στα αγαπημένα';

  @override
  String get removeFromFavorites => 'Αφαίρεση από τα αγαπημένα';

  @override
  String get noRecentConnections => 'Δεν υπάρχουν πρόσφατες συνδέσεις';

  @override
  String get terminalSplit => 'Διαίρεση προβολής';

  @override
  String get terminalUnsplit => 'Κλείσιμο διαίρεσης';

  @override
  String get terminalSelectSession => 'Επιλογή συνεδρίας για διαίρεση προβολής';

  @override
  String get knownHostsTitle => 'Γνωστοί hosts';

  @override
  String get knownHostsSubtitle =>
      'Διαχείριση αξιόπιστων αποτυπωμάτων διακομιστών';

  @override
  String get hostKeyNewTitle => 'Νέος host';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Πρώτη σύνδεση στο $hostname:$port. Επαληθεύστε το αποτύπωμα πριν τη σύνδεση.';
  }

  @override
  String get hostKeyChangedTitle => 'Το κλειδί του host άλλαξε!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Το κλειδί του host για $hostname:$port άλλαξε. Αυτό μπορεί να υποδηλώνει απειλή ασφάλειας.';
  }

  @override
  String get hostKeyFingerprint => 'Αποτύπωμα';

  @override
  String get hostKeyType => 'Τύπος κλειδιού';

  @override
  String get hostKeyTrustConnect => 'Εμπιστοσύνη & Σύνδεση';

  @override
  String get hostKeyAcceptNew => 'Αποδοχή νέου κλειδιού';

  @override
  String get hostKeyReject => 'Απόρριψη';

  @override
  String get hostKeyPreviousFingerprint => 'Προηγούμενο αποτύπωμα';

  @override
  String get hostKeyDeleteAll => 'Διαγραφή όλων των γνωστών hosts';

  @override
  String get hostKeyDeleteConfirm =>
      'Είστε σίγουροι ότι θέλετε να αφαιρέσετε όλους τους γνωστούς hosts; Θα ερωτηθείτε ξανά στην επόμενη σύνδεση.';

  @override
  String get hostKeyEmpty => 'Δεν υπάρχουν γνωστοί hosts ακόμα';

  @override
  String get hostKeyEmptySubtitle =>
      'Τα αποτυπώματα hosts θα αποθηκευτούν εδώ μετά την πρώτη σας σύνδεση';

  @override
  String get hostKeyFirstSeen => 'Πρώτη εμφάνιση';

  @override
  String get hostKeyLastSeen => 'Τελευταία εμφάνιση';

  @override
  String get sshConfigImportTitle => 'Εισαγωγή ρύθμισης SSH';

  @override
  String get sshConfigImportPickFile => 'Επιλογή αρχείου ρύθμισης SSH';

  @override
  String get sshConfigImportOrPaste => 'Ή επικολλήστε περιεχόμενο ρύθμισης';

  @override
  String sshConfigImportParsed(int count) {
    return 'Βρέθηκαν $count hosts';
  }

  @override
  String get sshConfigImportButton => 'Εισαγωγή';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count διακομιστές εισήχθησαν';
  }

  @override
  String get sshConfigImportDuplicate => 'Υπάρχει ήδη';

  @override
  String get sshConfigImportNoHosts => 'Δεν βρέθηκαν hosts στη ρύθμιση';

  @override
  String get sftpBookmarkAdd => 'Προσθήκη σελιδοδείκτη';

  @override
  String get sftpBookmarkLabel => 'Ετικέτα';

  @override
  String get disconnect => 'Αποσύνδεση';

  @override
  String get reportAndDisconnect => 'Αναφορά & Αποσύνδεση';

  @override
  String get continueAnyway => 'Συνέχεια ούτως ή άλλως';

  @override
  String get insertSnippet => 'Εισαγωγή αποσπάσματος';

  @override
  String get seconds => 'Δευτερόλεπτα';

  @override
  String get heartbeatLostMessage =>
      'Ο διακομιστής δεν ήταν προσβάσιμος μετά από πολλές προσπάθειες. Για την ασφάλειά σας, η συνεδρία τερματίστηκε.';

  @override
  String get attestationFailedTitle => 'Η επαλήθευση του διακομιστή απέτυχε';

  @override
  String get attestationFailedMessage =>
      'Ο διακομιστής δεν μπόρεσε να επαληθευτεί ως νόμιμο backend SSHVault. Αυτό μπορεί να υποδηλώνει επίθεση man-in-the-middle ή εσφαλμένη ρύθμιση διακομιστή.';

  @override
  String get attestationKeyChangedTitle => 'Το κλειδί του διακομιστή άλλαξε';

  @override
  String get attestationKeyChangedMessage =>
      'Το κλειδί attestation του διακομιστή άλλαξε από την αρχική σύνδεση. Αυτό μπορεί να υποδηλώνει επίθεση man-in-the-middle. ΜΗΝ συνεχίσετε εκτός αν ο διαχειριστής του διακομιστή έχει επιβεβαιώσει εναλλαγή κλειδιού.';

  @override
  String get sectionLinks => 'Σύνδεσμοι';

  @override
  String get sectionDeveloper => 'Προγραμματιστής';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Η σελίδα δεν βρέθηκε';

  @override
  String get connectionTestSuccess => 'Η σύνδεση πέτυχε';

  @override
  String connectionTestFailed(String message) {
    return 'Η σύνδεση απέτυχε: $message';
  }

  @override
  String get serverVerificationFailed => 'Η επαλήθευση του διακομιστή απέτυχε';

  @override
  String get importSuccessful => 'Η εισαγωγή ολοκληρώθηκε';

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

  @override
  String get deviceDeleteConfirmTitle => 'Αφαίρεση συσκευής';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Είστε σίγουροι ότι θέλετε να αφαιρέσετε \"$name\"; Η συσκευή θα αποσυνδεθεί αμέσως.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Αυτή είναι η τρέχουσα συσκευή σας. Θα αποσυνδεθείτε αμέσως.';

  @override
  String get deviceDeleteSuccess => 'Η συσκευή αφαιρέθηκε';

  @override
  String get deviceDeletedCurrentLogout =>
      'Η τρέχουσα συσκευή αφαιρέθηκε. Αποσυνδεθήκατε.';

  @override
  String get thisDevice => 'Αυτή η συσκευή';
}
