// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'שרתים';

  @override
  String get navSnippets => 'קטעי קוד';

  @override
  String get navFolders => 'תיקיות';

  @override
  String get navTags => 'תגיות';

  @override
  String get navSshKeys => 'מפתחות SSH';

  @override
  String get navExportImport => 'ייצוא / ייבוא';

  @override
  String get navTerminal => 'טרמינל';

  @override
  String get navMore => 'עוד';

  @override
  String get navManagement => 'ניהול';

  @override
  String get navSettings => 'הגדרות';

  @override
  String get navAbout => 'אודות';

  @override
  String get lockScreenTitle => 'SSHVault נעול';

  @override
  String get lockScreenUnlock => 'ביטול נעילה';

  @override
  String get lockScreenEnterPin => 'הזן PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'יותר מדי ניסיונות כושלים. נסה שוב בעוד $minutes דקות.';
  }

  @override
  String get pinDialogSetTitle => 'הגדרת קוד PIN';

  @override
  String get pinDialogSetSubtitle => 'הזן PIN בן 6 ספרות להגנה על SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'אימות PIN';

  @override
  String get pinDialogErrorLength => 'PIN חייב להיות בדיוק 6 ספרות';

  @override
  String get pinDialogErrorMismatch => 'קודי ה-PIN אינם תואמים';

  @override
  String get pinDialogVerifyTitle => 'הזן PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN שגוי. נותרו $attempts ניסיונות.';
  }

  @override
  String get securityBannerMessage =>
      'אישורי ה-SSH שלך אינם מוגנים. הגדר PIN או נעילה ביומטרית בהגדרות.';

  @override
  String get securityBannerDismiss => 'סגור';

  @override
  String get settingsTitle => 'הגדרות';

  @override
  String get settingsSectionAppearance => 'מראה';

  @override
  String get settingsSectionTerminal => 'טרמינל';

  @override
  String get settingsSectionSshDefaults => 'ברירות מחדל SSH';

  @override
  String get settingsSectionSecurity => 'אבטחה';

  @override
  String get settingsSectionExport => 'ייצוא';

  @override
  String get settingsSectionAbout => 'אודות';

  @override
  String get settingsTheme => 'ערכת נושא';

  @override
  String get settingsThemeSystem => 'מערכת';

  @override
  String get settingsThemeLight => 'בהיר';

  @override
  String get settingsThemeDark => 'כהה';

  @override
  String get settingsTerminalTheme => 'ערכת נושא טרמינל';

  @override
  String get settingsTerminalThemeDefault => 'כהה ברירת מחדל';

  @override
  String get settingsFontSize => 'גודל גופן';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'פורט ברירת מחדל';

  @override
  String get settingsDefaultPortDialog => 'פורט SSH ברירת מחדל';

  @override
  String get settingsPortLabel => 'פורט';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'שם משתמש ברירת מחדל';

  @override
  String get settingsDefaultUsernameDialog => 'שם משתמש ברירת מחדל';

  @override
  String get settingsUsernameLabel => 'שם משתמש';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'נעילה אוטומטית';

  @override
  String get settingsAutoLockDisabled => 'מושבת';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes דקות';
  }

  @override
  String get settingsAutoLockOff => 'כבוי';

  @override
  String get settingsAutoLock1Min => 'דקה 1';

  @override
  String get settingsAutoLock5Min => '5 דקות';

  @override
  String get settingsAutoLock15Min => '15 דקות';

  @override
  String get settingsAutoLock30Min => '30 דקות';

  @override
  String get settingsBiometricUnlock => 'ביטול נעילה ביומטרי';

  @override
  String get settingsBiometricNotAvailable => 'לא זמין במכשיר זה';

  @override
  String get settingsBiometricError => 'שגיאה בבדיקת ביומטריה';

  @override
  String get settingsBiometricReason =>
      'אמת את זהותך כדי לאפשר ביטול נעילה ביומטרי';

  @override
  String get settingsBiometricRequiresPin =>
      'הגדר תחילה PIN כדי לאפשר ביטול נעילה ביומטרי';

  @override
  String get settingsPinCode => 'קוד PIN';

  @override
  String get settingsPinIsSet => 'PIN מוגדר';

  @override
  String get settingsPinNotConfigured => 'לא הוגדר PIN';

  @override
  String get settingsPinRemove => 'הסר';

  @override
  String get settingsPinRemoveWarning =>
      'הסרת ה-PIN תפענח את כל שדות מסד הנתונים ותשבית ביטול נעילה ביומטרי. להמשיך?';

  @override
  String get settingsPinRemoveTitle => 'הסרת PIN';

  @override
  String get settingsPreventScreenshots => 'מניעת צילומי מסך';

  @override
  String get settingsPreventScreenshotsDescription =>
      'חסימת צילומי מסך והקלטת מסך';

  @override
  String get settingsEncryptExport => 'הצפנת ייצוא כברירת מחדל';

  @override
  String get settingsAbout => 'אודות SSHVault';

  @override
  String get settingsAboutLegalese => 'מאת Kiefer Networks';

  @override
  String get settingsAboutDescription => 'לקוח SSH מאובטח ומתארח עצמאית';

  @override
  String get settingsLanguage => 'שפה';

  @override
  String get settingsLanguageSystem => 'מערכת';

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
  String get cancel => 'ביטול';

  @override
  String get save => 'שמירה';

  @override
  String get delete => 'מחיקה';

  @override
  String get close => 'סגירה';

  @override
  String get update => 'עדכון';

  @override
  String get create => 'יצירה';

  @override
  String get retry => 'נסה שוב';

  @override
  String get copy => 'העתקה';

  @override
  String get edit => 'עריכה';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'שגיאה: $message';
  }

  @override
  String get serverListTitle => 'שרתים';

  @override
  String get serverListEmpty => 'אין שרתים עדיין';

  @override
  String get serverListEmptySubtitle =>
      'הוסף את שרת ה-SSH הראשון שלך כדי להתחיל.';

  @override
  String get serverAddButton => 'הוספת שרת';

  @override
  String sshConfigImportMessage(int count) {
    return 'נמצאו $count שרתים ב-~/.ssh/config. לייבא?';
  }

  @override
  String get sshConfigNotFound => 'לא נמצא קובץ תצורת SSH';

  @override
  String get sshConfigEmpty => 'לא נמצאו שרתים בתצורת SSH';

  @override
  String get sshConfigAddManually => 'הוספה ידנית';

  @override
  String get sshConfigImportAgain => 'לייבא תצורת SSH שוב?';

  @override
  String get sshConfigImportKeys =>
      'לייבא מפתחות SSH שמשמשים את השרתים שנבחרו?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count מפתחות SSH יובאו';
  }

  @override
  String get serverDuplicated => 'השרת שוכפל';

  @override
  String get serverDeleteTitle => 'מחיקת שרת';

  @override
  String serverDeleteMessage(String name) {
    return 'האם אתה בטוח שברצונך למחוק את \"$name\"? פעולה זו אינה ניתנת לביטול.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'למחוק את \"$name\"?';
  }

  @override
  String get serverConnect => 'התחבר';

  @override
  String get serverDetails => 'פרטים';

  @override
  String get serverDuplicate => 'שכפול';

  @override
  String get serverActive => 'פעיל';

  @override
  String get serverNoFolder => 'ללא תיקיה';

  @override
  String get serverFormTitleEdit => 'עריכת שרת';

  @override
  String get serverFormTitleAdd => 'הוספת שרת';

  @override
  String get serverSaved => 'השרת נשמר';

  @override
  String get serverFormUpdateButton => 'עדכון שרת';

  @override
  String get serverFormAddButton => 'הוספת שרת';

  @override
  String get serverFormPublicKeyExtracted => 'המפתח הציבורי חולץ בהצלחה';

  @override
  String serverFormPublicKeyError(String message) {
    return 'לא ניתן לחלץ מפתח ציבורי: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'זוג מפתחות $type נוצר';
  }

  @override
  String get serverDetailTitle => 'פרטי שרת';

  @override
  String get serverDetailDeleteMessage => 'פעולה זו אינה ניתנת לביטול.';

  @override
  String get serverDetailConnection => 'חיבור';

  @override
  String get serverDetailHost => 'שרת';

  @override
  String get serverDetailPort => 'פורט';

  @override
  String get serverDetailUsername => 'שם משתמש';

  @override
  String get serverDetailFolder => 'תיקיה';

  @override
  String get serverDetailTags => 'תגיות';

  @override
  String get serverDetailNotes => 'הערות';

  @override
  String get serverDetailInfo => 'מידע';

  @override
  String get serverDetailCreated => 'נוצר';

  @override
  String get serverDetailUpdated => 'עודכן';

  @override
  String get serverDetailDistro => 'מערכת';

  @override
  String get copiedToClipboard => 'הועתק ללוח';

  @override
  String get serverFormNameLabel => 'שם שרת';

  @override
  String get serverFormHostnameLabel => 'שם מארח / IP';

  @override
  String get serverFormPortLabel => 'פורט';

  @override
  String get serverFormUsernameLabel => 'שם משתמש';

  @override
  String get serverFormPasswordLabel => 'סיסמה';

  @override
  String get serverFormUseManagedKey => 'שימוש במפתח מנוהל';

  @override
  String get serverFormManagedKeySubtitle => 'בחר ממפתחות SSH מנוהלים מרכזית';

  @override
  String get serverFormDirectKeySubtitle => 'הדבק מפתח ישירות לשרת זה';

  @override
  String get serverFormGenerateKey => 'יצירת זוג מפתחות SSH';

  @override
  String get serverFormPrivateKeyLabel => 'מפתח פרטי';

  @override
  String get serverFormPrivateKeyHint => 'הדבק מפתח SSH פרטי...';

  @override
  String get serverFormExtractPublicKey => 'חילוץ מפתח ציבורי';

  @override
  String get serverFormPublicKeyLabel => 'מפתח ציבורי';

  @override
  String get serverFormPublicKeyHint => 'נוצר אוטומטית ממפתח פרטי אם ריק';

  @override
  String get serverFormPassphraseLabel => 'ביטוי סיסמה למפתח (אופציונלי)';

  @override
  String get serverFormNotesLabel => 'הערות (אופציונלי)';

  @override
  String get searchServers => 'חיפוש שרתים...';

  @override
  String get filterAllFolders => 'כל התיקיות';

  @override
  String get filterAll => 'הכל';

  @override
  String get filterActive => 'פעיל';

  @override
  String get filterInactive => 'לא פעיל';

  @override
  String get filterClear => 'ניקוי';

  @override
  String get folderListTitle => 'תיקיות';

  @override
  String get folderListEmpty => 'אין תיקיות עדיין';

  @override
  String get folderListEmptySubtitle => 'צור תיקיות כדי לארגן את השרתים שלך.';

  @override
  String get folderAddButton => 'הוספת תיקיה';

  @override
  String get folderDeleteTitle => 'מחיקת תיקיה';

  @override
  String folderDeleteMessage(String name) {
    return 'למחוק את \"$name\"? שרתים יהפכו ללא קטגוריה.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שרתים',
      one: 'שרת 1',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'כיווץ';

  @override
  String get folderShowHosts => 'הצג שרתים';

  @override
  String get folderConnectAll => 'חבר הכל';

  @override
  String get folderFormTitleEdit => 'עריכת תיקיה';

  @override
  String get folderFormTitleNew => 'תיקיה חדשה';

  @override
  String get folderFormNameLabel => 'שם תיקיה';

  @override
  String get folderFormParentLabel => 'תיקיית אב';

  @override
  String get folderFormParentNone => 'אין (שורש)';

  @override
  String get tagListTitle => 'תגיות';

  @override
  String get tagListEmpty => 'אין תגיות עדיין';

  @override
  String get tagListEmptySubtitle => 'צור תגיות כדי לסמן ולסנן את השרתים שלך.';

  @override
  String get tagAddButton => 'הוספת תגית';

  @override
  String get tagDeleteTitle => 'מחיקת תגית';

  @override
  String tagDeleteMessage(String name) {
    return 'למחוק את \"$name\"? התגית תוסר מכל השרתים.';
  }

  @override
  String get tagFormTitleEdit => 'עריכת תגית';

  @override
  String get tagFormTitleNew => 'תגית חדשה';

  @override
  String get tagFormNameLabel => 'שם תגית';

  @override
  String get sshKeyListTitle => 'מפתחות SSH';

  @override
  String get sshKeyListEmpty => 'אין מפתחות SSH עדיין';

  @override
  String get sshKeyListEmptySubtitle => 'צור או ייבא מפתחות SSH לניהול מרכזי';

  @override
  String get sshKeyCannotDeleteTitle => 'לא ניתן למחוק';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'לא ניתן למחוק את \"$name\". בשימוש על ידי $count שרתים. נתק תחילה מכל השרתים.';
  }

  @override
  String get sshKeyDeleteTitle => 'מחיקת מפתח SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'למחוק את \"$name\"? לא ניתן לבטל פעולה זו.';
  }

  @override
  String get sshKeyAddButton => 'הוספת מפתח SSH';

  @override
  String get sshKeyFormTitleEdit => 'עריכת מפתח SSH';

  @override
  String get sshKeyFormTitleAdd => 'הוספת מפתח SSH';

  @override
  String get sshKeyFormTabGenerate => 'יצירה';

  @override
  String get sshKeyFormTabImport => 'ייבוא';

  @override
  String get sshKeyFormNameLabel => 'שם מפתח';

  @override
  String get sshKeyFormNameHint => 'לדוגמה: מפתח הפקה שלי';

  @override
  String get sshKeyFormKeyType => 'סוג מפתח';

  @override
  String get sshKeyFormKeySize => 'גודל מפתח';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'הערה';

  @override
  String get sshKeyFormCommentHint => 'משתמש@שרת או תיאור';

  @override
  String get sshKeyFormCommentOptional => 'הערה (אופציונלי)';

  @override
  String get sshKeyFormImportFromFile => 'ייבוא מקובץ';

  @override
  String get sshKeyFormPrivateKeyLabel => 'מפתח פרטי';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'הדבק מפתח SSH פרטי או השתמש בכפתור למעלה...';

  @override
  String get sshKeyFormPassphraseLabel => 'ביטוי סיסמה (אופציונלי)';

  @override
  String get sshKeyFormNameRequired => 'שם הוא שדה חובה';

  @override
  String get sshKeyFormPrivateKeyRequired => 'מפתח פרטי הוא שדה חובה';

  @override
  String get sshKeyFormFileReadError => 'לא ניתן לקרוא את הקובץ שנבחר';

  @override
  String get sshKeyFormInvalidFormat =>
      'פורמט מפתח לא תקין — נדרש פורמט PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'קריאת קובץ נכשלה: $message';
  }

  @override
  String get sshKeyFormSaving => 'שומר...';

  @override
  String get sshKeySelectorLabel => 'מפתח SSH';

  @override
  String get sshKeySelectorNone => 'ללא מפתח מנוהל';

  @override
  String get sshKeySelectorManage => 'ניהול מפתחות...';

  @override
  String get sshKeySelectorError => 'טעינת מפתחות SSH נכשלה';

  @override
  String get sshKeyTileCopyPublicKey => 'העתק מפתח ציבורי';

  @override
  String get sshKeyTilePublicKeyCopied => 'המפתח הציבורי הועתק';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'בשימוש על ידי $count שרתים';
  }

  @override
  String get sshKeySavedSuccess => 'מפתח SSH נשמר';

  @override
  String get sshKeyDeletedSuccess => 'מפתח SSH נמחק';

  @override
  String get tagSavedSuccess => 'התגית נשמרה';

  @override
  String get tagDeletedSuccess => 'התגית נמחקה';

  @override
  String get folderDeletedSuccess => 'התיקייה נמחקה';

  @override
  String get sshKeyTileUnlinkFirst => 'נתק תחילה מכל השרתים';

  @override
  String get exportImportTitle => 'ייצוא / ייבוא';

  @override
  String get exportSectionTitle => 'ייצוא';

  @override
  String get exportJsonButton => 'ייצוא כ-JSON (ללא אישורים)';

  @override
  String get exportZipButton => 'ייצוא ZIP מוצפן (עם אישורים)';

  @override
  String get importSectionTitle => 'ייבוא';

  @override
  String get importButton => 'ייבוא מקובץ';

  @override
  String get importSupportedFormats =>
      'תומך בקבצי JSON (רגילים) ו-ZIP (מוצפנים).';

  @override
  String exportedTo(String path) {
    return 'יוצא אל: $path';
  }

  @override
  String get share => 'שיתוף';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'יובאו $servers שרתים, $groups קבוצות, $tags תגיות. $skipped דולגו.';
  }

  @override
  String get importPasswordTitle => 'הזן סיסמה';

  @override
  String get importPasswordLabel => 'סיסמת ייצוא';

  @override
  String get importPasswordDecrypt => 'פענוח';

  @override
  String get exportPasswordTitle => 'הגדרת סיסמת ייצוא';

  @override
  String get exportPasswordDescription =>
      'סיסמה זו תשמש להצפנת קובץ הייצוא שלך כולל אישורים.';

  @override
  String get exportPasswordLabel => 'סיסמה';

  @override
  String get exportPasswordConfirmLabel => 'אימות סיסמה';

  @override
  String get exportPasswordMismatch => 'הסיסמאות אינן תואמות';

  @override
  String get exportPasswordButton => 'הצפנה וייצוא';

  @override
  String get importConflictTitle => 'טיפול בהתנגשויות';

  @override
  String get importConflictDescription =>
      'כיצד יש לטפל ברשומות קיימות במהלך הייבוא?';

  @override
  String get importConflictSkip => 'דלג על קיימים';

  @override
  String get importConflictRename => 'שנה שם לחדשים';

  @override
  String get importConflictOverwrite => 'דרוס';

  @override
  String get confirmDeleteLabel => 'מחיקה';

  @override
  String get keyGenTitle => 'יצירת זוג מפתחות SSH';

  @override
  String get keyGenKeyType => 'סוג מפתח';

  @override
  String get keyGenKeySize => 'גודל מפתח';

  @override
  String get keyGenComment => 'הערה';

  @override
  String get keyGenCommentHint => 'משתמש@שרת או תיאור';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'יוצר...';

  @override
  String get keyGenGenerate => 'יצירה';

  @override
  String keyGenResultTitle(String type) {
    return 'מפתח $type נוצר';
  }

  @override
  String get keyGenPublicKey => 'מפתח ציבורי';

  @override
  String get keyGenPrivateKey => 'מפתח פרטי';

  @override
  String keyGenCommentInfo(String comment) {
    return 'הערה: $comment';
  }

  @override
  String get keyGenAnother => 'יצירת נוסף';

  @override
  String get keyGenUseThisKey => 'שימוש במפתח זה';

  @override
  String get keyGenCopyTooltip => 'העתק ללוח';

  @override
  String keyGenCopied(String label) {
    return '$label הועתק';
  }

  @override
  String get colorPickerLabel => 'צבע';

  @override
  String get iconPickerLabel => 'סמל';

  @override
  String get tagSelectorLabel => 'תגיות';

  @override
  String get tagSelectorEmpty => 'אין תגיות עדיין';

  @override
  String get tagSelectorError => 'טעינת תגיות נכשלה';

  @override
  String get snippetListTitle => 'קטעי קוד';

  @override
  String get snippetSearchHint => 'חיפוש קטעי קוד...';

  @override
  String get snippetListEmpty => 'אין קטעי קוד עדיין';

  @override
  String get snippetListEmptySubtitle => 'צור קטעי קוד ופקודות לשימוש חוזר.';

  @override
  String get snippetAddButton => 'הוספת קטע קוד';

  @override
  String get snippetDeleteTitle => 'מחיקת קטע קוד';

  @override
  String snippetDeleteMessage(String name) {
    return 'למחוק את \"$name\"? לא ניתן לבטל פעולה זו.';
  }

  @override
  String get snippetFormTitleEdit => 'עריכת קטע קוד';

  @override
  String get snippetFormTitleNew => 'קטע קוד חדש';

  @override
  String get snippetFormNameLabel => 'שם';

  @override
  String get snippetFormNameHint => 'לדוגמה: ניקוי Docker';

  @override
  String get snippetFormLanguageLabel => 'שפה';

  @override
  String get snippetFormContentLabel => 'תוכן';

  @override
  String get snippetFormContentHint => 'הזן את קוד קטע הקוד שלך...';

  @override
  String get snippetFormDescriptionLabel => 'תיאור';

  @override
  String get snippetFormDescriptionHint => 'תיאור אופציונלי...';

  @override
  String get snippetFormFolderLabel => 'תיקיה';

  @override
  String get snippetFormNoFolder => 'ללא תיקיה';

  @override
  String get snippetFormNameRequired => 'שם הוא שדה חובה';

  @override
  String get snippetFormContentRequired => 'תוכן הוא שדה חובה';

  @override
  String get snippetFormSaved => 'הקטע נשמר';

  @override
  String get snippetFormUpdateButton => 'עדכון קטע קוד';

  @override
  String get snippetFormCreateButton => 'יצירת קטע קוד';

  @override
  String get snippetDetailTitle => 'פרטי קטע קוד';

  @override
  String get snippetDetailDeleteTitle => 'מחיקת קטע קוד';

  @override
  String get snippetDetailDeleteMessage => 'פעולה זו אינה ניתנת לביטול.';

  @override
  String get snippetDetailContent => 'תוכן';

  @override
  String get snippetDetailFillVariables => 'מילוי משתנים';

  @override
  String get snippetDetailDescription => 'תיאור';

  @override
  String get snippetDetailVariables => 'משתנים';

  @override
  String get snippetDetailTags => 'תגיות';

  @override
  String get snippetDetailInfo => 'מידע';

  @override
  String get snippetDetailCreated => 'נוצר';

  @override
  String get snippetDetailUpdated => 'עודכן';

  @override
  String get variableEditorTitle => 'משתני תבנית';

  @override
  String get variableEditorAdd => 'הוספה';

  @override
  String get variableEditorEmpty =>
      'אין משתנים. השתמש בתחביר סוגריים מסולסלים בתוכן כדי להפנות אליהם.';

  @override
  String get variableEditorNameLabel => 'שם';

  @override
  String get variableEditorNameHint => 'לדוגמה: hostname';

  @override
  String get variableEditorDefaultLabel => 'ברירת מחדל';

  @override
  String get variableEditorDefaultHint => 'אופציונלי';

  @override
  String get variableFillTitle => 'מילוי משתנים';

  @override
  String variableFillHint(String name) {
    return 'הזן ערך עבור $name';
  }

  @override
  String get variableFillPreview => 'תצוגה מקדימה';

  @override
  String get terminalTitle => 'טרמינל';

  @override
  String get terminalEmpty => 'אין הפעלות פעילות';

  @override
  String get terminalEmptySubtitle => 'התחבר לשרת כדי לפתוח הפעלת טרמינל.';

  @override
  String get terminalGoToHosts => 'עבור לשרתים';

  @override
  String get terminalCloseAll => 'סגור את כל ההפעלות';

  @override
  String get terminalCloseTitle => 'סגירת הפעלה';

  @override
  String terminalCloseMessage(String title) {
    return 'לסגור את החיבור הפעיל ל-\"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'מאמת...';

  @override
  String connectionConnecting(String name) {
    return 'מתחבר ל-$name...';
  }

  @override
  String get connectionError => 'שגיאת חיבור';

  @override
  String get connectionLost => 'החיבור אבד';

  @override
  String get connectionReconnect => 'התחבר מחדש';

  @override
  String get snippetQuickPanelTitle => 'הכנסת קטע קוד';

  @override
  String get snippetQuickPanelSearch => 'חיפוש קטעי קוד...';

  @override
  String get snippetQuickPanelEmpty => 'אין קטעי קוד זמינים';

  @override
  String get snippetQuickPanelNoMatch => 'אין קטעי קוד תואמים';

  @override
  String get snippetQuickPanelInsertTooltip => 'הכנסת קטע קוד';

  @override
  String get terminalThemePickerTitle => 'ערכת נושא טרמינל';

  @override
  String get validatorHostnameRequired => 'שם מארח הוא שדה חובה';

  @override
  String get validatorHostnameInvalid => 'שם מארח או כתובת IP לא תקינים';

  @override
  String get validatorPortRequired => 'פורט הוא שדה חובה';

  @override
  String get validatorPortRange => 'הפורט חייב להיות בין 1 ל-65535';

  @override
  String get validatorUsernameRequired => 'שם משתמש הוא שדה חובה';

  @override
  String get validatorUsernameInvalid => 'פורמט שם משתמש לא תקין';

  @override
  String get validatorServerNameRequired => 'שם שרת הוא שדה חובה';

  @override
  String get validatorServerNameLength => 'שם שרת חייב להיות 100 תווים או פחות';

  @override
  String get validatorSshKeyInvalid => 'פורמט מפתח SSH לא תקין';

  @override
  String get validatorPasswordRequired => 'סיסמה היא שדה חובה';

  @override
  String get validatorPasswordLength => 'הסיסמה חייבת להיות לפחות 8 תווים';

  @override
  String get authMethodPassword => 'סיסמה';

  @override
  String get authMethodKey => 'מפתח SSH';

  @override
  String get authMethodBoth => 'סיסמה + מפתח';

  @override
  String get serverCopySuffix => '(עותק)';

  @override
  String get settingsDownloadLogs => 'הורדת יומנים';

  @override
  String get settingsSendLogs => 'שליחת יומנים לתמיכה';

  @override
  String get settingsLogsSaved => 'היומנים נשמרו בהצלחה';

  @override
  String get settingsUpdated => 'ההגדרה עודכנה';

  @override
  String get settingsThemeChanged => 'הערכת נושא שונתה';

  @override
  String get settingsLanguageChanged => 'השפה שונתה';

  @override
  String get settingsPinSetSuccess => 'הקוד הוגדר';

  @override
  String get settingsPinRemovedSuccess => 'הקוד הוסר';

  @override
  String get settingsDuressPinSetSuccess => 'קוד כפייה הוגדר';

  @override
  String get settingsDuressPinRemovedSuccess => 'קוד כפייה הוסר';

  @override
  String get settingsBiometricEnabled => 'זיהוי ביומטרי מופעל';

  @override
  String get settingsBiometricDisabled => 'זיהוי ביומטרי מושבת';

  @override
  String get settingsDnsServerAdded => 'שרת DNS נוסף';

  @override
  String get settingsDnsServerRemoved => 'שרת DNS הוסר';

  @override
  String get settingsDnsResetSuccess => 'שרתי DNS אופסו';

  @override
  String get settingsFontSizeDecreaseTooltip => 'הקטן גופן';

  @override
  String get settingsFontSizeIncreaseTooltip => 'הגדל גופן';

  @override
  String get settingsDnsRemoveServerTooltip => 'הסר שרת DNS';

  @override
  String get settingsLogsEmpty => 'אין רשומות יומן זמינות';

  @override
  String get authLogin => 'התחברות';

  @override
  String get authRegister => 'הרשמה';

  @override
  String get authForgotPassword => 'שכחת סיסמה?';

  @override
  String get authWhyLogin =>
      'התחבר כדי לאפשר סנכרון ענן מוצפן בכל המכשירים שלך. האפליקציה עובדת במצב לא מקוון מלא ללא חשבון.';

  @override
  String get authEmailLabel => 'אימייל';

  @override
  String get authEmailRequired => 'אימייל הוא שדה חובה';

  @override
  String get authEmailInvalid => 'כתובת אימייל לא תקינה';

  @override
  String get authPasswordLabel => 'סיסמה';

  @override
  String get authConfirmPasswordLabel => 'אימות סיסמה';

  @override
  String get authPasswordMismatch => 'הסיסמאות אינן תואמות';

  @override
  String get authNoAccount => 'אין חשבון?';

  @override
  String get authHasAccount => 'כבר יש לך חשבון?';

  @override
  String get authResetEmailSent =>
      'אם קיים חשבון, קישור איפוס נשלח לאימייל שלך.';

  @override
  String get authResetDescription =>
      'הזן את כתובת האימייל שלך ונשלח לך קישור לאיפוס הסיסמה.';

  @override
  String get authSendResetLink => 'שלח קישור איפוס';

  @override
  String get authBackToLogin => 'חזרה להתחברות';

  @override
  String get syncPasswordTitle => 'סיסמת סנכרון';

  @override
  String get syncPasswordTitleCreate => 'הגדרת סיסמת סנכרון';

  @override
  String get syncPasswordTitleEnter => 'הזנת סיסמת סנכרון';

  @override
  String get syncPasswordDescription =>
      'הגדר סיסמה נפרדת להצפנת נתוני הכספת שלך. סיסמה זו לעולם לא עוזבת את המכשיר שלך — השרת מאחסן רק נתונים מוצפנים.';

  @override
  String get syncPasswordHintEnter =>
      'הזן את הסיסמה שהגדרת בעת יצירת החשבון שלך.';

  @override
  String get syncPasswordWarning =>
      'אם תשכח סיסמה זו, לא ניתן יהיה לשחזר את הנתונים המסונכרנים שלך. אין אפשרות איפוס.';

  @override
  String get syncPasswordLabel => 'סיסמת סנכרון';

  @override
  String get syncPasswordWrong => 'סיסמה שגויה. נסה שוב.';

  @override
  String get firstSyncTitle => 'נמצאו נתונים קיימים';

  @override
  String get firstSyncMessage =>
      'למכשיר זה יש נתונים קיימים ולשרת יש כספת. כיצד להמשיך?';

  @override
  String get firstSyncMerge => 'מיזוג (השרת מנצח)';

  @override
  String get firstSyncOverwriteLocal => 'דרוס נתונים מקומיים';

  @override
  String get firstSyncKeepLocal => 'שמור מקומי ודחוף';

  @override
  String get firstSyncDeleteLocal => 'מחק מקומי ומשוך';

  @override
  String get changeEncryptionPassword => 'שינוי סיסמת הצפנה';

  @override
  String get changeEncryptionWarning => 'תנותק מכל המכשירים האחרים.';

  @override
  String get changeEncryptionOldPassword => 'סיסמה נוכחית';

  @override
  String get changeEncryptionNewPassword => 'סיסמה חדשה';

  @override
  String get changeEncryptionSuccess => 'הסיסמה שונתה בהצלחה.';

  @override
  String get logoutAllDevices => 'התנתקות מכל המכשירים';

  @override
  String get logoutAllDevicesConfirm =>
      'פעולה זו תבטל את כל ההפעלות הפעילות. תצטרך להתחבר שוב בכל המכשירים.';

  @override
  String get logoutAllDevicesSuccess => 'כל המכשירים התנתקו.';

  @override
  String get syncSettingsTitle => 'הגדרות סנכרון';

  @override
  String get syncAutoSync => 'סנכרון אוטומטי';

  @override
  String get syncAutoSyncDescription => 'סנכרון אוטומטי בהפעלת האפליקציה';

  @override
  String get syncNow => 'סנכרן עכשיו';

  @override
  String get syncSyncing => 'מסנכרן...';

  @override
  String get syncSuccess => 'הסנכרון הושלם';

  @override
  String get syncError => 'שגיאת סנכרון';

  @override
  String get syncServerUnreachable => 'השרת אינו נגיש';

  @override
  String get syncServerUnreachableHint =>
      'שרת הסנכרון אינו נגיש. בדוק את חיבור האינטרנט וכתובת השרת שלך.';

  @override
  String get syncNetworkError =>
      'החיבור לשרת נכשל. בדוק את חיבור האינטרנט שלך או נסה שוב מאוחר יותר.';

  @override
  String get syncNeverSynced => 'מעולם לא סונכרן';

  @override
  String get syncVaultVersion => 'גרסת כספת';

  @override
  String get syncTitle => 'סנכרון';

  @override
  String get settingsSectionNetwork => 'רשת ו-DNS';

  @override
  String get settingsDnsServers => 'שרתי DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'ברירת מחדל (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'הזן כתובות שרתי DoH מותאמות אישית, מופרדות בפסיקים. נדרשים לפחות 2 שרתים לאימות צולב.';

  @override
  String get settingsDnsLabel => 'כתובות שרתי DoH';

  @override
  String get settingsDnsReset => 'איפוס לברירת מחדל';

  @override
  String get settingsSectionSync => 'סנכרון';

  @override
  String get settingsSyncAccount => 'חשבון';

  @override
  String get settingsSyncNotLoggedIn => 'לא מחובר';

  @override
  String get settingsSyncStatus => 'סנכרון';

  @override
  String get settingsSyncServerUrl => 'כתובת שרת';

  @override
  String get settingsSyncDefaultServer => 'ברירת מחדל (sshvault.app)';

  @override
  String get accountTitle => 'חשבון';

  @override
  String get accountNotLoggedIn => 'לא מחובר';

  @override
  String get accountVerified => 'מאומת';

  @override
  String get accountMemberSince => 'חבר מאז';

  @override
  String get accountDevices => 'מכשירים';

  @override
  String get accountNoDevices => 'אין מכשירים רשומים';

  @override
  String get accountLastSync => 'סנכרון אחרון';

  @override
  String get accountChangePassword => 'שינוי סיסמה';

  @override
  String get accountOldPassword => 'סיסמה נוכחית';

  @override
  String get accountNewPassword => 'סיסמה חדשה';

  @override
  String get accountDeleteAccount => 'מחיקת חשבון';

  @override
  String get accountDeleteWarning =>
      'פעולה זו תמחק לצמיתות את החשבון שלך ואת כל הנתונים המסונכרנים. לא ניתן לבטל פעולה זו.';

  @override
  String get accountLogout => 'התנתקות';

  @override
  String get serverConfigTitle => 'תצורת שרת';

  @override
  String get serverConfigUrlLabel => 'כתובת שרת';

  @override
  String get serverConfigTest => 'בדיקת חיבור';

  @override
  String get serverSetupTitle => 'הגדרת שרת';

  @override
  String get serverSetupInfoCard =>
      'ShellVault דורש שרת מתארח עצמאית לסנכרון מוצפן מקצה לקצה. פרוס את המופע שלך כדי להתחיל.';

  @override
  String get serverSetupRepoLink => 'הצג ב-GitHub';

  @override
  String get serverSetupContinue => 'המשך';

  @override
  String get settingsServerNotConfigured => 'לא הוגדר שרת';

  @override
  String get settingsSetupSync => 'הגדר סנכרון לגיבוי הנתונים שלך';

  @override
  String get settingsChangeServer => 'שינוי שרת';

  @override
  String get settingsChangeServerConfirm => 'שינוי השרת ינתק אותך. להמשיך?';

  @override
  String get auditLogTitle => 'יומן פעילות';

  @override
  String get auditLogAll => 'הכל';

  @override
  String get auditLogEmpty => 'לא נמצאו יומני פעילות';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'מנהל קבצים';

  @override
  String get sftpLocalDevice => 'מכשיר מקומי';

  @override
  String get sftpSelectServer => 'בחר שרת...';

  @override
  String get sftpConnecting => 'מתחבר...';

  @override
  String get sftpEmptyDirectory => 'ספרייה זו ריקה';

  @override
  String get sftpNoConnection => 'אין שרת מחובר';

  @override
  String get sftpPathLabel => 'נתיב';

  @override
  String get sftpUpload => 'העלאה';

  @override
  String get sftpDownload => 'הורדה';

  @override
  String get sftpDelete => 'מחיקה';

  @override
  String get sftpRename => 'שינוי שם';

  @override
  String get sftpNewFolder => 'תיקיה חדשה';

  @override
  String get sftpNewFolderName => 'שם תיקיה';

  @override
  String get sftpChmod => 'הרשאות';

  @override
  String get sftpChmodTitle => 'שינוי הרשאות';

  @override
  String get sftpChmodOctal => 'אוקטלי';

  @override
  String get sftpChmodOwner => 'בעלים';

  @override
  String get sftpChmodGroup => 'קבוצה';

  @override
  String get sftpChmodOther => 'אחרים';

  @override
  String get sftpChmodRead => 'קריאה';

  @override
  String get sftpChmodWrite => 'כתיבה';

  @override
  String get sftpChmodExecute => 'הרצה';

  @override
  String get sftpCreateSymlink => 'יצירת קישור סמלי';

  @override
  String get sftpSymlinkTarget => 'נתיב יעד';

  @override
  String get sftpSymlinkName => 'שם קישור';

  @override
  String get sftpFilePreview => 'תצוגה מקדימה של קובץ';

  @override
  String get sftpFileInfo => 'מידע על קובץ';

  @override
  String get sftpFileSize => 'גודל';

  @override
  String get sftpFileModified => 'שונה';

  @override
  String get sftpFilePermissions => 'הרשאות';

  @override
  String get sftpFileOwner => 'בעלים';

  @override
  String get sftpFileType => 'סוג';

  @override
  String get sftpFileLinkTarget => 'יעד קישור';

  @override
  String get sftpTransfers => 'העברות';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current מתוך $total';
  }

  @override
  String get sftpTransferQueued => 'בתור';

  @override
  String get sftpTransferActive => 'מעביר...';

  @override
  String get sftpTransferPaused => 'מושהה';

  @override
  String get sftpTransferCompleted => 'הושלם';

  @override
  String get sftpTransferFailed => 'נכשל';

  @override
  String get sftpTransferCancelled => 'בוטל';

  @override
  String get sftpPauseTransfer => 'השהיה';

  @override
  String get sftpResumeTransfer => 'המשך';

  @override
  String get sftpCancelTransfer => 'ביטול';

  @override
  String get sftpClearCompleted => 'ניקוי מושלמים';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active מתוך $total העברות';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count פעילים',
      one: '1 פעיל',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count הושלמו',
      one: '1 הושלם',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count נכשלו',
      one: '1 נכשל',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'העתק לחלונית אחרת';

  @override
  String sftpConfirmDelete(int count) {
    return 'למחוק $count פריטים?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'למחוק את \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'נמחק בהצלחה';

  @override
  String get sftpRenameTitle => 'שינוי שם';

  @override
  String get sftpRenameLabel => 'שם חדש';

  @override
  String get sftpSortByName => 'שם';

  @override
  String get sftpSortBySize => 'גודל';

  @override
  String get sftpSortByDate => 'תאריך';

  @override
  String get sftpSortByType => 'סוג';

  @override
  String get sftpShowHidden => 'הצג קבצים מוסתרים';

  @override
  String get sftpHideHidden => 'הסתר קבצים מוסתרים';

  @override
  String get sftpSelectAll => 'בחר הכל';

  @override
  String get sftpDeselectAll => 'בטל בחירת הכל';

  @override
  String sftpItemsSelected(int count) {
    return '$count נבחרו';
  }

  @override
  String get sftpRefresh => 'רענון';

  @override
  String sftpConnectionError(String message) {
    return 'החיבור נכשל: $message';
  }

  @override
  String get sftpPermissionDenied => 'הגישה נדחתה';

  @override
  String sftpOperationFailed(String message) {
    return 'הפעולה נכשלה: $message';
  }

  @override
  String get sftpOverwriteTitle => 'הקובץ כבר קיים';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" כבר קיים. לדרוס?';
  }

  @override
  String get sftpOverwrite => 'דרוס';

  @override
  String sftpTransferStarted(String fileName) {
    return 'ההעברה החלה: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'בחר תחילה יעד בחלונית האחרת';

  @override
  String get sftpDirectoryTransferNotSupported => 'העברת ספריות בקרוב';

  @override
  String get sftpSelect => 'בחירה';

  @override
  String get sftpOpen => 'פתיחה';

  @override
  String get sftpExtractArchive => 'חילוץ כאן';

  @override
  String get sftpExtractSuccess => 'הארכיון חולץ';

  @override
  String sftpExtractFailed(String message) {
    return 'החילוץ נכשל: $message';
  }

  @override
  String get sftpExtractUnsupported => 'פורמט ארכיון לא נתמך';

  @override
  String get sftpExtracting => 'מחלץ...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count העלאות החלו',
      one: 'ההעלאה החלה',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count הורדות החלו',
      one: 'ההורדה החלה',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" הורד';
  }

  @override
  String get sftpSavedToDownloads => 'נשמר ב-Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'שמור בקבצים';

  @override
  String get sftpFileSaved => 'הקובץ נשמר';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count הפעלות SSH פעילות',
      one: 'הפעלת SSH פעילה',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'הקש לפתיחת טרמינל';

  @override
  String get settingsAccountAndSync => 'חשבון וסנכרון';

  @override
  String get settingsAccountSubtitleAuth => 'מחובר';

  @override
  String get settingsAccountSubtitleUnauth => 'לא מחובר';

  @override
  String get settingsSecuritySubtitle => 'נעילה אוטומטית, ביומטריה, PIN';

  @override
  String get settingsSshSubtitle => 'פורט 22, משתמש root';

  @override
  String get settingsAppearanceSubtitle => 'ערכת נושא, שפה, טרמינל';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'ברירות מחדל ייצוא מוצפן';

  @override
  String get settingsAboutSubtitle => 'גרסה, רישיונות';

  @override
  String get settingsSearchHint => 'חיפוש הגדרות...';

  @override
  String get settingsSearchNoResults => 'לא נמצאו הגדרות';

  @override
  String get aboutDeveloper => 'פותח על ידי Kiefer Networks';

  @override
  String get aboutDonate => 'תרומה';

  @override
  String get aboutOpenSourceLicenses => 'רישיונות קוד פתוח';

  @override
  String get aboutWebsite => 'אתר אינטרנט';

  @override
  String get aboutVersion => 'גרסה';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS מצפין שאילתות DNS ומונע זיוף DNS. SSHVault בודק שמות מארח מול מספר ספקים כדי לזהות התקפות.';

  @override
  String get settingsDnsAddServer => 'הוספת שרת DNS';

  @override
  String get settingsDnsServerUrl => 'כתובת שרת';

  @override
  String get settingsDnsDefaultBadge => 'ברירת מחדל';

  @override
  String get settingsDnsResetDefaults => 'איפוס לברירות מחדל';

  @override
  String get settingsDnsInvalidUrl => 'הזן כתובת HTTPS תקינה';

  @override
  String get settingsDefaultAuthMethod => 'שיטת אימות';

  @override
  String get settingsAuthPassword => 'סיסמה';

  @override
  String get settingsAuthKey => 'מפתח SSH';

  @override
  String get settingsConnectionTimeout => 'זמן חיבור מרבי';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$secondsש';
  }

  @override
  String get settingsKeepaliveInterval => 'מרווח Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$secondsש';
  }

  @override
  String get settingsCompression => 'דחיסה';

  @override
  String get settingsCompressionDescription => 'הפעלת דחיסת zlib לחיבורי SSH';

  @override
  String get settingsTerminalType => 'סוג טרמינל';

  @override
  String get settingsSectionConnection => 'חיבור';

  @override
  String get settingsClipboardAutoClear => 'ניקוי לוח אוטומטי';

  @override
  String get settingsClipboardAutoClearOff => 'כבוי';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$secondsש';
  }

  @override
  String get settingsSessionTimeout => 'זמן הפעלה מרבי';

  @override
  String get settingsSessionTimeoutOff => 'כבוי';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes דקות';
  }

  @override
  String get settingsDuressPin => 'PIN כפייה';

  @override
  String get settingsDuressPinDescription =>
      'PIN נפרד שמוחק את כל הנתונים בהזנתו';

  @override
  String get settingsDuressPinSet => 'PIN כפייה מוגדר';

  @override
  String get settingsDuressPinNotSet => 'לא מוגדר';

  @override
  String get settingsDuressPinWarning =>
      'הזנת PIN זה תמחק לצמיתות את כל הנתונים המקומיים כולל אישורים, מפתחות והגדרות. לא ניתן לבטל פעולה זו.';

  @override
  String get settingsKeyRotationReminder => 'תזכורת החלפת מפתחות';

  @override
  String get settingsKeyRotationOff => 'כבוי';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days ימים';
  }

  @override
  String get settingsFailedAttempts => 'ניסיונות PIN כושלים';

  @override
  String get settingsSectionAppLock => 'נעילת אפליקציה';

  @override
  String get settingsSectionPrivacy => 'פרטיות';

  @override
  String get settingsSectionReminders => 'תזכורות';

  @override
  String get settingsSectionStatus => 'מצב';

  @override
  String get settingsExportBackupSubtitle => 'ייצוא, ייבוא וגיבוי';

  @override
  String get settingsExportJson => 'ייצוא כ-JSON';

  @override
  String get settingsExportEncrypted => 'ייצוא מוצפן';

  @override
  String get settingsImportFile => 'ייבוא מקובץ';

  @override
  String get settingsSectionImport => 'ייבוא';

  @override
  String get filterTitle => 'סינון שרתים';

  @override
  String get filterApply => 'החל מסננים';

  @override
  String get filterClearAll => 'נקה הכל';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count מסננים פעילים',
      one: 'מסנן 1 פעיל',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'תיקיה';

  @override
  String get filterTags => 'תגיות';

  @override
  String get filterStatus => 'מצב';

  @override
  String get variablePreviewResolved => 'תצוגה מקדימה מפוענחת';

  @override
  String get variableInsert => 'הכנסה';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count שרתים',
      one: 'שרת 1',
    );
    return '$_temp0';
  }

  @override
  String tagSnippetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count snippets',
      one: '1 snippet',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count הפעלות בוטלו.',
      one: 'הפעלה 1 בוטלה.',
    );
    return '$_temp0 התנתקת.';
  }

  @override
  String get keyGenPassphrase => 'ביטוי סיסמה';

  @override
  String get keyGenPassphraseHint => 'אופציונלי — מגן על המפתח הפרטי';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'ברירת מחדל (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'מפתח עם אותו טביעת אצבע כבר קיים: \"$name\". כל מפתח SSH חייב להיות ייחודי.';
  }

  @override
  String get sshKeyFingerprint => 'טביעת אצבע';

  @override
  String get sshKeyPublicKey => 'מפתח ציבורי';

  @override
  String get jumpHost => 'Jump Host';

  @override
  String get jumpHostNone => 'אין';

  @override
  String get jumpHostLabel => 'התחבר דרך jump host';

  @override
  String get jumpHostSelfError => 'שרת לא יכול להיות ה-jump host של עצמו';

  @override
  String get jumpHostConnecting => 'מתחבר ל-jump host...';

  @override
  String get jumpHostCircularError => 'זוהתה שרשרת jump host מעגלית';

  @override
  String get logoutDialogTitle => 'התנתקות';

  @override
  String get logoutDialogMessage =>
      'האם ברצונך למחוק את כל הנתונים המקומיים? שרתים, מפתחות SSH, קטעי קוד והגדרות יוסרו ממכשיר זה.';

  @override
  String get logoutOnly => 'התנתקות בלבד';

  @override
  String get logoutAndDelete => 'התנתקות ומחיקת נתונים';

  @override
  String get changeAvatar => 'שינוי תמונה';

  @override
  String get removeAvatar => 'הסרת תמונה';

  @override
  String get avatarUploadFailed => 'העלאת תמונה נכשלה';

  @override
  String get avatarTooLarge => 'התמונה גדולה מדי';

  @override
  String get deviceLastSeen => 'נראה לאחרונה';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'לא ניתן לשנות כתובת שרת בזמן שאתה מחובר. התנתק תחילה.';

  @override
  String get serverListNoFolder => 'ללא קטגוריה';

  @override
  String get autoSyncInterval => 'מרווח סנכרון';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes דקות';
  }

  @override
  String get proxySettings => 'הגדרות Proxy';

  @override
  String get proxyType => 'סוג Proxy';

  @override
  String get proxyNone => 'ללא Proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'שרת Proxy';

  @override
  String get proxyPort => 'פורט Proxy';

  @override
  String get proxyUsername => 'שם משתמש Proxy';

  @override
  String get proxyPassword => 'סיסמת Proxy';

  @override
  String get proxyUseGlobal => 'שימוש ב-Proxy גלובלי';

  @override
  String get proxyGlobal => 'גלובלי';

  @override
  String get proxyServerSpecific => 'ספציפי לשרת';

  @override
  String get proxyTestConnection => 'בדיקת חיבור';

  @override
  String get proxyTestSuccess => 'ה-Proxy נגיש';

  @override
  String get proxyTestFailed => 'ה-Proxy אינו נגיש';

  @override
  String get proxyDefaultProxy => 'Proxy ברירת מחדל';

  @override
  String get vpnRequired => 'VPN נדרש';

  @override
  String get vpnRequiredTooltip => 'הצג אזהרה בעת התחברות ללא VPN פעיל';

  @override
  String get vpnActive => 'VPN פעיל';

  @override
  String get vpnInactive => 'VPN לא פעיל';

  @override
  String get vpnWarningTitle => 'VPN אינו פעיל';

  @override
  String get vpnWarningMessage =>
      'שרת זה מסומן כדורש חיבור VPN, אך אין VPN פעיל כרגע. האם ברצונך להתחבר בכל זאת?';

  @override
  String get vpnConnectAnyway => 'התחבר בכל זאת';

  @override
  String get postConnectCommands => 'פקודות לאחר חיבור';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'פקודות המופעלות אוטומטית לאחר חיבור (אחת בכל שורה)';

  @override
  String get dashboardFavorites => 'מועדפים';

  @override
  String get dashboardRecent => 'אחרונים';

  @override
  String get dashboardActiveSessions => 'הפעלות פעילות';

  @override
  String get addToFavorites => 'הוספה למועדפים';

  @override
  String get removeFromFavorites => 'הסרה מהמועדפים';

  @override
  String get noRecentConnections => 'אין חיבורים אחרונים';

  @override
  String get terminalSplit => 'תצוגה מפוצלת';

  @override
  String get terminalUnsplit => 'סגירת פיצול';

  @override
  String get terminalSelectSession => 'בחר הפעלה לתצוגה מפוצלת';

  @override
  String get knownHostsTitle => 'שרתים מוכרים';

  @override
  String get knownHostsSubtitle => 'ניהול טביעות אצבע של שרתים מהימנים';

  @override
  String get hostKeyNewTitle => 'שרת חדש';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'חיבור ראשון ל-$hostname:$port. אמת את טביעת האצבע לפני ההתחברות.';
  }

  @override
  String get hostKeyChangedTitle => 'מפתח השרת השתנה!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'מפתח השרת עבור $hostname:$port השתנה. ייתכן שמדובר באיום אבטחה.';
  }

  @override
  String get hostKeyFingerprint => 'טביעת אצבע';

  @override
  String get hostKeyType => 'סוג מפתח';

  @override
  String get hostKeyTrustConnect => 'אמון והתחברות';

  @override
  String get hostKeyAcceptNew => 'קבל מפתח חדש';

  @override
  String get hostKeyReject => 'דחייה';

  @override
  String get hostKeyPreviousFingerprint => 'טביעת אצבע קודמת';

  @override
  String get hostKeyDeleteAll => 'מחק את כל השרתים המוכרים';

  @override
  String get hostKeyDeleteConfirm =>
      'האם אתה בטוח שברצונך להסיר את כל השרתים המוכרים? תתבקש שוב בחיבור הבא.';

  @override
  String get hostKeyEmpty => 'אין שרתים מוכרים עדיין';

  @override
  String get hostKeyEmptySubtitle =>
      'טביעות אצבע של שרתים יישמרו כאן לאחר החיבור הראשון שלך';

  @override
  String get hostKeyFirstSeen => 'נראה לראשונה';

  @override
  String get hostKeyLastSeen => 'נראה לאחרונה';

  @override
  String get sshConfigImportTitle => 'ייבוא תצורת SSH';

  @override
  String get sshConfigImportPickFile => 'בחר קובץ תצורת SSH';

  @override
  String get sshConfigImportOrPaste => 'או הדבק תוכן תצורה';

  @override
  String sshConfigImportParsed(int count) {
    return 'נמצאו $count שרתים';
  }

  @override
  String get sshConfigImportButton => 'ייבוא';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count שרתים יובאו';
  }

  @override
  String get sshConfigImportDuplicate => 'כבר קיים';

  @override
  String get sshConfigImportNoHosts => 'לא נמצאו שרתים בתצורה';

  @override
  String get sftpBookmarkAdd => 'הוספת סימנייה';

  @override
  String get sftpBookmarkLabel => 'תווית';

  @override
  String get disconnect => 'ניתוק';

  @override
  String get reportAndDisconnect => 'דיווח וניתוק';

  @override
  String get continueAnyway => 'המשך בכל זאת';

  @override
  String get insertSnippet => 'הכנסת קטע קוד';

  @override
  String get seconds => 'שניות';

  @override
  String get heartbeatLostMessage =>
      'לא ניתן היה להגיע לשרת לאחר מספר ניסיונות. לביטחונך, ההפעלה הסתיימה.';

  @override
  String get attestationFailedTitle => 'אימות השרת נכשל';

  @override
  String get attestationFailedMessage =>
      'לא ניתן היה לאמת את השרת כ-backend SSHVault לגיטימי. ייתכן שמדובר בהתקפת man-in-the-middle או בשרת שהוגדר שלא כהלכה.';

  @override
  String get attestationKeyChangedTitle => 'מפתח השרת השתנה';

  @override
  String get attestationKeyChangedMessage =>
      'מפתח האימות של השרת השתנה מאז החיבור הראשוני. ייתכן שמדובר בהתקפת man-in-the-middle. אל תמשיך אלא אם מנהל השרת אישר החלפת מפתח.';

  @override
  String get sectionLinks => 'קישורים';

  @override
  String get sectionDeveloper => 'מפתח';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'הדף לא נמצא';

  @override
  String get connectionTestSuccess => 'החיבור הצליח';

  @override
  String connectionTestFailed(String message) {
    return 'החיבור נכשל: $message';
  }

  @override
  String get serverVerificationFailed => 'אימות השרת נכשל';

  @override
  String get importSuccessful => 'הייבוא הצליח';

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
  String get deviceDeleteConfirmTitle => 'הסרת מכשיר';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'האם אתה בטוח שברצונך להסיר את \"$name\"? המכשיר יתנתק מיד.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'זהו המכשיר הנוכחי שלך. תתנתק מיד.';

  @override
  String get deviceDeleteSuccess => 'המכשיר הוסר';

  @override
  String get deviceDeletedCurrentLogout => 'המכשיר הנוכחי הוסר. התנתקת.';

  @override
  String get thisDevice => 'מכשיר זה';
}
