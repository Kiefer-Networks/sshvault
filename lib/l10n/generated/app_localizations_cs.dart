// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Servery';

  @override
  String get navSnippets => 'Úryvky';

  @override
  String get navFolders => 'Složky';

  @override
  String get navTags => 'Štítky';

  @override
  String get navSshKeys => 'SSH klíče';

  @override
  String get navExportImport => 'Export / Import';

  @override
  String get navTerminal => 'Terminál';

  @override
  String get navMore => 'Více';

  @override
  String get navManagement => 'Správa';

  @override
  String get navSettings => 'Nastavení';

  @override
  String get navAbout => 'O aplikaci';

  @override
  String get lockScreenTitle => 'SSHVault je zamčen';

  @override
  String get lockScreenUnlock => 'Odemknout';

  @override
  String get lockScreenEnterPin => 'Zadejte PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Příliš mnoho neúspěšných pokusů. Zkuste to znovu za $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Nastavit PIN kód';

  @override
  String get pinDialogSetSubtitle => 'Zadejte 6místný PIN pro ochranu SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Potvrďte PIN';

  @override
  String get pinDialogErrorLength => 'PIN musí mít přesně 6 číslic';

  @override
  String get pinDialogErrorMismatch => 'PIN kódy se neshodují';

  @override
  String get pinDialogVerifyTitle => 'Zadejte PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Nesprávný PIN. Zbývá $attempts pokusů.';
  }

  @override
  String get securityBannerMessage =>
      'Vaše SSH přihlašovací údaje nejsou chráněny. Nastavte PIN nebo biometrický zámek v Nastavení.';

  @override
  String get securityBannerDismiss => 'Zavřít';

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get settingsSectionAppearance => 'Vzhled';

  @override
  String get settingsSectionTerminal => 'Terminál';

  @override
  String get settingsSectionSshDefaults => 'Výchozí SSH';

  @override
  String get settingsSectionSecurity => 'Zabezpečení';

  @override
  String get settingsSectionExport => 'Export';

  @override
  String get settingsSectionAbout => 'O aplikaci';

  @override
  String get settingsTheme => 'Motiv';

  @override
  String get settingsThemeSystem => 'Systém';

  @override
  String get settingsThemeLight => 'Světlý';

  @override
  String get settingsThemeDark => 'Tmavý';

  @override
  String get settingsTerminalTheme => 'Motiv terminálu';

  @override
  String get settingsTerminalThemeDefault => 'Výchozí tmavý';

  @override
  String get settingsFontSize => 'Velikost písma';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Výchozí port';

  @override
  String get settingsDefaultPortDialog => 'Výchozí SSH port';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Výchozí uživatelské jméno';

  @override
  String get settingsDefaultUsernameDialog => 'Výchozí uživatelské jméno';

  @override
  String get settingsUsernameLabel => 'Uživatelské jméno';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automatický zámek';

  @override
  String get settingsAutoLockDisabled => 'Vypnuto';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minut';
  }

  @override
  String get settingsAutoLockOff => 'Vyp.';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Biometrické odemknutí';

  @override
  String get settingsBiometricNotAvailable => 'Na tomto zařízení nedostupné';

  @override
  String get settingsBiometricError => 'Chyba při kontrole biometrie';

  @override
  String get settingsBiometricReason =>
      'Ověřte svou totožnost pro aktivaci biometrického odemknutí';

  @override
  String get settingsBiometricRequiresPin =>
      'Nejprve nastavte PIN pro aktivaci biometrického odemknutí';

  @override
  String get settingsPinCode => 'PIN kód';

  @override
  String get settingsPinIsSet => 'PIN je nastaven';

  @override
  String get settingsPinNotConfigured => 'PIN není nastaven';

  @override
  String get settingsPinRemove => 'Odstranit';

  @override
  String get settingsPinRemoveWarning =>
      'Odstranění PIN kódu dešifruje všechna pole v databázi a deaktivuje biometrické odemknutí. Pokračovat?';

  @override
  String get settingsPinRemoveTitle => 'Odstranit PIN';

  @override
  String get settingsPreventScreenshots => 'Zabránit snímkům obrazovky';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Blokovat snímky obrazovky a záznam obrazovky';

  @override
  String get settingsEncryptExport => 'Šifrovat exporty ve výchozím nastavení';

  @override
  String get settingsAbout => 'O aplikaci SSHVault';

  @override
  String get settingsAboutLegalese => 'od Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Bezpečný, self-hosted SSH klient';

  @override
  String get settingsLanguage => 'Jazyk';

  @override
  String get settingsLanguageSystem => 'Systém';

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
  String get cancel => 'Zrušit';

  @override
  String get save => 'Uložit';

  @override
  String get delete => 'Smazat';

  @override
  String get close => 'Zavřít';

  @override
  String get update => 'Aktualizovat';

  @override
  String get create => 'Vytvořit';

  @override
  String get retry => 'Opakovat';

  @override
  String get copy => 'Kopírovat';

  @override
  String get edit => 'Upravit';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Chyba: $message';
  }

  @override
  String get serverListTitle => 'Servery';

  @override
  String get serverListEmpty => 'Zatím žádné servery';

  @override
  String get serverListEmptySubtitle =>
      'Přidejte svůj první SSH server a začněte.';

  @override
  String get serverAddButton => 'Přidat server';

  @override
  String sshConfigImportMessage(int count) {
    return 'Nalezeno $count hostitelů v ~/.ssh/config. Importovat?';
  }

  @override
  String get sshConfigNotFound => 'Soubor SSH konfigurace nenalezen';

  @override
  String get sshConfigEmpty =>
      'V SSH konfiguraci nebyli nalezeni žádní hostitelé';

  @override
  String get sshConfigAddManually => 'Přidat ručně';

  @override
  String get sshConfigImportAgain => 'Importovat SSH konfiguraci znovu?';

  @override
  String get sshConfigImportKeys =>
      'Importovat SSH klíče odkazované vybranými servery?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH klíčů importováno';
  }

  @override
  String get serverDuplicated => 'Server duplikován';

  @override
  String get serverDeleteTitle => 'Smazat server';

  @override
  String serverDeleteMessage(String name) {
    return 'Opravdu chcete smazat \"$name\"? Tuto akci nelze vrátit.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Smazat \"$name\"?';
  }

  @override
  String get serverConnect => 'Připojit';

  @override
  String get serverDetails => 'Podrobnosti';

  @override
  String get serverDuplicate => 'Duplikovat';

  @override
  String get serverActive => 'Aktivní';

  @override
  String get serverNoFolder => 'Bez složky';

  @override
  String get serverFormTitleEdit => 'Upravit server';

  @override
  String get serverFormTitleAdd => 'Přidat server';

  @override
  String get serverSaved => 'Server uložen';

  @override
  String get serverFormUpdateButton => 'Aktualizovat server';

  @override
  String get serverFormAddButton => 'Přidat server';

  @override
  String get serverFormPublicKeyExtracted => 'Veřejný klíč úspěšně extrahován';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Nepodařilo se extrahovat veřejný klíč: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Pár klíčů $type vygenerován';
  }

  @override
  String get serverDetailTitle => 'Podrobnosti serveru';

  @override
  String get serverDetailDeleteMessage => 'Tuto akci nelze vrátit.';

  @override
  String get serverDetailConnection => 'Připojení';

  @override
  String get serverDetailHost => 'Hostitel';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Uživatelské jméno';

  @override
  String get serverDetailFolder => 'Složka';

  @override
  String get serverDetailTags => 'Štítky';

  @override
  String get serverDetailNotes => 'Poznámky';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Vytvořeno';

  @override
  String get serverDetailUpdated => 'Aktualizováno';

  @override
  String get serverDetailDistro => 'Systém';

  @override
  String get copiedToClipboard => 'Zkopírováno do schránky';

  @override
  String get serverFormNameLabel => 'Název serveru';

  @override
  String get serverFormHostnameLabel => 'Hostname / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Uživatelské jméno';

  @override
  String get serverFormPasswordLabel => 'Heslo';

  @override
  String get serverFormUseManagedKey => 'Použít spravovaný klíč';

  @override
  String get serverFormManagedKeySubtitle =>
      'Vybrat z centrálně spravovaných SSH klíčů';

  @override
  String get serverFormDirectKeySubtitle =>
      'Vložit klíč přímo k tomuto serveru';

  @override
  String get serverFormGenerateKey => 'Vygenerovat pár SSH klíčů';

  @override
  String get serverFormPrivateKeyLabel => 'Soukromý klíč';

  @override
  String get serverFormPrivateKeyHint => 'Vložte SSH soukromý klíč...';

  @override
  String get serverFormExtractPublicKey => 'Extrahovat veřejný klíč';

  @override
  String get serverFormPublicKeyLabel => 'Veřejný klíč';

  @override
  String get serverFormPublicKeyHint =>
      'Automaticky generován ze soukromého klíče, pokud je prázdný';

  @override
  String get serverFormPassphraseLabel => 'Heslo klíče (volitelné)';

  @override
  String get serverFormNotesLabel => 'Poznámky (volitelné)';

  @override
  String get searchServers => 'Hledat servery...';

  @override
  String get filterAllFolders => 'Všechny složky';

  @override
  String get filterAll => 'Vše';

  @override
  String get filterActive => 'Aktivní';

  @override
  String get filterInactive => 'Neaktivní';

  @override
  String get filterClear => 'Vymazat';

  @override
  String get folderListTitle => 'Složky';

  @override
  String get folderListEmpty => 'Zatím žádné složky';

  @override
  String get folderListEmptySubtitle =>
      'Vytvořte složky pro organizaci vašich serverů.';

  @override
  String get folderAddButton => 'Přidat složku';

  @override
  String get folderDeleteTitle => 'Smazat složku';

  @override
  String folderDeleteMessage(String name) {
    return 'Smazat \"$name\"? Servery budou neorganizované.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serverů',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Sbalit';

  @override
  String get folderShowHosts => 'Zobrazit hostitele';

  @override
  String get folderConnectAll => 'Připojit vše';

  @override
  String get folderFormTitleEdit => 'Upravit složku';

  @override
  String get folderFormTitleNew => 'Nová složka';

  @override
  String get folderFormNameLabel => 'Název složky';

  @override
  String get folderFormParentLabel => 'Nadřazená složka';

  @override
  String get folderFormParentNone => 'Žádná (kořen)';

  @override
  String get tagListTitle => 'Štítky';

  @override
  String get tagListEmpty => 'Zatím žádné štítky';

  @override
  String get tagListEmptySubtitle =>
      'Vytvořte štítky pro označení a filtrování serverů.';

  @override
  String get tagAddButton => 'Přidat štítek';

  @override
  String get tagDeleteTitle => 'Smazat štítek';

  @override
  String tagDeleteMessage(String name) {
    return 'Smazat \"$name\"? Bude odstraněn ze všech serverů.';
  }

  @override
  String get tagFormTitleEdit => 'Upravit štítek';

  @override
  String get tagFormTitleNew => 'Nový štítek';

  @override
  String get tagFormNameLabel => 'Název štítku';

  @override
  String get sshKeyListTitle => 'SSH klíče';

  @override
  String get sshKeyListEmpty => 'Zatím žádné SSH klíče';

  @override
  String get sshKeyListEmptySubtitle =>
      'Vygenerujte nebo importujte SSH klíče pro centrální správu';

  @override
  String get sshKeyCannotDeleteTitle => 'Nelze smazat';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Nelze smazat \"$name\". Používáno $count serverem/servery. Nejprve odpojte od všech serverů.';
  }

  @override
  String get sshKeyDeleteTitle => 'Smazat SSH klíč';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Smazat \"$name\"? Tuto akci nelze vrátit.';
  }

  @override
  String get sshKeyAddButton => 'Přidat SSH klíč';

  @override
  String get sshKeyFormTitleEdit => 'Upravit SSH klíč';

  @override
  String get sshKeyFormTitleAdd => 'Přidat SSH klíč';

  @override
  String get sshKeyFormTabGenerate => 'Vygenerovat';

  @override
  String get sshKeyFormTabImport => 'Importovat';

  @override
  String get sshKeyFormNameLabel => 'Název klíče';

  @override
  String get sshKeyFormNameHint => 'např. Produkční klíč';

  @override
  String get sshKeyFormKeyType => 'Typ klíče';

  @override
  String get sshKeyFormKeySize => 'Velikost klíče';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Komentář';

  @override
  String get sshKeyFormCommentHint => 'uživatel@hostitel nebo popis';

  @override
  String get sshKeyFormCommentOptional => 'Komentář (volitelný)';

  @override
  String get sshKeyFormImportFromFile => 'Importovat ze souboru';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Soukromý klíč';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Vložte SSH soukromý klíč nebo použijte tlačítko výše...';

  @override
  String get sshKeyFormPassphraseLabel => 'Heslo (volitelné)';

  @override
  String get sshKeyFormNameRequired => 'Název je povinný';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Soukromý klíč je povinný';

  @override
  String get sshKeyFormFileReadError => 'Vybraný soubor nelze přečíst';

  @override
  String get sshKeyFormInvalidFormat =>
      'Neplatný formát klíče — očekáván formát PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Čtení souboru se nezdařilo: $message';
  }

  @override
  String get sshKeyFormSaving => 'Ukládání...';

  @override
  String get sshKeySelectorLabel => 'SSH klíč';

  @override
  String get sshKeySelectorNone => 'Žádný spravovaný klíč';

  @override
  String get sshKeySelectorManage => 'Spravovat klíče...';

  @override
  String get sshKeySelectorError => 'Nepodařilo se načíst SSH klíče';

  @override
  String get sshKeyTileCopyPublicKey => 'Kopírovat veřejný klíč';

  @override
  String get sshKeyTilePublicKeyCopied => 'Veřejný klíč zkopírován';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Používáno $count serverem/servery';
  }

  @override
  String get sshKeySavedSuccess => 'SSH klíč uložen';

  @override
  String get sshKeyDeletedSuccess => 'SSH klíč smazán';

  @override
  String get tagSavedSuccess => 'Štítek uložen';

  @override
  String get tagDeletedSuccess => 'Štítek smazán';

  @override
  String get folderDeletedSuccess => 'Složka smazána';

  @override
  String get sshKeyTileUnlinkFirst => 'Nejprve odpojte od všech serverů';

  @override
  String get exportImportTitle => 'Export / Import';

  @override
  String get exportSectionTitle => 'Export';

  @override
  String get exportJsonButton =>
      'Exportovat jako JSON (bez přihlašovacích údajů)';

  @override
  String get exportZipButton =>
      'Exportovat šifrovaný ZIP (s přihlašovacími údaji)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Importovat ze souboru';

  @override
  String get importSupportedFormats =>
      'Podporuje JSON (prostý text) a ZIP (šifrované) soubory.';

  @override
  String exportedTo(String path) {
    return 'Exportováno do: $path';
  }

  @override
  String get share => 'Sdílet';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Importováno $servers serverů, $groups skupin, $tags štítků. $skipped přeskočeno.';
  }

  @override
  String get importPasswordTitle => 'Zadejte heslo';

  @override
  String get importPasswordLabel => 'Heslo exportu';

  @override
  String get importPasswordDecrypt => 'Dešifrovat';

  @override
  String get exportPasswordTitle => 'Nastavit heslo exportu';

  @override
  String get exportPasswordDescription =>
      'Toto heslo bude použito k šifrování exportního souboru včetně přihlašovacích údajů.';

  @override
  String get exportPasswordLabel => 'Heslo';

  @override
  String get exportPasswordConfirmLabel => 'Potvrďte heslo';

  @override
  String get exportPasswordMismatch => 'Hesla se neshodují';

  @override
  String get exportPasswordButton => 'Šifrovat a exportovat';

  @override
  String get importConflictTitle => 'Řešení konfliktů';

  @override
  String get importConflictDescription =>
      'Jak mají být zpracovány existující záznamy při importu?';

  @override
  String get importConflictSkip => 'Přeskočit existující';

  @override
  String get importConflictRename => 'Přejmenovat nové';

  @override
  String get importConflictOverwrite => 'Přepsat';

  @override
  String get confirmDeleteLabel => 'Smazat';

  @override
  String get keyGenTitle => 'Vygenerovat pár SSH klíčů';

  @override
  String get keyGenKeyType => 'Typ klíče';

  @override
  String get keyGenKeySize => 'Velikost klíče';

  @override
  String get keyGenComment => 'Komentář';

  @override
  String get keyGenCommentHint => 'uživatel@hostitel nebo popis';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Generování...';

  @override
  String get keyGenGenerate => 'Vygenerovat';

  @override
  String keyGenResultTitle(String type) {
    return 'Klíč $type vygenerován';
  }

  @override
  String get keyGenPublicKey => 'Veřejný klíč';

  @override
  String get keyGenPrivateKey => 'Soukromý klíč';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Komentář: $comment';
  }

  @override
  String get keyGenAnother => 'Vygenerovat další';

  @override
  String get keyGenUseThisKey => 'Použít tento klíč';

  @override
  String get keyGenCopyTooltip => 'Kopírovat do schránky';

  @override
  String keyGenCopied(String label) {
    return '$label zkopírován';
  }

  @override
  String get colorPickerLabel => 'Barva';

  @override
  String get iconPickerLabel => 'Ikona';

  @override
  String get tagSelectorLabel => 'Štítky';

  @override
  String get tagSelectorEmpty => 'Zatím žádné štítky';

  @override
  String get tagSelectorError => 'Nepodařilo se načíst štítky';

  @override
  String get snippetListTitle => 'Úryvky';

  @override
  String get snippetSearchHint => 'Hledat úryvky...';

  @override
  String get snippetListEmpty => 'Zatím žádné úryvky';

  @override
  String get snippetListEmptySubtitle =>
      'Vytvořte znovupoužitelné úryvky kódu a příkazy.';

  @override
  String get snippetAddButton => 'Přidat úryvek';

  @override
  String get snippetDeleteTitle => 'Smazat úryvek';

  @override
  String snippetDeleteMessage(String name) {
    return 'Smazat \"$name\"? Tuto akci nelze vrátit.';
  }

  @override
  String get snippetFormTitleEdit => 'Upravit úryvek';

  @override
  String get snippetFormTitleNew => 'Nový úryvek';

  @override
  String get snippetFormNameLabel => 'Název';

  @override
  String get snippetFormNameHint => 'např. Docker cleanup';

  @override
  String get snippetFormLanguageLabel => 'Jazyk';

  @override
  String get snippetFormContentLabel => 'Obsah';

  @override
  String get snippetFormContentHint => 'Zadejte kód úryvku...';

  @override
  String get snippetFormDescriptionLabel => 'Popis';

  @override
  String get snippetFormDescriptionHint => 'Volitelný popis...';

  @override
  String get snippetFormFolderLabel => 'Složka';

  @override
  String get snippetFormNoFolder => 'Bez složky';

  @override
  String get snippetFormNameRequired => 'Název je povinný';

  @override
  String get snippetFormContentRequired => 'Obsah je povinný';

  @override
  String get snippetFormSaved => 'Snippet uložen';

  @override
  String get snippetFormUpdateButton => 'Aktualizovat úryvek';

  @override
  String get snippetFormCreateButton => 'Vytvořit úryvek';

  @override
  String get snippetDetailTitle => 'Podrobnosti úryvku';

  @override
  String get snippetDetailDeleteTitle => 'Smazat úryvek';

  @override
  String get snippetDetailDeleteMessage => 'Tuto akci nelze vrátit.';

  @override
  String get snippetDetailContent => 'Obsah';

  @override
  String get snippetDetailFillVariables => 'Vyplnit proměnné';

  @override
  String get snippetDetailDescription => 'Popis';

  @override
  String get snippetDetailVariables => 'Proměnné';

  @override
  String get snippetDetailTags => 'Štítky';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Vytvořeno';

  @override
  String get snippetDetailUpdated => 'Aktualizováno';

  @override
  String get variableEditorTitle => 'Proměnné šablony';

  @override
  String get variableEditorAdd => 'Přidat';

  @override
  String get variableEditorEmpty =>
      'Žádné proměnné. Použijte syntaxi složených závorek v obsahu pro jejich odkaz.';

  @override
  String get variableEditorNameLabel => 'Název';

  @override
  String get variableEditorNameHint => 'např. hostname';

  @override
  String get variableEditorDefaultLabel => 'Výchozí';

  @override
  String get variableEditorDefaultHint => 'volitelné';

  @override
  String get variableFillTitle => 'Vyplnit proměnné';

  @override
  String variableFillHint(String name) {
    return 'Zadejte hodnotu pro $name';
  }

  @override
  String get variableFillPreview => 'Náhled';

  @override
  String get terminalTitle => 'Terminál';

  @override
  String get terminalEmpty => 'Žádné aktivní relace';

  @override
  String get terminalEmptySubtitle =>
      'Připojte se k hostiteli pro otevření terminálu.';

  @override
  String get terminalGoToHosts => 'Přejít na servery';

  @override
  String get terminalCloseAll => 'Zavřít všechny relace';

  @override
  String get terminalCloseTitle => 'Zavřít relaci';

  @override
  String terminalCloseMessage(String title) {
    return 'Zavřít aktivní připojení k \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Ověřování...';

  @override
  String connectionConnecting(String name) {
    return 'Připojování k $name...';
  }

  @override
  String get connectionError => 'Chyba připojení';

  @override
  String get connectionLost => 'Spojení ztraceno';

  @override
  String get connectionReconnect => 'Znovu připojit';

  @override
  String get snippetQuickPanelTitle => 'Vložit úryvek';

  @override
  String get snippetQuickPanelSearch => 'Hledat úryvky...';

  @override
  String get snippetQuickPanelEmpty => 'Žádné úryvky k dispozici';

  @override
  String get snippetQuickPanelNoMatch => 'Žádné odpovídající úryvky';

  @override
  String get snippetQuickPanelInsertTooltip => 'Vložit úryvek';

  @override
  String get terminalThemePickerTitle => 'Motiv terminálu';

  @override
  String get validatorHostnameRequired => 'Hostname je povinný';

  @override
  String get validatorHostnameInvalid => 'Neplatný hostname nebo IP adresa';

  @override
  String get validatorPortRequired => 'Port je povinný';

  @override
  String get validatorPortRange => 'Port musí být mezi 1 a 65535';

  @override
  String get validatorUsernameRequired => 'Uživatelské jméno je povinné';

  @override
  String get validatorUsernameInvalid => 'Neplatný formát uživatelského jména';

  @override
  String get validatorServerNameRequired => 'Název serveru je povinný';

  @override
  String get validatorServerNameLength =>
      'Název serveru nesmí přesáhnout 100 znaků';

  @override
  String get validatorSshKeyInvalid => 'Neplatný formát SSH klíče';

  @override
  String get validatorPasswordRequired => 'Heslo je povinné';

  @override
  String get validatorPasswordLength => 'Heslo musí mít alespoň 8 znaků';

  @override
  String get authMethodPassword => 'Heslo';

  @override
  String get authMethodKey => 'SSH klíč';

  @override
  String get authMethodBoth => 'Heslo + klíč';

  @override
  String get serverCopySuffix => '(Kopie)';

  @override
  String get settingsDownloadLogs => 'Stáhnout protokoly';

  @override
  String get settingsSendLogs => 'Odeslat protokoly podpoře';

  @override
  String get settingsLogsSaved => 'Protokoly úspěšně uloženy';

  @override
  String get settingsUpdated => 'Nastavení aktualizováno';

  @override
  String get settingsThemeChanged => 'Motiv změněn';

  @override
  String get settingsLanguageChanged => 'Jazyk změněn';

  @override
  String get settingsPinSetSuccess => 'PIN nastaven';

  @override
  String get settingsPinRemovedSuccess => 'PIN odstraněn';

  @override
  String get settingsDuressPinSetSuccess => 'Nouzový PIN nastaven';

  @override
  String get settingsDuressPinRemovedSuccess => 'Nouzový PIN odstraněn';

  @override
  String get settingsBiometricEnabled => 'Biometrické odemknutí aktivováno';

  @override
  String get settingsBiometricDisabled => 'Biometrické odemknutí deaktivováno';

  @override
  String get settingsDnsServerAdded => 'DNS server přidán';

  @override
  String get settingsDnsServerRemoved => 'DNS server odebrán';

  @override
  String get settingsDnsResetSuccess => 'DNS servery obnoveny';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Zmenšit písmo';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Zvětšit písmo';

  @override
  String get settingsDnsRemoveServerTooltip => 'Odebrat DNS server';

  @override
  String get settingsLogsEmpty => 'Žádné záznamy protokolu k dispozici';

  @override
  String get authLogin => 'Přihlásit';

  @override
  String get authRegister => 'Registrovat';

  @override
  String get authForgotPassword => 'Zapomněli jste heslo?';

  @override
  String get authWhyLogin =>
      'Přihlaste se pro aktivaci šifrované cloudové synchronizace na všech vašich zařízeních. Aplikace funguje plně offline bez účtu.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailRequired => 'E-mail je povinný';

  @override
  String get authEmailInvalid => 'Neplatná e-mailová adresa';

  @override
  String get authPasswordLabel => 'Heslo';

  @override
  String get authConfirmPasswordLabel => 'Potvrďte heslo';

  @override
  String get authPasswordMismatch => 'Hesla se neshodují';

  @override
  String get authNoAccount => 'Nemáte účet?';

  @override
  String get authHasAccount => 'Již máte účet?';

  @override
  String get authResetEmailSent =>
      'Pokud účet existuje, byl na váš e-mail odeslán odkaz pro resetování.';

  @override
  String get authResetDescription =>
      'Zadejte svou e-mailovou adresu a my vám zašleme odkaz pro resetování hesla.';

  @override
  String get authSendResetLink => 'Odeslat odkaz pro resetování';

  @override
  String get authBackToLogin => 'Zpět na přihlášení';

  @override
  String get syncPasswordTitle => 'Heslo synchronizace';

  @override
  String get syncPasswordTitleCreate => 'Nastavit heslo synchronizace';

  @override
  String get syncPasswordTitleEnter => 'Zadejte heslo synchronizace';

  @override
  String get syncPasswordDescription =>
      'Nastavte samostatné heslo pro šifrování dat vašeho trezoru. Toto heslo nikdy neopustí vaše zařízení — server ukládá pouze šifrovaná data.';

  @override
  String get syncPasswordHintEnter =>
      'Zadejte heslo, které jste nastavili při vytváření účtu.';

  @override
  String get syncPasswordWarning =>
      'Pokud toto heslo zapomenete, vaše synchronizovaná data nelze obnovit. Neexistuje možnost resetování.';

  @override
  String get syncPasswordLabel => 'Heslo synchronizace';

  @override
  String get syncPasswordWrong => 'Nesprávné heslo. Zkuste to prosím znovu.';

  @override
  String get firstSyncTitle => 'Nalezena existující data';

  @override
  String get firstSyncMessage =>
      'Na tomto zařízení jsou existující data a na serveru je trezor. Jak pokračovat?';

  @override
  String get firstSyncMerge => 'Sloučit (server má přednost)';

  @override
  String get firstSyncOverwriteLocal => 'Přepsat lokální data';

  @override
  String get firstSyncKeepLocal => 'Zachovat lokální a nahrát';

  @override
  String get firstSyncDeleteLocal => 'Smazat lokální a stáhnout';

  @override
  String get changeEncryptionPassword => 'Změnit šifrovací heslo';

  @override
  String get changeEncryptionWarning =>
      'Budete odhlášeni na všech ostatních zařízeních.';

  @override
  String get changeEncryptionOldPassword => 'Současné heslo';

  @override
  String get changeEncryptionNewPassword => 'Nové heslo';

  @override
  String get changeEncryptionSuccess => 'Heslo úspěšně změněno.';

  @override
  String get logoutAllDevices => 'Odhlásit ze všech zařízení';

  @override
  String get logoutAllDevicesConfirm =>
      'Tím se zruší všechny aktivní relace. Na všech zařízeních se budete muset znovu přihlásit.';

  @override
  String get logoutAllDevicesSuccess => 'Všechna zařízení odhlášena.';

  @override
  String get syncSettingsTitle => 'Nastavení synchronizace';

  @override
  String get syncAutoSync => 'Automatická synchronizace';

  @override
  String get syncAutoSyncDescription =>
      'Automaticky synchronizovat při spuštění aplikace';

  @override
  String get syncNow => 'Synchronizovat nyní';

  @override
  String get syncSyncing => 'Synchronizace...';

  @override
  String get syncSuccess => 'Synchronizace dokončena';

  @override
  String get syncError => 'Chyba synchronizace';

  @override
  String get syncServerUnreachable => 'Server nedostupný';

  @override
  String get syncServerUnreachableHint =>
      'Synchronizační server nebyl dostupný. Zkontrolujte internetové připojení a URL serveru.';

  @override
  String get syncNetworkError =>
      'Připojení k serveru se nezdařilo. Zkontrolujte prosím internetové připojení nebo to zkuste později.';

  @override
  String get syncNeverSynced => 'Nikdy nesynchronizováno';

  @override
  String get syncVaultVersion => 'Verze trezoru';

  @override
  String get syncTitle => 'Synchronizace';

  @override
  String get settingsSectionNetwork => 'Síť a DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS servery';

  @override
  String get settingsDnsDefault => 'Výchozí (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Zadejte vlastní URL adresy DoH serverů oddělené čárkami. Pro křížovou kontrolu jsou potřeba alespoň 2 servery.';

  @override
  String get settingsDnsLabel => 'URL adresy DoH serverů';

  @override
  String get settingsDnsReset => 'Obnovit výchozí';

  @override
  String get settingsSectionSync => 'Synchronizace';

  @override
  String get settingsSyncAccount => 'Účet';

  @override
  String get settingsSyncNotLoggedIn => 'Nepřihlášen';

  @override
  String get settingsSyncStatus => 'Synchronizace';

  @override
  String get settingsSyncServerUrl => 'URL serveru';

  @override
  String get settingsSyncDefaultServer => 'Výchozí (sshvault.app)';

  @override
  String get accountTitle => 'Účet';

  @override
  String get accountNotLoggedIn => 'Nepřihlášen';

  @override
  String get accountVerified => 'Ověřen';

  @override
  String get accountMemberSince => 'Členem od';

  @override
  String get accountDevices => 'Zařízení';

  @override
  String get accountNoDevices => 'Žádná registrovaná zařízení';

  @override
  String get accountLastSync => 'Poslední synchronizace';

  @override
  String get accountChangePassword => 'Změnit heslo';

  @override
  String get accountOldPassword => 'Současné heslo';

  @override
  String get accountNewPassword => 'Nové heslo';

  @override
  String get accountDeleteAccount => 'Smazat účet';

  @override
  String get accountDeleteWarning =>
      'Tím trvale smažete svůj účet a všechna synchronizovaná data. Tuto akci nelze vrátit.';

  @override
  String get accountLogout => 'Odhlásit';

  @override
  String get serverConfigTitle => 'Konfigurace serveru';

  @override
  String get serverConfigUrlLabel => 'URL serveru';

  @override
  String get serverConfigTest => 'Otestovat připojení';

  @override
  String get serverSetupTitle => 'Nastavení serveru';

  @override
  String get serverSetupInfoCard =>
      'ShellVault vyžaduje vlastní server pro end-to-end šifrovanou synchronizaci. Nasaďte vlastní instanci, abyste mohli začít.';

  @override
  String get serverSetupRepoLink => 'Zobrazit na GitHubu';

  @override
  String get serverSetupContinue => 'Pokračovat';

  @override
  String get settingsServerNotConfigured => 'Žádný server není nakonfigurován';

  @override
  String get settingsSetupSync => 'Nastavte synchronizaci pro zálohování dat';

  @override
  String get settingsChangeServer => 'Změnit server';

  @override
  String get settingsChangeServerConfirm =>
      'Změna serveru vás odhlásí. Pokračovat?';

  @override
  String get auditLogTitle => 'Protokol aktivit';

  @override
  String get auditLogAll => 'Vše';

  @override
  String get auditLogEmpty => 'Žádné záznamy aktivit nenalezeny';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Správce souborů';

  @override
  String get sftpLocalDevice => 'Místní zařízení';

  @override
  String get sftpSelectServer => 'Vybrat server...';

  @override
  String get sftpConnecting => 'Připojování...';

  @override
  String get sftpEmptyDirectory => 'Tento adresář je prázdný';

  @override
  String get sftpNoConnection => 'Žádný server nepřipojen';

  @override
  String get sftpPathLabel => 'Cesta';

  @override
  String get sftpUpload => 'Nahrát';

  @override
  String get sftpDownload => 'Stáhnout';

  @override
  String get sftpDelete => 'Smazat';

  @override
  String get sftpRename => 'Přejmenovat';

  @override
  String get sftpNewFolder => 'Nová složka';

  @override
  String get sftpNewFolderName => 'Název složky';

  @override
  String get sftpChmod => 'Oprávnění';

  @override
  String get sftpChmodTitle => 'Změnit oprávnění';

  @override
  String get sftpChmodOctal => 'Osmičkové';

  @override
  String get sftpChmodOwner => 'Vlastník';

  @override
  String get sftpChmodGroup => 'Skupina';

  @override
  String get sftpChmodOther => 'Ostatní';

  @override
  String get sftpChmodRead => 'Čtení';

  @override
  String get sftpChmodWrite => 'Zápis';

  @override
  String get sftpChmodExecute => 'Spuštění';

  @override
  String get sftpCreateSymlink => 'Vytvořit symbolický odkaz';

  @override
  String get sftpSymlinkTarget => 'Cílová cesta';

  @override
  String get sftpSymlinkName => 'Název odkazu';

  @override
  String get sftpFilePreview => 'Náhled souboru';

  @override
  String get sftpFileInfo => 'Informace o souboru';

  @override
  String get sftpFileSize => 'Velikost';

  @override
  String get sftpFileModified => 'Změněno';

  @override
  String get sftpFilePermissions => 'Oprávnění';

  @override
  String get sftpFileOwner => 'Vlastník';

  @override
  String get sftpFileType => 'Typ';

  @override
  String get sftpFileLinkTarget => 'Cíl odkazu';

  @override
  String get sftpTransfers => 'Přenosy';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current z $total';
  }

  @override
  String get sftpTransferQueued => 'Ve frontě';

  @override
  String get sftpTransferActive => 'Přenáší se...';

  @override
  String get sftpTransferPaused => 'Pozastaveno';

  @override
  String get sftpTransferCompleted => 'Dokončeno';

  @override
  String get sftpTransferFailed => 'Neúspěšné';

  @override
  String get sftpTransferCancelled => 'Zrušeno';

  @override
  String get sftpPauseTransfer => 'Pozastavit';

  @override
  String get sftpResumeTransfer => 'Pokračovat';

  @override
  String get sftpCancelTransfer => 'Zrušit';

  @override
  String get sftpClearCompleted => 'Vymazat dokončené';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active z $total přenosů';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktivních',
      one: '1 aktivní',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dokončených',
      one: '1 dokončený',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neúspěšných',
      one: '1 neúspěšný',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Kopírovat do druhého panelu';

  @override
  String sftpConfirmDelete(int count) {
    return 'Smazat $count položek?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Smazat \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Úspěšně smazáno';

  @override
  String get sftpRenameTitle => 'Přejmenovat';

  @override
  String get sftpRenameLabel => 'Nový název';

  @override
  String get sftpSortByName => 'Název';

  @override
  String get sftpSortBySize => 'Velikost';

  @override
  String get sftpSortByDate => 'Datum';

  @override
  String get sftpSortByType => 'Typ';

  @override
  String get sftpShowHidden => 'Zobrazit skryté soubory';

  @override
  String get sftpHideHidden => 'Skrýt skryté soubory';

  @override
  String get sftpSelectAll => 'Vybrat vše';

  @override
  String get sftpDeselectAll => 'Zrušit výběr';

  @override
  String sftpItemsSelected(int count) {
    return '$count vybráno';
  }

  @override
  String get sftpRefresh => 'Obnovit';

  @override
  String sftpConnectionError(String message) {
    return 'Připojení se nezdařilo: $message';
  }

  @override
  String get sftpPermissionDenied => 'Přístup odepřen';

  @override
  String sftpOperationFailed(String message) {
    return 'Operace se nezdařila: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Soubor již existuje';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" již existuje. Přepsat?';
  }

  @override
  String get sftpOverwrite => 'Přepsat';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Přenos zahájen: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'Nejprve vyberte cíl v druhém panelu';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Přenos adresářů bude brzy k dispozici';

  @override
  String get sftpSelect => 'Vybrat';

  @override
  String get sftpOpen => 'Otevřít';

  @override
  String get sftpExtractArchive => 'Rozbalit zde';

  @override
  String get sftpExtractSuccess => 'Archiv rozbalen';

  @override
  String sftpExtractFailed(String message) {
    return 'Rozbalení se nezdařilo: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Nepodporovaný formát archivu';

  @override
  String get sftpExtracting => 'Rozbalování...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nahrávání zahájeno',
      one: 'Nahrávání zahájeno',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stahování zahájeno',
      one: 'Stahování zahájeno',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" staženo';
  }

  @override
  String get sftpSavedToDownloads => 'Uloženo do Stažené/SSHVault';

  @override
  String get sftpSaveToFiles => 'Uložit do Souborů';

  @override
  String get sftpFileSaved => 'Soubor uložen';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH relací aktivních',
      one: 'SSH relace aktivní',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Klepnutím otevřete terminál';

  @override
  String get settingsAccountAndSync => 'Účet a synchronizace';

  @override
  String get settingsAccountSubtitleAuth => 'Přihlášen';

  @override
  String get settingsAccountSubtitleUnauth => 'Nepřihlášen';

  @override
  String get settingsSecuritySubtitle => 'Automatický zámek, biometrie, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, uživatel root';

  @override
  String get settingsAppearanceSubtitle => 'Motiv, jazyk, terminál';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Výchozí nastavení šifrovaného exportu';

  @override
  String get settingsAboutSubtitle => 'Verze, licence';

  @override
  String get settingsSearchHint => 'Hledat v nastavení...';

  @override
  String get settingsSearchNoResults => 'Žádná nastavení nenalezena';

  @override
  String get aboutDeveloper => 'Vyvinuto společností Kiefer Networks';

  @override
  String get aboutDonate => 'Přispět';

  @override
  String get aboutOpenSourceLicenses => 'Open source licence';

  @override
  String get aboutWebsite => 'Webové stránky';

  @override
  String get aboutVersion => 'Verze';

  @override
  String get aboutBuild => 'Sestavení';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS šifruje DNS dotazy a brání DNS spoofingu. SSHVault kontroluje hostitelská jména u více poskytovatelů pro detekci útoků.';

  @override
  String get settingsDnsAddServer => 'Přidat DNS server';

  @override
  String get settingsDnsServerUrl => 'URL serveru';

  @override
  String get settingsDnsDefaultBadge => 'Výchozí';

  @override
  String get settingsDnsResetDefaults => 'Obnovit výchozí hodnoty';

  @override
  String get settingsDnsInvalidUrl => 'Zadejte prosím platnou HTTPS URL';

  @override
  String get settingsDefaultAuthMethod => 'Metoda ověření';

  @override
  String get settingsAuthPassword => 'Heslo';

  @override
  String get settingsAuthKey => 'SSH klíč';

  @override
  String get settingsConnectionTimeout => 'Časový limit připojení';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsKeepaliveInterval => 'Interval keep-alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsCompression => 'Komprese';

  @override
  String get settingsCompressionDescription =>
      'Povolit zlib kompresi pro SSH připojení';

  @override
  String get settingsTerminalType => 'Typ terminálu';

  @override
  String get settingsSectionConnection => 'Připojení';

  @override
  String get settingsClipboardAutoClear => 'Automatické vymazání schránky';

  @override
  String get settingsClipboardAutoClearOff => 'Vyp.';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsSessionTimeout => 'Časový limit relace';

  @override
  String get settingsSessionTimeoutOff => 'Vyp.';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'Nouzový PIN';

  @override
  String get settingsDuressPinDescription =>
      'Samostatný PIN, který při zadání vymaže všechna data';

  @override
  String get settingsDuressPinSet => 'Nouzový PIN je nastaven';

  @override
  String get settingsDuressPinNotSet => 'Nenakonfigurováno';

  @override
  String get settingsDuressPinWarning =>
      'Zadání tohoto PIN kódu trvale smaže všechna lokální data včetně přihlašovacích údajů, klíčů a nastavení. Tuto akci nelze vrátit.';

  @override
  String get settingsKeyRotationReminder => 'Připomínka rotace klíčů';

  @override
  String get settingsKeyRotationOff => 'Vyp.';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days dní';
  }

  @override
  String get settingsFailedAttempts => 'Neúspěšné pokusy o PIN';

  @override
  String get settingsSectionAppLock => 'Zámek aplikace';

  @override
  String get settingsSectionPrivacy => 'Soukromí';

  @override
  String get settingsSectionReminders => 'Připomínky';

  @override
  String get settingsSectionStatus => 'Stav';

  @override
  String get settingsExportBackupSubtitle => 'Export, import a záloha';

  @override
  String get settingsExportJson => 'Exportovat jako JSON';

  @override
  String get settingsExportEncrypted => 'Exportovat šifrovaně';

  @override
  String get settingsImportFile => 'Importovat ze souboru';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Filtrovat servery';

  @override
  String get filterApply => 'Použít filtry';

  @override
  String get filterClearAll => 'Vymazat vše';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktivních filtrů',
      one: '1 aktivní filtr',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Složka';

  @override
  String get filterTags => 'Štítky';

  @override
  String get filterStatus => 'Stav';

  @override
  String get variablePreviewResolved => 'Rozpoznaný náhled';

  @override
  String get variableInsert => 'Vložit';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serverů',
      one: '1 server',
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
      other: '$count relací zrušeno.',
      one: '1 relace zrušena.',
    );
    return '$_temp0 Byli jste odhlášeni.';
  }

  @override
  String get keyGenPassphrase => 'Heslo';

  @override
  String get keyGenPassphraseHint => 'Volitelné — chrání soukromý klíč';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Výchozí (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Klíč se stejným otiskem již existuje: \"$name\". Každý SSH klíč musí být jedinečný.';
  }

  @override
  String get sshKeyFingerprint => 'Otisk';

  @override
  String get sshKeyPublicKey => 'Veřejný klíč';

  @override
  String get jumpHost => 'Jump Host';

  @override
  String get jumpHostNone => 'Žádný';

  @override
  String get jumpHostLabel => 'Připojit přes jump host';

  @override
  String get jumpHostSelfError => 'Server nemůže být sám sobě jump hostem';

  @override
  String get jumpHostConnecting => 'Připojování k jump hostu…';

  @override
  String get jumpHostCircularError => 'Zjištěn kruhový řetězec jump hostů';

  @override
  String get logoutDialogTitle => 'Odhlásit';

  @override
  String get logoutDialogMessage =>
      'Chcete smazat všechna lokální data? Servery, SSH klíče, úryvky a nastavení budou z tohoto zařízení odstraněny.';

  @override
  String get logoutOnly => 'Pouze odhlásit';

  @override
  String get logoutAndDelete => 'Odhlásit a smazat data';

  @override
  String get changeAvatar => 'Změnit avatar';

  @override
  String get removeAvatar => 'Odstranit avatar';

  @override
  String get avatarUploadFailed => 'Nahrání avataru se nezdařilo';

  @override
  String get avatarTooLarge => 'Obrázek je příliš velký';

  @override
  String get deviceLastSeen => 'Naposledy viděn';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'URL serveru nelze změnit při přihlášení. Nejprve se odhlaste.';

  @override
  String get serverListNoFolder => 'Nekategorizované';

  @override
  String get autoSyncInterval => 'Interval synchronizace';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Nastavení proxy';

  @override
  String get proxyType => 'Typ proxy';

  @override
  String get proxyNone => 'Bez proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxy hostitel';

  @override
  String get proxyPort => 'Proxy port';

  @override
  String get proxyUsername => 'Proxy uživatelské jméno';

  @override
  String get proxyPassword => 'Proxy heslo';

  @override
  String get proxyUseGlobal => 'Použít globální proxy';

  @override
  String get proxyGlobal => 'Globální';

  @override
  String get proxyServerSpecific => 'Specifické pro server';

  @override
  String get proxyTestConnection => 'Otestovat připojení';

  @override
  String get proxyTestSuccess => 'Proxy dostupná';

  @override
  String get proxyTestFailed => 'Proxy nedostupná';

  @override
  String get proxyDefaultProxy => 'Výchozí proxy';

  @override
  String get vpnRequired => 'VPN vyžadováno';

  @override
  String get vpnRequiredTooltip =>
      'Zobrazit varování při připojení bez aktivní VPN';

  @override
  String get vpnActive => 'VPN aktivní';

  @override
  String get vpnInactive => 'VPN neaktivní';

  @override
  String get vpnWarningTitle => 'VPN není aktivní';

  @override
  String get vpnWarningMessage =>
      'Tento server vyžaduje VPN připojení, ale žádná VPN není aktuálně aktivní. Chcete se přesto připojit?';

  @override
  String get vpnConnectAnyway => 'Přesto připojit';

  @override
  String get postConnectCommands => 'Příkazy po připojení';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Příkazy automaticky provedené po připojení (jeden na řádek)';

  @override
  String get dashboardFavorites => 'Oblíbené';

  @override
  String get dashboardRecent => 'Nedávné';

  @override
  String get dashboardActiveSessions => 'Aktivní relace';

  @override
  String get addToFavorites => 'Přidat do oblíbených';

  @override
  String get removeFromFavorites => 'Odebrat z oblíbených';

  @override
  String get noRecentConnections => 'Žádná nedávná připojení';

  @override
  String get terminalSplit => 'Rozdělit zobrazení';

  @override
  String get terminalUnsplit => 'Zavřít rozdělení';

  @override
  String get terminalSelectSession => 'Vyberte relaci pro rozdělené zobrazení';

  @override
  String get knownHostsTitle => 'Známí hostitelé';

  @override
  String get knownHostsSubtitle => 'Spravujte důvěryhodné otisky serverů';

  @override
  String get hostKeyNewTitle => 'Nový hostitel';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'První připojení k $hostname:$port. Ověřte otisk před připojením.';
  }

  @override
  String get hostKeyChangedTitle => 'Klíč hostitele se změnil!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Klíč hostitele pro $hostname:$port se změnil. To může znamenat bezpečnostní hrozbu.';
  }

  @override
  String get hostKeyFingerprint => 'Otisk';

  @override
  String get hostKeyType => 'Typ klíče';

  @override
  String get hostKeyTrustConnect => 'Důvěřovat a připojit';

  @override
  String get hostKeyAcceptNew => 'Přijmout nový klíč';

  @override
  String get hostKeyReject => 'Odmítnout';

  @override
  String get hostKeyPreviousFingerprint => 'Předchozí otisk';

  @override
  String get hostKeyDeleteAll => 'Smazat všechny známé hostitele';

  @override
  String get hostKeyDeleteConfirm =>
      'Opravdu chcete odstranit všechny známé hostitele? Při příštím připojení budete znovu vyzváni.';

  @override
  String get hostKeyEmpty => 'Zatím žádní známí hostitelé';

  @override
  String get hostKeyEmptySubtitle =>
      'Otisky hostitelů budou uloženy zde po vašem prvním připojení';

  @override
  String get hostKeyFirstSeen => 'Poprvé viděn';

  @override
  String get hostKeyLastSeen => 'Naposledy viděn';

  @override
  String get sshConfigImportTitle => 'Import SSH konfigurace';

  @override
  String get sshConfigImportPickFile => 'Vybrat soubor SSH konfigurace';

  @override
  String get sshConfigImportOrPaste => 'Nebo vložte obsah konfigurace';

  @override
  String sshConfigImportParsed(int count) {
    return 'Nalezeno $count hostitelů';
  }

  @override
  String get sshConfigImportButton => 'Importovat vybrané';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count serverů importováno';
  }

  @override
  String get sshConfigImportDuplicate => 'Již existuje';

  @override
  String get sshConfigImportNoHosts =>
      'V konfiguraci nebyli nalezeni žádní hostitelé';

  @override
  String get sftpBookmarkAdd => 'Přidat záložku';

  @override
  String get sftpBookmarkLabel => 'Popis';

  @override
  String get disconnect => 'Odpojit';

  @override
  String get reportAndDisconnect => 'Nahlásit a odpojit';

  @override
  String get continueAnyway => 'Přesto pokračovat';

  @override
  String get insertSnippet => 'Vložit úryvek';

  @override
  String get seconds => 'Sekundy';

  @override
  String get heartbeatLostMessage =>
      'Server nebyl dostupný po několika pokusech. Pro vaši bezpečnost byla relace ukončena.';

  @override
  String get attestationFailedTitle => 'Ověření serveru selhalo';

  @override
  String get attestationFailedMessage =>
      'Server nemohl být ověřen jako legitimní SSHVault backend. To může znamenat útok typu man-in-the-middle nebo nesprávně nakonfigurovaný server.';

  @override
  String get attestationKeyChangedTitle => 'Klíč serveru se změnil';

  @override
  String get attestationKeyChangedMessage =>
      'Ověřovací klíč serveru se od počátečního připojení změnil. To může znamenat útok typu man-in-the-middle. NEPOKRAČUJTE, pokud správce serveru nepotvrdil rotaci klíče.';

  @override
  String get sectionLinks => 'Odkazy';

  @override
  String get sectionDeveloper => 'Vývojář';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Stránka nenalezena';

  @override
  String get connectionTestSuccess => 'Připojení úspěšné';

  @override
  String connectionTestFailed(String message) {
    return 'Připojení se nezdařilo: $message';
  }

  @override
  String get serverVerificationFailed => 'Ověření serveru selhalo';

  @override
  String get importSuccessful => 'Import úspěšný';

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
  String get deviceDeleteConfirmTitle => 'Odebrat zařízení';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Opravdu chcete odebrat \"$name\"? Zařízení bude okamžitě odhlášeno.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Toto je vaše aktuální zařízení. Budete okamžitě odhlášeni.';

  @override
  String get deviceDeleteSuccess => 'Zařízení odebráno';

  @override
  String get deviceDeletedCurrentLogout =>
      'Aktuální zařízení odebráno. Byli jste odhlášeni.';

  @override
  String get thisDevice => 'Toto zařízení';
}
