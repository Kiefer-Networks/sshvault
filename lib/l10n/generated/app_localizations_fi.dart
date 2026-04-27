// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Palvelimet';

  @override
  String get navSnippets => 'Koodinpätkät';

  @override
  String get navFolders => 'Kansiot';

  @override
  String get navTags => 'Tunnisteet';

  @override
  String get navSshKeys => 'SSH-avaimet';

  @override
  String get navExportImport => 'Vienti / Tuonti';

  @override
  String get navTerminal => 'Terminaali';

  @override
  String get navMore => 'Lisää';

  @override
  String get navManagement => 'Hallinta';

  @override
  String get navSettings => 'Asetukset';

  @override
  String get navAbout => 'Tietoja';

  @override
  String get lockScreenTitle => 'SSHVault on lukittu';

  @override
  String get lockScreenUnlock => 'Avaa lukitus';

  @override
  String get lockScreenEnterPin => 'Syötä PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Liian monta epäonnistunutta yritystä. Yritä uudelleen $minutes min kuluttua.';
  }

  @override
  String get pinDialogSetTitle => 'Aseta PIN-koodi';

  @override
  String get pinDialogSetSubtitle =>
      'Syötä 6-numeroinen PIN suojataksesi SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Vahvista PIN';

  @override
  String get pinDialogErrorLength =>
      'PIN-koodin on oltava täsmälleen 6 numeroa';

  @override
  String get pinDialogErrorMismatch => 'PIN-koodit eivät täsmää';

  @override
  String get pinDialogVerifyTitle => 'Syötä PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Väärä PIN. $attempts yritystä jäljellä.';
  }

  @override
  String get securityBannerMessage =>
      'SSH-tunnuksiasi ei ole suojattu. Aseta PIN tai biometrinen lukitus asetuksissa.';

  @override
  String get securityBannerDismiss => 'Ohita';

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get settingsSectionAppearance => 'Ulkoasu';

  @override
  String get settingsSectionTerminal => 'Terminaali';

  @override
  String get settingsSectionSshDefaults => 'SSH-oletukset';

  @override
  String get settingsSectionSecurity => 'Turvallisuus';

  @override
  String get settingsSectionExport => 'Vienti';

  @override
  String get settingsSectionAbout => 'Tietoja';

  @override
  String get settingsTheme => 'Teema';

  @override
  String get settingsThemeSystem => 'Järjestelmä';

  @override
  String get settingsThemeLight => 'Vaalea';

  @override
  String get settingsThemeDark => 'Tumma';

  @override
  String get settingsTerminalTheme => 'Terminaalin teema';

  @override
  String get settingsTerminalThemeDefault => 'Oletus tumma';

  @override
  String get settingsFontSize => 'Fonttikoko';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Oletusportti';

  @override
  String get settingsDefaultPortDialog => 'SSH-oletusportti';

  @override
  String get settingsPortLabel => 'Portti';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Oletuskäyttäjänimi';

  @override
  String get settingsDefaultUsernameDialog => 'Oletuskäyttäjänimi';

  @override
  String get settingsUsernameLabel => 'Käyttäjänimi';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automaattinen lukitus';

  @override
  String get settingsAutoLockDisabled => 'Pois käytöstä';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minuuttia';
  }

  @override
  String get settingsAutoLockOff => 'Pois';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Biometrinen lukituksen avaus';

  @override
  String get settingsBiometricNotAvailable =>
      'Ei käytettävissä tällä laitteella';

  @override
  String get settingsBiometricError => 'Virhe biometriikan tarkistuksessa';

  @override
  String get settingsBiometricReason =>
      'Vahvista henkilöllisyytesi ottaaksesi biometrisen lukituksen avauksen käyttöön';

  @override
  String get settingsBiometricRequiresPin =>
      'Aseta ensin PIN ottaaksesi biometrisen lukituksen avauksen käyttöön';

  @override
  String get settingsPinCode => 'PIN-koodi';

  @override
  String get settingsPinIsSet => 'PIN on asetettu';

  @override
  String get settingsPinNotConfigured => 'PIN ei ole määritetty';

  @override
  String get settingsPinRemove => 'Poista';

  @override
  String get settingsPinRemoveWarning =>
      'PIN-koodin poistaminen purkaa kaikkien tietokantakenttien salauksen ja poistaa biometrisen lukituksen avauksen käytöstä. Jatketaanko?';

  @override
  String get settingsPinRemoveTitle => 'Poista PIN';

  @override
  String get settingsPreventScreenshots => 'Estä kuvakaappaukset';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Estä kuvakaappaukset ja näytön tallennus';

  @override
  String get settingsEncryptExport => 'Salaa viennit oletuksena';

  @override
  String get settingsAbout => 'Tietoja SSHVault';

  @override
  String get settingsAboutLegalese => 'Kiefer Networks';

  @override
  String get settingsAboutDescription =>
      'Turvallinen, itse ylläpidetty SSH-asiakasohjelma';

  @override
  String get settingsLanguage => 'Kieli';

  @override
  String get settingsLanguageSystem => 'Järjestelmä';

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
  String get cancel => 'Peruuta';

  @override
  String get save => 'Tallenna';

  @override
  String get delete => 'Poista';

  @override
  String get close => 'Sulje';

  @override
  String get update => 'Päivitä';

  @override
  String get create => 'Luo';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get copy => 'Kopioi';

  @override
  String get edit => 'Muokkaa';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Virhe: $message';
  }

  @override
  String get serverListTitle => 'Palvelimet';

  @override
  String get serverListEmpty => 'Ei palvelimia vielä';

  @override
  String get serverListEmptySubtitle =>
      'Lisää ensimmäinen SSH-palvelimesi aloittaaksesi.';

  @override
  String get serverAddButton => 'Lisää palvelin';

  @override
  String sshConfigImportMessage(int count) {
    return 'Löydettiin $count palvelin(ta) tiedostosta ~/.ssh/config. Tuodaanko ne?';
  }

  @override
  String get sshConfigNotFound => 'SSH-asetustiedostoa ei löytynyt';

  @override
  String get sshConfigEmpty => 'SSH-asetuksista ei löytynyt palvelimia';

  @override
  String get sshConfigAddManually => 'Lisää manuaalisesti';

  @override
  String get sshConfigImportAgain => 'Tuodaanko SSH-asetukset uudelleen?';

  @override
  String get sshConfigImportKeys =>
      'Tuodaanko valittujen palvelimien SSH-avaimet?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH-avain(ta) tuotu';
  }

  @override
  String get serverDuplicated => 'Palvelin monistettu';

  @override
  String get serverDeleteTitle => 'Poista palvelin';

  @override
  String serverDeleteMessage(String name) {
    return 'Haluatko varmasti poistaa palvelimen \"$name\"? Tätä toimintoa ei voi kumota.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Poistetaanko \"$name\"?';
  }

  @override
  String get serverConnect => 'Yhdistä';

  @override
  String get serverDetails => 'Tiedot';

  @override
  String get serverDuplicate => 'Monista';

  @override
  String get serverActive => 'Aktiivinen';

  @override
  String get serverNoFolder => 'Ei kansiota';

  @override
  String get serverFormTitleEdit => 'Muokkaa palvelinta';

  @override
  String get serverFormTitleAdd => 'Lisää palvelin';

  @override
  String get serverSaved => 'Palvelin tallennettu';

  @override
  String get serverFormUpdateButton => 'Päivitä palvelin';

  @override
  String get serverFormAddButton => 'Lisää palvelin';

  @override
  String get serverFormPublicKeyExtracted =>
      'Julkinen avain purettu onnistuneesti';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Julkista avainta ei voitu purkaa: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type-avainpari luotu';
  }

  @override
  String get serverDetailTitle => 'Palvelimen tiedot';

  @override
  String get serverDetailDeleteMessage => 'Tätä toimintoa ei voi kumota.';

  @override
  String get serverDetailConnection => 'Yhteys';

  @override
  String get serverDetailHost => 'Palvelin';

  @override
  String get serverDetailPort => 'Portti';

  @override
  String get serverDetailUsername => 'Käyttäjänimi';

  @override
  String get serverDetailFolder => 'Kansio';

  @override
  String get serverDetailTags => 'Tunnisteet';

  @override
  String get serverDetailNotes => 'Muistiinpanot';

  @override
  String get serverDetailInfo => 'Tiedot';

  @override
  String get serverDetailCreated => 'Luotu';

  @override
  String get serverDetailUpdated => 'Päivitetty';

  @override
  String get serverDetailDistro => 'Järjestelmä';

  @override
  String get copiedToClipboard => 'Kopioitu leikepöydälle';

  @override
  String get serverFormNameLabel => 'Palvelimen nimi';

  @override
  String get serverFormHostnameLabel => 'Palvelinnimi / IP';

  @override
  String get serverFormPortLabel => 'Portti';

  @override
  String get serverFormUsernameLabel => 'Käyttäjänimi';

  @override
  String get serverFormPasswordLabel => 'Salasana';

  @override
  String get serverFormUseManagedKey => 'Käytä hallittua avainta';

  @override
  String get serverFormManagedKeySubtitle =>
      'Valitse keskitetysti hallituista SSH-avaimista';

  @override
  String get serverFormDirectKeySubtitle =>
      'Liitä avain suoraan tähän palvelimeen';

  @override
  String get serverFormGenerateKey => 'Luo SSH-avainpari';

  @override
  String get serverFormPrivateKeyLabel => 'Yksityinen avain';

  @override
  String get serverFormPrivateKeyHint => 'Liitä SSH-yksityinen avain...';

  @override
  String get serverFormExtractPublicKey => 'Pura julkinen avain';

  @override
  String get serverFormPublicKeyLabel => 'Julkinen avain';

  @override
  String get serverFormPublicKeyHint =>
      'Luodaan automaattisesti yksityisestä avaimesta, jos tyhjä';

  @override
  String get serverFormPassphraseLabel => 'Avaimen tunnuslause (valinnainen)';

  @override
  String get serverFormNotesLabel => 'Muistiinpanot (valinnainen)';

  @override
  String get searchServers => 'Hae palvelimia...';

  @override
  String get filterAllFolders => 'Kaikki kansiot';

  @override
  String get filterAll => 'Kaikki';

  @override
  String get filterActive => 'Aktiiviset';

  @override
  String get filterInactive => 'Ei-aktiiviset';

  @override
  String get filterClear => 'Tyhjennä';

  @override
  String get folderListTitle => 'Kansiot';

  @override
  String get folderListEmpty => 'Ei kansioita vielä';

  @override
  String get folderListEmptySubtitle =>
      'Luo kansioita järjestääksesi palvelimesi.';

  @override
  String get folderAddButton => 'Lisää kansio';

  @override
  String get folderDeleteTitle => 'Poista kansio';

  @override
  String folderDeleteMessage(String name) {
    return 'Poistetaanko \"$name\"? Palvelimet jäävät järjestämättömiksi.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palvelinta',
      one: '1 palvelin',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Pienennä';

  @override
  String get folderShowHosts => 'Näytä palvelimet';

  @override
  String get folderConnectAll => 'Yhdistä kaikki';

  @override
  String get folderFormTitleEdit => 'Muokkaa kansiota';

  @override
  String get folderFormTitleNew => 'Uusi kansio';

  @override
  String get folderFormNameLabel => 'Kansion nimi';

  @override
  String get folderFormParentLabel => 'Yläkansio';

  @override
  String get folderFormParentNone => 'Ei (juuri)';

  @override
  String get tagListTitle => 'Tunnisteet';

  @override
  String get tagListEmpty => 'Ei tunnisteita vielä';

  @override
  String get tagListEmptySubtitle =>
      'Luo tunnisteita palvelimien merkitsemiseen ja suodattamiseen.';

  @override
  String get tagAddButton => 'Lisää tunniste';

  @override
  String get tagDeleteTitle => 'Poista tunniste';

  @override
  String tagDeleteMessage(String name) {
    return 'Poistetaanko \"$name\"? Se poistetaan kaikilta palvelimilta.';
  }

  @override
  String get tagFormTitleEdit => 'Muokkaa tunnistetta';

  @override
  String get tagFormTitleNew => 'Uusi tunniste';

  @override
  String get tagFormNameLabel => 'Tunnisteen nimi';

  @override
  String get sshKeyListTitle => 'SSH-avaimet';

  @override
  String get sshKeyListEmpty => 'Ei SSH-avaimia vielä';

  @override
  String get sshKeyListEmptySubtitle =>
      'Luo tai tuo SSH-avaimia hallitaksesi niitä keskitetysti';

  @override
  String get sshKeyCannotDeleteTitle => 'Ei voi poistaa';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Avainta \"$name\" ei voi poistaa. Käytössä $count palvelime(lla). Poista linkitys kaikilta palvelimilta ensin.';
  }

  @override
  String get sshKeyDeleteTitle => 'Poista SSH-avain';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Poistetaanko \"$name\"? Tätä ei voi kumota.';
  }

  @override
  String get sshKeyAddButton => 'Lisää SSH-avain';

  @override
  String get sshKeyFormTitleEdit => 'Muokkaa SSH-avainta';

  @override
  String get sshKeyFormTitleAdd => 'Lisää SSH-avain';

  @override
  String get sshKeyFormTabGenerate => 'Luo';

  @override
  String get sshKeyFormTabImport => 'Tuo';

  @override
  String get sshKeyFormNameLabel => 'Avaimen nimi';

  @override
  String get sshKeyFormNameHint => 'esim. Tuotantoavain';

  @override
  String get sshKeyFormKeyType => 'Avaintyyppi';

  @override
  String get sshKeyFormKeySize => 'Avaimen koko';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bittiä';
  }

  @override
  String get sshKeyFormCommentLabel => 'Kommentti';

  @override
  String get sshKeyFormCommentHint => 'käyttäjä@palvelin tai kuvaus';

  @override
  String get sshKeyFormCommentOptional => 'Kommentti (valinnainen)';

  @override
  String get sshKeyFormImportFromFile => 'Tuo tiedostosta';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Yksityinen avain';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Liitä SSH-yksityinen avain tai käytä yllä olevaa painiketta...';

  @override
  String get sshKeyFormPassphraseLabel => 'Tunnuslause (valinnainen)';

  @override
  String get sshKeyFormNameRequired => 'Nimi on pakollinen';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Yksityinen avain on pakollinen';

  @override
  String get sshKeyFormFileReadError => 'Valittua tiedostoa ei voitu lukea';

  @override
  String get sshKeyFormInvalidFormat =>
      'Virheellinen avaintiedosto — odotettiin PEM-muoto (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Tiedoston lukeminen epäonnistui: $message';
  }

  @override
  String get sshKeyFormSaving => 'Tallennetaan...';

  @override
  String get sshKeySelectorLabel => 'SSH-avain';

  @override
  String get sshKeySelectorNone => 'Ei hallittua avainta';

  @override
  String get sshKeySelectorManage => 'Hallitse avaimia...';

  @override
  String get sshKeySelectorError => 'SSH-avainten lataaminen epäonnistui';

  @override
  String get sshKeyTileCopyPublicKey => 'Kopioi julkinen avain';

  @override
  String get sshKeyTilePublicKeyCopied => 'Julkinen avain kopioitu';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Käytössä $count palvelime(lla)';
  }

  @override
  String get sshKeySavedSuccess => 'SSH-avain tallennettu';

  @override
  String get sshKeyDeletedSuccess => 'SSH-avain poistettu';

  @override
  String get tagSavedSuccess => 'Tunniste tallennettu';

  @override
  String get tagDeletedSuccess => 'Tunniste poistettu';

  @override
  String get folderDeletedSuccess => 'Kansio poistettu';

  @override
  String get sshKeyTileUnlinkFirst =>
      'Poista linkitys kaikilta palvelimilta ensin';

  @override
  String get exportImportTitle => 'Vienti / Tuonti';

  @override
  String get exportSectionTitle => 'Vienti';

  @override
  String get exportJsonButton => 'Vie JSON-muodossa (ilman tunnuksia)';

  @override
  String get exportZipButton => 'Vie salattu ZIP (tunnuksilla)';

  @override
  String get importSectionTitle => 'Tuonti';

  @override
  String get importButton => 'Tuo tiedostosta';

  @override
  String get importSupportedFormats =>
      'Tukee JSON- (selkoteksti) ja ZIP-tiedostoja (salattu).';

  @override
  String exportedTo(String path) {
    return 'Viety kohteeseen: $path';
  }

  @override
  String get share => 'Jaa';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Tuotu $servers palvelinta, $groups ryhmää, $tags tunnistetta. $skipped ohitettu.';
  }

  @override
  String get importPasswordTitle => 'Syötä salasana';

  @override
  String get importPasswordLabel => 'Viennin salasana';

  @override
  String get importPasswordDecrypt => 'Pura salaus';

  @override
  String get exportPasswordTitle => 'Aseta viennin salasana';

  @override
  String get exportPasswordDescription =>
      'Tällä salasanalla salataan vientitiedosto tunnuksineen.';

  @override
  String get exportPasswordLabel => 'Salasana';

  @override
  String get exportPasswordConfirmLabel => 'Vahvista salasana';

  @override
  String get exportPasswordMismatch => 'Salasanat eivät täsmää';

  @override
  String get exportPasswordButton => 'Salaa ja vie';

  @override
  String get importConflictTitle => 'Käsittele ristiriidat';

  @override
  String get importConflictDescription =>
      'Miten olemassa olevat merkinnät käsitellään tuonnissa?';

  @override
  String get importConflictSkip => 'Ohita olemassa olevat';

  @override
  String get importConflictRename => 'Nimeä uudet uudelleen';

  @override
  String get importConflictOverwrite => 'Korvaa';

  @override
  String get confirmDeleteLabel => 'Poista';

  @override
  String get keyGenTitle => 'Luo SSH-avainpari';

  @override
  String get keyGenKeyType => 'Avaintyyppi';

  @override
  String get keyGenKeySize => 'Avaimen koko';

  @override
  String get keyGenComment => 'Kommentti';

  @override
  String get keyGenCommentHint => 'käyttäjä@palvelin tai kuvaus';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bittiä';
  }

  @override
  String get keyGenGenerating => 'Luodaan...';

  @override
  String get keyGenGenerate => 'Luo';

  @override
  String keyGenResultTitle(String type) {
    return '$type-avain luotu';
  }

  @override
  String get keyGenPublicKey => 'Julkinen avain';

  @override
  String get keyGenPrivateKey => 'Yksityinen avain';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Kommentti: $comment';
  }

  @override
  String get keyGenAnother => 'Luo toinen';

  @override
  String get keyGenUseThisKey => 'Käytä tätä avainta';

  @override
  String get keyGenCopyTooltip => 'Kopioi leikepöydälle';

  @override
  String keyGenCopied(String label) {
    return '$label kopioitu';
  }

  @override
  String get colorPickerLabel => 'Väri';

  @override
  String get iconPickerLabel => 'Kuvake';

  @override
  String get tagSelectorLabel => 'Tunnisteet';

  @override
  String get tagSelectorEmpty => 'Ei tunnisteita vielä';

  @override
  String get tagSelectorError => 'Tunnisteiden lataaminen epäonnistui';

  @override
  String get snippetListTitle => 'Koodinpätkät';

  @override
  String get snippetSearchHint => 'Hae koodinpätkiä...';

  @override
  String get snippetListEmpty => 'Ei koodinpätkiä vielä';

  @override
  String get snippetListEmptySubtitle =>
      'Luo uudelleenkäytettäviä koodinpätkiä ja komentoja.';

  @override
  String get snippetAddButton => 'Lisää koodinpätkä';

  @override
  String get snippetDeleteTitle => 'Poista koodinpätkä';

  @override
  String snippetDeleteMessage(String name) {
    return 'Poistetaanko \"$name\"? Tätä ei voi kumota.';
  }

  @override
  String get snippetFormTitleEdit => 'Muokkaa koodinpätkää';

  @override
  String get snippetFormTitleNew => 'Uusi koodinpätkä';

  @override
  String get snippetFormNameLabel => 'Nimi';

  @override
  String get snippetFormNameHint => 'esim. Docker-siivous';

  @override
  String get snippetFormLanguageLabel => 'Kieli';

  @override
  String get snippetFormContentLabel => 'Sisältö';

  @override
  String get snippetFormContentHint => 'Kirjoita koodinpätkäsi...';

  @override
  String get snippetFormDescriptionLabel => 'Kuvaus';

  @override
  String get snippetFormDescriptionHint => 'Valinnainen kuvaus...';

  @override
  String get snippetFormFolderLabel => 'Kansio';

  @override
  String get snippetFormNoFolder => 'Ei kansiota';

  @override
  String get snippetFormNameRequired => 'Nimi on pakollinen';

  @override
  String get snippetFormContentRequired => 'Sisältö on pakollinen';

  @override
  String get snippetFormSaved => 'Snippet tallennettu';

  @override
  String get snippetFormUpdateButton => 'Päivitä koodinpätkä';

  @override
  String get snippetFormCreateButton => 'Luo koodinpätkä';

  @override
  String get snippetDetailTitle => 'Koodinpätkän tiedot';

  @override
  String get snippetDetailDeleteTitle => 'Poista koodinpätkä';

  @override
  String get snippetDetailDeleteMessage => 'Tätä toimintoa ei voi kumota.';

  @override
  String get snippetDetailContent => 'Sisältö';

  @override
  String get snippetDetailFillVariables => 'Täytä muuttujat';

  @override
  String get snippetDetailDescription => 'Kuvaus';

  @override
  String get snippetDetailVariables => 'Muuttujat';

  @override
  String get snippetDetailTags => 'Tunnisteet';

  @override
  String get snippetDetailInfo => 'Tiedot';

  @override
  String get snippetDetailCreated => 'Luotu';

  @override
  String get snippetDetailUpdated => 'Päivitetty';

  @override
  String get variableEditorTitle => 'Mallimuuttujat';

  @override
  String get variableEditorAdd => 'Lisää';

  @override
  String get variableEditorEmpty =>
      'Ei muuttujia. Käytä aaltosulkusyntaksia sisällössä viitataksesi niihin.';

  @override
  String get variableEditorNameLabel => 'Nimi';

  @override
  String get variableEditorNameHint => 'esim. palvelinnimi';

  @override
  String get variableEditorDefaultLabel => 'Oletus';

  @override
  String get variableEditorDefaultHint => 'valinnainen';

  @override
  String get variableFillTitle => 'Täytä muuttujat';

  @override
  String variableFillHint(String name) {
    return 'Syötä arvo muuttujalle $name';
  }

  @override
  String get variableFillPreview => 'Esikatselu';

  @override
  String get terminalTitle => 'Terminaali';

  @override
  String get terminalEmpty => 'Ei aktiivisia istuntoja';

  @override
  String get terminalEmptySubtitle =>
      'Yhdistä palvelimeen avataksesi terminaali-istunnon.';

  @override
  String get terminalGoToHosts => 'Siirry palvelimiin';

  @override
  String get terminalCloseAll => 'Sulje kaikki istunnot';

  @override
  String get terminalCloseTitle => 'Sulje istunto';

  @override
  String terminalCloseMessage(String title) {
    return 'Suljetaanko aktiivinen yhteys palvelimeen \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Tunnistaudutaan...';

  @override
  String connectionConnecting(String name) {
    return 'Yhdistetään palvelimeen $name...';
  }

  @override
  String get connectionError => 'Yhteysvirhe';

  @override
  String get connectionLost => 'Yhteys katkennut';

  @override
  String get connectionReconnect => 'Yhdistä uudelleen';

  @override
  String get snippetQuickPanelTitle => 'Lisää koodinpätkä';

  @override
  String get snippetQuickPanelSearch => 'Hae koodinpätkiä...';

  @override
  String get snippetQuickPanelEmpty => 'Ei koodinpätkiä saatavilla';

  @override
  String get snippetQuickPanelNoMatch => 'Ei vastaavia koodinpätkiä';

  @override
  String get snippetQuickPanelInsertTooltip => 'Lisää koodinpätkä';

  @override
  String get terminalThemePickerTitle => 'Terminaalin teema';

  @override
  String get validatorHostnameRequired => 'Palvelinnimi on pakollinen';

  @override
  String get validatorHostnameInvalid =>
      'Virheellinen palvelinnimi tai IP-osoite';

  @override
  String get validatorPortRequired => 'Portti on pakollinen';

  @override
  String get validatorPortRange => 'Portin on oltava välillä 1–65535';

  @override
  String get validatorUsernameRequired => 'Käyttäjänimi on pakollinen';

  @override
  String get validatorUsernameInvalid => 'Virheellinen käyttäjänimen muoto';

  @override
  String get validatorServerNameRequired => 'Palvelimen nimi on pakollinen';

  @override
  String get validatorServerNameLength =>
      'Palvelimen nimi saa olla enintään 100 merkkiä';

  @override
  String get validatorSshKeyInvalid => 'Virheellinen SSH-avaimen muoto';

  @override
  String get validatorPasswordRequired => 'Salasana on pakollinen';

  @override
  String get validatorPasswordLength =>
      'Salasanan on oltava vähintään 8 merkkiä';

  @override
  String get authMethodPassword => 'Salasana';

  @override
  String get authMethodKey => 'SSH-avain';

  @override
  String get authMethodBoth => 'Salasana + avain';

  @override
  String get serverCopySuffix => '(Kopio)';

  @override
  String get settingsDownloadLogs => 'Lataa lokit';

  @override
  String get settingsSendLogs => 'Lähetä lokit tukeen';

  @override
  String get settingsLogsSaved => 'Lokit tallennettu onnistuneesti';

  @override
  String get settingsUpdated => 'Asetus päivitetty';

  @override
  String get settingsThemeChanged => 'Teema vaihdettu';

  @override
  String get settingsLanguageChanged => 'Kieli vaihdettu';

  @override
  String get settingsPinSetSuccess => 'PIN asetettu';

  @override
  String get settingsPinRemovedSuccess => 'PIN poistettu';

  @override
  String get settingsDuressPinSetSuccess => 'Hätä-PIN asetettu';

  @override
  String get settingsDuressPinRemovedSuccess => 'Hätä-PIN poistettu';

  @override
  String get settingsBiometricEnabled => 'Biometrinen avaus käytössä';

  @override
  String get settingsBiometricDisabled => 'Biometrinen avaus pois käytöstä';

  @override
  String get settingsDnsServerAdded => 'DNS-palvelin lisätty';

  @override
  String get settingsDnsServerRemoved => 'DNS-palvelin poistettu';

  @override
  String get settingsDnsResetSuccess => 'DNS-palvelimet palautettu';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Pienennä fonttia';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Suurenna fonttia';

  @override
  String get settingsDnsRemoveServerTooltip => 'Poista DNS-palvelin';

  @override
  String get settingsLogsEmpty => 'Ei lokimerkintöjä saatavilla';

  @override
  String get authLogin => 'Kirjaudu sisään';

  @override
  String get authRegister => 'Rekisteröidy';

  @override
  String get authForgotPassword => 'Unohtuiko salasana?';

  @override
  String get authWhyLogin =>
      'Kirjaudu sisään ottaaksesi käyttöön salatun pilvisynkronoinnin kaikilla laitteillasi. Sovellus toimii täysin offline-tilassa ilman tiliä.';

  @override
  String get authEmailLabel => 'Sähköposti';

  @override
  String get authEmailRequired => 'Sähköposti on pakollinen';

  @override
  String get authEmailInvalid => 'Virheellinen sähköpostiosoite';

  @override
  String get authPasswordLabel => 'Salasana';

  @override
  String get authConfirmPasswordLabel => 'Vahvista salasana';

  @override
  String get authPasswordMismatch => 'Salasanat eivät täsmää';

  @override
  String get authNoAccount => 'Ei tiliä?';

  @override
  String get authHasAccount => 'Onko sinulla jo tili?';

  @override
  String get authResetEmailSent =>
      'Jos tili on olemassa, salasanan palautuslinkki on lähetetty sähköpostiisi.';

  @override
  String get authResetDescription =>
      'Syötä sähköpostiosoitteesi, niin lähetämme sinulle linkin salasanan palauttamiseksi.';

  @override
  String get authSendResetLink => 'Lähetä palautuslinkki';

  @override
  String get authBackToLogin => 'Takaisin kirjautumiseen';

  @override
  String get syncPasswordTitle => 'Synkronointisalasana';

  @override
  String get syncPasswordTitleCreate => 'Aseta synkronointisalasana';

  @override
  String get syncPasswordTitleEnter => 'Syötä synkronointisalasana';

  @override
  String get syncPasswordDescription =>
      'Aseta erillinen salasana holvitietojesi salaamiseen. Tämä salasana ei koskaan poistu laitteeltasi — palvelin tallentaa vain salatut tiedot.';

  @override
  String get syncPasswordHintEnter =>
      'Syötä salasana, jonka asetit tilin luomisen yhteydessä.';

  @override
  String get syncPasswordWarning =>
      'Jos unohdat tämän salasanan, synkronoituja tietojasi ei voi palauttaa. Palautusmahdollisuutta ei ole.';

  @override
  String get syncPasswordLabel => 'Synkronointisalasana';

  @override
  String get syncPasswordWrong => 'Väärä salasana. Yritä uudelleen.';

  @override
  String get firstSyncTitle => 'Olemassa olevat tiedot löydetty';

  @override
  String get firstSyncMessage =>
      'Tällä laitteella on olemassa olevia tietoja ja palvelimella on holvi. Miten jatketaan?';

  @override
  String get firstSyncMerge => 'Yhdistä (palvelin voittaa)';

  @override
  String get firstSyncOverwriteLocal => 'Korvaa paikalliset tiedot';

  @override
  String get firstSyncKeepLocal => 'Pidä paikalliset ja lähetä';

  @override
  String get firstSyncDeleteLocal => 'Poista paikalliset ja nouda';

  @override
  String get changeEncryptionPassword => 'Vaihda salaussalasana';

  @override
  String get changeEncryptionWarning =>
      'Sinut kirjataan ulos kaikilta muilta laitteilta.';

  @override
  String get changeEncryptionOldPassword => 'Nykyinen salasana';

  @override
  String get changeEncryptionNewPassword => 'Uusi salasana';

  @override
  String get changeEncryptionSuccess => 'Salasana vaihdettu onnistuneesti.';

  @override
  String get logoutAllDevices => 'Kirjaudu ulos kaikilta laitteilta';

  @override
  String get logoutAllDevicesConfirm =>
      'Tämä peruu kaikki aktiiviset istunnot. Sinun on kirjauduttava uudelleen kaikilla laitteilla.';

  @override
  String get logoutAllDevicesSuccess => 'Kaikki laitteet kirjattu ulos.';

  @override
  String get syncSettingsTitle => 'Synkronointiasetukset';

  @override
  String get syncAutoSync => 'Automaattinen synkronointi';

  @override
  String get syncAutoSyncDescription =>
      'Synkronoi automaattisesti sovelluksen käynnistyessä';

  @override
  String get syncNow => 'Synkronoi nyt';

  @override
  String get syncSyncing => 'Synkronoidaan...';

  @override
  String get syncSuccess => 'Synkronointi valmis';

  @override
  String get syncError => 'Synkronointivirhe';

  @override
  String get syncServerUnreachable => 'Palvelin ei ole tavoitettavissa';

  @override
  String get syncServerUnreachableHint =>
      'Synkronointipalvelinta ei saatu yhteyttä. Tarkista internet-yhteytesi ja palvelimen URL.';

  @override
  String get syncNetworkError =>
      'Yhteys palvelimeen epäonnistui. Tarkista internet-yhteytesi tai yritä myöhemmin uudelleen.';

  @override
  String get syncNeverSynced => 'Ei koskaan synkronoitu';

  @override
  String get syncVaultVersion => 'Holvin versio';

  @override
  String get syncTitle => 'Synkronointi';

  @override
  String get settingsSectionNetwork => 'Verkko ja DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS-palvelimet';

  @override
  String get settingsDnsDefault => 'Oletus (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Syötä mukautetut DoH-palvelinten URL-osoitteet pilkuilla erotettuna. Vähintään 2 palvelinta tarvitaan ristiintarkistukseen.';

  @override
  String get settingsDnsLabel => 'DoH-palvelinten URL-osoitteet';

  @override
  String get settingsDnsReset => 'Palauta oletukset';

  @override
  String get settingsSectionSync => 'Synkronointi';

  @override
  String get settingsSyncAccount => 'Tili';

  @override
  String get settingsSyncNotLoggedIn => 'Ei kirjautunut';

  @override
  String get settingsSyncStatus => 'Synkronointi';

  @override
  String get settingsSyncServerUrl => 'Palvelimen URL';

  @override
  String get settingsSyncDefaultServer => 'Oletus (sshvault.app)';

  @override
  String get accountTitle => 'Tili';

  @override
  String get accountNotLoggedIn => 'Ei kirjautunut';

  @override
  String get accountVerified => 'Vahvistettu';

  @override
  String get accountMemberSince => 'Jäsen alkaen';

  @override
  String get accountDevices => 'Laitteet';

  @override
  String get accountNoDevices => 'Ei rekisteröityjä laitteita';

  @override
  String get accountLastSync => 'Viimeisin synkronointi';

  @override
  String get accountChangePassword => 'Vaihda salasana';

  @override
  String get accountOldPassword => 'Nykyinen salasana';

  @override
  String get accountNewPassword => 'Uusi salasana';

  @override
  String get accountDeleteAccount => 'Poista tili';

  @override
  String get accountDeleteWarning =>
      'Tämä poistaa pysyvästi tilisi ja kaikki synkronoidut tiedot. Tätä ei voi kumota.';

  @override
  String get accountLogout => 'Kirjaudu ulos';

  @override
  String get serverConfigTitle => 'Palvelimen asetukset';

  @override
  String get serverConfigUrlLabel => 'Palvelimen URL';

  @override
  String get serverConfigTest => 'Testaa yhteys';

  @override
  String get serverSetupTitle => 'Palvelimen asennus';

  @override
  String get serverSetupInfoCard =>
      'ShellVault vaatii oman palvelimen päästä päähän salattuun synkronointiin. Ota käyttöön oma instanssi aloittaaksesi.';

  @override
  String get serverSetupRepoLink => 'Katso GitHubissa';

  @override
  String get serverSetupContinue => 'Jatka';

  @override
  String get settingsServerNotConfigured => 'Palvelinta ei ole määritetty';

  @override
  String get settingsSetupSync =>
      'Määritä synkronointi tietojesi varmuuskopiointiin';

  @override
  String get settingsChangeServer => 'Vaihda palvelin';

  @override
  String get settingsChangeServerConfirm =>
      'Palvelimen vaihtaminen kirjaa sinut ulos. Jatketaanko?';

  @override
  String get auditLogTitle => 'Toimintoloki';

  @override
  String get auditLogAll => 'Kaikki';

  @override
  String get auditLogEmpty => 'Lokimerkintöjä ei löytynyt';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Tiedostonhallinta';

  @override
  String get sftpLocalDevice => 'Paikallinen laite';

  @override
  String get sftpSelectServer => 'Valitse palvelin...';

  @override
  String get sftpConnecting => 'Yhdistetään...';

  @override
  String get sftpEmptyDirectory => 'Tämä hakemisto on tyhjä';

  @override
  String get sftpNoConnection => 'Ei palvelinyhteyttä';

  @override
  String get sftpPathLabel => 'Polku';

  @override
  String get sftpUpload => 'Lataa palvelimelle';

  @override
  String get sftpDownload => 'Lataa';

  @override
  String get sftpDelete => 'Poista';

  @override
  String get sftpRename => 'Nimeä uudelleen';

  @override
  String get sftpNewFolder => 'Uusi kansio';

  @override
  String get sftpNewFolderName => 'Kansion nimi';

  @override
  String get sftpChmod => 'Käyttöoikeudet';

  @override
  String get sftpChmodTitle => 'Muuta käyttöoikeuksia';

  @override
  String get sftpChmodOctal => 'Oktaali';

  @override
  String get sftpChmodOwner => 'Omistaja';

  @override
  String get sftpChmodGroup => 'Ryhmä';

  @override
  String get sftpChmodOther => 'Muut';

  @override
  String get sftpChmodRead => 'Luku';

  @override
  String get sftpChmodWrite => 'Kirjoitus';

  @override
  String get sftpChmodExecute => 'Suoritus';

  @override
  String get sftpCreateSymlink => 'Luo symbolinen linkki';

  @override
  String get sftpSymlinkTarget => 'Kohdepolku';

  @override
  String get sftpSymlinkName => 'Linkin nimi';

  @override
  String get sftpFilePreview => 'Tiedoston esikatselu';

  @override
  String get sftpFileInfo => 'Tiedoston tiedot';

  @override
  String get sftpFileSize => 'Koko';

  @override
  String get sftpFileModified => 'Muokattu';

  @override
  String get sftpFilePermissions => 'Käyttöoikeudet';

  @override
  String get sftpFileOwner => 'Omistaja';

  @override
  String get sftpFileType => 'Tyyppi';

  @override
  String get sftpFileLinkTarget => 'Linkin kohde';

  @override
  String get sftpTransfers => 'Siirrot';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get sftpTransferQueued => 'Jonossa';

  @override
  String get sftpTransferActive => 'Siirretään...';

  @override
  String get sftpTransferPaused => 'Keskeytetty';

  @override
  String get sftpTransferCompleted => 'Valmis';

  @override
  String get sftpTransferFailed => 'Epäonnistunut';

  @override
  String get sftpTransferCancelled => 'Peruutettu';

  @override
  String get sftpPauseTransfer => 'Keskeytä';

  @override
  String get sftpResumeTransfer => 'Jatka';

  @override
  String get sftpCancelTransfer => 'Peruuta';

  @override
  String get sftpClearCompleted => 'Tyhjennä valmiit';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active / $total siirtoa';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktiivista',
      one: '1 aktiivinen',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count valmista',
      one: '1 valmis',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count epäonnistunutta',
      one: '1 epäonnistunut',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Kopioi toiseen paneeliin';

  @override
  String sftpConfirmDelete(int count) {
    return 'Poistetaanko $count kohdetta?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Poistetaanko \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Poistettu onnistuneesti';

  @override
  String get sftpRenameTitle => 'Nimeä uudelleen';

  @override
  String get sftpRenameLabel => 'Uusi nimi';

  @override
  String get sftpSortByName => 'Nimi';

  @override
  String get sftpSortBySize => 'Koko';

  @override
  String get sftpSortByDate => 'Päivämäärä';

  @override
  String get sftpSortByType => 'Tyyppi';

  @override
  String get sftpShowHidden => 'Näytä piilotetut tiedostot';

  @override
  String get sftpHideHidden => 'Piilota piilotetut tiedostot';

  @override
  String get sftpSelectAll => 'Valitse kaikki';

  @override
  String get sftpDeselectAll => 'Poista kaikki valinnat';

  @override
  String sftpItemsSelected(int count) {
    return '$count valittu';
  }

  @override
  String get sftpRefresh => 'Päivitä';

  @override
  String sftpConnectionError(String message) {
    return 'Yhteys epäonnistui: $message';
  }

  @override
  String get sftpPermissionDenied => 'Käyttö estetty';

  @override
  String sftpOperationFailed(String message) {
    return 'Toiminto epäonnistui: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Tiedosto on jo olemassa';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" on jo olemassa. Korvataanko?';
  }

  @override
  String get sftpOverwrite => 'Korvaa';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Siirto aloitettu: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'Valitse ensin kohde toisesta paneelista';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Hakemistosiirto tulossa pian';

  @override
  String get sftpSelect => 'Valitse';

  @override
  String get sftpOpen => 'Avaa';

  @override
  String get sftpExtractArchive => 'Pura tähän';

  @override
  String get sftpExtractSuccess => 'Arkisto purettu';

  @override
  String sftpExtractFailed(String message) {
    return 'Purku epäonnistui: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Ei-tuettu arkistomuoto';

  @override
  String get sftpExtracting => 'Puretaan...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lähetystä aloitettu',
      one: 'Lähetys aloitettu',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count latausta aloitettu',
      one: 'Lataus aloitettu',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" ladattu';
  }

  @override
  String get sftpSavedToDownloads => 'Tallennettu kansioon Lataukset/SSHVault';

  @override
  String get sftpSaveToFiles => 'Tallenna Tiedostoihin';

  @override
  String get sftpFileSaved => 'Tiedosto tallennettu';

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
      other: '$count SSH-istuntoa aktiivista',
      one: 'SSH-istunto aktiivinen',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Napauta avataksesi terminaalin';

  @override
  String get settingsAccountAndSync => 'Tili ja synkronointi';

  @override
  String get settingsAccountSubtitleAuth => 'Kirjautunut sisään';

  @override
  String get settingsAccountSubtitleUnauth => 'Ei kirjautunut';

  @override
  String get settingsSecuritySubtitle =>
      'Automaattinen lukitus, biometriikka, PIN';

  @override
  String get settingsSshSubtitle => 'Portti 22, käyttäjä root';

  @override
  String get settingsAppearanceSubtitle => 'Teema, kieli, terminaali';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Salatun viennin oletukset';

  @override
  String get settingsAboutSubtitle => 'Versio, lisenssit';

  @override
  String get settingsSearchHint => 'Hae asetuksia...';

  @override
  String get settingsSearchNoResults => 'Asetuksia ei löytynyt';

  @override
  String get aboutDeveloper => 'Kehittäjä: Kiefer Networks';

  @override
  String get aboutDonate => 'Lahjoita';

  @override
  String get aboutOpenSourceLicenses => 'Avoimen lähdekoodin lisenssit';

  @override
  String get aboutWebsite => 'Verkkosivusto';

  @override
  String get aboutVersion => 'Versio';

  @override
  String get aboutBuild => 'Koontiversio';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS salaa DNS-kyselyt ja estää DNS-huijauksen. SSHVault tarkistaa palvelinnimet useasta palveluntarjoajasta hyökkäysten havaitsemiseksi.';

  @override
  String get settingsDnsAddServer => 'Lisää DNS-palvelin';

  @override
  String get settingsDnsServerUrl => 'Palvelimen URL';

  @override
  String get settingsDnsDefaultBadge => 'Oletus';

  @override
  String get settingsDnsResetDefaults => 'Palauta oletukset';

  @override
  String get settingsDnsInvalidUrl => 'Syötä kelvollinen HTTPS-URL';

  @override
  String get settingsDefaultAuthMethod => 'Tunnistautumismenetelmä';

  @override
  String get settingsAuthPassword => 'Salasana';

  @override
  String get settingsAuthKey => 'SSH-avain';

  @override
  String get settingsConnectionTimeout => 'Yhteyden aikakatkaisu';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsKeepaliveInterval => 'Elossapitoväli';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsCompression => 'Pakkaus';

  @override
  String get settingsCompressionDescription =>
      'Ota zlib-pakkaus käyttöön SSH-yhteyksille';

  @override
  String get settingsTerminalType => 'Terminaalityyppi';

  @override
  String get settingsSectionConnection => 'Yhteys';

  @override
  String get settingsClipboardAutoClear =>
      'Leikepöydän automaattinen tyhjennys';

  @override
  String get settingsClipboardAutoClearOff => 'Pois';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds s';
  }

  @override
  String get settingsSessionTimeout => 'Istunnon aikakatkaisu';

  @override
  String get settingsSessionTimeoutOff => 'Pois';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'Hätä-PIN';

  @override
  String get settingsDuressPinDescription =>
      'Erillinen PIN, joka tyhjentää kaikki tiedot syötettäessä';

  @override
  String get settingsDuressPinSet => 'Hätä-PIN on asetettu';

  @override
  String get settingsDuressPinNotSet => 'Ei määritetty';

  @override
  String get settingsDuressPinWarning =>
      'Tämän PIN-koodin syöttäminen poistaa pysyvästi kaikki paikalliset tiedot, mukaan lukien tunnukset, avaimet ja asetukset. Tätä ei voi kumota.';

  @override
  String get settingsKeyRotationReminder => 'Avaimen vaihtamuistutus';

  @override
  String get settingsKeyRotationOff => 'Pois';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days päivää';
  }

  @override
  String get settingsFailedAttempts => 'Epäonnistuneet PIN-yritykset';

  @override
  String get settingsSectionAppLock => 'Sovelluksen lukitus';

  @override
  String get settingsSectionPrivacy => 'Yksityisyys';

  @override
  String get settingsSectionReminders => 'Muistutukset';

  @override
  String get settingsSectionStatus => 'Tila';

  @override
  String get settingsExportBackupSubtitle =>
      'Vienti, tuonti ja varmuuskopiointi';

  @override
  String get settingsExportJson => 'Vie JSON-muodossa';

  @override
  String get settingsExportEncrypted => 'Vie salattuna';

  @override
  String get settingsImportFile => 'Tuo tiedostosta';

  @override
  String get settingsSectionImport => 'Tuonti';

  @override
  String get filterTitle => 'Suodata palvelimia';

  @override
  String get filterApply => 'Käytä suodattimia';

  @override
  String get filterClearAll => 'Tyhjennä kaikki';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suodatinta aktiivista',
      one: '1 suodatin aktiivinen',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Kansio';

  @override
  String get filterTags => 'Tunnisteet';

  @override
  String get filterStatus => 'Tila';

  @override
  String get variablePreviewResolved => 'Ratkaistu esikatselu';

  @override
  String get variableInsert => 'Lisää';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palvelinta',
      one: '1 palvelin',
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
      other: '$count istuntoa peruutettu.',
      one: '1 istunto peruutettu.',
    );
    return '$_temp0 Sinut on kirjattu ulos.';
  }

  @override
  String get keyGenPassphrase => 'Tunnuslause';

  @override
  String get keyGenPassphraseHint => 'Valinnainen — suojaa yksityisen avaimen';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Oletus (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Avain samalla sormenjäljellä on jo olemassa: \"$name\". Jokaisen SSH-avaimen on oltava yksilöllinen.';
  }

  @override
  String get sshKeyFingerprint => 'Sormenjälki';

  @override
  String get sshKeyPublicKey => 'Julkinen avain';

  @override
  String get jumpHost => 'Hyppypalvelin';

  @override
  String get jumpHostNone => 'Ei mitään';

  @override
  String get jumpHostLabel => 'Yhdistä hyppypalvelimen kautta';

  @override
  String get jumpHostSelfError => 'Palvelin ei voi olla oma hyppypalvelimensa';

  @override
  String get jumpHostConnecting => 'Yhdistetään hyppypalvelimeen…';

  @override
  String get jumpHostCircularError => 'Kehämäinen hyppypalvelinketju havaittu';

  @override
  String get logoutDialogTitle => 'Kirjaudu ulos';

  @override
  String get logoutDialogMessage =>
      'Haluatko poistaa kaikki paikalliset tiedot? Palvelimet, SSH-avaimet, koodinpätkät ja asetukset poistetaan tältä laitteelta.';

  @override
  String get logoutOnly => 'Kirjaudu vain ulos';

  @override
  String get logoutAndDelete => 'Kirjaudu ulos ja poista tiedot';

  @override
  String get changeAvatar => 'Vaihda avatar';

  @override
  String get removeAvatar => 'Poista avatar';

  @override
  String get avatarUploadFailed => 'Avatarin lataaminen epäonnistui';

  @override
  String get avatarTooLarge => 'Kuva on liian suuri';

  @override
  String get deviceLastSeen => 'Nähty viimeksi';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Palvelimen URL-osoitetta ei voi muuttaa kirjautuneena. Kirjaudu ensin ulos.';

  @override
  String get serverListNoFolder => 'Luokittelematon';

  @override
  String get autoSyncInterval => 'Synkronointiväli';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Välityspalvelimen asetukset';

  @override
  String get proxyType => 'Välityspalvelimen tyyppi';

  @override
  String get proxyNone => 'Ei välityspalvelinta';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Välityspalvelin';

  @override
  String get proxyPort => 'Välityspalvelimen portti';

  @override
  String get proxyUsername => 'Välityspalvelimen käyttäjänimi';

  @override
  String get proxyPassword => 'Välityspalvelimen salasana';

  @override
  String get proxyUseGlobal => 'Käytä yleistä välityspalvelinta';

  @override
  String get proxyGlobal => 'Yleinen';

  @override
  String get proxyServerSpecific => 'Palvelinkohtainen';

  @override
  String get proxyTestConnection => 'Testaa yhteys';

  @override
  String get proxyTestSuccess => 'Välityspalvelin tavoitettavissa';

  @override
  String get proxyTestFailed => 'Välityspalvelin ei tavoitettavissa';

  @override
  String get proxyDefaultProxy => 'Oletusvälityspalvelin';

  @override
  String get vpnRequired => 'VPN vaaditaan';

  @override
  String get vpnRequiredTooltip =>
      'Näytä varoitus, kun yhdistetään ilman aktiivista VPN:ää';

  @override
  String get vpnActive => 'VPN aktiivinen';

  @override
  String get vpnInactive => 'VPN ei aktiivinen';

  @override
  String get vpnWarningTitle => 'VPN ei ole aktiivinen';

  @override
  String get vpnWarningMessage =>
      'Tämä palvelin on merkitty vaatimaan VPN-yhteyden, mutta VPN ei ole tällä hetkellä aktiivinen. Haluatko yhdistää silti?';

  @override
  String get vpnConnectAnyway => 'Yhdistä silti';

  @override
  String get postConnectCommands => 'Yhteyden jälkeiset komennot';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Komennot suoritetaan automaattisesti yhteyden muodostamisen jälkeen (yksi per rivi)';

  @override
  String get dashboardFavorites => 'Suosikit';

  @override
  String get dashboardRecent => 'Viimeisimmät';

  @override
  String get dashboardActiveSessions => 'Aktiiviset istunnot';

  @override
  String get addToFavorites => 'Lisää suosikkeihin';

  @override
  String get removeFromFavorites => 'Poista suosikeista';

  @override
  String get noRecentConnections => 'Ei viimeaikaisia yhteyksiä';

  @override
  String get terminalSplit => 'Jaettu näkymä';

  @override
  String get terminalUnsplit => 'Sulje jaettu näkymä';

  @override
  String get terminalSelectSession => 'Valitse istunto jaetulle näkymälle';

  @override
  String get knownHostsTitle => 'Tunnetut palvelimet';

  @override
  String get knownHostsSubtitle => 'Hallitse luotettuja palvelinsormenjälkiä';

  @override
  String get hostKeyNewTitle => 'Uusi palvelin';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Ensimmäinen yhteys palvelimeen $hostname:$port. Vahvista sormenjälki ennen yhdistämistä.';
  }

  @override
  String get hostKeyChangedTitle => 'Palvelimen avain muuttunut!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Palvelimen $hostname:$port avain on muuttunut. Tämä voi viitata tietoturvauhkaan.';
  }

  @override
  String get hostKeyFingerprint => 'Sormenjälki';

  @override
  String get hostKeyType => 'Avaintyyppi';

  @override
  String get hostKeyTrustConnect => 'Luota ja yhdistä';

  @override
  String get hostKeyAcceptNew => 'Hyväksy uusi avain';

  @override
  String get hostKeyReject => 'Hylkää';

  @override
  String get hostKeyPreviousFingerprint => 'Edellinen sormenjälki';

  @override
  String get hostKeyDeleteAll => 'Poista kaikki tunnetut palvelimet';

  @override
  String get hostKeyDeleteConfirm =>
      'Haluatko varmasti poistaa kaikki tunnetut palvelimet? Sinulta kysytään vahvistus uudelleen seuraavalla yhdistyskerralla.';

  @override
  String get hostKeyEmpty => 'Ei tunnettuja palvelimia vielä';

  @override
  String get hostKeyEmptySubtitle =>
      'Palvelinsormenjäljet tallennetaan tänne ensimmäisen yhteyden jälkeen';

  @override
  String get hostKeyFirstSeen => 'Nähty ensimmäisen kerran';

  @override
  String get hostKeyLastSeen => 'Nähty viimeksi';

  @override
  String get sshConfigImportTitle => 'Tuo SSH-asetukset';

  @override
  String get sshConfigImportPickFile => 'Valitse SSH-asetustiedosto';

  @override
  String get sshConfigImportOrPaste => 'Tai liitä asetukset';

  @override
  String sshConfigImportParsed(int count) {
    return '$count palvelinta löydetty';
  }

  @override
  String get sshConfigImportButton => 'Tuo valitut';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count palvelinta tuotu';
  }

  @override
  String get sshConfigImportDuplicate => 'On jo olemassa';

  @override
  String get sshConfigImportNoHosts => 'Asetuksista ei löytynyt palvelimia';

  @override
  String get sftpBookmarkAdd => 'Lisää kirjanmerkki';

  @override
  String get sftpBookmarkLabel => 'Nimi';

  @override
  String get disconnect => 'Katkaise yhteys';

  @override
  String get reportAndDisconnect => 'Ilmoita ja katkaise yhteys';

  @override
  String get continueAnyway => 'Jatka silti';

  @override
  String get insertSnippet => 'Lisää koodinpätkä';

  @override
  String get seconds => 'Sekuntia';

  @override
  String get heartbeatLostMessage =>
      'Palvelinta ei tavoitettu usean yrityksen jälkeen. Turvallisuutesi vuoksi istunto on päätetty.';

  @override
  String get attestationFailedTitle => 'Palvelimen vahvistus epäonnistui';

  @override
  String get attestationFailedMessage =>
      'Palvelinta ei voitu vahvistaa aidoksi SSHVault-taustajärjestelmäksi. Tämä voi viitata väliintulohyökkäykseen tai väärin määritettyyn palvelimeen.';

  @override
  String get attestationKeyChangedTitle => 'Palvelimen avain muuttunut';

  @override
  String get attestationKeyChangedMessage =>
      'Palvelimen vahvistusavain on muuttunut alkuperäisen yhteyden jälkeen. Tämä voi viitata väliintulohyökkäykseen. ÄLÄ jatka, ellei palvelimen ylläpitäjä ole vahvistanut avaimen vaihtoa.';

  @override
  String get sectionLinks => 'Linkit';

  @override
  String get sectionDeveloper => 'Kehittäjä';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Sivua ei löytynyt';

  @override
  String get connectionTestSuccess => 'Yhteys onnistui';

  @override
  String connectionTestFailed(String message) {
    return 'Yhteys epäonnistui: $message';
  }

  @override
  String get serverVerificationFailed => 'Palvelimen vahvistus epäonnistui';

  @override
  String get importSuccessful => 'Tuonti onnistui';

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
  String get deviceDeleteConfirmTitle => 'Poista laite';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Haluatko varmasti poistaa laitteen \"$name\"? Laite kirjataan ulos välittömästi.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Tämä on nykyinen laitteesi. Sinut kirjataan ulos välittömästi.';

  @override
  String get deviceDeleteSuccess => 'Laite poistettu';

  @override
  String get deviceDeletedCurrentLogout =>
      'Nykyinen laite poistettu. Sinut on kirjattu ulos.';

  @override
  String get thisDevice => 'Tämä laite';
}
