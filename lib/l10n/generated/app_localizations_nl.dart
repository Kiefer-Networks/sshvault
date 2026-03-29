// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Hosts';

  @override
  String get navSnippets => 'Snippets';

  @override
  String get navFolders => 'Mappen';

  @override
  String get navTags => 'Tags';

  @override
  String get navSshKeys => 'SSH-sleutels';

  @override
  String get navExportImport => 'Exporteren / Importeren';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Meer';

  @override
  String get navManagement => 'Beheer';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get navAbout => 'Over';

  @override
  String get lockScreenTitle => 'SSHVault is vergrendeld';

  @override
  String get lockScreenUnlock => 'Ontgrendelen';

  @override
  String get lockScreenEnterPin => 'Voer PIN in';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Te veel mislukte pogingen. Probeer het opnieuw over $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'PIN-code instellen';

  @override
  String get pinDialogSetSubtitle =>
      'Voer een 6-cijferige PIN in om SSHVault te beveiligen';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'PIN bevestigen';

  @override
  String get pinDialogErrorLength => 'PIN moet precies 6 cijfers zijn';

  @override
  String get pinDialogErrorMismatch => 'PIN-codes komen niet overeen';

  @override
  String get pinDialogVerifyTitle => 'Voer PIN in';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Verkeerde PIN. Nog $attempts pogingen over.';
  }

  @override
  String get securityBannerMessage =>
      'Uw SSH-referenties zijn niet beveiligd. Stel een PIN of biometrische vergrendeling in via Instellingen.';

  @override
  String get securityBannerDismiss => 'Sluiten';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsSectionAppearance => 'Weergave';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'SSH-standaarden';

  @override
  String get settingsSectionSecurity => 'Beveiliging';

  @override
  String get settingsSectionExport => 'Exporteren';

  @override
  String get settingsSectionAbout => 'Over';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get settingsThemeSystem => 'Systeem';

  @override
  String get settingsThemeLight => 'Licht';

  @override
  String get settingsThemeDark => 'Donker';

  @override
  String get settingsTerminalTheme => 'Terminalthema';

  @override
  String get settingsTerminalThemeDefault => 'Standaard donker';

  @override
  String get settingsFontSize => 'Lettergrootte';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Standaardpoort';

  @override
  String get settingsDefaultPortDialog => 'Standaard SSH-poort';

  @override
  String get settingsPortLabel => 'Poort';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Standaard gebruikersnaam';

  @override
  String get settingsDefaultUsernameDialog => 'Standaard gebruikersnaam';

  @override
  String get settingsUsernameLabel => 'Gebruikersnaam';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automatische vergrendeling';

  @override
  String get settingsAutoLockDisabled => 'Uitgeschakeld';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minuten';
  }

  @override
  String get settingsAutoLockOff => 'Uit';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Biometrische ontgrendeling';

  @override
  String get settingsBiometricNotAvailable =>
      'Niet beschikbaar op dit apparaat';

  @override
  String get settingsBiometricError => 'Fout bij controleren van biometrie';

  @override
  String get settingsBiometricReason =>
      'Verifieer uw identiteit om biometrische ontgrendeling in te schakelen';

  @override
  String get settingsBiometricRequiresPin =>
      'Stel eerst een PIN in om biometrische ontgrendeling in te schakelen';

  @override
  String get settingsPinCode => 'PIN-code';

  @override
  String get settingsPinIsSet => 'PIN is ingesteld';

  @override
  String get settingsPinNotConfigured => 'Geen PIN geconfigureerd';

  @override
  String get settingsPinRemove => 'Verwijderen';

  @override
  String get settingsPinRemoveWarning =>
      'Het verwijderen van de PIN ontsleutelt alle databasevelden en schakelt biometrische ontgrendeling uit. Doorgaan?';

  @override
  String get settingsPinRemoveTitle => 'PIN verwijderen';

  @override
  String get settingsPreventScreenshots => 'Screenshots voorkomen';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Screenshots en schermopname blokkeren';

  @override
  String get settingsEncryptExport => 'Exports standaard versleutelen';

  @override
  String get settingsAbout => 'Over SSHVault';

  @override
  String get settingsAboutLegalese => 'door Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Beveiligde, zelfgehoste SSH-client';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get settingsLanguageSystem => 'Systeem';

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
  String get cancel => 'Annuleren';

  @override
  String get save => 'Opslaan';

  @override
  String get delete => 'Verwijderen';

  @override
  String get close => 'Sluiten';

  @override
  String get update => 'Bijwerken';

  @override
  String get create => 'Aanmaken';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get copy => 'Kopiëren';

  @override
  String get edit => 'Bewerken';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Fout: $message';
  }

  @override
  String get serverListTitle => 'Hosts';

  @override
  String get serverListEmpty => 'Nog geen servers';

  @override
  String get serverListEmptySubtitle =>
      'Voeg uw eerste SSH-server toe om te beginnen.';

  @override
  String get serverAddButton => 'Server toevoegen';

  @override
  String sshConfigImportMessage(int count) {
    return '$count host(s) gevonden in ~/.ssh/config. Importeren?';
  }

  @override
  String get sshConfigNotFound => 'Geen SSH-configuratiebestand gevonden';

  @override
  String get sshConfigEmpty => 'Geen hosts gevonden in SSH-configuratie';

  @override
  String get sshConfigAddManually => 'Handmatig toevoegen';

  @override
  String get sshConfigImportAgain => 'SSH-configuratie opnieuw importeren?';

  @override
  String get sshConfigImportKeys =>
      'SSH-sleutels importeren die door geselecteerde hosts worden gebruikt?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH-sleutel(s) geïmporteerd';
  }

  @override
  String get serverDuplicated => 'Server gedupliceerd';

  @override
  String get serverDeleteTitle => 'Server verwijderen';

  @override
  String serverDeleteMessage(String name) {
    return 'Weet u zeker dat u \"$name\" wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.';
  }

  @override
  String serverDeleteShort(String name) {
    return '\"$name\" verwijderen?';
  }

  @override
  String get serverConnect => 'Verbinden';

  @override
  String get serverDetails => 'Details';

  @override
  String get serverDuplicate => 'Dupliceren';

  @override
  String get serverActive => 'Actief';

  @override
  String get serverNoFolder => 'Geen map';

  @override
  String get serverFormTitleEdit => 'Server bewerken';

  @override
  String get serverFormTitleAdd => 'Server toevoegen';

  @override
  String get serverFormUpdateButton => 'Server bijwerken';

  @override
  String get serverFormAddButton => 'Server toevoegen';

  @override
  String get serverFormPublicKeyExtracted =>
      'Publieke sleutel succesvol geëxtraheerd';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Kon publieke sleutel niet extraheren: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type-sleutelpaar gegenereerd';
  }

  @override
  String get serverDetailTitle => 'Serverdetails';

  @override
  String get serverDetailDeleteMessage =>
      'Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get serverDetailConnection => 'Verbinding';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Poort';

  @override
  String get serverDetailUsername => 'Gebruikersnaam';

  @override
  String get serverDetailFolder => 'Map';

  @override
  String get serverDetailTags => 'Tags';

  @override
  String get serverDetailNotes => 'Notities';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Aangemaakt';

  @override
  String get serverDetailUpdated => 'Bijgewerkt';

  @override
  String get serverDetailDistro => 'Systeem';

  @override
  String get copiedToClipboard => 'Naar klembord gekopieerd';

  @override
  String get serverFormNameLabel => 'Servernaam';

  @override
  String get serverFormHostnameLabel => 'Hostnaam / IP';

  @override
  String get serverFormPortLabel => 'Poort';

  @override
  String get serverFormUsernameLabel => 'Gebruikersnaam';

  @override
  String get serverFormPasswordLabel => 'Wachtwoord';

  @override
  String get serverFormUseManagedKey => 'Beheerde sleutel gebruiken';

  @override
  String get serverFormManagedKeySubtitle =>
      'Selecteer uit centraal beheerde SSH-sleutels';

  @override
  String get serverFormDirectKeySubtitle =>
      'Plak sleutel rechtstreeks bij deze server';

  @override
  String get serverFormGenerateKey => 'SSH-sleutelpaar genereren';

  @override
  String get serverFormPrivateKeyLabel => 'Privésleutel';

  @override
  String get serverFormPrivateKeyHint => 'Plak SSH-privésleutel...';

  @override
  String get serverFormExtractPublicKey => 'Publieke sleutel extraheren';

  @override
  String get serverFormPublicKeyLabel => 'Publieke sleutel';

  @override
  String get serverFormPublicKeyHint =>
      'Automatisch gegenereerd uit privésleutel indien leeg';

  @override
  String get serverFormPassphraseLabel => 'Wachtwoordzin (optioneel)';

  @override
  String get serverFormNotesLabel => 'Notities (optioneel)';

  @override
  String get searchServers => 'Servers zoeken...';

  @override
  String get filterAllFolders => 'Alle mappen';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterActive => 'Actief';

  @override
  String get filterInactive => 'Inactief';

  @override
  String get filterClear => 'Wissen';

  @override
  String get folderListTitle => 'Mappen';

  @override
  String get folderListEmpty => 'Nog geen mappen';

  @override
  String get folderListEmptySubtitle =>
      'Maak mappen aan om uw servers te organiseren.';

  @override
  String get folderAddButton => 'Map toevoegen';

  @override
  String get folderDeleteTitle => 'Map verwijderen';

  @override
  String folderDeleteMessage(String name) {
    return '\"$name\" verwijderen? Servers worden ongecategoriseerd.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servers',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Inklappen';

  @override
  String get folderShowHosts => 'Hosts tonen';

  @override
  String get folderConnectAll => 'Alles verbinden';

  @override
  String get folderFormTitleEdit => 'Map bewerken';

  @override
  String get folderFormTitleNew => 'Nieuwe map';

  @override
  String get folderFormNameLabel => 'Mapnaam';

  @override
  String get folderFormParentLabel => 'Bovenliggende map';

  @override
  String get folderFormParentNone => 'Geen (Hoofdmap)';

  @override
  String get tagListTitle => 'Tags';

  @override
  String get tagListEmpty => 'Nog geen tags';

  @override
  String get tagListEmptySubtitle =>
      'Maak tags aan om uw servers te labelen en te filteren.';

  @override
  String get tagAddButton => 'Tag toevoegen';

  @override
  String get tagDeleteTitle => 'Tag verwijderen';

  @override
  String tagDeleteMessage(String name) {
    return '\"$name\" verwijderen? Het wordt van alle servers verwijderd.';
  }

  @override
  String get tagFormTitleEdit => 'Tag bewerken';

  @override
  String get tagFormTitleNew => 'Nieuwe tag';

  @override
  String get tagFormNameLabel => 'Tagnaam';

  @override
  String get sshKeyListTitle => 'SSH-sleutels';

  @override
  String get sshKeyListEmpty => 'Nog geen SSH-sleutels';

  @override
  String get sshKeyListEmptySubtitle =>
      'Genereer of importeer SSH-sleutels om ze centraal te beheren';

  @override
  String get sshKeyCannotDeleteTitle => 'Kan niet verwijderen';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Kan \"$name\" niet verwijderen. Gebruikt door $count server(s). Ontkoppel eerst van alle servers.';
  }

  @override
  String get sshKeyDeleteTitle => 'SSH-sleutel verwijderen';

  @override
  String sshKeyDeleteMessage(String name) {
    return '\"$name\" verwijderen? Dit kan niet ongedaan worden gemaakt.';
  }

  @override
  String get sshKeyAddButton => 'SSH-sleutel toevoegen';

  @override
  String get sshKeyFormTitleEdit => 'SSH-sleutel bewerken';

  @override
  String get sshKeyFormTitleAdd => 'SSH-sleutel toevoegen';

  @override
  String get sshKeyFormTabGenerate => 'Genereren';

  @override
  String get sshKeyFormTabImport => 'Importeren';

  @override
  String get sshKeyFormNameLabel => 'Sleutelnaam';

  @override
  String get sshKeyFormNameHint => 'bijv. Mijn productie-sleutel';

  @override
  String get sshKeyFormKeyType => 'Sleuteltype';

  @override
  String get sshKeyFormKeySize => 'Sleutelgrootte';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Opmerking';

  @override
  String get sshKeyFormCommentHint => 'gebruiker@host of beschrijving';

  @override
  String get sshKeyFormCommentOptional => 'Opmerking (optioneel)';

  @override
  String get sshKeyFormImportFromFile => 'Importeren vanuit bestand';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Privésleutel';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Plak SSH-privésleutel of gebruik bovenstaande knop...';

  @override
  String get sshKeyFormPassphraseLabel => 'Wachtwoordzin (optioneel)';

  @override
  String get sshKeyFormNameRequired => 'Naam is vereist';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Privésleutel is vereist';

  @override
  String get sshKeyFormFileReadError =>
      'Kan het geselecteerde bestand niet lezen';

  @override
  String get sshKeyFormInvalidFormat =>
      'Ongeldig sleutelformaat — verwacht PEM-formaat (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Kan bestand niet lezen: $message';
  }

  @override
  String get sshKeyFormSaving => 'Opslaan...';

  @override
  String get sshKeySelectorLabel => 'SSH-sleutel';

  @override
  String get sshKeySelectorNone => 'Geen beheerde sleutel';

  @override
  String get sshKeySelectorManage => 'Sleutels beheren...';

  @override
  String get sshKeySelectorError => 'Kan SSH-sleutels niet laden';

  @override
  String get sshKeyTileCopyPublicKey => 'Publieke sleutel kopiëren';

  @override
  String get sshKeyTilePublicKeyCopied => 'Publieke sleutel gekopieerd';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Gebruikt door $count server(s)';
  }

  @override
  String get sshKeyTileUnlinkFirst => 'Ontkoppel eerst van alle servers';

  @override
  String get exportImportTitle => 'Exporteren / Importeren';

  @override
  String get exportSectionTitle => 'Exporteren';

  @override
  String get exportJsonButton => 'Exporteren als JSON (zonder referenties)';

  @override
  String get exportZipButton => 'Versleutelde ZIP exporteren (met referenties)';

  @override
  String get importSectionTitle => 'Importeren';

  @override
  String get importButton => 'Importeren vanuit bestand';

  @override
  String get importSupportedFormats =>
      'Ondersteunt JSON- (onversleuteld) en ZIP-bestanden (versleuteld).';

  @override
  String exportedTo(String path) {
    return 'Geëxporteerd naar: $path';
  }

  @override
  String get share => 'Delen';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers servers, $groups groepen, $tags tags geïmporteerd. $skipped overgeslagen.';
  }

  @override
  String get importPasswordTitle => 'Wachtwoord invoeren';

  @override
  String get importPasswordLabel => 'Exportwachtwoord';

  @override
  String get importPasswordDecrypt => 'Ontsleutelen';

  @override
  String get exportPasswordTitle => 'Exportwachtwoord instellen';

  @override
  String get exportPasswordDescription =>
      'Dit wachtwoord wordt gebruikt om uw exportbestand inclusief referenties te versleutelen.';

  @override
  String get exportPasswordLabel => 'Wachtwoord';

  @override
  String get exportPasswordConfirmLabel => 'Wachtwoord bevestigen';

  @override
  String get exportPasswordMismatch => 'Wachtwoorden komen niet overeen';

  @override
  String get exportPasswordButton => 'Versleutelen en exporteren';

  @override
  String get importConflictTitle => 'Conflicten afhandelen';

  @override
  String get importConflictDescription =>
      'Hoe moeten bestaande items tijdens het importeren worden behandeld?';

  @override
  String get importConflictSkip => 'Bestaande overslaan';

  @override
  String get importConflictRename => 'Nieuwe hernoemen';

  @override
  String get importConflictOverwrite => 'Overschrijven';

  @override
  String get confirmDeleteLabel => 'Verwijderen';

  @override
  String get keyGenTitle => 'SSH-sleutelpaar genereren';

  @override
  String get keyGenKeyType => 'Sleuteltype';

  @override
  String get keyGenKeySize => 'Sleutelgrootte';

  @override
  String get keyGenComment => 'Opmerking';

  @override
  String get keyGenCommentHint => 'gebruiker@host of beschrijving';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Genereren...';

  @override
  String get keyGenGenerate => 'Genereren';

  @override
  String keyGenResultTitle(String type) {
    return '$type-sleutel gegenereerd';
  }

  @override
  String get keyGenPublicKey => 'Publieke sleutel';

  @override
  String get keyGenPrivateKey => 'Privésleutel';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Opmerking: $comment';
  }

  @override
  String get keyGenAnother => 'Nog een genereren';

  @override
  String get keyGenUseThisKey => 'Deze sleutel gebruiken';

  @override
  String get keyGenCopyTooltip => 'Naar klembord kopiëren';

  @override
  String keyGenCopied(String label) {
    return '$label gekopieerd';
  }

  @override
  String get colorPickerLabel => 'Kleur';

  @override
  String get iconPickerLabel => 'Pictogram';

  @override
  String get tagSelectorLabel => 'Tags';

  @override
  String get tagSelectorEmpty => 'Nog geen tags';

  @override
  String get tagSelectorError => 'Kan tags niet laden';

  @override
  String get snippetListTitle => 'Snippets';

  @override
  String get snippetSearchHint => 'Snippets zoeken...';

  @override
  String get snippetListEmpty => 'Nog geen snippets';

  @override
  String get snippetListEmptySubtitle =>
      'Maak herbruikbare codefragmenten en opdrachten.';

  @override
  String get snippetAddButton => 'Snippet toevoegen';

  @override
  String get snippetDeleteTitle => 'Snippet verwijderen';

  @override
  String snippetDeleteMessage(String name) {
    return '\"$name\" verwijderen? Dit kan niet ongedaan worden gemaakt.';
  }

  @override
  String get snippetFormTitleEdit => 'Snippet bewerken';

  @override
  String get snippetFormTitleNew => 'Nieuw snippet';

  @override
  String get snippetFormNameLabel => 'Naam';

  @override
  String get snippetFormNameHint => 'bijv. Docker opschonen';

  @override
  String get snippetFormLanguageLabel => 'Taal';

  @override
  String get snippetFormContentLabel => 'Inhoud';

  @override
  String get snippetFormContentHint => 'Voer uw snippetcode in...';

  @override
  String get snippetFormDescriptionLabel => 'Beschrijving';

  @override
  String get snippetFormDescriptionHint => 'Optionele beschrijving...';

  @override
  String get snippetFormFolderLabel => 'Map';

  @override
  String get snippetFormNoFolder => 'Geen map';

  @override
  String get snippetFormNameRequired => 'Naam is vereist';

  @override
  String get snippetFormContentRequired => 'Inhoud is vereist';

  @override
  String get snippetFormUpdateButton => 'Snippet bijwerken';

  @override
  String get snippetFormCreateButton => 'Snippet aanmaken';

  @override
  String get snippetDetailTitle => 'Snippetdetails';

  @override
  String get snippetDetailDeleteTitle => 'Snippet verwijderen';

  @override
  String get snippetDetailDeleteMessage =>
      'Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get snippetDetailContent => 'Inhoud';

  @override
  String get snippetDetailFillVariables => 'Variabelen invullen';

  @override
  String get snippetDetailDescription => 'Beschrijving';

  @override
  String get snippetDetailVariables => 'Variabelen';

  @override
  String get snippetDetailTags => 'Tags';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Aangemaakt';

  @override
  String get snippetDetailUpdated => 'Bijgewerkt';

  @override
  String get variableEditorTitle => 'Sjabloonvariabelen';

  @override
  String get variableEditorAdd => 'Toevoegen';

  @override
  String get variableEditorEmpty =>
      'Geen variabelen. Gebruik accolades in de inhoud om ernaar te verwijzen.';

  @override
  String get variableEditorNameLabel => 'Naam';

  @override
  String get variableEditorNameHint => 'bijv. hostnaam';

  @override
  String get variableEditorDefaultLabel => 'Standaard';

  @override
  String get variableEditorDefaultHint => 'optioneel';

  @override
  String get variableFillTitle => 'Variabelen invullen';

  @override
  String variableFillHint(String name) {
    return 'Voer waarde in voor $name';
  }

  @override
  String get variableFillPreview => 'Voorbeeld';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Geen actieve sessies';

  @override
  String get terminalEmptySubtitle =>
      'Maak verbinding met een host om een terminalsessie te openen.';

  @override
  String get terminalGoToHosts => 'Naar hosts';

  @override
  String get terminalCloseAll => 'Alle sessies sluiten';

  @override
  String get terminalCloseTitle => 'Sessie sluiten';

  @override
  String terminalCloseMessage(String title) {
    return 'De actieve verbinding met \"$title\" sluiten?';
  }

  @override
  String get connectionAuthenticating => 'Authenticeren...';

  @override
  String connectionConnecting(String name) {
    return 'Verbinden met $name...';
  }

  @override
  String get connectionError => 'Verbindingsfout';

  @override
  String get connectionLost => 'Verbinding verloren';

  @override
  String get connectionReconnect => 'Opnieuw verbinden';

  @override
  String get snippetQuickPanelTitle => 'Snippet invoegen';

  @override
  String get snippetQuickPanelSearch => 'Snippets zoeken...';

  @override
  String get snippetQuickPanelEmpty => 'Geen snippets beschikbaar';

  @override
  String get snippetQuickPanelNoMatch => 'Geen overeenkomende snippets';

  @override
  String get snippetQuickPanelInsertTooltip => 'Snippet invoegen';

  @override
  String get terminalThemePickerTitle => 'Terminalthema';

  @override
  String get validatorHostnameRequired => 'Hostnaam is vereist';

  @override
  String get validatorHostnameInvalid => 'Ongeldige hostnaam of IP-adres';

  @override
  String get validatorPortRequired => 'Poort is vereist';

  @override
  String get validatorPortRange => 'Poort moet tussen 1 en 65535 liggen';

  @override
  String get validatorUsernameRequired => 'Gebruikersnaam is vereist';

  @override
  String get validatorUsernameInvalid => 'Ongeldig gebruikersnaamformaat';

  @override
  String get validatorServerNameRequired => 'Servernaam is vereist';

  @override
  String get validatorServerNameLength =>
      'Servernaam mag maximaal 100 tekens zijn';

  @override
  String get validatorSshKeyInvalid => 'Ongeldig SSH-sleutelformaat';

  @override
  String get validatorPasswordRequired => 'Wachtwoord is vereist';

  @override
  String get validatorPasswordLength =>
      'Wachtwoord moet minstens 8 tekens zijn';

  @override
  String get authMethodPassword => 'Wachtwoord';

  @override
  String get authMethodKey => 'SSH-sleutel';

  @override
  String get authMethodBoth => 'Wachtwoord + Sleutel';

  @override
  String get serverCopySuffix => '(Kopie)';

  @override
  String get settingsDownloadLogs => 'Logboeken downloaden';

  @override
  String get settingsSendLogs => 'Logboeken naar support sturen';

  @override
  String get settingsLogsSaved => 'Logboeken succesvol opgeslagen';

  @override
  String get settingsLogsEmpty => 'Geen logboekitems beschikbaar';

  @override
  String get authLogin => 'Inloggen';

  @override
  String get authRegister => 'Registreren';

  @override
  String get authForgotPassword => 'Wachtwoord vergeten?';

  @override
  String get authWhyLogin =>
      'Log in om versleutelde cloudsynchronisatie op al uw apparaten in te schakelen. De app werkt volledig offline zonder account.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailRequired => 'E-mail is vereist';

  @override
  String get authEmailInvalid => 'Ongeldig e-mailadres';

  @override
  String get authPasswordLabel => 'Wachtwoord';

  @override
  String get authConfirmPasswordLabel => 'Wachtwoord bevestigen';

  @override
  String get authPasswordMismatch => 'Wachtwoorden komen niet overeen';

  @override
  String get authNoAccount => 'Geen account?';

  @override
  String get authHasAccount => 'Heeft u al een account?';

  @override
  String get authSelfHosted => 'Zelfgehoste server';

  @override
  String get authResetEmailSent =>
      'Als er een account bestaat, is er een resetlink naar uw e-mail gestuurd.';

  @override
  String get authResetDescription =>
      'Voer uw e-mailadres in en wij sturen u een link om uw wachtwoord te resetten.';

  @override
  String get authSendResetLink => 'Resetlink versturen';

  @override
  String get authBackToLogin => 'Terug naar inloggen';

  @override
  String get syncPasswordTitle => 'Synchronisatiewachtwoord';

  @override
  String get syncPasswordTitleCreate => 'Synchronisatiewachtwoord instellen';

  @override
  String get syncPasswordTitleEnter => 'Synchronisatiewachtwoord invoeren';

  @override
  String get syncPasswordDescription =>
      'Stel een apart wachtwoord in om uw kluisgegevens te versleutelen. Dit wachtwoord verlaat nooit uw apparaat — de server slaat alleen versleutelde gegevens op.';

  @override
  String get syncPasswordHintEnter =>
      'Voer het wachtwoord in dat u bij het aanmaken van uw account hebt ingesteld.';

  @override
  String get syncPasswordWarning =>
      'Als u dit wachtwoord vergeet, kunnen uw gesynchroniseerde gegevens niet worden hersteld. Er is geen resetoptie.';

  @override
  String get syncPasswordLabel => 'Synchronisatiewachtwoord';

  @override
  String get syncPasswordWrong => 'Verkeerd wachtwoord. Probeer het opnieuw.';

  @override
  String get firstSyncTitle => 'Bestaande gegevens gevonden';

  @override
  String get firstSyncMessage =>
      'Dit apparaat heeft bestaande gegevens en de server heeft een kluis. Hoe wilt u verdergaan?';

  @override
  String get firstSyncMerge => 'Samenvoegen (server wint)';

  @override
  String get firstSyncOverwriteLocal => 'Lokale gegevens overschrijven';

  @override
  String get firstSyncKeepLocal => 'Lokaal behouden en pushen';

  @override
  String get firstSyncDeleteLocal => 'Lokaal verwijderen en pullen';

  @override
  String get changeEncryptionPassword => 'Versleutelingswachtwoord wijzigen';

  @override
  String get changeEncryptionWarning =>
      'U wordt op alle andere apparaten uitgelogd.';

  @override
  String get changeEncryptionOldPassword => 'Huidig wachtwoord';

  @override
  String get changeEncryptionNewPassword => 'Nieuw wachtwoord';

  @override
  String get changeEncryptionSuccess => 'Wachtwoord succesvol gewijzigd.';

  @override
  String get logoutAllDevices => 'Op alle apparaten uitloggen';

  @override
  String get logoutAllDevicesConfirm =>
      'Hiermee worden alle actieve sessies ingetrokken. U moet opnieuw inloggen op alle apparaten.';

  @override
  String get logoutAllDevicesSuccess => 'Alle apparaten uitgelogd.';

  @override
  String get syncSettingsTitle => 'Synchronisatie-instellingen';

  @override
  String get syncAutoSync => 'Automatisch synchroniseren';

  @override
  String get syncAutoSyncDescription =>
      'Automatisch synchroniseren bij het starten van de app';

  @override
  String get syncNow => 'Nu synchroniseren';

  @override
  String get syncSyncing => 'Synchroniseren...';

  @override
  String get syncSuccess => 'Synchronisatie voltooid';

  @override
  String get syncError => 'Synchronisatiefout';

  @override
  String get syncServerUnreachable => 'Server niet bereikbaar';

  @override
  String get syncServerUnreachableHint =>
      'De synchronisatieserver kon niet worden bereikt. Controleer uw internetverbinding en server-URL.';

  @override
  String get syncNetworkError =>
      'Verbinding met server mislukt. Controleer uw internetverbinding of probeer het later opnieuw.';

  @override
  String get syncNeverSynced => 'Nooit gesynchroniseerd';

  @override
  String get syncVaultVersion => 'Kluisversie';

  @override
  String get syncTitle => 'Synchronisatie';

  @override
  String get settingsSectionNetwork => 'Netwerk & DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS-servers';

  @override
  String get settingsDnsDefault => 'Standaard (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Voer aangepaste DoH-server-URL\'s in, gescheiden door komma\'s. Er zijn minstens 2 servers nodig voor kruiscontrole.';

  @override
  String get settingsDnsLabel => 'DoH-server-URL\'s';

  @override
  String get settingsDnsReset => 'Standaard herstellen';

  @override
  String get settingsSectionSync => 'Synchronisatie';

  @override
  String get settingsSyncAccount => 'Account';

  @override
  String get settingsSyncNotLoggedIn => 'Niet ingelogd';

  @override
  String get settingsSyncStatus => 'Synchronisatie';

  @override
  String get settingsSyncServerUrl => 'Server-URL';

  @override
  String get settingsSyncDefaultServer => 'Standaard (sshvault.app)';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountNotLoggedIn => 'Niet ingelogd';

  @override
  String get accountVerified => 'Geverifieerd';

  @override
  String get accountMemberSince => 'Lid sinds';

  @override
  String get accountDevices => 'Apparaten';

  @override
  String get accountNoDevices => 'Geen apparaten geregistreerd';

  @override
  String get accountLastSync => 'Laatste synchronisatie';

  @override
  String get accountChangePassword => 'Wachtwoord wijzigen';

  @override
  String get accountOldPassword => 'Huidig wachtwoord';

  @override
  String get accountNewPassword => 'Nieuw wachtwoord';

  @override
  String get accountDeleteAccount => 'Account verwijderen';

  @override
  String get accountDeleteWarning =>
      'Hiermee worden uw account en alle gesynchroniseerde gegevens permanent verwijderd. Dit kan niet ongedaan worden gemaakt.';

  @override
  String get accountLogout => 'Uitloggen';

  @override
  String get serverConfigTitle => 'Serverconfiguratie';

  @override
  String get serverConfigSelfHosted => 'Zelfgehost';

  @override
  String get serverConfigSelfHostedDescription =>
      'Gebruik uw eigen SSHVault-server';

  @override
  String get serverConfigUrlLabel => 'Server-URL';

  @override
  String get serverConfigTest => 'Verbinding testen';

  @override
  String get auditLogTitle => 'Activiteitenlogboek';

  @override
  String get auditLogAll => 'Alle';

  @override
  String get auditLogEmpty => 'Geen activiteitenlogboeken gevonden';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Bestandsbeheer';

  @override
  String get sftpLocalDevice => 'Lokaal apparaat';

  @override
  String get sftpSelectServer => 'Server selecteren...';

  @override
  String get sftpConnecting => 'Verbinden...';

  @override
  String get sftpEmptyDirectory => 'Deze map is leeg';

  @override
  String get sftpNoConnection => 'Geen server verbonden';

  @override
  String get sftpPathLabel => 'Pad';

  @override
  String get sftpUpload => 'Uploaden';

  @override
  String get sftpDownload => 'Downloaden';

  @override
  String get sftpDelete => 'Verwijderen';

  @override
  String get sftpRename => 'Hernoemen';

  @override
  String get sftpNewFolder => 'Nieuwe map';

  @override
  String get sftpNewFolderName => 'Mapnaam';

  @override
  String get sftpChmod => 'Rechten';

  @override
  String get sftpChmodTitle => 'Rechten wijzigen';

  @override
  String get sftpChmodOctal => 'Octaal';

  @override
  String get sftpChmodOwner => 'Eigenaar';

  @override
  String get sftpChmodGroup => 'Groep';

  @override
  String get sftpChmodOther => 'Overige';

  @override
  String get sftpChmodRead => 'Lezen';

  @override
  String get sftpChmodWrite => 'Schrijven';

  @override
  String get sftpChmodExecute => 'Uitvoeren';

  @override
  String get sftpCreateSymlink => 'Symlink aanmaken';

  @override
  String get sftpSymlinkTarget => 'Doelpad';

  @override
  String get sftpSymlinkName => 'Linknaam';

  @override
  String get sftpFilePreview => 'Bestandsvoorbeeld';

  @override
  String get sftpFileInfo => 'Bestandsinfo';

  @override
  String get sftpFileSize => 'Grootte';

  @override
  String get sftpFileModified => 'Gewijzigd';

  @override
  String get sftpFilePermissions => 'Rechten';

  @override
  String get sftpFileOwner => 'Eigenaar';

  @override
  String get sftpFileType => 'Type';

  @override
  String get sftpFileLinkTarget => 'Linkdoel';

  @override
  String get sftpTransfers => 'Overdrachten';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current van $total';
  }

  @override
  String get sftpTransferQueued => 'In wachtrij';

  @override
  String get sftpTransferActive => 'Bezig met overdracht...';

  @override
  String get sftpTransferPaused => 'Gepauzeerd';

  @override
  String get sftpTransferCompleted => 'Voltooid';

  @override
  String get sftpTransferFailed => 'Mislukt';

  @override
  String get sftpTransferCancelled => 'Geannuleerd';

  @override
  String get sftpPauseTransfer => 'Pauzeren';

  @override
  String get sftpResumeTransfer => 'Hervatten';

  @override
  String get sftpCancelTransfer => 'Annuleren';

  @override
  String get sftpClearCompleted => 'Voltooide wissen';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active van $total overdrachten';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actief',
      one: '1 actief',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voltooid',
      one: '1 voltooid',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mislukt',
      one: '1 mislukt',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Kopiëren naar ander paneel';

  @override
  String sftpConfirmDelete(int count) {
    return '$count items verwijderen?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return '\"$name\" verwijderen?';
  }

  @override
  String get sftpDeleteSuccess => 'Succesvol verwijderd';

  @override
  String get sftpRenameTitle => 'Hernoemen';

  @override
  String get sftpRenameLabel => 'Nieuwe naam';

  @override
  String get sftpSortByName => 'Naam';

  @override
  String get sftpSortBySize => 'Grootte';

  @override
  String get sftpSortByDate => 'Datum';

  @override
  String get sftpSortByType => 'Type';

  @override
  String get sftpShowHidden => 'Verborgen bestanden tonen';

  @override
  String get sftpHideHidden => 'Verborgen bestanden verbergen';

  @override
  String get sftpSelectAll => 'Alles selecteren';

  @override
  String get sftpDeselectAll => 'Alles deselecteren';

  @override
  String sftpItemsSelected(int count) {
    return '$count geselecteerd';
  }

  @override
  String get sftpRefresh => 'Vernieuwen';

  @override
  String sftpConnectionError(String message) {
    return 'Verbinding mislukt: $message';
  }

  @override
  String get sftpPermissionDenied => 'Toegang geweigerd';

  @override
  String sftpOperationFailed(String message) {
    return 'Bewerking mislukt: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Bestand bestaat al';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" bestaat al. Overschrijven?';
  }

  @override
  String get sftpOverwrite => 'Overschrijven';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Overdracht gestart: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Selecteer eerst een bestemming in het andere paneel';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Mapoverdracht binnenkort beschikbaar';

  @override
  String get sftpSelect => 'Selecteren';

  @override
  String get sftpOpen => 'Openen';

  @override
  String get sftpExtractArchive => 'Hier uitpakken';

  @override
  String get sftpExtractSuccess => 'Archief uitgepakt';

  @override
  String sftpExtractFailed(String message) {
    return 'Uitpakken mislukt: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Niet-ondersteund archiefformaat';

  @override
  String get sftpExtracting => 'Uitpakken...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uploads gestart',
      one: 'Upload gestart',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads gestart',
      one: 'Download gestart',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" gedownload';
  }

  @override
  String get sftpSavedToDownloads => 'Opgeslagen in Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Opslaan in bestanden';

  @override
  String get sftpFileSaved => 'Bestand opgeslagen';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH-sessies actief',
      one: 'SSH-sessie actief',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Tik om terminal te openen';

  @override
  String get settingsAccountAndSync => 'Account & Synchronisatie';

  @override
  String get settingsAccountSubtitleAuth => 'Ingelogd';

  @override
  String get settingsAccountSubtitleUnauth => 'Niet ingelogd';

  @override
  String get settingsSecuritySubtitle =>
      'Automatische vergrendeling, Biometrie, PIN';

  @override
  String get settingsSshSubtitle => 'Poort 22, Gebruiker root';

  @override
  String get settingsAppearanceSubtitle => 'Thema, Taal, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Versleutelde exportstandaarden';

  @override
  String get settingsAboutSubtitle => 'Versie, Licenties';

  @override
  String get settingsSearchHint => 'Instellingen zoeken...';

  @override
  String get settingsSearchNoResults => 'Geen instellingen gevonden';

  @override
  String get aboutDeveloper => 'Ontwikkeld door Kiefer Networks';

  @override
  String get aboutDonate => 'Doneren';

  @override
  String get aboutOpenSourceLicenses => 'Opensourcelicenties';

  @override
  String get aboutWebsite => 'Website';

  @override
  String get aboutVersion => 'Versie';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS versleutelt DNS-query\'s en voorkomt DNS-spoofing. SSHVault controleert hostnamen bij meerdere providers om aanvallen te detecteren.';

  @override
  String get settingsDnsAddServer => 'DNS-server toevoegen';

  @override
  String get settingsDnsServerUrl => 'Server-URL';

  @override
  String get settingsDnsDefaultBadge => 'Standaard';

  @override
  String get settingsDnsResetDefaults => 'Standaard herstellen';

  @override
  String get settingsDnsInvalidUrl => 'Voer een geldige HTTPS-URL in';

  @override
  String get settingsDefaultAuthMethod => 'Authenticatiemethode';

  @override
  String get settingsAuthPassword => 'Wachtwoord';

  @override
  String get settingsAuthKey => 'SSH-sleutel';

  @override
  String get settingsConnectionTimeout => 'Verbindingstime-out';

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
  String get settingsCompression => 'Compressie';

  @override
  String get settingsCompressionDescription =>
      'Zlib-compressie voor SSH-verbindingen inschakelen';

  @override
  String get settingsTerminalType => 'Terminaltype';

  @override
  String get settingsSectionConnection => 'Verbinding';

  @override
  String get settingsClipboardAutoClear => 'Klembord automatisch wissen';

  @override
  String get settingsClipboardAutoClearOff => 'Uit';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Sessietime-out';

  @override
  String get settingsSessionTimeoutOff => 'Uit';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'Nood-PIN';

  @override
  String get settingsDuressPinDescription =>
      'Een aparte PIN die alle gegevens wist bij invoer';

  @override
  String get settingsDuressPinSet => 'Nood-PIN is ingesteld';

  @override
  String get settingsDuressPinNotSet => 'Niet geconfigureerd';

  @override
  String get settingsDuressPinWarning =>
      'Het invoeren van deze PIN verwijdert permanent alle lokale gegevens, inclusief referenties, sleutels en instellingen. Dit kan niet ongedaan worden gemaakt.';

  @override
  String get settingsKeyRotationReminder => 'Sleutelrotatieherinnering';

  @override
  String get settingsKeyRotationOff => 'Uit';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days dagen';
  }

  @override
  String get settingsFailedAttempts => 'Mislukte PIN-pogingen';

  @override
  String get settingsSectionAppLock => 'App-vergrendeling';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsSectionReminders => 'Herinneringen';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle => 'Exporteren, Importeren & Back-up';

  @override
  String get settingsExportJson => 'Exporteren als JSON';

  @override
  String get settingsExportEncrypted => 'Versleuteld exporteren';

  @override
  String get settingsImportFile => 'Importeren vanuit bestand';

  @override
  String get settingsSectionImport => 'Importeren';

  @override
  String get filterTitle => 'Servers filteren';

  @override
  String get filterApply => 'Filters toepassen';

  @override
  String get filterClearAll => 'Alles wissen';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filters actief',
      one: '1 filter actief',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Map';

  @override
  String get filterTags => 'Tags';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Opgelost voorbeeld';

  @override
  String get variableInsert => 'Invoegen';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servers',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessies ingetrokken.',
      one: '1 sessie ingetrokken.',
    );
    return '$_temp0 U bent uitgelogd.';
  }

  @override
  String get keyGenPassphrase => 'Wachtwoordzin';

  @override
  String get keyGenPassphraseHint => 'Optioneel — beschermt de privésleutel';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Standaard (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Een sleutel met dezelfde vingerafdruk bestaat al: \"$name\". Elke SSH-sleutel moet uniek zijn.';
  }

  @override
  String get sshKeyFingerprint => 'Vingerafdruk';

  @override
  String get sshKeyPublicKey => 'Publieke sleutel';

  @override
  String get jumpHost => 'Jump Host';

  @override
  String get jumpHostNone => 'Geen';

  @override
  String get jumpHostLabel => 'Verbinden via jump host';

  @override
  String get jumpHostSelfError =>
      'Een server kan niet zijn eigen jump host zijn';

  @override
  String get jumpHostConnecting => 'Verbinden met jump host...';

  @override
  String get jumpHostCircularError => 'Circulaire jump host-keten gedetecteerd';

  @override
  String get logoutDialogTitle => 'Uitloggen';

  @override
  String get logoutDialogMessage =>
      'Wilt u alle lokale gegevens verwijderen? Servers, SSH-sleutels, snippets en instellingen worden van dit apparaat verwijderd.';

  @override
  String get logoutOnly => 'Alleen uitloggen';

  @override
  String get logoutAndDelete => 'Uitloggen en gegevens verwijderen';

  @override
  String get changeAvatar => 'Avatar wijzigen';

  @override
  String get removeAvatar => 'Avatar verwijderen';

  @override
  String get avatarUploadFailed => 'Avatar uploaden mislukt';

  @override
  String get avatarTooLarge => 'Afbeelding is te groot';

  @override
  String get deviceLastSeen => 'Laatst gezien';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Server-URL kan niet worden gewijzigd terwijl u bent ingelogd. Log eerst uit.';

  @override
  String get serverListNoFolder => 'Ongecategoriseerd';

  @override
  String get autoSyncInterval => 'Synchronisatie-interval';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Proxy-instellingen';

  @override
  String get proxyType => 'Proxytype';

  @override
  String get proxyNone => 'Geen proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxyhost';

  @override
  String get proxyPort => 'Proxypoort';

  @override
  String get proxyUsername => 'Proxygebruikersnaam';

  @override
  String get proxyPassword => 'Proxywachtwoord';

  @override
  String get proxyUseGlobal => 'Globale proxy gebruiken';

  @override
  String get proxyGlobal => 'Globaal';

  @override
  String get proxyServerSpecific => 'Serverspecifiek';

  @override
  String get proxyTestConnection => 'Verbinding testen';

  @override
  String get proxyTestSuccess => 'Proxy bereikbaar';

  @override
  String get proxyTestFailed => 'Proxy niet bereikbaar';

  @override
  String get proxyDefaultProxy => 'Standaardproxy';

  @override
  String get vpnRequired => 'VPN vereist';

  @override
  String get vpnRequiredTooltip =>
      'Waarschuwing tonen bij verbinden zonder actieve VPN';

  @override
  String get vpnActive => 'VPN actief';

  @override
  String get vpnInactive => 'VPN inactief';

  @override
  String get vpnWarningTitle => 'VPN niet actief';

  @override
  String get vpnWarningMessage =>
      'Deze server vereist een VPN-verbinding, maar er is momenteel geen VPN actief. Wilt u toch verbinden?';

  @override
  String get vpnConnectAnyway => 'Toch verbinden';

  @override
  String get postConnectCommands => 'Opdrachten na verbinding';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Opdrachten die automatisch na verbinding worden uitgevoerd (één per regel)';

  @override
  String get dashboardFavorites => 'Favorieten';

  @override
  String get dashboardRecent => 'Recent';

  @override
  String get dashboardActiveSessions => 'Actieve sessies';

  @override
  String get addToFavorites => 'Toevoegen aan favorieten';

  @override
  String get removeFromFavorites => 'Verwijderen uit favorieten';

  @override
  String get noRecentConnections => 'Geen recente verbindingen';

  @override
  String get terminalSplit => 'Gesplitste weergave';

  @override
  String get terminalUnsplit => 'Splitsing sluiten';

  @override
  String get terminalSelectSession =>
      'Selecteer sessie voor gesplitste weergave';

  @override
  String get knownHostsTitle => 'Bekende hosts';

  @override
  String get knownHostsSubtitle => 'Vertrouwde servervingerafdrukken beheren';

  @override
  String get hostKeyNewTitle => 'Nieuwe host';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Eerste verbinding met $hostname:$port. Controleer de vingerafdruk voordat u verbindt.';
  }

  @override
  String get hostKeyChangedTitle => 'Hostsleutel gewijzigd!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'De hostsleutel voor $hostname:$port is gewijzigd. Dit kan een beveiligingsbedreiging zijn.';
  }

  @override
  String get hostKeyFingerprint => 'Vingerafdruk';

  @override
  String get hostKeyType => 'Sleuteltype';

  @override
  String get hostKeyTrustConnect => 'Vertrouwen en verbinden';

  @override
  String get hostKeyAcceptNew => 'Nieuwe sleutel accepteren';

  @override
  String get hostKeyReject => 'Weigeren';

  @override
  String get hostKeyPreviousFingerprint => 'Vorige vingerafdruk';

  @override
  String get hostKeyDeleteAll => 'Alle bekende hosts verwijderen';

  @override
  String get hostKeyDeleteConfirm =>
      'Weet u zeker dat u alle bekende hosts wilt verwijderen? U wordt bij de volgende verbinding opnieuw gevraagd.';

  @override
  String get hostKeyEmpty => 'Nog geen bekende hosts';

  @override
  String get hostKeyEmptySubtitle =>
      'Hostvingerafdrukken worden hier opgeslagen na uw eerste verbinding';

  @override
  String get hostKeyFirstSeen => 'Eerste keer gezien';

  @override
  String get hostKeyLastSeen => 'Laatste keer gezien';

  @override
  String get sshConfigImportTitle => 'SSH-configuratie importeren';

  @override
  String get sshConfigImportPickFile => 'SSH-configuratiebestand selecteren';

  @override
  String get sshConfigImportOrPaste => 'Of configuratie-inhoud plakken';

  @override
  String sshConfigImportParsed(int count) {
    return '$count hosts gevonden';
  }

  @override
  String get sshConfigImportButton => 'Importeren';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count server(s) geïmporteerd';
  }

  @override
  String get sshConfigImportDuplicate => 'Bestaat al';

  @override
  String get sshConfigImportNoHosts => 'Geen hosts gevonden in configuratie';

  @override
  String get sftpBookmarkAdd => 'Bladwijzer toevoegen';

  @override
  String get sftpBookmarkLabel => 'Label';

  @override
  String get disconnect => 'Verbinding verbreken';

  @override
  String get reportAndDisconnect => 'Melden en verbinding verbreken';

  @override
  String get continueAnyway => 'Toch doorgaan';

  @override
  String get insertSnippet => 'Snippet invoegen';

  @override
  String get seconds => 'Seconden';

  @override
  String get heartbeatLostMessage =>
      'De server kon na meerdere pogingen niet worden bereikt. Voor uw veiligheid is de sessie beëindigd.';

  @override
  String get attestationFailedTitle => 'Serververificatie mislukt';

  @override
  String get attestationFailedMessage =>
      'De server kon niet worden geverifieerd als een legitieme SSHVault-backend. Dit kan duiden op een man-in-the-middle-aanval of een verkeerd geconfigureerde server.';

  @override
  String get attestationKeyChangedTitle => 'Serversleutel gewijzigd';

  @override
  String get attestationKeyChangedMessage =>
      'De attestatiesleutel van de server is gewijzigd sinds de eerste verbinding. Dit kan duiden op een man-in-the-middle-aanval. Ga NIET door tenzij de serverbeheerder een sleutelrotatie heeft bevestigd.';

  @override
  String get sectionLinks => 'Links';

  @override
  String get sectionDeveloper => 'Ontwikkelaar';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Pagina niet gevonden';

  @override
  String get connectionTestSuccess => 'Verbinding geslaagd';

  @override
  String connectionTestFailed(String message) {
    return 'Verbinding mislukt: $message';
  }

  @override
  String get serverVerificationFailed => 'Serververificatie mislukt';

  @override
  String get importSuccessful => 'Import geslaagd';

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
  String get deviceDeleteConfirmTitle => 'Apparaat verwijderen';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Weet je zeker dat je \"$name\" wilt verwijderen? Het apparaat wordt onmiddellijk uitgelogd.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Dit is je huidige apparaat. Je wordt onmiddellijk uitgelogd.';

  @override
  String get deviceDeleteSuccess => 'Apparaat verwijderd';

  @override
  String get deviceDeletedCurrentLogout =>
      'Huidig apparaat verwijderd. Je bent uitgelogd.';

  @override
  String get thisDevice => 'Dit apparaat';
}
