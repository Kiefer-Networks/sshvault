// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Kiszolgálók';

  @override
  String get navSnippets => 'Kódrészletek';

  @override
  String get navFolders => 'Mappák';

  @override
  String get navTags => 'Címkék';

  @override
  String get navSshKeys => 'SSH kulcsok';

  @override
  String get navExportImport => 'Exportálás / Importálás';

  @override
  String get navTerminal => 'Terminál';

  @override
  String get navMore => 'Továbbiak';

  @override
  String get navManagement => 'Kezelés';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get navAbout => 'Névjegy';

  @override
  String get lockScreenTitle => 'Az SSHVault zárolva van';

  @override
  String get lockScreenUnlock => 'Feloldás';

  @override
  String get lockScreenEnterPin => 'Adja meg a PIN-t';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Túl sok sikertelen próbálkozás. Próbálja újra $minutes perc múlva.';
  }

  @override
  String get pinDialogSetTitle => 'PIN kód beállítása';

  @override
  String get pinDialogSetSubtitle =>
      'Adjon meg egy 6 számjegyű PIN-t az SSHVault védelméhez';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'PIN megerősítése';

  @override
  String get pinDialogErrorLength =>
      'A PIN-nek pontosan 6 számjegyűnek kell lennie';

  @override
  String get pinDialogErrorMismatch => 'A PIN kódok nem egyeznek';

  @override
  String get pinDialogVerifyTitle => 'Adja meg a PIN-t';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Hibás PIN. $attempts próbálkozás maradt.';
  }

  @override
  String get securityBannerMessage =>
      'Az SSH hitelesítő adatai nincsenek védve. Állítson be PIN-t vagy biometrikus zárolást a Beállításokban.';

  @override
  String get securityBannerDismiss => 'Bezárás';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get settingsSectionAppearance => 'Megjelenés';

  @override
  String get settingsSectionTerminal => 'Terminál';

  @override
  String get settingsSectionSshDefaults => 'SSH alapértelmezések';

  @override
  String get settingsSectionSecurity => 'Biztonság';

  @override
  String get settingsSectionExport => 'Exportálás';

  @override
  String get settingsSectionAbout => 'Névjegy';

  @override
  String get settingsTheme => 'Téma';

  @override
  String get settingsThemeSystem => 'Rendszer';

  @override
  String get settingsThemeLight => 'Világos';

  @override
  String get settingsThemeDark => 'Sötét';

  @override
  String get settingsTerminalTheme => 'Terminál téma';

  @override
  String get settingsTerminalThemeDefault => 'Alapértelmezett sötét';

  @override
  String get settingsFontSize => 'Betűméret';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Alapértelmezett port';

  @override
  String get settingsDefaultPortDialog => 'Alapértelmezett SSH port';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Alapértelmezett felhasználónév';

  @override
  String get settingsDefaultUsernameDialog => 'Alapértelmezett felhasználónév';

  @override
  String get settingsUsernameLabel => 'Felhasználónév';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automatikus zárolás';

  @override
  String get settingsAutoLockDisabled => 'Letiltva';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes perc';
  }

  @override
  String get settingsAutoLockOff => 'Ki';

  @override
  String get settingsAutoLock1Min => '1 perc';

  @override
  String get settingsAutoLock5Min => '5 perc';

  @override
  String get settingsAutoLock15Min => '15 perc';

  @override
  String get settingsAutoLock30Min => '30 perc';

  @override
  String get settingsBiometricUnlock => 'Biometrikus feloldás';

  @override
  String get settingsBiometricNotAvailable => 'Nem érhető el ezen az eszközön';

  @override
  String get settingsBiometricError => 'Hiba a biometria ellenőrzésekor';

  @override
  String get settingsBiometricReason =>
      'Igazolja személyazonosságát a biometrikus feloldás engedélyezéséhez';

  @override
  String get settingsBiometricRequiresPin =>
      'Először állítson be PIN-t a biometrikus feloldás engedélyezéséhez';

  @override
  String get settingsPinCode => 'PIN kód';

  @override
  String get settingsPinIsSet => 'A PIN be van állítva';

  @override
  String get settingsPinNotConfigured => 'Nincs PIN beállítva';

  @override
  String get settingsPinRemove => 'Eltávolítás';

  @override
  String get settingsPinRemoveWarning =>
      'A PIN eltávolítása visszafejti az összes adatbázismezőt és letiltja a biometrikus feloldást. Folytatja?';

  @override
  String get settingsPinRemoveTitle => 'PIN eltávolítása';

  @override
  String get settingsPreventScreenshots => 'Képernyőképek tiltása';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Képernyőképek és képernyőfelvétel blokkolása';

  @override
  String get settingsEncryptExport =>
      'Exportálások titkosítása alapértelmezetten';

  @override
  String get settingsAbout => 'Az SSHVault névjegye';

  @override
  String get settingsAboutLegalese => 'Kiefer Networks';

  @override
  String get settingsAboutDescription =>
      'Biztonságos, saját üzemeltetésű SSH kliens';

  @override
  String get settingsLanguage => 'Nyelv';

  @override
  String get settingsLanguageSystem => 'Rendszer';

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
  String get cancel => 'Mégse';

  @override
  String get save => 'Mentés';

  @override
  String get delete => 'Törlés';

  @override
  String get close => 'Bezárás';

  @override
  String get update => 'Frissítés';

  @override
  String get create => 'Létrehozás';

  @override
  String get retry => 'Újrapróbálás';

  @override
  String get copy => 'Másolás';

  @override
  String get edit => 'Szerkesztés';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Hiba: $message';
  }

  @override
  String get serverListTitle => 'Kiszolgálók';

  @override
  String get serverListEmpty => 'Még nincsenek kiszolgálók';

  @override
  String get serverListEmptySubtitle =>
      'Adja hozzá első SSH kiszolgálóját a kezdéshez.';

  @override
  String get serverAddButton => 'Kiszolgáló hozzáadása';

  @override
  String sshConfigImportMessage(int count) {
    return '$count gazdagép található a ~/.ssh/config fájlban. Importálja őket?';
  }

  @override
  String get sshConfigNotFound => 'SSH konfigurációs fájl nem található';

  @override
  String get sshConfigEmpty => 'Nem található gazdagép az SSH konfigurációban';

  @override
  String get sshConfigAddManually => 'Kézi hozzáadás';

  @override
  String get sshConfigImportAgain => 'SSH konfiguráció újbóli importálása?';

  @override
  String get sshConfigImportKeys =>
      'Importálja a kiválasztott kiszolgálók által hivatkozott SSH kulcsokat?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH kulcs importálva';
  }

  @override
  String get serverDuplicated => 'Kiszolgáló duplikálva';

  @override
  String get serverDeleteTitle => 'Kiszolgáló törlése';

  @override
  String serverDeleteMessage(String name) {
    return 'Biztosan törli a(z) \"$name\" kiszolgálót? Ez a művelet nem vonható vissza.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Törli a(z) \"$name\" kiszolgálót?';
  }

  @override
  String get serverConnect => 'Csatlakozás';

  @override
  String get serverDetails => 'Részletek';

  @override
  String get serverDuplicate => 'Duplikálás';

  @override
  String get serverActive => 'Aktív';

  @override
  String get serverNoFolder => 'Nincs mappa';

  @override
  String get serverFormTitleEdit => 'Kiszolgáló szerkesztése';

  @override
  String get serverFormTitleAdd => 'Kiszolgáló hozzáadása';

  @override
  String get serverSaved => 'Szerver mentve';

  @override
  String get serverFormUpdateButton => 'Kiszolgáló frissítése';

  @override
  String get serverFormAddButton => 'Kiszolgáló hozzáadása';

  @override
  String get serverFormPublicKeyExtracted =>
      'Nyilvános kulcs sikeresen kinyerve';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Nem sikerült kinyerni a nyilvános kulcsot: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type kulcspár létrehozva';
  }

  @override
  String get serverDetailTitle => 'Kiszolgáló részletei';

  @override
  String get serverDetailDeleteMessage => 'Ez a művelet nem vonható vissza.';

  @override
  String get serverDetailConnection => 'Kapcsolat';

  @override
  String get serverDetailHost => 'Gazdagép';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Felhasználónév';

  @override
  String get serverDetailFolder => 'Mappa';

  @override
  String get serverDetailTags => 'Címkék';

  @override
  String get serverDetailNotes => 'Megjegyzések';

  @override
  String get serverDetailInfo => 'Információ';

  @override
  String get serverDetailCreated => 'Létrehozva';

  @override
  String get serverDetailUpdated => 'Frissítve';

  @override
  String get serverDetailDistro => 'Rendszer';

  @override
  String get copiedToClipboard => 'Vágólapra másolva';

  @override
  String get serverFormNameLabel => 'Kiszolgáló neve';

  @override
  String get serverFormHostnameLabel => 'Gazdagépnév / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Felhasználónév';

  @override
  String get serverFormPasswordLabel => 'Jelszó';

  @override
  String get serverFormUseManagedKey => 'Kezelt kulcs használata';

  @override
  String get serverFormManagedKeySubtitle =>
      'Válasszon a központilag kezelt SSH kulcsok közül';

  @override
  String get serverFormDirectKeySubtitle =>
      'Kulcs közvetlen beillesztése ehhez a kiszolgálóhoz';

  @override
  String get serverFormGenerateKey => 'SSH kulcspár generálása';

  @override
  String get serverFormPrivateKeyLabel => 'Privát kulcs';

  @override
  String get serverFormPrivateKeyHint => 'Illessze be az SSH privát kulcsot...';

  @override
  String get serverFormExtractPublicKey => 'Nyilvános kulcs kinyerése';

  @override
  String get serverFormPublicKeyLabel => 'Nyilvános kulcs';

  @override
  String get serverFormPublicKeyHint =>
      'Automatikusan generálva a privát kulcsból, ha üres';

  @override
  String get serverFormPassphraseLabel => 'Kulcs jelmondat (opcionális)';

  @override
  String get serverFormNotesLabel => 'Megjegyzések (opcionális)';

  @override
  String get searchServers => 'Kiszolgálók keresése...';

  @override
  String get filterAllFolders => 'Összes mappa';

  @override
  String get filterAll => 'Mind';

  @override
  String get filterActive => 'Aktív';

  @override
  String get filterInactive => 'Inaktív';

  @override
  String get filterClear => 'Törlés';

  @override
  String get folderListTitle => 'Mappák';

  @override
  String get folderListEmpty => 'Még nincsenek mappák';

  @override
  String get folderListEmptySubtitle =>
      'Hozzon létre mappákat a kiszolgálók rendszerezéséhez.';

  @override
  String get folderAddButton => 'Mappa hozzáadása';

  @override
  String get folderDeleteTitle => 'Mappa törlése';

  @override
  String folderDeleteMessage(String name) {
    return 'Törli a(z) \"$name\" mappát? A kiszolgálók rendezetlen állapotba kerülnek.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kiszolgáló',
      one: '1 kiszolgáló',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Összecsukás';

  @override
  String get folderShowHosts => 'Gazdagépek megjelenítése';

  @override
  String get folderConnectAll => 'Összes csatlakoztatása';

  @override
  String get folderFormTitleEdit => 'Mappa szerkesztése';

  @override
  String get folderFormTitleNew => 'Új mappa';

  @override
  String get folderFormNameLabel => 'Mappa neve';

  @override
  String get folderFormParentLabel => 'Szülőmappa';

  @override
  String get folderFormParentNone => 'Nincs (gyökér)';

  @override
  String get tagListTitle => 'Címkék';

  @override
  String get tagListEmpty => 'Még nincsenek címkék';

  @override
  String get tagListEmptySubtitle =>
      'Hozzon létre címkéket a kiszolgálók jelöléséhez és szűréséhez.';

  @override
  String get tagAddButton => 'Címke hozzáadása';

  @override
  String get tagDeleteTitle => 'Címke törlése';

  @override
  String tagDeleteMessage(String name) {
    return 'Törli a(z) \"$name\" címkét? Eltávolításra kerül az összes kiszolgálóról.';
  }

  @override
  String get tagFormTitleEdit => 'Címke szerkesztése';

  @override
  String get tagFormTitleNew => 'Új címke';

  @override
  String get tagFormNameLabel => 'Címke neve';

  @override
  String get sshKeyListTitle => 'SSH kulcsok';

  @override
  String get sshKeyListEmpty => 'Még nincsenek SSH kulcsok';

  @override
  String get sshKeyListEmptySubtitle =>
      'Generáljon vagy importáljon SSH kulcsokat a központi kezeléshez';

  @override
  String get sshKeyCannotDeleteTitle => 'Nem törölhető';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'A(z) \"$name\" nem törölhető. $count kiszolgáló használja. Először válassza le az összes kiszolgálóról.';
  }

  @override
  String get sshKeyDeleteTitle => 'SSH kulcs törlése';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Törli a(z) \"$name\" kulcsot? Ez nem vonható vissza.';
  }

  @override
  String get sshKeyAddButton => 'SSH kulcs hozzáadása';

  @override
  String get sshKeyFormTitleEdit => 'SSH kulcs szerkesztése';

  @override
  String get sshKeyFormTitleAdd => 'SSH kulcs hozzáadása';

  @override
  String get sshKeyFormTabGenerate => 'Generálás';

  @override
  String get sshKeyFormTabImport => 'Importálás';

  @override
  String get sshKeyFormNameLabel => 'Kulcs neve';

  @override
  String get sshKeyFormNameHint => 'pl. Éles üzemi kulcs';

  @override
  String get sshKeyFormKeyType => 'Kulcstípus';

  @override
  String get sshKeyFormKeySize => 'Kulcsméret';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Megjegyzés';

  @override
  String get sshKeyFormCommentHint => 'felhasználó@gazdagép vagy leírás';

  @override
  String get sshKeyFormCommentOptional => 'Megjegyzés (opcionális)';

  @override
  String get sshKeyFormImportFromFile => 'Importálás fájlból';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Privát kulcs';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Illessze be az SSH privát kulcsot, vagy használja a fenti gombot...';

  @override
  String get sshKeyFormPassphraseLabel => 'Jelmondat (opcionális)';

  @override
  String get sshKeyFormNameRequired => 'A név megadása kötelező';

  @override
  String get sshKeyFormPrivateKeyRequired => 'A privát kulcs megadása kötelező';

  @override
  String get sshKeyFormFileReadError => 'A kiválasztott fájl nem olvasható';

  @override
  String get sshKeyFormInvalidFormat =>
      'Érvénytelen kulcsformátum — PEM formátum szükséges (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Fájl olvasása sikertelen: $message';
  }

  @override
  String get sshKeyFormSaving => 'Mentés...';

  @override
  String get sshKeySelectorLabel => 'SSH kulcs';

  @override
  String get sshKeySelectorNone => 'Nincs kezelt kulcs';

  @override
  String get sshKeySelectorManage => 'Kulcsok kezelése...';

  @override
  String get sshKeySelectorError => 'SSH kulcsok betöltése sikertelen';

  @override
  String get sshKeyTileCopyPublicKey => 'Nyilvános kulcs másolása';

  @override
  String get sshKeyTilePublicKeyCopied => 'Nyilvános kulcs másolva';

  @override
  String sshKeyTileLinkedServers(int count) {
    return '$count kiszolgáló használja';
  }

  @override
  String get sshKeySavedSuccess => 'SSH-kulcs mentve';

  @override
  String get sshKeyDeletedSuccess => 'SSH-kulcs törölve';

  @override
  String get tagSavedSuccess => 'Címke mentve';

  @override
  String get tagDeletedSuccess => 'Címke törölve';

  @override
  String get folderDeletedSuccess => 'Mappa törölve';

  @override
  String get sshKeyTileUnlinkFirst =>
      'Először válassza le az összes kiszolgálóról';

  @override
  String get exportImportTitle => 'Exportálás / Importálás';

  @override
  String get exportSectionTitle => 'Exportálás';

  @override
  String get exportJsonButton =>
      'Exportálás JSON formátumban (hitelesítő adatok nélkül)';

  @override
  String get exportZipButton =>
      'Titkosított ZIP exportálása (hitelesítő adatokkal)';

  @override
  String get importSectionTitle => 'Importálás';

  @override
  String get importButton => 'Importálás fájlból';

  @override
  String get importSupportedFormats =>
      'JSON (egyszerű szöveg) és ZIP (titkosított) fájlok támogatottak.';

  @override
  String exportedTo(String path) {
    return 'Exportálva ide: $path';
  }

  @override
  String get share => 'Megosztás';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers kiszolgáló, $groups csoport, $tags címke importálva. $skipped kihagyva.';
  }

  @override
  String get importPasswordTitle => 'Jelszó megadása';

  @override
  String get importPasswordLabel => 'Export jelszó';

  @override
  String get importPasswordDecrypt => 'Visszafejtés';

  @override
  String get exportPasswordTitle => 'Export jelszó beállítása';

  @override
  String get exportPasswordDescription =>
      'Ezzel a jelszóval lesz titkosítva az export fájl a hitelesítő adatokkal együtt.';

  @override
  String get exportPasswordLabel => 'Jelszó';

  @override
  String get exportPasswordConfirmLabel => 'Jelszó megerősítése';

  @override
  String get exportPasswordMismatch => 'A jelszavak nem egyeznek';

  @override
  String get exportPasswordButton => 'Titkosítás és exportálás';

  @override
  String get importConflictTitle => 'Ütközések kezelése';

  @override
  String get importConflictDescription =>
      'Hogyan legyenek kezelve a meglévő bejegyzések az importálás során?';

  @override
  String get importConflictSkip => 'Meglévők kihagyása';

  @override
  String get importConflictRename => 'Újak átnevezése';

  @override
  String get importConflictOverwrite => 'Felülírás';

  @override
  String get confirmDeleteLabel => 'Törlés';

  @override
  String get keyGenTitle => 'SSH kulcspár generálása';

  @override
  String get keyGenKeyType => 'Kulcstípus';

  @override
  String get keyGenKeySize => 'Kulcsméret';

  @override
  String get keyGenComment => 'Megjegyzés';

  @override
  String get keyGenCommentHint => 'felhasználó@gazdagép vagy leírás';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Generálás...';

  @override
  String get keyGenGenerate => 'Generálás';

  @override
  String keyGenResultTitle(String type) {
    return '$type kulcs létrehozva';
  }

  @override
  String get keyGenPublicKey => 'Nyilvános kulcs';

  @override
  String get keyGenPrivateKey => 'Privát kulcs';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Megjegyzés: $comment';
  }

  @override
  String get keyGenAnother => 'Másik generálása';

  @override
  String get keyGenUseThisKey => 'Kulcs használata';

  @override
  String get keyGenCopyTooltip => 'Másolás a vágólapra';

  @override
  String keyGenCopied(String label) {
    return '$label másolva';
  }

  @override
  String get colorPickerLabel => 'Szín';

  @override
  String get iconPickerLabel => 'Ikon';

  @override
  String get tagSelectorLabel => 'Címkék';

  @override
  String get tagSelectorEmpty => 'Még nincsenek címkék';

  @override
  String get tagSelectorError => 'Címkék betöltése sikertelen';

  @override
  String get snippetListTitle => 'Kódrészletek';

  @override
  String get snippetSearchHint => 'Kódrészletek keresése...';

  @override
  String get snippetListEmpty => 'Még nincsenek kódrészletek';

  @override
  String get snippetListEmptySubtitle =>
      'Hozzon létre újrafelhasználható kódrészleteket és parancsokat.';

  @override
  String get snippetAddButton => 'Kódrészlet hozzáadása';

  @override
  String get snippetDeleteTitle => 'Kódrészlet törlése';

  @override
  String snippetDeleteMessage(String name) {
    return 'Törli a(z) \"$name\" kódrészletet? Ez nem vonható vissza.';
  }

  @override
  String get snippetFormTitleEdit => 'Kódrészlet szerkesztése';

  @override
  String get snippetFormTitleNew => 'Új kódrészlet';

  @override
  String get snippetFormNameLabel => 'Név';

  @override
  String get snippetFormNameHint => 'pl. Docker tisztítás';

  @override
  String get snippetFormLanguageLabel => 'Nyelv';

  @override
  String get snippetFormContentLabel => 'Tartalom';

  @override
  String get snippetFormContentHint => 'Írja be a kódrészletet...';

  @override
  String get snippetFormDescriptionLabel => 'Leírás';

  @override
  String get snippetFormDescriptionHint => 'Opcionális leírás...';

  @override
  String get snippetFormFolderLabel => 'Mappa';

  @override
  String get snippetFormNoFolder => 'Nincs mappa';

  @override
  String get snippetFormNameRequired => 'A név megadása kötelező';

  @override
  String get snippetFormContentRequired => 'A tartalom megadása kötelező';

  @override
  String get snippetFormSaved => 'Snippet mentve';

  @override
  String get snippetFormUpdateButton => 'Kódrészlet frissítése';

  @override
  String get snippetFormCreateButton => 'Kódrészlet létrehozása';

  @override
  String get snippetDetailTitle => 'Kódrészlet részletei';

  @override
  String get snippetDetailDeleteTitle => 'Kódrészlet törlése';

  @override
  String get snippetDetailDeleteMessage => 'Ez a művelet nem vonható vissza.';

  @override
  String get snippetDetailContent => 'Tartalom';

  @override
  String get snippetDetailFillVariables => 'Változók kitöltése';

  @override
  String get snippetDetailDescription => 'Leírás';

  @override
  String get snippetDetailVariables => 'Változók';

  @override
  String get snippetDetailTags => 'Címkék';

  @override
  String get snippetDetailInfo => 'Információ';

  @override
  String get snippetDetailCreated => 'Létrehozva';

  @override
  String get snippetDetailUpdated => 'Frissítve';

  @override
  String get variableEditorTitle => 'Sablon változók';

  @override
  String get variableEditorAdd => 'Hozzáadás';

  @override
  String get variableEditorEmpty =>
      'Nincsenek változók. Használjon kapcsos zárójeles szintaxist a tartalomban a hivatkozáshoz.';

  @override
  String get variableEditorNameLabel => 'Név';

  @override
  String get variableEditorNameHint => 'pl. gazdagépnév';

  @override
  String get variableEditorDefaultLabel => 'Alapértelmezett';

  @override
  String get variableEditorDefaultHint => 'opcionális';

  @override
  String get variableFillTitle => 'Változók kitöltése';

  @override
  String variableFillHint(String name) {
    return 'Adja meg a(z) $name értékét';
  }

  @override
  String get variableFillPreview => 'Előnézet';

  @override
  String get terminalTitle => 'Terminál';

  @override
  String get terminalEmpty => 'Nincsenek aktív munkamenetek';

  @override
  String get terminalEmptySubtitle =>
      'Csatlakozzon egy gazdagéphez a terminál munkamenet megnyitásához.';

  @override
  String get terminalGoToHosts => 'Ugrás a kiszolgálókhoz';

  @override
  String get terminalCloseAll => 'Összes munkamenet bezárása';

  @override
  String get terminalCloseTitle => 'Munkamenet bezárása';

  @override
  String terminalCloseMessage(String title) {
    return 'Bezárja az aktív kapcsolatot a(z) \"$title\" felé?';
  }

  @override
  String get connectionAuthenticating => 'Hitelesítés...';

  @override
  String connectionConnecting(String name) {
    return 'Csatlakozás a következőhöz: $name...';
  }

  @override
  String get connectionError => 'Csatlakozási hiba';

  @override
  String get connectionLost => 'Kapcsolat megszakadt';

  @override
  String get connectionReconnect => 'Újracsatlakozás';

  @override
  String get snippetQuickPanelTitle => 'Kódrészlet beszúrása';

  @override
  String get snippetQuickPanelSearch => 'Kódrészletek keresése...';

  @override
  String get snippetQuickPanelEmpty => 'Nincsenek elérhető kódrészletek';

  @override
  String get snippetQuickPanelNoMatch => 'Nincs egyező kódrészlet';

  @override
  String get snippetQuickPanelInsertTooltip => 'Kódrészlet beszúrása';

  @override
  String get terminalThemePickerTitle => 'Terminál téma';

  @override
  String get validatorHostnameRequired => 'A gazdagépnév megadása kötelező';

  @override
  String get validatorHostnameInvalid => 'Érvénytelen gazdagépnév vagy IP-cím';

  @override
  String get validatorPortRequired => 'A port megadása kötelező';

  @override
  String get validatorPortRange => 'A portnak 1 és 65535 között kell lennie';

  @override
  String get validatorUsernameRequired => 'A felhasználónév megadása kötelező';

  @override
  String get validatorUsernameInvalid => 'Érvénytelen felhasználónév formátum';

  @override
  String get validatorServerNameRequired => 'A kiszolgáló neve kötelező';

  @override
  String get validatorServerNameLength =>
      'A kiszolgáló neve legfeljebb 100 karakter lehet';

  @override
  String get validatorSshKeyInvalid => 'Érvénytelen SSH kulcs formátum';

  @override
  String get validatorPasswordRequired => 'A jelszó megadása kötelező';

  @override
  String get validatorPasswordLength =>
      'A jelszónak legalább 8 karakter hosszúnak kell lennie';

  @override
  String get authMethodPassword => 'Jelszó';

  @override
  String get authMethodKey => 'SSH kulcs';

  @override
  String get authMethodBoth => 'Jelszó + kulcs';

  @override
  String get serverCopySuffix => '(Másolat)';

  @override
  String get settingsDownloadLogs => 'Naplók letöltése';

  @override
  String get settingsSendLogs => 'Naplók küldése a támogatásnak';

  @override
  String get settingsLogsSaved => 'Naplók sikeresen mentve';

  @override
  String get settingsUpdated => 'Beállítás frissítve';

  @override
  String get settingsThemeChanged => 'Téma megváltoztatva';

  @override
  String get settingsLanguageChanged => 'Nyelv megváltoztatva';

  @override
  String get settingsPinSetSuccess => 'PIN beállítva';

  @override
  String get settingsPinRemovedSuccess => 'PIN eltávolítva';

  @override
  String get settingsDuressPinSetSuccess => 'Kényszerkód beállítva';

  @override
  String get settingsDuressPinRemovedSuccess => 'Kényszerkód eltávolítva';

  @override
  String get settingsBiometricEnabled => 'Biometrikus feloldás engedélyezve';

  @override
  String get settingsBiometricDisabled => 'Biometrikus feloldás letiltva';

  @override
  String get settingsDnsServerAdded => 'DNS-szerver hozzáadva';

  @override
  String get settingsDnsServerRemoved => 'DNS-szerver eltávolítva';

  @override
  String get settingsDnsResetSuccess => 'DNS-szerverek visszaállítva';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Betűméret csökkentése';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Betűméret növelése';

  @override
  String get settingsDnsRemoveServerTooltip => 'DNS-szerver eltávolítása';

  @override
  String get settingsLogsEmpty => 'Nincsenek elérhető naplóbejegyzések';

  @override
  String get authLogin => 'Bejelentkezés';

  @override
  String get authRegister => 'Regisztráció';

  @override
  String get authForgotPassword => 'Elfelejtett jelszó?';

  @override
  String get authWhyLogin =>
      'Jelentkezzen be a titkosított felhőszinkronizálás engedélyezéséhez az összes eszközén. Az alkalmazás fiók nélkül is teljes mértékben offline működik.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailRequired => 'Az e-mail megadása kötelező';

  @override
  String get authEmailInvalid => 'Érvénytelen e-mail cím';

  @override
  String get authPasswordLabel => 'Jelszó';

  @override
  String get authConfirmPasswordLabel => 'Jelszó megerősítése';

  @override
  String get authPasswordMismatch => 'A jelszavak nem egyeznek';

  @override
  String get authNoAccount => 'Nincs fiókja?';

  @override
  String get authHasAccount => 'Már van fiókja?';

  @override
  String get authResetEmailSent =>
      'Ha létezik a fiók, egy visszaállítási link lett elküldve az e-mail címére.';

  @override
  String get authResetDescription =>
      'Adja meg e-mail címét, és küldünk egy linket a jelszó visszaállításához.';

  @override
  String get authSendResetLink => 'Visszaállítási link küldése';

  @override
  String get authBackToLogin => 'Vissza a bejelentkezéshez';

  @override
  String get syncPasswordTitle => 'Szinkronizálási jelszó';

  @override
  String get syncPasswordTitleCreate => 'Szinkronizálási jelszó beállítása';

  @override
  String get syncPasswordTitleEnter => 'Szinkronizálási jelszó megadása';

  @override
  String get syncPasswordDescription =>
      'Állítson be egy külön jelszót a széfadatok titkosításához. Ez a jelszó soha nem hagyja el az eszközét — a szerver csak titkosított adatokat tárol.';

  @override
  String get syncPasswordHintEnter =>
      'Adja meg a fiók létrehozásakor beállított jelszót.';

  @override
  String get syncPasswordWarning =>
      'Ha elfelejti ezt a jelszót, a szinkronizált adatait nem lehet visszaállítani. Nincs visszaállítási lehetőség.';

  @override
  String get syncPasswordLabel => 'Szinkronizálási jelszó';

  @override
  String get syncPasswordWrong => 'Hibás jelszó. Kérjük, próbálja újra.';

  @override
  String get firstSyncTitle => 'Meglévő adatok találhatók';

  @override
  String get firstSyncMessage =>
      'Ezen az eszközön meglévő adatok vannak, és a szerveren is van széf. Hogyan folytassuk?';

  @override
  String get firstSyncMerge => 'Összevonás (szerver nyer)';

  @override
  String get firstSyncOverwriteLocal => 'Helyi adatok felülírása';

  @override
  String get firstSyncKeepLocal => 'Helyi megtartása és feltöltés';

  @override
  String get firstSyncDeleteLocal => 'Helyi törlése és letöltés';

  @override
  String get changeEncryptionPassword => 'Titkosítási jelszó módosítása';

  @override
  String get changeEncryptionWarning =>
      'Kijelentkezik az összes többi eszközéről.';

  @override
  String get changeEncryptionOldPassword => 'Jelenlegi jelszó';

  @override
  String get changeEncryptionNewPassword => 'Új jelszó';

  @override
  String get changeEncryptionSuccess => 'Jelszó sikeresen módosítva.';

  @override
  String get logoutAllDevices => 'Kijelentkezés az összes eszközről';

  @override
  String get logoutAllDevicesConfirm =>
      'Ez visszavonja az összes aktív munkamenetet. Az összes eszközön újra be kell majd jelentkeznie.';

  @override
  String get logoutAllDevicesSuccess => 'Összes eszköz kijelentkeztetve.';

  @override
  String get syncSettingsTitle => 'Szinkronizálási beállítások';

  @override
  String get syncAutoSync => 'Automatikus szinkronizálás';

  @override
  String get syncAutoSyncDescription =>
      'Automatikus szinkronizálás az alkalmazás indításakor';

  @override
  String get syncNow => 'Szinkronizálás most';

  @override
  String get syncSyncing => 'Szinkronizálás...';

  @override
  String get syncSuccess => 'Szinkronizálás befejezve';

  @override
  String get syncError => 'Szinkronizálási hiba';

  @override
  String get syncServerUnreachable => 'A szerver nem érhető el';

  @override
  String get syncServerUnreachableHint =>
      'A szinkronizálási szerver nem érhető el. Ellenőrizze az internetkapcsolatot és a szerver URL-jét.';

  @override
  String get syncNetworkError =>
      'A szerverhez való csatlakozás sikertelen. Kérjük, ellenőrizze az internetkapcsolatot, vagy próbálja újra később.';

  @override
  String get syncNeverSynced => 'Soha nem szinkronizálva';

  @override
  String get syncVaultVersion => 'Széf verzió';

  @override
  String get syncTitle => 'Szinkronizálás';

  @override
  String get settingsSectionNetwork => 'Hálózat és DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS szerverek';

  @override
  String get settingsDnsDefault => 'Alapértelmezett (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Adja meg az egyéni DoH szerver URL-eket vesszővel elválasztva. Legalább 2 szerver szükséges a keresztellenőrzéshez.';

  @override
  String get settingsDnsLabel => 'DoH szerver URL-ek';

  @override
  String get settingsDnsReset => 'Alapértelmezések visszaállítása';

  @override
  String get settingsSectionSync => 'Szinkronizálás';

  @override
  String get settingsSyncAccount => 'Fiók';

  @override
  String get settingsSyncNotLoggedIn => 'Nincs bejelentkezve';

  @override
  String get settingsSyncStatus => 'Szinkronizálás';

  @override
  String get settingsSyncServerUrl => 'Szerver URL';

  @override
  String get settingsSyncDefaultServer => 'Alapértelmezett (sshvault.app)';

  @override
  String get accountTitle => 'Fiók';

  @override
  String get accountNotLoggedIn => 'Nincs bejelentkezve';

  @override
  String get accountVerified => 'Ellenőrizve';

  @override
  String get accountMemberSince => 'Tag óta';

  @override
  String get accountDevices => 'Eszközök';

  @override
  String get accountNoDevices => 'Nincsenek regisztrált eszközök';

  @override
  String get accountLastSync => 'Utolsó szinkronizálás';

  @override
  String get accountChangePassword => 'Jelszó módosítása';

  @override
  String get accountOldPassword => 'Jelenlegi jelszó';

  @override
  String get accountNewPassword => 'Új jelszó';

  @override
  String get accountDeleteAccount => 'Fiók törlése';

  @override
  String get accountDeleteWarning =>
      'Ez véglegesen törli a fiókját és az összes szinkronizált adatot. Ez nem vonható vissza.';

  @override
  String get accountLogout => 'Kijelentkezés';

  @override
  String get serverConfigTitle => 'Szerver konfiguráció';

  @override
  String get serverConfigUrlLabel => 'Szerver URL';

  @override
  String get serverConfigTest => 'Kapcsolat tesztelése';

  @override
  String get serverSetupTitle => 'Szerver beállítása';

  @override
  String get serverSetupInfoCard =>
      'A ShellVault saját szervert igényel a végponttól végpontig titkosított szinkronizáláshoz. Telepítse saját példányát a kezdéshez.';

  @override
  String get serverSetupRepoLink => 'Megtekintés a GitHubon';

  @override
  String get serverSetupContinue => 'Folytatás';

  @override
  String get settingsServerNotConfigured => 'Nincs szerver beállítva';

  @override
  String get settingsSetupSync =>
      'Szinkronizálás beállítása az adatok mentéséhez';

  @override
  String get settingsChangeServer => 'Szerver módosítása';

  @override
  String get settingsChangeServerConfirm =>
      'A szerver módosítása kijelentkezteti. Folytatja?';

  @override
  String get auditLogTitle => 'Tevékenységnapló';

  @override
  String get auditLogAll => 'Mind';

  @override
  String get auditLogEmpty => 'Nem találhatók tevékenységnaplók';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Fájlkezelő';

  @override
  String get sftpLocalDevice => 'Helyi eszköz';

  @override
  String get sftpSelectServer => 'Válasszon kiszolgálót...';

  @override
  String get sftpConnecting => 'Csatlakozás...';

  @override
  String get sftpEmptyDirectory => 'Ez a könyvtár üres';

  @override
  String get sftpNoConnection => 'Nincs csatlakoztatott szerver';

  @override
  String get sftpPathLabel => 'Útvonal';

  @override
  String get sftpUpload => 'Feltöltés';

  @override
  String get sftpDownload => 'Letöltés';

  @override
  String get sftpDelete => 'Törlés';

  @override
  String get sftpRename => 'Átnevezés';

  @override
  String get sftpNewFolder => 'Új mappa';

  @override
  String get sftpNewFolderName => 'Mappa neve';

  @override
  String get sftpChmod => 'Jogosultságok';

  @override
  String get sftpChmodTitle => 'Jogosultságok módosítása';

  @override
  String get sftpChmodOctal => 'Oktális';

  @override
  String get sftpChmodOwner => 'Tulajdonos';

  @override
  String get sftpChmodGroup => 'Csoport';

  @override
  String get sftpChmodOther => 'Egyéb';

  @override
  String get sftpChmodRead => 'Olvasás';

  @override
  String get sftpChmodWrite => 'Írás';

  @override
  String get sftpChmodExecute => 'Végrehajtás';

  @override
  String get sftpCreateSymlink => 'Szimbolikus link létrehozása';

  @override
  String get sftpSymlinkTarget => 'Cél útvonal';

  @override
  String get sftpSymlinkName => 'Link neve';

  @override
  String get sftpFilePreview => 'Fájl előnézet';

  @override
  String get sftpFileInfo => 'Fájl információ';

  @override
  String get sftpFileSize => 'Méret';

  @override
  String get sftpFileModified => 'Módosítva';

  @override
  String get sftpFilePermissions => 'Jogosultságok';

  @override
  String get sftpFileOwner => 'Tulajdonos';

  @override
  String get sftpFileType => 'Típus';

  @override
  String get sftpFileLinkTarget => 'Link célpontja';

  @override
  String get sftpTransfers => 'Átvitelek';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get sftpTransferQueued => 'Várólistán';

  @override
  String get sftpTransferActive => 'Átvitel folyamatban...';

  @override
  String get sftpTransferPaused => 'Szüneteltetve';

  @override
  String get sftpTransferCompleted => 'Befejezve';

  @override
  String get sftpTransferFailed => 'Sikertelen';

  @override
  String get sftpTransferCancelled => 'Megszakítva';

  @override
  String get sftpPauseTransfer => 'Szüneteltetés';

  @override
  String get sftpResumeTransfer => 'Folytatás';

  @override
  String get sftpCancelTransfer => 'Megszakítás';

  @override
  String get sftpClearCompleted => 'Befejezettek törlése';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active / $total átvitel';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktív',
      one: '1 aktív',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count befejezett',
      one: '1 befejezett',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sikertelen',
      one: '1 sikertelen',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Másolás a másik panelbe';

  @override
  String sftpConfirmDelete(int count) {
    return '$count elem törlése?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Törli a(z) \"$name\" fájlt?';
  }

  @override
  String get sftpDeleteSuccess => 'Sikeresen törölve';

  @override
  String get sftpRenameTitle => 'Átnevezés';

  @override
  String get sftpRenameLabel => 'Új név';

  @override
  String get sftpSortByName => 'Név';

  @override
  String get sftpSortBySize => 'Méret';

  @override
  String get sftpSortByDate => 'Dátum';

  @override
  String get sftpSortByType => 'Típus';

  @override
  String get sftpShowHidden => 'Rejtett fájlok megjelenítése';

  @override
  String get sftpHideHidden => 'Rejtett fájlok elrejtése';

  @override
  String get sftpSelectAll => 'Összes kijelölése';

  @override
  String get sftpDeselectAll => 'Kijelölés megszüntetése';

  @override
  String sftpItemsSelected(int count) {
    return '$count kijelölve';
  }

  @override
  String get sftpRefresh => 'Frissítés';

  @override
  String sftpConnectionError(String message) {
    return 'Csatlakozás sikertelen: $message';
  }

  @override
  String get sftpPermissionDenied => 'Hozzáférés megtagadva';

  @override
  String sftpOperationFailed(String message) {
    return 'Művelet sikertelen: $message';
  }

  @override
  String get sftpOverwriteTitle => 'A fájl már létezik';

  @override
  String sftpOverwriteMessage(String fileName) {
    return 'A(z) \"$fileName\" már létezik. Felülírja?';
  }

  @override
  String get sftpOverwrite => 'Felülírás';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Átvitel elindítva: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Először válasszon célhelyet a másik panelben';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Könyvtár átvitel hamarosan elérhető';

  @override
  String get sftpSelect => 'Kiválasztás';

  @override
  String get sftpOpen => 'Megnyitás';

  @override
  String get sftpExtractArchive => 'Kibontás ide';

  @override
  String get sftpExtractSuccess => 'Archívum kibontva';

  @override
  String sftpExtractFailed(String message) {
    return 'Kibontás sikertelen: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Nem támogatott archívum formátum';

  @override
  String get sftpExtracting => 'Kibontás...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count feltöltés elindítva',
      one: 'Feltöltés elindítva',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count letöltés elindítva',
      one: 'Letöltés elindítva',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" letöltve';
  }

  @override
  String get sftpSavedToDownloads => 'Mentve a Letöltések/SSHVault mappába';

  @override
  String get sftpSaveToFiles => 'Mentés a Fájlokba';

  @override
  String get sftpFileSaved => 'Fájl mentve';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH munkamenet aktív',
      one: 'SSH munkamenet aktív',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Koppintson a terminál megnyitásához';

  @override
  String get settingsAccountAndSync => 'Fiók és szinkronizálás';

  @override
  String get settingsAccountSubtitleAuth => 'Bejelentkezve';

  @override
  String get settingsAccountSubtitleUnauth => 'Nincs bejelentkezve';

  @override
  String get settingsSecuritySubtitle => 'Automatikus zárolás, biometria, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, felhasználó root';

  @override
  String get settingsAppearanceSubtitle => 'Téma, nyelv, terminál';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Titkosított export alapértelmezések';

  @override
  String get settingsAboutSubtitle => 'Verzió, licencek';

  @override
  String get settingsSearchHint => 'Beállítások keresése...';

  @override
  String get settingsSearchNoResults => 'Nem található beállítás';

  @override
  String get aboutDeveloper => 'Fejlesztő: Kiefer Networks';

  @override
  String get aboutDonate => 'Támogatás';

  @override
  String get aboutOpenSourceLicenses => 'Nyílt forráskódú licencek';

  @override
  String get aboutWebsite => 'Weboldal';

  @override
  String get aboutVersion => 'Verzió';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'A DNS-over-HTTPS titkosítja a DNS lekérdezéseket és megakadályozza a DNS hamisítást. Az SSHVault több szolgáltatónál ellenőrzi a gazdagépneveket a támadások észleléséhez.';

  @override
  String get settingsDnsAddServer => 'DNS szerver hozzáadása';

  @override
  String get settingsDnsServerUrl => 'Szerver URL';

  @override
  String get settingsDnsDefaultBadge => 'Alapértelmezett';

  @override
  String get settingsDnsResetDefaults => 'Alapértelmezések visszaállítása';

  @override
  String get settingsDnsInvalidUrl =>
      'Kérjük, adjon meg egy érvényes HTTPS URL-t';

  @override
  String get settingsDefaultAuthMethod => 'Hitelesítési módszer';

  @override
  String get settingsAuthPassword => 'Jelszó';

  @override
  String get settingsAuthKey => 'SSH kulcs';

  @override
  String get settingsConnectionTimeout => 'Csatlakozási időtúllépés';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds mp';
  }

  @override
  String get settingsKeepaliveInterval => 'Életben tartási intervallum';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds mp';
  }

  @override
  String get settingsCompression => 'Tömörítés';

  @override
  String get settingsCompressionDescription =>
      'Zlib tömörítés engedélyezése SSH kapcsolatokhoz';

  @override
  String get settingsTerminalType => 'Terminál típus';

  @override
  String get settingsSectionConnection => 'Kapcsolat';

  @override
  String get settingsClipboardAutoClear => 'Vágólap automatikus törlése';

  @override
  String get settingsClipboardAutoClearOff => 'Ki';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds mp';
  }

  @override
  String get settingsSessionTimeout => 'Munkamenet időtúllépés';

  @override
  String get settingsSessionTimeoutOff => 'Ki';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes perc';
  }

  @override
  String get settingsDuressPin => 'Kényszer PIN';

  @override
  String get settingsDuressPinDescription =>
      'Egy külön PIN, amelynek megadása törli az összes adatot';

  @override
  String get settingsDuressPinSet => 'A kényszer PIN be van állítva';

  @override
  String get settingsDuressPinNotSet => 'Nincs beállítva';

  @override
  String get settingsDuressPinWarning =>
      'Ennek a PIN-nek a megadása véglegesen törli az összes helyi adatot, beleértve a hitelesítő adatokat, kulcsokat és beállításokat. Ez nem vonható vissza.';

  @override
  String get settingsKeyRotationReminder => 'Kulcscsere emlékeztető';

  @override
  String get settingsKeyRotationOff => 'Ki';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days nap';
  }

  @override
  String get settingsFailedAttempts => 'Sikertelen PIN próbálkozások';

  @override
  String get settingsSectionAppLock => 'Alkalmazás zárolás';

  @override
  String get settingsSectionPrivacy => 'Adatvédelem';

  @override
  String get settingsSectionReminders => 'Emlékeztetők';

  @override
  String get settingsSectionStatus => 'Állapot';

  @override
  String get settingsExportBackupSubtitle =>
      'Exportálás, importálás és biztonsági mentés';

  @override
  String get settingsExportJson => 'Exportálás JSON formátumban';

  @override
  String get settingsExportEncrypted => 'Titkosított exportálás';

  @override
  String get settingsImportFile => 'Importálás fájlból';

  @override
  String get settingsSectionImport => 'Importálás';

  @override
  String get filterTitle => 'Kiszolgálók szűrése';

  @override
  String get filterApply => 'Szűrők alkalmazása';

  @override
  String get filterClearAll => 'Összes törlése';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktív szűrő',
      one: '1 aktív szűrő',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Mappa';

  @override
  String get filterTags => 'Címkék';

  @override
  String get filterStatus => 'Állapot';

  @override
  String get variablePreviewResolved => 'Feloldott előnézet';

  @override
  String get variableInsert => 'Beszúrás';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kiszolgáló',
      one: '1 kiszolgáló',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count munkamenet visszavonva.',
      one: '1 munkamenet visszavonva.',
    );
    return '$_temp0 Kijelentkezett.';
  }

  @override
  String get keyGenPassphrase => 'Jelmondat';

  @override
  String get keyGenPassphraseHint => 'Opcionális — védi a privát kulcsot';

  @override
  String get settingsDnsDefaultQuad9Mullvad =>
      'Alapértelmezett (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Egy azonos ujjlenyomatú kulcs már létezik: \"$name\". Minden SSH kulcsnak egyedinek kell lennie.';
  }

  @override
  String get sshKeyFingerprint => 'Ujjlenyomat';

  @override
  String get sshKeyPublicKey => 'Nyilvános kulcs';

  @override
  String get jumpHost => 'Jump Host';

  @override
  String get jumpHostNone => 'Nincs';

  @override
  String get jumpHostLabel => 'Csatlakozás jump hoston keresztül';

  @override
  String get jumpHostSelfError => 'Egy kiszolgáló nem lehet saját jump hostja';

  @override
  String get jumpHostConnecting => 'Csatlakozás a jump hosthoz…';

  @override
  String get jumpHostCircularError => 'Körkörös jump host lánc észlelve';

  @override
  String get logoutDialogTitle => 'Kijelentkezés';

  @override
  String get logoutDialogMessage =>
      'Törölni szeretné az összes helyi adatot? A kiszolgálók, SSH kulcsok, kódrészletek és beállítások eltávolításra kerülnek erről az eszközről.';

  @override
  String get logoutOnly => 'Csak kijelentkezés';

  @override
  String get logoutAndDelete => 'Kijelentkezés és adatok törlése';

  @override
  String get changeAvatar => 'Avatar módosítása';

  @override
  String get removeAvatar => 'Avatar eltávolítása';

  @override
  String get avatarUploadFailed => 'Az avatar feltöltése sikertelen';

  @override
  String get avatarTooLarge => 'A kép túl nagy';

  @override
  String get deviceLastSeen => 'Utoljára látva';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'A szerver URL nem módosítható bejelentkezve. Először jelentkezzen ki.';

  @override
  String get serverListNoFolder => 'Kategorizálatlan';

  @override
  String get autoSyncInterval => 'Szinkronizálási intervallum';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes perc';
  }

  @override
  String get proxySettings => 'Proxy beállítások';

  @override
  String get proxyType => 'Proxy típus';

  @override
  String get proxyNone => 'Nincs proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxy gazdagép';

  @override
  String get proxyPort => 'Proxy port';

  @override
  String get proxyUsername => 'Proxy felhasználónév';

  @override
  String get proxyPassword => 'Proxy jelszó';

  @override
  String get proxyUseGlobal => 'Globális proxy használata';

  @override
  String get proxyGlobal => 'Globális';

  @override
  String get proxyServerSpecific => 'Szerver-specifikus';

  @override
  String get proxyTestConnection => 'Kapcsolat tesztelése';

  @override
  String get proxyTestSuccess => 'Proxy elérhető';

  @override
  String get proxyTestFailed => 'Proxy nem elérhető';

  @override
  String get proxyDefaultProxy => 'Alapértelmezett proxy';

  @override
  String get vpnRequired => 'VPN szükséges';

  @override
  String get vpnRequiredTooltip =>
      'Figyelmeztetés megjelenítése aktív VPN nélküli csatlakozáskor';

  @override
  String get vpnActive => 'VPN aktív';

  @override
  String get vpnInactive => 'VPN inaktív';

  @override
  String get vpnWarningTitle => 'VPN nem aktív';

  @override
  String get vpnWarningMessage =>
      'Ez a kiszolgáló VPN kapcsolatot igényel, de jelenleg nincs aktív VPN. Szeretne mégis csatlakozni?';

  @override
  String get vpnConnectAnyway => 'Csatlakozás mindenképp';

  @override
  String get postConnectCommands => 'Csatlakozás utáni parancsok';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Csatlakozás után automatikusan végrehajtott parancsok (soronként egy)';

  @override
  String get dashboardFavorites => 'Kedvencek';

  @override
  String get dashboardRecent => 'Legutóbbi';

  @override
  String get dashboardActiveSessions => 'Aktív munkamenetek';

  @override
  String get addToFavorites => 'Hozzáadás a kedvencekhez';

  @override
  String get removeFromFavorites => 'Eltávolítás a kedvencekből';

  @override
  String get noRecentConnections => 'Nincsenek legutóbbi csatlakozások';

  @override
  String get terminalSplit => 'Osztott nézet';

  @override
  String get terminalUnsplit => 'Osztott nézet bezárása';

  @override
  String get terminalSelectSession =>
      'Válasszon munkamenetet az osztott nézethez';

  @override
  String get knownHostsTitle => 'Ismert gazdagépek';

  @override
  String get knownHostsSubtitle => 'Megbízható szerver ujjlenyomatok kezelése';

  @override
  String get hostKeyNewTitle => 'Új gazdagép';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Első csatlakozás a következőhöz: $hostname:$port. Ellenőrizze az ujjlenyomatot a csatlakozás előtt.';
  }

  @override
  String get hostKeyChangedTitle => 'A gazdagép kulcsa megváltozott!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'A(z) $hostname:$port gazdagép kulcsa megváltozott. Ez biztonsági fenyegetést jelezhet.';
  }

  @override
  String get hostKeyFingerprint => 'Ujjlenyomat';

  @override
  String get hostKeyType => 'Kulcstípus';

  @override
  String get hostKeyTrustConnect => 'Megbízás és csatlakozás';

  @override
  String get hostKeyAcceptNew => 'Új kulcs elfogadása';

  @override
  String get hostKeyReject => 'Elutasítás';

  @override
  String get hostKeyPreviousFingerprint => 'Előző ujjlenyomat';

  @override
  String get hostKeyDeleteAll => 'Összes ismert gazdagép törlése';

  @override
  String get hostKeyDeleteConfirm =>
      'Biztosan eltávolítja az összes ismert gazdagépet? A következő csatlakozáskor újra meg kell erősítenie.';

  @override
  String get hostKeyEmpty => 'Még nincsenek ismert gazdagépek';

  @override
  String get hostKeyEmptySubtitle =>
      'A gazdagép ujjlenyomatok az első csatlakozás után itt lesznek tárolva';

  @override
  String get hostKeyFirstSeen => 'Először látva';

  @override
  String get hostKeyLastSeen => 'Utoljára látva';

  @override
  String get sshConfigImportTitle => 'SSH konfiguráció importálása';

  @override
  String get sshConfigImportPickFile => 'SSH konfigurációs fájl kiválasztása';

  @override
  String get sshConfigImportOrPaste => 'Vagy illessze be a konfigurációt';

  @override
  String sshConfigImportParsed(int count) {
    return '$count gazdagép található';
  }

  @override
  String get sshConfigImportButton => 'Kiválasztottak importálása';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count kiszolgáló importálva';
  }

  @override
  String get sshConfigImportDuplicate => 'Már létezik';

  @override
  String get sshConfigImportNoHosts =>
      'Nem találhatók gazdagépek a konfigurációban';

  @override
  String get sftpBookmarkAdd => 'Könyvjelző hozzáadása';

  @override
  String get sftpBookmarkLabel => 'Címke';

  @override
  String get disconnect => 'Lecsatlakozás';

  @override
  String get reportAndDisconnect => 'Jelentés és lecsatlakozás';

  @override
  String get continueAnyway => 'Folytatás mindenképp';

  @override
  String get insertSnippet => 'Kódrészlet beszúrása';

  @override
  String get seconds => 'Másodperc';

  @override
  String get heartbeatLostMessage =>
      'A szerver több próbálkozás után sem volt elérhető. Az Ön biztonsága érdekében a munkamenet lezárásra került.';

  @override
  String get attestationFailedTitle => 'Szerver ellenőrzés sikertelen';

  @override
  String get attestationFailedMessage =>
      'A szerver nem igazolható hiteles SSHVault háttérrendszerként. Ez közbeékelődéses támadást vagy rosszul konfigurált szervert jelezhet.';

  @override
  String get attestationKeyChangedTitle => 'A szerver kulcsa megváltozott';

  @override
  String get attestationKeyChangedMessage =>
      'A szerver tanúsító kulcsa megváltozott a kezdeti csatlakozás óta. Ez közbeékelődéses támadást jelezhet. NE folytassa, hacsak a szerver rendszergazda nem erősítette meg a kulcscserét.';

  @override
  String get sectionLinks => 'Linkek';

  @override
  String get sectionDeveloper => 'Fejlesztő';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Az oldal nem található';

  @override
  String get connectionTestSuccess => 'Csatlakozás sikeres';

  @override
  String connectionTestFailed(String message) {
    return 'Csatlakozás sikertelen: $message';
  }

  @override
  String get serverVerificationFailed => 'Szerver ellenőrzés sikertelen';

  @override
  String get importSuccessful => 'Importálás sikeres';

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
  String get deviceDeleteConfirmTitle => 'Eszköz eltávolítása';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Biztosan el szeretnéd távolítani a(z) \"$name\" eszközt? Az eszköz azonnal kijelentkezik.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Ez a jelenlegi eszközöd. Azonnal kijelentkezel.';

  @override
  String get deviceDeleteSuccess => 'Eszköz eltávolítva';

  @override
  String get deviceDeletedCurrentLogout =>
      'Jelenlegi eszköz eltávolítva. Kijelentkeztél.';

  @override
  String get thisDevice => 'Ez az eszköz';
}
