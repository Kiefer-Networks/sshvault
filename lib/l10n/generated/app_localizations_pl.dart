// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Hosty';

  @override
  String get navSnippets => 'Snippety';

  @override
  String get navFolders => 'Foldery';

  @override
  String get navTags => 'Tagi';

  @override
  String get navSshKeys => 'Klucze SSH';

  @override
  String get navExportImport => 'Eksport / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Więcej';

  @override
  String get navManagement => 'Zarządzanie';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String get navAbout => 'O aplikacji';

  @override
  String get lockScreenTitle => 'SSHVault jest zablokowany';

  @override
  String get lockScreenUnlock => 'Odblokuj';

  @override
  String get lockScreenEnterPin => 'Wprowadź PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Zbyt wiele nieudanych prób. Spróbuj ponownie za $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Ustaw kod PIN';

  @override
  String get pinDialogSetSubtitle =>
      'Wprowadź 6-cyfrowy PIN, aby chronić SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Potwierdź PIN';

  @override
  String get pinDialogErrorLength => 'PIN musi składać się z dokładnie 6 cyfr';

  @override
  String get pinDialogErrorMismatch => 'Kody PIN nie pasują do siebie';

  @override
  String get pinDialogVerifyTitle => 'Wprowadź PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Błędny PIN. Pozostało prób: $attempts.';
  }

  @override
  String get securityBannerMessage =>
      'Twoje dane logowania SSH nie są chronione. Ustaw PIN lub blokadę biometryczną w ustawieniach.';

  @override
  String get securityBannerDismiss => 'Ukryj';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get settingsSectionAppearance => 'Wygląd';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'Domyślne ustawienia SSH';

  @override
  String get settingsSectionSecurity => 'Bezpieczeństwo';

  @override
  String get settingsSectionExport => 'Eksport';

  @override
  String get settingsSectionAbout => 'O aplikacji';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get settingsThemeSystem => 'Systemowy';

  @override
  String get settingsThemeLight => 'Jasny';

  @override
  String get settingsThemeDark => 'Ciemny';

  @override
  String get settingsTerminalTheme => 'Motyw terminala';

  @override
  String get settingsTerminalThemeDefault => 'Domyślny ciemny';

  @override
  String get settingsFontSize => 'Rozmiar czcionki';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Domyślny port';

  @override
  String get settingsDefaultPortDialog => 'Domyślny port SSH';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Domyślna nazwa użytkownika';

  @override
  String get settingsDefaultUsernameDialog => 'Domyślna nazwa użytkownika';

  @override
  String get settingsUsernameLabel => 'Nazwa użytkownika';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automatyczna blokada';

  @override
  String get settingsAutoLockDisabled => 'Wyłączona';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minut';
  }

  @override
  String get settingsAutoLockOff => 'Wył.';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Odblokowanie biometryczne';

  @override
  String get settingsBiometricNotAvailable => 'Niedostępne na tym urządzeniu';

  @override
  String get settingsBiometricError => 'Błąd sprawdzania biometrii';

  @override
  String get settingsBiometricReason =>
      'Potwierdź tożsamość, aby włączyć odblokowanie biometryczne';

  @override
  String get settingsBiometricRequiresPin =>
      'Najpierw ustaw PIN, aby włączyć odblokowanie biometryczne';

  @override
  String get settingsPinCode => 'Kod PIN';

  @override
  String get settingsPinIsSet => 'PIN jest ustawiony';

  @override
  String get settingsPinNotConfigured => 'PIN nie jest skonfigurowany';

  @override
  String get settingsPinRemove => 'Usuń';

  @override
  String get settingsPinRemoveWarning =>
      'Usunięcie PIN odszyfruje wszystkie pola bazy danych i wyłączy odblokowanie biometryczne. Kontynuować?';

  @override
  String get settingsPinRemoveTitle => 'Usuń PIN';

  @override
  String get settingsPreventScreenshots => 'Blokada zrzutów ekranu';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Blokuj zrzuty ekranu i nagrywanie ekranu';

  @override
  String get settingsEncryptExport => 'Domyślnie szyfruj eksport';

  @override
  String get settingsAbout => 'O SSHVault';

  @override
  String get settingsAboutLegalese => 'od Kiefer Networks';

  @override
  String get settingsAboutDescription =>
      'Bezpieczny klient SSH z własnym serwerem';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsLanguageSystem => 'Systemowy';

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
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get delete => 'Usuń';

  @override
  String get close => 'Zamknij';

  @override
  String get update => 'Aktualizuj';

  @override
  String get create => 'Utwórz';

  @override
  String get retry => 'Ponów';

  @override
  String get copy => 'Kopiuj';

  @override
  String get edit => 'Edytuj';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Błąd: $message';
  }

  @override
  String get serverListTitle => 'Hosty';

  @override
  String get serverListEmpty => 'Brak serwerów';

  @override
  String get serverListEmptySubtitle =>
      'Dodaj pierwszy serwer SSH, aby rozpocząć.';

  @override
  String get serverAddButton => 'Dodaj serwer';

  @override
  String sshConfigImportMessage(int count) {
    return 'Znaleziono $count host(ów) w ~/.ssh/config. Zaimportować?';
  }

  @override
  String get sshConfigNotFound => 'Nie znaleziono pliku SSH config';

  @override
  String get sshConfigEmpty => 'Nie znaleziono hostów w SSH config';

  @override
  String get sshConfigAddManually => 'Dodaj ręcznie';

  @override
  String get sshConfigImportAgain => 'Zaimportować SSH Config ponownie?';

  @override
  String get sshConfigImportKeys =>
      'Zaimportować klucze SSH powiązane z wybranymi hostami?';

  @override
  String sshConfigKeysImported(int count) {
    return 'Zaimportowano $count klucz(y) SSH';
  }

  @override
  String get serverDuplicated => 'Serwer zduplikowany';

  @override
  String get serverDeleteTitle => 'Usuń serwer';

  @override
  String serverDeleteMessage(String name) {
    return 'Czy na pewno chcesz usunąć \"$name\"? Tej operacji nie można cofnąć.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Usunąć \"$name\"?';
  }

  @override
  String get serverConnect => 'Połącz';

  @override
  String get serverDetails => 'Szczegóły';

  @override
  String get serverDuplicate => 'Duplikuj';

  @override
  String get serverActive => 'Aktywny';

  @override
  String get serverNoFolder => 'Bez folderu';

  @override
  String get serverFormTitleEdit => 'Edytuj serwer';

  @override
  String get serverFormTitleAdd => 'Dodaj serwer';

  @override
  String get serverSaved => 'Serwer zapisany';

  @override
  String get serverFormUpdateButton => 'Aktualizuj serwer';

  @override
  String get serverFormAddButton => 'Dodaj serwer';

  @override
  String get serverFormPublicKeyExtracted =>
      'Klucz publiczny wyodrębniony pomyślnie';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Nie udało się wyodrębnić klucza publicznego: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Para kluczy $type wygenerowana';
  }

  @override
  String get serverDetailTitle => 'Szczegóły serwera';

  @override
  String get serverDetailDeleteMessage => 'Tej operacji nie można cofnąć.';

  @override
  String get serverDetailConnection => 'Połączenie';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Nazwa użytkownika';

  @override
  String get serverDetailFolder => 'Folder';

  @override
  String get serverDetailTags => 'Tagi';

  @override
  String get serverDetailNotes => 'Notatki';

  @override
  String get serverDetailInfo => 'Informacje';

  @override
  String get serverDetailCreated => 'Utworzono';

  @override
  String get serverDetailUpdated => 'Zaktualizowano';

  @override
  String get serverDetailDistro => 'System';

  @override
  String get copiedToClipboard => 'Skopiowano do schowka';

  @override
  String get serverFormNameLabel => 'Nazwa serwera';

  @override
  String get serverFormHostnameLabel => 'Nazwa hosta / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Nazwa użytkownika';

  @override
  String get serverFormPasswordLabel => 'Hasło';

  @override
  String get serverFormUseManagedKey => 'Użyj zarządzanego klucza';

  @override
  String get serverFormManagedKeySubtitle =>
      'Wybierz z centralnie zarządzanych kluczy SSH';

  @override
  String get serverFormDirectKeySubtitle =>
      'Wklej klucz bezpośrednio do tego serwera';

  @override
  String get serverFormGenerateKey => 'Wygeneruj parę kluczy SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Klucz prywatny';

  @override
  String get serverFormPrivateKeyHint => 'Wklej prywatny klucz SSH...';

  @override
  String get serverFormExtractPublicKey => 'Wyodrębnij klucz publiczny';

  @override
  String get serverFormPublicKeyLabel => 'Klucz publiczny';

  @override
  String get serverFormPublicKeyHint =>
      'Generowany automatycznie z klucza prywatnego, jeśli pusty';

  @override
  String get serverFormPassphraseLabel => 'Hasło klucza (opcjonalnie)';

  @override
  String get serverFormNotesLabel => 'Notatki (opcjonalnie)';

  @override
  String get searchServers => 'Szukaj serwerów...';

  @override
  String get filterAllFolders => 'Wszystkie foldery';

  @override
  String get filterAll => 'Wszystkie';

  @override
  String get filterActive => 'Aktywne';

  @override
  String get filterInactive => 'Nieaktywne';

  @override
  String get filterClear => 'Wyczyść';

  @override
  String get folderListTitle => 'Foldery';

  @override
  String get folderListEmpty => 'Brak folderów';

  @override
  String get folderListEmptySubtitle =>
      'Utwórz foldery, aby uporządkować serwery.';

  @override
  String get folderAddButton => 'Dodaj folder';

  @override
  String get folderDeleteTitle => 'Usuń folder';

  @override
  String folderDeleteMessage(String name) {
    return 'Usunąć \"$name\"? Serwery staną się nieskategoryzowane.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serwerów',
      one: '1 serwer',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Zwiń';

  @override
  String get folderShowHosts => 'Pokaż hosty';

  @override
  String get folderConnectAll => 'Połącz wszystkie';

  @override
  String get folderFormTitleEdit => 'Edytuj folder';

  @override
  String get folderFormTitleNew => 'Nowy folder';

  @override
  String get folderFormNameLabel => 'Nazwa folderu';

  @override
  String get folderFormParentLabel => 'Folder nadrzędny';

  @override
  String get folderFormParentNone => 'Brak (Katalog główny)';

  @override
  String get tagListTitle => 'Tagi';

  @override
  String get tagListEmpty => 'Brak tagów';

  @override
  String get tagListEmptySubtitle =>
      'Utwórz tagi, aby oznaczać i filtrować serwery.';

  @override
  String get tagAddButton => 'Dodaj tag';

  @override
  String get tagDeleteTitle => 'Usuń tag';

  @override
  String tagDeleteMessage(String name) {
    return 'Usunąć \"$name\"? Zostanie usunięty ze wszystkich serwerów.';
  }

  @override
  String get tagFormTitleEdit => 'Edytuj tag';

  @override
  String get tagFormTitleNew => 'Nowy tag';

  @override
  String get tagFormNameLabel => 'Nazwa tagu';

  @override
  String get sshKeyListTitle => 'Klucze SSH';

  @override
  String get sshKeyListEmpty => 'Brak kluczy SSH';

  @override
  String get sshKeyListEmptySubtitle =>
      'Wygeneruj lub zaimportuj klucze SSH do centralnego zarządzania';

  @override
  String get sshKeyCannotDeleteTitle => 'Nie można usunąć';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Nie można usunąć \"$name\". Używany przez $count serwer(ów). Najpierw odłącz od wszystkich serwerów.';
  }

  @override
  String get sshKeyDeleteTitle => 'Usuń klucz SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Usunąć \"$name\"? Tej operacji nie można cofnąć.';
  }

  @override
  String get sshKeyAddButton => 'Dodaj klucz SSH';

  @override
  String get sshKeyFormTitleEdit => 'Edytuj klucz SSH';

  @override
  String get sshKeyFormTitleAdd => 'Dodaj klucz SSH';

  @override
  String get sshKeyFormTabGenerate => 'Generuj';

  @override
  String get sshKeyFormTabImport => 'Importuj';

  @override
  String get sshKeyFormNameLabel => 'Nazwa klucza';

  @override
  String get sshKeyFormNameHint => 'np. Mój klucz produkcyjny';

  @override
  String get sshKeyFormKeyType => 'Typ klucza';

  @override
  String get sshKeyFormKeySize => 'Rozmiar klucza';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Komentarz';

  @override
  String get sshKeyFormCommentHint => 'user@host lub opis';

  @override
  String get sshKeyFormCommentOptional => 'Komentarz (opcjonalnie)';

  @override
  String get sshKeyFormImportFromFile => 'Importuj z pliku';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Klucz prywatny';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Wklej prywatny klucz SSH lub użyj przycisku powyżej...';

  @override
  String get sshKeyFormPassphraseLabel => 'Hasło (opcjonalnie)';

  @override
  String get sshKeyFormNameRequired => 'Nazwa jest wymagana';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Klucz prywatny jest wymagany';

  @override
  String get sshKeyFormFileReadError =>
      'Nie udało się odczytać wybranego pliku';

  @override
  String get sshKeyFormInvalidFormat =>
      'Nieprawidłowy format klucza — oczekiwano PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Nie udało się odczytać pliku: $message';
  }

  @override
  String get sshKeyFormSaving => 'Zapisywanie...';

  @override
  String get sshKeySelectorLabel => 'Klucz SSH';

  @override
  String get sshKeySelectorNone => 'Brak zarządzanego klucza';

  @override
  String get sshKeySelectorManage => 'Zarządzaj kluczami...';

  @override
  String get sshKeySelectorError => 'Nie udało się załadować kluczy SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Kopiuj klucz publiczny';

  @override
  String get sshKeyTilePublicKeyCopied => 'Klucz publiczny skopiowany';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Używany przez $count serwer(ów)';
  }

  @override
  String get sshKeySavedSuccess => 'Klucz SSH zapisany';

  @override
  String get sshKeyDeletedSuccess => 'Klucz SSH usunięty';

  @override
  String get tagSavedSuccess => 'Tag zapisany';

  @override
  String get tagDeletedSuccess => 'Tag usunięty';

  @override
  String get folderDeletedSuccess => 'Folder usunięty';

  @override
  String get sshKeyTileUnlinkFirst => 'Najpierw odłącz od wszystkich serwerów';

  @override
  String get exportImportTitle => 'Eksport / Import';

  @override
  String get exportSectionTitle => 'Eksport';

  @override
  String get exportJsonButton => 'Eksportuj jako JSON (bez danych logowania)';

  @override
  String get exportZipButton =>
      'Eksportuj zaszyfrowany ZIP (z danymi logowania)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Importuj z pliku';

  @override
  String get importSupportedFormats =>
      'Obsługiwane pliki JSON (otwarte) i ZIP (zaszyfrowane).';

  @override
  String exportedTo(String path) {
    return 'Wyeksportowano do: $path';
  }

  @override
  String get share => 'Udostępnij';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Zaimportowano: $servers serwerów, $groups grup, $tags tagów. $skipped pominięto.';
  }

  @override
  String get importPasswordTitle => 'Wprowadź hasło';

  @override
  String get importPasswordLabel => 'Hasło eksportu';

  @override
  String get importPasswordDecrypt => 'Odszyfruj';

  @override
  String get exportPasswordTitle => 'Ustaw hasło eksportu';

  @override
  String get exportPasswordDescription =>
      'To hasło zostanie użyte do zaszyfrowania pliku eksportu, w tym danych logowania.';

  @override
  String get exportPasswordLabel => 'Hasło';

  @override
  String get exportPasswordConfirmLabel => 'Potwierdź hasło';

  @override
  String get exportPasswordMismatch => 'Hasła nie pasują do siebie';

  @override
  String get exportPasswordButton => 'Zaszyfruj i eksportuj';

  @override
  String get importConflictTitle => 'Obsługa konfliktów';

  @override
  String get importConflictDescription =>
      'Jak postąpić z istniejącymi wpisami podczas importu?';

  @override
  String get importConflictSkip => 'Pomiń istniejące';

  @override
  String get importConflictRename => 'Zmień nazwy nowych';

  @override
  String get importConflictOverwrite => 'Nadpisz';

  @override
  String get confirmDeleteLabel => 'Usuń';

  @override
  String get keyGenTitle => 'Generowanie pary kluczy SSH';

  @override
  String get keyGenKeyType => 'Typ klucza';

  @override
  String get keyGenKeySize => 'Rozmiar klucza';

  @override
  String get keyGenComment => 'Komentarz';

  @override
  String get keyGenCommentHint => 'user@host lub opis';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Generowanie...';

  @override
  String get keyGenGenerate => 'Wygeneruj';

  @override
  String keyGenResultTitle(String type) {
    return 'Klucz $type wygenerowany';
  }

  @override
  String get keyGenPublicKey => 'Klucz publiczny';

  @override
  String get keyGenPrivateKey => 'Klucz prywatny';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Komentarz: $comment';
  }

  @override
  String get keyGenAnother => 'Wygeneruj kolejny';

  @override
  String get keyGenUseThisKey => 'Użyj tego klucza';

  @override
  String get keyGenCopyTooltip => 'Kopiuj do schowka';

  @override
  String keyGenCopied(String label) {
    return '$label skopiowano';
  }

  @override
  String get colorPickerLabel => 'Kolor';

  @override
  String get iconPickerLabel => 'Ikona';

  @override
  String get tagSelectorLabel => 'Tagi';

  @override
  String get tagSelectorEmpty => 'Brak tagów';

  @override
  String get tagSelectorError => 'Nie udało się załadować tagów';

  @override
  String get snippetListTitle => 'Snippety';

  @override
  String get snippetSearchHint => 'Szukaj snippetów...';

  @override
  String get snippetListEmpty => 'Brak snippetów';

  @override
  String get snippetListEmptySubtitle =>
      'Twórz wielokrotnego użytku fragmenty kodu i polecenia.';

  @override
  String get snippetAddButton => 'Dodaj snippet';

  @override
  String get snippetDeleteTitle => 'Usuń snippet';

  @override
  String snippetDeleteMessage(String name) {
    return 'Usunąć \"$name\"? Tej operacji nie można cofnąć.';
  }

  @override
  String get snippetFormTitleEdit => 'Edytuj snippet';

  @override
  String get snippetFormTitleNew => 'Nowy snippet';

  @override
  String get snippetFormNameLabel => 'Nazwa';

  @override
  String get snippetFormNameHint => 'np. Czyszczenie Docker';

  @override
  String get snippetFormLanguageLabel => 'Język';

  @override
  String get snippetFormContentLabel => 'Zawartość';

  @override
  String get snippetFormContentHint => 'Wprowadź kod snippetu...';

  @override
  String get snippetFormDescriptionLabel => 'Opis';

  @override
  String get snippetFormDescriptionHint => 'Opcjonalny opis...';

  @override
  String get snippetFormFolderLabel => 'Folder';

  @override
  String get snippetFormNoFolder => 'Bez folderu';

  @override
  String get snippetFormNameRequired => 'Nazwa jest wymagana';

  @override
  String get snippetFormContentRequired => 'Zawartość jest wymagana';

  @override
  String get snippetFormSaved => 'Snippet zapisany';

  @override
  String get snippetFormUpdateButton => 'Aktualizuj snippet';

  @override
  String get snippetFormCreateButton => 'Utwórz snippet';

  @override
  String get snippetDetailTitle => 'Szczegóły snippetu';

  @override
  String get snippetDetailDeleteTitle => 'Usuń snippet';

  @override
  String get snippetDetailDeleteMessage => 'Tej operacji nie można cofnąć.';

  @override
  String get snippetDetailContent => 'Zawartość';

  @override
  String get snippetDetailFillVariables => 'Wypełnij zmienne';

  @override
  String get snippetDetailDescription => 'Opis';

  @override
  String get snippetDetailVariables => 'Zmienne';

  @override
  String get snippetDetailTags => 'Tagi';

  @override
  String get snippetDetailInfo => 'Informacje';

  @override
  String get snippetDetailCreated => 'Utworzono';

  @override
  String get snippetDetailUpdated => 'Zaktualizowano';

  @override
  String get variableEditorTitle => 'Zmienne szablonu';

  @override
  String get variableEditorAdd => 'Dodaj';

  @override
  String get variableEditorEmpty =>
      'Brak zmiennych. Użyj nawiasów klamrowych w treści, aby się do nich odwoływać.';

  @override
  String get variableEditorNameLabel => 'Nazwa';

  @override
  String get variableEditorNameHint => 'np. hostname';

  @override
  String get variableEditorDefaultLabel => 'Domyślna';

  @override
  String get variableEditorDefaultHint => 'opcjonalnie';

  @override
  String get variableFillTitle => 'Wypełnij zmienne';

  @override
  String variableFillHint(String name) {
    return 'Wprowadź wartość dla $name';
  }

  @override
  String get variableFillPreview => 'Podgląd';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Brak aktywnych sesji';

  @override
  String get terminalEmptySubtitle =>
      'Połącz się z hostem, aby otworzyć sesję terminala.';

  @override
  String get terminalGoToHosts => 'Przejdź do hostów';

  @override
  String get terminalCloseAll => 'Zamknij wszystkie sesje';

  @override
  String get terminalCloseTitle => 'Zamknij sesję';

  @override
  String terminalCloseMessage(String title) {
    return 'Zamknąć aktywne połączenie z \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Uwierzytelnianie...';

  @override
  String connectionConnecting(String name) {
    return 'Łączenie z $name...';
  }

  @override
  String get connectionError => 'Błąd połączenia';

  @override
  String get connectionLost => 'Połączenie utracone';

  @override
  String get connectionReconnect => 'Połącz ponownie';

  @override
  String get snippetQuickPanelTitle => 'Wstaw snippet';

  @override
  String get snippetQuickPanelSearch => 'Szukaj snippetów...';

  @override
  String get snippetQuickPanelEmpty => 'Brak dostępnych snippetów';

  @override
  String get snippetQuickPanelNoMatch => 'Nie znaleziono pasujących snippetów';

  @override
  String get snippetQuickPanelInsertTooltip => 'Wstaw snippet';

  @override
  String get terminalThemePickerTitle => 'Motyw terminala';

  @override
  String get validatorHostnameRequired => 'Nazwa hosta jest wymagana';

  @override
  String get validatorHostnameInvalid =>
      'Nieprawidłowa nazwa hosta lub adres IP';

  @override
  String get validatorPortRequired => 'Port jest wymagany';

  @override
  String get validatorPortRange => 'Port musi być w zakresie od 1 do 65535';

  @override
  String get validatorUsernameRequired => 'Nazwa użytkownika jest wymagana';

  @override
  String get validatorUsernameInvalid =>
      'Nieprawidłowy format nazwy użytkownika';

  @override
  String get validatorServerNameRequired => 'Nazwa serwera jest wymagana';

  @override
  String get validatorServerNameLength =>
      'Nazwa serwera musi mieć maksymalnie 100 znaków';

  @override
  String get validatorSshKeyInvalid => 'Nieprawidłowy format klucza SSH';

  @override
  String get validatorPasswordRequired => 'Hasło jest wymagane';

  @override
  String get validatorPasswordLength => 'Hasło musi mieć co najmniej 8 znaków';

  @override
  String get authMethodPassword => 'Hasło';

  @override
  String get authMethodKey => 'Klucz SSH';

  @override
  String get authMethodBoth => 'Hasło + Klucz';

  @override
  String get serverCopySuffix => '(Kopia)';

  @override
  String get settingsDownloadLogs => 'Pobierz logi';

  @override
  String get settingsSendLogs => 'Wyślij logi do wsparcia';

  @override
  String get settingsLogsSaved => 'Logi zapisane pomyślnie';

  @override
  String get settingsUpdated => 'Ustawienie zaktualizowane';

  @override
  String get settingsThemeChanged => 'Motyw zmieniony';

  @override
  String get settingsLanguageChanged => 'Język zmieniony';

  @override
  String get settingsPinSetSuccess => 'PIN ustawiony';

  @override
  String get settingsPinRemovedSuccess => 'PIN usunięty';

  @override
  String get settingsDuressPinSetSuccess => 'PIN przymusu ustawiony';

  @override
  String get settingsDuressPinRemovedSuccess => 'PIN przymusu usunięty';

  @override
  String get settingsBiometricEnabled => 'Biometria włączona';

  @override
  String get settingsBiometricDisabled => 'Biometria wyłączona';

  @override
  String get settingsDnsServerAdded => 'Serwer DNS dodany';

  @override
  String get settingsDnsServerRemoved => 'Serwer DNS usunięty';

  @override
  String get settingsDnsResetSuccess => 'Serwery DNS zresetowane';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Zmniejsz czcionkę';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Zwiększ czcionkę';

  @override
  String get settingsDnsRemoveServerTooltip => 'Usuń serwer DNS';

  @override
  String get settingsLogsEmpty => 'Brak dostępnych wpisów logów';

  @override
  String get authLogin => 'Zaloguj się';

  @override
  String get authRegister => 'Rejestracja';

  @override
  String get authForgotPassword => 'Zapomniałeś hasła?';

  @override
  String get authWhyLogin =>
      'Zaloguj się, aby włączyć zaszyfrowaną synchronizację w chmurze na wszystkich urządzeniach. Aplikacja działa w pełni offline bez konta.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'Email jest wymagany';

  @override
  String get authEmailInvalid => 'Nieprawidłowy adres e-mail';

  @override
  String get authPasswordLabel => 'Hasło';

  @override
  String get authConfirmPasswordLabel => 'Potwierdź hasło';

  @override
  String get authPasswordMismatch => 'Hasła nie pasują do siebie';

  @override
  String get authNoAccount => 'Nie masz konta?';

  @override
  String get authHasAccount => 'Masz już konto?';

  @override
  String get authResetEmailSent =>
      'Jeśli konto istnieje, link do resetowania został wysłany na Twój adres e-mail.';

  @override
  String get authResetDescription =>
      'Wprowadź swój adres e-mail, a wyślemy Ci link do resetowania hasła.';

  @override
  String get authSendResetLink => 'Wyślij link resetujący';

  @override
  String get authBackToLogin => 'Powrót do logowania';

  @override
  String get syncPasswordTitle => 'Hasło synchronizacji';

  @override
  String get syncPasswordTitleCreate => 'Ustaw hasło synchronizacji';

  @override
  String get syncPasswordTitleEnter => 'Wprowadź hasło synchronizacji';

  @override
  String get syncPasswordDescription =>
      'Ustaw oddzielne hasło do szyfrowania danych sejfu. To hasło nigdy nie opuszcza Twojego urządzenia — serwer przechowuje tylko zaszyfrowane dane.';

  @override
  String get syncPasswordHintEnter =>
      'Wprowadź hasło ustawione podczas tworzenia konta.';

  @override
  String get syncPasswordWarning =>
      'Jeśli zapomnisz tego hasła, zsynchronizowanych danych nie będzie można odzyskać. Nie ma opcji resetowania.';

  @override
  String get syncPasswordLabel => 'Hasło synchronizacji';

  @override
  String get syncPasswordWrong => 'Błędne hasło. Spróbuj ponownie.';

  @override
  String get firstSyncTitle => 'Znaleziono istniejące dane';

  @override
  String get firstSyncMessage =>
      'Na tym urządzeniu są dane, a na serwerze jest sejf. Jak kontynuować?';

  @override
  String get firstSyncMerge => 'Scal (priorytet serwera)';

  @override
  String get firstSyncOverwriteLocal => 'Nadpisz dane lokalne';

  @override
  String get firstSyncKeepLocal => 'Zachowaj lokalne i wyślij';

  @override
  String get firstSyncDeleteLocal => 'Usuń lokalne i pobierz';

  @override
  String get changeEncryptionPassword => 'Zmień hasło szyfrowania';

  @override
  String get changeEncryptionWarning =>
      'Zostaniesz wylogowany na wszystkich innych urządzeniach.';

  @override
  String get changeEncryptionOldPassword => 'Obecne hasło';

  @override
  String get changeEncryptionNewPassword => 'Nowe hasło';

  @override
  String get changeEncryptionSuccess => 'Hasło zmienione pomyślnie.';

  @override
  String get logoutAllDevices => 'Wyloguj ze wszystkich urządzeń';

  @override
  String get logoutAllDevicesConfirm =>
      'Wszystkie aktywne sesje zostaną unieważnione. Będziesz musiał zalogować się ponownie na wszystkich urządzeniach.';

  @override
  String get logoutAllDevicesSuccess => 'Wylogowano ze wszystkich urządzeń.';

  @override
  String get syncSettingsTitle => 'Ustawienia synchronizacji';

  @override
  String get syncAutoSync => 'Autosynchronizacja';

  @override
  String get syncAutoSyncDescription =>
      'Automatyczna synchronizacja przy uruchomieniu aplikacji';

  @override
  String get syncNow => 'Synchronizuj teraz';

  @override
  String get syncSyncing => 'Synchronizacja...';

  @override
  String get syncSuccess => 'Synchronizacja zakończona';

  @override
  String get syncError => 'Błąd synchronizacji';

  @override
  String get syncServerUnreachable => 'Serwer nieosiągalny';

  @override
  String get syncServerUnreachableHint =>
      'Serwer synchronizacji jest nieosiągalny. Sprawdź połączenie internetowe i adres URL serwera.';

  @override
  String get syncNetworkError =>
      'Połączenie z serwerem nie powiodło się. Sprawdź połączenie internetowe lub spróbuj później.';

  @override
  String get syncNeverSynced => 'Nigdy nie synchronizowano';

  @override
  String get syncVaultVersion => 'Wersja sejfu';

  @override
  String get syncBackgroundSync => 'Synchronizuj w tle';

  @override
  String get syncBackgroundSyncDescription =>
      'Okresowa synchronizacja sejfu przez WorkManager nawet przy zamkniętej aplikacji.';

  @override
  String get syncTitle => 'Synchronizacja';

  @override
  String get settingsSectionNetwork => 'Sieć i DNS';

  @override
  String get settingsDnsServers => 'Serwery DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Domyślne (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Wprowadź własne adresy URL serwerów DoH, oddzielone przecinkami. Do weryfikacji krzyżowej potrzebne są co najmniej 2 serwery.';

  @override
  String get settingsDnsLabel => 'Adresy URL serwerów DoH';

  @override
  String get settingsDnsReset => 'Przywróć domyślne';

  @override
  String get settingsSectionSync => 'Synchronizacja';

  @override
  String get settingsSyncAccount => 'Konto';

  @override
  String get settingsSyncNotLoggedIn => 'Niezalogowany';

  @override
  String get settingsSyncStatus => 'Synchronizacja';

  @override
  String get settingsSyncServerUrl => 'Adres URL serwera';

  @override
  String get settingsSyncDefaultServer => 'Domyślny (sshvault.app)';

  @override
  String get accountTitle => 'Konto';

  @override
  String get accountNotLoggedIn => 'Niezalogowany';

  @override
  String get accountVerified => 'Zweryfikowany';

  @override
  String get accountMemberSince => 'Członek od';

  @override
  String get accountDevices => 'Urządzenia';

  @override
  String get accountNoDevices => 'Brak zarejestrowanych urządzeń';

  @override
  String get accountLastSync => 'Ostatnia synchronizacja';

  @override
  String get accountChangePassword => 'Zmień hasło';

  @override
  String get accountOldPassword => 'Obecne hasło';

  @override
  String get accountNewPassword => 'Nowe hasło';

  @override
  String get accountDeleteAccount => 'Usuń konto';

  @override
  String get accountDeleteWarning =>
      'To trwale usunie Twoje konto i wszystkie zsynchronizowane dane. Tej operacji nie można cofnąć.';

  @override
  String get accountLogout => 'Wyloguj się';

  @override
  String get serverConfigTitle => 'Konfiguracja serwera';

  @override
  String get serverConfigUrlLabel => 'Adres URL serwera';

  @override
  String get serverConfigTest => 'Testuj połączenie';

  @override
  String get serverSetupTitle => 'Konfiguracja serwera';

  @override
  String get serverSetupInfoCard =>
      'ShellVault wymaga własnego serwera do szyfrowanej synchronizacji end-to-end. Wdróż własną instancję, aby rozpocząć.';

  @override
  String get serverSetupRepoLink => 'Zobacz na GitHub';

  @override
  String get serverSetupContinue => 'Kontynuuj';

  @override
  String get settingsServerNotConfigured => 'Nie skonfigurowano serwera';

  @override
  String get settingsSetupSync =>
      'Skonfiguruj synchronizację, aby utworzyć kopię zapasową danych';

  @override
  String get settingsChangeServer => 'Zmień serwer';

  @override
  String get settingsChangeServerConfirm =>
      'Zmiana serwera spowoduje wylogowanie. Kontynuować?';

  @override
  String get auditLogTitle => 'Dziennik aktywności';

  @override
  String get auditLogAll => 'Wszystkie';

  @override
  String get auditLogEmpty => 'Nie znaleziono wpisów w dzienniku';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Menedżer plików';

  @override
  String get sftpLocalDevice => 'Urządzenie lokalne';

  @override
  String get sftpSelectServer => 'Wybierz serwer...';

  @override
  String get sftpConnecting => 'Łączenie...';

  @override
  String get sftpEmptyDirectory => 'Ten katalog jest pusty';

  @override
  String get sftpNoConnection => 'Brak połączenia z serwerem';

  @override
  String get sftpPathLabel => 'Ścieżka';

  @override
  String get sftpUpload => 'Wyślij';

  @override
  String get sftpDownload => 'Pobierz';

  @override
  String get sftpDelete => 'Usuń';

  @override
  String get sftpRename => 'Zmień nazwę';

  @override
  String get sftpNewFolder => 'Nowy folder';

  @override
  String get sftpNewFolderName => 'Nazwa folderu';

  @override
  String get sftpChmod => 'Uprawnienia';

  @override
  String get sftpChmodTitle => 'Zmień uprawnienia';

  @override
  String get sftpChmodOctal => 'Ósemkowy';

  @override
  String get sftpChmodOwner => 'Właściciel';

  @override
  String get sftpChmodGroup => 'Grupa';

  @override
  String get sftpChmodOther => 'Inni';

  @override
  String get sftpChmodRead => 'Odczyt';

  @override
  String get sftpChmodWrite => 'Zapis';

  @override
  String get sftpChmodExecute => 'Wykonanie';

  @override
  String get sftpCreateSymlink => 'Utwórz dowiązanie symboliczne';

  @override
  String get sftpSymlinkTarget => 'Ścieżka docelowa';

  @override
  String get sftpSymlinkName => 'Nazwa dowiązania';

  @override
  String get sftpFilePreview => 'Podgląd pliku';

  @override
  String get sftpFileInfo => 'Informacje o pliku';

  @override
  String get sftpFileSize => 'Rozmiar';

  @override
  String get sftpFileModified => 'Zmodyfikowany';

  @override
  String get sftpFilePermissions => 'Uprawnienia';

  @override
  String get sftpFileOwner => 'Właściciel';

  @override
  String get sftpFileType => 'Typ';

  @override
  String get sftpFileLinkTarget => 'Cel dowiązania';

  @override
  String get sftpTransfers => 'Transfery';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current z $total';
  }

  @override
  String get sftpTransferQueued => 'W kolejce';

  @override
  String get sftpTransferActive => 'Przesyłanie...';

  @override
  String get sftpTransferPaused => 'Wstrzymano';

  @override
  String get sftpTransferCompleted => 'Zakończono';

  @override
  String get sftpTransferFailed => 'Niepowodzenie';

  @override
  String get sftpTransferCancelled => 'Anulowano';

  @override
  String get sftpPauseTransfer => 'Wstrzymaj';

  @override
  String get sftpResumeTransfer => 'Wznów';

  @override
  String get sftpCancelTransfer => 'Anuluj';

  @override
  String get sftpClearCompleted => 'Wyczyść zakończone';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active z $total transferów';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktywnych',
      one: '1 aktywny',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zakończonych',
      one: '1 zakończony',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nieudanych',
      one: '1 nieudany',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Kopiuj do drugiego panelu';

  @override
  String sftpConfirmDelete(int count) {
    return 'Usunąć $count elementów?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Usunąć \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Usunięto pomyślnie';

  @override
  String get sftpRenameTitle => 'Zmień nazwę';

  @override
  String get sftpRenameLabel => 'Nowa nazwa';

  @override
  String get sftpSortByName => 'Nazwa';

  @override
  String get sftpSortBySize => 'Rozmiar';

  @override
  String get sftpSortByDate => 'Data';

  @override
  String get sftpSortByType => 'Typ';

  @override
  String get sftpShowHidden => 'Pokaż ukryte pliki';

  @override
  String get sftpHideHidden => 'Ukryj ukryte pliki';

  @override
  String get sftpSelectAll => 'Zaznacz wszystko';

  @override
  String get sftpDeselectAll => 'Odznacz wszystko';

  @override
  String sftpItemsSelected(int count) {
    return 'Zaznaczono: $count';
  }

  @override
  String get sftpRefresh => 'Odśwież';

  @override
  String sftpConnectionError(String message) {
    return 'Błąd połączenia: $message';
  }

  @override
  String get sftpPermissionDenied => 'Brak uprawnień';

  @override
  String sftpOperationFailed(String message) {
    return 'Operacja nie powiodła się: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Plik już istnieje';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" już istnieje. Nadpisać?';
  }

  @override
  String get sftpOverwrite => 'Nadpisz';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Transfer rozpoczęty: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'Najpierw wybierz cel w drugim panelu';

  @override
  String get sftpDirectoryTransferNotSupported => 'Transfer katalogów wkrótce';

  @override
  String get sftpSelect => 'Wybierz';

  @override
  String get sftpOpen => 'Otwórz';

  @override
  String get sftpExtractArchive => 'Wypakuj tutaj';

  @override
  String get sftpExtractSuccess => 'Archiwum wypakowane';

  @override
  String sftpExtractFailed(String message) {
    return 'Wypakowywanie nie powiodło się: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Nieobsługiwany format archiwum';

  @override
  String get sftpExtracting => 'Wypakowywanie...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wysyłań rozpoczętych',
      one: 'Wysyłanie rozpoczęte',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pobierań rozpoczętych',
      one: 'Pobieranie rozpoczęte',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" pobrano';
  }

  @override
  String get sftpSavedToDownloads => 'Zapisano w Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Zapisz do plików';

  @override
  String get sftpFileSaved => 'Plik zapisany';

  @override
  String get fileChooserOpenFile => 'Open file';

  @override
  String get fileChooserSaveFile => 'Save file';

  @override
  String get fileChooserOpenDirectory => 'Choose folder';

  @override
  String get fileChooserImportArchive => 'Import backup';

  @override
  String get fileChooserImportSshConfig => 'Import SSH config';

  @override
  String get fileChooserImportSettings => 'Import settings';

  @override
  String get fileChooserPickKeyFile => 'Pick SSH key file';

  @override
  String get fileChooserUploadFiles => 'Upload files';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesji SSH aktywnych',
      one: 'Sesja SSH aktywna',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Stuknij, aby otworzyć terminal';

  @override
  String get settingsAccountAndSync => 'Konto i synchronizacja';

  @override
  String get settingsAccountSubtitleAuth => 'Zalogowany';

  @override
  String get settingsAccountSubtitleUnauth => 'Niezalogowany';

  @override
  String get settingsSecuritySubtitle => 'Autoblokada, Biometria, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Użytkownik root';

  @override
  String get settingsAppearanceSubtitle => 'Motyw, Język, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Ustawienia zaszyfrowanego eksportu';

  @override
  String get settingsAboutSubtitle => 'Wersja, Licencje';

  @override
  String get settingsSearchHint => 'Szukaj ustawień...';

  @override
  String get settingsSearchNoResults => 'Nie znaleziono ustawień';

  @override
  String get aboutDeveloper => 'Opracowane przez Kiefer Networks';

  @override
  String get aboutDonate => 'Wesprzyj';

  @override
  String get aboutOpenSourceLicenses => 'Licencje Open Source';

  @override
  String get aboutWebsite => 'Strona internetowa';

  @override
  String get aboutVersion => 'Wersja';

  @override
  String get aboutBuild => 'Kompilacja';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS szyfruje zapytania DNS i zapobiega fałszowaniu DNS. SSHVault sprawdza nazwy hostów u wielu dostawców w celu wykrycia ataków.';

  @override
  String get settingsDnsAddServer => 'Dodaj serwer DNS';

  @override
  String get settingsDnsServerUrl => 'Adres URL serwera';

  @override
  String get settingsDnsDefaultBadge => 'Domyślny';

  @override
  String get settingsDnsResetDefaults => 'Przywróć domyślne';

  @override
  String get settingsDnsInvalidUrl => 'Wprowadź prawidłowy adres HTTPS URL';

  @override
  String get settingsDefaultAuthMethod => 'Metoda uwierzytelniania';

  @override
  String get settingsAuthPassword => 'Hasło';

  @override
  String get settingsAuthKey => 'Klucz SSH';

  @override
  String get settingsConnectionTimeout => 'Limit czasu połączenia';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsKeepaliveInterval => 'Interwał Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsCompression => 'Kompresja';

  @override
  String get settingsCompressionDescription =>
      'Włącz kompresję zlib dla połączeń SSH';

  @override
  String get settingsTerminalType => 'Typ terminala';

  @override
  String get settingsSectionConnection => 'Połączenie';

  @override
  String get settingsClipboardAutoClear => 'Automatyczne czyszczenie schowka';

  @override
  String get settingsClipboardAutoClearOff => 'Wył.';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsSessionTimeout => 'Limit czasu sesji';

  @override
  String get settingsSessionTimeoutOff => 'Wył.';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'PIN alarmowy';

  @override
  String get settingsDuressPinDescription =>
      'Oddzielny PIN, który kasuje wszystkie dane po wprowadzeniu';

  @override
  String get settingsDuressPinSet => 'PIN alarmowy jest ustawiony';

  @override
  String get settingsDuressPinNotSet => 'Nie skonfigurowano';

  @override
  String get settingsDuressPinWarning =>
      'Wprowadzenie tego PIN trwale usunie wszystkie lokalne dane, w tym dane logowania, klucze i ustawienia. Tej operacji nie można cofnąć.';

  @override
  String get settingsKeyRotationReminder => 'Przypomnienie o rotacji kluczy';

  @override
  String get settingsKeyRotationOff => 'Wył.';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days dni';
  }

  @override
  String get settingsFailedAttempts => 'Nieudane próby PIN';

  @override
  String get settingsSectionAppLock => 'Blokada aplikacji';

  @override
  String get settingsSectionPrivacy => 'Prywatność';

  @override
  String get settingsSectionReminders => 'Przypomnienia';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle => 'Eksport, Import i kopia zapasowa';

  @override
  String get settingsExportJson => 'Eksportuj jako JSON';

  @override
  String get settingsExportEncrypted => 'Eksportuj zaszyfrowany';

  @override
  String get settingsImportFile => 'Importuj z pliku';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Filtruj serwery';

  @override
  String get filterApply => 'Zastosuj filtry';

  @override
  String get filterClearAll => 'Wyczyść wszystko';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtrów aktywnych',
      one: '1 filtr aktywny',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Folder';

  @override
  String get filterTags => 'Tagi';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Podgląd z podstawieniem';

  @override
  String get variableInsert => 'Wstaw';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serwerów',
      one: '1 serwer',
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
      other: '$count sesji unieważnionych.',
      one: '1 sesja unieważniona.',
    );
    return '$_temp0 Zostałeś wylogowany.';
  }

  @override
  String get keyGenPassphrase => 'Hasło';

  @override
  String get keyGenPassphraseHint => 'Opcjonalnie — chroni klucz prywatny';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Domyślne (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Klucz o tym samym odcisku palca już istnieje: \"$name\". Każdy klucz SSH musi być unikalny.';
  }

  @override
  String get sshKeyFingerprint => 'Odcisk palca';

  @override
  String get sshKeyPublicKey => 'Klucz publiczny';

  @override
  String get jumpHost => 'Host pośredniczący';

  @override
  String get jumpHostNone => 'Brak';

  @override
  String get jumpHostLabel => 'Połącz przez host pośredniczący';

  @override
  String get jumpHostSelfError =>
      'Serwer nie może być własnym hostem pośredniczącym';

  @override
  String get jumpHostConnecting => 'Łączenie z hostem pośredniczącym...';

  @override
  String get jumpHostCircularError =>
      'Wykryto cykliczny łańcuch hostów pośredniczących';

  @override
  String get logoutDialogTitle => 'Wylogowanie';

  @override
  String get logoutDialogMessage =>
      'Czy usunąć wszystkie lokalne dane? Serwery, klucze SSH, snippety i ustawienia zostaną usunięte z tego urządzenia.';

  @override
  String get logoutOnly => 'Tylko wyloguj';

  @override
  String get logoutAndDelete => 'Wyloguj i usuń dane';

  @override
  String get changeAvatar => 'Zmień awatar';

  @override
  String get removeAvatar => 'Usuń awatar';

  @override
  String get avatarUploadFailed => 'Nie udało się przesłać awatara';

  @override
  String get avatarTooLarge => 'Obraz jest za duży';

  @override
  String get deviceLastSeen => 'Ostatnio widziany';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Adresu URL serwera nie można zmienić podczas zalogowania. Najpierw się wyloguj.';

  @override
  String get serverListNoFolder => 'Bez kategorii';

  @override
  String get autoSyncInterval => 'Interwał synchronizacji';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Ustawienia proxy';

  @override
  String get proxyType => 'Typ proxy';

  @override
  String get proxyNone => 'Bez proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Host proxy';

  @override
  String get proxyPort => 'Port proxy';

  @override
  String get proxyUsername => 'Nazwa użytkownika proxy';

  @override
  String get proxyPassword => 'Hasło proxy';

  @override
  String get proxyUseGlobal => 'Użyj globalnego proxy';

  @override
  String get proxyGlobal => 'Globalny';

  @override
  String get proxyServerSpecific => 'Specyficzny dla serwera';

  @override
  String get proxyTestConnection => 'Testuj połączenie';

  @override
  String get proxyTestSuccess => 'Proxy osiągalne';

  @override
  String get proxyTestFailed => 'Proxy nieosiągalne';

  @override
  String get proxyDefaultProxy => 'Domyślne proxy';

  @override
  String get vpnRequired => 'Wymagany VPN';

  @override
  String get vpnRequiredTooltip =>
      'Pokaż ostrzeżenie przy łączeniu bez aktywnego VPN';

  @override
  String get vpnActive => 'VPN aktywny';

  @override
  String get vpnInactive => 'VPN nieaktywny';

  @override
  String get vpnWarningTitle => 'VPN nieaktywny';

  @override
  String get vpnWarningMessage =>
      'Ten serwer wymaga połączenia VPN, ale VPN nie jest obecnie aktywny. Połączyć mimo to?';

  @override
  String get vpnConnectAnyway => 'Połącz mimo to';

  @override
  String get postConnectCommands => 'Polecenia po połączeniu';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Polecenia wykonywane automatycznie po połączeniu (jedno na linię)';

  @override
  String get dashboardFavorites => 'Ulubione';

  @override
  String get dashboardRecent => 'Ostatnie';

  @override
  String get dashboardActiveSessions => 'Aktywne sesje';

  @override
  String get addToFavorites => 'Dodaj do ulubionych';

  @override
  String get removeFromFavorites => 'Usuń z ulubionych';

  @override
  String get noRecentConnections => 'Brak ostatnich połączeń';

  @override
  String get terminalSplit => 'Podziel widok';

  @override
  String get terminalUnsplit => 'Zamknij podział';

  @override
  String get terminalSelectSession => 'Wybierz sesję do podzielonego widoku';

  @override
  String get knownHostsTitle => 'Znane hosty';

  @override
  String get knownHostsSubtitle =>
      'Zarządzaj zaufanymi odciskami palców serwerów';

  @override
  String get hostKeyNewTitle => 'Nowy host';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Pierwsze połączenie z $hostname:$port. Zweryfikuj odcisk palca przed połączeniem.';
  }

  @override
  String get hostKeyChangedTitle => 'Klucz hosta się zmienił!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Klucz hosta $hostname:$port uległ zmianie. Może to wskazywać na zagrożenie bezpieczeństwa.';
  }

  @override
  String get hostKeyFingerprint => 'Odcisk palca';

  @override
  String get hostKeyType => 'Typ klucza';

  @override
  String get hostKeyTrustConnect => 'Zaufaj i połącz';

  @override
  String get hostKeyAcceptNew => 'Zaakceptuj nowy klucz';

  @override
  String get hostKeyReject => 'Odrzuć';

  @override
  String get hostKeyPreviousFingerprint => 'Poprzedni odcisk palca';

  @override
  String get hostKeyDeleteAll => 'Usuń wszystkie znane hosty';

  @override
  String get hostKeyDeleteConfirm =>
      'Czy na pewno chcesz usunąć wszystkie znane hosty? Przy następnym połączeniu zostaniesz ponownie poproszony o weryfikację.';

  @override
  String get hostKeyEmpty => 'Brak znanych hostów';

  @override
  String get hostKeyEmptySubtitle =>
      'Odciski palców hostów zostaną zapisane tutaj po pierwszym połączeniu';

  @override
  String get hostKeyFirstSeen => 'Wykryto po raz pierwszy';

  @override
  String get hostKeyLastSeen => 'Ostatnio wykryto';

  @override
  String get sshConfigImportTitle => 'Import SSH Config';

  @override
  String get sshConfigImportPickFile => 'Wybierz plik SSH Config';

  @override
  String get sshConfigImportOrPaste => 'Lub wklej zawartość konfiguracji';

  @override
  String sshConfigImportParsed(int count) {
    return 'Znaleziono $count hostów';
  }

  @override
  String get sshConfigImportButton => 'Importuj';

  @override
  String sshConfigImportSuccess(int count) {
    return 'Zaimportowano $count serwer(ów)';
  }

  @override
  String get sshConfigImportDuplicate => 'Już istnieje';

  @override
  String get sshConfigImportNoHosts => 'Nie znaleziono hostów w konfiguracji';

  @override
  String get sftpBookmarkAdd => 'Dodaj zakładkę';

  @override
  String get sftpBookmarkLabel => 'Etykieta';

  @override
  String get disconnect => 'Rozłącz';

  @override
  String get reportAndDisconnect => 'Zgłoś i rozłącz';

  @override
  String get continueAnyway => 'Kontynuuj mimo to';

  @override
  String get insertSnippet => 'Wstaw snippet';

  @override
  String get seconds => 'Sekundy';

  @override
  String get heartbeatLostMessage =>
      'Serwer nie odpowiadał po wielu próbach. Dla Twojego bezpieczeństwa sesja została zakończona.';

  @override
  String get attestationFailedTitle => 'Weryfikacja serwera nie powiodła się';

  @override
  String get attestationFailedMessage =>
      'Serwera nie udało się zweryfikować jako prawidłowy backend SSHVault. Może to wskazywać na atak typu man-in-the-middle lub błędną konfigurację serwera.';

  @override
  String get attestationKeyChangedTitle =>
      'Klucz atestacji serwera się zmienił';

  @override
  String get attestationKeyChangedMessage =>
      'Klucz atestacji serwera zmienił się od czasu początkowego połączenia. Może to wskazywać na atak typu man-in-the-middle. NIE kontynuuj, chyba że administrator serwera potwierdził rotację kluczy.';

  @override
  String get sectionLinks => 'Linki';

  @override
  String get sectionDeveloper => 'Deweloper';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Strona nie znaleziona';

  @override
  String get connectionTestSuccess => 'Połączenie udane';

  @override
  String connectionTestFailed(String message) {
    return 'Połączenie nieudane: $message';
  }

  @override
  String get serverVerificationFailed => 'Weryfikacja serwera nie powiodła się';

  @override
  String get importSuccessful => 'Import zakończony pomyślnie';

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
  String get deviceDeleteConfirmTitle => 'Usuń urządzenie';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Czy na pewno chcesz usunąć \"$name\"? Urządzenie zostanie natychmiast wylogowane.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'To jest Twoje obecne urządzenie. Zostaniesz natychmiast wylogowany.';

  @override
  String get deviceDeleteSuccess => 'Urządzenie usunięte';

  @override
  String get deviceDeletedCurrentLogout =>
      'Obecne urządzenie usunięte. Zostałeś wylogowany.';

  @override
  String get thisDevice => 'To urządzenie';
}
