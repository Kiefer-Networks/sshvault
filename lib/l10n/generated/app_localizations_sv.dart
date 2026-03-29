// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Värdar';

  @override
  String get navSnippets => 'Kodsnuttar';

  @override
  String get navFolders => 'Mappar';

  @override
  String get navTags => 'Taggar';

  @override
  String get navSshKeys => 'SSH-nycklar';

  @override
  String get navExportImport => 'Export / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Mer';

  @override
  String get navManagement => 'Hantering';

  @override
  String get navSettings => 'Inställningar';

  @override
  String get navAbout => 'Om';

  @override
  String get lockScreenTitle => 'SSHVault är låst';

  @override
  String get lockScreenUnlock => 'Lås upp';

  @override
  String get lockScreenEnterPin => 'Ange PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'För många misslyckade försök. Försök igen om $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Ange PIN-kod';

  @override
  String get pinDialogSetSubtitle =>
      'Ange en 6-siffrig PIN för att skydda SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Bekräfta PIN';

  @override
  String get pinDialogErrorLength => 'PIN måste vara exakt 6 siffror';

  @override
  String get pinDialogErrorMismatch => 'PIN-koderna matchar inte';

  @override
  String get pinDialogVerifyTitle => 'Ange PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Fel PIN. $attempts försök kvar.';
  }

  @override
  String get securityBannerMessage =>
      'Dina SSH-uppgifter är inte skyddade. Konfigurera en PIN eller biometriskt lås i Inställningar.';

  @override
  String get securityBannerDismiss => 'Avvisa';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsSectionAppearance => 'Utseende';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'SSH-standardvärden';

  @override
  String get settingsSectionSecurity => 'Säkerhet';

  @override
  String get settingsSectionExport => 'Export';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Ljust';

  @override
  String get settingsThemeDark => 'Mörkt';

  @override
  String get settingsTerminalTheme => 'Terminaltema';

  @override
  String get settingsTerminalThemeDefault => 'Standard mörk';

  @override
  String get settingsFontSize => 'Teckenstorlek';

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
  String get settingsDefaultUsername => 'Standardanvändarnamn';

  @override
  String get settingsDefaultUsernameDialog => 'Standardanvändarnamn';

  @override
  String get settingsUsernameLabel => 'Användarnamn';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automatiskt lås';

  @override
  String get settingsAutoLockDisabled => 'Inaktiverat';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minuter';
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
  String get settingsBiometricUnlock => 'Biometrisk upplåsning';

  @override
  String get settingsBiometricNotAvailable => 'Inte tillgänglig på denna enhet';

  @override
  String get settingsBiometricError => 'Fel vid kontroll av biometri';

  @override
  String get settingsBiometricReason =>
      'Verifiera din identitet för att aktivera biometrisk upplåsning';

  @override
  String get settingsBiometricRequiresPin =>
      'Ange en PIN först för att aktivera biometrisk upplåsning';

  @override
  String get settingsPinCode => 'PIN-kod';

  @override
  String get settingsPinIsSet => 'PIN är inställd';

  @override
  String get settingsPinNotConfigured => 'Ingen PIN konfigurerad';

  @override
  String get settingsPinRemove => 'Ta bort';

  @override
  String get settingsPinRemoveWarning =>
      'Att ta bort PIN dekrypterar alla databasfält och inaktiverar biometrisk upplåsning. Fortsätta?';

  @override
  String get settingsPinRemoveTitle => 'Ta bort PIN';

  @override
  String get settingsPreventScreenshots => 'Förhindra skärmdumpar';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Blockera skärmdumpar och skärminspelning';

  @override
  String get settingsEncryptExport => 'Kryptera export som standard';

  @override
  String get settingsAbout => 'Om SSHVault';

  @override
  String get settingsAboutLegalese => 'av Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Säker, självhostad SSH-klient';

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
  String get save => 'Spara';

  @override
  String get delete => 'Radera';

  @override
  String get close => 'Stäng';

  @override
  String get update => 'Uppdatera';

  @override
  String get create => 'Skapa';

  @override
  String get retry => 'Försök igen';

  @override
  String get copy => 'Kopiera';

  @override
  String get edit => 'Redigera';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Fel: $message';
  }

  @override
  String get serverListTitle => 'Värdar';

  @override
  String get serverListEmpty => 'Inga servrar ännu';

  @override
  String get serverListEmptySubtitle =>
      'Lägg till din första SSH-server för att komma igång.';

  @override
  String get serverAddButton => 'Lägg till server';

  @override
  String sshConfigImportMessage(int count) {
    return 'Hittade $count värd(ar) i ~/.ssh/config. Importera dem?';
  }

  @override
  String get sshConfigNotFound => 'Ingen SSH-konfigurationsfil hittades';

  @override
  String get sshConfigEmpty => 'Inga värdar hittades i SSH-konfigurationen';

  @override
  String get sshConfigAddManually => 'Lägg till manuellt';

  @override
  String get sshConfigImportAgain => 'Importera SSH-konfiguration igen?';

  @override
  String get sshConfigImportKeys =>
      'Importera SSH-nycklar som refereras av valda värdar?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH-nyckel/nycklar importerade';
  }

  @override
  String get serverDuplicated => 'Server duplicerad';

  @override
  String get serverDeleteTitle => 'Radera server';

  @override
  String serverDeleteMessage(String name) {
    return 'Är du säker på att du vill radera \"$name\"? Denna åtgärd kan inte ångras.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Radera \"$name\"?';
  }

  @override
  String get serverConnect => 'Anslut';

  @override
  String get serverDetails => 'Detaljer';

  @override
  String get serverDuplicate => 'Duplicera';

  @override
  String get serverActive => 'Aktiv';

  @override
  String get serverNoFolder => 'Ingen mapp';

  @override
  String get serverFormTitleEdit => 'Redigera server';

  @override
  String get serverFormTitleAdd => 'Lägg till server';

  @override
  String get serverFormUpdateButton => 'Uppdatera server';

  @override
  String get serverFormAddButton => 'Lägg till server';

  @override
  String get serverFormPublicKeyExtracted => 'Publik nyckel extraherad';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Kunde inte extrahera publik nyckel: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type-nyckelpar genererat';
  }

  @override
  String get serverDetailTitle => 'Serverdetaljer';

  @override
  String get serverDetailDeleteMessage => 'Denna åtgärd kan inte ångras.';

  @override
  String get serverDetailConnection => 'Anslutning';

  @override
  String get serverDetailHost => 'Värd';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Användarnamn';

  @override
  String get serverDetailFolder => 'Mapp';

  @override
  String get serverDetailTags => 'Taggar';

  @override
  String get serverDetailNotes => 'Anteckningar';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Skapad';

  @override
  String get serverDetailUpdated => 'Uppdaterad';

  @override
  String get serverDetailDistro => 'System';

  @override
  String get copiedToClipboard => 'Kopierat till urklipp';

  @override
  String get serverFormNameLabel => 'Servernamn';

  @override
  String get serverFormHostnameLabel => 'Värdnamn / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Användarnamn';

  @override
  String get serverFormPasswordLabel => 'Lösenord';

  @override
  String get serverFormUseManagedKey => 'Använd hanterad nyckel';

  @override
  String get serverFormManagedKeySubtitle =>
      'Välj från centralt hanterade SSH-nycklar';

  @override
  String get serverFormDirectKeySubtitle =>
      'Klistra in nyckeln direkt i denna server';

  @override
  String get serverFormGenerateKey => 'Generera SSH-nyckelpar';

  @override
  String get serverFormPrivateKeyLabel => 'Privat nyckel';

  @override
  String get serverFormPrivateKeyHint => 'Klistra in SSH privat nyckel...';

  @override
  String get serverFormExtractPublicKey => 'Extrahera publik nyckel';

  @override
  String get serverFormPublicKeyLabel => 'Publik nyckel';

  @override
  String get serverFormPublicKeyHint =>
      'Autogenereras från privat nyckel om tomt';

  @override
  String get serverFormPassphraseLabel => 'Nyckellösenord (valfritt)';

  @override
  String get serverFormNotesLabel => 'Anteckningar (valfritt)';

  @override
  String get searchServers => 'Sök servrar...';

  @override
  String get filterAllFolders => 'Alla mappar';

  @override
  String get filterAll => 'Alla';

  @override
  String get filterActive => 'Aktiva';

  @override
  String get filterInactive => 'Inaktiva';

  @override
  String get filterClear => 'Rensa';

  @override
  String get folderListTitle => 'Mappar';

  @override
  String get folderListEmpty => 'Inga mappar ännu';

  @override
  String get folderListEmptySubtitle =>
      'Skapa mappar för att organisera dina servrar.';

  @override
  String get folderAddButton => 'Lägg till mapp';

  @override
  String get folderDeleteTitle => 'Radera mapp';

  @override
  String folderDeleteMessage(String name) {
    return 'Radera \"$name\"? Servrar blir oorganiserade.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servrar',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Fäll ihop';

  @override
  String get folderShowHosts => 'Visa värdar';

  @override
  String get folderConnectAll => 'Anslut alla';

  @override
  String get folderFormTitleEdit => 'Redigera mapp';

  @override
  String get folderFormTitleNew => 'Ny mapp';

  @override
  String get folderFormNameLabel => 'Mappnamn';

  @override
  String get folderFormParentLabel => 'Överordnad mapp';

  @override
  String get folderFormParentNone => 'Ingen (rot)';

  @override
  String get tagListTitle => 'Taggar';

  @override
  String get tagListEmpty => 'Inga taggar ännu';

  @override
  String get tagListEmptySubtitle =>
      'Skapa taggar för att märka och filtrera dina servrar.';

  @override
  String get tagAddButton => 'Lägg till tagg';

  @override
  String get tagDeleteTitle => 'Radera tagg';

  @override
  String tagDeleteMessage(String name) {
    return 'Radera \"$name\"? Den tas bort från alla servrar.';
  }

  @override
  String get tagFormTitleEdit => 'Redigera tagg';

  @override
  String get tagFormTitleNew => 'Ny tagg';

  @override
  String get tagFormNameLabel => 'Taggnamn';

  @override
  String get sshKeyListTitle => 'SSH-nycklar';

  @override
  String get sshKeyListEmpty => 'Inga SSH-nycklar ännu';

  @override
  String get sshKeyListEmptySubtitle =>
      'Generera eller importera SSH-nycklar för att hantera dem centralt';

  @override
  String get sshKeyCannotDeleteTitle => 'Kan inte radera';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Kan inte radera \"$name\". Används av $count server/servrar. Koppla bort från alla servrar först.';
  }

  @override
  String get sshKeyDeleteTitle => 'Radera SSH-nyckel';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Radera \"$name\"? Detta kan inte ångras.';
  }

  @override
  String get sshKeyAddButton => 'Lägg till SSH-nyckel';

  @override
  String get sshKeyFormTitleEdit => 'Redigera SSH-nyckel';

  @override
  String get sshKeyFormTitleAdd => 'Lägg till SSH-nyckel';

  @override
  String get sshKeyFormTabGenerate => 'Generera';

  @override
  String get sshKeyFormTabImport => 'Importera';

  @override
  String get sshKeyFormNameLabel => 'Nyckelnamn';

  @override
  String get sshKeyFormNameHint => 't.ex. Min produktionsnyckel';

  @override
  String get sshKeyFormKeyType => 'Nyckeltyp';

  @override
  String get sshKeyFormKeySize => 'Nyckelstorlek';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Kommentar';

  @override
  String get sshKeyFormCommentHint => 'user@host eller beskrivning';

  @override
  String get sshKeyFormCommentOptional => 'Kommentar (valfritt)';

  @override
  String get sshKeyFormImportFromFile => 'Importera från fil';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Privat nyckel';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Klistra in SSH privat nyckel eller använd knappen ovan...';

  @override
  String get sshKeyFormPassphraseLabel => 'Lösenordsfras (valfritt)';

  @override
  String get sshKeyFormNameRequired => 'Namn krävs';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Privat nyckel krävs';

  @override
  String get sshKeyFormFileReadError => 'Kunde inte läsa den valda filen';

  @override
  String get sshKeyFormInvalidFormat =>
      'Ogiltigt nyckelformat — förväntat PEM-format (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Kunde inte läsa filen: $message';
  }

  @override
  String get sshKeyFormSaving => 'Sparar...';

  @override
  String get sshKeySelectorLabel => 'SSH-nyckel';

  @override
  String get sshKeySelectorNone => 'Ingen hanterad nyckel';

  @override
  String get sshKeySelectorManage => 'Hantera nycklar...';

  @override
  String get sshKeySelectorError => 'Kunde inte ladda SSH-nycklar';

  @override
  String get sshKeyTileCopyPublicKey => 'Kopiera publik nyckel';

  @override
  String get sshKeyTilePublicKeyCopied => 'Publik nyckel kopierad';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Används av $count server/servrar';
  }

  @override
  String get sshKeyTileUnlinkFirst => 'Koppla bort från alla servrar först';

  @override
  String get exportImportTitle => 'Export / Import';

  @override
  String get exportSectionTitle => 'Export';

  @override
  String get exportJsonButton => 'Exportera som JSON (utan uppgifter)';

  @override
  String get exportZipButton => 'Exportera krypterad ZIP (med uppgifter)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Importera från fil';

  @override
  String get importSupportedFormats =>
      'Stöder JSON (okrypterad) och ZIP (krypterad) filer.';

  @override
  String exportedTo(String path) {
    return 'Exporterat till: $path';
  }

  @override
  String get share => 'Dela';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Importerade $servers servrar, $groups grupper, $tags taggar. $skipped hoppades över.';
  }

  @override
  String get importPasswordTitle => 'Ange lösenord';

  @override
  String get importPasswordLabel => 'Exportlösenord';

  @override
  String get importPasswordDecrypt => 'Dekryptera';

  @override
  String get exportPasswordTitle => 'Ange exportlösenord';

  @override
  String get exportPasswordDescription =>
      'Detta lösenord används för att kryptera din exportfil inklusive uppgifter.';

  @override
  String get exportPasswordLabel => 'Lösenord';

  @override
  String get exportPasswordConfirmLabel => 'Bekräfta lösenord';

  @override
  String get exportPasswordMismatch => 'Lösenorden matchar inte';

  @override
  String get exportPasswordButton => 'Kryptera & exportera';

  @override
  String get importConflictTitle => 'Hantera konflikter';

  @override
  String get importConflictDescription =>
      'Hur ska befintliga poster hanteras vid import?';

  @override
  String get importConflictSkip => 'Hoppa över befintliga';

  @override
  String get importConflictRename => 'Byt namn på nya';

  @override
  String get importConflictOverwrite => 'Skriv över';

  @override
  String get confirmDeleteLabel => 'Radera';

  @override
  String get keyGenTitle => 'Generera SSH-nyckelpar';

  @override
  String get keyGenKeyType => 'Nyckeltyp';

  @override
  String get keyGenKeySize => 'Nyckelstorlek';

  @override
  String get keyGenComment => 'Kommentar';

  @override
  String get keyGenCommentHint => 'user@host eller beskrivning';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Genererar...';

  @override
  String get keyGenGenerate => 'Generera';

  @override
  String keyGenResultTitle(String type) {
    return '$type-nyckel genererad';
  }

  @override
  String get keyGenPublicKey => 'Publik nyckel';

  @override
  String get keyGenPrivateKey => 'Privat nyckel';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Kommentar: $comment';
  }

  @override
  String get keyGenAnother => 'Generera en till';

  @override
  String get keyGenUseThisKey => 'Använd denna nyckel';

  @override
  String get keyGenCopyTooltip => 'Kopiera till urklipp';

  @override
  String keyGenCopied(String label) {
    return '$label kopierad';
  }

  @override
  String get colorPickerLabel => 'Färg';

  @override
  String get iconPickerLabel => 'Ikon';

  @override
  String get tagSelectorLabel => 'Taggar';

  @override
  String get tagSelectorEmpty => 'Inga taggar ännu';

  @override
  String get tagSelectorError => 'Kunde inte ladda taggar';

  @override
  String get snippetListTitle => 'Kodsnuttar';

  @override
  String get snippetSearchHint => 'Sök kodsnuttar...';

  @override
  String get snippetListEmpty => 'Inga kodsnuttar ännu';

  @override
  String get snippetListEmptySubtitle =>
      'Skapa återanvändbara kodsnuttar och kommandon.';

  @override
  String get snippetAddButton => 'Lägg till kodsnutta';

  @override
  String get snippetDeleteTitle => 'Radera kodsnutta';

  @override
  String snippetDeleteMessage(String name) {
    return 'Radera \"$name\"? Detta kan inte ångras.';
  }

  @override
  String get snippetFormTitleEdit => 'Redigera kodsnutta';

  @override
  String get snippetFormTitleNew => 'Ny kodsnutta';

  @override
  String get snippetFormNameLabel => 'Namn';

  @override
  String get snippetFormNameHint => 't.ex. Docker-rensning';

  @override
  String get snippetFormLanguageLabel => 'Språk';

  @override
  String get snippetFormContentLabel => 'Innehåll';

  @override
  String get snippetFormContentHint => 'Ange din kodsnutt...';

  @override
  String get snippetFormDescriptionLabel => 'Beskrivning';

  @override
  String get snippetFormDescriptionHint => 'Valfri beskrivning...';

  @override
  String get snippetFormFolderLabel => 'Mapp';

  @override
  String get snippetFormNoFolder => 'Ingen mapp';

  @override
  String get snippetFormNameRequired => 'Namn krävs';

  @override
  String get snippetFormContentRequired => 'Innehåll krävs';

  @override
  String get snippetFormUpdateButton => 'Uppdatera kodsnutta';

  @override
  String get snippetFormCreateButton => 'Skapa kodsnutta';

  @override
  String get snippetDetailTitle => 'Kodsnuttdetaljer';

  @override
  String get snippetDetailDeleteTitle => 'Radera kodsnutta';

  @override
  String get snippetDetailDeleteMessage => 'Denna åtgärd kan inte ångras.';

  @override
  String get snippetDetailContent => 'Innehåll';

  @override
  String get snippetDetailFillVariables => 'Fyll i variabler';

  @override
  String get snippetDetailDescription => 'Beskrivning';

  @override
  String get snippetDetailVariables => 'Variabler';

  @override
  String get snippetDetailTags => 'Taggar';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Skapad';

  @override
  String get snippetDetailUpdated => 'Uppdaterad';

  @override
  String get variableEditorTitle => 'Mallvariabler';

  @override
  String get variableEditorAdd => 'Lägg till';

  @override
  String get variableEditorEmpty =>
      'Inga variabler. Använd klammerparentes-syntax i innehållet för att referera till dem.';

  @override
  String get variableEditorNameLabel => 'Namn';

  @override
  String get variableEditorNameHint => 't.ex. hostname';

  @override
  String get variableEditorDefaultLabel => 'Standard';

  @override
  String get variableEditorDefaultHint => 'valfritt';

  @override
  String get variableFillTitle => 'Fyll i variabler';

  @override
  String variableFillHint(String name) {
    return 'Ange värde för $name';
  }

  @override
  String get variableFillPreview => 'Förhandsgranskning';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Inga aktiva sessioner';

  @override
  String get terminalEmptySubtitle =>
      'Anslut till en värd för att öppna en terminalsession.';

  @override
  String get terminalGoToHosts => 'Gå till värdar';

  @override
  String get terminalCloseAll => 'Stäng alla sessioner';

  @override
  String get terminalCloseTitle => 'Stäng session';

  @override
  String terminalCloseMessage(String title) {
    return 'Stäng den aktiva anslutningen till \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Autentiserar...';

  @override
  String connectionConnecting(String name) {
    return 'Ansluter till $name...';
  }

  @override
  String get connectionError => 'Anslutningsfel';

  @override
  String get connectionLost => 'Anslutningen förlorad';

  @override
  String get connectionReconnect => 'Återanslut';

  @override
  String get snippetQuickPanelTitle => 'Infoga kodsnutta';

  @override
  String get snippetQuickPanelSearch => 'Sök kodsnuttar...';

  @override
  String get snippetQuickPanelEmpty => 'Inga kodsnuttar tillgängliga';

  @override
  String get snippetQuickPanelNoMatch => 'Inga matchande kodsnuttar';

  @override
  String get snippetQuickPanelInsertTooltip => 'Infoga kodsnutta';

  @override
  String get terminalThemePickerTitle => 'Terminaltema';

  @override
  String get validatorHostnameRequired => 'Värdnamn krävs';

  @override
  String get validatorHostnameInvalid => 'Ogiltigt värdnamn eller IP-adress';

  @override
  String get validatorPortRequired => 'Port krävs';

  @override
  String get validatorPortRange => 'Port måste vara mellan 1 och 65535';

  @override
  String get validatorUsernameRequired => 'Användarnamn krävs';

  @override
  String get validatorUsernameInvalid => 'Ogiltigt användarnamnsformat';

  @override
  String get validatorServerNameRequired => 'Servernamn krävs';

  @override
  String get validatorServerNameLength =>
      'Servernamn får vara högst 100 tecken';

  @override
  String get validatorSshKeyInvalid => 'Ogiltigt SSH-nyckelformat';

  @override
  String get validatorPasswordRequired => 'Lösenord krävs';

  @override
  String get validatorPasswordLength => 'Lösenord måste vara minst 8 tecken';

  @override
  String get authMethodPassword => 'Lösenord';

  @override
  String get authMethodKey => 'SSH-nyckel';

  @override
  String get authMethodBoth => 'Lösenord + nyckel';

  @override
  String get serverCopySuffix => '(Kopia)';

  @override
  String get settingsDownloadLogs => 'Ladda ner loggar';

  @override
  String get settingsSendLogs => 'Skicka loggar till support';

  @override
  String get settingsLogsSaved => 'Loggar sparade';

  @override
  String get settingsLogsEmpty => 'Inga loggposter tillgängliga';

  @override
  String get authLogin => 'Logga in';

  @override
  String get authRegister => 'Registrera';

  @override
  String get authForgotPassword => 'Glömt lösenord?';

  @override
  String get authWhyLogin =>
      'Logga in för att aktivera krypterad molnsynkronisering på alla dina enheter. Appen fungerar fullt offline utan ett konto.';

  @override
  String get authEmailLabel => 'E-post';

  @override
  String get authEmailRequired => 'E-post krävs';

  @override
  String get authEmailInvalid => 'Ogiltig e-postadress';

  @override
  String get authPasswordLabel => 'Lösenord';

  @override
  String get authConfirmPasswordLabel => 'Bekräfta lösenord';

  @override
  String get authPasswordMismatch => 'Lösenorden matchar inte';

  @override
  String get authNoAccount => 'Inget konto?';

  @override
  String get authHasAccount => 'Har du redan ett konto?';

  @override
  String get authSelfHosted => 'Självhostad server';

  @override
  String get authResetEmailSent =>
      'Om ett konto finns har en återställningslänk skickats till din e-post.';

  @override
  String get authResetDescription =>
      'Ange din e-postadress så skickar vi en länk för att återställa ditt lösenord.';

  @override
  String get authSendResetLink => 'Skicka återställningslänk';

  @override
  String get authBackToLogin => 'Tillbaka till inloggning';

  @override
  String get syncPasswordTitle => 'Synkroniseringslösenord';

  @override
  String get syncPasswordTitleCreate => 'Ange synkroniseringslösenord';

  @override
  String get syncPasswordTitleEnter => 'Ange synkroniseringslösenord';

  @override
  String get syncPasswordDescription =>
      'Ange ett separat lösenord för att kryptera dina valvdata. Detta lösenord lämnar aldrig din enhet — servern lagrar bara krypterad data.';

  @override
  String get syncPasswordHintEnter =>
      'Ange lösenordet du satte när du skapade ditt konto.';

  @override
  String get syncPasswordWarning =>
      'Om du glömmer detta lösenord kan dina synkade data inte återställas. Det finns inget återställningsalternativ.';

  @override
  String get syncPasswordLabel => 'Synkroniseringslösenord';

  @override
  String get syncPasswordWrong => 'Fel lösenord. Försök igen.';

  @override
  String get firstSyncTitle => 'Befintlig data hittad';

  @override
  String get firstSyncMessage =>
      'Denna enhet har befintlig data och servern har ett valv. Hur ska vi fortsätta?';

  @override
  String get firstSyncMerge => 'Sammanfoga (servern vinner)';

  @override
  String get firstSyncOverwriteLocal => 'Skriv över lokal data';

  @override
  String get firstSyncKeepLocal => 'Behåll lokal & skicka';

  @override
  String get firstSyncDeleteLocal => 'Radera lokal & hämta';

  @override
  String get changeEncryptionPassword => 'Ändra krypteringslösenord';

  @override
  String get changeEncryptionWarning => 'Du loggas ut på alla andra enheter.';

  @override
  String get changeEncryptionOldPassword => 'Nuvarande lösenord';

  @override
  String get changeEncryptionNewPassword => 'Nytt lösenord';

  @override
  String get changeEncryptionSuccess => 'Lösenord ändrat.';

  @override
  String get logoutAllDevices => 'Logga ut från alla enheter';

  @override
  String get logoutAllDevicesConfirm =>
      'Detta återkallar alla aktiva sessioner. Du behöver logga in igen på alla enheter.';

  @override
  String get logoutAllDevicesSuccess => 'Alla enheter utloggade.';

  @override
  String get syncSettingsTitle => 'Synkroniseringsinställningar';

  @override
  String get syncAutoSync => 'Autosynkronisering';

  @override
  String get syncAutoSyncDescription =>
      'Synkronisera automatiskt när appen startar';

  @override
  String get syncNow => 'Synkronisera nu';

  @override
  String get syncSyncing => 'Synkroniserar...';

  @override
  String get syncSuccess => 'Synkronisering klar';

  @override
  String get syncError => 'Synkroniseringsfel';

  @override
  String get syncServerUnreachable => 'Servern kan inte nås';

  @override
  String get syncServerUnreachableHint =>
      'Synkroniseringsservern kunde inte nås. Kontrollera din internetanslutning och server-URL.';

  @override
  String get syncNetworkError =>
      'Anslutning till server misslyckades. Kontrollera din internetanslutning eller försök igen senare.';

  @override
  String get syncNeverSynced => 'Aldrig synkroniserad';

  @override
  String get syncVaultVersion => 'Valvversion';

  @override
  String get syncTitle => 'Synkronisering';

  @override
  String get settingsSectionNetwork => 'Nätverk & DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS-servrar';

  @override
  String get settingsDnsDefault => 'Standard (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Ange anpassade DoH-serveradresser, separerade med kommatecken. Minst 2 servrar behövs för korsverifiering.';

  @override
  String get settingsDnsLabel => 'DoH-serveradresser';

  @override
  String get settingsDnsReset => 'Återställ till standard';

  @override
  String get settingsSectionSync => 'Synkronisering';

  @override
  String get settingsSyncAccount => 'Konto';

  @override
  String get settingsSyncNotLoggedIn => 'Inte inloggad';

  @override
  String get settingsSyncStatus => 'Synkronisering';

  @override
  String get settingsSyncServerUrl => 'Server-URL';

  @override
  String get settingsSyncDefaultServer => 'Standard (sshvault.app)';

  @override
  String get accountTitle => 'Konto';

  @override
  String get accountNotLoggedIn => 'Inte inloggad';

  @override
  String get accountVerified => 'Verifierad';

  @override
  String get accountMemberSince => 'Medlem sedan';

  @override
  String get accountDevices => 'Enheter';

  @override
  String get accountNoDevices => 'Inga enheter registrerade';

  @override
  String get accountLastSync => 'Senaste synkronisering';

  @override
  String get accountChangePassword => 'Ändra lösenord';

  @override
  String get accountOldPassword => 'Nuvarande lösenord';

  @override
  String get accountNewPassword => 'Nytt lösenord';

  @override
  String get accountDeleteAccount => 'Radera konto';

  @override
  String get accountDeleteWarning =>
      'Detta raderar permanent ditt konto och all synkad data. Detta kan inte ångras.';

  @override
  String get accountLogout => 'Logga ut';

  @override
  String get serverConfigTitle => 'Serverkonfiguration';

  @override
  String get serverConfigSelfHosted => 'Självhostad';

  @override
  String get serverConfigSelfHostedDescription =>
      'Använd din egen SSHVault-server';

  @override
  String get serverConfigUrlLabel => 'Server-URL';

  @override
  String get serverConfigTest => 'Testa anslutning';

  @override
  String get auditLogTitle => 'Aktivitetslogg';

  @override
  String get auditLogAll => 'Alla';

  @override
  String get auditLogEmpty => 'Inga aktivitetsloggar hittades';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Filhanterare';

  @override
  String get sftpLocalDevice => 'Lokal enhet';

  @override
  String get sftpSelectServer => 'Välj server...';

  @override
  String get sftpConnecting => 'Ansluter...';

  @override
  String get sftpEmptyDirectory => 'Denna katalog är tom';

  @override
  String get sftpNoConnection => 'Ingen server ansluten';

  @override
  String get sftpPathLabel => 'Sökväg';

  @override
  String get sftpUpload => 'Ladda upp';

  @override
  String get sftpDownload => 'Ladda ner';

  @override
  String get sftpDelete => 'Radera';

  @override
  String get sftpRename => 'Byt namn';

  @override
  String get sftpNewFolder => 'Ny mapp';

  @override
  String get sftpNewFolderName => 'Mappnamn';

  @override
  String get sftpChmod => 'Rättigheter';

  @override
  String get sftpChmodTitle => 'Ändra rättigheter';

  @override
  String get sftpChmodOctal => 'Oktal';

  @override
  String get sftpChmodOwner => 'Ägare';

  @override
  String get sftpChmodGroup => 'Grupp';

  @override
  String get sftpChmodOther => 'Övriga';

  @override
  String get sftpChmodRead => 'Läsa';

  @override
  String get sftpChmodWrite => 'Skriva';

  @override
  String get sftpChmodExecute => 'Köra';

  @override
  String get sftpCreateSymlink => 'Skapa symlänk';

  @override
  String get sftpSymlinkTarget => 'Målsökväg';

  @override
  String get sftpSymlinkName => 'Länknamn';

  @override
  String get sftpFilePreview => 'Filförhandsgranskning';

  @override
  String get sftpFileInfo => 'Filinformation';

  @override
  String get sftpFileSize => 'Storlek';

  @override
  String get sftpFileModified => 'Ändrad';

  @override
  String get sftpFilePermissions => 'Rättigheter';

  @override
  String get sftpFileOwner => 'Ägare';

  @override
  String get sftpFileType => 'Typ';

  @override
  String get sftpFileLinkTarget => 'Länkmål';

  @override
  String get sftpTransfers => 'Överföringar';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current av $total';
  }

  @override
  String get sftpTransferQueued => 'Köad';

  @override
  String get sftpTransferActive => 'Överför...';

  @override
  String get sftpTransferPaused => 'Pausad';

  @override
  String get sftpTransferCompleted => 'Slutförd';

  @override
  String get sftpTransferFailed => 'Misslyckad';

  @override
  String get sftpTransferCancelled => 'Avbruten';

  @override
  String get sftpPauseTransfer => 'Pausa';

  @override
  String get sftpResumeTransfer => 'Återuppta';

  @override
  String get sftpCancelTransfer => 'Avbryt';

  @override
  String get sftpClearCompleted => 'Rensa slutförda';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active av $total överföringar';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktiva',
      one: '1 aktiv',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count slutförda',
      one: '1 slutförd',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count misslyckade',
      one: '1 misslyckad',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Kopiera till andra panelen';

  @override
  String sftpConfirmDelete(int count) {
    return 'Radera $count objekt?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Radera \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Raderat';

  @override
  String get sftpRenameTitle => 'Byt namn';

  @override
  String get sftpRenameLabel => 'Nytt namn';

  @override
  String get sftpSortByName => 'Namn';

  @override
  String get sftpSortBySize => 'Storlek';

  @override
  String get sftpSortByDate => 'Datum';

  @override
  String get sftpSortByType => 'Typ';

  @override
  String get sftpShowHidden => 'Visa dolda filer';

  @override
  String get sftpHideHidden => 'Dölj dolda filer';

  @override
  String get sftpSelectAll => 'Markera alla';

  @override
  String get sftpDeselectAll => 'Avmarkera alla';

  @override
  String sftpItemsSelected(int count) {
    return '$count markerade';
  }

  @override
  String get sftpRefresh => 'Uppdatera';

  @override
  String sftpConnectionError(String message) {
    return 'Anslutningen misslyckades: $message';
  }

  @override
  String get sftpPermissionDenied => 'Åtkomst nekad';

  @override
  String sftpOperationFailed(String message) {
    return 'Åtgärden misslyckades: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Filen finns redan';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" finns redan. Skriv över?';
  }

  @override
  String get sftpOverwrite => 'Skriv över';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Överföring startad: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Välj en destination i den andra panelen först';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Katalogöverföring kommer snart';

  @override
  String get sftpSelect => 'Välj';

  @override
  String get sftpOpen => 'Öppna';

  @override
  String get sftpExtractArchive => 'Extrahera här';

  @override
  String get sftpExtractSuccess => 'Arkiv extraherat';

  @override
  String sftpExtractFailed(String message) {
    return 'Extrahering misslyckades: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Arkivformat stöds ej';

  @override
  String get sftpExtracting => 'Extraherar...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uppladdningar startade',
      one: 'Uppladdning startad',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nedladdningar startade',
      one: 'Nedladdning startad',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" nedladdad';
  }

  @override
  String get sftpSavedToDownloads => 'Sparad i Nedladdningar/SSHVault';

  @override
  String get sftpSaveToFiles => 'Spara till filer';

  @override
  String get sftpFileSaved => 'Fil sparad';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH-sessioner aktiva',
      one: 'SSH-session aktiv',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Tryck för att öppna terminalen';

  @override
  String get settingsAccountAndSync => 'Konto & synkronisering';

  @override
  String get settingsAccountSubtitleAuth => 'Inloggad';

  @override
  String get settingsAccountSubtitleUnauth => 'Inte inloggad';

  @override
  String get settingsSecuritySubtitle => 'Autolås, biometri, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Användare root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, språk, terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Krypterade exportstandarder';

  @override
  String get settingsAboutSubtitle => 'Version, licenser';

  @override
  String get settingsSearchHint => 'Sök inställningar...';

  @override
  String get settingsSearchNoResults => 'Inga inställningar hittades';

  @override
  String get aboutDeveloper => 'Utvecklad av Kiefer Networks';

  @override
  String get aboutDonate => 'Donera';

  @override
  String get aboutOpenSourceLicenses => 'Öppen källkodslicenser';

  @override
  String get aboutWebsite => 'Webbplats';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutBuild => 'Bygge';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS krypterar DNS-förfrågningar och förhindrar DNS-förfalskning. SSHVault kontrollerar värdnamn mot flera leverantörer för att upptäcka attacker.';

  @override
  String get settingsDnsAddServer => 'Lägg till DNS-server';

  @override
  String get settingsDnsServerUrl => 'Server-URL';

  @override
  String get settingsDnsDefaultBadge => 'Standard';

  @override
  String get settingsDnsResetDefaults => 'Återställ till standard';

  @override
  String get settingsDnsInvalidUrl => 'Ange en giltig HTTPS-URL';

  @override
  String get settingsDefaultAuthMethod => 'Autentiseringsmetod';

  @override
  String get settingsAuthPassword => 'Lösenord';

  @override
  String get settingsAuthKey => 'SSH-nyckel';

  @override
  String get settingsConnectionTimeout => 'Anslutningstimeout';

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
      'Aktivera zlib-komprimering för SSH-anslutningar';

  @override
  String get settingsTerminalType => 'Terminaltyp';

  @override
  String get settingsSectionConnection => 'Anslutning';

  @override
  String get settingsClipboardAutoClear => 'Automatisk rensning av urklipp';

  @override
  String get settingsClipboardAutoClearOff => 'Av';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Sessionstimeout';

  @override
  String get settingsSessionTimeoutOff => 'Av';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'Nöd-PIN';

  @override
  String get settingsDuressPinDescription =>
      'En separat PIN som raderar all data när den anges';

  @override
  String get settingsDuressPinSet => 'Nöd-PIN är inställd';

  @override
  String get settingsDuressPinNotSet => 'Inte konfigurerad';

  @override
  String get settingsDuressPinWarning =>
      'Att ange denna PIN raderar permanent all lokal data inklusive uppgifter, nycklar och inställningar. Detta kan inte ångras.';

  @override
  String get settingsKeyRotationReminder => 'Påminnelse om nyckelrotation';

  @override
  String get settingsKeyRotationOff => 'Av';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days dagar';
  }

  @override
  String get settingsFailedAttempts => 'Misslyckade PIN-försök';

  @override
  String get settingsSectionAppLock => 'Applås';

  @override
  String get settingsSectionPrivacy => 'Integritet';

  @override
  String get settingsSectionReminders => 'Påminnelser';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle =>
      'Export, import & säkerhetskopiering';

  @override
  String get settingsExportJson => 'Exportera som JSON';

  @override
  String get settingsExportEncrypted => 'Exportera krypterat';

  @override
  String get settingsImportFile => 'Importera från fil';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Filtrera servrar';

  @override
  String get filterApply => 'Tillämpa filter';

  @override
  String get filterClearAll => 'Rensa alla';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filter aktiva',
      one: '1 filter aktivt',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Mapp';

  @override
  String get filterTags => 'Taggar';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Löst förhandsgranskning';

  @override
  String get variableInsert => 'Infoga';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servrar',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessioner återkallade.',
      one: '1 session återkallad.',
    );
    return '$_temp0 Du har loggats ut.';
  }

  @override
  String get keyGenPassphrase => 'Lösenordsfras';

  @override
  String get keyGenPassphraseHint => 'Valfritt — skyddar den privata nyckeln';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Standard (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'En nyckel med samma fingeravtryck finns redan: \"$name\". Varje SSH-nyckel måste vara unik.';
  }

  @override
  String get sshKeyFingerprint => 'Fingeravtryck';

  @override
  String get sshKeyPublicKey => 'Publik nyckel';

  @override
  String get jumpHost => 'Hoppvärd';

  @override
  String get jumpHostNone => 'Ingen';

  @override
  String get jumpHostLabel => 'Anslut via hoppvärd';

  @override
  String get jumpHostSelfError => 'En server kan inte vara sin egen hoppvärd';

  @override
  String get jumpHostConnecting => 'Ansluter till hoppvärd...';

  @override
  String get jumpHostCircularError => 'Cirkulär hoppvärdskedja upptäckt';

  @override
  String get logoutDialogTitle => 'Logga ut';

  @override
  String get logoutDialogMessage =>
      'Vill du radera all lokal data? Servrar, SSH-nycklar, kodsnuttar och inställningar tas bort från denna enhet.';

  @override
  String get logoutOnly => 'Logga bara ut';

  @override
  String get logoutAndDelete => 'Logga ut & radera data';

  @override
  String get changeAvatar => 'Ändra avatar';

  @override
  String get removeAvatar => 'Ta bort avatar';

  @override
  String get avatarUploadFailed => 'Kunde inte ladda upp avatar';

  @override
  String get avatarTooLarge => 'Bilden är för stor';

  @override
  String get deviceLastSeen => 'Senast sedd';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Server-URL kan inte ändras medan du är inloggad. Logga ut först.';

  @override
  String get serverListNoFolder => 'Okategoriserad';

  @override
  String get autoSyncInterval => 'Synkroniseringsintervall';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Proxyinställningar';

  @override
  String get proxyType => 'Proxytyp';

  @override
  String get proxyNone => 'Ingen proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxyvärd';

  @override
  String get proxyPort => 'Proxyport';

  @override
  String get proxyUsername => 'Proxyanvändarnamn';

  @override
  String get proxyPassword => 'Proxylösenord';

  @override
  String get proxyUseGlobal => 'Använd global proxy';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Serverspecifik';

  @override
  String get proxyTestConnection => 'Testa anslutning';

  @override
  String get proxyTestSuccess => 'Proxy nåbar';

  @override
  String get proxyTestFailed => 'Proxy ej nåbar';

  @override
  String get proxyDefaultProxy => 'Standardproxy';

  @override
  String get vpnRequired => 'VPN krävs';

  @override
  String get vpnRequiredTooltip =>
      'Visa varning vid anslutning utan aktivt VPN';

  @override
  String get vpnActive => 'VPN aktivt';

  @override
  String get vpnInactive => 'VPN inaktivt';

  @override
  String get vpnWarningTitle => 'VPN inte aktivt';

  @override
  String get vpnWarningMessage =>
      'Denna server kräver VPN-anslutning, men inget VPN är aktivt. Vill du ansluta ändå?';

  @override
  String get vpnConnectAnyway => 'Anslut ändå';

  @override
  String get postConnectCommands => 'Kommandon efter anslutning';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Kommandon som körs automatiskt efter anslutning (ett per rad)';

  @override
  String get dashboardFavorites => 'Favoriter';

  @override
  String get dashboardRecent => 'Senaste';

  @override
  String get dashboardActiveSessions => 'Aktiva sessioner';

  @override
  String get addToFavorites => 'Lägg till i favoriter';

  @override
  String get removeFromFavorites => 'Ta bort från favoriter';

  @override
  String get noRecentConnections => 'Inga senaste anslutningar';

  @override
  String get terminalSplit => 'Delad vy';

  @override
  String get terminalUnsplit => 'Stäng delad vy';

  @override
  String get terminalSelectSession => 'Välj session för delad vy';

  @override
  String get knownHostsTitle => 'Kända värdar';

  @override
  String get knownHostsSubtitle => 'Hantera betrodda serverfingeravtryck';

  @override
  String get hostKeyNewTitle => 'Ny värd';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Första anslutningen till $hostname:$port. Verifiera fingeravtrycket innan du ansluter.';
  }

  @override
  String get hostKeyChangedTitle => 'Värdnyckel ändrad!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Värdnyckeln för $hostname:$port har ändrats. Detta kan tyda på ett säkerhetshot.';
  }

  @override
  String get hostKeyFingerprint => 'Fingeravtryck';

  @override
  String get hostKeyType => 'Nyckeltyp';

  @override
  String get hostKeyTrustConnect => 'Lita på & anslut';

  @override
  String get hostKeyAcceptNew => 'Acceptera ny nyckel';

  @override
  String get hostKeyReject => 'Avvisa';

  @override
  String get hostKeyPreviousFingerprint => 'Tidigare fingeravtryck';

  @override
  String get hostKeyDeleteAll => 'Radera alla kända värdar';

  @override
  String get hostKeyDeleteConfirm =>
      'Är du säker på att du vill ta bort alla kända värdar? Du blir tillfrågad igen vid nästa anslutning.';

  @override
  String get hostKeyEmpty => 'Inga kända värdar ännu';

  @override
  String get hostKeyEmptySubtitle =>
      'Värdfingeravtryck lagras här efter din första anslutning';

  @override
  String get hostKeyFirstSeen => 'Första gången sedd';

  @override
  String get hostKeyLastSeen => 'Senast sedd';

  @override
  String get sshConfigImportTitle => 'Importera SSH-konfiguration';

  @override
  String get sshConfigImportPickFile => 'Välj SSH-konfigurationsfil';

  @override
  String get sshConfigImportOrPaste =>
      'Eller klistra in konfigurationsinnehåll';

  @override
  String sshConfigImportParsed(int count) {
    return '$count värdar hittade';
  }

  @override
  String get sshConfigImportButton => 'Importera';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count server(rar) importerade';
  }

  @override
  String get sshConfigImportDuplicate => 'Finns redan';

  @override
  String get sshConfigImportNoHosts => 'Inga värdar hittades i konfigurationen';

  @override
  String get sftpBookmarkAdd => 'Lägg till bokmärke';

  @override
  String get sftpBookmarkLabel => 'Etikett';

  @override
  String get disconnect => 'Koppla från';

  @override
  String get reportAndDisconnect => 'Rapportera & koppla från';

  @override
  String get continueAnyway => 'Fortsätt ändå';

  @override
  String get insertSnippet => 'Infoga kodsnutta';

  @override
  String get seconds => 'Sekunder';

  @override
  String get heartbeatLostMessage =>
      'Servern kunde inte nås efter flera försök. Av säkerhetsskäl har sessionen avslutats.';

  @override
  String get attestationFailedTitle => 'Serververifiering misslyckades';

  @override
  String get attestationFailedMessage =>
      'Servern kunde inte verifieras som en legitim SSHVault-backend. Detta kan tyda på en man-in-the-middle-attack eller en felkonfigurerad server.';

  @override
  String get attestationKeyChangedTitle => 'Servernyckeln har ändrats';

  @override
  String get attestationKeyChangedMessage =>
      'Serverns attestationsnyckel har ändrats sedan den första anslutningen. Detta kan tyda på en man-in-the-middle-attack. Fortsätt INTE om inte serveradministratören har bekräftat en nyckelrotation.';

  @override
  String get sectionLinks => 'Länkar';

  @override
  String get sectionDeveloper => 'Utvecklare';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Sidan hittades inte';

  @override
  String get connectionTestSuccess => 'Anslutningen lyckades';

  @override
  String connectionTestFailed(String message) {
    return 'Anslutningen misslyckades: $message';
  }

  @override
  String get serverVerificationFailed => 'Serververifiering misslyckades';

  @override
  String get importSuccessful => 'Import lyckades';

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
  String get deviceDeleteConfirmTitle => 'Ta bort enhet';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Är du säker på att du vill ta bort \"$name\"? Enheten loggas ut omedelbart.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Detta är din nuvarande enhet. Du loggas ut omedelbart.';

  @override
  String get deviceDeleteSuccess => 'Enhet borttagen';

  @override
  String get deviceDeletedCurrentLogout =>
      'Nuvarande enhet borttagen. Du har loggats ut.';

  @override
  String get thisDevice => 'Denna enhet';
}
