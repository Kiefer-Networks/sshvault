// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Gazde';

  @override
  String get navSnippets => 'Fragmente';

  @override
  String get navFolders => 'Foldere';

  @override
  String get navTags => 'Etichete';

  @override
  String get navSshKeys => 'Chei SSH';

  @override
  String get navExportImport => 'Export / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Mai mult';

  @override
  String get navManagement => 'Administrare';

  @override
  String get navSettings => 'Setari';

  @override
  String get navAbout => 'Despre';

  @override
  String get lockScreenTitle => 'SSHVault este blocat';

  @override
  String get lockScreenUnlock => 'Deblocare';

  @override
  String get lockScreenEnterPin => 'Introduceti PIN-ul';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Prea multe incercari esuate. Reincercati in $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Setare cod PIN';

  @override
  String get pinDialogSetSubtitle =>
      'Introduceti un PIN de 6 cifre pentru a proteja SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Confirmare PIN';

  @override
  String get pinDialogErrorLength => 'PIN-ul trebuie sa aiba exact 6 cifre';

  @override
  String get pinDialogErrorMismatch => 'Codurile PIN nu corespund';

  @override
  String get pinDialogVerifyTitle => 'Introduceti PIN-ul';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN gresit. $attempts incercari ramase.';
  }

  @override
  String get securityBannerMessage =>
      'Datele SSH nu sunt protejate. Configurati un PIN sau blocarea biometrica in Setari.';

  @override
  String get securityBannerDismiss => 'Respinge';

  @override
  String get settingsTitle => 'Setari';

  @override
  String get settingsSectionAppearance => 'Aspect';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'Setari implicite SSH';

  @override
  String get settingsSectionSecurity => 'Securitate';

  @override
  String get settingsSectionExport => 'Export';

  @override
  String get settingsSectionAbout => 'Despre';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get settingsThemeLight => 'Deschis';

  @override
  String get settingsThemeDark => 'Inchis';

  @override
  String get settingsTerminalTheme => 'Tema terminal';

  @override
  String get settingsTerminalThemeDefault => 'Inchis implicit';

  @override
  String get settingsFontSize => 'Dimensiune font';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Port implicit';

  @override
  String get settingsDefaultPortDialog => 'Port SSH implicit';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Nume utilizator implicit';

  @override
  String get settingsDefaultUsernameDialog => 'Nume utilizator implicit';

  @override
  String get settingsUsernameLabel => 'Nume utilizator';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Blocare automata';

  @override
  String get settingsAutoLockDisabled => 'Dezactivat';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minute';
  }

  @override
  String get settingsAutoLockOff => 'Oprit';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Deblocare biometrica';

  @override
  String get settingsBiometricNotAvailable =>
      'Indisponibil pe acest dispozitiv';

  @override
  String get settingsBiometricError => 'Eroare la verificarea biometriei';

  @override
  String get settingsBiometricReason =>
      'Verificati-va identitatea pentru a activa deblocarea biometrica';

  @override
  String get settingsBiometricRequiresPin =>
      'Setati mai intai un PIN pentru a activa deblocarea biometrica';

  @override
  String get settingsPinCode => 'Cod PIN';

  @override
  String get settingsPinIsSet => 'PIN-ul este setat';

  @override
  String get settingsPinNotConfigured => 'Niciun PIN configurat';

  @override
  String get settingsPinRemove => 'Eliminare';

  @override
  String get settingsPinRemoveWarning =>
      'Eliminarea PIN-ului va decripta toate campurile bazei de date si va dezactiva deblocarea biometrica. Continuati?';

  @override
  String get settingsPinRemoveTitle => 'Eliminare PIN';

  @override
  String get settingsPreventScreenshots => 'Prevenire capturi de ecran';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Blocati capturile de ecran si inregistrarea ecranului';

  @override
  String get settingsEncryptExport => 'Criptare exporturi implicit';

  @override
  String get settingsAbout => 'Despre SSHVault';

  @override
  String get settingsAboutLegalese => 'de Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Client SSH securizat, auto-gazduit';

  @override
  String get settingsLanguage => 'Limba';

  @override
  String get settingsLanguageSystem => 'Sistem';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsLanguageDe => 'Deutsch';

  @override
  String get settingsLanguageEs => 'Espanol';

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
  String get cancel => 'Anulare';

  @override
  String get save => 'Salvare';

  @override
  String get delete => 'Stergere';

  @override
  String get close => 'Inchidere';

  @override
  String get update => 'Actualizare';

  @override
  String get create => 'Creare';

  @override
  String get retry => 'Reincercare';

  @override
  String get copy => 'Copiere';

  @override
  String get edit => 'Editare';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Eroare: $message';
  }

  @override
  String get serverListTitle => 'Gazde';

  @override
  String get serverListEmpty => 'Niciun server inca';

  @override
  String get serverListEmptySubtitle =>
      'Adaugati primul server SSH pentru a incepe.';

  @override
  String get serverAddButton => 'Adaugare server';

  @override
  String sshConfigImportMessage(int count) {
    return '$count gazda(e) gasite in ~/.ssh/config. Le importati?';
  }

  @override
  String get sshConfigNotFound => 'Fisierul de configurare SSH nu a fost gasit';

  @override
  String get sshConfigEmpty => 'Nicio gazda gasita in configurarea SSH';

  @override
  String get sshConfigAddManually => 'Adaugare manuala';

  @override
  String get sshConfigImportAgain => 'Importati din nou configuratia SSH?';

  @override
  String get sshConfigImportKeys =>
      'Importati cheile SSH referite de gazdele selectate?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count cheie(i) SSH importate';
  }

  @override
  String get serverDuplicated => 'Server duplicat';

  @override
  String get serverDeleteTitle => 'Stergere server';

  @override
  String serverDeleteMessage(String name) {
    return 'Sunteti sigur ca doriti sa stergeti \"$name\"? Aceasta actiune nu poate fi anulata.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Stergeti \"$name\"?';
  }

  @override
  String get serverConnect => 'Conectare';

  @override
  String get serverDetails => 'Detalii';

  @override
  String get serverDuplicate => 'Duplicare';

  @override
  String get serverActive => 'Activ';

  @override
  String get serverNoFolder => 'Fara folder';

  @override
  String get serverFormTitleEdit => 'Editare server';

  @override
  String get serverFormTitleAdd => 'Adaugare server';

  @override
  String get serverSaved => 'Server saved successfully';

  @override
  String get serverFormUpdateButton => 'Actualizare server';

  @override
  String get serverFormAddButton => 'Adaugare server';

  @override
  String get serverFormPublicKeyExtracted => 'Cheie publica extrasa cu succes';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Nu s-a putut extrage cheia publica: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Pereche de chei $type generata';
  }

  @override
  String get serverDetailTitle => 'Detalii server';

  @override
  String get serverDetailDeleteMessage =>
      'Aceasta actiune nu poate fi anulata.';

  @override
  String get serverDetailConnection => 'Conexiune';

  @override
  String get serverDetailHost => 'Gazda';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Nume utilizator';

  @override
  String get serverDetailFolder => 'Folder';

  @override
  String get serverDetailTags => 'Etichete';

  @override
  String get serverDetailNotes => 'Note';

  @override
  String get serverDetailInfo => 'Informatii';

  @override
  String get serverDetailCreated => 'Creat';

  @override
  String get serverDetailUpdated => 'Actualizat';

  @override
  String get serverDetailDistro => 'Sistem';

  @override
  String get copiedToClipboard => 'Copiat in clipboard';

  @override
  String get serverFormNameLabel => 'Nume server';

  @override
  String get serverFormHostnameLabel => 'Nume gazda / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Nume utilizator';

  @override
  String get serverFormPasswordLabel => 'Parola';

  @override
  String get serverFormUseManagedKey => 'Utilizare cheie gestionata';

  @override
  String get serverFormManagedKeySubtitle =>
      'Selectati din cheile SSH gestionate central';

  @override
  String get serverFormDirectKeySubtitle =>
      'Lipiti cheia direct in acest server';

  @override
  String get serverFormGenerateKey => 'Generare pereche de chei SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Cheie privata';

  @override
  String get serverFormPrivateKeyHint => 'Lipiti cheia privata SSH...';

  @override
  String get serverFormExtractPublicKey => 'Extragere cheie publica';

  @override
  String get serverFormPublicKeyLabel => 'Cheie publica';

  @override
  String get serverFormPublicKeyHint =>
      'Generata automat din cheia privata daca este goala';

  @override
  String get serverFormPassphraseLabel =>
      'Fraza de acces pentru cheie (optional)';

  @override
  String get serverFormNotesLabel => 'Note (optional)';

  @override
  String get searchServers => 'Cautare servere...';

  @override
  String get filterAllFolders => 'Toate folderele';

  @override
  String get filterAll => 'Toate';

  @override
  String get filterActive => 'Active';

  @override
  String get filterInactive => 'Inactive';

  @override
  String get filterClear => 'Stergere';

  @override
  String get folderListTitle => 'Foldere';

  @override
  String get folderListEmpty => 'Niciun folder inca';

  @override
  String get folderListEmptySubtitle =>
      'Creati foldere pentru a organiza serverele.';

  @override
  String get folderAddButton => 'Adaugare folder';

  @override
  String get folderDeleteTitle => 'Stergere folder';

  @override
  String folderDeleteMessage(String name) {
    return 'Stergeti \"$name\"? Serverele vor ramane neorganizate.';
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
  String get folderCollapse => 'Restranger';

  @override
  String get folderShowHosts => 'Afisare gazde';

  @override
  String get folderConnectAll => 'Conectare la toate';

  @override
  String get folderFormTitleEdit => 'Editare folder';

  @override
  String get folderFormTitleNew => 'Folder nou';

  @override
  String get folderFormNameLabel => 'Nume folder';

  @override
  String get folderFormParentLabel => 'Folder parinte';

  @override
  String get folderFormParentNone => 'Niciuna (Radacina)';

  @override
  String get tagListTitle => 'Etichete';

  @override
  String get tagListEmpty => 'Nicio eticheta inca';

  @override
  String get tagListEmptySubtitle =>
      'Creati etichete pentru a marca si filtra serverele.';

  @override
  String get tagAddButton => 'Adaugare eticheta';

  @override
  String get tagDeleteTitle => 'Stergere eticheta';

  @override
  String tagDeleteMessage(String name) {
    return 'Stergeti \"$name\"? Va fi eliminata de la toate serverele.';
  }

  @override
  String get tagFormTitleEdit => 'Editare eticheta';

  @override
  String get tagFormTitleNew => 'Eticheta noua';

  @override
  String get tagFormNameLabel => 'Nume eticheta';

  @override
  String get sshKeyListTitle => 'Chei SSH';

  @override
  String get sshKeyListEmpty => 'Nicio cheie SSH inca';

  @override
  String get sshKeyListEmptySubtitle =>
      'Generati sau importati chei SSH pentru a le gestiona central';

  @override
  String get sshKeyCannotDeleteTitle => 'Nu se poate sterge';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Nu se poate sterge \"$name\". Utilizata de $count server(e). Dezlegati mai intai de toate serverele.';
  }

  @override
  String get sshKeyDeleteTitle => 'Stergere cheie SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Stergeti \"$name\"? Aceasta actiune nu poate fi anulata.';
  }

  @override
  String get sshKeyAddButton => 'Adaugare cheie SSH';

  @override
  String get sshKeyFormTitleEdit => 'Editare cheie SSH';

  @override
  String get sshKeyFormTitleAdd => 'Adaugare cheie SSH';

  @override
  String get sshKeyFormTabGenerate => 'Generare';

  @override
  String get sshKeyFormTabImport => 'Import';

  @override
  String get sshKeyFormNameLabel => 'Nume cheie';

  @override
  String get sshKeyFormNameHint => 'ex. Cheia mea de productie';

  @override
  String get sshKeyFormKeyType => 'Tip cheie';

  @override
  String get sshKeyFormKeySize => 'Dimensiune cheie';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Comentariu';

  @override
  String get sshKeyFormCommentHint => 'utilizator@gazda sau descriere';

  @override
  String get sshKeyFormCommentOptional => 'Comentariu (optional)';

  @override
  String get sshKeyFormImportFromFile => 'Import din fisier';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Cheie privata';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Lipiti cheia privata SSH sau folositi butonul de mai sus...';

  @override
  String get sshKeyFormPassphraseLabel => 'Fraza de acces (optional)';

  @override
  String get sshKeyFormNameRequired => 'Numele este obligatoriu';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Cheia privata este obligatorie';

  @override
  String get sshKeyFormFileReadError => 'Fisierul selectat nu a putut fi citit';

  @override
  String get sshKeyFormInvalidFormat =>
      'Format cheie invalid — se asteapta format PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Eroare la citirea fisierului: $message';
  }

  @override
  String get sshKeyFormSaving => 'Se salveaza...';

  @override
  String get sshKeySelectorLabel => 'Cheie SSH';

  @override
  String get sshKeySelectorNone => 'Nicio cheie gestionata';

  @override
  String get sshKeySelectorManage => 'Gestionare chei...';

  @override
  String get sshKeySelectorError => 'Eroare la incarcarea cheilor SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Copiere cheie publica';

  @override
  String get sshKeyTilePublicKeyCopied => 'Cheie publica copiata';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Utilizata de $count server(e)';
  }

  @override
  String get sshKeySavedSuccess => 'SSH key saved';

  @override
  String get sshKeyDeletedSuccess => 'SSH key deleted';

  @override
  String get tagSavedSuccess => 'Tag saved';

  @override
  String get tagDeletedSuccess => 'Tag deleted';

  @override
  String get folderDeletedSuccess => 'Folder deleted';

  @override
  String get sshKeyTileUnlinkFirst => 'Dezlegati mai intai de toate serverele';

  @override
  String get exportImportTitle => 'Export / Import';

  @override
  String get exportSectionTitle => 'Export';

  @override
  String get exportJsonButton => 'Export ca JSON (fara credentiale)';

  @override
  String get exportZipButton => 'Export ZIP criptat (cu credentiale)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Import din fisier';

  @override
  String get importSupportedFormats =>
      'Suporta fisiere JSON (necriptate) si ZIP (criptate).';

  @override
  String exportedTo(String path) {
    return 'Exportat in: $path';
  }

  @override
  String get share => 'Partajare';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Importate $servers servere, $groups grupuri, $tags etichete. $skipped omise.';
  }

  @override
  String get importPasswordTitle => 'Introduceti parola';

  @override
  String get importPasswordLabel => 'Parola export';

  @override
  String get importPasswordDecrypt => 'Decriptare';

  @override
  String get exportPasswordTitle => 'Setare parola export';

  @override
  String get exportPasswordDescription =>
      'Aceasta parola va fi folosita pentru a cripta fisierul de export, inclusiv credentialele.';

  @override
  String get exportPasswordLabel => 'Parola';

  @override
  String get exportPasswordConfirmLabel => 'Confirmare parola';

  @override
  String get exportPasswordMismatch => 'Parolele nu corespund';

  @override
  String get exportPasswordButton => 'Criptare si export';

  @override
  String get importConflictTitle => 'Gestionare conflicte';

  @override
  String get importConflictDescription =>
      'Cum ar trebui gestionate intrarile existente la import?';

  @override
  String get importConflictSkip => 'Omitere existente';

  @override
  String get importConflictRename => 'Redenumire noi';

  @override
  String get importConflictOverwrite => 'Suprascriere';

  @override
  String get confirmDeleteLabel => 'Stergere';

  @override
  String get keyGenTitle => 'Generare pereche de chei SSH';

  @override
  String get keyGenKeyType => 'Tip cheie';

  @override
  String get keyGenKeySize => 'Dimensiune cheie';

  @override
  String get keyGenComment => 'Comentariu';

  @override
  String get keyGenCommentHint => 'utilizator@gazda sau descriere';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Se genereaza...';

  @override
  String get keyGenGenerate => 'Generare';

  @override
  String keyGenResultTitle(String type) {
    return 'Cheie $type generata';
  }

  @override
  String get keyGenPublicKey => 'Cheie publica';

  @override
  String get keyGenPrivateKey => 'Cheie privata';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Comentariu: $comment';
  }

  @override
  String get keyGenAnother => 'Generare alta';

  @override
  String get keyGenUseThisKey => 'Utilizare aceasta cheie';

  @override
  String get keyGenCopyTooltip => 'Copiere in clipboard';

  @override
  String keyGenCopied(String label) {
    return '$label copiat';
  }

  @override
  String get colorPickerLabel => 'Culoare';

  @override
  String get iconPickerLabel => 'Pictograma';

  @override
  String get tagSelectorLabel => 'Etichete';

  @override
  String get tagSelectorEmpty => 'Nicio eticheta inca';

  @override
  String get tagSelectorError => 'Eroare la incarcarea etichetelor';

  @override
  String get snippetListTitle => 'Fragmente';

  @override
  String get snippetSearchHint => 'Cautare fragmente...';

  @override
  String get snippetListEmpty => 'Niciun fragment inca';

  @override
  String get snippetListEmptySubtitle =>
      'Creati fragmente de cod si comenzi reutilizabile.';

  @override
  String get snippetAddButton => 'Adaugare fragment';

  @override
  String get snippetDeleteTitle => 'Stergere fragment';

  @override
  String snippetDeleteMessage(String name) {
    return 'Stergeti \"$name\"? Aceasta actiune nu poate fi anulata.';
  }

  @override
  String get snippetFormTitleEdit => 'Editare fragment';

  @override
  String get snippetFormTitleNew => 'Fragment nou';

  @override
  String get snippetFormNameLabel => 'Nume';

  @override
  String get snippetFormNameHint => 'ex. Curatare Docker';

  @override
  String get snippetFormLanguageLabel => 'Limbaj';

  @override
  String get snippetFormContentLabel => 'Continut';

  @override
  String get snippetFormContentHint => 'Introduceti codul fragmentului...';

  @override
  String get snippetFormDescriptionLabel => 'Descriere';

  @override
  String get snippetFormDescriptionHint => 'Descriere optionala...';

  @override
  String get snippetFormFolderLabel => 'Folder';

  @override
  String get snippetFormNoFolder => 'Fara folder';

  @override
  String get snippetFormNameRequired => 'Numele este obligatoriu';

  @override
  String get snippetFormContentRequired => 'Continutul este obligatoriu';

  @override
  String get snippetFormSaved => 'Snippet salvat';

  @override
  String get snippetFormUpdateButton => 'Actualizare fragment';

  @override
  String get snippetFormCreateButton => 'Creare fragment';

  @override
  String get snippetDetailTitle => 'Detalii fragment';

  @override
  String get snippetDetailDeleteTitle => 'Stergere fragment';

  @override
  String get snippetDetailDeleteMessage =>
      'Aceasta actiune nu poate fi anulata.';

  @override
  String get snippetDetailContent => 'Continut';

  @override
  String get snippetDetailFillVariables => 'Completare variabile';

  @override
  String get snippetDetailDescription => 'Descriere';

  @override
  String get snippetDetailVariables => 'Variabile';

  @override
  String get snippetDetailTags => 'Etichete';

  @override
  String get snippetDetailInfo => 'Informatii';

  @override
  String get snippetDetailCreated => 'Creat';

  @override
  String get snippetDetailUpdated => 'Actualizat';

  @override
  String get variableEditorTitle => 'Variabile sablon';

  @override
  String get variableEditorAdd => 'Adaugare';

  @override
  String get variableEditorEmpty =>
      'Nicio variabila. Folositi sintaxa cu acolade in continut pentru a le referi.';

  @override
  String get variableEditorNameLabel => 'Nume';

  @override
  String get variableEditorNameHint => 'ex. numegzda';

  @override
  String get variableEditorDefaultLabel => 'Implicit';

  @override
  String get variableEditorDefaultHint => 'optional';

  @override
  String get variableFillTitle => 'Completare variabile';

  @override
  String variableFillHint(String name) {
    return 'Introduceti valoarea pentru $name';
  }

  @override
  String get variableFillPreview => 'Previzualizare';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Nicio sesiune activa';

  @override
  String get terminalEmptySubtitle =>
      'Conectati-va la o gazda pentru a deschide o sesiune de terminal.';

  @override
  String get terminalGoToHosts => 'Mergi la Gazde';

  @override
  String get terminalCloseAll => 'Inchidere toate sesiunile';

  @override
  String get terminalCloseTitle => 'Inchidere sesiune';

  @override
  String terminalCloseMessage(String title) {
    return 'Inchideti conexiunea activa la \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Se autentifica...';

  @override
  String connectionConnecting(String name) {
    return 'Conectare la $name...';
  }

  @override
  String get connectionError => 'Eroare de conexiune';

  @override
  String get connectionLost => 'Conexiune pierduta';

  @override
  String get connectionReconnect => 'Reconectare';

  @override
  String get snippetQuickPanelTitle => 'Inserare fragment';

  @override
  String get snippetQuickPanelSearch => 'Cautare fragmente...';

  @override
  String get snippetQuickPanelEmpty => 'Niciun fragment disponibil';

  @override
  String get snippetQuickPanelNoMatch => 'Niciun fragment corespunzator';

  @override
  String get snippetQuickPanelInsertTooltip => 'Inserare fragment';

  @override
  String get terminalThemePickerTitle => 'Tema terminal';

  @override
  String get validatorHostnameRequired => 'Numele gazdei este obligatoriu';

  @override
  String get validatorHostnameInvalid => 'Nume de gazda sau adresa IP invalida';

  @override
  String get validatorPortRequired => 'Portul este obligatoriu';

  @override
  String get validatorPortRange => 'Portul trebuie sa fie intre 1 si 65535';

  @override
  String get validatorUsernameRequired =>
      'Numele de utilizator este obligatoriu';

  @override
  String get validatorUsernameInvalid => 'Format nume de utilizator invalid';

  @override
  String get validatorServerNameRequired =>
      'Numele serverului este obligatoriu';

  @override
  String get validatorServerNameLength =>
      'Numele serverului trebuie sa aiba maxim 100 de caractere';

  @override
  String get validatorSshKeyInvalid => 'Format cheie SSH invalid';

  @override
  String get validatorPasswordRequired => 'Parola este obligatorie';

  @override
  String get validatorPasswordLength =>
      'Parola trebuie sa aiba cel putin 8 caractere';

  @override
  String get authMethodPassword => 'Parola';

  @override
  String get authMethodKey => 'Cheie SSH';

  @override
  String get authMethodBoth => 'Parola + Cheie';

  @override
  String get serverCopySuffix => '(Copie)';

  @override
  String get settingsDownloadLogs => 'Descarcare jurnale';

  @override
  String get settingsSendLogs => 'Trimitere jurnale catre suport';

  @override
  String get settingsLogsSaved => 'Jurnale salvate cu succes';

  @override
  String get settingsUpdated => 'Setting updated';

  @override
  String get settingsThemeChanged => 'Theme changed';

  @override
  String get settingsLanguageChanged => 'Language changed';

  @override
  String get settingsPinSetSuccess => 'PIN set successfully';

  @override
  String get settingsPinRemovedSuccess => 'PIN removed';

  @override
  String get settingsDuressPinSetSuccess => 'Duress PIN set';

  @override
  String get settingsDuressPinRemovedSuccess => 'Duress PIN removed';

  @override
  String get settingsBiometricEnabled => 'Biometric unlock enabled';

  @override
  String get settingsBiometricDisabled => 'Biometric unlock disabled';

  @override
  String get settingsDnsServerAdded => 'DNS server added';

  @override
  String get settingsDnsServerRemoved => 'DNS server removed';

  @override
  String get settingsDnsResetSuccess => 'DNS servers reset to defaults';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Decrease font size';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Increase font size';

  @override
  String get settingsDnsRemoveServerTooltip => 'Remove server';

  @override
  String get settingsLogsEmpty => 'Nicio intrare in jurnal disponibila';

  @override
  String get authLogin => 'Autentificare';

  @override
  String get authRegister => 'Inregistrare';

  @override
  String get authForgotPassword => 'Ati uitat parola?';

  @override
  String get authWhyLogin =>
      'Conectati-va pentru a activa sincronizarea cloud criptata pe toate dispozitivele. Aplicatia functioneaza complet offline fara cont.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'Adresa de email este obligatorie';

  @override
  String get authEmailInvalid => 'Adresa de email invalida';

  @override
  String get authPasswordLabel => 'Parola';

  @override
  String get authConfirmPasswordLabel => 'Confirmare parola';

  @override
  String get authPasswordMismatch => 'Parolele nu corespund';

  @override
  String get authNoAccount => 'Nu aveti cont?';

  @override
  String get authHasAccount => 'Aveti deja un cont?';

  @override
  String get authResetEmailSent =>
      'Daca exista un cont, un link de resetare a fost trimis pe email.';

  @override
  String get authResetDescription =>
      'Introduceti adresa de email si va vom trimite un link pentru a va reseta parola.';

  @override
  String get authSendResetLink => 'Trimitere link de resetare';

  @override
  String get authBackToLogin => 'Inapoi la autentificare';

  @override
  String get syncPasswordTitle => 'Parola de sincronizare';

  @override
  String get syncPasswordTitleCreate => 'Setare parola de sincronizare';

  @override
  String get syncPasswordTitleEnter => 'Introduceti parola de sincronizare';

  @override
  String get syncPasswordDescription =>
      'Setati o parola separata pentru a cripta datele din seif. Aceasta parola nu paraseste niciodata dispozitivul — serverul stocheaza doar date criptate.';

  @override
  String get syncPasswordHintEnter =>
      'Introduceti parola setata la crearea contului.';

  @override
  String get syncPasswordWarning =>
      'Daca uitati aceasta parola, datele sincronizate nu pot fi recuperate. Nu exista optiune de resetare.';

  @override
  String get syncPasswordLabel => 'Parola de sincronizare';

  @override
  String get syncPasswordWrong => 'Parola gresita. Incercati din nou.';

  @override
  String get firstSyncTitle => 'Date existente gasite';

  @override
  String get firstSyncMessage =>
      'Acest dispozitiv are date existente si serverul are un seif. Cum dorim sa procedam?';

  @override
  String get firstSyncMerge => 'Imbinare (serverul primeaza)';

  @override
  String get firstSyncOverwriteLocal => 'Suprascriere date locale';

  @override
  String get firstSyncKeepLocal => 'Pastrare locale si trimitere';

  @override
  String get firstSyncDeleteLocal => 'Stergere locale si preluare';

  @override
  String get changeEncryptionPassword => 'Schimbare parola de criptare';

  @override
  String get changeEncryptionWarning =>
      'Veti fi deconectat de pe toate celelalte dispozitive.';

  @override
  String get changeEncryptionOldPassword => 'Parola curenta';

  @override
  String get changeEncryptionNewPassword => 'Parola noua';

  @override
  String get changeEncryptionSuccess => 'Parola a fost schimbata cu succes.';

  @override
  String get logoutAllDevices => 'Deconectare de pe toate dispozitivele';

  @override
  String get logoutAllDevicesConfirm =>
      'Aceasta va revoca toate sesiunile active. Va trebui sa va autentificati din nou pe toate dispozitivele.';

  @override
  String get logoutAllDevicesSuccess =>
      'Toate dispozitivele au fost deconectate.';

  @override
  String get syncSettingsTitle => 'Setari sincronizare';

  @override
  String get syncAutoSync => 'Sincronizare automata';

  @override
  String get syncAutoSyncDescription =>
      'Sincronizare automata la pornirea aplicatiei';

  @override
  String get syncNow => 'Sincronizare acum';

  @override
  String get syncSyncing => 'Se sincronizeaza...';

  @override
  String get syncSuccess => 'Sincronizare finalizata';

  @override
  String get syncError => 'Eroare de sincronizare';

  @override
  String get syncServerUnreachable => 'Serverul nu este accesibil';

  @override
  String get syncServerUnreachableHint =>
      'Serverul de sincronizare nu a putut fi contactat. Verificati conexiunea la internet si URL-ul serverului.';

  @override
  String get syncNetworkError =>
      'Conexiunea la server a esuat. Verificati conexiunea la internet sau incercati mai tarziu.';

  @override
  String get syncNeverSynced => 'Niciodata sincronizat';

  @override
  String get syncVaultVersion => 'Versiune seif';

  @override
  String get syncTitle => 'Sincronizare';

  @override
  String get settingsSectionNetwork => 'Retea si DNS';

  @override
  String get settingsDnsServers => 'Servere DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Implicit (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Introduceti URL-uri personalizate de servere DoH, separate prin virgule. Sunt necesare cel putin 2 servere pentru verificarea incrucisata.';

  @override
  String get settingsDnsLabel => 'URL-uri servere DoH';

  @override
  String get settingsDnsReset => 'Resetare la implicit';

  @override
  String get settingsSectionSync => 'Sincronizare';

  @override
  String get settingsSyncAccount => 'Cont';

  @override
  String get settingsSyncNotLoggedIn => 'Neautentificat';

  @override
  String get settingsSyncStatus => 'Sincronizare';

  @override
  String get settingsSyncServerUrl => 'URL server';

  @override
  String get settingsSyncDefaultServer => 'Implicit (sshvault.app)';

  @override
  String get accountTitle => 'Cont';

  @override
  String get accountNotLoggedIn => 'Neautentificat';

  @override
  String get accountVerified => 'Verificat';

  @override
  String get accountMemberSince => 'Membru din';

  @override
  String get accountDevices => 'Dispozitive';

  @override
  String get accountNoDevices => 'Niciun dispozitiv inregistrat';

  @override
  String get accountLastSync => 'Ultima sincronizare';

  @override
  String get accountChangePassword => 'Schimbare parola';

  @override
  String get accountOldPassword => 'Parola curenta';

  @override
  String get accountNewPassword => 'Parola noua';

  @override
  String get accountDeleteAccount => 'Stergere cont';

  @override
  String get accountDeleteWarning =>
      'Aceasta va sterge permanent contul si toate datele sincronizate. Aceasta actiune nu poate fi anulata.';

  @override
  String get accountLogout => 'Deconectare';

  @override
  String get serverConfigTitle => 'Configurare server';

  @override
  String get serverConfigUrlLabel => 'URL server';

  @override
  String get serverConfigTest => 'Testare conexiune';

  @override
  String get serverSetupTitle => 'Configurare server';

  @override
  String get serverSetupInfoCard =>
      'ShellVault necesită un server auto-găzduit pentru sincronizarea criptată end-to-end. Implementați propria instanță pentru a începe.';

  @override
  String get serverSetupRepoLink => 'Vezi pe GitHub';

  @override
  String get serverSetupContinue => 'Continuare';

  @override
  String get settingsServerNotConfigured => 'Niciun server configurat';

  @override
  String get settingsSetupSync =>
      'Configurați sincronizarea pentru a face backup datelor';

  @override
  String get settingsChangeServer => 'Schimbă serverul';

  @override
  String get settingsChangeServerConfirm =>
      'Schimbarea serverului vă va deconecta. Continuați?';

  @override
  String get auditLogTitle => 'Jurnal activitate';

  @override
  String get auditLogAll => 'Toate';

  @override
  String get auditLogEmpty => 'Niciun jurnal de activitate gasit';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Manager fisiere';

  @override
  String get sftpLocalDevice => 'Dispozitiv local';

  @override
  String get sftpSelectServer => 'Selectati serverul...';

  @override
  String get sftpConnecting => 'Conectare...';

  @override
  String get sftpEmptyDirectory => 'Acest director este gol';

  @override
  String get sftpNoConnection => 'Niciun server conectat';

  @override
  String get sftpPathLabel => 'Cale';

  @override
  String get sftpUpload => 'Incarcare';

  @override
  String get sftpDownload => 'Descarcare';

  @override
  String get sftpDelete => 'Stergere';

  @override
  String get sftpRename => 'Redenumire';

  @override
  String get sftpNewFolder => 'Folder nou';

  @override
  String get sftpNewFolderName => 'Nume folder';

  @override
  String get sftpChmod => 'Permisiuni';

  @override
  String get sftpChmodTitle => 'Modificare permisiuni';

  @override
  String get sftpChmodOctal => 'Octal';

  @override
  String get sftpChmodOwner => 'Proprietar';

  @override
  String get sftpChmodGroup => 'Grup';

  @override
  String get sftpChmodOther => 'Altii';

  @override
  String get sftpChmodRead => 'Citire';

  @override
  String get sftpChmodWrite => 'Scriere';

  @override
  String get sftpChmodExecute => 'Executare';

  @override
  String get sftpCreateSymlink => 'Creare Symlink';

  @override
  String get sftpSymlinkTarget => 'Cale tinta';

  @override
  String get sftpSymlinkName => 'Nume link';

  @override
  String get sftpFilePreview => 'Previzualizare fisier';

  @override
  String get sftpFileInfo => 'Informatii fisier';

  @override
  String get sftpFileSize => 'Dimensiune';

  @override
  String get sftpFileModified => 'Modificat';

  @override
  String get sftpFilePermissions => 'Permisiuni';

  @override
  String get sftpFileOwner => 'Proprietar';

  @override
  String get sftpFileType => 'Tip';

  @override
  String get sftpFileLinkTarget => 'Tinta link';

  @override
  String get sftpTransfers => 'Transferuri';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current din $total';
  }

  @override
  String get sftpTransferQueued => 'In asteptare';

  @override
  String get sftpTransferActive => 'Se transfera...';

  @override
  String get sftpTransferPaused => 'In pauza';

  @override
  String get sftpTransferCompleted => 'Finalizat';

  @override
  String get sftpTransferFailed => 'Esuat';

  @override
  String get sftpTransferCancelled => 'Anulat';

  @override
  String get sftpPauseTransfer => 'Pauza';

  @override
  String get sftpResumeTransfer => 'Reluare';

  @override
  String get sftpCancelTransfer => 'Anulare';

  @override
  String get sftpClearCompleted => 'Stergere finalizate';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active din $total transferuri';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active',
      one: '1 activ',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count finalizate',
      one: '1 finalizat',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count esuat',
      one: '1 esuat',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Copiere in celalalt panou';

  @override
  String sftpConfirmDelete(int count) {
    return 'Stergeti $count elemente?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Stergeti \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Sters cu succes';

  @override
  String get sftpRenameTitle => 'Redenumire';

  @override
  String get sftpRenameLabel => 'Nume nou';

  @override
  String get sftpSortByName => 'Nume';

  @override
  String get sftpSortBySize => 'Dimensiune';

  @override
  String get sftpSortByDate => 'Data';

  @override
  String get sftpSortByType => 'Tip';

  @override
  String get sftpShowHidden => 'Afisare fisiere ascunse';

  @override
  String get sftpHideHidden => 'Ascundere fisiere ascunse';

  @override
  String get sftpSelectAll => 'Selectare tot';

  @override
  String get sftpDeselectAll => 'Deselectare tot';

  @override
  String sftpItemsSelected(int count) {
    return '$count selectate';
  }

  @override
  String get sftpRefresh => 'Reimprospatare';

  @override
  String sftpConnectionError(String message) {
    return 'Conexiune esuata: $message';
  }

  @override
  String get sftpPermissionDenied => 'Acces refuzat';

  @override
  String sftpOperationFailed(String message) {
    return 'Operatiune esuata: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Fisierul exista deja';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" exista deja. Suprascriere?';
  }

  @override
  String get sftpOverwrite => 'Suprascriere';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Transfer inceput: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Selectati mai intai o destinatie in celalalt panou';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Transferul de directoare va fi disponibil in curand';

  @override
  String get sftpSelect => 'Selectare';

  @override
  String get sftpOpen => 'Deschidere';

  @override
  String get sftpExtractArchive => 'Extragere aici';

  @override
  String get sftpExtractSuccess => 'Arhiva extrasa';

  @override
  String sftpExtractFailed(String message) {
    return 'Extragere esuata: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Format de arhiva nesuportat';

  @override
  String get sftpExtracting => 'Se extrage...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count incarcari incepute',
      one: 'Incarcare inceputa',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descarcari incepute',
      one: 'Descarcare inceputa',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" descarcat';
  }

  @override
  String get sftpSavedToDownloads => 'Salvat in Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Salvare in Fisiere';

  @override
  String get sftpFileSaved => 'Fisier salvat';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiuni SSH active',
      one: 'Sesiune SSH activa',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Atingeti pentru a deschide terminalul';

  @override
  String get settingsAccountAndSync => 'Cont si sincronizare';

  @override
  String get settingsAccountSubtitleAuth => 'Autentificat';

  @override
  String get settingsAccountSubtitleUnauth => 'Neautentificat';

  @override
  String get settingsSecuritySubtitle => 'Blocare automata, Biometrie, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Utilizator root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, Limba, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Setari implicite export criptat';

  @override
  String get settingsAboutSubtitle => 'Versiune, Licente';

  @override
  String get settingsSearchHint => 'Cautare setari...';

  @override
  String get settingsSearchNoResults => 'Nicio setare gasita';

  @override
  String get aboutDeveloper => 'Dezvoltat de Kiefer Networks';

  @override
  String get aboutDonate => 'Donati';

  @override
  String get aboutOpenSourceLicenses => 'Licente Open Source';

  @override
  String get aboutWebsite => 'Website';

  @override
  String get aboutVersion => 'Versiune';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS cripteaza interogari DNS si previne falsificarea DNS. SSHVault verifica numele de gazda cu mai multi furnizori pentru a detecta atacuri.';

  @override
  String get settingsDnsAddServer => 'Adaugare server DNS';

  @override
  String get settingsDnsServerUrl => 'URL server';

  @override
  String get settingsDnsDefaultBadge => 'Implicit';

  @override
  String get settingsDnsResetDefaults => 'Resetare la implicit';

  @override
  String get settingsDnsInvalidUrl => 'Introduceti un URL HTTPS valid';

  @override
  String get settingsDefaultAuthMethod => 'Metoda de autentificare';

  @override
  String get settingsAuthPassword => 'Parola';

  @override
  String get settingsAuthKey => 'Cheie SSH';

  @override
  String get settingsConnectionTimeout => 'Timeout conexiune';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Interval Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Compresie';

  @override
  String get settingsCompressionDescription =>
      'Activare compresie zlib pentru conexiunile SSH';

  @override
  String get settingsTerminalType => 'Tip terminal';

  @override
  String get settingsSectionConnection => 'Conexiune';

  @override
  String get settingsClipboardAutoClear => 'Stergere automata clipboard';

  @override
  String get settingsClipboardAutoClearOff => 'Oprit';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Timeout sesiune';

  @override
  String get settingsSessionTimeoutOff => 'Oprit';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'PIN de constrangere';

  @override
  String get settingsDuressPinDescription =>
      'Un PIN separat care sterge toate datele cand este introdus';

  @override
  String get settingsDuressPinSet => 'PIN-ul de constrangere este setat';

  @override
  String get settingsDuressPinNotSet => 'Neconfigurat';

  @override
  String get settingsDuressPinWarning =>
      'Introducerea acestui PIN va sterge permanent toate datele locale, inclusiv credentialele, cheile si setarile. Aceasta actiune nu poate fi anulata.';

  @override
  String get settingsKeyRotationReminder => 'Memento rotatie chei';

  @override
  String get settingsKeyRotationOff => 'Oprit';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days zile';
  }

  @override
  String get settingsFailedAttempts => 'Incercari PIN esuate';

  @override
  String get settingsSectionAppLock => 'Blocare aplicatie';

  @override
  String get settingsSectionPrivacy => 'Confidentialitate';

  @override
  String get settingsSectionReminders => 'Memento-uri';

  @override
  String get settingsSectionStatus => 'Stare';

  @override
  String get settingsExportBackupSubtitle => 'Export, Import si Backup';

  @override
  String get settingsExportJson => 'Export ca JSON';

  @override
  String get settingsExportEncrypted => 'Export criptat';

  @override
  String get settingsImportFile => 'Import din fisier';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Filtrare servere';

  @override
  String get filterApply => 'Aplicare filtre';

  @override
  String get filterClearAll => 'Stergere toate';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtre active',
      one: '1 filtru activ',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Folder';

  @override
  String get filterTags => 'Etichete';

  @override
  String get filterStatus => 'Stare';

  @override
  String get variablePreviewResolved => 'Previzualizare rezolvata';

  @override
  String get variableInsert => 'Inserare';

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
      other: '$count sesiuni revocate.',
      one: '1 sesiune revocata.',
    );
    return '$_temp0 Ati fost deconectat.';
  }

  @override
  String get keyGenPassphrase => 'Fraza de acces';

  @override
  String get keyGenPassphraseHint => 'Optional — protejeaza cheia privata';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Implicit (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'O cheie cu aceeasi amprenta exista deja: \"$name\". Fiecare cheie SSH trebuie sa fie unica.';
  }

  @override
  String get sshKeyFingerprint => 'Amprenta';

  @override
  String get sshKeyPublicKey => 'Cheie publica';

  @override
  String get jumpHost => 'Gazda intermediara';

  @override
  String get jumpHostNone => 'Niciuna';

  @override
  String get jumpHostLabel => 'Conectare prin gazda intermediara';

  @override
  String get jumpHostSelfError =>
      'Un server nu poate fi propria gazda intermediara';

  @override
  String get jumpHostConnecting => 'Conectare la gazda intermediara...';

  @override
  String get jumpHostCircularError =>
      'Lant circular de gazde intermediare detectat';

  @override
  String get logoutDialogTitle => 'Deconectare';

  @override
  String get logoutDialogMessage =>
      'Doriti sa stergeti toate datele locale? Serverele, cheile SSH, fragmentele si setarile vor fi eliminate de pe acest dispozitiv.';

  @override
  String get logoutOnly => 'Doar deconectare';

  @override
  String get logoutAndDelete => 'Deconectare si stergere date';

  @override
  String get changeAvatar => 'Schimbare avatar';

  @override
  String get removeAvatar => 'Eliminare avatar';

  @override
  String get avatarUploadFailed => 'Incarcarea avatarului a esuat';

  @override
  String get avatarTooLarge => 'Imaginea este prea mare';

  @override
  String get deviceLastSeen => 'Ultima activitate';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'URL-ul serverului nu poate fi schimbat cat timp sunteti autentificat. Deconectati-va mai intai.';

  @override
  String get serverListNoFolder => 'Necategorizat';

  @override
  String get autoSyncInterval => 'Interval sincronizare';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Setari proxy';

  @override
  String get proxyType => 'Tip proxy';

  @override
  String get proxyNone => 'Fara proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Gazda proxy';

  @override
  String get proxyPort => 'Port proxy';

  @override
  String get proxyUsername => 'Utilizator proxy';

  @override
  String get proxyPassword => 'Parola proxy';

  @override
  String get proxyUseGlobal => 'Utilizare proxy global';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Specific serverului';

  @override
  String get proxyTestConnection => 'Testare conexiune';

  @override
  String get proxyTestSuccess => 'Proxy accesibil';

  @override
  String get proxyTestFailed => 'Proxy inaccesibil';

  @override
  String get proxyDefaultProxy => 'Proxy implicit';

  @override
  String get vpnRequired => 'VPN necesar';

  @override
  String get vpnRequiredTooltip =>
      'Afisare avertisment la conectare fara VPN activ';

  @override
  String get vpnActive => 'VPN activ';

  @override
  String get vpnInactive => 'VPN inactiv';

  @override
  String get vpnWarningTitle => 'VPN inactiv';

  @override
  String get vpnWarningMessage =>
      'Acest server necesita o conexiune VPN, dar niciun VPN nu este activ in prezent. Doriti sa va conectati oricum?';

  @override
  String get vpnConnectAnyway => 'Conectare oricum';

  @override
  String get postConnectCommands => 'Comenzi post-conectare';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Comenzi executate automat dupa conectare (una pe linie)';

  @override
  String get dashboardFavorites => 'Favorite';

  @override
  String get dashboardRecent => 'Recente';

  @override
  String get dashboardActiveSessions => 'Sesiuni active';

  @override
  String get addToFavorites => 'Adaugare la favorite';

  @override
  String get removeFromFavorites => 'Eliminare din favorite';

  @override
  String get noRecentConnections => 'Nicio conexiune recenta';

  @override
  String get terminalSplit => 'Vizualizare impartita';

  @override
  String get terminalUnsplit => 'Inchidere impartire';

  @override
  String get terminalSelectSession =>
      'Selectati sesiunea pentru vizualizare impartita';

  @override
  String get knownHostsTitle => 'Gazde cunoscute';

  @override
  String get knownHostsSubtitle => 'Gestionare amprente servere de incredere';

  @override
  String get hostKeyNewTitle => 'Gazda noua';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Prima conexiune la $hostname:$port. Verificati amprenta inainte de conectare.';
  }

  @override
  String get hostKeyChangedTitle => 'Cheia gazdei s-a schimbat!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Cheia gazdei pentru $hostname:$port s-a schimbat. Aceasta ar putea indica o amenintare de securitate.';
  }

  @override
  String get hostKeyFingerprint => 'Amprenta';

  @override
  String get hostKeyType => 'Tip cheie';

  @override
  String get hostKeyTrustConnect => 'Incredere si conectare';

  @override
  String get hostKeyAcceptNew => 'Acceptare cheie noua';

  @override
  String get hostKeyReject => 'Respingere';

  @override
  String get hostKeyPreviousFingerprint => 'Amprenta anterioara';

  @override
  String get hostKeyDeleteAll => 'Stergere toate gazdele cunoscute';

  @override
  String get hostKeyDeleteConfirm =>
      'Sunteti sigur ca doriti sa eliminati toate gazdele cunoscute? Veti fi intrebat din nou la urmatoarea conexiune.';

  @override
  String get hostKeyEmpty => 'Nicio gazda cunoscuta inca';

  @override
  String get hostKeyEmptySubtitle =>
      'Amprentele gazdelor vor fi stocate aici dupa prima conexiune';

  @override
  String get hostKeyFirstSeen => 'Prima aparitie';

  @override
  String get hostKeyLastSeen => 'Ultima aparitie';

  @override
  String get sshConfigImportTitle => 'Import configuratie SSH';

  @override
  String get sshConfigImportPickFile => 'Selectare fisier de configurare SSH';

  @override
  String get sshConfigImportOrPaste => 'Sau lipiti continutul configuratiei';

  @override
  String sshConfigImportParsed(int count) {
    return '$count gazde gasite';
  }

  @override
  String get sshConfigImportButton => 'Import';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count server(e) importate';
  }

  @override
  String get sshConfigImportDuplicate => 'Exista deja';

  @override
  String get sshConfigImportNoHosts => 'Nicio gazda gasita in configuratie';

  @override
  String get sftpBookmarkAdd => 'Adaugare semn de carte';

  @override
  String get sftpBookmarkLabel => 'Eticheta';

  @override
  String get disconnect => 'Deconectare';

  @override
  String get reportAndDisconnect => 'Raportare si deconectare';

  @override
  String get continueAnyway => 'Continuare oricum';

  @override
  String get insertSnippet => 'Inserare fragment';

  @override
  String get seconds => 'Secunde';

  @override
  String get heartbeatLostMessage =>
      'Serverul nu a putut fi contactat dupa mai multe incercari. Pentru securitatea dumneavoastra, sesiunea a fost inchisa.';

  @override
  String get attestationFailedTitle => 'Verificarea serverului a esuat';

  @override
  String get attestationFailedMessage =>
      'Serverul nu a putut fi verificat ca backend SSHVault legitim. Aceasta poate indica un atac man-in-the-middle sau un server configurat gresit.';

  @override
  String get attestationKeyChangedTitle =>
      'Cheia de atestare a serverului s-a schimbat';

  @override
  String get attestationKeyChangedMessage =>
      'Cheia de atestare a serverului s-a schimbat de la conexiunea initiala. Aceasta poate indica un atac man-in-the-middle. NU continuati decat daca administratorul serverului a confirmat o rotatie a cheii.';

  @override
  String get sectionLinks => 'Linkuri';

  @override
  String get sectionDeveloper => 'Dezvoltator';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Pagina negasita';

  @override
  String get connectionTestSuccess => 'Conexiune reusita';

  @override
  String connectionTestFailed(String message) {
    return 'Conexiune esuata: $message';
  }

  @override
  String get serverVerificationFailed => 'Verificarea serverului a esuat';

  @override
  String get importSuccessful => 'Import reusit';

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
  String get deviceDeleteConfirmTitle => 'Eliminare dispozitiv';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Sigur doriți să eliminați \"$name\"? Dispozitivul va fi deconectat imediat.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Acesta este dispozitivul dvs. actual. Veți fi deconectat imediat.';

  @override
  String get deviceDeleteSuccess => 'Dispozitiv eliminat';

  @override
  String get deviceDeletedCurrentLogout =>
      'Dispozitivul actual a fost eliminat. Ați fost deconectat.';

  @override
  String get thisDevice => 'Acest dispozitiv';
}
