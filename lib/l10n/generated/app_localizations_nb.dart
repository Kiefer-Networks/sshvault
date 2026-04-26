// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Verter';

  @override
  String get navSnippets => 'Kodebiter';

  @override
  String get navFolders => 'Mapper';

  @override
  String get navTags => 'Etiketter';

  @override
  String get navSshKeys => 'SSH-nøkler';

  @override
  String get navExportImport => 'Eksport / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Mer';

  @override
  String get navManagement => 'Administrasjon';

  @override
  String get navSettings => 'Innstillinger';

  @override
  String get navAbout => 'Om';

  @override
  String get lockScreenTitle => 'SSHVault er låst';

  @override
  String get lockScreenUnlock => 'Lås opp';

  @override
  String get lockScreenEnterPin => 'Skriv inn PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'For mange mislykkede forsøk. Prøv igjen om $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Angi PIN-kode';

  @override
  String get pinDialogSetSubtitle =>
      'Skriv inn en 6-sifret PIN for å beskytte SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Bekreft PIN';

  @override
  String get pinDialogErrorLength => 'PIN må være nøyaktig 6 siffer';

  @override
  String get pinDialogErrorMismatch => 'PIN-kodene stemmer ikke overens';

  @override
  String get pinDialogVerifyTitle => 'Skriv inn PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Feil PIN. $attempts forsøk gjenstår.';
  }

  @override
  String get securityBannerMessage =>
      'SSH-legitimasjonen din er ikke beskyttet. Sett opp en PIN eller biometrisk lås i Innstillinger.';

  @override
  String get securityBannerDismiss => 'Avvis';

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get settingsSectionAppearance => 'Utseende';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'SSH-standardverdier';

  @override
  String get settingsSectionSecurity => 'Sikkerhet';

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
  String get settingsDefaultUsername => 'Standard brukernavn';

  @override
  String get settingsDefaultUsernameDialog => 'Standard brukernavn';

  @override
  String get settingsUsernameLabel => 'Brukernavn';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automatisk låsing';

  @override
  String get settingsAutoLockDisabled => 'Deaktivert';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minutter';
  }

  @override
  String get settingsAutoLockOff => 'Av';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Biometrisk opplåsing';

  @override
  String get settingsBiometricNotAvailable =>
      'Ikke tilgjengelig på denne enheten';

  @override
  String get settingsBiometricError => 'Feil ved kontroll av biometri';

  @override
  String get settingsBiometricReason =>
      'Bekreft identiteten din for å aktivere biometrisk opplåsing';

  @override
  String get settingsBiometricRequiresPin =>
      'Sett en PIN først for å aktivere biometrisk opplåsing';

  @override
  String get settingsPinCode => 'PIN-kode';

  @override
  String get settingsPinIsSet => 'PIN er satt';

  @override
  String get settingsPinNotConfigured => 'Ingen PIN konfigurert';

  @override
  String get settingsPinRemove => 'Fjern';

  @override
  String get settingsPinRemoveWarning =>
      'Fjerning av PIN dekrypterer alle databasefelt og deaktiverer biometrisk opplåsing. Fortsette?';

  @override
  String get settingsPinRemoveTitle => 'Fjern PIN';

  @override
  String get settingsPreventScreenshots => 'Forhindre skjermbilder';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Blokker skjermbilder og skjermopptak';

  @override
  String get settingsEncryptExport => 'Krypter eksport som standard';

  @override
  String get settingsAbout => 'Om SSHVault';

  @override
  String get settingsAboutLegalese => 'av Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Sikker, selvhostet SSH-klient';

  @override
  String get settingsLanguage => 'Språk';

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
  String get cancel => 'Avbryt';

  @override
  String get save => 'Lagre';

  @override
  String get delete => 'Slett';

  @override
  String get close => 'Lukk';

  @override
  String get update => 'Oppdater';

  @override
  String get create => 'Opprett';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get copy => 'Kopier';

  @override
  String get edit => 'Rediger';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Feil: $message';
  }

  @override
  String get serverListTitle => 'Verter';

  @override
  String get serverListEmpty => 'Ingen servere ennå';

  @override
  String get serverListEmptySubtitle =>
      'Legg til din første SSH-server for å komme i gang.';

  @override
  String get serverAddButton => 'Legg til server';

  @override
  String sshConfigImportMessage(int count) {
    return 'Fant $count vert(er) i ~/.ssh/config. Importere dem?';
  }

  @override
  String get sshConfigNotFound => 'Ingen SSH-konfigurasjonsfil funnet';

  @override
  String get sshConfigEmpty => 'Ingen verter funnet i SSH-konfigurasjonen';

  @override
  String get sshConfigAddManually => 'Legg til manuelt';

  @override
  String get sshConfigImportAgain => 'Importere SSH-konfigurasjon igjen?';

  @override
  String get sshConfigImportKeys =>
      'Importere SSH-nøkler referert av valgte verter?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH-nøkkel/nøkler importert';
  }

  @override
  String get serverDuplicated => 'Server duplisert';

  @override
  String get serverDeleteTitle => 'Slett server';

  @override
  String serverDeleteMessage(String name) {
    return 'Er du sikker på at du vil slette \"$name\"? Denne handlingen kan ikke angres.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Slette \"$name\"?';
  }

  @override
  String get serverConnect => 'Koble til';

  @override
  String get serverDetails => 'Detaljer';

  @override
  String get serverDuplicate => 'Dupliser';

  @override
  String get serverActive => 'Aktiv';

  @override
  String get serverNoFolder => 'Ingen mappe';

  @override
  String get serverFormTitleEdit => 'Rediger server';

  @override
  String get serverFormTitleAdd => 'Legg til server';

  @override
  String get serverSaved => 'Server lagret';

  @override
  String get serverFormUpdateButton => 'Oppdater server';

  @override
  String get serverFormAddButton => 'Legg til server';

  @override
  String get serverFormPublicKeyExtracted => 'Offentlig nøkkel hentet ut';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Kunne ikke hente ut offentlig nøkkel: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type-nøkkelpar generert';
  }

  @override
  String get serverDetailTitle => 'Serverdetaljer';

  @override
  String get serverDetailDeleteMessage => 'Denne handlingen kan ikke angres.';

  @override
  String get serverDetailConnection => 'Tilkobling';

  @override
  String get serverDetailHost => 'Vert';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Brukernavn';

  @override
  String get serverDetailFolder => 'Mappe';

  @override
  String get serverDetailTags => 'Etiketter';

  @override
  String get serverDetailNotes => 'Notater';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Opprettet';

  @override
  String get serverDetailUpdated => 'Oppdatert';

  @override
  String get serverDetailDistro => 'System';

  @override
  String get copiedToClipboard => 'Kopiert til utklippstavlen';

  @override
  String get serverFormNameLabel => 'Servernavn';

  @override
  String get serverFormHostnameLabel => 'Vertsnavn / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Brukernavn';

  @override
  String get serverFormPasswordLabel => 'Passord';

  @override
  String get serverFormUseManagedKey => 'Bruk administrert nøkkel';

  @override
  String get serverFormManagedKeySubtitle =>
      'Velg fra sentralt administrerte SSH-nøkler';

  @override
  String get serverFormDirectKeySubtitle =>
      'Lim inn nøkkel direkte i denne serveren';

  @override
  String get serverFormGenerateKey => 'Generer SSH-nøkkelpar';

  @override
  String get serverFormPrivateKeyLabel => 'Privat nøkkel';

  @override
  String get serverFormPrivateKeyHint => 'Lim inn SSH privat nøkkel...';

  @override
  String get serverFormExtractPublicKey => 'Hent ut offentlig nøkkel';

  @override
  String get serverFormPublicKeyLabel => 'Offentlig nøkkel';

  @override
  String get serverFormPublicKeyHint =>
      'Autogenerert fra privat nøkkel hvis tom';

  @override
  String get serverFormPassphraseLabel => 'Nøkkelpassord (valgfritt)';

  @override
  String get serverFormNotesLabel => 'Notater (valgfritt)';

  @override
  String get searchServers => 'Søk servere...';

  @override
  String get filterAllFolders => 'Alle mapper';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterActive => 'Aktive';

  @override
  String get filterInactive => 'Inaktive';

  @override
  String get filterClear => 'Tøm';

  @override
  String get folderListTitle => 'Mapper';

  @override
  String get folderListEmpty => 'Ingen mapper ennå';

  @override
  String get folderListEmptySubtitle =>
      'Opprett mapper for å organisere serverne dine.';

  @override
  String get folderAddButton => 'Legg til mappe';

  @override
  String get folderDeleteTitle => 'Slett mappe';

  @override
  String folderDeleteMessage(String name) {
    return 'Slette \"$name\"? Servere blir uorganiserte.';
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
  String get folderCollapse => 'Skjul';

  @override
  String get folderShowHosts => 'Vis verter';

  @override
  String get folderConnectAll => 'Koble til alle';

  @override
  String get folderFormTitleEdit => 'Rediger mappe';

  @override
  String get folderFormTitleNew => 'Ny mappe';

  @override
  String get folderFormNameLabel => 'Mappenavn';

  @override
  String get folderFormParentLabel => 'Overordnet mappe';

  @override
  String get folderFormParentNone => 'Ingen (rot)';

  @override
  String get tagListTitle => 'Etiketter';

  @override
  String get tagListEmpty => 'Ingen etiketter ennå';

  @override
  String get tagListEmptySubtitle =>
      'Opprett etiketter for å merke og filtrere serverne dine.';

  @override
  String get tagAddButton => 'Legg til etikett';

  @override
  String get tagDeleteTitle => 'Slett etikett';

  @override
  String tagDeleteMessage(String name) {
    return 'Slette \"$name\"? Den fjernes fra alle servere.';
  }

  @override
  String get tagFormTitleEdit => 'Rediger etikett';

  @override
  String get tagFormTitleNew => 'Ny etikett';

  @override
  String get tagFormNameLabel => 'Etikettnavn';

  @override
  String get sshKeyListTitle => 'SSH-nøkler';

  @override
  String get sshKeyListEmpty => 'Ingen SSH-nøkler ennå';

  @override
  String get sshKeyListEmptySubtitle =>
      'Generer eller importer SSH-nøkler for å administrere dem sentralt';

  @override
  String get sshKeyCannotDeleteTitle => 'Kan ikke slette';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Kan ikke slette \"$name\". Brukes av $count server(e). Koble fra alle servere først.';
  }

  @override
  String get sshKeyDeleteTitle => 'Slett SSH-nøkkel';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Slette \"$name\"? Dette kan ikke angres.';
  }

  @override
  String get sshKeyAddButton => 'Legg til SSH-nøkkel';

  @override
  String get sshKeyFormTitleEdit => 'Rediger SSH-nøkkel';

  @override
  String get sshKeyFormTitleAdd => 'Legg til SSH-nøkkel';

  @override
  String get sshKeyFormTabGenerate => 'Generer';

  @override
  String get sshKeyFormTabImport => 'Importer';

  @override
  String get sshKeyFormNameLabel => 'Nøkkelnavn';

  @override
  String get sshKeyFormNameHint => 'f.eks. Min produksjonsnøkkel';

  @override
  String get sshKeyFormKeyType => 'Nøkkeltype';

  @override
  String get sshKeyFormKeySize => 'Nøkkelstørrelse';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Kommentar';

  @override
  String get sshKeyFormCommentHint => 'user@host eller beskrivelse';

  @override
  String get sshKeyFormCommentOptional => 'Kommentar (valgfritt)';

  @override
  String get sshKeyFormImportFromFile => 'Importer fra fil';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Privat nøkkel';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Lim inn SSH privat nøkkel eller bruk knappen ovenfor...';

  @override
  String get sshKeyFormPassphraseLabel => 'Passordsetning (valgfritt)';

  @override
  String get sshKeyFormNameRequired => 'Navn er påkrevd';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Privat nøkkel er påkrevd';

  @override
  String get sshKeyFormFileReadError => 'Kunne ikke lese den valgte filen';

  @override
  String get sshKeyFormInvalidFormat =>
      'Ugyldig nøkkelformat — forventet PEM-format (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Kunne ikke lese filen: $message';
  }

  @override
  String get sshKeyFormSaving => 'Lagrer...';

  @override
  String get sshKeySelectorLabel => 'SSH-nøkkel';

  @override
  String get sshKeySelectorNone => 'Ingen administrert nøkkel';

  @override
  String get sshKeySelectorManage => 'Administrer nøkler...';

  @override
  String get sshKeySelectorError => 'Kunne ikke laste SSH-nøkler';

  @override
  String get sshKeyTileCopyPublicKey => 'Kopier offentlig nøkkel';

  @override
  String get sshKeyTilePublicKeyCopied => 'Offentlig nøkkel kopiert';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Brukes av $count server(e)';
  }

  @override
  String get sshKeySavedSuccess => 'SSH-nøkkel lagret';

  @override
  String get sshKeyDeletedSuccess => 'SSH-nøkkel slettet';

  @override
  String get tagSavedSuccess => 'Tagg lagret';

  @override
  String get tagDeletedSuccess => 'Tagg slettet';

  @override
  String get folderDeletedSuccess => 'Mappe slettet';

  @override
  String get sshKeyTileUnlinkFirst => 'Koble fra alle servere først';

  @override
  String get exportImportTitle => 'Eksport / Import';

  @override
  String get exportSectionTitle => 'Eksport';

  @override
  String get exportJsonButton => 'Eksporter som JSON (uten legitimasjon)';

  @override
  String get exportZipButton => 'Eksporter kryptert ZIP (med legitimasjon)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Importer fra fil';

  @override
  String get importSupportedFormats =>
      'Støtter JSON (ukryptert) og ZIP (kryptert) filer.';

  @override
  String exportedTo(String path) {
    return 'Eksportert til: $path';
  }

  @override
  String get share => 'Del';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Importerte $servers servere, $groups grupper, $tags etiketter. $skipped hoppet over.';
  }

  @override
  String get importPasswordTitle => 'Skriv inn passord';

  @override
  String get importPasswordLabel => 'Eksportpassord';

  @override
  String get importPasswordDecrypt => 'Dekrypter';

  @override
  String get exportPasswordTitle => 'Angi eksportpassord';

  @override
  String get exportPasswordDescription =>
      'Dette passordet brukes til å kryptere eksportfilen inkludert legitimasjon.';

  @override
  String get exportPasswordLabel => 'Passord';

  @override
  String get exportPasswordConfirmLabel => 'Bekreft passord';

  @override
  String get exportPasswordMismatch => 'Passordene stemmer ikke overens';

  @override
  String get exportPasswordButton => 'Krypter & eksporter';

  @override
  String get importConflictTitle => 'Håndter konflikter';

  @override
  String get importConflictDescription =>
      'Hvordan skal eksisterende oppføringer håndteres under import?';

  @override
  String get importConflictSkip => 'Hopp over eksisterende';

  @override
  String get importConflictRename => 'Gi nye nytt navn';

  @override
  String get importConflictOverwrite => 'Overskriv';

  @override
  String get confirmDeleteLabel => 'Slett';

  @override
  String get keyGenTitle => 'Generer SSH-nøkkelpar';

  @override
  String get keyGenKeyType => 'Nøkkeltype';

  @override
  String get keyGenKeySize => 'Nøkkelstørrelse';

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
    return '$type-nøkkel generert';
  }

  @override
  String get keyGenPublicKey => 'Offentlig nøkkel';

  @override
  String get keyGenPrivateKey => 'Privat nøkkel';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Kommentar: $comment';
  }

  @override
  String get keyGenAnother => 'Generer en til';

  @override
  String get keyGenUseThisKey => 'Bruk denne nøkkelen';

  @override
  String get keyGenCopyTooltip => 'Kopier til utklippstavlen';

  @override
  String keyGenCopied(String label) {
    return '$label kopiert';
  }

  @override
  String get colorPickerLabel => 'Farge';

  @override
  String get iconPickerLabel => 'Ikon';

  @override
  String get tagSelectorLabel => 'Etiketter';

  @override
  String get tagSelectorEmpty => 'Ingen etiketter ennå';

  @override
  String get tagSelectorError => 'Kunne ikke laste etiketter';

  @override
  String get snippetListTitle => 'Kodebiter';

  @override
  String get snippetSearchHint => 'Søk kodebiter...';

  @override
  String get snippetListEmpty => 'Ingen kodebiter ennå';

  @override
  String get snippetListEmptySubtitle =>
      'Opprett gjenbrukbare kodebiter og kommandoer.';

  @override
  String get snippetAddButton => 'Legg til kodebit';

  @override
  String get snippetDeleteTitle => 'Slett kodebit';

  @override
  String snippetDeleteMessage(String name) {
    return 'Slette \"$name\"? Dette kan ikke angres.';
  }

  @override
  String get snippetFormTitleEdit => 'Rediger kodebit';

  @override
  String get snippetFormTitleNew => 'Ny kodebit';

  @override
  String get snippetFormNameLabel => 'Navn';

  @override
  String get snippetFormNameHint => 'f.eks. Docker-opprydding';

  @override
  String get snippetFormLanguageLabel => 'Språk';

  @override
  String get snippetFormContentLabel => 'Innhold';

  @override
  String get snippetFormContentHint => 'Skriv inn kodebit-koden din...';

  @override
  String get snippetFormDescriptionLabel => 'Beskrivelse';

  @override
  String get snippetFormDescriptionHint => 'Valgfri beskrivelse...';

  @override
  String get snippetFormFolderLabel => 'Mappe';

  @override
  String get snippetFormNoFolder => 'Ingen mappe';

  @override
  String get snippetFormNameRequired => 'Navn er påkrevd';

  @override
  String get snippetFormContentRequired => 'Innhold er påkrevd';

  @override
  String get snippetFormSaved => 'Snippet lagret';

  @override
  String get snippetFormUpdateButton => 'Oppdater kodebit';

  @override
  String get snippetFormCreateButton => 'Opprett kodebit';

  @override
  String get snippetDetailTitle => 'Kodebitdetaljer';

  @override
  String get snippetDetailDeleteTitle => 'Slett kodebit';

  @override
  String get snippetDetailDeleteMessage => 'Denne handlingen kan ikke angres.';

  @override
  String get snippetDetailContent => 'Innhold';

  @override
  String get snippetDetailFillVariables => 'Fyll inn variabler';

  @override
  String get snippetDetailDescription => 'Beskrivelse';

  @override
  String get snippetDetailVariables => 'Variabler';

  @override
  String get snippetDetailTags => 'Etiketter';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Opprettet';

  @override
  String get snippetDetailUpdated => 'Oppdatert';

  @override
  String get variableEditorTitle => 'Malvariabler';

  @override
  String get variableEditorAdd => 'Legg til';

  @override
  String get variableEditorEmpty =>
      'Ingen variabler. Bruk krøllparentessyntaks i innholdet for å referere til dem.';

  @override
  String get variableEditorNameLabel => 'Navn';

  @override
  String get variableEditorNameHint => 'f.eks. hostname';

  @override
  String get variableEditorDefaultLabel => 'Standard';

  @override
  String get variableEditorDefaultHint => 'valgfritt';

  @override
  String get variableFillTitle => 'Fyll inn variabler';

  @override
  String variableFillHint(String name) {
    return 'Skriv inn verdi for $name';
  }

  @override
  String get variableFillPreview => 'Forhåndsvisning';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Ingen aktive økter';

  @override
  String get terminalEmptySubtitle =>
      'Koble til en vert for å åpne en terminaløkt.';

  @override
  String get terminalGoToHosts => 'Gå til verter';

  @override
  String get terminalCloseAll => 'Lukk alle økter';

  @override
  String get terminalCloseTitle => 'Lukk økt';

  @override
  String terminalCloseMessage(String title) {
    return 'Lukke den aktive tilkoblingen til \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Autentiserer...';

  @override
  String connectionConnecting(String name) {
    return 'Kobler til $name...';
  }

  @override
  String get connectionError => 'Tilkoblingsfeil';

  @override
  String get connectionLost => 'Tilkoblingen mistet';

  @override
  String get connectionReconnect => 'Koble til igjen';

  @override
  String get snippetQuickPanelTitle => 'Sett inn kodebit';

  @override
  String get snippetQuickPanelSearch => 'Søk kodebiter...';

  @override
  String get snippetQuickPanelEmpty => 'Ingen kodebiter tilgjengelig';

  @override
  String get snippetQuickPanelNoMatch => 'Ingen samsvarende kodebiter';

  @override
  String get snippetQuickPanelInsertTooltip => 'Sett inn kodebit';

  @override
  String get terminalThemePickerTitle => 'Terminaltema';

  @override
  String get validatorHostnameRequired => 'Vertsnavn er påkrevd';

  @override
  String get validatorHostnameInvalid => 'Ugyldig vertsnavn eller IP-adresse';

  @override
  String get validatorPortRequired => 'Port er påkrevd';

  @override
  String get validatorPortRange => 'Port må være mellom 1 og 65535';

  @override
  String get validatorUsernameRequired => 'Brukernavn er påkrevd';

  @override
  String get validatorUsernameInvalid => 'Ugyldig brukernavnformat';

  @override
  String get validatorServerNameRequired => 'Servernavn er påkrevd';

  @override
  String get validatorServerNameLength =>
      'Servernavn må være 100 tegn eller mindre';

  @override
  String get validatorSshKeyInvalid => 'Ugyldig SSH-nøkkelformat';

  @override
  String get validatorPasswordRequired => 'Passord er påkrevd';

  @override
  String get validatorPasswordLength => 'Passord må være minst 8 tegn';

  @override
  String get authMethodPassword => 'Passord';

  @override
  String get authMethodKey => 'SSH-nøkkel';

  @override
  String get authMethodBoth => 'Passord + nøkkel';

  @override
  String get serverCopySuffix => '(Kopi)';

  @override
  String get settingsDownloadLogs => 'Last ned logger';

  @override
  String get settingsSendLogs => 'Send logger til kundestøtte';

  @override
  String get settingsLogsSaved => 'Logger lagret';

  @override
  String get settingsUpdated => 'Innstilling oppdatert';

  @override
  String get settingsThemeChanged => 'Tema endret';

  @override
  String get settingsLanguageChanged => 'Språk endret';

  @override
  String get settingsPinSetSuccess => 'PIN satt';

  @override
  String get settingsPinRemovedSuccess => 'PIN fjernet';

  @override
  String get settingsDuressPinSetSuccess => 'Tvangskode satt';

  @override
  String get settingsDuressPinRemovedSuccess => 'Tvangskode fjernet';

  @override
  String get settingsBiometricEnabled => 'Biometrisk opplåsing aktivert';

  @override
  String get settingsBiometricDisabled => 'Biometrisk opplåsing deaktivert';

  @override
  String get settingsDnsServerAdded => 'DNS-server lagt til';

  @override
  String get settingsDnsServerRemoved => 'DNS-server fjernet';

  @override
  String get settingsDnsResetSuccess => 'DNS-servere tilbakestilt';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Reduser skrift';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Øk skrift';

  @override
  String get settingsDnsRemoveServerTooltip => 'Fjern DNS-server';

  @override
  String get settingsLogsEmpty => 'Ingen loggoppføringer tilgjengelig';

  @override
  String get authLogin => 'Logg inn';

  @override
  String get authRegister => 'Registrer';

  @override
  String get authForgotPassword => 'Glemt passord?';

  @override
  String get authWhyLogin =>
      'Logg inn for å aktivere kryptert skysynkronisering på alle enhetene dine. Appen fungerer fullt offline uten en konto.';

  @override
  String get authEmailLabel => 'E-post';

  @override
  String get authEmailRequired => 'E-post er påkrevd';

  @override
  String get authEmailInvalid => 'Ugyldig e-postadresse';

  @override
  String get authPasswordLabel => 'Passord';

  @override
  String get authConfirmPasswordLabel => 'Bekreft passord';

  @override
  String get authPasswordMismatch => 'Passordene stemmer ikke overens';

  @override
  String get authNoAccount => 'Ingen konto?';

  @override
  String get authHasAccount => 'Har du allerede en konto?';

  @override
  String get authResetEmailSent =>
      'Hvis en konto finnes, har en tilbakestillingslenke blitt sendt til e-posten din.';

  @override
  String get authResetDescription =>
      'Skriv inn e-postadressen din, så sender vi deg en lenke for å tilbakestille passordet ditt.';

  @override
  String get authSendResetLink => 'Send tilbakestillingslenke';

  @override
  String get authBackToLogin => 'Tilbake til innlogging';

  @override
  String get syncPasswordTitle => 'Synkroniseringspassord';

  @override
  String get syncPasswordTitleCreate => 'Angi synkroniseringspassord';

  @override
  String get syncPasswordTitleEnter => 'Skriv inn synkroniseringspassord';

  @override
  String get syncPasswordDescription =>
      'Angi et separat passord for å kryptere hvelvdataene dine. Dette passordet forlater aldri enheten din — serveren lagrer bare kryptert data.';

  @override
  String get syncPasswordHintEnter =>
      'Skriv inn passordet du satte da du opprettet kontoen din.';

  @override
  String get syncPasswordWarning =>
      'Hvis du glemmer dette passordet, kan de synkroniserte dataene dine ikke gjenopprettes. Det finnes ingen tilbakestillingsmulighet.';

  @override
  String get syncPasswordLabel => 'Synkroniseringspassord';

  @override
  String get syncPasswordWrong => 'Feil passord. Prøv igjen.';

  @override
  String get firstSyncTitle => 'Eksisterende data funnet';

  @override
  String get firstSyncMessage =>
      'Denne enheten har eksisterende data og serveren har et hvelv. Hvordan skal vi fortsette?';

  @override
  String get firstSyncMerge => 'Slå sammen (serveren vinner)';

  @override
  String get firstSyncOverwriteLocal => 'Overskriv lokale data';

  @override
  String get firstSyncKeepLocal => 'Behold lokale & push';

  @override
  String get firstSyncDeleteLocal => 'Slett lokale & pull';

  @override
  String get changeEncryptionPassword => 'Endre krypteringspassord';

  @override
  String get changeEncryptionWarning =>
      'Du blir logget ut på alle andre enheter.';

  @override
  String get changeEncryptionOldPassword => 'Nåværende passord';

  @override
  String get changeEncryptionNewPassword => 'Nytt passord';

  @override
  String get changeEncryptionSuccess => 'Passord endret.';

  @override
  String get logoutAllDevices => 'Logg ut fra alle enheter';

  @override
  String get logoutAllDevicesConfirm =>
      'Dette tilbakekaller alle aktive økter. Du må logge inn igjen på alle enheter.';

  @override
  String get logoutAllDevicesSuccess => 'Alle enheter logget ut.';

  @override
  String get syncSettingsTitle => 'Synkroniseringsinnstillinger';

  @override
  String get syncAutoSync => 'Autosynkronisering';

  @override
  String get syncAutoSyncDescription =>
      'Synkroniser automatisk når appen starter';

  @override
  String get syncNow => 'Synkroniser nå';

  @override
  String get syncSyncing => 'Synkroniserer...';

  @override
  String get syncSuccess => 'Synkronisering fullført';

  @override
  String get syncError => 'Synkroniseringsfeil';

  @override
  String get syncServerUnreachable => 'Serveren kan ikke nås';

  @override
  String get syncServerUnreachableHint =>
      'Synkroniseringsserveren kunne ikke nås. Sjekk internettforbindelsen og server-URL-en din.';

  @override
  String get syncNetworkError =>
      'Tilkobling til server mislyktes. Sjekk internettforbindelsen din eller prøv igjen senere.';

  @override
  String get syncNeverSynced => 'Aldri synkronisert';

  @override
  String get syncVaultVersion => 'Hvelvversjon';

  @override
  String get syncTitle => 'Synkronisering';

  @override
  String get settingsSectionNetwork => 'Nettverk & DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS-servere';

  @override
  String get settingsDnsDefault => 'Standard (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Skriv inn egendefinerte DoH-serveradresser, adskilt med komma. Minst 2 servere trengs for kryssverifisering.';

  @override
  String get settingsDnsLabel => 'DoH-serveradresser';

  @override
  String get settingsDnsReset => 'Tilbakestill til standard';

  @override
  String get settingsSectionSync => 'Synkronisering';

  @override
  String get settingsSyncAccount => 'Konto';

  @override
  String get settingsSyncNotLoggedIn => 'Ikke logget inn';

  @override
  String get settingsSyncStatus => 'Synkronisering';

  @override
  String get settingsSyncServerUrl => 'Server-URL';

  @override
  String get settingsSyncDefaultServer => 'Standard (sshvault.app)';

  @override
  String get accountTitle => 'Konto';

  @override
  String get accountNotLoggedIn => 'Ikke logget inn';

  @override
  String get accountVerified => 'Verifisert';

  @override
  String get accountMemberSince => 'Medlem siden';

  @override
  String get accountDevices => 'Enheter';

  @override
  String get accountNoDevices => 'Ingen enheter registrert';

  @override
  String get accountLastSync => 'Siste synkronisering';

  @override
  String get accountChangePassword => 'Endre passord';

  @override
  String get accountOldPassword => 'Nåværende passord';

  @override
  String get accountNewPassword => 'Nytt passord';

  @override
  String get accountDeleteAccount => 'Slett konto';

  @override
  String get accountDeleteWarning =>
      'Dette sletter kontoen din og alle synkroniserte data permanent. Dette kan ikke angres.';

  @override
  String get accountLogout => 'Logg ut';

  @override
  String get serverConfigTitle => 'Serverkonfigurasjon';

  @override
  String get serverConfigUrlLabel => 'Server-URL';

  @override
  String get serverConfigTest => 'Test tilkobling';

  @override
  String get serverSetupTitle => 'Serveroppsett';

  @override
  String get serverSetupInfoCard =>
      'ShellVault krever en selvhostet server for ende-til-ende kryptert synkronisering. Distribuer din egen instans for å komme i gang.';

  @override
  String get serverSetupRepoLink => 'Vis på GitHub';

  @override
  String get serverSetupContinue => 'Fortsett';

  @override
  String get settingsServerNotConfigured => 'Ingen server konfigurert';

  @override
  String get settingsSetupSync =>
      'Konfigurer synkronisering for å sikkerhetskopiere dataene dine';

  @override
  String get settingsChangeServer => 'Bytt server';

  @override
  String get settingsChangeServerConfirm =>
      'Å bytte server vil logge deg ut. Fortsette?';

  @override
  String get auditLogTitle => 'Aktivitetslogg';

  @override
  String get auditLogAll => 'Alle';

  @override
  String get auditLogEmpty => 'Ingen aktivitetslogger funnet';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Filbehandler';

  @override
  String get sftpLocalDevice => 'Lokal enhet';

  @override
  String get sftpSelectServer => 'Velg server...';

  @override
  String get sftpConnecting => 'Kobler til...';

  @override
  String get sftpEmptyDirectory => 'Denne katalogen er tom';

  @override
  String get sftpNoConnection => 'Ingen server tilkoblet';

  @override
  String get sftpPathLabel => 'Sti';

  @override
  String get sftpUpload => 'Last opp';

  @override
  String get sftpDownload => 'Last ned';

  @override
  String get sftpDelete => 'Slett';

  @override
  String get sftpRename => 'Gi nytt navn';

  @override
  String get sftpNewFolder => 'Ny mappe';

  @override
  String get sftpNewFolderName => 'Mappenavn';

  @override
  String get sftpChmod => 'Tillatelser';

  @override
  String get sftpChmodTitle => 'Endre tillatelser';

  @override
  String get sftpChmodOctal => 'Oktal';

  @override
  String get sftpChmodOwner => 'Eier';

  @override
  String get sftpChmodGroup => 'Gruppe';

  @override
  String get sftpChmodOther => 'Andre';

  @override
  String get sftpChmodRead => 'Lese';

  @override
  String get sftpChmodWrite => 'Skrive';

  @override
  String get sftpChmodExecute => 'Kjøre';

  @override
  String get sftpCreateSymlink => 'Opprett symlenke';

  @override
  String get sftpSymlinkTarget => 'Målsti';

  @override
  String get sftpSymlinkName => 'Lenkenavn';

  @override
  String get sftpFilePreview => 'Filforhåndsvisning';

  @override
  String get sftpFileInfo => 'Filinformasjon';

  @override
  String get sftpFileSize => 'Størrelse';

  @override
  String get sftpFileModified => 'Endret';

  @override
  String get sftpFilePermissions => 'Tillatelser';

  @override
  String get sftpFileOwner => 'Eier';

  @override
  String get sftpFileType => 'Type';

  @override
  String get sftpFileLinkTarget => 'Lenkemål';

  @override
  String get sftpTransfers => 'Overføringer';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current av $total';
  }

  @override
  String get sftpTransferQueued => 'I kø';

  @override
  String get sftpTransferActive => 'Overfører...';

  @override
  String get sftpTransferPaused => 'Satt på pause';

  @override
  String get sftpTransferCompleted => 'Fullført';

  @override
  String get sftpTransferFailed => 'Mislykket';

  @override
  String get sftpTransferCancelled => 'Avbrutt';

  @override
  String get sftpPauseTransfer => 'Pause';

  @override
  String get sftpResumeTransfer => 'Gjenoppta';

  @override
  String get sftpCancelTransfer => 'Avbryt';

  @override
  String get sftpClearCompleted => 'Fjern fullførte';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active av $total overføringer';
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
      other: '$count fullførte',
      one: '1 fullført',
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
  String get sftpCopyToOtherPane => 'Kopier til andre panel';

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
  String get sftpRenameTitle => 'Gi nytt navn';

  @override
  String get sftpRenameLabel => 'Nytt navn';

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
  String get sftpSelectAll => 'Velg alle';

  @override
  String get sftpDeselectAll => 'Opphev valg';

  @override
  String sftpItemsSelected(int count) {
    return '$count valgt';
  }

  @override
  String get sftpRefresh => 'Oppdater';

  @override
  String sftpConnectionError(String message) {
    return 'Tilkobling mislyktes: $message';
  }

  @override
  String get sftpPermissionDenied => 'Tilgang nektet';

  @override
  String sftpOperationFailed(String message) {
    return 'Operasjonen mislyktes: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Filen finnes allerede';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" finnes allerede. Overskrive?';
  }

  @override
  String get sftpOverwrite => 'Overskriv';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Overføring startet: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Velg en destinasjon i det andre panelet først';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Katalogoverføring kommer snart';

  @override
  String get sftpSelect => 'Velg';

  @override
  String get sftpOpen => 'Åpne';

  @override
  String get sftpExtractArchive => 'Pakk ut her';

  @override
  String get sftpExtractSuccess => 'Arkiv pakket ut';

  @override
  String sftpExtractFailed(String message) {
    return 'Utpakking mislyktes: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Arkivformat støttes ikke';

  @override
  String get sftpExtracting => 'Pakker ut...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count opplastinger startet',
      one: 'Opplasting startet',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nedlastinger startet',
      one: 'Nedlasting startet',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" lastet ned';
  }

  @override
  String get sftpSavedToDownloads => 'Lagret i Nedlastinger/SSHVault';

  @override
  String get sftpSaveToFiles => 'Lagre til filer';

  @override
  String get sftpFileSaved => 'Fil lagret';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH-økter aktive',
      one: 'SSH-økt aktiv',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Trykk for å åpne terminalen';

  @override
  String get settingsAccountAndSync => 'Konto & synkronisering';

  @override
  String get settingsAccountSubtitleAuth => 'Logget inn';

  @override
  String get settingsAccountSubtitleUnauth => 'Ikke logget inn';

  @override
  String get settingsSecuritySubtitle => 'Autolås, biometri, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Bruker root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, språk, terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Krypterte eksportstandarder';

  @override
  String get settingsAboutSubtitle => 'Versjon, lisenser';

  @override
  String get settingsSearchHint => 'Søk innstillinger...';

  @override
  String get settingsSearchNoResults => 'Ingen innstillinger funnet';

  @override
  String get aboutDeveloper => 'Utviklet av Kiefer Networks';

  @override
  String get aboutDonate => 'Doner';

  @override
  String get aboutOpenSourceLicenses => 'Åpen kildekode-lisenser';

  @override
  String get aboutWebsite => 'Nettside';

  @override
  String get aboutVersion => 'Versjon';

  @override
  String get aboutBuild => 'Bygg';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS krypterer DNS-spørringer og forhindrer DNS-forfalskning. SSHVault sjekker vertsnavn mot flere leverandører for å oppdage angrep.';

  @override
  String get settingsDnsAddServer => 'Legg til DNS-server';

  @override
  String get settingsDnsServerUrl => 'Server-URL';

  @override
  String get settingsDnsDefaultBadge => 'Standard';

  @override
  String get settingsDnsResetDefaults => 'Tilbakestill til standard';

  @override
  String get settingsDnsInvalidUrl => 'Skriv inn en gyldig HTTPS-URL';

  @override
  String get settingsDefaultAuthMethod => 'Autentiseringsmetode';

  @override
  String get settingsAuthPassword => 'Passord';

  @override
  String get settingsAuthKey => 'SSH-nøkkel';

  @override
  String get settingsConnectionTimeout => 'Tilkoblingstidsavbrudd';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Keep-Alive-intervall';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Komprimering';

  @override
  String get settingsCompressionDescription =>
      'Aktiver zlib-komprimering for SSH-tilkoblinger';

  @override
  String get settingsTerminalType => 'Terminaltype';

  @override
  String get settingsSectionConnection => 'Tilkobling';

  @override
  String get settingsClipboardAutoClear =>
      'Automatisk tømming av utklippstavlen';

  @override
  String get settingsClipboardAutoClearOff => 'Av';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Økttidsavbrudd';

  @override
  String get settingsSessionTimeoutOff => 'Av';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'Nød-PIN';

  @override
  String get settingsDuressPinDescription =>
      'En separat PIN som sletter all data når den skrives inn';

  @override
  String get settingsDuressPinSet => 'Nød-PIN er satt';

  @override
  String get settingsDuressPinNotSet => 'Ikke konfigurert';

  @override
  String get settingsDuressPinWarning =>
      'Å skrive inn denne PIN-en sletter permanent all lokal data inkludert legitimasjon, nøkler og innstillinger. Dette kan ikke angres.';

  @override
  String get settingsKeyRotationReminder => 'Påminnelse om nøkkelrotasjon';

  @override
  String get settingsKeyRotationOff => 'Av';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days dager';
  }

  @override
  String get settingsFailedAttempts => 'Mislykkede PIN-forsøk';

  @override
  String get settingsSectionAppLock => 'Applås';

  @override
  String get settingsSectionPrivacy => 'Personvern';

  @override
  String get settingsSectionReminders => 'Påminnelser';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle =>
      'Eksport, import & sikkerhetskopiering';

  @override
  String get settingsExportJson => 'Eksporter som JSON';

  @override
  String get settingsExportEncrypted => 'Eksporter kryptert';

  @override
  String get settingsImportFile => 'Importer fra fil';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Filtrer servere';

  @override
  String get filterApply => 'Bruk filtre';

  @override
  String get filterClearAll => 'Fjern alle';

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
  String get filterTags => 'Etiketter';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Løst forhåndsvisning';

  @override
  String get variableInsert => 'Sett inn';

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
      other: '$count økter tilbakekalt.',
      one: '1 økt tilbakekalt.',
    );
    return '$_temp0 Du har blitt logget ut.';
  }

  @override
  String get keyGenPassphrase => 'Passordsetning';

  @override
  String get keyGenPassphraseHint =>
      'Valgfritt — beskytter den private nøkkelen';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Standard (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'En nøkkel med samme fingeravtrykk finnes allerede: \"$name\". Hver SSH-nøkkel må være unik.';
  }

  @override
  String get sshKeyFingerprint => 'Fingeravtrykk';

  @override
  String get sshKeyPublicKey => 'Offentlig nøkkel';

  @override
  String get jumpHost => 'Hoppvert';

  @override
  String get jumpHostNone => 'Ingen';

  @override
  String get jumpHostLabel => 'Koble til via hoppvert';

  @override
  String get jumpHostSelfError => 'En server kan ikke være sin egen hoppvert';

  @override
  String get jumpHostConnecting => 'Kobler til hoppvert...';

  @override
  String get jumpHostCircularError => 'Sirkulær hoppvertskjede oppdaget';

  @override
  String get logoutDialogTitle => 'Logg ut';

  @override
  String get logoutDialogMessage =>
      'Vil du slette all lokal data? Servere, SSH-nøkler, kodebiter og innstillinger fjernes fra denne enheten.';

  @override
  String get logoutOnly => 'Bare logg ut';

  @override
  String get logoutAndDelete => 'Logg ut & slett data';

  @override
  String get changeAvatar => 'Endre avatar';

  @override
  String get removeAvatar => 'Fjern avatar';

  @override
  String get avatarUploadFailed => 'Kunne ikke laste opp avatar';

  @override
  String get avatarTooLarge => 'Bildet er for stort';

  @override
  String get deviceLastSeen => 'Sist sett';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Server-URL kan ikke endres mens du er logget inn. Logg ut først.';

  @override
  String get serverListNoFolder => 'Ukategorisert';

  @override
  String get autoSyncInterval => 'Synkroniseringsintervall';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Proxyinnstillinger';

  @override
  String get proxyType => 'Proxytype';

  @override
  String get proxyNone => 'Ingen proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxyvert';

  @override
  String get proxyPort => 'Proxyport';

  @override
  String get proxyUsername => 'Proxybrukernavn';

  @override
  String get proxyPassword => 'Proxypassord';

  @override
  String get proxyUseGlobal => 'Bruk global proxy';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Serverspesifikk';

  @override
  String get proxyTestConnection => 'Test tilkobling';

  @override
  String get proxyTestSuccess => 'Proxy nåbar';

  @override
  String get proxyTestFailed => 'Proxy ikke nåbar';

  @override
  String get proxyDefaultProxy => 'Standardproxy';

  @override
  String get vpnRequired => 'VPN påkrevd';

  @override
  String get vpnRequiredTooltip =>
      'Vis advarsel ved tilkobling uten aktivt VPN';

  @override
  String get vpnActive => 'VPN aktivt';

  @override
  String get vpnInactive => 'VPN inaktivt';

  @override
  String get vpnWarningTitle => 'VPN ikke aktivt';

  @override
  String get vpnWarningMessage =>
      'Denne serveren krever VPN-tilkobling, men ingen VPN er aktiv. Vil du koble til likevel?';

  @override
  String get vpnConnectAnyway => 'Koble til likevel';

  @override
  String get postConnectCommands => 'Kommandoer etter tilkobling';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Kommandoer som kjøres automatisk etter tilkobling (en per linje)';

  @override
  String get dashboardFavorites => 'Favoritter';

  @override
  String get dashboardRecent => 'Siste';

  @override
  String get dashboardActiveSessions => 'Aktive økter';

  @override
  String get addToFavorites => 'Legg til i favoritter';

  @override
  String get removeFromFavorites => 'Fjern fra favoritter';

  @override
  String get noRecentConnections => 'Ingen siste tilkoblinger';

  @override
  String get terminalSplit => 'Delt visning';

  @override
  String get terminalUnsplit => 'Lukk deling';

  @override
  String get terminalSelectSession => 'Velg økt for delt visning';

  @override
  String get knownHostsTitle => 'Kjente verter';

  @override
  String get knownHostsSubtitle => 'Administrer klarerte serverfingeravtrykk';

  @override
  String get hostKeyNewTitle => 'Ny vert';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Første tilkobling til $hostname:$port. Verifiser fingeravtrykket før du kobler til.';
  }

  @override
  String get hostKeyChangedTitle => 'Vertsnøkkel endret!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Vertsnøkkelen for $hostname:$port har endret seg. Dette kan tyde på en sikkerhetstrussel.';
  }

  @override
  String get hostKeyFingerprint => 'Fingeravtrykk';

  @override
  String get hostKeyType => 'Nøkkeltype';

  @override
  String get hostKeyTrustConnect => 'Stol på & koble til';

  @override
  String get hostKeyAcceptNew => 'Godta ny nøkkel';

  @override
  String get hostKeyReject => 'Avvis';

  @override
  String get hostKeyPreviousFingerprint => 'Forrige fingeravtrykk';

  @override
  String get hostKeyDeleteAll => 'Slett alle kjente verter';

  @override
  String get hostKeyDeleteConfirm =>
      'Er du sikker på at du vil fjerne alle kjente verter? Du blir spurt igjen ved neste tilkobling.';

  @override
  String get hostKeyEmpty => 'Ingen kjente verter ennå';

  @override
  String get hostKeyEmptySubtitle =>
      'Vertsfingeravtrykk lagres her etter din første tilkobling';

  @override
  String get hostKeyFirstSeen => 'Første gang sett';

  @override
  String get hostKeyLastSeen => 'Sist sett';

  @override
  String get sshConfigImportTitle => 'Importer SSH-konfigurasjon';

  @override
  String get sshConfigImportPickFile => 'Velg SSH-konfigurasjonsfil';

  @override
  String get sshConfigImportOrPaste => 'Eller lim inn konfigurasjonsinnhold';

  @override
  String sshConfigImportParsed(int count) {
    return '$count verter funnet';
  }

  @override
  String get sshConfigImportButton => 'Importer';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count server(e) importert';
  }

  @override
  String get sshConfigImportDuplicate => 'Finnes allerede';

  @override
  String get sshConfigImportNoHosts => 'Ingen verter funnet i konfigurasjonen';

  @override
  String get sftpBookmarkAdd => 'Legg til bokmerke';

  @override
  String get sftpBookmarkLabel => 'Etikett';

  @override
  String get disconnect => 'Koble fra';

  @override
  String get reportAndDisconnect => 'Rapporter & koble fra';

  @override
  String get continueAnyway => 'Fortsett likevel';

  @override
  String get insertSnippet => 'Sett inn kodebit';

  @override
  String get seconds => 'Sekunder';

  @override
  String get heartbeatLostMessage =>
      'Serveren kunne ikke nås etter flere forsøk. Av sikkerhetshensyn har økten blitt avsluttet.';

  @override
  String get attestationFailedTitle => 'Serververifisering mislyktes';

  @override
  String get attestationFailedMessage =>
      'Serveren kunne ikke verifiseres som en legitim SSHVault-backend. Dette kan tyde på et man-in-the-middle-angrep eller en feilkonfigurert server.';

  @override
  String get attestationKeyChangedTitle => 'Servernøkkelen har endret seg';

  @override
  String get attestationKeyChangedMessage =>
      'Serverens attestasjonsnøkkel har endret seg siden den første tilkoblingen. Dette kan tyde på et man-in-the-middle-angrep. IKKE fortsett med mindre serveradministratoren har bekreftet en nøkkelrotasjon.';

  @override
  String get sectionLinks => 'Lenker';

  @override
  String get sectionDeveloper => 'Utvikler';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Siden ble ikke funnet';

  @override
  String get connectionTestSuccess => 'Tilkobling vellykket';

  @override
  String connectionTestFailed(String message) {
    return 'Tilkobling mislyktes: $message';
  }

  @override
  String get serverVerificationFailed => 'Serververifisering mislyktes';

  @override
  String get importSuccessful => 'Import vellykket';

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
  String get deviceDeleteConfirmTitle => 'Fjern enhet';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Er du sikker på at du vil fjerne \"$name\"? Enheten logges ut umiddelbart.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Dette er din nåværende enhet. Du logges ut umiddelbart.';

  @override
  String get deviceDeleteSuccess => 'Enhet fjernet';

  @override
  String get deviceDeletedCurrentLogout =>
      'Nåværende enhet fjernet. Du er logget ut.';

  @override
  String get thisDevice => 'Denne enheten';
}
