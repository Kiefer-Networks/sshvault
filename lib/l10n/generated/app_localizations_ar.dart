// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'المضيفون';

  @override
  String get navSnippets => 'المقتطفات';

  @override
  String get navFolders => 'المجلدات';

  @override
  String get navTags => 'العلامات';

  @override
  String get navSshKeys => 'مفاتيح SSH';

  @override
  String get navExportImport => 'تصدير / استيراد';

  @override
  String get navTerminal => 'الطرفية';

  @override
  String get navMore => 'المزيد';

  @override
  String get navManagement => 'الإدارة';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navAbout => 'حول';

  @override
  String get lockScreenTitle => 'SSHVault مقفل';

  @override
  String get lockScreenUnlock => 'فتح القفل';

  @override
  String get lockScreenEnterPin => 'أدخل رمز PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'محاولات فاشلة كثيرة. حاول مرة أخرى بعد $minutes دقيقة.';
  }

  @override
  String get pinDialogSetTitle => 'تعيين رمز PIN';

  @override
  String get pinDialogSetSubtitle =>
      'أدخل رمز PIN مكون من 6 أرقام لحماية SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'تأكيد رمز PIN';

  @override
  String get pinDialogErrorLength =>
      'يجب أن يكون رمز PIN مكونًا من 6 أرقام بالضبط';

  @override
  String get pinDialogErrorMismatch => 'رمز PIN غير متطابق';

  @override
  String get pinDialogVerifyTitle => 'أدخل رمز PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'رمز PIN خاطئ. $attempts محاولات متبقية.';
  }

  @override
  String get securityBannerMessage =>
      'بيانات اعتماد SSH غير محمية. قم بإعداد رمز PIN أو القفل البيومتري في الإعدادات.';

  @override
  String get securityBannerDismiss => 'تجاهل';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSectionAppearance => 'المظهر';

  @override
  String get settingsSectionTerminal => 'الطرفية';

  @override
  String get settingsSectionSshDefaults => 'إعدادات SSH الافتراضية';

  @override
  String get settingsSectionSecurity => 'الأمان';

  @override
  String get settingsSectionExport => 'التصدير';

  @override
  String get settingsSectionAbout => 'حول';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get settingsThemeSystem => 'النظام';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsTerminalTheme => 'سمة الطرفية';

  @override
  String get settingsTerminalThemeDefault => 'داكن افتراضي';

  @override
  String get settingsFontSize => 'حجم الخط';

  @override
  String settingsFontSizeValue(int size) {
    return '$size بكسل';
  }

  @override
  String get settingsDefaultPort => 'المنفذ الافتراضي';

  @override
  String get settingsDefaultPortDialog => 'منفذ SSH الافتراضي';

  @override
  String get settingsPortLabel => 'المنفذ';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'اسم المستخدم الافتراضي';

  @override
  String get settingsDefaultUsernameDialog => 'اسم المستخدم الافتراضي';

  @override
  String get settingsUsernameLabel => 'اسم المستخدم';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'مهلة القفل التلقائي';

  @override
  String get settingsAutoLockDisabled => 'معطل';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes دقائق';
  }

  @override
  String get settingsAutoLockOff => 'إيقاف';

  @override
  String get settingsAutoLock1Min => '1 دقيقة';

  @override
  String get settingsAutoLock5Min => '5 دقائق';

  @override
  String get settingsAutoLock15Min => '15 دقيقة';

  @override
  String get settingsAutoLock30Min => '30 دقيقة';

  @override
  String get settingsBiometricUnlock => 'الفتح البيومتري';

  @override
  String get settingsBiometricNotAvailable => 'غير متاح على هذا الجهاز';

  @override
  String get settingsBiometricError => 'خطأ في فحص البيانات البيومترية';

  @override
  String get settingsBiometricReason => 'تحقق من هويتك لتفعيل الفتح البيومتري';

  @override
  String get settingsBiometricRequiresPin =>
      'قم بتعيين رمز PIN أولاً لتفعيل الفتح البيومتري';

  @override
  String get settingsPinCode => 'رمز PIN';

  @override
  String get settingsPinIsSet => 'تم تعيين رمز PIN';

  @override
  String get settingsPinNotConfigured => 'لم يتم تكوين رمز PIN';

  @override
  String get settingsPinRemove => 'إزالة';

  @override
  String get settingsPinRemoveWarning =>
      'ستؤدي إزالة رمز PIN إلى فك تشفير جميع حقول قاعدة البيانات وتعطيل الفتح البيومتري. هل تريد المتابعة؟';

  @override
  String get settingsPinRemoveTitle => 'إزالة رمز PIN';

  @override
  String get settingsPreventScreenshots => 'منع لقطات الشاشة';

  @override
  String get settingsPreventScreenshotsDescription =>
      'حظر لقطات الشاشة وتسجيل الشاشة';

  @override
  String get settingsEncryptExport => 'تشفير التصديرات افتراضيًا';

  @override
  String get settingsAbout => 'حول SSHVault';

  @override
  String get settingsAboutLegalese => 'من Kiefer Networks';

  @override
  String get settingsAboutDescription => 'عميل SSH آمن ذاتي الاستضافة';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsLanguageSystem => 'النظام';

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
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get close => 'إغلاق';

  @override
  String get update => 'تحديث';

  @override
  String get create => 'إنشاء';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get copy => 'نسخ';

  @override
  String get edit => 'تعديل';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'خطأ: $message';
  }

  @override
  String get serverListTitle => 'المضيفون';

  @override
  String get serverListEmpty => 'لا توجد خوادم بعد';

  @override
  String get serverListEmptySubtitle => 'أضف أول خادم SSH للبدء.';

  @override
  String get serverAddButton => 'إضافة خادم';

  @override
  String sshConfigImportMessage(int count) {
    return 'تم العثور على $count مضيف(ين) في ~/.ssh/config. هل تريد استيرادهم؟';
  }

  @override
  String get sshConfigNotFound => 'لم يتم العثور على ملف إعدادات SSH';

  @override
  String get sshConfigEmpty => 'لم يتم العثور على مضيفين في إعدادات SSH';

  @override
  String get sshConfigAddManually => 'إضافة يدويًا';

  @override
  String get sshConfigImportAgain => 'استيراد إعدادات SSH مرة أخرى؟';

  @override
  String get sshConfigImportKeys =>
      'استيراد مفاتيح SSH المرتبطة بالمضيفين المحددين؟';

  @override
  String sshConfigKeysImported(int count) {
    return 'تم استيراد $count مفتاح(مفاتيح) SSH';
  }

  @override
  String get serverDuplicated => 'تم تكرار الخادم';

  @override
  String get serverDeleteTitle => 'حذف الخادم';

  @override
  String serverDeleteMessage(String name) {
    return 'هل أنت متأكد من حذف \"$name\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'حذف \"$name\"؟';
  }

  @override
  String get serverConnect => 'اتصال';

  @override
  String get serverDetails => 'التفاصيل';

  @override
  String get serverDuplicate => 'تكرار';

  @override
  String get serverActive => 'نشط';

  @override
  String get serverNoFolder => 'بدون مجلد';

  @override
  String get serverFormTitleEdit => 'تعديل الخادم';

  @override
  String get serverFormTitleAdd => 'إضافة خادم';

  @override
  String get serverSaved => 'تم حفظ الخادم';

  @override
  String get serverFormUpdateButton => 'تحديث الخادم';

  @override
  String get serverFormAddButton => 'إضافة خادم';

  @override
  String get serverFormPublicKeyExtracted => 'تم استخراج المفتاح العام بنجاح';

  @override
  String serverFormPublicKeyError(String message) {
    return 'تعذر استخراج المفتاح العام: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'تم إنشاء زوج مفاتيح $type';
  }

  @override
  String get serverDetailTitle => 'تفاصيل الخادم';

  @override
  String get serverDetailDeleteMessage => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get serverDetailConnection => 'الاتصال';

  @override
  String get serverDetailHost => 'المضيف';

  @override
  String get serverDetailPort => 'المنفذ';

  @override
  String get serverDetailUsername => 'اسم المستخدم';

  @override
  String get serverDetailFolder => 'المجلد';

  @override
  String get serverDetailTags => 'العلامات';

  @override
  String get serverDetailNotes => 'الملاحظات';

  @override
  String get serverDetailInfo => 'معلومات';

  @override
  String get serverDetailCreated => 'تاريخ الإنشاء';

  @override
  String get serverDetailUpdated => 'تاريخ التحديث';

  @override
  String get serverDetailDistro => 'النظام';

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get serverFormNameLabel => 'اسم الخادم';

  @override
  String get serverFormHostnameLabel => 'اسم المضيف / عنوان IP';

  @override
  String get serverFormPortLabel => 'المنفذ';

  @override
  String get serverFormUsernameLabel => 'اسم المستخدم';

  @override
  String get serverFormPasswordLabel => 'كلمة المرور';

  @override
  String get serverFormUseManagedKey => 'استخدام مفتاح مُدار';

  @override
  String get serverFormManagedKeySubtitle =>
      'اختيار من مفاتيح SSH المُدارة مركزيًا';

  @override
  String get serverFormDirectKeySubtitle => 'لصق المفتاح مباشرة في هذا الخادم';

  @override
  String get serverFormGenerateKey => 'إنشاء زوج مفاتيح SSH';

  @override
  String get serverFormPrivateKeyLabel => 'المفتاح الخاص';

  @override
  String get serverFormPrivateKeyHint => 'الصق مفتاح SSH الخاص...';

  @override
  String get serverFormExtractPublicKey => 'استخراج المفتاح العام';

  @override
  String get serverFormPublicKeyLabel => 'المفتاح العام';

  @override
  String get serverFormPublicKeyHint =>
      'يتم إنشاؤه تلقائيًا من المفتاح الخاص إذا كان فارغًا';

  @override
  String get serverFormPassphraseLabel => 'عبارة مرور المفتاح (اختياري)';

  @override
  String get serverFormNotesLabel => 'ملاحظات (اختياري)';

  @override
  String get searchServers => 'البحث عن خوادم...';

  @override
  String get filterAllFolders => 'جميع المجلدات';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterActive => 'نشط';

  @override
  String get filterInactive => 'غير نشط';

  @override
  String get filterClear => 'مسح';

  @override
  String get folderListTitle => 'المجلدات';

  @override
  String get folderListEmpty => 'لا توجد مجلدات بعد';

  @override
  String get folderListEmptySubtitle => 'أنشئ مجلدات لتنظيم خوادمك.';

  @override
  String get folderAddButton => 'إضافة مجلد';

  @override
  String get folderDeleteTitle => 'حذف المجلد';

  @override
  String folderDeleteMessage(String name) {
    return 'حذف \"$name\"؟ ستصبح الخوادم غير مصنفة.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خوادم',
      one: 'خادم واحد',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'طي';

  @override
  String get folderShowHosts => 'عرض المضيفين';

  @override
  String get folderConnectAll => 'اتصال بالكل';

  @override
  String get folderFormTitleEdit => 'تعديل المجلد';

  @override
  String get folderFormTitleNew => 'مجلد جديد';

  @override
  String get folderFormNameLabel => 'اسم المجلد';

  @override
  String get folderFormParentLabel => 'المجلد الأصل';

  @override
  String get folderFormParentNone => 'بدون (جذر)';

  @override
  String get tagListTitle => 'العلامات';

  @override
  String get tagListEmpty => 'لا توجد علامات بعد';

  @override
  String get tagListEmptySubtitle => 'أنشئ علامات لتصنيف وتصفية خوادمك.';

  @override
  String get tagAddButton => 'إضافة علامة';

  @override
  String get tagDeleteTitle => 'حذف العلامة';

  @override
  String tagDeleteMessage(String name) {
    return 'حذف \"$name\"؟ ستتم إزالتها من جميع الخوادم.';
  }

  @override
  String get tagFormTitleEdit => 'تعديل العلامة';

  @override
  String get tagFormTitleNew => 'علامة جديدة';

  @override
  String get tagFormNameLabel => 'اسم العلامة';

  @override
  String get sshKeyListTitle => 'مفاتيح SSH';

  @override
  String get sshKeyListEmpty => 'لا توجد مفاتيح SSH بعد';

  @override
  String get sshKeyListEmptySubtitle =>
      'أنشئ أو استورد مفاتيح SSH لإدارتها مركزيًا';

  @override
  String get sshKeyCannotDeleteTitle => 'لا يمكن الحذف';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'لا يمكن حذف \"$name\". مستخدم من قبل $count خادم(خوادم). قم بفك الربط من جميع الخوادم أولاً.';
  }

  @override
  String get sshKeyDeleteTitle => 'حذف مفتاح SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'حذف \"$name\"؟ لا يمكن التراجع عن هذا.';
  }

  @override
  String get sshKeyAddButton => 'إضافة مفتاح SSH';

  @override
  String get sshKeyFormTitleEdit => 'تعديل مفتاح SSH';

  @override
  String get sshKeyFormTitleAdd => 'إضافة مفتاح SSH';

  @override
  String get sshKeyFormTabGenerate => 'إنشاء';

  @override
  String get sshKeyFormTabImport => 'استيراد';

  @override
  String get sshKeyFormNameLabel => 'اسم المفتاح';

  @override
  String get sshKeyFormNameHint => 'مثال: مفتاح الإنتاج';

  @override
  String get sshKeyFormKeyType => 'نوع المفتاح';

  @override
  String get sshKeyFormKeySize => 'حجم المفتاح';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits بت';
  }

  @override
  String get sshKeyFormCommentLabel => 'تعليق';

  @override
  String get sshKeyFormCommentHint => 'user@host أو وصف';

  @override
  String get sshKeyFormCommentOptional => 'تعليق (اختياري)';

  @override
  String get sshKeyFormImportFromFile => 'استيراد من ملف';

  @override
  String get sshKeyFormPrivateKeyLabel => 'المفتاح الخاص';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'الصق مفتاح SSH الخاص أو استخدم الزر أعلاه...';

  @override
  String get sshKeyFormPassphraseLabel => 'عبارة المرور (اختياري)';

  @override
  String get sshKeyFormNameRequired => 'الاسم مطلوب';

  @override
  String get sshKeyFormPrivateKeyRequired => 'المفتاح الخاص مطلوب';

  @override
  String get sshKeyFormFileReadError => 'تعذرت قراءة الملف المحدد';

  @override
  String get sshKeyFormInvalidFormat =>
      'تنسيق مفتاح غير صالح — يُتوقع تنسيق PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'فشل في قراءة الملف: $message';
  }

  @override
  String get sshKeyFormSaving => 'جارٍ الحفظ...';

  @override
  String get sshKeySelectorLabel => 'مفتاح SSH';

  @override
  String get sshKeySelectorNone => 'بدون مفتاح مُدار';

  @override
  String get sshKeySelectorManage => 'إدارة المفاتيح...';

  @override
  String get sshKeySelectorError => 'فشل في تحميل مفاتيح SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'نسخ المفتاح العام';

  @override
  String get sshKeyTilePublicKeyCopied => 'تم نسخ المفتاح العام';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'مستخدم من قبل $count خادم(خوادم)';
  }

  @override
  String get sshKeySavedSuccess => 'تم حفظ مفتاح SSH';

  @override
  String get sshKeyDeletedSuccess => 'تم حذف مفتاح SSH';

  @override
  String get tagSavedSuccess => 'تم حفظ الوسم';

  @override
  String get tagDeletedSuccess => 'تم حذف الوسم';

  @override
  String get folderDeletedSuccess => 'تم حذف المجلد';

  @override
  String get sshKeyTileUnlinkFirst => 'قم بفك الربط من جميع الخوادم أولاً';

  @override
  String get exportImportTitle => 'تصدير / استيراد';

  @override
  String get exportSectionTitle => 'تصدير';

  @override
  String get exportJsonButton => 'تصدير كـ JSON (بدون بيانات اعتماد)';

  @override
  String get exportZipButton => 'تصدير ZIP مشفر (مع بيانات اعتماد)';

  @override
  String get importSectionTitle => 'استيراد';

  @override
  String get importButton => 'استيراد من ملف';

  @override
  String get importSupportedFormats => 'يدعم ملفات JSON (عادية) و ZIP (مشفرة).';

  @override
  String exportedTo(String path) {
    return 'تم التصدير إلى: $path';
  }

  @override
  String get share => 'مشاركة';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'تم استيراد $servers خوادم، $groups مجموعات، $tags علامات. تم تخطي $skipped.';
  }

  @override
  String get importPasswordTitle => 'أدخل كلمة المرور';

  @override
  String get importPasswordLabel => 'كلمة مرور التصدير';

  @override
  String get importPasswordDecrypt => 'فك التشفير';

  @override
  String get exportPasswordTitle => 'تعيين كلمة مرور التصدير';

  @override
  String get exportPasswordDescription =>
      'ستُستخدم كلمة المرور هذه لتشفير ملف التصدير بما في ذلك بيانات الاعتماد.';

  @override
  String get exportPasswordLabel => 'كلمة المرور';

  @override
  String get exportPasswordConfirmLabel => 'تأكيد كلمة المرور';

  @override
  String get exportPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get exportPasswordButton => 'تشفير وتصدير';

  @override
  String get importConflictTitle => 'معالجة التعارضات';

  @override
  String get importConflictDescription =>
      'كيف يجب التعامل مع الإدخالات الموجودة أثناء الاستيراد؟';

  @override
  String get importConflictSkip => 'تخطي الموجود';

  @override
  String get importConflictRename => 'إعادة تسمية الجديد';

  @override
  String get importConflictOverwrite => 'الكتابة فوق';

  @override
  String get confirmDeleteLabel => 'حذف';

  @override
  String get keyGenTitle => 'إنشاء زوج مفاتيح SSH';

  @override
  String get keyGenKeyType => 'نوع المفتاح';

  @override
  String get keyGenKeySize => 'حجم المفتاح';

  @override
  String get keyGenComment => 'تعليق';

  @override
  String get keyGenCommentHint => 'user@host أو وصف';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits بت';
  }

  @override
  String get keyGenGenerating => 'جارٍ الإنشاء...';

  @override
  String get keyGenGenerate => 'إنشاء';

  @override
  String keyGenResultTitle(String type) {
    return 'تم إنشاء مفتاح $type';
  }

  @override
  String get keyGenPublicKey => 'المفتاح العام';

  @override
  String get keyGenPrivateKey => 'المفتاح الخاص';

  @override
  String keyGenCommentInfo(String comment) {
    return 'تعليق: $comment';
  }

  @override
  String get keyGenAnother => 'إنشاء آخر';

  @override
  String get keyGenUseThisKey => 'استخدام هذا المفتاح';

  @override
  String get keyGenCopyTooltip => 'نسخ إلى الحافظة';

  @override
  String keyGenCopied(String label) {
    return 'تم نسخ $label';
  }

  @override
  String get colorPickerLabel => 'اللون';

  @override
  String get iconPickerLabel => 'الأيقونة';

  @override
  String get tagSelectorLabel => 'العلامات';

  @override
  String get tagSelectorEmpty => 'لا توجد علامات بعد';

  @override
  String get tagSelectorError => 'فشل في تحميل العلامات';

  @override
  String get snippetListTitle => 'المقتطفات';

  @override
  String get snippetSearchHint => 'البحث في المقتطفات...';

  @override
  String get snippetListEmpty => 'لا توجد مقتطفات بعد';

  @override
  String get snippetListEmptySubtitle =>
      'أنشئ مقتطفات أكواد وأوامر قابلة لإعادة الاستخدام.';

  @override
  String get snippetAddButton => 'إضافة مقتطف';

  @override
  String get snippetDeleteTitle => 'حذف المقتطف';

  @override
  String snippetDeleteMessage(String name) {
    return 'حذف \"$name\"؟ لا يمكن التراجع عن هذا.';
  }

  @override
  String get snippetFormTitleEdit => 'تعديل المقتطف';

  @override
  String get snippetFormTitleNew => 'مقتطف جديد';

  @override
  String get snippetFormNameLabel => 'الاسم';

  @override
  String get snippetFormNameHint => 'مثال: تنظيف Docker';

  @override
  String get snippetFormLanguageLabel => 'اللغة';

  @override
  String get snippetFormContentLabel => 'المحتوى';

  @override
  String get snippetFormContentHint => 'أدخل كود المقتطف...';

  @override
  String get snippetFormDescriptionLabel => 'الوصف';

  @override
  String get snippetFormDescriptionHint => 'وصف اختياري...';

  @override
  String get snippetFormFolderLabel => 'المجلد';

  @override
  String get snippetFormNoFolder => 'بدون مجلد';

  @override
  String get snippetFormNameRequired => 'الاسم مطلوب';

  @override
  String get snippetFormContentRequired => 'المحتوى مطلوب';

  @override
  String get snippetFormSaved => 'تم حفظ المقتطف';

  @override
  String get snippetFormUpdateButton => 'تحديث المقتطف';

  @override
  String get snippetFormCreateButton => 'إنشاء المقتطف';

  @override
  String get snippetDetailTitle => 'تفاصيل المقتطف';

  @override
  String get snippetDetailDeleteTitle => 'حذف المقتطف';

  @override
  String get snippetDetailDeleteMessage => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get snippetDetailContent => 'المحتوى';

  @override
  String get snippetDetailFillVariables => 'ملء المتغيرات';

  @override
  String get snippetDetailDescription => 'الوصف';

  @override
  String get snippetDetailVariables => 'المتغيرات';

  @override
  String get snippetDetailTags => 'العلامات';

  @override
  String get snippetDetailInfo => 'معلومات';

  @override
  String get snippetDetailCreated => 'تاريخ الإنشاء';

  @override
  String get snippetDetailUpdated => 'تاريخ التحديث';

  @override
  String get variableEditorTitle => 'متغيرات القالب';

  @override
  String get variableEditorAdd => 'إضافة';

  @override
  String get variableEditorEmpty =>
      'لا توجد متغيرات. استخدم صيغة الأقواس المعقوفة في المحتوى للإشارة إليها.';

  @override
  String get variableEditorNameLabel => 'الاسم';

  @override
  String get variableEditorNameHint => 'مثال: hostname';

  @override
  String get variableEditorDefaultLabel => 'الافتراضي';

  @override
  String get variableEditorDefaultHint => 'اختياري';

  @override
  String get variableFillTitle => 'ملء المتغيرات';

  @override
  String variableFillHint(String name) {
    return 'أدخل قيمة لـ $name';
  }

  @override
  String get variableFillPreview => 'معاينة';

  @override
  String get terminalTitle => 'الطرفية';

  @override
  String get terminalEmpty => 'لا توجد جلسات نشطة';

  @override
  String get terminalEmptySubtitle => 'اتصل بمضيف لفتح جلسة طرفية.';

  @override
  String get terminalGoToHosts => 'الانتقال إلى المضيفين';

  @override
  String get terminalCloseAll => 'إغلاق جميع الجلسات';

  @override
  String get terminalCloseTitle => 'إغلاق الجلسة';

  @override
  String terminalCloseMessage(String title) {
    return 'إغلاق الاتصال النشط بـ \"$title\"؟';
  }

  @override
  String get connectionAuthenticating => 'جارٍ المصادقة...';

  @override
  String connectionConnecting(String name) {
    return 'جارٍ الاتصال بـ $name...';
  }

  @override
  String get connectionError => 'خطأ في الاتصال';

  @override
  String get connectionLost => 'تم فقدان الاتصال';

  @override
  String get connectionReconnect => 'إعادة الاتصال';

  @override
  String get snippetQuickPanelTitle => 'إدراج مقتطف';

  @override
  String get snippetQuickPanelSearch => 'البحث في المقتطفات...';

  @override
  String get snippetQuickPanelEmpty => 'لا توجد مقتطفات متاحة';

  @override
  String get snippetQuickPanelNoMatch => 'لا توجد مقتطفات مطابقة';

  @override
  String get snippetQuickPanelInsertTooltip => 'إدراج مقتطف';

  @override
  String get terminalThemePickerTitle => 'سمة الطرفية';

  @override
  String get validatorHostnameRequired => 'اسم المضيف مطلوب';

  @override
  String get validatorHostnameInvalid => 'اسم مضيف أو عنوان IP غير صالح';

  @override
  String get validatorPortRequired => 'المنفذ مطلوب';

  @override
  String get validatorPortRange => 'يجب أن يكون المنفذ بين 1 و 65535';

  @override
  String get validatorUsernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get validatorUsernameInvalid => 'صيغة اسم المستخدم غير صالحة';

  @override
  String get validatorServerNameRequired => 'اسم الخادم مطلوب';

  @override
  String get validatorServerNameLength => 'يجب ألا يتجاوز اسم الخادم 100 حرف';

  @override
  String get validatorSshKeyInvalid => 'صيغة مفتاح SSH غير صالحة';

  @override
  String get validatorPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String get validatorPasswordLength =>
      'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get authMethodPassword => 'كلمة المرور';

  @override
  String get authMethodKey => 'مفتاح SSH';

  @override
  String get authMethodBoth => 'كلمة المرور + مفتاح';

  @override
  String get serverCopySuffix => '(نسخة)';

  @override
  String get settingsDownloadLogs => 'تحميل السجلات';

  @override
  String get settingsSendLogs => 'إرسال السجلات إلى الدعم';

  @override
  String get settingsLogsSaved => 'تم حفظ السجلات بنجاح';

  @override
  String get settingsUpdated => 'تم تحديث الإعداد';

  @override
  String get settingsThemeChanged => 'تم تغيير السمة';

  @override
  String get settingsLanguageChanged => 'تم تغيير اللغة';

  @override
  String get settingsPinSetSuccess => 'تم تعيين الرمز';

  @override
  String get settingsPinRemovedSuccess => 'تم إزالة الرمز';

  @override
  String get settingsDuressPinSetSuccess => 'تم تعيين رمز الإكراه';

  @override
  String get settingsDuressPinRemovedSuccess => 'تم إزالة رمز الإكراه';

  @override
  String get settingsBiometricEnabled => 'تم تفعيل القياسات الحيوية';

  @override
  String get settingsBiometricDisabled => 'تم تعطيل القياسات الحيوية';

  @override
  String get settingsDnsServerAdded => 'تمت إضافة خادم DNS';

  @override
  String get settingsDnsServerRemoved => 'تمت إزالة خادم DNS';

  @override
  String get settingsDnsResetSuccess => 'تمت إعادة تعيين خوادم DNS';

  @override
  String get settingsFontSizeDecreaseTooltip => 'تصغير الخط';

  @override
  String get settingsFontSizeIncreaseTooltip => 'تكبير الخط';

  @override
  String get settingsDnsRemoveServerTooltip => 'إزالة خادم DNS';

  @override
  String get settingsLogsEmpty => 'لا توجد إدخالات سجل متاحة';

  @override
  String get authLogin => 'تسجيل الدخول';

  @override
  String get authRegister => 'التسجيل';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authWhyLogin =>
      'سجل الدخول لتفعيل المزامنة السحابية المشفرة عبر جميع أجهزتك. يعمل التطبيق بالكامل بدون اتصال بدون حساب.';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get authEmailInvalid => 'عنوان بريد إلكتروني غير صالح';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get authPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get authNoAccount => 'ليس لديك حساب؟';

  @override
  String get authHasAccount => 'لديك حساب بالفعل؟';

  @override
  String get authResetEmailSent =>
      'إذا كان الحساب موجودًا، فقد تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني.';

  @override
  String get authResetDescription =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get authSendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get authBackToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get syncPasswordTitle => 'كلمة مرور المزامنة';

  @override
  String get syncPasswordTitleCreate => 'تعيين كلمة مرور المزامنة';

  @override
  String get syncPasswordTitleEnter => 'أدخل كلمة مرور المزامنة';

  @override
  String get syncPasswordDescription =>
      'عيّن كلمة مرور منفصلة لتشفير بيانات الخزنة. لا تغادر كلمة المرور هذه جهازك أبدًا — يخزن الخادم البيانات المشفرة فقط.';

  @override
  String get syncPasswordHintEnter =>
      'أدخل كلمة المرور التي عيّنتها عند إنشاء حسابك.';

  @override
  String get syncPasswordWarning =>
      'إذا نسيت كلمة المرور هذه، لا يمكن استرداد بياناتك المزامنة. لا يوجد خيار إعادة تعيين.';

  @override
  String get syncPasswordLabel => 'كلمة مرور المزامنة';

  @override
  String get syncPasswordWrong => 'كلمة مرور خاطئة. يرجى المحاولة مرة أخرى.';

  @override
  String get firstSyncTitle => 'تم العثور على بيانات موجودة';

  @override
  String get firstSyncMessage =>
      'يحتوي هذا الجهاز على بيانات موجودة والخادم يحتوي على خزنة. كيف نتابع؟';

  @override
  String get firstSyncMerge => 'دمج (الخادم يسود)';

  @override
  String get firstSyncOverwriteLocal => 'الكتابة فوق البيانات المحلية';

  @override
  String get firstSyncKeepLocal => 'الاحتفاظ بالمحلي والدفع';

  @override
  String get firstSyncDeleteLocal => 'حذف المحلي والسحب';

  @override
  String get changeEncryptionPassword => 'تغيير كلمة مرور التشفير';

  @override
  String get changeEncryptionWarning =>
      'سيتم تسجيل خروجك من جميع الأجهزة الأخرى.';

  @override
  String get changeEncryptionOldPassword => 'كلمة المرور الحالية';

  @override
  String get changeEncryptionNewPassword => 'كلمة المرور الجديدة';

  @override
  String get changeEncryptionSuccess => 'تم تغيير كلمة المرور بنجاح.';

  @override
  String get logoutAllDevices => 'تسجيل الخروج من جميع الأجهزة';

  @override
  String get logoutAllDevicesConfirm =>
      'سيؤدي هذا إلى إلغاء جميع الجلسات النشطة. ستحتاج إلى تسجيل الدخول مرة أخرى على جميع الأجهزة.';

  @override
  String get logoutAllDevicesSuccess => 'تم تسجيل الخروج من جميع الأجهزة.';

  @override
  String get syncSettingsTitle => 'إعدادات المزامنة';

  @override
  String get syncAutoSync => 'المزامنة التلقائية';

  @override
  String get syncAutoSyncDescription => 'المزامنة تلقائيًا عند بدء التطبيق';

  @override
  String get syncNow => 'مزامنة الآن';

  @override
  String get syncSyncing => 'جارٍ المزامنة...';

  @override
  String get syncSuccess => 'اكتملت المزامنة';

  @override
  String get syncError => 'خطأ في المزامنة';

  @override
  String get syncServerUnreachable => 'الخادم غير قابل للوصول';

  @override
  String get syncServerUnreachableHint =>
      'تعذر الوصول إلى خادم المزامنة. تحقق من اتصالك بالإنترنت وعنوان الخادم.';

  @override
  String get syncNetworkError =>
      'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت أو المحاولة لاحقًا.';

  @override
  String get syncNeverSynced => 'لم تتم المزامنة مطلقًا';

  @override
  String get syncVaultVersion => 'إصدار الخزنة';

  @override
  String get syncTitle => 'المزامنة';

  @override
  String get settingsSectionNetwork => 'الشبكة و DNS';

  @override
  String get settingsDnsServers => 'خوادم DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'الافتراضي (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'أدخل عناوين خوادم DoH مخصصة، مفصولة بفواصل. يلزم خادمان على الأقل للتحقق المتبادل.';

  @override
  String get settingsDnsLabel => 'عناوين خوادم DoH';

  @override
  String get settingsDnsReset => 'إعادة التعيين إلى الافتراضي';

  @override
  String get settingsSectionSync => 'المزامنة';

  @override
  String get settingsSyncAccount => 'الحساب';

  @override
  String get settingsSyncNotLoggedIn => 'غير مسجل الدخول';

  @override
  String get settingsSyncStatus => 'المزامنة';

  @override
  String get settingsSyncServerUrl => 'عنوان الخادم';

  @override
  String get settingsSyncDefaultServer => 'الافتراضي (sshvault.app)';

  @override
  String get accountTitle => 'الحساب';

  @override
  String get accountNotLoggedIn => 'غير مسجل الدخول';

  @override
  String get accountVerified => 'تم التحقق';

  @override
  String get accountMemberSince => 'عضو منذ';

  @override
  String get accountDevices => 'الأجهزة';

  @override
  String get accountNoDevices => 'لا توجد أجهزة مسجلة';

  @override
  String get accountLastSync => 'آخر مزامنة';

  @override
  String get accountChangePassword => 'تغيير كلمة المرور';

  @override
  String get accountOldPassword => 'كلمة المرور الحالية';

  @override
  String get accountNewPassword => 'كلمة المرور الجديدة';

  @override
  String get accountDeleteAccount => 'حذف الحساب';

  @override
  String get accountDeleteWarning =>
      'سيؤدي هذا إلى حذف حسابك وجميع البيانات المزامنة نهائيًا. لا يمكن التراجع عن هذا.';

  @override
  String get accountLogout => 'تسجيل الخروج';

  @override
  String get serverConfigTitle => 'تكوين الخادم';

  @override
  String get serverConfigUrlLabel => 'عنوان الخادم';

  @override
  String get serverConfigTest => 'اختبار الاتصال';

  @override
  String get serverSetupTitle => 'إعداد الخادم';

  @override
  String get serverSetupInfoCard =>
      'يتطلب ShellVault خادمًا مستضافًا ذاتيًا للمزامنة المشفرة من طرف إلى طرف. انشر مثيلك الخاص للبدء.';

  @override
  String get serverSetupRepoLink => 'عرض على GitHub';

  @override
  String get serverSetupContinue => 'متابعة';

  @override
  String get settingsServerNotConfigured => 'لم يتم تكوين أي خادم';

  @override
  String get settingsSetupSync => 'إعداد المزامنة لنسخ بياناتك احتياطيًا';

  @override
  String get settingsChangeServer => 'تغيير الخادم';

  @override
  String get settingsChangeServerConfirm =>
      'سيؤدي تغيير الخادم إلى تسجيل خروجك. هل تريد المتابعة؟';

  @override
  String get auditLogTitle => 'سجل النشاط';

  @override
  String get auditLogAll => 'الكل';

  @override
  String get auditLogEmpty => 'لا توجد سجلات نشاط';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'مدير الملفات';

  @override
  String get sftpLocalDevice => 'الجهاز المحلي';

  @override
  String get sftpSelectServer => 'اختر خادمًا...';

  @override
  String get sftpConnecting => 'جارٍ الاتصال...';

  @override
  String get sftpEmptyDirectory => 'هذا المجلد فارغ';

  @override
  String get sftpNoConnection => 'لا يوجد خادم متصل';

  @override
  String get sftpPathLabel => 'المسار';

  @override
  String get sftpUpload => 'رفع';

  @override
  String get sftpDownload => 'تحميل';

  @override
  String get sftpDelete => 'حذف';

  @override
  String get sftpRename => 'إعادة تسمية';

  @override
  String get sftpNewFolder => 'مجلد جديد';

  @override
  String get sftpNewFolderName => 'اسم المجلد';

  @override
  String get sftpChmod => 'الصلاحيات';

  @override
  String get sftpChmodTitle => 'تغيير الصلاحيات';

  @override
  String get sftpChmodOctal => 'ثماني';

  @override
  String get sftpChmodOwner => 'المالك';

  @override
  String get sftpChmodGroup => 'المجموعة';

  @override
  String get sftpChmodOther => 'آخرون';

  @override
  String get sftpChmodRead => 'قراءة';

  @override
  String get sftpChmodWrite => 'كتابة';

  @override
  String get sftpChmodExecute => 'تنفيذ';

  @override
  String get sftpCreateSymlink => 'إنشاء رابط رمزي';

  @override
  String get sftpSymlinkTarget => 'المسار الهدف';

  @override
  String get sftpSymlinkName => 'اسم الرابط';

  @override
  String get sftpFilePreview => 'معاينة الملف';

  @override
  String get sftpFileInfo => 'معلومات الملف';

  @override
  String get sftpFileSize => 'الحجم';

  @override
  String get sftpFileModified => 'تاريخ التعديل';

  @override
  String get sftpFilePermissions => 'الصلاحيات';

  @override
  String get sftpFileOwner => 'المالك';

  @override
  String get sftpFileType => 'النوع';

  @override
  String get sftpFileLinkTarget => 'هدف الرابط';

  @override
  String get sftpTransfers => 'عمليات النقل';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current من $total';
  }

  @override
  String get sftpTransferQueued => 'في قائمة الانتظار';

  @override
  String get sftpTransferActive => 'جارٍ النقل...';

  @override
  String get sftpTransferPaused => 'متوقف مؤقتًا';

  @override
  String get sftpTransferCompleted => 'مكتمل';

  @override
  String get sftpTransferFailed => 'فشل';

  @override
  String get sftpTransferCancelled => 'ملغى';

  @override
  String get sftpPauseTransfer => 'إيقاف مؤقت';

  @override
  String get sftpResumeTransfer => 'استئناف';

  @override
  String get sftpCancelTransfer => 'إلغاء';

  @override
  String get sftpClearCompleted => 'مسح المكتملة';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active من $total عملية نقل';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نشط',
      one: '1 نشط',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مكتمل',
      one: '1 مكتمل',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فاشل',
      one: '1 فاشل',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'نسخ إلى اللوحة الأخرى';

  @override
  String sftpConfirmDelete(int count) {
    return 'حذف $count عنصر؟';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'حذف \"$name\"؟';
  }

  @override
  String get sftpDeleteSuccess => 'تم الحذف بنجاح';

  @override
  String get sftpRenameTitle => 'إعادة تسمية';

  @override
  String get sftpRenameLabel => 'الاسم الجديد';

  @override
  String get sftpSortByName => 'الاسم';

  @override
  String get sftpSortBySize => 'الحجم';

  @override
  String get sftpSortByDate => 'التاريخ';

  @override
  String get sftpSortByType => 'النوع';

  @override
  String get sftpShowHidden => 'إظهار الملفات المخفية';

  @override
  String get sftpHideHidden => 'إخفاء الملفات المخفية';

  @override
  String get sftpSelectAll => 'تحديد الكل';

  @override
  String get sftpDeselectAll => 'إلغاء تحديد الكل';

  @override
  String sftpItemsSelected(int count) {
    return '$count محدد';
  }

  @override
  String get sftpRefresh => 'تحديث';

  @override
  String sftpConnectionError(String message) {
    return 'فشل الاتصال: $message';
  }

  @override
  String get sftpPermissionDenied => 'تم رفض الإذن';

  @override
  String sftpOperationFailed(String message) {
    return 'فشلت العملية: $message';
  }

  @override
  String get sftpOverwriteTitle => 'الملف موجود بالفعل';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" موجود بالفعل. هل تريد الكتابة فوقه؟';
  }

  @override
  String get sftpOverwrite => 'الكتابة فوق';

  @override
  String sftpTransferStarted(String fileName) {
    return 'بدأ النقل: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'اختر وجهة في اللوحة الأخرى أولاً';

  @override
  String get sftpDirectoryTransferNotSupported => 'نقل المجلدات قريبًا';

  @override
  String get sftpSelect => 'اختيار';

  @override
  String get sftpOpen => 'فتح';

  @override
  String get sftpExtractArchive => 'استخراج هنا';

  @override
  String get sftpExtractSuccess => 'تم استخراج الأرشيف';

  @override
  String sftpExtractFailed(String message) {
    return 'فشل الاستخراج: $message';
  }

  @override
  String get sftpExtractUnsupported => 'تنسيق أرشيف غير مدعوم';

  @override
  String get sftpExtracting => 'جارٍ الاستخراج...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بدأ رفع $count ملفات',
      one: 'بدأ الرفع',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بدأ تحميل $count ملفات',
      one: 'بدأ التحميل',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return 'تم تحميل \"$fileName\"';
  }

  @override
  String get sftpSavedToDownloads => 'تم الحفظ في Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'حفظ في الملفات';

  @override
  String get sftpFileSaved => 'تم حفظ الملف';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جلسات SSH نشطة',
      one: 'جلسة SSH نشطة',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'اضغط لفتح الطرفية';

  @override
  String get settingsAccountAndSync => 'الحساب والمزامنة';

  @override
  String get settingsAccountSubtitleAuth => 'مسجل الدخول';

  @override
  String get settingsAccountSubtitleUnauth => 'غير مسجل الدخول';

  @override
  String get settingsSecuritySubtitle => 'القفل التلقائي، البيومتري، PIN';

  @override
  String get settingsSshSubtitle => 'المنفذ 22، المستخدم root';

  @override
  String get settingsAppearanceSubtitle => 'السمة، اللغة، الطرفية';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'إعدادات التصدير المشفر الافتراضية';

  @override
  String get settingsAboutSubtitle => 'الإصدار، التراخيص';

  @override
  String get settingsSearchHint => 'البحث في الإعدادات...';

  @override
  String get settingsSearchNoResults => 'لم يتم العثور على إعدادات';

  @override
  String get aboutDeveloper => 'تطوير Kiefer Networks';

  @override
  String get aboutDonate => 'تبرع';

  @override
  String get aboutOpenSourceLicenses => 'تراخيص المصادر المفتوحة';

  @override
  String get aboutWebsite => 'الموقع الإلكتروني';

  @override
  String get aboutVersion => 'الإصدار';

  @override
  String get aboutBuild => 'البناء';

  @override
  String get settingsDohDescription =>
      'يقوم DNS-over-HTTPS بتشفير استعلامات DNS ويمنع انتحال DNS. يتحقق SSHVault من أسماء المضيفين عبر مزودين متعددين لكشف الهجمات.';

  @override
  String get settingsDnsAddServer => 'إضافة خادم DNS';

  @override
  String get settingsDnsServerUrl => 'عنوان الخادم';

  @override
  String get settingsDnsDefaultBadge => 'افتراضي';

  @override
  String get settingsDnsResetDefaults => 'إعادة التعيين إلى الافتراضي';

  @override
  String get settingsDnsInvalidUrl => 'يرجى إدخال عنوان HTTPS صالح';

  @override
  String get settingsDefaultAuthMethod => 'طريقة المصادقة';

  @override
  String get settingsAuthPassword => 'كلمة المرور';

  @override
  String get settingsAuthKey => 'مفتاح SSH';

  @override
  String get settingsConnectionTimeout => 'مهلة الاتصال';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds ثانية';
  }

  @override
  String get settingsKeepaliveInterval => 'فاصل Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds ثانية';
  }

  @override
  String get settingsCompression => 'الضغط';

  @override
  String get settingsCompressionDescription => 'تفعيل ضغط zlib لاتصالات SSH';

  @override
  String get settingsTerminalType => 'نوع الطرفية';

  @override
  String get settingsSectionConnection => 'الاتصال';

  @override
  String get settingsClipboardAutoClear => 'مسح الحافظة التلقائي';

  @override
  String get settingsClipboardAutoClearOff => 'إيقاف';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds ثانية';
  }

  @override
  String get settingsSessionTimeout => 'مهلة الجلسة';

  @override
  String get settingsSessionTimeoutOff => 'إيقاف';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get settingsDuressPin => 'رمز PIN للطوارئ';

  @override
  String get settingsDuressPinDescription =>
      'رمز PIN منفصل يمسح جميع البيانات عند إدخاله';

  @override
  String get settingsDuressPinSet => 'تم تعيين رمز PIN للطوارئ';

  @override
  String get settingsDuressPinNotSet => 'غير مكوّن';

  @override
  String get settingsDuressPinWarning =>
      'سيؤدي إدخال رمز PIN هذا إلى حذف جميع البيانات المحلية نهائيًا بما في ذلك بيانات الاعتماد والمفاتيح والإعدادات. لا يمكن التراجع عن هذا.';

  @override
  String get settingsKeyRotationReminder => 'تذكير تدوير المفاتيح';

  @override
  String get settingsKeyRotationOff => 'إيقاف';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days يوم';
  }

  @override
  String get settingsFailedAttempts => 'محاولات PIN الفاشلة';

  @override
  String get settingsSectionAppLock => 'قفل التطبيق';

  @override
  String get settingsSectionPrivacy => 'الخصوصية';

  @override
  String get settingsSectionReminders => 'التذكيرات';

  @override
  String get settingsSectionStatus => 'الحالة';

  @override
  String get settingsExportBackupSubtitle => 'تصدير، استيراد ونسخ احتياطي';

  @override
  String get settingsExportJson => 'تصدير كـ JSON';

  @override
  String get settingsExportEncrypted => 'تصدير مشفر';

  @override
  String get settingsImportFile => 'استيراد من ملف';

  @override
  String get settingsSectionImport => 'استيراد';

  @override
  String get filterTitle => 'تصفية الخوادم';

  @override
  String get filterApply => 'تطبيق المرشحات';

  @override
  String get filterClearAll => 'مسح الكل';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرشحات نشطة',
      one: 'مرشح واحد نشط',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'المجلد';

  @override
  String get filterTags => 'العلامات';

  @override
  String get filterStatus => 'الحالة';

  @override
  String get variablePreviewResolved => 'معاينة محلولة';

  @override
  String get variableInsert => 'إدراج';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خوادم',
      one: 'خادم واحد',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم إلغاء $count جلسات.',
      one: 'تم إلغاء جلسة واحدة.',
    );
    return '$_temp0 تم تسجيل خروجك.';
  }

  @override
  String get keyGenPassphrase => 'عبارة المرور';

  @override
  String get keyGenPassphraseHint => 'اختياري — يحمي المفتاح الخاص';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'الافتراضي (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'يوجد مفتاح بنفس البصمة بالفعل: \"$name\". يجب أن يكون كل مفتاح SSH فريدًا.';
  }

  @override
  String get sshKeyFingerprint => 'البصمة';

  @override
  String get sshKeyPublicKey => 'المفتاح العام';

  @override
  String get jumpHost => 'مضيف القفز';

  @override
  String get jumpHostNone => 'بدون';

  @override
  String get jumpHostLabel => 'الاتصال عبر مضيف القفز';

  @override
  String get jumpHostSelfError => 'لا يمكن للخادم أن يكون مضيف القفز الخاص به';

  @override
  String get jumpHostConnecting => 'جارٍ الاتصال بمضيف القفز…';

  @override
  String get jumpHostCircularError => 'تم اكتشاف سلسلة مضيف قفز دائرية';

  @override
  String get logoutDialogTitle => 'تسجيل الخروج';

  @override
  String get logoutDialogMessage =>
      'هل تريد حذف جميع البيانات المحلية؟ سيتم إزالة الخوادم ومفاتيح SSH والمقتطفات والإعدادات من هذا الجهاز.';

  @override
  String get logoutOnly => 'تسجيل الخروج فقط';

  @override
  String get logoutAndDelete => 'تسجيل الخروج وحذف البيانات';

  @override
  String get changeAvatar => 'تغيير الصورة الرمزية';

  @override
  String get removeAvatar => 'إزالة الصورة الرمزية';

  @override
  String get avatarUploadFailed => 'فشل في رفع الصورة الرمزية';

  @override
  String get avatarTooLarge => 'الصورة كبيرة جدًا';

  @override
  String get deviceLastSeen => 'آخر ظهور';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'لا يمكن تغيير عنوان الخادم أثناء تسجيل الدخول. قم بتسجيل الخروج أولاً.';

  @override
  String get serverListNoFolder => 'غير مصنف';

  @override
  String get autoSyncInterval => 'فاصل المزامنة';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get proxySettings => 'إعدادات البروكسي';

  @override
  String get proxyType => 'نوع البروكسي';

  @override
  String get proxyNone => 'بدون بروكسي';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'مضيف البروكسي';

  @override
  String get proxyPort => 'منفذ البروكسي';

  @override
  String get proxyUsername => 'اسم مستخدم البروكسي';

  @override
  String get proxyPassword => 'كلمة مرور البروكسي';

  @override
  String get proxyUseGlobal => 'استخدام البروكسي العام';

  @override
  String get proxyGlobal => 'عام';

  @override
  String get proxyServerSpecific => 'خاص بالخادم';

  @override
  String get proxyTestConnection => 'اختبار الاتصال';

  @override
  String get proxyTestSuccess => 'البروكسي قابل للوصول';

  @override
  String get proxyTestFailed => 'البروكسي غير قابل للوصول';

  @override
  String get proxyDefaultProxy => 'البروكسي الافتراضي';

  @override
  String get vpnRequired => 'VPN مطلوب';

  @override
  String get vpnRequiredTooltip => 'إظهار تحذير عند الاتصال بدون VPN نشط';

  @override
  String get vpnActive => 'VPN نشط';

  @override
  String get vpnInactive => 'VPN غير نشط';

  @override
  String get vpnWarningTitle => 'VPN غير نشط';

  @override
  String get vpnWarningMessage =>
      'هذا الخادم مُعلّم بأنه يتطلب اتصال VPN، لكن لا يوجد VPN نشط حاليًا. هل تريد الاتصال على أي حال؟';

  @override
  String get vpnConnectAnyway => 'اتصال على أي حال';

  @override
  String get postConnectCommands => 'أوامر ما بعد الاتصال';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'أوامر تُنفذ تلقائيًا بعد الاتصال (واحد لكل سطر)';

  @override
  String get dashboardFavorites => 'المفضلة';

  @override
  String get dashboardRecent => 'الأخيرة';

  @override
  String get dashboardActiveSessions => 'الجلسات النشطة';

  @override
  String get addToFavorites => 'إضافة إلى المفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get noRecentConnections => 'لا توجد اتصالات حديثة';

  @override
  String get terminalSplit => 'تقسيم العرض';

  @override
  String get terminalUnsplit => 'إغلاق التقسيم';

  @override
  String get terminalSelectSession => 'اختر جلسة لتقسيم العرض';

  @override
  String get knownHostsTitle => 'المضيفون المعروفون';

  @override
  String get knownHostsSubtitle => 'إدارة بصمات الخوادم الموثوقة';

  @override
  String get hostKeyNewTitle => 'مضيف جديد';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'الاتصال الأول بـ $hostname:$port. تحقق من البصمة قبل الاتصال.';
  }

  @override
  String get hostKeyChangedTitle => 'تغيّر مفتاح المضيف!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'تغيّر مفتاح المضيف لـ $hostname:$port. قد يشير هذا إلى تهديد أمني.';
  }

  @override
  String get hostKeyFingerprint => 'البصمة';

  @override
  String get hostKeyType => 'نوع المفتاح';

  @override
  String get hostKeyTrustConnect => 'ثقة واتصال';

  @override
  String get hostKeyAcceptNew => 'قبول المفتاح الجديد';

  @override
  String get hostKeyReject => 'رفض';

  @override
  String get hostKeyPreviousFingerprint => 'البصمة السابقة';

  @override
  String get hostKeyDeleteAll => 'حذف جميع المضيفين المعروفين';

  @override
  String get hostKeyDeleteConfirm =>
      'هل أنت متأكد من إزالة جميع المضيفين المعروفين؟ سيُطلب منك التأكيد مرة أخرى عند الاتصال التالي.';

  @override
  String get hostKeyEmpty => 'لا يوجد مضيفون معروفون بعد';

  @override
  String get hostKeyEmptySubtitle =>
      'سيتم تخزين بصمات المضيفين هنا بعد اتصالك الأول';

  @override
  String get hostKeyFirstSeen => 'أول ظهور';

  @override
  String get hostKeyLastSeen => 'آخر ظهور';

  @override
  String get sshConfigImportTitle => 'استيراد إعدادات SSH';

  @override
  String get sshConfigImportPickFile => 'اختر ملف إعدادات SSH';

  @override
  String get sshConfigImportOrPaste => 'أو الصق محتوى الإعدادات';

  @override
  String sshConfigImportParsed(int count) {
    return 'تم العثور على $count مضيف';
  }

  @override
  String get sshConfigImportButton => 'استيراد المحدد';

  @override
  String sshConfigImportSuccess(int count) {
    return 'تم استيراد $count خادم';
  }

  @override
  String get sshConfigImportDuplicate => 'موجود بالفعل';

  @override
  String get sshConfigImportNoHosts => 'لم يتم العثور على مضيفين في الإعدادات';

  @override
  String get sftpBookmarkAdd => 'إضافة إشارة مرجعية';

  @override
  String get sftpBookmarkLabel => 'التسمية';

  @override
  String get disconnect => 'قطع الاتصال';

  @override
  String get reportAndDisconnect => 'إبلاغ وقطع الاتصال';

  @override
  String get continueAnyway => 'متابعة على أي حال';

  @override
  String get insertSnippet => 'إدراج مقتطف';

  @override
  String get seconds => 'ثوانٍ';

  @override
  String get heartbeatLostMessage =>
      'تعذر الوصول إلى الخادم بعد عدة محاولات. لأمانك، تم إنهاء الجلسة.';

  @override
  String get attestationFailedTitle => 'فشل التحقق من الخادم';

  @override
  String get attestationFailedMessage =>
      'تعذر التحقق من الخادم كواجهة خلفية شرعية لـ SSHVault. قد يشير هذا إلى هجوم وسيط أو خادم غير مكوّن بشكل صحيح.';

  @override
  String get attestationKeyChangedTitle => 'تغيّر مفتاح التحقق من الخادم';

  @override
  String get attestationKeyChangedMessage =>
      'تغيّر مفتاح التحقق من الخادم منذ الاتصال الأولي. قد يشير هذا إلى هجوم وسيط. لا تتابع ما لم يؤكد مسؤول الخادم تدوير المفتاح.';

  @override
  String get sectionLinks => 'روابط';

  @override
  String get sectionDeveloper => 'المطور';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'الصفحة غير موجودة';

  @override
  String get connectionTestSuccess => 'الاتصال ناجح';

  @override
  String connectionTestFailed(String message) {
    return 'فشل الاتصال: $message';
  }

  @override
  String get serverVerificationFailed => 'فشل التحقق من الخادم';

  @override
  String get importSuccessful => 'تم الاستيراد بنجاح';

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
  String get deviceDeleteConfirmTitle => 'إزالة الجهاز';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'هل أنت متأكد من إزالة \"$name\"؟ سيتم تسجيل خروج الجهاز فوراً.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'هذا هو جهازك الحالي. سيتم تسجيل خروجك فوراً.';

  @override
  String get deviceDeleteSuccess => 'تم إزالة الجهاز';

  @override
  String get deviceDeletedCurrentLogout =>
      'تم إزالة الجهاز الحالي. تم تسجيل خروجك.';

  @override
  String get thisDevice => 'هذا الجهاز';
}
