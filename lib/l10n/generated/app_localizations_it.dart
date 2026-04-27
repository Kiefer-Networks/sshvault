// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Host';

  @override
  String get navSnippets => 'Snippet';

  @override
  String get navFolders => 'Cartelle';

  @override
  String get navTags => 'Tag';

  @override
  String get navSshKeys => 'Chiavi SSH';

  @override
  String get navExportImport => 'Esporta / Importa';

  @override
  String get navTerminal => 'Terminale';

  @override
  String get navMore => 'Altro';

  @override
  String get navManagement => 'Gestione';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get navAbout => 'Informazioni';

  @override
  String get lockScreenTitle => 'SSHVault è bloccato';

  @override
  String get lockScreenUnlock => 'Sblocca';

  @override
  String get lockScreenEnterPin => 'Inserisci il PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Troppi tentativi falliti. Riprova tra $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Imposta codice PIN';

  @override
  String get pinDialogSetSubtitle =>
      'Inserisci un PIN a 6 cifre per proteggere SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Conferma PIN';

  @override
  String get pinDialogErrorLength =>
      'Il PIN deve essere esattamente di 6 cifre';

  @override
  String get pinDialogErrorMismatch => 'I PIN non corrispondono';

  @override
  String get pinDialogVerifyTitle => 'Inserisci il PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN errato. $attempts tentativi rimanenti.';
  }

  @override
  String get securityBannerMessage =>
      'Le tue credenziali SSH non sono protette. Configura un PIN o il blocco biometrico nelle Impostazioni.';

  @override
  String get securityBannerDismiss => 'Ignora';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSectionAppearance => 'Aspetto';

  @override
  String get settingsSectionTerminal => 'Terminale';

  @override
  String get settingsSectionSshDefaults => 'Impostazioni SSH predefinite';

  @override
  String get settingsSectionSecurity => 'Sicurezza';

  @override
  String get settingsSectionExport => 'Esportazione';

  @override
  String get settingsSectionAbout => 'Informazioni';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsTerminalTheme => 'Tema del terminale';

  @override
  String get settingsTerminalThemeDefault => 'Scuro predefinito';

  @override
  String get settingsFontSize => 'Dimensione carattere';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Porta predefinita';

  @override
  String get settingsDefaultPortDialog => 'Porta SSH predefinita';

  @override
  String get settingsPortLabel => 'Porta';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Nome utente predefinito';

  @override
  String get settingsDefaultUsernameDialog => 'Nome utente predefinito';

  @override
  String get settingsUsernameLabel => 'Nome utente';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Blocco automatico';

  @override
  String get settingsAutoLockDisabled => 'Disattivato';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minuti';
  }

  @override
  String get settingsAutoLockOff => 'Disattivato';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Sblocco biometrico';

  @override
  String get settingsBiometricNotAvailable =>
      'Non disponibile su questo dispositivo';

  @override
  String get settingsBiometricError => 'Errore durante il controllo biometrico';

  @override
  String get settingsBiometricReason =>
      'Verifica la tua identità per attivare lo sblocco biometrico';

  @override
  String get settingsBiometricRequiresPin =>
      'Imposta prima un PIN per attivare lo sblocco biometrico';

  @override
  String get settingsPinCode => 'Codice PIN';

  @override
  String get settingsPinIsSet => 'PIN impostato';

  @override
  String get settingsPinNotConfigured => 'Nessun PIN configurato';

  @override
  String get settingsPinRemove => 'Rimuovi';

  @override
  String get settingsPinRemoveWarning =>
      'La rimozione del PIN decritterà tutti i campi del database e disattiverà lo sblocco biometrico. Continuare?';

  @override
  String get settingsPinRemoveTitle => 'Rimuovi PIN';

  @override
  String get settingsPreventScreenshots => 'Impedisci screenshot';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Blocca screenshot e registrazione dello schermo';

  @override
  String get settingsEncryptExport =>
      'Crittografa le esportazioni per impostazione predefinita';

  @override
  String get settingsAbout => 'Informazioni su SSHVault';

  @override
  String get settingsAboutLegalese => 'di Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Client SSH sicuro e auto-ospitato';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Sistema';

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
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get close => 'Chiudi';

  @override
  String get update => 'Aggiorna';

  @override
  String get create => 'Crea';

  @override
  String get retry => 'Riprova';

  @override
  String get copy => 'Copia';

  @override
  String get edit => 'Modifica';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Errore: $message';
  }

  @override
  String get serverListTitle => 'Host';

  @override
  String get serverListEmpty => 'Nessun server ancora';

  @override
  String get serverListEmptySubtitle =>
      'Aggiungi il tuo primo server SSH per iniziare.';

  @override
  String get serverAddButton => 'Aggiungi server';

  @override
  String sshConfigImportMessage(int count) {
    return '$count host trovati in ~/.ssh/config. Importarli?';
  }

  @override
  String get sshConfigNotFound => 'Nessun file di configurazione SSH trovato';

  @override
  String get sshConfigEmpty => 'Nessun host trovato nella configurazione SSH';

  @override
  String get sshConfigAddManually => 'Aggiungi manualmente';

  @override
  String get sshConfigImportAgain =>
      'Importare di nuovo la configurazione SSH?';

  @override
  String get sshConfigImportKeys =>
      'Importare le chiavi SSH referenziate dagli host selezionati?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count chiave/i SSH importata/e';
  }

  @override
  String get serverDuplicated => 'Server duplicato';

  @override
  String get serverDeleteTitle => 'Elimina server';

  @override
  String serverDeleteMessage(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"? Questa azione non può essere annullata.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get serverConnect => 'Connetti';

  @override
  String get serverDetails => 'Dettagli';

  @override
  String get serverDuplicate => 'Duplica';

  @override
  String get serverActive => 'Attivo';

  @override
  String get serverNoFolder => 'Nessuna cartella';

  @override
  String get serverFormTitleEdit => 'Modifica server';

  @override
  String get serverFormTitleAdd => 'Aggiungi server';

  @override
  String get serverSaved => 'Server salvato';

  @override
  String get serverFormUpdateButton => 'Aggiorna server';

  @override
  String get serverFormAddButton => 'Aggiungi server';

  @override
  String get serverFormPublicKeyExtracted =>
      'Chiave pubblica estratta con successo';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Impossibile estrarre la chiave pubblica: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Coppia di chiavi $type generata';
  }

  @override
  String get serverDetailTitle => 'Dettagli del server';

  @override
  String get serverDetailDeleteMessage =>
      'Questa azione non può essere annullata.';

  @override
  String get serverDetailConnection => 'Connessione';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Porta';

  @override
  String get serverDetailUsername => 'Nome utente';

  @override
  String get serverDetailFolder => 'Cartella';

  @override
  String get serverDetailTags => 'Tag';

  @override
  String get serverDetailNotes => 'Note';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Creato';

  @override
  String get serverDetailUpdated => 'Aggiornato';

  @override
  String get serverDetailDistro => 'Sistema';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get serverFormNameLabel => 'Nome del server';

  @override
  String get serverFormHostnameLabel => 'Nome host / IP';

  @override
  String get serverFormPortLabel => 'Porta';

  @override
  String get serverFormUsernameLabel => 'Nome utente';

  @override
  String get serverFormPasswordLabel => 'Password';

  @override
  String get serverFormUseManagedKey => 'Usa chiave gestita';

  @override
  String get serverFormManagedKeySubtitle =>
      'Seleziona tra le chiavi SSH gestite centralmente';

  @override
  String get serverFormDirectKeySubtitle =>
      'Incolla la chiave direttamente in questo server';

  @override
  String get serverFormGenerateKey => 'Genera coppia di chiavi SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Chiave privata';

  @override
  String get serverFormPrivateKeyHint => 'Incolla la chiave privata SSH...';

  @override
  String get serverFormExtractPublicKey => 'Estrai chiave pubblica';

  @override
  String get serverFormPublicKeyLabel => 'Chiave pubblica';

  @override
  String get serverFormPublicKeyHint =>
      'Generata automaticamente dalla chiave privata se vuoto';

  @override
  String get serverFormPassphraseLabel => 'Passphrase della chiave (opzionale)';

  @override
  String get serverFormNotesLabel => 'Note (opzionale)';

  @override
  String get searchServers => 'Cerca server...';

  @override
  String get filterAllFolders => 'Tutte le cartelle';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterActive => 'Attivi';

  @override
  String get filterInactive => 'Inattivi';

  @override
  String get filterClear => 'Cancella';

  @override
  String get folderListTitle => 'Cartelle';

  @override
  String get folderListEmpty => 'Nessuna cartella ancora';

  @override
  String get folderListEmptySubtitle =>
      'Crea cartelle per organizzare i tuoi server.';

  @override
  String get folderAddButton => 'Aggiungi cartella';

  @override
  String get folderDeleteTitle => 'Elimina cartella';

  @override
  String folderDeleteMessage(String name) {
    return 'Eliminare \"$name\"? I server diventeranno non organizzati.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count server',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Comprimi';

  @override
  String get folderShowHosts => 'Mostra host';

  @override
  String get folderConnectAll => 'Connetti tutti';

  @override
  String get folderFormTitleEdit => 'Modifica cartella';

  @override
  String get folderFormTitleNew => 'Nuova cartella';

  @override
  String get folderFormNameLabel => 'Nome della cartella';

  @override
  String get folderFormParentLabel => 'Cartella principale';

  @override
  String get folderFormParentNone => 'Nessuna (Radice)';

  @override
  String get tagListTitle => 'Tag';

  @override
  String get tagListEmpty => 'Nessun tag ancora';

  @override
  String get tagListEmptySubtitle =>
      'Crea tag per etichettare e filtrare i tuoi server.';

  @override
  String get tagAddButton => 'Aggiungi tag';

  @override
  String get tagDeleteTitle => 'Elimina tag';

  @override
  String tagDeleteMessage(String name) {
    return 'Eliminare \"$name\"? Verrà rimosso da tutti i server.';
  }

  @override
  String get tagFormTitleEdit => 'Modifica tag';

  @override
  String get tagFormTitleNew => 'Nuovo tag';

  @override
  String get tagFormNameLabel => 'Nome del tag';

  @override
  String get sshKeyListTitle => 'Chiavi SSH';

  @override
  String get sshKeyListEmpty => 'Nessuna chiave SSH ancora';

  @override
  String get sshKeyListEmptySubtitle =>
      'Genera o importa chiavi SSH per gestirle centralmente';

  @override
  String get sshKeyCannotDeleteTitle => 'Impossibile eliminare';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Impossibile eliminare \"$name\". Utilizzata da $count server. Scollega prima da tutti i server.';
  }

  @override
  String get sshKeyDeleteTitle => 'Elimina chiave SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Eliminare \"$name\"? Questa azione non può essere annullata.';
  }

  @override
  String get sshKeyAddButton => 'Aggiungi chiave SSH';

  @override
  String get sshKeyFormTitleEdit => 'Modifica chiave SSH';

  @override
  String get sshKeyFormTitleAdd => 'Aggiungi chiave SSH';

  @override
  String get sshKeyFormTabGenerate => 'Genera';

  @override
  String get sshKeyFormTabImport => 'Importa';

  @override
  String get sshKeyFormNameLabel => 'Nome della chiave';

  @override
  String get sshKeyFormNameHint => 'es. La mia chiave di produzione';

  @override
  String get sshKeyFormKeyType => 'Tipo di chiave';

  @override
  String get sshKeyFormKeySize => 'Dimensione della chiave';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Commento';

  @override
  String get sshKeyFormCommentHint => 'utente@host o descrizione';

  @override
  String get sshKeyFormCommentOptional => 'Commento (opzionale)';

  @override
  String get sshKeyFormImportFromFile => 'Importa da file';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Chiave privata';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Incolla la chiave privata SSH o usa il pulsante sopra...';

  @override
  String get sshKeyFormPassphraseLabel => 'Passphrase (opzionale)';

  @override
  String get sshKeyFormNameRequired => 'Il nome è obbligatorio';

  @override
  String get sshKeyFormPrivateKeyRequired => 'La chiave privata è obbligatoria';

  @override
  String get sshKeyFormFileReadError =>
      'Impossibile leggere il file selezionato';

  @override
  String get sshKeyFormInvalidFormat =>
      'Formato chiave non valido — formato PEM previsto (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Impossibile leggere il file: $message';
  }

  @override
  String get sshKeyFormSaving => 'Salvataggio...';

  @override
  String get sshKeySelectorLabel => 'Chiave SSH';

  @override
  String get sshKeySelectorNone => 'Nessuna chiave gestita';

  @override
  String get sshKeySelectorManage => 'Gestisci chiavi...';

  @override
  String get sshKeySelectorError => 'Impossibile caricare le chiavi SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Copia chiave pubblica';

  @override
  String get sshKeyTilePublicKeyCopied => 'Chiave pubblica copiata';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Utilizzata da $count server';
  }

  @override
  String get sshKeySavedSuccess => 'Chiave SSH salvata';

  @override
  String get sshKeyDeletedSuccess => 'Chiave SSH eliminata';

  @override
  String get tagSavedSuccess => 'Tag salvato';

  @override
  String get tagDeletedSuccess => 'Tag eliminato';

  @override
  String get folderDeletedSuccess => 'Cartella eliminata';

  @override
  String get sshKeyTileUnlinkFirst => 'Scollega prima da tutti i server';

  @override
  String get exportImportTitle => 'Esporta / Importa';

  @override
  String get exportSectionTitle => 'Esporta';

  @override
  String get exportJsonButton => 'Esporta come JSON (senza credenziali)';

  @override
  String get exportZipButton => 'Esporta ZIP crittografato (con credenziali)';

  @override
  String get importSectionTitle => 'Importa';

  @override
  String get importButton => 'Importa da file';

  @override
  String get importSupportedFormats =>
      'Supporta file JSON (non crittografati) e ZIP (crittografati).';

  @override
  String exportedTo(String path) {
    return 'Esportato in: $path';
  }

  @override
  String get share => 'Condividi';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers server, $groups gruppi, $tags tag importati. $skipped ignorati.';
  }

  @override
  String get importPasswordTitle => 'Inserisci password';

  @override
  String get importPasswordLabel => 'Password di esportazione';

  @override
  String get importPasswordDecrypt => 'Decrittografa';

  @override
  String get exportPasswordTitle => 'Imposta password di esportazione';

  @override
  String get exportPasswordDescription =>
      'Questa password verrà utilizzata per crittografare il file di esportazione, incluse le credenziali.';

  @override
  String get exportPasswordLabel => 'Password';

  @override
  String get exportPasswordConfirmLabel => 'Conferma password';

  @override
  String get exportPasswordMismatch => 'Le password non corrispondono';

  @override
  String get exportPasswordButton => 'Crittografa ed esporta';

  @override
  String get importConflictTitle => 'Gestisci conflitti';

  @override
  String get importConflictDescription =>
      'Come devono essere gestite le voci esistenti durante l\'importazione?';

  @override
  String get importConflictSkip => 'Ignora esistenti';

  @override
  String get importConflictRename => 'Rinomina nuovi';

  @override
  String get importConflictOverwrite => 'Sovrascrivi';

  @override
  String get confirmDeleteLabel => 'Elimina';

  @override
  String get keyGenTitle => 'Genera coppia di chiavi SSH';

  @override
  String get keyGenKeyType => 'Tipo di chiave';

  @override
  String get keyGenKeySize => 'Dimensione della chiave';

  @override
  String get keyGenComment => 'Commento';

  @override
  String get keyGenCommentHint => 'utente@host o descrizione';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Generazione...';

  @override
  String get keyGenGenerate => 'Genera';

  @override
  String keyGenResultTitle(String type) {
    return 'Chiave $type generata';
  }

  @override
  String get keyGenPublicKey => 'Chiave pubblica';

  @override
  String get keyGenPrivateKey => 'Chiave privata';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Commento: $comment';
  }

  @override
  String get keyGenAnother => 'Genera un\'altra';

  @override
  String get keyGenUseThisKey => 'Usa questa chiave';

  @override
  String get keyGenCopyTooltip => 'Copia negli appunti';

  @override
  String keyGenCopied(String label) {
    return '$label copiato';
  }

  @override
  String get colorPickerLabel => 'Colore';

  @override
  String get iconPickerLabel => 'Icona';

  @override
  String get tagSelectorLabel => 'Tag';

  @override
  String get tagSelectorEmpty => 'Nessun tag ancora';

  @override
  String get tagSelectorError => 'Impossibile caricare i tag';

  @override
  String get snippetListTitle => 'Snippet';

  @override
  String get snippetSearchHint => 'Cerca snippet...';

  @override
  String get snippetListEmpty => 'Nessun snippet ancora';

  @override
  String get snippetListEmptySubtitle =>
      'Crea snippet di codice e comandi riutilizzabili.';

  @override
  String get snippetAddButton => 'Aggiungi snippet';

  @override
  String get snippetDeleteTitle => 'Elimina snippet';

  @override
  String snippetDeleteMessage(String name) {
    return 'Eliminare \"$name\"? Questa azione non può essere annullata.';
  }

  @override
  String get snippetFormTitleEdit => 'Modifica snippet';

  @override
  String get snippetFormTitleNew => 'Nuovo snippet';

  @override
  String get snippetFormNameLabel => 'Nome';

  @override
  String get snippetFormNameHint => 'es. Pulizia Docker';

  @override
  String get snippetFormLanguageLabel => 'Linguaggio';

  @override
  String get snippetFormContentLabel => 'Contenuto';

  @override
  String get snippetFormContentHint => 'Inserisci il codice dello snippet...';

  @override
  String get snippetFormDescriptionLabel => 'Descrizione';

  @override
  String get snippetFormDescriptionHint => 'Descrizione opzionale...';

  @override
  String get snippetFormFolderLabel => 'Cartella';

  @override
  String get snippetFormNoFolder => 'Nessuna cartella';

  @override
  String get snippetFormNameRequired => 'Il nome è obbligatorio';

  @override
  String get snippetFormContentRequired => 'Il contenuto è obbligatorio';

  @override
  String get snippetFormSaved => 'Snippet salvato';

  @override
  String get snippetFormUpdateButton => 'Aggiorna snippet';

  @override
  String get snippetFormCreateButton => 'Crea snippet';

  @override
  String get snippetDetailTitle => 'Dettagli dello snippet';

  @override
  String get snippetDetailDeleteTitle => 'Elimina snippet';

  @override
  String get snippetDetailDeleteMessage =>
      'Questa azione non può essere annullata.';

  @override
  String get snippetDetailContent => 'Contenuto';

  @override
  String get snippetDetailFillVariables => 'Compila variabili';

  @override
  String get snippetDetailDescription => 'Descrizione';

  @override
  String get snippetDetailVariables => 'Variabili';

  @override
  String get snippetDetailTags => 'Tag';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Creato';

  @override
  String get snippetDetailUpdated => 'Aggiornato';

  @override
  String get variableEditorTitle => 'Variabili del modello';

  @override
  String get variableEditorAdd => 'Aggiungi';

  @override
  String get variableEditorEmpty =>
      'Nessuna variabile. Usa la sintassi con parentesi graffe nel contenuto per farvi riferimento.';

  @override
  String get variableEditorNameLabel => 'Nome';

  @override
  String get variableEditorNameHint => 'es. hostname';

  @override
  String get variableEditorDefaultLabel => 'Predefinito';

  @override
  String get variableEditorDefaultHint => 'opzionale';

  @override
  String get variableFillTitle => 'Compila variabili';

  @override
  String variableFillHint(String name) {
    return 'Inserisci il valore per $name';
  }

  @override
  String get variableFillPreview => 'Anteprima';

  @override
  String get terminalTitle => 'Terminale';

  @override
  String get terminalEmpty => 'Nessuna sessione attiva';

  @override
  String get terminalEmptySubtitle =>
      'Connettiti a un host per aprire una sessione terminale.';

  @override
  String get terminalGoToHosts => 'Vai agli host';

  @override
  String get terminalCloseAll => 'Chiudi tutte le sessioni';

  @override
  String get terminalCloseTitle => 'Chiudi sessione';

  @override
  String terminalCloseMessage(String title) {
    return 'Chiudere la connessione attiva a \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Autenticazione...';

  @override
  String connectionConnecting(String name) {
    return 'Connessione a $name...';
  }

  @override
  String get connectionError => 'Errore di connessione';

  @override
  String get connectionLost => 'Connessione persa';

  @override
  String get connectionReconnect => 'Riconnetti';

  @override
  String get snippetQuickPanelTitle => 'Inserisci snippet';

  @override
  String get snippetQuickPanelSearch => 'Cerca snippet...';

  @override
  String get snippetQuickPanelEmpty => 'Nessun snippet disponibile';

  @override
  String get snippetQuickPanelNoMatch => 'Nessun snippet corrispondente';

  @override
  String get snippetQuickPanelInsertTooltip => 'Inserisci snippet';

  @override
  String get terminalThemePickerTitle => 'Tema del terminale';

  @override
  String get validatorHostnameRequired => 'Il nome host è obbligatorio';

  @override
  String get validatorHostnameInvalid => 'Nome host o indirizzo IP non valido';

  @override
  String get validatorPortRequired => 'La porta è obbligatoria';

  @override
  String get validatorPortRange => 'La porta deve essere tra 1 e 65535';

  @override
  String get validatorUsernameRequired => 'Il nome utente è obbligatorio';

  @override
  String get validatorUsernameInvalid => 'Formato nome utente non valido';

  @override
  String get validatorServerNameRequired => 'Il nome del server è obbligatorio';

  @override
  String get validatorServerNameLength =>
      'Il nome del server deve essere di 100 caratteri o meno';

  @override
  String get validatorSshKeyInvalid => 'Formato chiave SSH non valido';

  @override
  String get validatorPasswordRequired => 'La password è obbligatoria';

  @override
  String get validatorPasswordLength =>
      'La password deve essere di almeno 8 caratteri';

  @override
  String get authMethodPassword => 'Password';

  @override
  String get authMethodKey => 'Chiave SSH';

  @override
  String get authMethodBoth => 'Password + Chiave';

  @override
  String get serverCopySuffix => '(Copia)';

  @override
  String get settingsDownloadLogs => 'Scarica log';

  @override
  String get settingsSendLogs => 'Invia log al supporto';

  @override
  String get settingsLogsSaved => 'Log salvati con successo';

  @override
  String get settingsUpdated => 'Impostazione aggiornata';

  @override
  String get settingsThemeChanged => 'Tema cambiato';

  @override
  String get settingsLanguageChanged => 'Lingua cambiata';

  @override
  String get settingsPinSetSuccess => 'PIN impostato';

  @override
  String get settingsPinRemovedSuccess => 'PIN rimosso';

  @override
  String get settingsDuressPinSetSuccess => 'PIN di emergenza impostato';

  @override
  String get settingsDuressPinRemovedSuccess => 'PIN di emergenza rimosso';

  @override
  String get settingsBiometricEnabled => 'Sblocco biometrico attivato';

  @override
  String get settingsBiometricDisabled => 'Sblocco biometrico disattivato';

  @override
  String get settingsDnsServerAdded => 'Server DNS aggiunto';

  @override
  String get settingsDnsServerRemoved => 'Server DNS rimosso';

  @override
  String get settingsDnsResetSuccess => 'Server DNS ripristinati';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Riduci dimensione';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Aumenta dimensione';

  @override
  String get settingsDnsRemoveServerTooltip => 'Rimuovi server DNS';

  @override
  String get settingsLogsEmpty => 'Nessuna voce di log disponibile';

  @override
  String get authLogin => 'Accedi';

  @override
  String get authRegister => 'Registrati';

  @override
  String get authForgotPassword => 'Password dimenticata?';

  @override
  String get authWhyLogin =>
      'Accedi per attivare la sincronizzazione cloud crittografata su tutti i tuoi dispositivi. L\'app funziona completamente offline senza un account.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'L\'email è obbligatoria';

  @override
  String get authEmailInvalid => 'Indirizzo email non valido';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Conferma password';

  @override
  String get authPasswordMismatch => 'Le password non corrispondono';

  @override
  String get authNoAccount => 'Non hai un account?';

  @override
  String get authHasAccount => 'Hai già un account?';

  @override
  String get authResetEmailSent =>
      'Se esiste un account, un link di reimpostazione è stato inviato al tuo indirizzo email.';

  @override
  String get authResetDescription =>
      'Inserisci il tuo indirizzo email e ti invieremo un link per reimpostare la password.';

  @override
  String get authSendResetLink => 'Invia link di reimpostazione';

  @override
  String get authBackToLogin => 'Torna al login';

  @override
  String get syncPasswordTitle => 'Password di sincronizzazione';

  @override
  String get syncPasswordTitleCreate => 'Imposta password di sincronizzazione';

  @override
  String get syncPasswordTitleEnter => 'Inserisci password di sincronizzazione';

  @override
  String get syncPasswordDescription =>
      'Imposta una password separata per crittografare i dati del tuo vault. Questa password non lascia mai il tuo dispositivo — il server memorizza solo dati crittografati.';

  @override
  String get syncPasswordHintEnter =>
      'Inserisci la password impostata durante la creazione del tuo account.';

  @override
  String get syncPasswordWarning =>
      'Se dimentichi questa password, i tuoi dati sincronizzati non potranno essere recuperati. Non esiste un\'opzione di reimpostazione.';

  @override
  String get syncPasswordLabel => 'Password di sincronizzazione';

  @override
  String get syncPasswordWrong => 'Password errata. Riprova.';

  @override
  String get firstSyncTitle => 'Dati esistenti trovati';

  @override
  String get firstSyncMessage =>
      'Questo dispositivo ha dati esistenti e il server ha un vault. Come procedere?';

  @override
  String get firstSyncMerge => 'Unisci (il server ha la priorità)';

  @override
  String get firstSyncOverwriteLocal => 'Sovrascrivi dati locali';

  @override
  String get firstSyncKeepLocal => 'Mantieni locali e invia';

  @override
  String get firstSyncDeleteLocal => 'Elimina locali e scarica';

  @override
  String get changeEncryptionPassword => 'Cambia password di crittografia';

  @override
  String get changeEncryptionWarning =>
      'Verrai disconnesso da tutti gli altri dispositivi.';

  @override
  String get changeEncryptionOldPassword => 'Password attuale';

  @override
  String get changeEncryptionNewPassword => 'Nuova password';

  @override
  String get changeEncryptionSuccess => 'Password cambiata con successo.';

  @override
  String get logoutAllDevices => 'Disconnetti da tutti i dispositivi';

  @override
  String get logoutAllDevicesConfirm =>
      'Questo revocherà tutte le sessioni attive. Dovrai accedere di nuovo su tutti i dispositivi.';

  @override
  String get logoutAllDevicesSuccess => 'Tutti i dispositivi disconnessi.';

  @override
  String get syncSettingsTitle => 'Impostazioni di sincronizzazione';

  @override
  String get syncAutoSync => 'Sincronizzazione automatica';

  @override
  String get syncAutoSyncDescription =>
      'Sincronizza automaticamente all\'avvio dell\'app';

  @override
  String get syncBackgroundSync => 'Sincronizza in background';

  @override
  String get syncBackgroundSyncDescription =>
      'Sync periodico del vault tramite WorkManager anche con app chiusa.';

  @override
  String get syncNow => 'Sincronizza ora';

  @override
  String get syncSyncing => 'Sincronizzazione...';

  @override
  String get syncSuccess => 'Sincronizzazione completata';

  @override
  String get syncError => 'Errore di sincronizzazione';

  @override
  String get syncServerUnreachable => 'Server non raggiungibile';

  @override
  String get syncServerUnreachableHint =>
      'Il server di sincronizzazione non è raggiungibile. Controlla la tua connessione Internet e l\'URL del server.';

  @override
  String get syncNetworkError =>
      'Connessione al server fallita. Controlla la tua connessione Internet o riprova più tardi.';

  @override
  String get syncNeverSynced => 'Mai sincronizzato';

  @override
  String get syncVaultVersion => 'Versione del vault';

  @override
  String get syncTitle => 'Sincronizzazione';

  @override
  String get settingsSectionNetwork => 'Rete e DNS';

  @override
  String get settingsDnsServers => 'Server DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Predefinito (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Inserisci URL di server DoH personalizzati, separati da virgole. Sono necessari almeno 2 server per la verifica incrociata.';

  @override
  String get settingsDnsLabel => 'URL dei server DoH';

  @override
  String get settingsDnsReset => 'Ripristina predefiniti';

  @override
  String get settingsSectionSync => 'Sincronizzazione';

  @override
  String get settingsSyncAccount => 'Account';

  @override
  String get settingsSyncNotLoggedIn => 'Non connesso';

  @override
  String get settingsSyncStatus => 'Sincronizzazione';

  @override
  String get settingsSyncServerUrl => 'URL del server';

  @override
  String get settingsSyncDefaultServer => 'Predefinito (sshvault.app)';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountNotLoggedIn => 'Non connesso';

  @override
  String get accountVerified => 'Verificato';

  @override
  String get accountMemberSince => 'Membro da';

  @override
  String get accountDevices => 'Dispositivi';

  @override
  String get accountNoDevices => 'Nessun dispositivo registrato';

  @override
  String get accountLastSync => 'Ultima sincronizzazione';

  @override
  String get accountChangePassword => 'Cambia password';

  @override
  String get accountOldPassword => 'Password attuale';

  @override
  String get accountNewPassword => 'Nuova password';

  @override
  String get accountDeleteAccount => 'Elimina account';

  @override
  String get accountDeleteWarning =>
      'Questo eliminerà permanentemente il tuo account e tutti i dati sincronizzati. Questa azione non può essere annullata.';

  @override
  String get accountLogout => 'Esci';

  @override
  String get serverConfigTitle => 'Configurazione del server';

  @override
  String get serverConfigUrlLabel => 'URL del server';

  @override
  String get serverConfigTest => 'Testa connessione';

  @override
  String get serverSetupTitle => 'Configurazione server';

  @override
  String get serverSetupInfoCard =>
      'ShellVault richiede un server self-hosted per la sincronizzazione crittografata end-to-end. Distribuisci la tua istanza per iniziare.';

  @override
  String get serverSetupRepoLink => 'Vedi su GitHub';

  @override
  String get serverSetupContinue => 'Continua';

  @override
  String get settingsServerNotConfigured => 'Nessun server configurato';

  @override
  String get settingsSetupSync =>
      'Configura la sincronizzazione per il backup dei dati';

  @override
  String get settingsChangeServer => 'Cambia server';

  @override
  String get settingsChangeServerConfirm =>
      'Cambiare server ti disconnetterà. Continuare?';

  @override
  String get auditLogTitle => 'Registro attività';

  @override
  String get auditLogAll => 'Tutti';

  @override
  String get auditLogEmpty => 'Nessun registro di attività trovato';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Gestore file';

  @override
  String get sftpLocalDevice => 'Dispositivo locale';

  @override
  String get sftpSelectServer => 'Seleziona server...';

  @override
  String get sftpConnecting => 'Connessione...';

  @override
  String get sftpEmptyDirectory => 'Questa directory è vuota';

  @override
  String get sftpNoConnection => 'Nessun server connesso';

  @override
  String get sftpPathLabel => 'Percorso';

  @override
  String get sftpUpload => 'Carica';

  @override
  String get sftpDownload => 'Scarica';

  @override
  String get sftpDelete => 'Elimina';

  @override
  String get sftpRename => 'Rinomina';

  @override
  String get sftpNewFolder => 'Nuova cartella';

  @override
  String get sftpNewFolderName => 'Nome della cartella';

  @override
  String get sftpChmod => 'Permessi';

  @override
  String get sftpChmodTitle => 'Modifica permessi';

  @override
  String get sftpChmodOctal => 'Ottale';

  @override
  String get sftpChmodOwner => 'Proprietario';

  @override
  String get sftpChmodGroup => 'Gruppo';

  @override
  String get sftpChmodOther => 'Altri';

  @override
  String get sftpChmodRead => 'Lettura';

  @override
  String get sftpChmodWrite => 'Scrittura';

  @override
  String get sftpChmodExecute => 'Esecuzione';

  @override
  String get sftpCreateSymlink => 'Crea collegamento simbolico';

  @override
  String get sftpSymlinkTarget => 'Percorso di destinazione';

  @override
  String get sftpSymlinkName => 'Nome del collegamento';

  @override
  String get sftpFilePreview => 'Anteprima file';

  @override
  String get sftpFileInfo => 'Info file';

  @override
  String get sftpFileSize => 'Dimensione';

  @override
  String get sftpFileModified => 'Modificato';

  @override
  String get sftpFilePermissions => 'Permessi';

  @override
  String get sftpFileOwner => 'Proprietario';

  @override
  String get sftpFileType => 'Tipo';

  @override
  String get sftpFileLinkTarget => 'Destinazione del collegamento';

  @override
  String get sftpTransfers => 'Trasferimenti';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current di $total';
  }

  @override
  String get sftpTransferQueued => 'In coda';

  @override
  String get sftpTransferActive => 'Trasferimento...';

  @override
  String get sftpTransferPaused => 'In pausa';

  @override
  String get sftpTransferCompleted => 'Completato';

  @override
  String get sftpTransferFailed => 'Fallito';

  @override
  String get sftpTransferCancelled => 'Annullato';

  @override
  String get sftpPauseTransfer => 'Pausa';

  @override
  String get sftpResumeTransfer => 'Riprendi';

  @override
  String get sftpCancelTransfer => 'Annulla';

  @override
  String get sftpClearCompleted => 'Cancella completati';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active di $total trasferimenti';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attivi',
      one: '1 attivo',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count completati',
      one: '1 completato',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count falliti',
      one: '1 fallito',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Copia nell\'altro pannello';

  @override
  String sftpConfirmDelete(int count) {
    return 'Eliminare $count elementi?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Eliminato con successo';

  @override
  String get sftpRenameTitle => 'Rinomina';

  @override
  String get sftpRenameLabel => 'Nuovo nome';

  @override
  String get sftpSortByName => 'Nome';

  @override
  String get sftpSortBySize => 'Dimensione';

  @override
  String get sftpSortByDate => 'Data';

  @override
  String get sftpSortByType => 'Tipo';

  @override
  String get sftpShowHidden => 'Mostra file nascosti';

  @override
  String get sftpHideHidden => 'Nascondi file nascosti';

  @override
  String get sftpSelectAll => 'Seleziona tutto';

  @override
  String get sftpDeselectAll => 'Deseleziona tutto';

  @override
  String sftpItemsSelected(int count) {
    return '$count selezionati';
  }

  @override
  String get sftpRefresh => 'Aggiorna';

  @override
  String sftpConnectionError(String message) {
    return 'Connessione fallita: $message';
  }

  @override
  String get sftpPermissionDenied => 'Permesso negato';

  @override
  String sftpOperationFailed(String message) {
    return 'Operazione fallita: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Il file esiste già';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" esiste già. Sovrascrivere?';
  }

  @override
  String get sftpOverwrite => 'Sovrascrivi';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Trasferimento avviato: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Seleziona prima una destinazione nell\'altro pannello';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Trasferimento directory in arrivo';

  @override
  String get sftpSelect => 'Seleziona';

  @override
  String get sftpOpen => 'Apri';

  @override
  String get sftpExtractArchive => 'Estrai qui';

  @override
  String get sftpExtractSuccess => 'Archivio estratto';

  @override
  String sftpExtractFailed(String message) {
    return 'Estrazione fallita: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Formato archivio non supportato';

  @override
  String get sftpExtracting => 'Estrazione...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caricamenti avviati',
      one: 'Caricamento avviato',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count download avviati',
      one: 'Download avviato',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" scaricato';
  }

  @override
  String get sftpSavedToDownloads => 'Salvato in Download/SSHVault';

  @override
  String get sftpSaveToFiles => 'Salva nei file';

  @override
  String get sftpFileSaved => 'File salvato';

  @override
  String get fileChooserOpenFile => 'Apri file';

  @override
  String get fileChooserSaveFile => 'Salva file';

  @override
  String get fileChooserOpenDirectory => 'Scegli cartella';

  @override
  String get fileChooserImportArchive => 'Importa backup';

  @override
  String get fileChooserImportSshConfig => 'Importa config SSH';

  @override
  String get fileChooserImportSettings => 'Importa impostazioni';

  @override
  String get fileChooserPickKeyFile => 'Scegli file chiave SSH';

  @override
  String get fileChooserUploadFiles => 'Carica file';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessioni SSH attive',
      one: 'Sessione SSH attiva',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Tocca per aprire il terminale';

  @override
  String get settingsAccountAndSync => 'Account e sincronizzazione';

  @override
  String get settingsAccountSubtitleAuth => 'Connesso';

  @override
  String get settingsAccountSubtitleUnauth => 'Non connesso';

  @override
  String get settingsSecuritySubtitle => 'Blocco auto, Biometria, PIN';

  @override
  String get settingsSshSubtitle => 'Porta 22, Utente root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, Lingua, Terminale';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle =>
      'Impostazioni esportazione crittografata';

  @override
  String get settingsAboutSubtitle => 'Versione, Licenze';

  @override
  String get settingsSearchHint => 'Cerca impostazioni...';

  @override
  String get settingsSearchNoResults => 'Nessuna impostazione trovata';

  @override
  String get aboutDeveloper => 'Sviluppato da Kiefer Networks';

  @override
  String get aboutDonate => 'Dona';

  @override
  String get aboutOpenSourceLicenses => 'Licenze Open Source';

  @override
  String get aboutWebsite => 'Sito web';

  @override
  String get aboutVersion => 'Versione';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS crittografa le query DNS e previene lo spoofing DNS. SSHVault verifica i nomi host con più provider per rilevare gli attacchi.';

  @override
  String get settingsDnsAddServer => 'Aggiungi server DNS';

  @override
  String get settingsDnsServerUrl => 'URL del server';

  @override
  String get settingsDnsDefaultBadge => 'Predefinito';

  @override
  String get settingsDnsResetDefaults => 'Ripristina predefiniti';

  @override
  String get settingsDnsInvalidUrl => 'Inserisci un URL HTTPS valido';

  @override
  String get settingsDefaultAuthMethod => 'Metodo di autenticazione';

  @override
  String get settingsAuthPassword => 'Password';

  @override
  String get settingsAuthKey => 'Chiave SSH';

  @override
  String get settingsConnectionTimeout => 'Timeout connessione';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Intervallo Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Compressione';

  @override
  String get settingsCompressionDescription =>
      'Abilita la compressione zlib per le connessioni SSH';

  @override
  String get settingsTerminalType => 'Tipo di terminale';

  @override
  String get settingsSectionConnection => 'Connessione';

  @override
  String get settingsClipboardAutoClear => 'Cancellazione automatica appunti';

  @override
  String get settingsClipboardAutoClearOff => 'Disattivato';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Timeout sessione';

  @override
  String get settingsSessionTimeoutOff => 'Disattivato';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'PIN di costrizione';

  @override
  String get settingsDuressPinDescription =>
      'Un PIN separato che cancella tutti i dati quando inserito';

  @override
  String get settingsDuressPinSet => 'PIN di costrizione impostato';

  @override
  String get settingsDuressPinNotSet => 'Non configurato';

  @override
  String get settingsDuressPinWarning =>
      'L\'inserimento di questo PIN eliminerà permanentemente tutti i dati locali, incluse credenziali, chiavi e impostazioni. Questa azione non può essere annullata.';

  @override
  String get settingsKeyRotationReminder => 'Promemoria rotazione chiavi';

  @override
  String get settingsKeyRotationOff => 'Disattivato';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days giorni';
  }

  @override
  String get settingsFailedAttempts => 'Tentativi PIN falliti';

  @override
  String get settingsSectionAppLock => 'Blocco app';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsSectionReminders => 'Promemoria';

  @override
  String get settingsSectionStatus => 'Stato';

  @override
  String get settingsExportBackupSubtitle => 'Esporta, Importa e Backup';

  @override
  String get settingsExportJson => 'Esporta come JSON';

  @override
  String get settingsExportEncrypted => 'Esporta crittografato';

  @override
  String get settingsImportFile => 'Importa da file';

  @override
  String get settingsSectionImport => 'Importa';

  @override
  String get filterTitle => 'Filtra server';

  @override
  String get filterApply => 'Applica filtri';

  @override
  String get filterClearAll => 'Cancella tutto';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtri attivi',
      one: '1 filtro attivo',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Cartella';

  @override
  String get filterTags => 'Tag';

  @override
  String get filterStatus => 'Stato';

  @override
  String get variablePreviewResolved => 'Anteprima risolta';

  @override
  String get variableInsert => 'Inserisci';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count server',
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
      other: '$count sessioni revocate.',
      one: '1 sessione revocata.',
    );
    return '$_temp0 Sei stato disconnesso.';
  }

  @override
  String get keyGenPassphrase => 'Passphrase';

  @override
  String get keyGenPassphraseHint => 'Opzionale — protegge la chiave privata';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Predefinito (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Una chiave con la stessa impronta digitale esiste già: \"$name\". Ogni chiave SSH deve essere unica.';
  }

  @override
  String get sshKeyFingerprint => 'Impronta digitale';

  @override
  String get sshKeyPublicKey => 'Chiave pubblica';

  @override
  String get jumpHost => 'Host di salto';

  @override
  String get jumpHostNone => 'Nessuno';

  @override
  String get jumpHostLabel => 'Connetti tramite host di salto';

  @override
  String get jumpHostSelfError =>
      'Un server non può essere il proprio host di salto';

  @override
  String get jumpHostConnecting => 'Connessione all\'host di salto…';

  @override
  String get jumpHostCircularError =>
      'Rilevata catena circolare di host di salto';

  @override
  String get logoutDialogTitle => 'Esci';

  @override
  String get logoutDialogMessage =>
      'Vuoi eliminare tutti i dati locali? Server, chiavi SSH, snippet e impostazioni verranno rimossi da questo dispositivo.';

  @override
  String get logoutOnly => 'Solo esci';

  @override
  String get logoutAndDelete => 'Esci ed elimina dati';

  @override
  String get changeAvatar => 'Cambia avatar';

  @override
  String get removeAvatar => 'Rimuovi avatar';

  @override
  String get avatarUploadFailed => 'Caricamento avatar fallito';

  @override
  String get avatarTooLarge => 'L\'immagine è troppo grande';

  @override
  String get deviceLastSeen => 'Visto l\'ultima volta';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'L\'URL del server non può essere modificato mentre sei connesso. Esci prima.';

  @override
  String get serverListNoFolder => 'Senza categoria';

  @override
  String get autoSyncInterval => 'Intervallo di sincronizzazione';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Impostazioni proxy';

  @override
  String get proxyType => 'Tipo di proxy';

  @override
  String get proxyNone => 'Nessun proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Host del proxy';

  @override
  String get proxyPort => 'Porta del proxy';

  @override
  String get proxyUsername => 'Nome utente del proxy';

  @override
  String get proxyPassword => 'Password del proxy';

  @override
  String get proxyUseGlobal => 'Usa proxy globale';

  @override
  String get proxyGlobal => 'Globale';

  @override
  String get proxyServerSpecific => 'Specifico del server';

  @override
  String get proxyTestConnection => 'Testa connessione';

  @override
  String get proxyTestSuccess => 'Proxy raggiungibile';

  @override
  String get proxyTestFailed => 'Proxy non raggiungibile';

  @override
  String get proxyDefaultProxy => 'Proxy predefinito';

  @override
  String get vpnRequired => 'VPN richiesta';

  @override
  String get vpnRequiredTooltip =>
      'Mostra avviso quando ci si connette senza VPN attiva';

  @override
  String get vpnActive => 'VPN attiva';

  @override
  String get vpnInactive => 'VPN inattiva';

  @override
  String get vpnWarningTitle => 'VPN non attiva';

  @override
  String get vpnWarningMessage =>
      'Questo server richiede una connessione VPN, ma nessuna VPN è attualmente attiva. Vuoi connetterti comunque?';

  @override
  String get vpnConnectAnyway => 'Connetti comunque';

  @override
  String get postConnectCommands => 'Comandi post-connessione';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Comandi eseguiti automaticamente dopo la connessione (uno per riga)';

  @override
  String get dashboardFavorites => 'Preferiti';

  @override
  String get dashboardRecent => 'Recenti';

  @override
  String get dashboardActiveSessions => 'Sessioni attive';

  @override
  String get addToFavorites => 'Aggiungi ai preferiti';

  @override
  String get removeFromFavorites => 'Rimuovi dai preferiti';

  @override
  String get noRecentConnections => 'Nessuna connessione recente';

  @override
  String get terminalSplit => 'Vista divisa';

  @override
  String get terminalUnsplit => 'Chiudi divisione';

  @override
  String get terminalSelectSession => 'Seleziona sessione per la vista divisa';

  @override
  String get knownHostsTitle => 'Host conosciuti';

  @override
  String get knownHostsSubtitle =>
      'Gestisci le impronte digitali dei server fidati';

  @override
  String get hostKeyNewTitle => 'Nuovo host';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Prima connessione a $hostname:$port. Verifica l\'impronta digitale prima di connetterti.';
  }

  @override
  String get hostKeyChangedTitle => 'Chiave dell\'host cambiata!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'La chiave dell\'host per $hostname:$port è cambiata. Questo potrebbe indicare una minaccia alla sicurezza.';
  }

  @override
  String get hostKeyFingerprint => 'Impronta digitale';

  @override
  String get hostKeyType => 'Tipo di chiave';

  @override
  String get hostKeyTrustConnect => 'Fidati e connetti';

  @override
  String get hostKeyAcceptNew => 'Accetta nuova chiave';

  @override
  String get hostKeyReject => 'Rifiuta';

  @override
  String get hostKeyPreviousFingerprint => 'Impronta digitale precedente';

  @override
  String get hostKeyDeleteAll => 'Elimina tutti gli host conosciuti';

  @override
  String get hostKeyDeleteConfirm =>
      'Sei sicuro di voler rimuovere tutti gli host conosciuti? Ti verrà chiesto di nuovo alla prossima connessione.';

  @override
  String get hostKeyEmpty => 'Nessun host conosciuto ancora';

  @override
  String get hostKeyEmptySubtitle =>
      'Le impronte digitali degli host verranno memorizzate qui dopo la prima connessione';

  @override
  String get hostKeyFirstSeen => 'Visto per la prima volta';

  @override
  String get hostKeyLastSeen => 'Visto l\'ultima volta';

  @override
  String get sshConfigImportTitle => 'Importa configurazione SSH';

  @override
  String get sshConfigImportPickFile => 'Seleziona file di configurazione SSH';

  @override
  String get sshConfigImportOrPaste =>
      'Oppure incolla il contenuto della configurazione';

  @override
  String sshConfigImportParsed(int count) {
    return '$count host trovati';
  }

  @override
  String get sshConfigImportButton => 'Importa selezionati';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count server importati';
  }

  @override
  String get sshConfigImportDuplicate => 'Esiste già';

  @override
  String get sshConfigImportNoHosts =>
      'Nessun host trovato nella configurazione';

  @override
  String get sftpBookmarkAdd => 'Aggiungi segnalibro';

  @override
  String get sftpBookmarkLabel => 'Etichetta';

  @override
  String get disconnect => 'Disconnetti';

  @override
  String get reportAndDisconnect => 'Segnala e disconnetti';

  @override
  String get continueAnyway => 'Continua comunque';

  @override
  String get insertSnippet => 'Inserisci snippet';

  @override
  String get seconds => 'Secondi';

  @override
  String get heartbeatLostMessage =>
      'Il server non è raggiungibile dopo diversi tentativi. Per la tua sicurezza, la sessione è stata terminata.';

  @override
  String get attestationFailedTitle => 'Verifica del server fallita';

  @override
  String get attestationFailedMessage =>
      'Il server non è stato verificato come un backend SSHVault legittimo. Questo potrebbe indicare un attacco man-in-the-middle o un server configurato in modo errato.';

  @override
  String get attestationKeyChangedTitle =>
      'Chiave di attestazione del server cambiata';

  @override
  String get attestationKeyChangedMessage =>
      'La chiave di attestazione del server è cambiata dalla connessione iniziale. Questo potrebbe indicare un attacco man-in-the-middle. NON continuare a meno che l\'amministratore del server abbia confermato una rotazione delle chiavi.';

  @override
  String get sectionLinks => 'Link';

  @override
  String get sectionDeveloper => 'Sviluppatore';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Pagina non trovata';

  @override
  String get connectionTestSuccess => 'Connessione riuscita';

  @override
  String connectionTestFailed(String message) {
    return 'Connessione fallita: $message';
  }

  @override
  String get serverVerificationFailed => 'Verifica del server fallita';

  @override
  String get importSuccessful => 'Importazione riuscita';

  @override
  String get hintExampleServerUrl => 'https://il-tuo-server.example.com';

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
  String get deviceDeleteConfirmTitle => 'Rimuovi dispositivo';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Sei sicuro di voler rimuovere \"$name\"? Il dispositivo verrà disconnesso immediatamente.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Questo è il tuo dispositivo attuale. Verrai disconnesso immediatamente.';

  @override
  String get deviceDeleteSuccess => 'Dispositivo rimosso';

  @override
  String get deviceDeletedCurrentLogout =>
      'Dispositivo attuale rimosso. Sei stato disconnesso.';

  @override
  String get thisDevice => 'Questo dispositivo';
}
