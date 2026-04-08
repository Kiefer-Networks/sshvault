// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Værter';

  @override
  String get navSnippets => 'Kodestykker';

  @override
  String get navFolders => 'Mapper';

  @override
  String get navTags => 'Tags';

  @override
  String get navSshKeys => 'SSH-nøgler';

  @override
  String get navExportImport => 'Eksport / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Mere';

  @override
  String get navManagement => 'Administration';

  @override
  String get navSettings => 'Indstillinger';

  @override
  String get navAbout => 'Om';

  @override
  String get lockScreenTitle => 'SSHVault er låst';

  @override
  String get lockScreenUnlock => 'Lås op';

  @override
  String get lockScreenEnterPin => 'Indtast PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'For mange mislykkede forsøg. Prøv igen om $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Angiv PIN-kode';

  @override
  String get pinDialogSetSubtitle =>
      'Indtast en 6-cifret PIN for at beskytte SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Bekræft PIN';

  @override
  String get pinDialogErrorLength => 'PIN skal være præcis 6 cifre';

  @override
  String get pinDialogErrorMismatch => 'PIN-koderne stemmer ikke overens';

  @override
  String get pinDialogVerifyTitle => 'Indtast PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Forkert PIN. $attempts forsøg tilbage.';
  }

  @override
  String get securityBannerMessage =>
      'Dine SSH-legitimationsoplysninger er ikke beskyttet. Opsæt en PIN eller biometrisk lås i Indstillinger.';

  @override
  String get securityBannerDismiss => 'Afvis';

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get settingsSectionAppearance => 'Udseende';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'SSH-standardværdier';

  @override
  String get settingsSectionSecurity => 'Sikkerhed';

  @override
  String get settingsSectionExport => 'Eksport';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Lyst';

  @override
  String get settingsThemeDark => 'Mørkt';

  @override
  String get settingsTerminalTheme => 'Terminaltema';

  @override
  String get settingsTerminalThemeDefault => 'Standard mørk';

  @override
  String get settingsFontSize => 'Skriftstørrelse';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Standardport';

  @override
  String get settingsDefaultPortDialog => 'Standard SSH-port';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Standard brugernavn';

  @override
  String get settingsDefaultUsernameDialog => 'Standard brugernavn';

  @override
  String get settingsUsernameLabel => 'Brugernavn';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automatisk låsning';

  @override
  String get settingsAutoLockDisabled => 'Deaktiveret';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minutter';
  }

  @override
  String get settingsAutoLockOff => 'Fra';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Biometrisk oplåsning';

  @override
  String get settingsBiometricNotAvailable => 'Ikke tilgængelig på denne enhed';

  @override
  String get settingsBiometricError => 'Fejl ved kontrol af biometri';

  @override
  String get settingsBiometricReason =>
      'Bekræft din identitet for at aktivere biometrisk oplåsning';

  @override
  String get settingsBiometricRequiresPin =>
      'Angiv en PIN først for at aktivere biometrisk oplåsning';

  @override
  String get settingsPinCode => 'PIN-kode';

  @override
  String get settingsPinIsSet => 'PIN er angivet';

  @override
  String get settingsPinNotConfigured => 'Ingen PIN konfigureret';

  @override
  String get settingsPinRemove => 'Fjern';

  @override
  String get settingsPinRemoveWarning =>
      'Fjernelse af PIN dekrypterer alle databasefelter og deaktiverer biometrisk oplåsning. Fortsætte?';

  @override
  String get settingsPinRemoveTitle => 'Fjern PIN';

  @override
  String get settingsPreventScreenshots => 'Forhindre skærmbilleder';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Bloker skærmbilleder og skærmoptagelse';

  @override
  String get settingsEncryptExport => 'Krypter eksport som standard';

  @override
  String get settingsAbout => 'Om SSHVault';

  @override
  String get settingsAboutLegalese => 'af Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Sikker, selvhostet SSH-klient';

  @override
  String get settingsLanguage => 'Sprog';

  @override
  String get settingsLanguageSystem => 'System';

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
  String get cancel => 'Annuller';

  @override
  String get save => 'Gem';

  @override
  String get delete => 'Slet';

  @override
  String get close => 'Luk';

  @override
  String get update => 'Opdater';

  @override
  String get create => 'Opret';

  @override
  String get retry => 'Prøv igen';

  @override
  String get copy => 'Kopier';

  @override
  String get edit => 'Rediger';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Fejl: $message';
  }

  @override
  String get serverListTitle => 'Værter';

  @override
  String get serverListEmpty => 'Ingen servere endnu';

  @override
  String get serverListEmptySubtitle =>
      'Tilføj din første SSH-server for at komme i gang.';

  @override
  String get serverAddButton => 'Tilføj server';

  @override
  String sshConfigImportMessage(int count) {
    return 'Fandt $count vært(er) i ~/.ssh/config. Importere dem?';
  }

  @override
  String get sshConfigNotFound => 'Ingen SSH-konfigurationsfil fundet';

  @override
  String get sshConfigEmpty => 'Ingen værter fundet i SSH-konfigurationen';

  @override
  String get sshConfigAddManually => 'Tilføj manuelt';

  @override
  String get sshConfigImportAgain => 'Importere SSH-konfiguration igen?';

  @override
  String get sshConfigImportKeys =>
      'Importere SSH-nøgler refereret af valgte værter?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH-nøgle(r) importeret';
  }

  @override
  String get serverDuplicated => 'Server duplikeret';

  @override
  String get serverDeleteTitle => 'Slet server';

  @override
  String serverDeleteMessage(String name) {
    return 'Er du sikker på, at du vil slette \"$name\"? Denne handling kan ikke fortrydes.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Slette \"$name\"?';
  }

  @override
  String get serverConnect => 'Opret forbindelse';

  @override
  String get serverDetails => 'Detaljer';

  @override
  String get serverDuplicate => 'Dupliker';

  @override
  String get serverActive => 'Aktiv';

  @override
  String get serverNoFolder => 'Ingen mappe';

  @override
  String get serverFormTitleEdit => 'Rediger server';

  @override
  String get serverFormTitleAdd => 'Tilføj server';

  @override
  String get serverSaved => 'Server gemt';

  @override
  String get serverFormUpdateButton => 'Opdater server';

  @override
  String get serverFormAddButton => 'Tilføj server';

  @override
  String get serverFormPublicKeyExtracted => 'Offentlig nøgle hentet';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Kunne ikke hente offentlig nøgle: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type-nøglepar genereret';
  }

  @override
  String get serverDetailTitle => 'Serverdetaljer';

  @override
  String get serverDetailDeleteMessage => 'Denne handling kan ikke fortrydes.';

  @override
  String get serverDetailConnection => 'Forbindelse';

  @override
  String get serverDetailHost => 'Vært';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Brugernavn';

  @override
  String get serverDetailFolder => 'Mappe';

  @override
  String get serverDetailTags => 'Tags';

  @override
  String get serverDetailNotes => 'Noter';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Oprettet';

  @override
  String get serverDetailUpdated => 'Opdateret';

  @override
  String get serverDetailDistro => 'System';

  @override
  String get copiedToClipboard => 'Kopieret til udklipsholder';

  @override
  String get serverFormNameLabel => 'Servernavn';

  @override
  String get serverFormHostnameLabel => 'Værtsnavn / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Brugernavn';

  @override
  String get serverFormPasswordLabel => 'Adgangskode';

  @override
  String get serverFormUseManagedKey => 'Brug administreret nøgle';

  @override
  String get serverFormManagedKeySubtitle =>
      'Vælg fra centralt administrerede SSH-nøgler';

  @override
  String get serverFormDirectKeySubtitle =>
      'Indsæt nøgle direkte i denne server';

  @override
  String get serverFormGenerateKey => 'Generer SSH-nøglepar';

  @override
  String get serverFormPrivateKeyLabel => 'Privat nøgle';

  @override
  String get serverFormPrivateKeyHint => 'Indsæt SSH privat nøgle...';

  @override
  String get serverFormExtractPublicKey => 'Hent offentlig nøgle';

  @override
  String get serverFormPublicKeyLabel => 'Offentlig nøgle';

  @override
  String get serverFormPublicKeyHint =>
      'Autogenereres fra privat nøgle hvis tom';

  @override
  String get serverFormPassphraseLabel => 'Nøgleadgangskode (valgfrit)';

  @override
  String get serverFormNotesLabel => 'Noter (valgfrit)';

  @override
  String get searchServers => 'Søg servere...';

  @override
  String get filterAllFolders => 'Alle mapper';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterActive => 'Aktive';

  @override
  String get filterInactive => 'Inaktive';

  @override
  String get filterClear => 'Ryd';

  @override
  String get folderListTitle => 'Mapper';

  @override
  String get folderListEmpty => 'Ingen mapper endnu';

  @override
  String get folderListEmptySubtitle =>
      'Opret mapper for at organisere dine servere.';

  @override
  String get folderAddButton => 'Tilføj mappe';

  @override
  String get folderDeleteTitle => 'Slet mappe';

  @override
  String folderDeleteMessage(String name) {
    return 'Slette \"$name\"? Servere bliver uorganiserede.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servere',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Fold sammen';

  @override
  String get folderShowHosts => 'Vis værter';

  @override
  String get folderConnectAll => 'Opret forbindelse til alle';

  @override
  String get folderFormTitleEdit => 'Rediger mappe';

  @override
  String get folderFormTitleNew => 'Ny mappe';

  @override
  String get folderFormNameLabel => 'Mappenavn';

  @override
  String get folderFormParentLabel => 'Overordnet mappe';

  @override
  String get folderFormParentNone => 'Ingen (rod)';

  @override
  String get tagListTitle => 'Tags';

  @override
  String get tagListEmpty => 'Ingen tags endnu';

  @override
  String get tagListEmptySubtitle =>
      'Opret tags for at mærke og filtrere dine servere.';

  @override
  String get tagAddButton => 'Tilføj tag';

  @override
  String get tagDeleteTitle => 'Slet tag';

  @override
  String tagDeleteMessage(String name) {
    return 'Slette \"$name\"? Den fjernes fra alle servere.';
  }

  @override
  String get tagFormTitleEdit => 'Rediger tag';

  @override
  String get tagFormTitleNew => 'Ny tag';

  @override
  String get tagFormNameLabel => 'Tagnavn';

  @override
  String get sshKeyListTitle => 'SSH-nøgler';

  @override
  String get sshKeyListEmpty => 'Ingen SSH-nøgler endnu';

  @override
  String get sshKeyListEmptySubtitle =>
      'Generer eller importer SSH-nøgler for at administrere dem centralt';

  @override
  String get sshKeyCannotDeleteTitle => 'Kan ikke slette';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Kan ikke slette \"$name\". Bruges af $count server(e). Fjern tilknytning fra alle servere først.';
  }

  @override
  String get sshKeyDeleteTitle => 'Slet SSH-nøgle';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Slette \"$name\"? Dette kan ikke fortrydes.';
  }

  @override
  String get sshKeyAddButton => 'Tilføj SSH-nøgle';

  @override
  String get sshKeyFormTitleEdit => 'Rediger SSH-nøgle';

  @override
  String get sshKeyFormTitleAdd => 'Tilføj SSH-nøgle';

  @override
  String get sshKeyFormTabGenerate => 'Generer';

  @override
  String get sshKeyFormTabImport => 'Importer';

  @override
  String get sshKeyFormNameLabel => 'Nøglenavn';

  @override
  String get sshKeyFormNameHint => 'f.eks. Min produktionsnøgle';

  @override
  String get sshKeyFormKeyType => 'Nøgletype';

  @override
  String get sshKeyFormKeySize => 'Nøglestørrelse';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Kommentar';

  @override
  String get sshKeyFormCommentHint => 'user@host eller beskrivelse';

  @override
  String get sshKeyFormCommentOptional => 'Kommentar (valgfrit)';

  @override
  String get sshKeyFormImportFromFile => 'Importer fra fil';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Privat nøgle';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Indsæt SSH privat nøgle eller brug knappen ovenfor...';

  @override
  String get sshKeyFormPassphraseLabel => 'Adgangssætning (valgfrit)';

  @override
  String get sshKeyFormNameRequired => 'Navn er påkrævet';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Privat nøgle er påkrævet';

  @override
  String get sshKeyFormFileReadError => 'Kunne ikke læse den valgte fil';

  @override
  String get sshKeyFormInvalidFormat =>
      'Ugyldigt nøgleformat — forventet PEM-format (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Kunne ikke læse filen: $message';
  }

  @override
  String get sshKeyFormSaving => 'Gemmer...';

  @override
  String get sshKeySelectorLabel => 'SSH-nøgle';

  @override
  String get sshKeySelectorNone => 'Ingen administreret nøgle';

  @override
  String get sshKeySelectorManage => 'Administrer nøgler...';

  @override
  String get sshKeySelectorError => 'Kunne ikke indlæse SSH-nøgler';

  @override
  String get sshKeyTileCopyPublicKey => 'Kopier offentlig nøgle';

  @override
  String get sshKeyTilePublicKeyCopied => 'Offentlig nøgle kopieret';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Bruges af $count server(e)';
  }

  @override
  String get sshKeySavedSuccess => 'SSH-nøgle gemt';

  @override
  String get sshKeyDeletedSuccess => 'SSH-nøgle slettet';

  @override
  String get tagSavedSuccess => 'Tag gemt';

  @override
  String get tagDeletedSuccess => 'Tag slettet';

  @override
  String get folderDeletedSuccess => 'Mappe slettet';

  @override
  String get sshKeyTileUnlinkFirst =>
      'Fjern tilknytning fra alle servere først';

  @override
  String get exportImportTitle => 'Eksport / Import';

  @override
  String get exportSectionTitle => 'Eksport';

  @override
  String get exportJsonButton =>
      'Eksporter som JSON (uden legitimationsoplysninger)';

  @override
  String get exportZipButton =>
      'Eksporter krypteret ZIP (med legitimationsoplysninger)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Importer fra fil';

  @override
  String get importSupportedFormats =>
      'Understøtter JSON (ukrypteret) og ZIP (krypteret) filer.';

  @override
  String exportedTo(String path) {
    return 'Eksporteret til: $path';
  }

  @override
  String get share => 'Del';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Importerede $servers servere, $groups grupper, $tags tags. $skipped sprunget over.';
  }

  @override
  String get importPasswordTitle => 'Indtast adgangskode';

  @override
  String get importPasswordLabel => 'Eksportadgangskode';

  @override
  String get importPasswordDecrypt => 'Dekrypter';

  @override
  String get exportPasswordTitle => 'Angiv eksportadgangskode';

  @override
  String get exportPasswordDescription =>
      'Denne adgangskode bruges til at kryptere din eksportfil inklusiv legitimationsoplysninger.';

  @override
  String get exportPasswordLabel => 'Adgangskode';

  @override
  String get exportPasswordConfirmLabel => 'Bekræft adgangskode';

  @override
  String get exportPasswordMismatch => 'Adgangskoderne stemmer ikke overens';

  @override
  String get exportPasswordButton => 'Krypter & eksporter';

  @override
  String get importConflictTitle => 'Håndter konflikter';

  @override
  String get importConflictDescription =>
      'Hvordan skal eksisterende poster håndteres under import?';

  @override
  String get importConflictSkip => 'Spring over eksisterende';

  @override
  String get importConflictRename => 'Omdøb nye';

  @override
  String get importConflictOverwrite => 'Overskriv';

  @override
  String get confirmDeleteLabel => 'Slet';

  @override
  String get keyGenTitle => 'Generer SSH-nøglepar';

  @override
  String get keyGenKeyType => 'Nøgletype';

  @override
  String get keyGenKeySize => 'Nøglestørrelse';

  @override
  String get keyGenComment => 'Kommentar';

  @override
  String get keyGenCommentHint => 'user@host eller beskrivelse';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Genererer...';

  @override
  String get keyGenGenerate => 'Generer';

  @override
  String keyGenResultTitle(String type) {
    return '$type-nøgle genereret';
  }

  @override
  String get keyGenPublicKey => 'Offentlig nøgle';

  @override
  String get keyGenPrivateKey => 'Privat nøgle';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Kommentar: $comment';
  }

  @override
  String get keyGenAnother => 'Generer en mere';

  @override
  String get keyGenUseThisKey => 'Brug denne nøgle';

  @override
  String get keyGenCopyTooltip => 'Kopier til udklipsholder';

  @override
  String keyGenCopied(String label) {
    return '$label kopieret';
  }

  @override
  String get colorPickerLabel => 'Farve';

  @override
  String get iconPickerLabel => 'Ikon';

  @override
  String get tagSelectorLabel => 'Tags';

  @override
  String get tagSelectorEmpty => 'Ingen tags endnu';

  @override
  String get tagSelectorError => 'Kunne ikke indlæse tags';

  @override
  String get snippetListTitle => 'Kodestykker';

  @override
  String get snippetSearchHint => 'Søg kodestykker...';

  @override
  String get snippetListEmpty => 'Ingen kodestykker endnu';

  @override
  String get snippetListEmptySubtitle =>
      'Opret genbrugelige kodestykker og kommandoer.';

  @override
  String get snippetAddButton => 'Tilføj kodestykke';

  @override
  String get snippetDeleteTitle => 'Slet kodestykke';

  @override
  String snippetDeleteMessage(String name) {
    return 'Slette \"$name\"? Dette kan ikke fortrydes.';
  }

  @override
  String get snippetFormTitleEdit => 'Rediger kodestykke';

  @override
  String get snippetFormTitleNew => 'Nyt kodestykke';

  @override
  String get snippetFormNameLabel => 'Navn';

  @override
  String get snippetFormNameHint => 'f.eks. Docker-oprydning';

  @override
  String get snippetFormLanguageLabel => 'Sprog';

  @override
  String get snippetFormContentLabel => 'Indhold';

  @override
  String get snippetFormContentHint => 'Indtast din kode...';

  @override
  String get snippetFormDescriptionLabel => 'Beskrivelse';

  @override
  String get snippetFormDescriptionHint => 'Valgfri beskrivelse...';

  @override
  String get snippetFormFolderLabel => 'Mappe';

  @override
  String get snippetFormNoFolder => 'Ingen mappe';

  @override
  String get snippetFormNameRequired => 'Navn er påkrævet';

  @override
  String get snippetFormContentRequired => 'Indhold er påkrævet';

  @override
  String get snippetFormSaved => 'Snippet gemt';

  @override
  String get snippetFormUpdateButton => 'Opdater kodestykke';

  @override
  String get snippetFormCreateButton => 'Opret kodestykke';

  @override
  String get snippetDetailTitle => 'Kodestykkedetaljer';

  @override
  String get snippetDetailDeleteTitle => 'Slet kodestykke';

  @override
  String get snippetDetailDeleteMessage => 'Denne handling kan ikke fortrydes.';

  @override
  String get snippetDetailContent => 'Indhold';

  @override
  String get snippetDetailFillVariables => 'Udfyld variabler';

  @override
  String get snippetDetailDescription => 'Beskrivelse';

  @override
  String get snippetDetailVariables => 'Variabler';

  @override
  String get snippetDetailTags => 'Tags';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Oprettet';

  @override
  String get snippetDetailUpdated => 'Opdateret';

  @override
  String get variableEditorTitle => 'Skabelonvariabler';

  @override
  String get variableEditorAdd => 'Tilføj';

  @override
  String get variableEditorEmpty =>
      'Ingen variabler. Brug krølleparentessyntaks i indholdet for at referere til dem.';

  @override
  String get variableEditorNameLabel => 'Navn';

  @override
  String get variableEditorNameHint => 'f.eks. hostname';

  @override
  String get variableEditorDefaultLabel => 'Standard';

  @override
  String get variableEditorDefaultHint => 'valgfrit';

  @override
  String get variableFillTitle => 'Udfyld variabler';

  @override
  String variableFillHint(String name) {
    return 'Indtast værdi for $name';
  }

  @override
  String get variableFillPreview => 'Forhåndsvisning';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Ingen aktive sessioner';

  @override
  String get terminalEmptySubtitle =>
      'Opret forbindelse til en vært for at åbne en terminalsession.';

  @override
  String get terminalGoToHosts => 'Gå til værter';

  @override
  String get terminalCloseAll => 'Luk alle sessioner';

  @override
  String get terminalCloseTitle => 'Luk session';

  @override
  String terminalCloseMessage(String title) {
    return 'Luk den aktive forbindelse til \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Autentificerer...';

  @override
  String connectionConnecting(String name) {
    return 'Opretter forbindelse til $name...';
  }

  @override
  String get connectionError => 'Forbindelsesfejl';

  @override
  String get connectionLost => 'Forbindelsen mistet';

  @override
  String get connectionReconnect => 'Genopret forbindelse';

  @override
  String get snippetQuickPanelTitle => 'Indsæt kodestykke';

  @override
  String get snippetQuickPanelSearch => 'Søg kodestykker...';

  @override
  String get snippetQuickPanelEmpty => 'Ingen kodestykker tilgængelige';

  @override
  String get snippetQuickPanelNoMatch => 'Ingen matchende kodestykker';

  @override
  String get snippetQuickPanelInsertTooltip => 'Indsæt kodestykke';

  @override
  String get terminalThemePickerTitle => 'Terminaltema';

  @override
  String get validatorHostnameRequired => 'Værtsnavn er påkrævet';

  @override
  String get validatorHostnameInvalid => 'Ugyldigt værtsnavn eller IP-adresse';

  @override
  String get validatorPortRequired => 'Port er påkrævet';

  @override
  String get validatorPortRange => 'Port skal være mellem 1 og 65535';

  @override
  String get validatorUsernameRequired => 'Brugernavn er påkrævet';

  @override
  String get validatorUsernameInvalid => 'Ugyldigt brugernavnsformat';

  @override
  String get validatorServerNameRequired => 'Servernavn er påkrævet';

  @override
  String get validatorServerNameLength =>
      'Servernavn skal være 100 tegn eller derunder';

  @override
  String get validatorSshKeyInvalid => 'Ugyldigt SSH-nøgleformat';

  @override
  String get validatorPasswordRequired => 'Adgangskode er påkrævet';

  @override
  String get validatorPasswordLength => 'Adgangskode skal være mindst 8 tegn';

  @override
  String get authMethodPassword => 'Adgangskode';

  @override
  String get authMethodKey => 'SSH-nøgle';

  @override
  String get authMethodBoth => 'Adgangskode + nøgle';

  @override
  String get serverCopySuffix => '(Kopi)';

  @override
  String get settingsDownloadLogs => 'Download logfiler';

  @override
  String get settingsSendLogs => 'Send logfiler til support';

  @override
  String get settingsLogsSaved => 'Logfiler gemt';

  @override
  String get settingsUpdated => 'Indstilling opdateret';

  @override
  String get settingsThemeChanged => 'Tema ændret';

  @override
  String get settingsLanguageChanged => 'Sprog ændret';

  @override
  String get settingsPinSetSuccess => 'PIN indstillet';

  @override
  String get settingsPinRemovedSuccess => 'PIN fjernet';

  @override
  String get settingsDuressPinSetSuccess => 'Tvangskode indstillet';

  @override
  String get settingsDuressPinRemovedSuccess => 'Tvangskode fjernet';

  @override
  String get settingsBiometricEnabled => 'Biometrisk oplåsning aktiveret';

  @override
  String get settingsBiometricDisabled => 'Biometrisk oplåsning deaktiveret';

  @override
  String get settingsDnsServerAdded => 'DNS-server tilføjet';

  @override
  String get settingsDnsServerRemoved => 'DNS-server fjernet';

  @override
  String get settingsDnsResetSuccess => 'DNS-servere nulstillet';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Formindsk skrift';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Forstør skrift';

  @override
  String get settingsDnsRemoveServerTooltip => 'Fjern DNS-server';

  @override
  String get settingsLogsEmpty => 'Ingen logposter tilgængelige';

  @override
  String get authLogin => 'Log ind';

  @override
  String get authRegister => 'Registrer';

  @override
  String get authForgotPassword => 'Glemt adgangskode?';

  @override
  String get authWhyLogin =>
      'Log ind for at aktivere krypteret skysynkronisering på alle dine enheder. Appen fungerer fuldt offline uden en konto.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailRequired => 'E-mail er påkrævet';

  @override
  String get authEmailInvalid => 'Ugyldig e-mailadresse';

  @override
  String get authPasswordLabel => 'Adgangskode';

  @override
  String get authConfirmPasswordLabel => 'Bekræft adgangskode';

  @override
  String get authPasswordMismatch => 'Adgangskoderne stemmer ikke overens';

  @override
  String get authNoAccount => 'Ingen konto?';

  @override
  String get authHasAccount => 'Har du allerede en konto?';

  @override
  String get authResetEmailSent =>
      'Hvis en konto eksisterer, er der sendt et nulstillingslink til din e-mail.';

  @override
  String get authResetDescription =>
      'Indtast din e-mailadresse, så sender vi dig et link til at nulstille din adgangskode.';

  @override
  String get authSendResetLink => 'Send nulstillingslink';

  @override
  String get authBackToLogin => 'Tilbage til login';

  @override
  String get syncPasswordTitle => 'Synkroniseringsadgangskode';

  @override
  String get syncPasswordTitleCreate => 'Angiv synkroniseringsadgangskode';

  @override
  String get syncPasswordTitleEnter => 'Indtast synkroniseringsadgangskode';

  @override
  String get syncPasswordDescription =>
      'Angiv en separat adgangskode for at kryptere dine boksdata. Denne adgangskode forlader aldrig din enhed — serveren gemmer kun krypteret data.';

  @override
  String get syncPasswordHintEnter =>
      'Indtast den adgangskode, du angav, da du oprettede din konto.';

  @override
  String get syncPasswordWarning =>
      'Hvis du glemmer denne adgangskode, kan dine synkroniserede data ikke gendannes. Der er ingen nulstillingsmulighed.';

  @override
  String get syncPasswordLabel => 'Synkroniseringsadgangskode';

  @override
  String get syncPasswordWrong => 'Forkert adgangskode. Prøv igen.';

  @override
  String get firstSyncTitle => 'Eksisterende data fundet';

  @override
  String get firstSyncMessage =>
      'Denne enhed har eksisterende data, og serveren har en boks. Hvordan skal vi fortsætte?';

  @override
  String get firstSyncMerge => 'Flet (serveren vinder)';

  @override
  String get firstSyncOverwriteLocal => 'Overskriv lokale data';

  @override
  String get firstSyncKeepLocal => 'Behold lokale & push';

  @override
  String get firstSyncDeleteLocal => 'Slet lokale & pull';

  @override
  String get changeEncryptionPassword => 'Skift krypteringsadgangskode';

  @override
  String get changeEncryptionWarning =>
      'Du bliver logget ud på alle andre enheder.';

  @override
  String get changeEncryptionOldPassword => 'Nuværende adgangskode';

  @override
  String get changeEncryptionNewPassword => 'Ny adgangskode';

  @override
  String get changeEncryptionSuccess => 'Adgangskode ændret.';

  @override
  String get logoutAllDevices => 'Log ud fra alle enheder';

  @override
  String get logoutAllDevicesConfirm =>
      'Dette tilbagekalder alle aktive sessioner. Du skal logge ind igen på alle enheder.';

  @override
  String get logoutAllDevicesSuccess => 'Alle enheder logget ud.';

  @override
  String get syncSettingsTitle => 'Synkroniseringsindstillinger';

  @override
  String get syncAutoSync => 'Autosynkronisering';

  @override
  String get syncAutoSyncDescription =>
      'Synkroniser automatisk når appen starter';

  @override
  String get syncNow => 'Synkroniser nu';

  @override
  String get syncSyncing => 'Synkroniserer...';

  @override
  String get syncSuccess => 'Synkronisering fuldført';

  @override
  String get syncError => 'Synkroniseringsfejl';

  @override
  String get syncServerUnreachable => 'Serveren kan ikke nås';

  @override
  String get syncServerUnreachableHint =>
      'Synkroniseringsserveren kunne ikke nås. Tjek din internetforbindelse og server-URL.';

  @override
  String get syncNetworkError =>
      'Forbindelse til server mislykkedes. Tjek din internetforbindelse eller prøv igen senere.';

  @override
  String get syncNeverSynced => 'Aldrig synkroniseret';

  @override
  String get syncVaultVersion => 'Boksversion';

  @override
  String get syncTitle => 'Synkronisering';

  @override
  String get settingsSectionNetwork => 'Netværk & DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS-servere';

  @override
  String get settingsDnsDefault => 'Standard (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Indtast brugerdefinerede DoH-serveradresser, adskilt med kommaer. Mindst 2 servere kræves til krydstjek.';

  @override
  String get settingsDnsLabel => 'DoH-serveradresser';

  @override
  String get settingsDnsReset => 'Nulstil til standard';

  @override
  String get settingsSectionSync => 'Synkronisering';

  @override
  String get settingsSyncAccount => 'Konto';

  @override
  String get settingsSyncNotLoggedIn => 'Ikke logget ind';

  @override
  String get settingsSyncStatus => 'Synkronisering';

  @override
  String get settingsSyncServerUrl => 'Server-URL';

  @override
  String get settingsSyncDefaultServer => 'Standard (sshvault.app)';

  @override
  String get accountTitle => 'Konto';

  @override
  String get accountNotLoggedIn => 'Ikke logget ind';

  @override
  String get accountVerified => 'Verificeret';

  @override
  String get accountMemberSince => 'Medlem siden';

  @override
  String get accountDevices => 'Enheder';

  @override
  String get accountNoDevices => 'Ingen enheder registreret';

  @override
  String get accountLastSync => 'Seneste synkronisering';

  @override
  String get accountChangePassword => 'Skift adgangskode';

  @override
  String get accountOldPassword => 'Nuværende adgangskode';

  @override
  String get accountNewPassword => 'Ny adgangskode';

  @override
  String get accountDeleteAccount => 'Slet konto';

  @override
  String get accountDeleteWarning =>
      'Dette sletter permanent din konto og alle synkroniserede data. Dette kan ikke fortrydes.';

  @override
  String get accountLogout => 'Log ud';

  @override
  String get serverConfigTitle => 'Serverkonfiguration';

  @override
  String get serverConfigUrlLabel => 'Server-URL';

  @override
  String get serverConfigTest => 'Test forbindelse';

  @override
  String get serverSetupTitle => 'Serveropsætning';

  @override
  String get serverSetupInfoCard =>
      'ShellVault kræver en selvhostet server til ende-til-ende krypteret synkronisering. Implementer din egen instans for at komme i gang.';

  @override
  String get serverSetupRepoLink => 'Vis på GitHub';

  @override
  String get serverSetupContinue => 'Fortsæt';

  @override
  String get settingsServerNotConfigured => 'Ingen server konfigureret';

  @override
  String get settingsSetupSync =>
      'Konfigurer synkronisering for at sikkerhedskopiere dine data';

  @override
  String get settingsChangeServer => 'Skift server';

  @override
  String get settingsChangeServerConfirm =>
      'Ændring af server vil logge dig ud. Fortsæt?';

  @override
  String get auditLogTitle => 'Aktivitetslog';

  @override
  String get auditLogAll => 'Alle';

  @override
  String get auditLogEmpty => 'Ingen aktivitetslogfiler fundet';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Filhåndtering';

  @override
  String get sftpLocalDevice => 'Lokal enhed';

  @override
  String get sftpSelectServer => 'Vælg server...';

  @override
  String get sftpConnecting => 'Opretter forbindelse...';

  @override
  String get sftpEmptyDirectory => 'Denne mappe er tom';

  @override
  String get sftpNoConnection => 'Ingen server forbundet';

  @override
  String get sftpPathLabel => 'Sti';

  @override
  String get sftpUpload => 'Upload';

  @override
  String get sftpDownload => 'Download';

  @override
  String get sftpDelete => 'Slet';

  @override
  String get sftpRename => 'Omdøb';

  @override
  String get sftpNewFolder => 'Ny mappe';

  @override
  String get sftpNewFolderName => 'Mappenavn';

  @override
  String get sftpChmod => 'Tilladelser';

  @override
  String get sftpChmodTitle => 'Skift tilladelser';

  @override
  String get sftpChmodOctal => 'Oktal';

  @override
  String get sftpChmodOwner => 'Ejer';

  @override
  String get sftpChmodGroup => 'Gruppe';

  @override
  String get sftpChmodOther => 'Andre';

  @override
  String get sftpChmodRead => 'Læse';

  @override
  String get sftpChmodWrite => 'Skrive';

  @override
  String get sftpChmodExecute => 'Udføre';

  @override
  String get sftpCreateSymlink => 'Opret symlink';

  @override
  String get sftpSymlinkTarget => 'Målsti';

  @override
  String get sftpSymlinkName => 'Linknavn';

  @override
  String get sftpFilePreview => 'Filforhåndsvisning';

  @override
  String get sftpFileInfo => 'Filinfo';

  @override
  String get sftpFileSize => 'Størrelse';

  @override
  String get sftpFileModified => 'Ændret';

  @override
  String get sftpFilePermissions => 'Tilladelser';

  @override
  String get sftpFileOwner => 'Ejer';

  @override
  String get sftpFileType => 'Type';

  @override
  String get sftpFileLinkTarget => 'Linkmål';

  @override
  String get sftpTransfers => 'Overførsler';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current af $total';
  }

  @override
  String get sftpTransferQueued => 'I kø';

  @override
  String get sftpTransferActive => 'Overfører...';

  @override
  String get sftpTransferPaused => 'Sat på pause';

  @override
  String get sftpTransferCompleted => 'Fuldført';

  @override
  String get sftpTransferFailed => 'Mislykket';

  @override
  String get sftpTransferCancelled => 'Annulleret';

  @override
  String get sftpPauseTransfer => 'Pause';

  @override
  String get sftpResumeTransfer => 'Genoptag';

  @override
  String get sftpCancelTransfer => 'Annuller';

  @override
  String get sftpClearCompleted => 'Ryd fuldførte';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active af $total overførsler';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktive',
      one: '1 aktiv',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fuldførte',
      one: '1 fuldført',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mislykkede',
      one: '1 mislykket',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Kopier til andet panel';

  @override
  String sftpConfirmDelete(int count) {
    return 'Slette $count elementer?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Slette \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Slettet';

  @override
  String get sftpRenameTitle => 'Omdøb';

  @override
  String get sftpRenameLabel => 'Nyt navn';

  @override
  String get sftpSortByName => 'Navn';

  @override
  String get sftpSortBySize => 'Størrelse';

  @override
  String get sftpSortByDate => 'Dato';

  @override
  String get sftpSortByType => 'Type';

  @override
  String get sftpShowHidden => 'Vis skjulte filer';

  @override
  String get sftpHideHidden => 'Skjul skjulte filer';

  @override
  String get sftpSelectAll => 'Vælg alle';

  @override
  String get sftpDeselectAll => 'Fravælg alle';

  @override
  String sftpItemsSelected(int count) {
    return '$count valgt';
  }

  @override
  String get sftpRefresh => 'Opdater';

  @override
  String sftpConnectionError(String message) {
    return 'Forbindelsen mislykkedes: $message';
  }

  @override
  String get sftpPermissionDenied => 'Adgang nægtet';

  @override
  String sftpOperationFailed(String message) {
    return 'Handlingen mislykkedes: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Filen findes allerede';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" findes allerede. Overskrive?';
  }

  @override
  String get sftpOverwrite => 'Overskriv';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Overførsel startet: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Vælg en destination i det andet panel først';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Mappeoverførsel kommer snart';

  @override
  String get sftpSelect => 'Vælg';

  @override
  String get sftpOpen => 'Åbn';

  @override
  String get sftpExtractArchive => 'Pak ud her';

  @override
  String get sftpExtractSuccess => 'Arkiv pakket ud';

  @override
  String sftpExtractFailed(String message) {
    return 'Udpakning mislykkedes: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Arkivformat understøttes ikke';

  @override
  String get sftpExtracting => 'Pakker ud...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uploads startet',
      one: 'Upload startet',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads startet',
      one: 'Download startet',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" downloadet';
  }

  @override
  String get sftpSavedToDownloads => 'Gemt i Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Gem til filer';

  @override
  String get sftpFileSaved => 'Fil gemt';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH-sessioner aktive',
      one: 'SSH-session aktiv',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Tryk for at åbne terminalen';

  @override
  String get settingsAccountAndSync => 'Konto & synkronisering';

  @override
  String get settingsAccountSubtitleAuth => 'Logget ind';

  @override
  String get settingsAccountSubtitleUnauth => 'Ikke logget ind';

  @override
  String get settingsSecuritySubtitle => 'Autolås, biometri, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Bruger root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, sprog, terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Krypterede eksportstandarder';

  @override
  String get settingsAboutSubtitle => 'Version, licenser';

  @override
  String get settingsSearchHint => 'Søg indstillinger...';

  @override
  String get settingsSearchNoResults => 'Ingen indstillinger fundet';

  @override
  String get aboutDeveloper => 'Udviklet af Kiefer Networks';

  @override
  String get aboutDonate => 'Doner';

  @override
  String get aboutOpenSourceLicenses => 'Open source-licenser';

  @override
  String get aboutWebsite => 'Hjemmeside';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutBuild => 'Byg';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS krypterer DNS-forespørgsler og forhindrer DNS-forfalskning. SSHVault tjekker værtsnavne mod flere udbydere for at opdage angreb.';

  @override
  String get settingsDnsAddServer => 'Tilføj DNS-server';

  @override
  String get settingsDnsServerUrl => 'Server-URL';

  @override
  String get settingsDnsDefaultBadge => 'Standard';

  @override
  String get settingsDnsResetDefaults => 'Nulstil til standard';

  @override
  String get settingsDnsInvalidUrl => 'Indtast en gyldig HTTPS-URL';

  @override
  String get settingsDefaultAuthMethod => 'Autentificeringsmetode';

  @override
  String get settingsAuthPassword => 'Adgangskode';

  @override
  String get settingsAuthKey => 'SSH-nøgle';

  @override
  String get settingsConnectionTimeout => 'Forbindelsestimeout';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Keep-Alive-interval';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Komprimering';

  @override
  String get settingsCompressionDescription =>
      'Aktiver zlib-komprimering for SSH-forbindelser';

  @override
  String get settingsTerminalType => 'Terminaltype';

  @override
  String get settingsSectionConnection => 'Forbindelse';

  @override
  String get settingsClipboardAutoClear =>
      'Automatisk rydning af udklipsholder';

  @override
  String get settingsClipboardAutoClearOff => 'Fra';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Sessionstimeout';

  @override
  String get settingsSessionTimeoutOff => 'Fra';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'Nød-PIN';

  @override
  String get settingsDuressPinDescription =>
      'En separat PIN der sletter al data når den indtastes';

  @override
  String get settingsDuressPinSet => 'Nød-PIN er angivet';

  @override
  String get settingsDuressPinNotSet => 'Ikke konfigureret';

  @override
  String get settingsDuressPinWarning =>
      'Indtastning af denne PIN sletter permanent alle lokale data inklusiv legitimationsoplysninger, nøgler og indstillinger. Dette kan ikke fortrydes.';

  @override
  String get settingsKeyRotationReminder => 'Påmindelse om nøglerotation';

  @override
  String get settingsKeyRotationOff => 'Fra';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days dage';
  }

  @override
  String get settingsFailedAttempts => 'Mislykkede PIN-forsøg';

  @override
  String get settingsSectionAppLock => 'Applås';

  @override
  String get settingsSectionPrivacy => 'Privatliv';

  @override
  String get settingsSectionReminders => 'Påmindelser';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle =>
      'Eksport, import & sikkerhedskopiering';

  @override
  String get settingsExportJson => 'Eksporter som JSON';

  @override
  String get settingsExportEncrypted => 'Eksporter krypteret';

  @override
  String get settingsImportFile => 'Importer fra fil';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Filtrer servere';

  @override
  String get filterApply => 'Anvend filtre';

  @override
  String get filterClearAll => 'Ryd alle';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtre aktive',
      one: '1 filter aktivt',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Mappe';

  @override
  String get filterTags => 'Tags';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Løst forhåndsvisning';

  @override
  String get variableInsert => 'Indsæt';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servere',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessioner tilbagekaldt.',
      one: '1 session tilbagekaldt.',
    );
    return '$_temp0 Du er blevet logget ud.';
  }

  @override
  String get keyGenPassphrase => 'Adgangssætning';

  @override
  String get keyGenPassphraseHint => 'Valgfrit — beskytter den private nøgle';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Standard (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'En nøgle med samme fingeraftryk findes allerede: \"$name\". Hver SSH-nøgle skal være unik.';
  }

  @override
  String get sshKeyFingerprint => 'Fingeraftryk';

  @override
  String get sshKeyPublicKey => 'Offentlig nøgle';

  @override
  String get jumpHost => 'Hopvært';

  @override
  String get jumpHostNone => 'Ingen';

  @override
  String get jumpHostLabel => 'Opret forbindelse via hopvært';

  @override
  String get jumpHostSelfError => 'En server kan ikke være sin egen hopvært';

  @override
  String get jumpHostConnecting => 'Opretter forbindelse til hopvært...';

  @override
  String get jumpHostCircularError => 'Cirkulær hopværtskæde opdaget';

  @override
  String get logoutDialogTitle => 'Log ud';

  @override
  String get logoutDialogMessage =>
      'Vil du slette alle lokale data? Servere, SSH-nøgler, kodestykker og indstillinger fjernes fra denne enhed.';

  @override
  String get logoutOnly => 'Log kun ud';

  @override
  String get logoutAndDelete => 'Log ud & slet data';

  @override
  String get changeAvatar => 'Skift avatar';

  @override
  String get removeAvatar => 'Fjern avatar';

  @override
  String get avatarUploadFailed => 'Kunne ikke uploade avatar';

  @override
  String get avatarTooLarge => 'Billedet er for stort';

  @override
  String get deviceLastSeen => 'Sidst set';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Server-URL kan ikke ændres, mens du er logget ind. Log ud først.';

  @override
  String get serverListNoFolder => 'Ukategoriseret';

  @override
  String get autoSyncInterval => 'Synkroniseringsinterval';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Proxyindstillinger';

  @override
  String get proxyType => 'Proxytype';

  @override
  String get proxyNone => 'Ingen proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxyvært';

  @override
  String get proxyPort => 'Proxyport';

  @override
  String get proxyUsername => 'Proxybrugernavn';

  @override
  String get proxyPassword => 'Proxyadgangskode';

  @override
  String get proxyUseGlobal => 'Brug global proxy';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Serverspecifik';

  @override
  String get proxyTestConnection => 'Test forbindelse';

  @override
  String get proxyTestSuccess => 'Proxy tilgængelig';

  @override
  String get proxyTestFailed => 'Proxy ikke tilgængelig';

  @override
  String get proxyDefaultProxy => 'Standardproxy';

  @override
  String get vpnRequired => 'VPN påkrævet';

  @override
  String get vpnRequiredTooltip =>
      'Vis advarsel ved forbindelse uden aktivt VPN';

  @override
  String get vpnActive => 'VPN aktivt';

  @override
  String get vpnInactive => 'VPN inaktivt';

  @override
  String get vpnWarningTitle => 'VPN ikke aktivt';

  @override
  String get vpnWarningMessage =>
      'Denne server kræver VPN-forbindelse, men intet VPN er aktivt. Vil du oprette forbindelse alligevel?';

  @override
  String get vpnConnectAnyway => 'Opret forbindelse alligevel';

  @override
  String get postConnectCommands => 'Kommandoer efter forbindelse';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Kommandoer der udføres automatisk efter forbindelse (en per linje)';

  @override
  String get dashboardFavorites => 'Favoritter';

  @override
  String get dashboardRecent => 'Seneste';

  @override
  String get dashboardActiveSessions => 'Aktive sessioner';

  @override
  String get addToFavorites => 'Tilføj til favoritter';

  @override
  String get removeFromFavorites => 'Fjern fra favoritter';

  @override
  String get noRecentConnections => 'Ingen seneste forbindelser';

  @override
  String get terminalSplit => 'Delt visning';

  @override
  String get terminalUnsplit => 'Luk deling';

  @override
  String get terminalSelectSession => 'Vælg session til delt visning';

  @override
  String get knownHostsTitle => 'Kendte værter';

  @override
  String get knownHostsSubtitle => 'Administrer betroede serverfingeraftryk';

  @override
  String get hostKeyNewTitle => 'Ny vært';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Første forbindelse til $hostname:$port. Bekræft fingeraftrykket før du opretter forbindelse.';
  }

  @override
  String get hostKeyChangedTitle => 'Værtsnøgle ændret!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Værtsnøglen for $hostname:$port er ændret. Dette kan indikere en sikkerhedstrussel.';
  }

  @override
  String get hostKeyFingerprint => 'Fingeraftryk';

  @override
  String get hostKeyType => 'Nøgletype';

  @override
  String get hostKeyTrustConnect => 'Stol på & opret forbindelse';

  @override
  String get hostKeyAcceptNew => 'Accepter ny nøgle';

  @override
  String get hostKeyReject => 'Afvis';

  @override
  String get hostKeyPreviousFingerprint => 'Tidligere fingeraftryk';

  @override
  String get hostKeyDeleteAll => 'Slet alle kendte værter';

  @override
  String get hostKeyDeleteConfirm =>
      'Er du sikker på, at du vil fjerne alle kendte værter? Du bliver spurgt igen ved næste forbindelse.';

  @override
  String get hostKeyEmpty => 'Ingen kendte værter endnu';

  @override
  String get hostKeyEmptySubtitle =>
      'Værtsfingeraftryk gemmes her efter din første forbindelse';

  @override
  String get hostKeyFirstSeen => 'Første gang set';

  @override
  String get hostKeyLastSeen => 'Sidst set';

  @override
  String get sshConfigImportTitle => 'Importer SSH-konfiguration';

  @override
  String get sshConfigImportPickFile => 'Vælg SSH-konfigurationsfil';

  @override
  String get sshConfigImportOrPaste => 'Eller indsæt konfigurationsindhold';

  @override
  String sshConfigImportParsed(int count) {
    return '$count værter fundet';
  }

  @override
  String get sshConfigImportButton => 'Importer';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count server(e) importeret';
  }

  @override
  String get sshConfigImportDuplicate => 'Findes allerede';

  @override
  String get sshConfigImportNoHosts => 'Ingen værter fundet i konfigurationen';

  @override
  String get sftpBookmarkAdd => 'Tilføj bogmærke';

  @override
  String get sftpBookmarkLabel => 'Etiket';

  @override
  String get disconnect => 'Afbryd forbindelse';

  @override
  String get reportAndDisconnect => 'Rapporter & afbryd';

  @override
  String get continueAnyway => 'Fortsæt alligevel';

  @override
  String get insertSnippet => 'Indsæt kodestykke';

  @override
  String get seconds => 'Sekunder';

  @override
  String get heartbeatLostMessage =>
      'Serveren kunne ikke nås efter flere forsøg. Af sikkerhedshensyn er sessionen blevet afsluttet.';

  @override
  String get attestationFailedTitle => 'Serververificering mislykkedes';

  @override
  String get attestationFailedMessage =>
      'Serveren kunne ikke verificeres som en legitim SSHVault-backend. Dette kan indikere et man-in-the-middle-angreb eller en forkert konfigureret server.';

  @override
  String get attestationKeyChangedTitle => 'Servernøglen er ændret';

  @override
  String get attestationKeyChangedMessage =>
      'Serverens attestationsnøgle er ændret siden den første forbindelse. Dette kan indikere et man-in-the-middle-angreb. Fortsæt IKKE medmindre serveradministratoren har bekræftet en nøglerotation.';

  @override
  String get sectionLinks => 'Links';

  @override
  String get sectionDeveloper => 'Udvikler';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Siden blev ikke fundet';

  @override
  String get connectionTestSuccess => 'Forbindelsen lykkedes';

  @override
  String connectionTestFailed(String message) {
    return 'Forbindelsen mislykkedes: $message';
  }

  @override
  String get serverVerificationFailed => 'Serververificering mislykkedes';

  @override
  String get importSuccessful => 'Import lykkedes';

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
  String get deviceDeleteConfirmTitle => 'Fjern enhed';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Er du sikker på, at du vil fjerne \"$name\"? Enheden logges ud med det samme.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Dette er din nuværende enhed. Du logges ud med det samme.';

  @override
  String get deviceDeleteSuccess => 'Enhed fjernet';

  @override
  String get deviceDeletedCurrentLogout =>
      'Nuværende enhed fjernet. Du er logget ud.';

  @override
  String get thisDevice => 'Denne enhed';
}
