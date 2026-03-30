// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Хости';

  @override
  String get navSnippets => 'Сніпети';

  @override
  String get navFolders => 'Папки';

  @override
  String get navTags => 'Теги';

  @override
  String get navSshKeys => 'SSH-ключі';

  @override
  String get navExportImport => 'Експорт / Імпорт';

  @override
  String get navTerminal => 'Термінал';

  @override
  String get navMore => 'Ще';

  @override
  String get navManagement => 'Керування';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get navAbout => 'Про застосунок';

  @override
  String get lockScreenTitle => 'SSHVault заблоковано';

  @override
  String get lockScreenUnlock => 'Розблокувати';

  @override
  String get lockScreenEnterPin => 'Введіть PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Забагато невдалих спроб. Спробуйте через $minutes хв.';
  }

  @override
  String get pinDialogSetTitle => 'Встановити PIN-код';

  @override
  String get pinDialogSetSubtitle =>
      'Введіть 6-значний PIN для захисту SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Підтвердіть PIN';

  @override
  String get pinDialogErrorLength => 'PIN повинен містити рівно 6 цифр';

  @override
  String get pinDialogErrorMismatch => 'PIN-коди не збігаються';

  @override
  String get pinDialogVerifyTitle => 'Введіть PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Невірний PIN. Залишилось спроб: $attempts.';
  }

  @override
  String get securityBannerMessage =>
      'Ваші SSH-облікові дані не захищені. Встановіть PIN або біометричне блокування в налаштуваннях.';

  @override
  String get securityBannerDismiss => 'Сховати';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsSectionAppearance => 'Зовнішній вигляд';

  @override
  String get settingsSectionTerminal => 'Термінал';

  @override
  String get settingsSectionSshDefaults => 'Параметри SSH за замовчуванням';

  @override
  String get settingsSectionSecurity => 'Безпека';

  @override
  String get settingsSectionExport => 'Експорт';

  @override
  String get settingsSectionAbout => 'Про застосунок';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSystem => 'Системна';

  @override
  String get settingsThemeLight => 'Світла';

  @override
  String get settingsThemeDark => 'Темна';

  @override
  String get settingsTerminalTheme => 'Тема терміналу';

  @override
  String get settingsTerminalThemeDefault => 'Темна за замовчуванням';

  @override
  String get settingsFontSize => 'Розмір шрифту';

  @override
  String settingsFontSizeValue(int size) {
    return '$size пікс.';
  }

  @override
  String get settingsDefaultPort => 'Порт за замовчуванням';

  @override
  String get settingsDefaultPortDialog => 'SSH-порт за замовчуванням';

  @override
  String get settingsPortLabel => 'Порт';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Ім\'я користувача за замовчуванням';

  @override
  String get settingsDefaultUsernameDialog =>
      'Ім\'я користувача за замовчуванням';

  @override
  String get settingsUsernameLabel => 'Ім\'я користувача';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Автоблокування';

  @override
  String get settingsAutoLockDisabled => 'Вимкнено';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes хвилин';
  }

  @override
  String get settingsAutoLockOff => 'Вимк.';

  @override
  String get settingsAutoLock1Min => '1 хв';

  @override
  String get settingsAutoLock5Min => '5 хв';

  @override
  String get settingsAutoLock15Min => '15 хв';

  @override
  String get settingsAutoLock30Min => '30 хв';

  @override
  String get settingsBiometricUnlock => 'Біометричне розблокування';

  @override
  String get settingsBiometricNotAvailable => 'Недоступно на цьому пристрої';

  @override
  String get settingsBiometricError => 'Помилка перевірки біометрії';

  @override
  String get settingsBiometricReason =>
      'Підтвердіть особу для увімкнення біометричного розблокування';

  @override
  String get settingsBiometricRequiresPin =>
      'Спочатку встановіть PIN для увімкнення біометричного розблокування';

  @override
  String get settingsPinCode => 'PIN-код';

  @override
  String get settingsPinIsSet => 'PIN встановлено';

  @override
  String get settingsPinNotConfigured => 'PIN не налаштовано';

  @override
  String get settingsPinRemove => 'Видалити';

  @override
  String get settingsPinRemoveWarning =>
      'Видалення PIN розшифрує всі поля бази даних та вимкне біометричне розблокування. Продовжити?';

  @override
  String get settingsPinRemoveTitle => 'Видалити PIN';

  @override
  String get settingsPreventScreenshots => 'Заборона знімків екрана';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Блокувати знімки екрана та запис екрана';

  @override
  String get settingsEncryptExport => 'Шифрувати експорт за замовчуванням';

  @override
  String get settingsAbout => 'Про SSHVault';

  @override
  String get settingsAboutLegalese => 'від Kiefer Networks';

  @override
  String get settingsAboutDescription =>
      'Безпечний SSH-клієнт з власним сервером';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsLanguageSystem => 'Системна';

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
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get delete => 'Видалити';

  @override
  String get close => 'Закрити';

  @override
  String get update => 'Оновити';

  @override
  String get create => 'Створити';

  @override
  String get retry => 'Повторити';

  @override
  String get copy => 'Копіювати';

  @override
  String get edit => 'Редагувати';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Помилка: $message';
  }

  @override
  String get serverListTitle => 'Хости';

  @override
  String get serverListEmpty => 'Немає серверів';

  @override
  String get serverListEmptySubtitle =>
      'Додайте перший SSH-сервер для початку роботи.';

  @override
  String get serverAddButton => 'Додати сервер';

  @override
  String sshConfigImportMessage(int count) {
    return 'Знайдено $count хост(ів) у ~/.ssh/config. Імпортувати?';
  }

  @override
  String get sshConfigNotFound => 'Файл SSH config не знайдено';

  @override
  String get sshConfigEmpty => 'Хости в SSH config не знайдені';

  @override
  String get sshConfigAddManually => 'Додати вручну';

  @override
  String get sshConfigImportAgain => 'Імпортувати SSH Config знову?';

  @override
  String get sshConfigImportKeys =>
      'Імпортувати SSH-ключі, вказані у вибраних хостах?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH-ключ(ів) імпортовано';
  }

  @override
  String get serverDuplicated => 'Сервер дубльовано';

  @override
  String get serverDeleteTitle => 'Видалити сервер';

  @override
  String serverDeleteMessage(String name) {
    return 'Ви впевнені, що хочете видалити \"$name\"? Цю дію не можна скасувати.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Видалити \"$name\"?';
  }

  @override
  String get serverConnect => 'Підключитися';

  @override
  String get serverDetails => 'Деталі';

  @override
  String get serverDuplicate => 'Дублювати';

  @override
  String get serverActive => 'Активний';

  @override
  String get serverNoFolder => 'Без папки';

  @override
  String get serverFormTitleEdit => 'Редагувати сервер';

  @override
  String get serverFormTitleAdd => 'Додати сервер';

  @override
  String get serverFormUpdateButton => 'Оновити сервер';

  @override
  String get serverFormAddButton => 'Додати сервер';

  @override
  String get serverFormPublicKeyExtracted => 'Відкритий ключ витягнуто успішно';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Не вдалося витягнути відкритий ключ: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Пару ключів $type згенеровано';
  }

  @override
  String get serverDetailTitle => 'Інформація про сервер';

  @override
  String get serverDetailDeleteMessage => 'Цю дію не можна скасувати.';

  @override
  String get serverDetailConnection => 'Підключення';

  @override
  String get serverDetailHost => 'Хост';

  @override
  String get serverDetailPort => 'Порт';

  @override
  String get serverDetailUsername => 'Ім\'я користувача';

  @override
  String get serverDetailFolder => 'Папка';

  @override
  String get serverDetailTags => 'Теги';

  @override
  String get serverDetailNotes => 'Нотатки';

  @override
  String get serverDetailInfo => 'Інформація';

  @override
  String get serverDetailCreated => 'Створено';

  @override
  String get serverDetailUpdated => 'Оновлено';

  @override
  String get serverDetailDistro => 'Система';

  @override
  String get copiedToClipboard => 'Скопійовано до буфера обміну';

  @override
  String get serverFormNameLabel => 'Назва сервера';

  @override
  String get serverFormHostnameLabel => 'Ім\'я хоста / IP';

  @override
  String get serverFormPortLabel => 'Порт';

  @override
  String get serverFormUsernameLabel => 'Ім\'я користувача';

  @override
  String get serverFormPasswordLabel => 'Пароль';

  @override
  String get serverFormUseManagedKey => 'Використати керований ключ';

  @override
  String get serverFormManagedKeySubtitle =>
      'Вибрати з централізовано керованих SSH-ключів';

  @override
  String get serverFormDirectKeySubtitle =>
      'Вставити ключ напряму для цього сервера';

  @override
  String get serverFormGenerateKey => 'Згенерувати пару SSH-ключів';

  @override
  String get serverFormPrivateKeyLabel => 'Закритий ключ';

  @override
  String get serverFormPrivateKeyHint => 'Вставте закритий SSH-ключ...';

  @override
  String get serverFormExtractPublicKey => 'Витягнути відкритий ключ';

  @override
  String get serverFormPublicKeyLabel => 'Відкритий ключ';

  @override
  String get serverFormPublicKeyHint =>
      'Автоматично генерується із закритого ключа, якщо порожньо';

  @override
  String get serverFormPassphraseLabel =>
      'Парольна фраза ключа (необов\'язково)';

  @override
  String get serverFormNotesLabel => 'Нотатки (необов\'язково)';

  @override
  String get searchServers => 'Пошук серверів...';

  @override
  String get filterAllFolders => 'Усі папки';

  @override
  String get filterAll => 'Усі';

  @override
  String get filterActive => 'Активні';

  @override
  String get filterInactive => 'Неактивні';

  @override
  String get filterClear => 'Скинути';

  @override
  String get folderListTitle => 'Папки';

  @override
  String get folderListEmpty => 'Немає папок';

  @override
  String get folderListEmptySubtitle =>
      'Створіть папки для організації серверів.';

  @override
  String get folderAddButton => 'Додати папку';

  @override
  String get folderDeleteTitle => 'Видалити папку';

  @override
  String folderDeleteMessage(String name) {
    return 'Видалити \"$name\"? Сервери стануть некатегоризованими.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count серверів',
      one: '1 сервер',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Згорнути';

  @override
  String get folderShowHosts => 'Показати хости';

  @override
  String get folderConnectAll => 'Підключити всі';

  @override
  String get folderFormTitleEdit => 'Редагувати папку';

  @override
  String get folderFormTitleNew => 'Нова папка';

  @override
  String get folderFormNameLabel => 'Назва папки';

  @override
  String get folderFormParentLabel => 'Батьківська папка';

  @override
  String get folderFormParentNone => 'Немає (Корінь)';

  @override
  String get tagListTitle => 'Теги';

  @override
  String get tagListEmpty => 'Немає тегів';

  @override
  String get tagListEmptySubtitle =>
      'Створіть теги для маркування та фільтрації серверів.';

  @override
  String get tagAddButton => 'Додати тег';

  @override
  String get tagDeleteTitle => 'Видалити тег';

  @override
  String tagDeleteMessage(String name) {
    return 'Видалити \"$name\"? Його буде видалено з усіх серверів.';
  }

  @override
  String get tagFormTitleEdit => 'Редагувати тег';

  @override
  String get tagFormTitleNew => 'Новий тег';

  @override
  String get tagFormNameLabel => 'Назва тегу';

  @override
  String get sshKeyListTitle => 'SSH-ключі';

  @override
  String get sshKeyListEmpty => 'Немає SSH-ключів';

  @override
  String get sshKeyListEmptySubtitle =>
      'Згенеруйте або імпортуйте SSH-ключі для централізованого керування';

  @override
  String get sshKeyCannotDeleteTitle => 'Неможливо видалити';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Неможливо видалити \"$name\". Використовується $count сервером(ами). Спочатку від\'єднайте від усіх серверів.';
  }

  @override
  String get sshKeyDeleteTitle => 'Видалити SSH-ключ';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Видалити \"$name\"? Цю дію не можна скасувати.';
  }

  @override
  String get sshKeyAddButton => 'Додати SSH-ключ';

  @override
  String get sshKeyFormTitleEdit => 'Редагувати SSH-ключ';

  @override
  String get sshKeyFormTitleAdd => 'Додати SSH-ключ';

  @override
  String get sshKeyFormTabGenerate => 'Генерація';

  @override
  String get sshKeyFormTabImport => 'Імпорт';

  @override
  String get sshKeyFormNameLabel => 'Назва ключа';

  @override
  String get sshKeyFormNameHint => 'напр. Мій продакшен-ключ';

  @override
  String get sshKeyFormKeyType => 'Тип ключа';

  @override
  String get sshKeyFormKeySize => 'Розмір ключа';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits біт';
  }

  @override
  String get sshKeyFormCommentLabel => 'Коментар';

  @override
  String get sshKeyFormCommentHint => 'user@host або опис';

  @override
  String get sshKeyFormCommentOptional => 'Коментар (необов\'язково)';

  @override
  String get sshKeyFormImportFromFile => 'Імпорт з файлу';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Закритий ключ';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Вставте закритий SSH-ключ або скористайтеся кнопкою вище...';

  @override
  String get sshKeyFormPassphraseLabel => 'Парольна фраза (необов\'язково)';

  @override
  String get sshKeyFormNameRequired => 'Назва обов\'язкова';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Закритий ключ обов\'язковий';

  @override
  String get sshKeyFormFileReadError => 'Не вдалося прочитати вибраний файл';

  @override
  String get sshKeyFormInvalidFormat =>
      'Недійсний формат ключа — очікується PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Не вдалося прочитати файл: $message';
  }

  @override
  String get sshKeyFormSaving => 'Збереження...';

  @override
  String get sshKeySelectorLabel => 'SSH-ключ';

  @override
  String get sshKeySelectorNone => 'Немає керованого ключа';

  @override
  String get sshKeySelectorManage => 'Керування ключами...';

  @override
  String get sshKeySelectorError => 'Не вдалося завантажити SSH-ключі';

  @override
  String get sshKeyTileCopyPublicKey => 'Копіювати відкритий ключ';

  @override
  String get sshKeyTilePublicKeyCopied => 'Відкритий ключ скопійовано';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Використовується $count сервером(ами)';
  }

  @override
  String get sshKeyTileUnlinkFirst => 'Спочатку від\'єднайте від усіх серверів';

  @override
  String get exportImportTitle => 'Експорт / Імпорт';

  @override
  String get exportSectionTitle => 'Експорт';

  @override
  String get exportJsonButton => 'Експорт у JSON (без облікових даних)';

  @override
  String get exportZipButton =>
      'Зашифрований експорт у ZIP (з обліковими даними)';

  @override
  String get importSectionTitle => 'Імпорт';

  @override
  String get importButton => 'Імпорт з файлу';

  @override
  String get importSupportedFormats =>
      'Підтримуються файли JSON (відкриті) та ZIP (зашифровані).';

  @override
  String exportedTo(String path) {
    return 'Експортовано до: $path';
  }

  @override
  String get share => 'Поділитися';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Імпортовано: $servers серверів, $groups груп, $tags тегів. $skipped пропущено.';
  }

  @override
  String get importPasswordTitle => 'Введіть пароль';

  @override
  String get importPasswordLabel => 'Пароль експорту';

  @override
  String get importPasswordDecrypt => 'Розшифрувати';

  @override
  String get exportPasswordTitle => 'Встановіть пароль експорту';

  @override
  String get exportPasswordDescription =>
      'Цей пароль буде використано для шифрування файлу експорту, включно з обліковими даними.';

  @override
  String get exportPasswordLabel => 'Пароль';

  @override
  String get exportPasswordConfirmLabel => 'Підтвердіть пароль';

  @override
  String get exportPasswordMismatch => 'Паролі не збігаються';

  @override
  String get exportPasswordButton => 'Зашифрувати та експортувати';

  @override
  String get importConflictTitle => 'Обробка конфліктів';

  @override
  String get importConflictDescription =>
      'Як поводитися з наявними записами під час імпорту?';

  @override
  String get importConflictSkip => 'Пропустити наявні';

  @override
  String get importConflictRename => 'Перейменувати нові';

  @override
  String get importConflictOverwrite => 'Перезаписати';

  @override
  String get confirmDeleteLabel => 'Видалити';

  @override
  String get keyGenTitle => 'Генерація пари SSH-ключів';

  @override
  String get keyGenKeyType => 'Тип ключа';

  @override
  String get keyGenKeySize => 'Розмір ключа';

  @override
  String get keyGenComment => 'Коментар';

  @override
  String get keyGenCommentHint => 'user@host або опис';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits біт';
  }

  @override
  String get keyGenGenerating => 'Генерація...';

  @override
  String get keyGenGenerate => 'Згенерувати';

  @override
  String keyGenResultTitle(String type) {
    return 'Ключ $type згенеровано';
  }

  @override
  String get keyGenPublicKey => 'Відкритий ключ';

  @override
  String get keyGenPrivateKey => 'Закритий ключ';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Коментар: $comment';
  }

  @override
  String get keyGenAnother => 'Згенерувати інший';

  @override
  String get keyGenUseThisKey => 'Використати цей ключ';

  @override
  String get keyGenCopyTooltip => 'Копіювати до буфера обміну';

  @override
  String keyGenCopied(String label) {
    return '$label скопійовано';
  }

  @override
  String get colorPickerLabel => 'Колір';

  @override
  String get iconPickerLabel => 'Іконка';

  @override
  String get tagSelectorLabel => 'Теги';

  @override
  String get tagSelectorEmpty => 'Немає тегів';

  @override
  String get tagSelectorError => 'Не вдалося завантажити теги';

  @override
  String get snippetListTitle => 'Сніпети';

  @override
  String get snippetSearchHint => 'Пошук сніпетів...';

  @override
  String get snippetListEmpty => 'Немає сніпетів';

  @override
  String get snippetListEmptySubtitle =>
      'Створюйте багаторазові фрагменти коду та команди.';

  @override
  String get snippetAddButton => 'Додати сніпет';

  @override
  String get snippetDeleteTitle => 'Видалити сніпет';

  @override
  String snippetDeleteMessage(String name) {
    return 'Видалити \"$name\"? Цю дію не можна скасувати.';
  }

  @override
  String get snippetFormTitleEdit => 'Редагувати сніпет';

  @override
  String get snippetFormTitleNew => 'Новий сніпет';

  @override
  String get snippetFormNameLabel => 'Назва';

  @override
  String get snippetFormNameHint => 'напр. Очищення Docker';

  @override
  String get snippetFormLanguageLabel => 'Мова';

  @override
  String get snippetFormContentLabel => 'Вміст';

  @override
  String get snippetFormContentHint => 'Введіть код сніпета...';

  @override
  String get snippetFormDescriptionLabel => 'Опис';

  @override
  String get snippetFormDescriptionHint => 'Необов\'язковий опис...';

  @override
  String get snippetFormFolderLabel => 'Папка';

  @override
  String get snippetFormNoFolder => 'Без папки';

  @override
  String get snippetFormNameRequired => 'Назва обов\'язкова';

  @override
  String get snippetFormContentRequired => 'Вміст обов\'язковий';

  @override
  String get snippetFormUpdateButton => 'Оновити сніпет';

  @override
  String get snippetFormCreateButton => 'Створити сніпет';

  @override
  String get snippetDetailTitle => 'Деталі сніпета';

  @override
  String get snippetDetailDeleteTitle => 'Видалити сніпет';

  @override
  String get snippetDetailDeleteMessage => 'Цю дію не можна скасувати.';

  @override
  String get snippetDetailContent => 'Вміст';

  @override
  String get snippetDetailFillVariables => 'Заповнити змінні';

  @override
  String get snippetDetailDescription => 'Опис';

  @override
  String get snippetDetailVariables => 'Змінні';

  @override
  String get snippetDetailTags => 'Теги';

  @override
  String get snippetDetailInfo => 'Інформація';

  @override
  String get snippetDetailCreated => 'Створено';

  @override
  String get snippetDetailUpdated => 'Оновлено';

  @override
  String get variableEditorTitle => 'Змінні шаблону';

  @override
  String get variableEditorAdd => 'Додати';

  @override
  String get variableEditorEmpty =>
      'Немає змінних. Використовуйте фігурні дужки у вмісті для посилання на них.';

  @override
  String get variableEditorNameLabel => 'Назва';

  @override
  String get variableEditorNameHint => 'напр. hostname';

  @override
  String get variableEditorDefaultLabel => 'За замовчуванням';

  @override
  String get variableEditorDefaultHint => 'необов\'язково';

  @override
  String get variableFillTitle => 'Заповнити змінні';

  @override
  String variableFillHint(String name) {
    return 'Введіть значення для $name';
  }

  @override
  String get variableFillPreview => 'Попередній перегляд';

  @override
  String get terminalTitle => 'Термінал';

  @override
  String get terminalEmpty => 'Немає активних сеансів';

  @override
  String get terminalEmptySubtitle =>
      'Підключіться до хоста, щоб відкрити термінальний сеанс.';

  @override
  String get terminalGoToHosts => 'Перейти до хостів';

  @override
  String get terminalCloseAll => 'Закрити всі сеанси';

  @override
  String get terminalCloseTitle => 'Закрити сеанс';

  @override
  String terminalCloseMessage(String title) {
    return 'Закрити активне підключення до \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Автентифікація...';

  @override
  String connectionConnecting(String name) {
    return 'Підключення до $name...';
  }

  @override
  String get connectionError => 'Помилка підключення';

  @override
  String get connectionLost => 'Підключення втрачено';

  @override
  String get connectionReconnect => 'Перепідключитися';

  @override
  String get snippetQuickPanelTitle => 'Вставити сніпет';

  @override
  String get snippetQuickPanelSearch => 'Пошук сніпетів...';

  @override
  String get snippetQuickPanelEmpty => 'Немає доступних сніпетів';

  @override
  String get snippetQuickPanelNoMatch => 'Збігів не знайдено';

  @override
  String get snippetQuickPanelInsertTooltip => 'Вставити сніпет';

  @override
  String get terminalThemePickerTitle => 'Тема терміналу';

  @override
  String get validatorHostnameRequired => 'Ім\'я хоста обов\'язкове';

  @override
  String get validatorHostnameInvalid => 'Недійсне ім\'я хоста або IP-адреса';

  @override
  String get validatorPortRequired => 'Порт обов\'язковий';

  @override
  String get validatorPortRange => 'Порт повинен бути від 1 до 65535';

  @override
  String get validatorUsernameRequired => 'Ім\'я користувача обов\'язкове';

  @override
  String get validatorUsernameInvalid => 'Недійсний формат імені користувача';

  @override
  String get validatorServerNameRequired => 'Назва сервера обов\'язкова';

  @override
  String get validatorServerNameLength =>
      'Назва сервера повинна бути не більше 100 символів';

  @override
  String get validatorSshKeyInvalid => 'Недійсний формат SSH-ключа';

  @override
  String get validatorPasswordRequired => 'Пароль обов\'язковий';

  @override
  String get validatorPasswordLength =>
      'Пароль повинен містити щонайменше 8 символів';

  @override
  String get authMethodPassword => 'Пароль';

  @override
  String get authMethodKey => 'SSH-ключ';

  @override
  String get authMethodBoth => 'Пароль + Ключ';

  @override
  String get serverCopySuffix => '(Копія)';

  @override
  String get settingsDownloadLogs => 'Завантажити логи';

  @override
  String get settingsSendLogs => 'Надіслати логи до підтримки';

  @override
  String get settingsLogsSaved => 'Логи збережено успішно';

  @override
  String get settingsLogsEmpty => 'Немає доступних записів логів';

  @override
  String get authLogin => 'Увійти';

  @override
  String get authRegister => 'Реєстрація';

  @override
  String get authForgotPassword => 'Забули пароль?';

  @override
  String get authWhyLogin =>
      'Увійдіть, щоб увімкнути зашифровану хмарну синхронізацію на всіх пристроях. Застосунок повністю працює офлайн без облікового запису.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'Email обов\'язковий';

  @override
  String get authEmailInvalid => 'Недійсна адреса електронної пошти';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authConfirmPasswordLabel => 'Підтвердіть пароль';

  @override
  String get authPasswordMismatch => 'Паролі не збігаються';

  @override
  String get authNoAccount => 'Немає облікового запису?';

  @override
  String get authHasAccount => 'Вже маєте обліковий запис?';

  @override
  String get authResetEmailSent =>
      'Якщо обліковий запис існує, посилання для скидання надіслано на вашу електронну пошту.';

  @override
  String get authResetDescription =>
      'Введіть адресу електронної пошти, і ми надішлемо вам посилання для скидання пароля.';

  @override
  String get authSendResetLink => 'Надіслати посилання для скидання';

  @override
  String get authBackToLogin => 'Назад до входу';

  @override
  String get syncPasswordTitle => 'Пароль синхронізації';

  @override
  String get syncPasswordTitleCreate => 'Встановити пароль синхронізації';

  @override
  String get syncPasswordTitleEnter => 'Введіть пароль синхронізації';

  @override
  String get syncPasswordDescription =>
      'Встановіть окремий пароль для шифрування даних сховища. Цей пароль ніколи не залишає ваш пристрій — на сервері зберігаються лише зашифровані дані.';

  @override
  String get syncPasswordHintEnter =>
      'Введіть пароль, який ви встановили при створенні облікового запису.';

  @override
  String get syncPasswordWarning =>
      'Якщо ви забудете цей пароль, ваші синхронізовані дані неможливо буде відновити. Скидання пароля неможливе.';

  @override
  String get syncPasswordLabel => 'Пароль синхронізації';

  @override
  String get syncPasswordWrong => 'Невірний пароль. Спробуйте ще раз.';

  @override
  String get firstSyncTitle => 'Знайдено наявні дані';

  @override
  String get firstSyncMessage =>
      'На цьому пристрої є дані, і на сервері є сховище. Як продовжити?';

  @override
  String get firstSyncMerge => 'Об\'єднати (пріоритет сервера)';

  @override
  String get firstSyncOverwriteLocal => 'Перезаписати локальні дані';

  @override
  String get firstSyncKeepLocal => 'Залишити локальні та відправити';

  @override
  String get firstSyncDeleteLocal => 'Видалити локальні та завантажити';

  @override
  String get changeEncryptionPassword => 'Змінити пароль шифрування';

  @override
  String get changeEncryptionWarning =>
      'Вас буде розлогінено на всіх інших пристроях.';

  @override
  String get changeEncryptionOldPassword => 'Поточний пароль';

  @override
  String get changeEncryptionNewPassword => 'Новий пароль';

  @override
  String get changeEncryptionSuccess => 'Пароль успішно змінено.';

  @override
  String get logoutAllDevices => 'Вийти на всіх пристроях';

  @override
  String get logoutAllDevicesConfirm =>
      'Усі активні сеанси буде відкликано. Вам потрібно буде увійти заново на всіх пристроях.';

  @override
  String get logoutAllDevicesSuccess => 'Вихід виконано на всіх пристроях.';

  @override
  String get syncSettingsTitle => 'Налаштування синхронізації';

  @override
  String get syncAutoSync => 'Автосинхронізація';

  @override
  String get syncAutoSyncDescription =>
      'Автоматична синхронізація при запуску застосунку';

  @override
  String get syncNow => 'Синхронізувати зараз';

  @override
  String get syncSyncing => 'Синхронізація...';

  @override
  String get syncSuccess => 'Синхронізацію завершено';

  @override
  String get syncError => 'Помилка синхронізації';

  @override
  String get syncServerUnreachable => 'Сервер недоступний';

  @override
  String get syncServerUnreachableHint =>
      'Сервер синхронізації недоступний. Перевірте підключення до інтернету та URL сервера.';

  @override
  String get syncNetworkError =>
      'Підключення до сервера не вдалося. Перевірте підключення до інтернету або спробуйте пізніше.';

  @override
  String get syncNeverSynced => 'Синхронізація не виконувалася';

  @override
  String get syncVaultVersion => 'Версія сховища';

  @override
  String get syncTitle => 'Синхронізація';

  @override
  String get settingsSectionNetwork => 'Мережа та DNS';

  @override
  String get settingsDnsServers => 'Сервери DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'За замовчуванням (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Введіть власні URL-адреси DoH-серверів через кому. Для перехресної перевірки потрібно щонайменше 2 сервери.';

  @override
  String get settingsDnsLabel => 'URL DoH-серверів';

  @override
  String get settingsDnsReset => 'Скинути за замовчуванням';

  @override
  String get settingsSectionSync => 'Синхронізація';

  @override
  String get settingsSyncAccount => 'Обліковий запис';

  @override
  String get settingsSyncNotLoggedIn => 'Не виконано вхід';

  @override
  String get settingsSyncStatus => 'Синхронізація';

  @override
  String get settingsSyncServerUrl => 'URL сервера';

  @override
  String get settingsSyncDefaultServer => 'За замовчуванням (sshvault.app)';

  @override
  String get accountTitle => 'Обліковий запис';

  @override
  String get accountNotLoggedIn => 'Не виконано вхід';

  @override
  String get accountVerified => 'Підтверджено';

  @override
  String get accountMemberSince => 'Учасник з';

  @override
  String get accountDevices => 'Пристрої';

  @override
  String get accountNoDevices => 'Немає зареєстрованих пристроїв';

  @override
  String get accountLastSync => 'Остання синхронізація';

  @override
  String get accountChangePassword => 'Змінити пароль';

  @override
  String get accountOldPassword => 'Поточний пароль';

  @override
  String get accountNewPassword => 'Новий пароль';

  @override
  String get accountDeleteAccount => 'Видалити обліковий запис';

  @override
  String get accountDeleteWarning =>
      'Це назавжди видалить ваш обліковий запис та всі синхронізовані дані. Цю дію не можна скасувати.';

  @override
  String get accountLogout => 'Вийти';

  @override
  String get serverConfigTitle => 'Конфігурація сервера';

  @override
  String get serverConfigUrlLabel => 'URL сервера';

  @override
  String get serverConfigTest => 'Перевірити з\'єднання';

  @override
  String get serverSetupTitle => 'Налаштування сервера';

  @override
  String get serverSetupInfoCard =>
      'ShellVault потребує власний сервер для наскрізної зашифрованої синхронізації. Розгорніть свій екземпляр, щоб почати.';

  @override
  String get serverSetupRepoLink => 'Переглянути на GitHub';

  @override
  String get serverSetupContinue => 'Продовжити';

  @override
  String get settingsServerNotConfigured => 'No server configured';

  @override
  String get settingsSetupSync => 'Set up sync to back up your data';

  @override
  String get settingsChangeServer => 'Change Server';

  @override
  String get settingsChangeServerConfirm =>
      'Changing the server will log you out. Continue?';

  @override
  String get auditLogTitle => 'Журнал дій';

  @override
  String get auditLogAll => 'Усі';

  @override
  String get auditLogEmpty => 'Записи журналу не знайдено';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Файловий менеджер';

  @override
  String get sftpLocalDevice => 'Локальний пристрій';

  @override
  String get sftpSelectServer => 'Виберіть сервер...';

  @override
  String get sftpConnecting => 'Підключення...';

  @override
  String get sftpEmptyDirectory => 'Ця директорія порожня';

  @override
  String get sftpNoConnection => 'Сервер не підключено';

  @override
  String get sftpPathLabel => 'Шлях';

  @override
  String get sftpUpload => 'Завантажити';

  @override
  String get sftpDownload => 'Скачати';

  @override
  String get sftpDelete => 'Видалити';

  @override
  String get sftpRename => 'Перейменувати';

  @override
  String get sftpNewFolder => 'Нова папка';

  @override
  String get sftpNewFolderName => 'Назва папки';

  @override
  String get sftpChmod => 'Права доступу';

  @override
  String get sftpChmodTitle => 'Змінити права доступу';

  @override
  String get sftpChmodOctal => 'Вісімковий';

  @override
  String get sftpChmodOwner => 'Власник';

  @override
  String get sftpChmodGroup => 'Група';

  @override
  String get sftpChmodOther => 'Інші';

  @override
  String get sftpChmodRead => 'Читання';

  @override
  String get sftpChmodWrite => 'Запис';

  @override
  String get sftpChmodExecute => 'Виконання';

  @override
  String get sftpCreateSymlink => 'Створити символічне посилання';

  @override
  String get sftpSymlinkTarget => 'Цільовий шлях';

  @override
  String get sftpSymlinkName => 'Назва посилання';

  @override
  String get sftpFilePreview => 'Попередній перегляд файлу';

  @override
  String get sftpFileInfo => 'Інформація про файл';

  @override
  String get sftpFileSize => 'Розмір';

  @override
  String get sftpFileModified => 'Змінено';

  @override
  String get sftpFilePermissions => 'Права доступу';

  @override
  String get sftpFileOwner => 'Власник';

  @override
  String get sftpFileType => 'Тип';

  @override
  String get sftpFileLinkTarget => 'Ціль посилання';

  @override
  String get sftpTransfers => 'Передачі';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current з $total';
  }

  @override
  String get sftpTransferQueued => 'У черзі';

  @override
  String get sftpTransferActive => 'Передача...';

  @override
  String get sftpTransferPaused => 'Призупинено';

  @override
  String get sftpTransferCompleted => 'Завершено';

  @override
  String get sftpTransferFailed => 'Помилка';

  @override
  String get sftpTransferCancelled => 'Скасовано';

  @override
  String get sftpPauseTransfer => 'Призупинити';

  @override
  String get sftpResumeTransfer => 'Відновити';

  @override
  String get sftpCancelTransfer => 'Скасувати';

  @override
  String get sftpClearCompleted => 'Очистити завершені';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active з $total передач';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активних',
      one: '1 активна',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завершено',
      one: '1 завершена',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count з помилками',
      one: '1 з помилкою',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Копіювати до іншої панелі';

  @override
  String sftpConfirmDelete(int count) {
    return 'Видалити $count елементів?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Видалити \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Успішно видалено';

  @override
  String get sftpRenameTitle => 'Перейменувати';

  @override
  String get sftpRenameLabel => 'Нова назва';

  @override
  String get sftpSortByName => 'Назва';

  @override
  String get sftpSortBySize => 'Розмір';

  @override
  String get sftpSortByDate => 'Дата';

  @override
  String get sftpSortByType => 'Тип';

  @override
  String get sftpShowHidden => 'Показати приховані файли';

  @override
  String get sftpHideHidden => 'Сховати приховані файли';

  @override
  String get sftpSelectAll => 'Вибрати все';

  @override
  String get sftpDeselectAll => 'Зняти виділення';

  @override
  String sftpItemsSelected(int count) {
    return '$count вибрано';
  }

  @override
  String get sftpRefresh => 'Оновити';

  @override
  String sftpConnectionError(String message) {
    return 'Помилка підключення: $message';
  }

  @override
  String get sftpPermissionDenied => 'Доступ заборонено';

  @override
  String sftpOperationFailed(String message) {
    return 'Операція не вдалася: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Файл вже існує';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" вже існує. Перезаписати?';
  }

  @override
  String get sftpOverwrite => 'Перезаписати';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Передачу розпочато: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Спочатку виберіть місце призначення в іншій панелі';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Передача директорій скоро з\'явиться';

  @override
  String get sftpSelect => 'Вибрати';

  @override
  String get sftpOpen => 'Відкрити';

  @override
  String get sftpExtractArchive => 'Видобути тут';

  @override
  String get sftpExtractSuccess => 'Архів видобуто';

  @override
  String sftpExtractFailed(String message) {
    return 'Видобування не вдалося: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Непідтримуваний формат архіву';

  @override
  String get sftpExtracting => 'Видобування...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завантажень розпочато',
      one: 'Завантаження розпочато',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count скачувань розпочато',
      one: 'Скачування розпочато',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" скачано';
  }

  @override
  String get sftpSavedToDownloads => 'Збережено до Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Зберегти до файлів';

  @override
  String get sftpFileSaved => 'Файл збережено';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH-сеансів активно',
      one: 'SSH-сеанс активний',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Натисніть, щоб відкрити термінал';

  @override
  String get settingsAccountAndSync => 'Обліковий запис і синхронізація';

  @override
  String get settingsAccountSubtitleAuth => 'Вхід виконано';

  @override
  String get settingsAccountSubtitleUnauth => 'Вхід не виконано';

  @override
  String get settingsSecuritySubtitle => 'Автоблокування, Біометрія, PIN';

  @override
  String get settingsSshSubtitle => 'Порт 22, Користувач root';

  @override
  String get settingsAppearanceSubtitle => 'Тема, Мова, Термінал';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Налаштування шифрованого експорту';

  @override
  String get settingsAboutSubtitle => 'Версія, Ліцензії';

  @override
  String get settingsSearchHint => 'Пошук налаштувань...';

  @override
  String get settingsSearchNoResults => 'Налаштувань не знайдено';

  @override
  String get aboutDeveloper => 'Розроблено Kiefer Networks';

  @override
  String get aboutDonate => 'Пожертвувати';

  @override
  String get aboutOpenSourceLicenses => 'Ліцензії відкритого ПЗ';

  @override
  String get aboutWebsite => 'Вебсайт';

  @override
  String get aboutVersion => 'Версія';

  @override
  String get aboutBuild => 'Збірка';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS шифрує DNS-запити та запобігає DNS-спуфінгу. SSHVault перевіряє імена хостів через кількох провайдерів для виявлення атак.';

  @override
  String get settingsDnsAddServer => 'Додати DNS-сервер';

  @override
  String get settingsDnsServerUrl => 'URL сервера';

  @override
  String get settingsDnsDefaultBadge => 'За замовчуванням';

  @override
  String get settingsDnsResetDefaults => 'Скинути за замовчуванням';

  @override
  String get settingsDnsInvalidUrl => 'Введіть коректний HTTPS URL';

  @override
  String get settingsDefaultAuthMethod => 'Метод автентифікації';

  @override
  String get settingsAuthPassword => 'Пароль';

  @override
  String get settingsAuthKey => 'SSH-ключ';

  @override
  String get settingsConnectionTimeout => 'Тайм-аут підключення';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds с';
  }

  @override
  String get settingsKeepaliveInterval => 'Інтервал Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds с';
  }

  @override
  String get settingsCompression => 'Стиснення';

  @override
  String get settingsCompressionDescription =>
      'Увімкнути стиснення zlib для SSH-підключень';

  @override
  String get settingsTerminalType => 'Тип терміналу';

  @override
  String get settingsSectionConnection => 'Підключення';

  @override
  String get settingsClipboardAutoClear => 'Автоочищення буфера обміну';

  @override
  String get settingsClipboardAutoClearOff => 'Вимк.';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds с';
  }

  @override
  String get settingsSessionTimeout => 'Тайм-аут сеансу';

  @override
  String get settingsSessionTimeoutOff => 'Вимк.';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes хв';
  }

  @override
  String get settingsDuressPin => 'Примусовий PIN';

  @override
  String get settingsDuressPinDescription =>
      'Окремий PIN, який стирає всі дані при введенні';

  @override
  String get settingsDuressPinSet => 'Примусовий PIN встановлено';

  @override
  String get settingsDuressPinNotSet => 'Не налаштовано';

  @override
  String get settingsDuressPinWarning =>
      'Введення цього PIN назавжди видалить усі локальні дані, включно з обліковими даними, ключами та налаштуваннями. Цю дію не можна скасувати.';

  @override
  String get settingsKeyRotationReminder => 'Нагадування про ротацію ключів';

  @override
  String get settingsKeyRotationOff => 'Вимк.';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days днів';
  }

  @override
  String get settingsFailedAttempts => 'Невдалі спроби введення PIN';

  @override
  String get settingsSectionAppLock => 'Блокування застосунку';

  @override
  String get settingsSectionPrivacy => 'Конфіденційність';

  @override
  String get settingsSectionReminders => 'Нагадування';

  @override
  String get settingsSectionStatus => 'Статус';

  @override
  String get settingsExportBackupSubtitle =>
      'Експорт, Імпорт та Резервне копіювання';

  @override
  String get settingsExportJson => 'Експорт у JSON';

  @override
  String get settingsExportEncrypted => 'Зашифрований експорт';

  @override
  String get settingsImportFile => 'Імпорт з файлу';

  @override
  String get settingsSectionImport => 'Імпорт';

  @override
  String get filterTitle => 'Фільтр серверів';

  @override
  String get filterApply => 'Застосувати фільтри';

  @override
  String get filterClearAll => 'Скинути все';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фільтрів активно',
      one: '1 фільтр активний',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Папка';

  @override
  String get filterTags => 'Теги';

  @override
  String get filterStatus => 'Статус';

  @override
  String get variablePreviewResolved => 'Попередній перегляд з підстановкою';

  @override
  String get variableInsert => 'Вставити';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count серверів',
      one: '1 сервер',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сеансів відкликано.',
      one: '1 сеанс відкликано.',
    );
    return '$_temp0 Ви вийшли з облікового запису.';
  }

  @override
  String get keyGenPassphrase => 'Парольна фраза';

  @override
  String get keyGenPassphraseHint => 'Необов\'язково — захищає закритий ключ';

  @override
  String get settingsDnsDefaultQuad9Mullvad =>
      'За замовчуванням (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Ключ з таким самим відбитком вже існує: \"$name\". Кожен SSH-ключ повинен бути унікальним.';
  }

  @override
  String get sshKeyFingerprint => 'Відбиток';

  @override
  String get sshKeyPublicKey => 'Відкритий ключ';

  @override
  String get jumpHost => 'Проміжний хост';

  @override
  String get jumpHostNone => 'Немає';

  @override
  String get jumpHostLabel => 'Підключитися через проміжний хост';

  @override
  String get jumpHostSelfError =>
      'Сервер не може бути власним проміжним хостом';

  @override
  String get jumpHostConnecting => 'Підключення до проміжного хоста...';

  @override
  String get jumpHostCircularError =>
      'Виявлено циклічний ланцюжок проміжних хостів';

  @override
  String get logoutDialogTitle => 'Вихід';

  @override
  String get logoutDialogMessage =>
      'Видалити всі локальні дані? Сервери, SSH-ключі, сніпети та налаштування будуть видалені з цього пристрою.';

  @override
  String get logoutOnly => 'Лише вийти';

  @override
  String get logoutAndDelete => 'Вийти та видалити дані';

  @override
  String get changeAvatar => 'Змінити аватар';

  @override
  String get removeAvatar => 'Видалити аватар';

  @override
  String get avatarUploadFailed => 'Не вдалося завантажити аватар';

  @override
  String get avatarTooLarge => 'Зображення занадто велике';

  @override
  String get deviceLastSeen => 'Остання активність';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'URL сервера не можна змінити під час входу. Спочатку вийдіть.';

  @override
  String get serverListNoFolder => 'Без категорії';

  @override
  String get autoSyncInterval => 'Інтервал синхронізації';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes хв';
  }

  @override
  String get proxySettings => 'Налаштування проксі';

  @override
  String get proxyType => 'Тип проксі';

  @override
  String get proxyNone => 'Без проксі';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Хост проксі';

  @override
  String get proxyPort => 'Порт проксі';

  @override
  String get proxyUsername => 'Ім\'я користувача проксі';

  @override
  String get proxyPassword => 'Пароль проксі';

  @override
  String get proxyUseGlobal => 'Використовувати глобальний проксі';

  @override
  String get proxyGlobal => 'Глобальний';

  @override
  String get proxyServerSpecific => 'Для конкретного сервера';

  @override
  String get proxyTestConnection => 'Перевірити з\'єднання';

  @override
  String get proxyTestSuccess => 'Проксі доступний';

  @override
  String get proxyTestFailed => 'Проксі недоступний';

  @override
  String get proxyDefaultProxy => 'Проксі за замовчуванням';

  @override
  String get vpnRequired => 'Потрібен VPN';

  @override
  String get vpnRequiredTooltip =>
      'Показувати попередження при підключенні без активного VPN';

  @override
  String get vpnActive => 'VPN активний';

  @override
  String get vpnInactive => 'VPN неактивний';

  @override
  String get vpnWarningTitle => 'VPN не активний';

  @override
  String get vpnWarningMessage =>
      'Для цього сервера потрібне VPN-підключення, але VPN наразі не активний. Підключитися все одно?';

  @override
  String get vpnConnectAnyway => 'Підключитися все одно';

  @override
  String get postConnectCommands => 'Команди після підключення';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Команди, що виконуються автоматично після підключення (по одній на рядок)';

  @override
  String get dashboardFavorites => 'Обране';

  @override
  String get dashboardRecent => 'Останні';

  @override
  String get dashboardActiveSessions => 'Активні сеанси';

  @override
  String get addToFavorites => 'Додати до обраного';

  @override
  String get removeFromFavorites => 'Видалити з обраного';

  @override
  String get noRecentConnections => 'Немає останніх підключень';

  @override
  String get terminalSplit => 'Розділити вид';

  @override
  String get terminalUnsplit => 'Закрити розділення';

  @override
  String get terminalSelectSession => 'Виберіть сеанс для розділеного виду';

  @override
  String get knownHostsTitle => 'Відомі хости';

  @override
  String get knownHostsSubtitle => 'Керування довіреними відбитками серверів';

  @override
  String get hostKeyNewTitle => 'Новий хост';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Перше підключення до $hostname:$port. Перевірте відбиток перед підключенням.';
  }

  @override
  String get hostKeyChangedTitle => 'Ключ хоста змінився!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Ключ хоста $hostname:$port змінився. Це може вказувати на загрозу безпеці.';
  }

  @override
  String get hostKeyFingerprint => 'Відбиток';

  @override
  String get hostKeyType => 'Тип ключа';

  @override
  String get hostKeyTrustConnect => 'Довіряти та підключитися';

  @override
  String get hostKeyAcceptNew => 'Прийняти новий ключ';

  @override
  String get hostKeyReject => 'Відхилити';

  @override
  String get hostKeyPreviousFingerprint => 'Попередній відбиток';

  @override
  String get hostKeyDeleteAll => 'Видалити всі відомі хости';

  @override
  String get hostKeyDeleteConfirm =>
      'Видалити всі відомі хости? При наступному підключенні вам буде запропоновано підтвердити відбиток.';

  @override
  String get hostKeyEmpty => 'Немає відомих хостів';

  @override
  String get hostKeyEmptySubtitle =>
      'Відбитки хостів будуть збережені тут після першого підключення';

  @override
  String get hostKeyFirstSeen => 'Вперше виявлено';

  @override
  String get hostKeyLastSeen => 'Востаннє виявлено';

  @override
  String get sshConfigImportTitle => 'Імпорт SSH Config';

  @override
  String get sshConfigImportPickFile => 'Виберіть файл SSH Config';

  @override
  String get sshConfigImportOrPaste => 'Або вставте вміст конфігурації';

  @override
  String sshConfigImportParsed(int count) {
    return 'Знайдено $count хостів';
  }

  @override
  String get sshConfigImportButton => 'Імпортувати';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count сервер(ів) імпортовано';
  }

  @override
  String get sshConfigImportDuplicate => 'Вже існує';

  @override
  String get sshConfigImportNoHosts => 'Хости в конфігурації не знайдені';

  @override
  String get sftpBookmarkAdd => 'Додати закладку';

  @override
  String get sftpBookmarkLabel => 'Мітка';

  @override
  String get disconnect => 'Від\'єднатися';

  @override
  String get reportAndDisconnect => 'Повідомити та від\'єднатися';

  @override
  String get continueAnyway => 'Продовжити все одно';

  @override
  String get insertSnippet => 'Вставити сніпет';

  @override
  String get seconds => 'Секунди';

  @override
  String get heartbeatLostMessage =>
      'Сервер не відповідав після кількох спроб. Для вашої безпеки сеанс було завершено.';

  @override
  String get attestationFailedTitle => 'Верифікація сервера не вдалася';

  @override
  String get attestationFailedMessage =>
      'Сервер не вдалося підтвердити як легітимний бекенд SSHVault. Це може вказувати на атаку посередника або неправильно налаштований сервер.';

  @override
  String get attestationKeyChangedTitle => 'Ключ атестації сервера змінився';

  @override
  String get attestationKeyChangedMessage =>
      'Ключ атестації сервера змінився з моменту початкового підключення. Це може вказувати на атаку посередника. НЕ продовжуйте, якщо адміністратор сервера не підтвердив ротацію ключів.';

  @override
  String get sectionLinks => 'Посилання';

  @override
  String get sectionDeveloper => 'Розробник';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Сторінку не знайдено';

  @override
  String get connectionTestSuccess => 'Підключення успішне';

  @override
  String connectionTestFailed(String message) {
    return 'Підключення не вдалося: $message';
  }

  @override
  String get serverVerificationFailed => 'Верифікація сервера не вдалася';

  @override
  String get importSuccessful => 'Імпорт виконано успішно';

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
  String get deviceDeleteConfirmTitle => 'Видалити пристрій';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Ви впевнені, що хочете видалити \"$name\"? Пристрій буде негайно відключено.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Це ваш поточний пристрій. Вас буде негайно відключено.';

  @override
  String get deviceDeleteSuccess => 'Пристрій видалено';

  @override
  String get deviceDeletedCurrentLogout =>
      'Поточний пристрій видалено. Вас було відключено.';

  @override
  String get thisDevice => 'Цей пристрій';
}
