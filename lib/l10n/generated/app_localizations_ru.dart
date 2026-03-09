// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Хосты';

  @override
  String get navSnippets => 'Сниппеты';

  @override
  String get navFolders => 'Папки';

  @override
  String get navTags => 'Теги';

  @override
  String get navSshKeys => 'SSH-ключи';

  @override
  String get navExportImport => 'Экспорт / Импорт';

  @override
  String get navTerminal => 'Терминал';

  @override
  String get navMore => 'Ещё';

  @override
  String get navManagement => 'Управление';

  @override
  String get navSettings => 'Настройки';

  @override
  String get navAbout => 'О приложении';

  @override
  String get lockScreenTitle => 'SSHVault заблокирован';

  @override
  String get lockScreenUnlock => 'Разблокировать';

  @override
  String get lockScreenEnterPin => 'Введите PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Слишком много неудачных попыток. Попробуйте через $minutes мин.';
  }

  @override
  String get pinDialogSetTitle => 'Установить PIN-код';

  @override
  String get pinDialogSetSubtitle =>
      'Введите 6-значный PIN для защиты SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Подтвердите PIN';

  @override
  String get pinDialogErrorLength => 'PIN должен содержать ровно 6 цифр';

  @override
  String get pinDialogErrorMismatch => 'PIN-коды не совпадают';

  @override
  String get pinDialogVerifyTitle => 'Введите PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Неверный PIN. Осталось попыток: $attempts.';
  }

  @override
  String get securityBannerMessage =>
      'Ваши SSH-учётные данные не защищены. Установите PIN или биометрическую блокировку в настройках.';

  @override
  String get securityBannerDismiss => 'Скрыть';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSectionAppearance => 'Внешний вид';

  @override
  String get settingsSectionTerminal => 'Терминал';

  @override
  String get settingsSectionSshDefaults => 'Параметры SSH по умолчанию';

  @override
  String get settingsSectionSecurity => 'Безопасность';

  @override
  String get settingsSectionExport => 'Экспорт';

  @override
  String get settingsSectionAbout => 'О приложении';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsTerminalTheme => 'Тема терминала';

  @override
  String get settingsTerminalThemeDefault => 'Тёмная по умолчанию';

  @override
  String get settingsFontSize => 'Размер шрифта';

  @override
  String settingsFontSizeValue(int size) {
    return '$size пикс.';
  }

  @override
  String get settingsDefaultPort => 'Порт по умолчанию';

  @override
  String get settingsDefaultPortDialog => 'SSH-порт по умолчанию';

  @override
  String get settingsPortLabel => 'Порт';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Имя пользователя по умолчанию';

  @override
  String get settingsDefaultUsernameDialog => 'Имя пользователя по умолчанию';

  @override
  String get settingsUsernameLabel => 'Имя пользователя';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Автоблокировка';

  @override
  String get settingsAutoLockDisabled => 'Отключена';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes минут';
  }

  @override
  String get settingsAutoLockOff => 'Выкл.';

  @override
  String get settingsAutoLock1Min => '1 мин';

  @override
  String get settingsAutoLock5Min => '5 мин';

  @override
  String get settingsAutoLock15Min => '15 мин';

  @override
  String get settingsAutoLock30Min => '30 мин';

  @override
  String get settingsBiometricUnlock => 'Биометрическая разблокировка';

  @override
  String get settingsBiometricNotAvailable => 'Недоступно на этом устройстве';

  @override
  String get settingsBiometricError => 'Ошибка проверки биометрии';

  @override
  String get settingsBiometricReason =>
      'Подтвердите личность для включения биометрической разблокировки';

  @override
  String get settingsBiometricRequiresPin =>
      'Сначала установите PIN для включения биометрической разблокировки';

  @override
  String get settingsPinCode => 'PIN-код';

  @override
  String get settingsPinIsSet => 'PIN установлен';

  @override
  String get settingsPinNotConfigured => 'PIN не настроен';

  @override
  String get settingsPinRemove => 'Удалить';

  @override
  String get settingsPinRemoveWarning =>
      'Удаление PIN расшифрует все поля базы данных и отключит биометрическую разблокировку. Продолжить?';

  @override
  String get settingsPinRemoveTitle => 'Удалить PIN';

  @override
  String get settingsPreventScreenshots => 'Запрет снимков экрана';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Блокировать снимки экрана и запись экрана';

  @override
  String get settingsEncryptExport => 'Шифровать экспорт по умолчанию';

  @override
  String get settingsAbout => 'О SSHVault';

  @override
  String get settingsAboutLegalese => 'от Kiefer Networks';

  @override
  String get settingsAboutDescription =>
      'Безопасный SSH-клиент с собственным сервером';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageSystem => 'Системный';

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
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get close => 'Закрыть';

  @override
  String get update => 'Обновить';

  @override
  String get create => 'Создать';

  @override
  String get retry => 'Повторить';

  @override
  String get copy => 'Копировать';

  @override
  String get edit => 'Редактировать';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Ошибка: $message';
  }

  @override
  String get serverListTitle => 'Хосты';

  @override
  String get serverListEmpty => 'Нет серверов';

  @override
  String get serverListEmptySubtitle =>
      'Добавьте первый SSH-сервер для начала работы.';

  @override
  String get serverAddButton => 'Добавить сервер';

  @override
  String get sshConfigImportTitle => 'Импорт SSH Config';

  @override
  String sshConfigImportMessage(int count) {
    return 'Найдено $count хост(ов) в ~/.ssh/config. Импортировать?';
  }

  @override
  String get sshConfigImportButton => 'Импортировать';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count сервер(ов) импортировано';
  }

  @override
  String get sshConfigNotFound => 'Файл SSH config не найден';

  @override
  String get sshConfigEmpty => 'Хосты в SSH config не найдены';

  @override
  String get sshConfigAddManually => 'Добавить вручную';

  @override
  String get sshConfigImportAgain => 'Импортировать SSH Config снова?';

  @override
  String get sshConfigImportKeys =>
      'Импортировать SSH-ключи, указанные в выбранных хостах?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH-ключ(ей) импортировано';
  }

  @override
  String get serverDuplicated => 'Сервер дублирован';

  @override
  String get serverDeleteTitle => 'Удалить сервер';

  @override
  String serverDeleteMessage(String name) {
    return 'Вы уверены, что хотите удалить \"$name\"? Это действие нельзя отменить.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get serverConnect => 'Подключиться';

  @override
  String get serverDetails => 'Подробности';

  @override
  String get serverDuplicate => 'Дублировать';

  @override
  String get serverActive => 'Активен';

  @override
  String get serverNoFolder => 'Без папки';

  @override
  String get serverFormTitleEdit => 'Редактировать сервер';

  @override
  String get serverFormTitleAdd => 'Добавить сервер';

  @override
  String get serverFormUpdateButton => 'Обновить сервер';

  @override
  String get serverFormAddButton => 'Добавить сервер';

  @override
  String get serverFormPublicKeyExtracted => 'Открытый ключ извлечён успешно';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Не удалось извлечь открытый ключ: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Пара ключей $type сгенерирована';
  }

  @override
  String get serverDetailTitle => 'Информация о сервере';

  @override
  String get serverDetailDeleteMessage => 'Это действие нельзя отменить.';

  @override
  String get serverDetailConnection => 'Подключение';

  @override
  String get serverDetailHost => 'Хост';

  @override
  String get serverDetailPort => 'Порт';

  @override
  String get serverDetailUsername => 'Имя пользователя';

  @override
  String get serverDetailFolder => 'Папка';

  @override
  String get serverDetailTags => 'Теги';

  @override
  String get serverDetailNotes => 'Заметки';

  @override
  String get serverDetailInfo => 'Информация';

  @override
  String get serverDetailCreated => 'Создано';

  @override
  String get serverDetailUpdated => 'Обновлено';

  @override
  String get serverDetailDistro => 'Система';

  @override
  String get copiedToClipboard => 'Скопировано в буфер обмена';

  @override
  String get serverFormNameLabel => 'Имя сервера';

  @override
  String get serverFormHostnameLabel => 'Имя хоста / IP';

  @override
  String get serverFormPortLabel => 'Порт';

  @override
  String get serverFormUsernameLabel => 'Имя пользователя';

  @override
  String get serverFormPasswordLabel => 'Пароль';

  @override
  String get serverFormUseManagedKey => 'Использовать управляемый ключ';

  @override
  String get serverFormManagedKeySubtitle =>
      'Выбрать из централизованно управляемых SSH-ключей';

  @override
  String get serverFormDirectKeySubtitle =>
      'Вставить ключ напрямую для этого сервера';

  @override
  String get serverFormGenerateKey => 'Сгенерировать пару SSH-ключей';

  @override
  String get serverFormPrivateKeyLabel => 'Закрытый ключ';

  @override
  String get serverFormPrivateKeyHint => 'Вставьте закрытый SSH-ключ...';

  @override
  String get serverFormExtractPublicKey => 'Извлечь открытый ключ';

  @override
  String get serverFormPublicKeyLabel => 'Открытый ключ';

  @override
  String get serverFormPublicKeyHint =>
      'Автоматически генерируется из закрытого ключа, если пусто';

  @override
  String get serverFormPassphraseLabel =>
      'Парольная фраза ключа (необязательно)';

  @override
  String get serverFormNotesLabel => 'Заметки (необязательно)';

  @override
  String get searchServers => 'Поиск серверов...';

  @override
  String get filterAllFolders => 'Все папки';

  @override
  String get filterAll => 'Все';

  @override
  String get filterActive => 'Активные';

  @override
  String get filterInactive => 'Неактивные';

  @override
  String get filterClear => 'Сбросить';

  @override
  String get folderListTitle => 'Папки';

  @override
  String get folderListEmpty => 'Нет папок';

  @override
  String get folderListEmptySubtitle =>
      'Создайте папки для организации серверов.';

  @override
  String get folderAddButton => 'Добавить папку';

  @override
  String get folderDeleteTitle => 'Удалить папку';

  @override
  String folderDeleteMessage(String name) {
    return 'Удалить \"$name\"? Серверы станут неупорядоченными.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count серверов',
      one: '1 сервер',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Свернуть';

  @override
  String get folderShowHosts => 'Показать хосты';

  @override
  String get folderConnectAll => 'Подключить все';

  @override
  String get folderFormTitleEdit => 'Редактировать папку';

  @override
  String get folderFormTitleNew => 'Новая папка';

  @override
  String get folderFormNameLabel => 'Имя папки';

  @override
  String get folderFormParentLabel => 'Родительская папка';

  @override
  String get folderFormParentNone => 'Нет (Корень)';

  @override
  String get tagListTitle => 'Теги';

  @override
  String get tagListEmpty => 'Нет тегов';

  @override
  String get tagListEmptySubtitle =>
      'Создайте теги для маркировки и фильтрации серверов.';

  @override
  String get tagAddButton => 'Добавить тег';

  @override
  String get tagDeleteTitle => 'Удалить тег';

  @override
  String tagDeleteMessage(String name) {
    return 'Удалить \"$name\"? Он будет удалён со всех серверов.';
  }

  @override
  String get tagFormTitleEdit => 'Редактировать тег';

  @override
  String get tagFormTitleNew => 'Новый тег';

  @override
  String get tagFormNameLabel => 'Имя тега';

  @override
  String get sshKeyListTitle => 'SSH-ключи';

  @override
  String get sshKeyListEmpty => 'Нет SSH-ключей';

  @override
  String get sshKeyListEmptySubtitle =>
      'Сгенерируйте или импортируйте SSH-ключи для централизованного управления';

  @override
  String get sshKeyCannotDeleteTitle => 'Невозможно удалить';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Невозможно удалить \"$name\". Используется $count сервером(ами). Сначала отвяжите от всех серверов.';
  }

  @override
  String get sshKeyDeleteTitle => 'Удалить SSH-ключ';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Удалить \"$name\"? Это действие нельзя отменить.';
  }

  @override
  String get sshKeyAddButton => 'Добавить SSH-ключ';

  @override
  String get sshKeyFormTitleEdit => 'Редактировать SSH-ключ';

  @override
  String get sshKeyFormTitleAdd => 'Добавить SSH-ключ';

  @override
  String get sshKeyFormTabGenerate => 'Генерация';

  @override
  String get sshKeyFormTabImport => 'Импорт';

  @override
  String get sshKeyFormNameLabel => 'Имя ключа';

  @override
  String get sshKeyFormNameHint => 'напр. Мой продакшен-ключ';

  @override
  String get sshKeyFormKeyType => 'Тип ключа';

  @override
  String get sshKeyFormKeySize => 'Размер ключа';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits бит';
  }

  @override
  String get sshKeyFormCommentLabel => 'Комментарий';

  @override
  String get sshKeyFormCommentHint => 'user@host или описание';

  @override
  String get sshKeyFormCommentOptional => 'Комментарий (необязательно)';

  @override
  String get sshKeyFormImportFromFile => 'Импорт из файла';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Закрытый ключ';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Вставьте закрытый SSH-ключ или используйте кнопку выше...';

  @override
  String get sshKeyFormPassphraseLabel => 'Парольная фраза (необязательно)';

  @override
  String get sshKeyFormNameRequired => 'Имя обязательно';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Закрытый ключ обязателен';

  @override
  String get sshKeyFormFileReadError => 'Не удалось прочитать выбранный файл';

  @override
  String get sshKeyFormInvalidFormat =>
      'Недопустимый формат ключа — ожидается PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Не удалось прочитать файл: $message';
  }

  @override
  String get sshKeyFormSaving => 'Сохранение...';

  @override
  String get sshKeySelectorLabel => 'SSH-ключ';

  @override
  String get sshKeySelectorNone => 'Нет управляемого ключа';

  @override
  String get sshKeySelectorManage => 'Управление ключами...';

  @override
  String get sshKeySelectorError => 'Не удалось загрузить SSH-ключи';

  @override
  String get sshKeyTileCopyPublicKey => 'Копировать открытый ключ';

  @override
  String get sshKeyTilePublicKeyCopied => 'Открытый ключ скопирован';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Используется $count сервером(ами)';
  }

  @override
  String get sshKeyTileUnlinkFirst => 'Сначала отвяжите от всех серверов';

  @override
  String get exportImportTitle => 'Экспорт / Импорт';

  @override
  String get exportSectionTitle => 'Экспорт';

  @override
  String get exportJsonButton => 'Экспорт в JSON (без учётных данных)';

  @override
  String get exportZipButton =>
      'Зашифрованный экспорт в ZIP (с учётными данными)';

  @override
  String get importSectionTitle => 'Импорт';

  @override
  String get importButton => 'Импорт из файла';

  @override
  String get importSupportedFormats =>
      'Поддерживаются файлы JSON (открытые) и ZIP (зашифрованные).';

  @override
  String exportedTo(String path) {
    return 'Экспортировано в: $path';
  }

  @override
  String get share => 'Поделиться';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Импортировано: $servers серверов, $groups групп, $tags тегов. $skipped пропущено.';
  }

  @override
  String get importPasswordTitle => 'Введите пароль';

  @override
  String get importPasswordLabel => 'Пароль экспорта';

  @override
  String get importPasswordDecrypt => 'Расшифровать';

  @override
  String get exportPasswordTitle => 'Установите пароль экспорта';

  @override
  String get exportPasswordDescription =>
      'Этот пароль будет использоваться для шифрования файла экспорта, включая учётные данные.';

  @override
  String get exportPasswordLabel => 'Пароль';

  @override
  String get exportPasswordConfirmLabel => 'Подтвердите пароль';

  @override
  String get exportPasswordMismatch => 'Пароли не совпадают';

  @override
  String get exportPasswordButton => 'Зашифровать и экспортировать';

  @override
  String get importConflictTitle => 'Обработка конфликтов';

  @override
  String get importConflictDescription =>
      'Как поступить с существующими записями при импорте?';

  @override
  String get importConflictSkip => 'Пропустить существующие';

  @override
  String get importConflictRename => 'Переименовать новые';

  @override
  String get importConflictOverwrite => 'Перезаписать';

  @override
  String get confirmDeleteLabel => 'Удалить';

  @override
  String get keyGenTitle => 'Генерация пары SSH-ключей';

  @override
  String get keyGenKeyType => 'Тип ключа';

  @override
  String get keyGenKeySize => 'Размер ключа';

  @override
  String get keyGenComment => 'Комментарий';

  @override
  String get keyGenCommentHint => 'user@host или описание';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits бит';
  }

  @override
  String get keyGenGenerating => 'Генерация...';

  @override
  String get keyGenGenerate => 'Сгенерировать';

  @override
  String keyGenResultTitle(String type) {
    return 'Ключ $type сгенерирован';
  }

  @override
  String get keyGenPublicKey => 'Открытый ключ';

  @override
  String get keyGenPrivateKey => 'Закрытый ключ';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Комментарий: $comment';
  }

  @override
  String get keyGenAnother => 'Сгенерировать другой';

  @override
  String get keyGenUseThisKey => 'Использовать этот ключ';

  @override
  String get keyGenCopyTooltip => 'Копировать в буфер обмена';

  @override
  String keyGenCopied(String label) {
    return '$label скопировано';
  }

  @override
  String get colorPickerLabel => 'Цвет';

  @override
  String get iconPickerLabel => 'Иконка';

  @override
  String get tagSelectorLabel => 'Теги';

  @override
  String get tagSelectorEmpty => 'Нет тегов';

  @override
  String get tagSelectorError => 'Не удалось загрузить теги';

  @override
  String get snippetListTitle => 'Сниппеты';

  @override
  String get snippetSearchHint => 'Поиск сниппетов...';

  @override
  String get snippetListEmpty => 'Нет сниппетов';

  @override
  String get snippetListEmptySubtitle =>
      'Создайте многоразовые фрагменты кода и команды.';

  @override
  String get snippetAddButton => 'Добавить сниппет';

  @override
  String get snippetDeleteTitle => 'Удалить сниппет';

  @override
  String snippetDeleteMessage(String name) {
    return 'Удалить \"$name\"? Это действие нельзя отменить.';
  }

  @override
  String get snippetFormTitleEdit => 'Редактировать сниппет';

  @override
  String get snippetFormTitleNew => 'Новый сниппет';

  @override
  String get snippetFormNameLabel => 'Имя';

  @override
  String get snippetFormNameHint => 'напр. Очистка Docker';

  @override
  String get snippetFormLanguageLabel => 'Язык';

  @override
  String get snippetFormContentLabel => 'Содержимое';

  @override
  String get snippetFormContentHint => 'Введите код сниппета...';

  @override
  String get snippetFormDescriptionLabel => 'Описание';

  @override
  String get snippetFormDescriptionHint => 'Необязательное описание...';

  @override
  String get snippetFormFolderLabel => 'Папка';

  @override
  String get snippetFormNoFolder => 'Без папки';

  @override
  String get snippetFormNameRequired => 'Имя обязательно';

  @override
  String get snippetFormContentRequired => 'Содержимое обязательно';

  @override
  String get snippetFormUpdateButton => 'Обновить сниппет';

  @override
  String get snippetFormCreateButton => 'Создать сниппет';

  @override
  String get snippetDetailTitle => 'Подробности сниппета';

  @override
  String get snippetDetailDeleteTitle => 'Удалить сниппет';

  @override
  String get snippetDetailDeleteMessage => 'Это действие нельзя отменить.';

  @override
  String get snippetDetailContent => 'Содержимое';

  @override
  String get snippetDetailFillVariables => 'Заполнить переменные';

  @override
  String get snippetDetailDescription => 'Описание';

  @override
  String get snippetDetailVariables => 'Переменные';

  @override
  String get snippetDetailTags => 'Теги';

  @override
  String get snippetDetailInfo => 'Информация';

  @override
  String get snippetDetailCreated => 'Создано';

  @override
  String get snippetDetailUpdated => 'Обновлено';

  @override
  String get variableEditorTitle => 'Переменные шаблона';

  @override
  String get variableEditorAdd => 'Добавить';

  @override
  String get variableEditorEmpty =>
      'Нет переменных. Используйте фигурные скобки в содержимом для ссылки на них.';

  @override
  String get variableEditorNameLabel => 'Имя';

  @override
  String get variableEditorNameHint => 'напр. hostname';

  @override
  String get variableEditorDefaultLabel => 'По умолчанию';

  @override
  String get variableEditorDefaultHint => 'необязательно';

  @override
  String get variableFillTitle => 'Заполнить переменные';

  @override
  String variableFillHint(String name) {
    return 'Введите значение для $name';
  }

  @override
  String get variableFillPreview => 'Предпросмотр';

  @override
  String get terminalTitle => 'Терминал';

  @override
  String get terminalEmpty => 'Нет активных сеансов';

  @override
  String get terminalEmptySubtitle =>
      'Подключитесь к хосту, чтобы открыть терминальный сеанс.';

  @override
  String get terminalGoToHosts => 'Перейти к хостам';

  @override
  String get terminalCloseAll => 'Закрыть все сеансы';

  @override
  String get terminalCloseTitle => 'Закрыть сеанс';

  @override
  String terminalCloseMessage(String title) {
    return 'Закрыть активное подключение к \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Аутентификация...';

  @override
  String connectionConnecting(String name) {
    return 'Подключение к $name...';
  }

  @override
  String get connectionError => 'Ошибка подключения';

  @override
  String get connectionLost => 'Подключение потеряно';

  @override
  String get connectionReconnect => 'Переподключиться';

  @override
  String get snippetQuickPanelTitle => 'Вставить сниппет';

  @override
  String get snippetQuickPanelSearch => 'Поиск сниппетов...';

  @override
  String get snippetQuickPanelEmpty => 'Нет доступных сниппетов';

  @override
  String get snippetQuickPanelNoMatch => 'Совпадений не найдено';

  @override
  String get snippetQuickPanelInsertTooltip => 'Вставить сниппет';

  @override
  String get terminalThemePickerTitle => 'Тема терминала';

  @override
  String get validatorHostnameRequired => 'Имя хоста обязательно';

  @override
  String get validatorHostnameInvalid => 'Недопустимое имя хоста или IP-адрес';

  @override
  String get validatorPortRequired => 'Порт обязателен';

  @override
  String get validatorPortRange => 'Порт должен быть от 1 до 65535';

  @override
  String get validatorUsernameRequired => 'Имя пользователя обязательно';

  @override
  String get validatorUsernameInvalid =>
      'Недопустимый формат имени пользователя';

  @override
  String get validatorServerNameRequired => 'Имя сервера обязательно';

  @override
  String get validatorServerNameLength =>
      'Имя сервера должно быть не более 100 символов';

  @override
  String get validatorSshKeyInvalid => 'Недопустимый формат SSH-ключа';

  @override
  String get validatorPasswordRequired => 'Пароль обязателен';

  @override
  String get validatorPasswordLength =>
      'Пароль должен содержать не менее 8 символов';

  @override
  String get authMethodPassword => 'Пароль';

  @override
  String get authMethodKey => 'SSH-ключ';

  @override
  String get authMethodBoth => 'Пароль + Ключ';

  @override
  String get serverCopySuffix => '(Копия)';

  @override
  String get settingsDownloadLogs => 'Скачать логи';

  @override
  String get settingsSendLogs => 'Отправить логи в поддержку';

  @override
  String get settingsLogsSaved => 'Логи сохранены успешно';

  @override
  String get settingsLogsEmpty => 'Нет доступных записей логов';

  @override
  String get authLogin => 'Войти';

  @override
  String get authRegister => 'Регистрация';

  @override
  String get authForgotPassword => 'Забыли пароль?';

  @override
  String get authWhyLogin =>
      'Войдите, чтобы включить зашифрованную облачную синхронизацию на всех устройствах. Приложение полностью работает офлайн без аккаунта.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'Email обязателен';

  @override
  String get authEmailInvalid => 'Недопустимый адрес электронной почты';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authConfirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get authPasswordMismatch => 'Пароли не совпадают';

  @override
  String get authNoAccount => 'Нет аккаунта?';

  @override
  String get authHasAccount => 'Уже есть аккаунт?';

  @override
  String get authSelfHosted => 'Собственный сервер';

  @override
  String get authResetEmailSent =>
      'Если аккаунт существует, ссылка для сброса отправлена на вашу электронную почту.';

  @override
  String get authResetDescription =>
      'Введите адрес электронной почты, и мы отправим вам ссылку для сброса пароля.';

  @override
  String get authSendResetLink => 'Отправить ссылку для сброса';

  @override
  String get authBackToLogin => 'Назад ко входу';

  @override
  String get syncPasswordTitle => 'Пароль синхронизации';

  @override
  String get syncPasswordTitleCreate => 'Установить пароль синхронизации';

  @override
  String get syncPasswordTitleEnter => 'Введите пароль синхронизации';

  @override
  String get syncPasswordDescription =>
      'Установите отдельный пароль для шифрования данных хранилища. Этот пароль никогда не покидает ваше устройство — на сервере хранятся только зашифрованные данные.';

  @override
  String get syncPasswordHintEnter =>
      'Введите пароль, который вы установили при создании аккаунта.';

  @override
  String get syncPasswordWarning =>
      'Если вы забудете этот пароль, ваши синхронизированные данные невозможно будет восстановить. Сброс пароля невозможен.';

  @override
  String get syncPasswordLabel => 'Пароль синхронизации';

  @override
  String get syncPasswordWrong => 'Неверный пароль. Попробуйте снова.';

  @override
  String get firstSyncTitle => 'Найдены существующие данные';

  @override
  String get firstSyncMessage =>
      'На этом устройстве есть данные, и на сервере есть хранилище. Как продолжить?';

  @override
  String get firstSyncMerge => 'Объединить (приоритет сервера)';

  @override
  String get firstSyncOverwriteLocal => 'Перезаписать локальные данные';

  @override
  String get firstSyncKeepLocal => 'Оставить локальные и отправить';

  @override
  String get firstSyncDeleteLocal => 'Удалить локальные и загрузить';

  @override
  String get changeEncryptionPassword => 'Изменить пароль шифрования';

  @override
  String get changeEncryptionWarning =>
      'Вы будете разлогинены на всех других устройствах.';

  @override
  String get changeEncryptionOldPassword => 'Текущий пароль';

  @override
  String get changeEncryptionNewPassword => 'Новый пароль';

  @override
  String get changeEncryptionSuccess => 'Пароль успешно изменён.';

  @override
  String get logoutAllDevices => 'Выйти на всех устройствах';

  @override
  String get logoutAllDevicesConfirm =>
      'Все активные сеансы будут отозваны. Вам потребуется войти заново на всех устройствах.';

  @override
  String get logoutAllDevicesSuccess => 'Выход выполнен на всех устройствах.';

  @override
  String get syncSettingsTitle => 'Настройки синхронизации';

  @override
  String get syncAutoSync => 'Автосинхронизация';

  @override
  String get syncAutoSyncDescription =>
      'Автоматическая синхронизация при запуске приложения';

  @override
  String get syncNow => 'Синхронизировать сейчас';

  @override
  String get syncSyncing => 'Синхронизация...';

  @override
  String get syncSuccess => 'Синхронизация завершена';

  @override
  String get syncError => 'Ошибка синхронизации';

  @override
  String get syncServerUnreachable => 'Сервер недоступен';

  @override
  String get syncServerUnreachableHint =>
      'Сервер синхронизации недоступен. Проверьте подключение к интернету и URL сервера.';

  @override
  String get syncNetworkError =>
      'Подключение к серверу не удалось. Проверьте подключение к интернету или попробуйте позже.';

  @override
  String get syncNeverSynced => 'Синхронизация не выполнялась';

  @override
  String get syncVaultVersion => 'Версия хранилища';

  @override
  String get syncTitle => 'Синхронизация';

  @override
  String get settingsSectionNetwork => 'Сеть и DNS';

  @override
  String get settingsDnsServers => 'Серверы DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'По умолчанию (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Введите пользовательские URL-адреса DoH-серверов через запятую. Для перекрёстной проверки необходимо минимум 2 сервера.';

  @override
  String get settingsDnsLabel => 'URL DoH-серверов';

  @override
  String get settingsDnsReset => 'Сбросить по умолчанию';

  @override
  String get settingsSectionSync => 'Синхронизация';

  @override
  String get settingsSyncAccount => 'Аккаунт';

  @override
  String get settingsSyncNotLoggedIn => 'Не выполнен вход';

  @override
  String get settingsSyncStatus => 'Синхронизация';

  @override
  String get settingsSyncServerUrl => 'URL сервера';

  @override
  String get settingsSyncDefaultServer => 'По умолчанию (sshvault.app)';

  @override
  String get accountTitle => 'Аккаунт';

  @override
  String get accountNotLoggedIn => 'Не выполнен вход';

  @override
  String get accountVerified => 'Подтверждён';

  @override
  String get accountMemberSince => 'Участник с';

  @override
  String get accountDevices => 'Устройства';

  @override
  String get accountNoDevices => 'Нет зарегистрированных устройств';

  @override
  String get accountLastSync => 'Последняя синхронизация';

  @override
  String get accountChangePassword => 'Изменить пароль';

  @override
  String get accountOldPassword => 'Текущий пароль';

  @override
  String get accountNewPassword => 'Новый пароль';

  @override
  String get accountDeleteAccount => 'Удалить аккаунт';

  @override
  String get accountDeleteWarning =>
      'Это навсегда удалит ваш аккаунт и все синхронизированные данные. Это действие нельзя отменить.';

  @override
  String get accountLogout => 'Выйти';

  @override
  String get serverConfigTitle => 'Конфигурация сервера';

  @override
  String get serverConfigSelfHosted => 'Собственный сервер';

  @override
  String get serverConfigSelfHostedDescription =>
      'Используйте свой собственный сервер SSHVault';

  @override
  String get serverConfigUrlLabel => 'URL сервера';

  @override
  String get serverConfigTest => 'Проверить соединение';

  @override
  String get auditLogTitle => 'Журнал действий';

  @override
  String get auditLogAll => 'Все';

  @override
  String get auditLogEmpty => 'Записи журнала не найдены';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Файловый менеджер';

  @override
  String get sftpLocalDevice => 'Локальное устройство';

  @override
  String get sftpSelectServer => 'Выберите сервер...';

  @override
  String get sftpConnecting => 'Подключение...';

  @override
  String get sftpEmptyDirectory => 'Эта директория пуста';

  @override
  String get sftpNoConnection => 'Сервер не подключён';

  @override
  String get sftpPathLabel => 'Путь';

  @override
  String get sftpUpload => 'Загрузить';

  @override
  String get sftpDownload => 'Скачать';

  @override
  String get sftpDelete => 'Удалить';

  @override
  String get sftpRename => 'Переименовать';

  @override
  String get sftpNewFolder => 'Новая папка';

  @override
  String get sftpNewFolderName => 'Имя папки';

  @override
  String get sftpChmod => 'Права доступа';

  @override
  String get sftpChmodTitle => 'Изменить права доступа';

  @override
  String get sftpChmodOctal => 'Восьмеричный';

  @override
  String get sftpChmodOwner => 'Владелец';

  @override
  String get sftpChmodGroup => 'Группа';

  @override
  String get sftpChmodOther => 'Остальные';

  @override
  String get sftpChmodRead => 'Чтение';

  @override
  String get sftpChmodWrite => 'Запись';

  @override
  String get sftpChmodExecute => 'Выполнение';

  @override
  String get sftpCreateSymlink => 'Создать символическую ссылку';

  @override
  String get sftpSymlinkTarget => 'Целевой путь';

  @override
  String get sftpSymlinkName => 'Имя ссылки';

  @override
  String get sftpFilePreview => 'Предпросмотр файла';

  @override
  String get sftpFileInfo => 'Информация о файле';

  @override
  String get sftpFileSize => 'Размер';

  @override
  String get sftpFileModified => 'Изменён';

  @override
  String get sftpFilePermissions => 'Права доступа';

  @override
  String get sftpFileOwner => 'Владелец';

  @override
  String get sftpFileType => 'Тип';

  @override
  String get sftpFileLinkTarget => 'Цель ссылки';

  @override
  String get sftpTransfers => 'Передачи';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current из $total';
  }

  @override
  String get sftpTransferQueued => 'В очереди';

  @override
  String get sftpTransferActive => 'Передача...';

  @override
  String get sftpTransferPaused => 'Приостановлено';

  @override
  String get sftpTransferCompleted => 'Завершено';

  @override
  String get sftpTransferFailed => 'Ошибка';

  @override
  String get sftpTransferCancelled => 'Отменено';

  @override
  String get sftpPauseTransfer => 'Приостановить';

  @override
  String get sftpResumeTransfer => 'Возобновить';

  @override
  String get sftpCancelTransfer => 'Отменить';

  @override
  String get sftpClearCompleted => 'Очистить завершённые';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active из $total передач';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активных',
      one: '1 активная',
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
      other: '$count с ошибками',
      one: '1 с ошибкой',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Копировать в другую панель';

  @override
  String sftpConfirmDelete(int count) {
    return 'Удалить $count элементов?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Успешно удалено';

  @override
  String get sftpRenameTitle => 'Переименовать';

  @override
  String get sftpRenameLabel => 'Новое имя';

  @override
  String get sftpSortByName => 'Имя';

  @override
  String get sftpSortBySize => 'Размер';

  @override
  String get sftpSortByDate => 'Дата';

  @override
  String get sftpSortByType => 'Тип';

  @override
  String get sftpShowHidden => 'Показать скрытые файлы';

  @override
  String get sftpHideHidden => 'Скрыть скрытые файлы';

  @override
  String get sftpSelectAll => 'Выбрать все';

  @override
  String get sftpDeselectAll => 'Снять выделение';

  @override
  String sftpItemsSelected(int count) {
    return '$count выбрано';
  }

  @override
  String get sftpRefresh => 'Обновить';

  @override
  String sftpConnectionError(String message) {
    return 'Ошибка подключения: $message';
  }

  @override
  String get sftpPermissionDenied => 'Доступ запрещён';

  @override
  String sftpOperationFailed(String message) {
    return 'Операция не удалась: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Файл уже существует';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" уже существует. Перезаписать?';
  }

  @override
  String get sftpOverwrite => 'Перезаписать';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Передача начата: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Сначала выберите место назначения в другой панели';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Передача директорий скоро появится';

  @override
  String get sftpSelect => 'Выбрать';

  @override
  String get sftpOpen => 'Открыть';

  @override
  String get sftpExtractArchive => 'Извлечь здесь';

  @override
  String get sftpExtractSuccess => 'Архив извлечён';

  @override
  String sftpExtractFailed(String message) {
    return 'Извлечение не удалось: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Неподдерживаемый формат архива';

  @override
  String get sftpExtracting => 'Извлечение...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count загрузок начато',
      one: 'Загрузка начата',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count скачиваний начато',
      one: 'Скачивание начато',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" скачан';
  }

  @override
  String get sftpSavedToDownloads => 'Сохранено в Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Сохранить в файлы';

  @override
  String get sftpFileSaved => 'Файл сохранён';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH-сеансов активно',
      one: 'SSH-сеанс активен',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Нажмите, чтобы открыть терминал';

  @override
  String get settingsAccountAndSync => 'Аккаунт и синхронизация';

  @override
  String get settingsAccountSubtitleAuth => 'Вход выполнен';

  @override
  String get settingsAccountSubtitleUnauth => 'Вход не выполнен';

  @override
  String get settingsSecuritySubtitle => 'Автоблокировка, Биометрия, PIN';

  @override
  String get settingsSshSubtitle => 'Порт 22, Пользователь root';

  @override
  String get settingsAppearanceSubtitle => 'Тема, Язык, Терминал';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Настройки шифрованного экспорта';

  @override
  String get settingsAboutSubtitle => 'Версия, Лицензии';

  @override
  String get settingsSearchHint => 'Поиск настроек...';

  @override
  String get settingsSearchNoResults => 'Настройки не найдены';

  @override
  String get aboutDeveloper => 'Разработано Kiefer Networks';

  @override
  String get aboutDonate => 'Пожертвовать';

  @override
  String get aboutOpenSourceLicenses => 'Лицензии открытого ПО';

  @override
  String get aboutWebsite => 'Веб-сайт';

  @override
  String get aboutVersion => 'Версия';

  @override
  String get aboutBuild => 'Сборка';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS шифрует DNS-запросы и предотвращает DNS-спуфинг. SSHVault проверяет имена хостов через несколько провайдеров для обнаружения атак.';

  @override
  String get settingsDnsAddServer => 'Добавить DNS-сервер';

  @override
  String get settingsDnsServerUrl => 'URL сервера';

  @override
  String get settingsDnsDefaultBadge => 'По умолчанию';

  @override
  String get settingsDnsResetDefaults => 'Сбросить по умолчанию';

  @override
  String get settingsDnsInvalidUrl => 'Введите корректный HTTPS URL';

  @override
  String get settingsDefaultAuthMethod => 'Метод аутентификации';

  @override
  String get settingsAuthPassword => 'Пароль';

  @override
  String get settingsAuthKey => 'SSH-ключ';

  @override
  String get settingsConnectionTimeout => 'Тайм-аут подключения';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds с';
  }

  @override
  String get settingsKeepaliveInterval => 'Интервал Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds с';
  }

  @override
  String get settingsCompression => 'Сжатие';

  @override
  String get settingsCompressionDescription =>
      'Включить сжатие zlib для SSH-подключений';

  @override
  String get settingsTerminalType => 'Тип терминала';

  @override
  String get settingsSectionConnection => 'Подключение';

  @override
  String get settingsClipboardAutoClear => 'Автоочистка буфера обмена';

  @override
  String get settingsClipboardAutoClearOff => 'Выкл.';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds с';
  }

  @override
  String get settingsSessionTimeout => 'Тайм-аут сеанса';

  @override
  String get settingsSessionTimeoutOff => 'Выкл.';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes мин';
  }

  @override
  String get settingsDuressPin => 'Принудительный PIN';

  @override
  String get settingsDuressPinDescription =>
      'Отдельный PIN, который стирает все данные при вводе';

  @override
  String get settingsDuressPinSet => 'Принудительный PIN установлен';

  @override
  String get settingsDuressPinNotSet => 'Не настроен';

  @override
  String get settingsDuressPinWarning =>
      'Ввод этого PIN навсегда удалит все локальные данные, включая учётные данные, ключи и настройки. Это действие нельзя отменить.';

  @override
  String get settingsKeyRotationReminder => 'Напоминание о ротации ключей';

  @override
  String get settingsKeyRotationOff => 'Выкл.';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days дней';
  }

  @override
  String get settingsFailedAttempts => 'Неудачные попытки ввода PIN';

  @override
  String get settingsSectionAppLock => 'Блокировка приложения';

  @override
  String get settingsSectionPrivacy => 'Конфиденциальность';

  @override
  String get settingsSectionReminders => 'Напоминания';

  @override
  String get settingsSectionStatus => 'Статус';

  @override
  String get settingsExportBackupSubtitle =>
      'Экспорт, Импорт и Резервное копирование';

  @override
  String get settingsExportJson => 'Экспорт в JSON';

  @override
  String get settingsExportEncrypted => 'Зашифрованный экспорт';

  @override
  String get settingsImportFile => 'Импорт из файла';

  @override
  String get settingsSectionImport => 'Импорт';

  @override
  String get filterTitle => 'Фильтр серверов';

  @override
  String get filterApply => 'Применить фильтры';

  @override
  String get filterClearAll => 'Сбросить все';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фильтров активно',
      one: '1 фильтр активен',
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
  String get variablePreviewResolved => 'Предпросмотр с подстановкой';

  @override
  String get variableInsert => 'Вставить';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count серверов',
      one: '1 сервер',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сеансов отозвано.',
      one: '1 сеанс отозван.',
    );
    return '$_temp0 Вы вышли из аккаунта.';
  }

  @override
  String get keyGenPassphrase => 'Парольная фраза';

  @override
  String get keyGenPassphraseHint => 'Необязательно — защищает закрытый ключ';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'По умолчанию (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Ключ с таким же отпечатком уже существует: \"$name\". Каждый SSH-ключ должен быть уникальным.';
  }

  @override
  String get sshKeyFingerprint => 'Отпечаток';

  @override
  String get sshKeyPublicKey => 'Открытый ключ';

  @override
  String get jumpHost => 'Промежуточный хост';

  @override
  String get jumpHostNone => 'Нет';

  @override
  String get jumpHostLabel => 'Подключиться через промежуточный хост';

  @override
  String get jumpHostSelfError =>
      'Сервер не может быть собственным промежуточным хостом';

  @override
  String get jumpHostConnecting => 'Подключение к промежуточному хосту...';

  @override
  String get jumpHostCircularError =>
      'Обнаружена циклическая цепочка промежуточных хостов';

  @override
  String get logoutDialogTitle => 'Выход';

  @override
  String get logoutDialogMessage =>
      'Удалить все локальные данные? Серверы, SSH-ключи, сниппеты и настройки будут удалены с этого устройства.';

  @override
  String get logoutOnly => 'Только выйти';

  @override
  String get logoutAndDelete => 'Выйти и удалить данные';

  @override
  String get changeAvatar => 'Изменить аватар';

  @override
  String get removeAvatar => 'Удалить аватар';

  @override
  String get avatarUploadFailed => 'Не удалось загрузить аватар';

  @override
  String get avatarTooLarge => 'Изображение слишком большое';

  @override
  String get deviceLastSeen => 'Последняя активность';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'URL сервера нельзя изменить при входе в аккаунт. Сначала выйдите.';

  @override
  String get serverListNoFolder => 'Без категории';

  @override
  String get autoSyncInterval => 'Интервал синхронизации';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes мин';
  }

  @override
  String get proxySettings => 'Настройки прокси';

  @override
  String get proxyType => 'Тип прокси';

  @override
  String get proxyNone => 'Без прокси';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Хост прокси';

  @override
  String get proxyPort => 'Порт прокси';

  @override
  String get proxyUsername => 'Имя пользователя прокси';

  @override
  String get proxyPassword => 'Пароль прокси';

  @override
  String get proxyUseGlobal => 'Использовать глобальный прокси';

  @override
  String get proxyGlobal => 'Глобальный';

  @override
  String get proxyServerSpecific => 'Для конкретного сервера';

  @override
  String get proxyTestConnection => 'Проверить соединение';

  @override
  String get proxyTestSuccess => 'Прокси доступен';

  @override
  String get proxyTestFailed => 'Прокси недоступен';

  @override
  String get proxyDefaultProxy => 'Прокси по умолчанию';

  @override
  String get vpnRequired => 'Требуется VPN';

  @override
  String get vpnRequiredTooltip =>
      'Показывать предупреждение при подключении без активного VPN';

  @override
  String get vpnActive => 'VPN активен';

  @override
  String get vpnInactive => 'VPN неактивен';

  @override
  String get vpnWarningTitle => 'VPN не активен';

  @override
  String get vpnWarningMessage =>
      'Для этого сервера требуется VPN-подключение, но VPN в данный момент не активен. Подключиться всё равно?';

  @override
  String get vpnConnectAnyway => 'Подключиться всё равно';

  @override
  String get postConnectCommands => 'Команды после подключения';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Команды, выполняемые автоматически после подключения (по одной на строку)';

  @override
  String get dashboardFavorites => 'Избранное';

  @override
  String get dashboardRecent => 'Последние';

  @override
  String get dashboardActiveSessions => 'Активные сеансы';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get removeFromFavorites => 'Удалить из избранного';

  @override
  String get noRecentConnections => 'Нет недавних подключений';

  @override
  String get terminalSplit => 'Разделить вид';

  @override
  String get terminalUnsplit => 'Закрыть разделение';

  @override
  String get terminalSelectSession => 'Выберите сеанс для разделённого вида';

  @override
  String get knownHostsTitle => 'Известные хосты';

  @override
  String get knownHostsSubtitle =>
      'Управление доверенными отпечатками серверов';

  @override
  String get hostKeyNewTitle => 'Новый хост';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Первое подключение к $hostname:$port. Проверьте отпечаток перед подключением.';
  }

  @override
  String get hostKeyChangedTitle => 'Ключ хоста изменился!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Ключ хоста $hostname:$port изменился. Это может указывать на угрозу безопасности.';
  }

  @override
  String get hostKeyFingerprint => 'Отпечаток';

  @override
  String get hostKeyType => 'Тип ключа';

  @override
  String get hostKeyTrustConnect => 'Доверять и подключиться';

  @override
  String get hostKeyAcceptNew => 'Принять новый ключ';

  @override
  String get hostKeyReject => 'Отклонить';

  @override
  String get hostKeyPreviousFingerprint => 'Предыдущий отпечаток';

  @override
  String get hostKeyDeleteAll => 'Удалить все известные хосты';

  @override
  String get hostKeyDeleteConfirm =>
      'Удалить все известные хосты? При следующем подключении вам будет предложено подтвердить отпечаток.';

  @override
  String get hostKeyEmpty => 'Нет известных хостов';

  @override
  String get hostKeyEmptySubtitle =>
      'Отпечатки хостов будут сохранены здесь после первого подключения';

  @override
  String get hostKeyFirstSeen => 'Впервые обнаружен';

  @override
  String get hostKeyLastSeen => 'Последний раз обнаружен';

  @override
  String get sshConfigImportPickFile => 'Выберите файл SSH Config';

  @override
  String get sshConfigImportOrPaste => 'Или вставьте содержимое конфигурации';

  @override
  String sshConfigImportParsed(int count) {
    return 'Найдено $count хостов';
  }

  @override
  String get sshConfigImportDuplicate => 'Уже существует';

  @override
  String get sshConfigImportNoHosts => 'Хосты в конфигурации не найдены';

  @override
  String get sftpBookmarkAdd => 'Добавить закладку';

  @override
  String get sftpBookmarkLabel => 'Метка';

  @override
  String get disconnect => 'Отключиться';

  @override
  String get reportAndDisconnect => 'Сообщить и отключиться';

  @override
  String get continueAnyway => 'Продолжить всё равно';

  @override
  String get insertSnippet => 'Вставить сниппет';

  @override
  String get seconds => 'Секунды';

  @override
  String get heartbeatLostMessage =>
      'Сервер не отвечал после нескольких попыток. Для вашей безопасности сеанс был завершён.';

  @override
  String get attestationFailedTitle => 'Верификация сервера не удалась';

  @override
  String get attestationFailedMessage =>
      'Сервер не удалось подтвердить как легитимный бэкенд SSHVault. Это может указывать на атаку посредника или неправильно настроенный сервер.';

  @override
  String get attestationKeyChangedTitle => 'Ключ аттестации сервера изменился';

  @override
  String get attestationKeyChangedMessage =>
      'Ключ аттестации сервера изменился с момента первоначального подключения. Это может указывать на атаку посредника. НЕ продолжайте, если администратор сервера не подтвердил ротацию ключей.';

  @override
  String get sectionLinks => 'Ссылки';

  @override
  String get sectionDeveloper => 'Разработчик';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Страница не найдена';

  @override
  String get connectionTestSuccess => 'Подключение успешно';

  @override
  String connectionTestFailed(String message) {
    return 'Подключение не удалось: $message';
  }

  @override
  String get serverVerificationFailed => 'Верификация сервера не удалась';

  @override
  String get importSuccessful => 'Импорт выполнен успешно';

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
