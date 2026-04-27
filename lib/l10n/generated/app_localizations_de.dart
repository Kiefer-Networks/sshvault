// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Hosts';

  @override
  String get navSnippets => 'Snippets';

  @override
  String get navFolders => 'Ordner';

  @override
  String get navTags => 'Tags';

  @override
  String get navSshKeys => 'SSH-Schlüssel';

  @override
  String get navExportImport => 'Export / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Mehr';

  @override
  String get navManagement => 'Verwaltung';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navAbout => 'Über';

  @override
  String get lockScreenTitle => 'SSHVault ist gesperrt';

  @override
  String get lockScreenUnlock => 'Entsperren';

  @override
  String get lockScreenEnterPin => 'PIN eingeben';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Zu viele Fehlversuche. Versuche es in $minutes Min. erneut.';
  }

  @override
  String get pinDialogSetTitle => 'PIN festlegen';

  @override
  String get pinDialogSetSubtitle =>
      'Gib eine 6-stellige PIN ein, um SSHVault zu schützen';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'PIN bestätigen';

  @override
  String get pinDialogErrorLength => 'PIN muss genau 6 Ziffern haben';

  @override
  String get pinDialogErrorMismatch => 'PINs stimmen nicht überein';

  @override
  String get pinDialogVerifyTitle => 'PIN eingeben';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Falsche PIN. $attempts Versuche verbleibend.';
  }

  @override
  String get securityBannerMessage =>
      'Deine SSH-Zugangsdaten sind nicht geschützt. Richte eine PIN oder biometrische Sperre in den Einstellungen ein.';

  @override
  String get securityBannerDismiss => 'Ausblenden';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSectionAppearance => 'Darstellung';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'SSH-Standards';

  @override
  String get settingsSectionSecurity => 'Sicherheit';

  @override
  String get settingsSectionExport => 'Export';

  @override
  String get settingsSectionAbout => 'Über';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsTerminalTheme => 'Terminal-Design';

  @override
  String get settingsTerminalThemeDefault => 'Standard Dunkel';

  @override
  String get settingsFontSize => 'Schriftgröße';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Standard-Port';

  @override
  String get settingsDefaultPortDialog => 'Standard-SSH-Port';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Standard-Benutzername';

  @override
  String get settingsDefaultUsernameDialog => 'Standard-Benutzername';

  @override
  String get settingsUsernameLabel => 'Benutzername';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Automatische Sperre';

  @override
  String get settingsAutoLockDisabled => 'Deaktiviert';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes Minuten';
  }

  @override
  String get settingsAutoLockOff => 'Aus';

  @override
  String get settingsAutoLock1Min => '1 Min';

  @override
  String get settingsAutoLock5Min => '5 Min';

  @override
  String get settingsAutoLock15Min => '15 Min';

  @override
  String get settingsAutoLock30Min => '30 Min';

  @override
  String get settingsBiometricUnlock => 'Biometrische Entsperrung';

  @override
  String get settingsBiometricNotAvailable =>
      'Auf diesem Gerät nicht verfügbar';

  @override
  String get settingsBiometricError => 'Fehler bei der Biometrie-Prüfung';

  @override
  String get settingsBiometricReason =>
      'Bestätige deine Identität, um die biometrische Entsperrung zu aktivieren';

  @override
  String get settingsBiometricRequiresPin =>
      'Lege zuerst eine PIN fest, um die biometrische Entsperrung zu aktivieren';

  @override
  String get settingsPinCode => 'PIN-Code';

  @override
  String get settingsPinIsSet => 'PIN ist gesetzt';

  @override
  String get settingsPinNotConfigured => 'Keine PIN konfiguriert';

  @override
  String get settingsPinRemove => 'Entfernen';

  @override
  String get settingsPinRemoveWarning =>
      'Das Entfernen der PIN entschlüsselt alle Datenbankfelder und deaktiviert die biometrische Entsperrung. Fortfahren?';

  @override
  String get settingsPinRemoveTitle => 'PIN entfernen';

  @override
  String get settingsPreventScreenshots => 'Screenshots verhindern';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Screenshots und Bildschirmaufnahmen blockieren';

  @override
  String get settingsEncryptExport => 'Exporte standardmäßig verschlüsseln';

  @override
  String get settingsAbout => 'Über SSHVault';

  @override
  String get settingsAboutLegalese => 'von Kiefer Networks';

  @override
  String get settingsAboutDescription =>
      'Sicherer, selbst-gehosteter SSH-Client';

  @override
  String get settingsLanguage => 'Sprache';

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
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get close => 'Schließen';

  @override
  String get update => 'Aktualisieren';

  @override
  String get create => 'Erstellen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get copy => 'Kopieren';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Fehler: $message';
  }

  @override
  String get serverListTitle => 'Hosts';

  @override
  String get serverListEmpty => 'Noch keine Server';

  @override
  String get serverListEmptySubtitle => 'Füge deinen ersten SSH-Server hinzu.';

  @override
  String get serverAddButton => 'Server hinzufügen';

  @override
  String sshConfigImportMessage(int count) {
    return '$count Host(s) in ~/.ssh/config gefunden. Importieren?';
  }

  @override
  String get sshConfigNotFound => 'Keine SSH-Konfigurationsdatei gefunden';

  @override
  String get sshConfigEmpty => 'Keine Hosts in der SSH-Konfiguration gefunden';

  @override
  String get sshConfigAddManually => 'Manuell hinzufügen';

  @override
  String get sshConfigImportAgain => 'SSH-Konfiguration erneut importieren?';

  @override
  String get sshConfigImportKeys =>
      'SSH-Schlüssel der ausgewählten Hosts importieren?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH-Schlüssel importiert';
  }

  @override
  String get serverDuplicated => 'Server dupliziert';

  @override
  String get serverDeleteTitle => 'Server löschen';

  @override
  String serverDeleteMessage(String name) {
    return 'Möchtest du \"$name\" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String serverDeleteShort(String name) {
    return '\"$name\" löschen?';
  }

  @override
  String get serverConnect => 'Verbinden';

  @override
  String get serverDetails => 'Details';

  @override
  String get serverDuplicate => 'Duplizieren';

  @override
  String get serverActive => 'Aktiv';

  @override
  String get serverNoFolder => 'Kein Ordner';

  @override
  String get serverFormTitleEdit => 'Server bearbeiten';

  @override
  String get serverFormTitleAdd => 'Server hinzufügen';

  @override
  String get serverSaved => 'Server gespeichert';

  @override
  String get serverFormUpdateButton => 'Server aktualisieren';

  @override
  String get serverFormAddButton => 'Server hinzufügen';

  @override
  String get serverFormPublicKeyExtracted =>
      'Öffentlicher Schlüssel erfolgreich extrahiert';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Öffentlicher Schlüssel konnte nicht extrahiert werden: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type-Schlüsselpaar generiert';
  }

  @override
  String get serverDetailTitle => 'Server-Details';

  @override
  String get serverDetailDeleteMessage =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get serverDetailConnection => 'Verbindung';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Benutzername';

  @override
  String get serverDetailFolder => 'Ordner';

  @override
  String get serverDetailTags => 'Tags';

  @override
  String get serverDetailNotes => 'Notizen';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Erstellt';

  @override
  String get serverDetailUpdated => 'Aktualisiert';

  @override
  String get serverDetailDistro => 'System';

  @override
  String get copiedToClipboard => 'In die Zwischenablage kopiert';

  @override
  String get serverFormNameLabel => 'Servername';

  @override
  String get serverFormHostnameLabel => 'Hostname / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Benutzername';

  @override
  String get serverFormPasswordLabel => 'Passwort';

  @override
  String get serverFormUseManagedKey => 'Verwalteten Schlüssel verwenden';

  @override
  String get serverFormManagedKeySubtitle =>
      'Aus zentral verwalteten SSH-Schlüsseln auswählen';

  @override
  String get serverFormDirectKeySubtitle =>
      'Schlüssel direkt für diesen Server einfügen';

  @override
  String get serverFormGenerateKey => 'SSH-Schlüsselpaar generieren';

  @override
  String get serverFormPrivateKeyLabel => 'Privater Schlüssel';

  @override
  String get serverFormPrivateKeyHint => 'SSH-Privatschlüssel einfügen...';

  @override
  String get serverFormExtractPublicKey => 'Öffentlichen Schlüssel extrahieren';

  @override
  String get serverFormPublicKeyLabel => 'Öffentlicher Schlüssel';

  @override
  String get serverFormPublicKeyHint =>
      'Wird automatisch aus dem privaten Schlüssel generiert';

  @override
  String get serverFormPassphraseLabel => 'Schlüssel-Passphrase (optional)';

  @override
  String get serverFormNotesLabel => 'Notizen (optional)';

  @override
  String get searchServers => 'Server suchen...';

  @override
  String get filterAllFolders => 'Alle Ordner';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterActive => 'Aktiv';

  @override
  String get filterInactive => 'Inaktiv';

  @override
  String get filterClear => 'Zurücksetzen';

  @override
  String get folderListTitle => 'Ordner';

  @override
  String get folderListEmpty => 'Noch keine Ordner';

  @override
  String get folderListEmptySubtitle =>
      'Erstelle Ordner, um deine Server zu organisieren.';

  @override
  String get folderAddButton => 'Ordner erstellen';

  @override
  String get folderDeleteTitle => 'Ordner löschen';

  @override
  String folderDeleteMessage(String name) {
    return '\"$name\" löschen? Server werden unsortiert.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Server',
      one: '1 Server',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Einklappen';

  @override
  String get folderShowHosts => 'Hosts anzeigen';

  @override
  String get folderConnectAll => 'Alle verbinden';

  @override
  String get folderFormTitleEdit => 'Ordner bearbeiten';

  @override
  String get folderFormTitleNew => 'Neuer Ordner';

  @override
  String get folderFormNameLabel => 'Ordnername';

  @override
  String get folderFormParentLabel => 'Übergeordneter Ordner';

  @override
  String get folderFormParentNone => 'Ohne (Root)';

  @override
  String get tagListTitle => 'Tags';

  @override
  String get tagListEmpty => 'Noch keine Tags';

  @override
  String get tagListEmptySubtitle =>
      'Erstelle Tags, um deine Server zu kennzeichnen und zu filtern.';

  @override
  String get tagAddButton => 'Tag hinzufügen';

  @override
  String get tagDeleteTitle => 'Tag löschen';

  @override
  String tagDeleteMessage(String name) {
    return '\"$name\" löschen? Es wird von allen Servern entfernt.';
  }

  @override
  String get tagFormTitleEdit => 'Tag bearbeiten';

  @override
  String get tagFormTitleNew => 'Neuer Tag';

  @override
  String get tagFormNameLabel => 'Tag-Name';

  @override
  String get sshKeyListTitle => 'SSH-Schlüssel';

  @override
  String get sshKeyListEmpty => 'Noch keine SSH-Schlüssel';

  @override
  String get sshKeyListEmptySubtitle =>
      'Generiere oder importiere SSH-Schlüssel zur zentralen Verwaltung';

  @override
  String get sshKeyCannotDeleteTitle => 'Löschen nicht möglich';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return '\"$name\" kann nicht gelöscht werden. Wird von $count Server(n) verwendet. Zuerst von allen Servern trennen.';
  }

  @override
  String get sshKeyDeleteTitle => 'SSH-Schlüssel löschen';

  @override
  String sshKeyDeleteMessage(String name) {
    return '\"$name\" löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get sshKeyAddButton => 'SSH-Schlüssel hinzufügen';

  @override
  String get sshKeyFormTitleEdit => 'SSH-Schlüssel bearbeiten';

  @override
  String get sshKeyFormTitleAdd => 'SSH-Schlüssel hinzufügen';

  @override
  String get sshKeyFormTabGenerate => 'Generieren';

  @override
  String get sshKeyFormTabImport => 'Importieren';

  @override
  String get sshKeyFormNameLabel => 'Schlüsselname';

  @override
  String get sshKeyFormNameHint => 'z.B. Mein Produktionsschlüssel';

  @override
  String get sshKeyFormKeyType => 'Schlüsseltyp';

  @override
  String get sshKeyFormKeySize => 'Schlüsselgröße';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits Bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Kommentar';

  @override
  String get sshKeyFormCommentHint => 'benutzer@host oder Beschreibung';

  @override
  String get sshKeyFormCommentOptional => 'Kommentar (optional)';

  @override
  String get sshKeyFormImportFromFile => 'Aus Datei importieren';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Privater Schlüssel';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'SSH-Privatschlüssel einfügen oder Schaltfläche oben verwenden...';

  @override
  String get sshKeyFormPassphraseLabel => 'Passphrase (optional)';

  @override
  String get sshKeyFormNameRequired => 'Name ist erforderlich';

  @override
  String get sshKeyFormPrivateKeyRequired =>
      'Privater Schlüssel ist erforderlich';

  @override
  String get sshKeyFormFileReadError =>
      'Die ausgewählte Datei konnte nicht gelesen werden';

  @override
  String get sshKeyFormInvalidFormat =>
      'Ungültiges Schlüsselformat — PEM-Format erwartet (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Datei konnte nicht gelesen werden: $message';
  }

  @override
  String get sshKeyFormSaving => 'Speichert...';

  @override
  String get sshKeySelectorLabel => 'SSH-Schlüssel';

  @override
  String get sshKeySelectorNone => 'Kein verwalteter Schlüssel';

  @override
  String get sshKeySelectorManage => 'Schlüssel verwalten...';

  @override
  String get sshKeySelectorError =>
      'SSH-Schlüssel konnten nicht geladen werden';

  @override
  String get sshKeyTileCopyPublicKey => 'Öffentlichen Schlüssel kopieren';

  @override
  String get sshKeyTilePublicKeyCopied => 'Öffentlicher Schlüssel kopiert';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Verwendet von $count Server(n)';
  }

  @override
  String get sshKeySavedSuccess => 'SSH-Schlüssel gespeichert';

  @override
  String get sshKeyDeletedSuccess => 'SSH-Schlüssel gelöscht';

  @override
  String get tagSavedSuccess => 'Tag gespeichert';

  @override
  String get tagDeletedSuccess => 'Tag gelöscht';

  @override
  String get folderDeletedSuccess => 'Ordner gelöscht';

  @override
  String get sshKeyTileUnlinkFirst => 'Zuerst von allen Servern trennen';

  @override
  String get exportImportTitle => 'Export / Import';

  @override
  String get exportSectionTitle => 'Export';

  @override
  String get exportJsonButton => 'Als JSON exportieren (ohne Zugangsdaten)';

  @override
  String get exportZipButton =>
      'Verschlüsseltes ZIP exportieren (mit Zugangsdaten)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Aus Datei importieren';

  @override
  String get importSupportedFormats =>
      'Unterstützt JSON- (unverschlüsselt) und ZIP-Dateien (verschlüsselt).';

  @override
  String exportedTo(String path) {
    return 'Exportiert nach: $path';
  }

  @override
  String get share => 'Teilen';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers Server, $groups Gruppen, $tags Tags importiert. $skipped übersprungen.';
  }

  @override
  String get importPasswordTitle => 'Passwort eingeben';

  @override
  String get importPasswordLabel => 'Export-Passwort';

  @override
  String get importPasswordDecrypt => 'Entschlüsseln';

  @override
  String get exportPasswordTitle => 'Export-Passwort festlegen';

  @override
  String get exportPasswordDescription =>
      'Dieses Passwort wird verwendet, um deine Exportdatei einschließlich der Zugangsdaten zu verschlüsseln.';

  @override
  String get exportPasswordLabel => 'Passwort';

  @override
  String get exportPasswordConfirmLabel => 'Passwort bestätigen';

  @override
  String get exportPasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get exportPasswordButton => 'Verschlüsseln & Exportieren';

  @override
  String get importConflictTitle => 'Konflikte behandeln';

  @override
  String get importConflictDescription =>
      'Wie sollen vorhandene Einträge beim Import behandelt werden?';

  @override
  String get importConflictSkip => 'Vorhandene überspringen';

  @override
  String get importConflictRename => 'Neue umbenennen';

  @override
  String get importConflictOverwrite => 'Überschreiben';

  @override
  String get confirmDeleteLabel => 'Löschen';

  @override
  String get keyGenTitle => 'SSH-Schlüsselpaar generieren';

  @override
  String get keyGenKeyType => 'Schlüsseltyp';

  @override
  String get keyGenKeySize => 'Schlüsselgröße';

  @override
  String get keyGenComment => 'Kommentar';

  @override
  String get keyGenCommentHint => 'benutzer@host oder Beschreibung';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits Bit';
  }

  @override
  String get keyGenGenerating => 'Generiert...';

  @override
  String get keyGenGenerate => 'Generieren';

  @override
  String keyGenResultTitle(String type) {
    return '$type-Schlüssel generiert';
  }

  @override
  String get keyGenPublicKey => 'Öffentlicher Schlüssel';

  @override
  String get keyGenPrivateKey => 'Privater Schlüssel';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Kommentar: $comment';
  }

  @override
  String get keyGenAnother => 'Neuen generieren';

  @override
  String get keyGenUseThisKey => 'Diesen Schlüssel verwenden';

  @override
  String get keyGenCopyTooltip => 'In die Zwischenablage kopieren';

  @override
  String keyGenCopied(String label) {
    return '$label kopiert';
  }

  @override
  String get colorPickerLabel => 'Farbe';

  @override
  String get iconPickerLabel => 'Symbol';

  @override
  String get tagSelectorLabel => 'Tags';

  @override
  String get tagSelectorEmpty => 'Noch keine Tags';

  @override
  String get tagSelectorError => 'Tags konnten nicht geladen werden';

  @override
  String get snippetListTitle => 'Snippets';

  @override
  String get snippetSearchHint => 'Snippets suchen...';

  @override
  String get snippetListEmpty => 'Noch keine Snippets';

  @override
  String get snippetListEmptySubtitle =>
      'Erstelle wiederverwendbare Code-Snippets und Befehle.';

  @override
  String get snippetAddButton => 'Snippet hinzufügen';

  @override
  String get snippetDeleteTitle => 'Snippet löschen';

  @override
  String snippetDeleteMessage(String name) {
    return '\"$name\" löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get snippetFormTitleEdit => 'Snippet bearbeiten';

  @override
  String get snippetFormTitleNew => 'Neues Snippet';

  @override
  String get snippetFormNameLabel => 'Name';

  @override
  String get snippetFormNameHint => 'z.B. Docker aufräumen';

  @override
  String get snippetFormLanguageLabel => 'Sprache';

  @override
  String get snippetFormContentLabel => 'Inhalt';

  @override
  String get snippetFormContentHint => 'Snippet-Code eingeben...';

  @override
  String get snippetFormDescriptionLabel => 'Beschreibung';

  @override
  String get snippetFormDescriptionHint => 'Optionale Beschreibung...';

  @override
  String get snippetFormFolderLabel => 'Ordner';

  @override
  String get snippetFormNoFolder => 'Kein Ordner';

  @override
  String get snippetFormNameRequired => 'Name ist erforderlich';

  @override
  String get snippetFormContentRequired => 'Inhalt ist erforderlich';

  @override
  String get snippetFormSaved => 'Snippet gespeichert';

  @override
  String get snippetFormUpdateButton => 'Snippet aktualisieren';

  @override
  String get snippetFormCreateButton => 'Snippet erstellen';

  @override
  String get snippetDetailTitle => 'Snippet-Details';

  @override
  String get snippetDetailDeleteTitle => 'Snippet löschen';

  @override
  String get snippetDetailDeleteMessage =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get snippetDetailContent => 'Inhalt';

  @override
  String get snippetDetailFillVariables => 'Variablen ausfüllen';

  @override
  String get snippetDetailDescription => 'Beschreibung';

  @override
  String get snippetDetailVariables => 'Variablen';

  @override
  String get snippetDetailTags => 'Tags';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Erstellt';

  @override
  String get snippetDetailUpdated => 'Aktualisiert';

  @override
  String get variableEditorTitle => 'Vorlagen-Variablen';

  @override
  String get variableEditorAdd => 'Hinzufügen';

  @override
  String get variableEditorEmpty =>
      'Keine Variablen. Verwende geschweifte Klammern im Inhalt, um sie zu referenzieren.';

  @override
  String get variableEditorNameLabel => 'Name';

  @override
  String get variableEditorNameHint => 'z.B. hostname';

  @override
  String get variableEditorDefaultLabel => 'Standard';

  @override
  String get variableEditorDefaultHint => 'optional';

  @override
  String get variableFillTitle => 'Variablen ausfüllen';

  @override
  String variableFillHint(String name) {
    return 'Wert für $name eingeben';
  }

  @override
  String get variableFillPreview => 'Vorschau';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Keine aktiven Sitzungen';

  @override
  String get terminalEmptySubtitle =>
      'Verbinde dich mit einem Host, um eine Terminal-Sitzung zu öffnen.';

  @override
  String get terminalGoToHosts => 'Zu den Hosts';

  @override
  String get terminalCloseAll => 'Alle Sitzungen schließen';

  @override
  String get terminalCloseTitle => 'Sitzung schließen';

  @override
  String terminalCloseMessage(String title) {
    return 'Die aktive Verbindung zu \"$title\" trennen?';
  }

  @override
  String get connectionAuthenticating => 'Authentifizierung...';

  @override
  String connectionConnecting(String name) {
    return 'Verbindung zu $name...';
  }

  @override
  String get connectionError => 'Verbindungsfehler';

  @override
  String get connectionLost => 'Verbindung verloren';

  @override
  String get connectionReconnect => 'Erneut verbinden';

  @override
  String get snippetQuickPanelTitle => 'Snippet einfügen';

  @override
  String get snippetQuickPanelSearch => 'Snippets suchen...';

  @override
  String get snippetQuickPanelEmpty => 'Keine Snippets verfügbar';

  @override
  String get snippetQuickPanelNoMatch => 'Keine passenden Snippets';

  @override
  String get snippetQuickPanelInsertTooltip => 'Snippet einfügen';

  @override
  String get terminalThemePickerTitle => 'Terminal-Design';

  @override
  String get validatorHostnameRequired => 'Hostname ist erforderlich';

  @override
  String get validatorHostnameInvalid => 'Ungültiger Hostname oder IP-Adresse';

  @override
  String get validatorPortRequired => 'Port ist erforderlich';

  @override
  String get validatorPortRange => 'Port muss zwischen 1 und 65535 liegen';

  @override
  String get validatorUsernameRequired => 'Benutzername ist erforderlich';

  @override
  String get validatorUsernameInvalid => 'Ungültiges Benutzernamen-Format';

  @override
  String get validatorServerNameRequired => 'Servername ist erforderlich';

  @override
  String get validatorServerNameLength =>
      'Servername darf maximal 100 Zeichen lang sein';

  @override
  String get validatorSshKeyInvalid => 'Ungültiges SSH-Schlüsselformat';

  @override
  String get validatorPasswordRequired => 'Passwort ist erforderlich';

  @override
  String get validatorPasswordLength =>
      'Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get authMethodPassword => 'Passwort';

  @override
  String get authMethodKey => 'SSH-Schlüssel';

  @override
  String get authMethodBoth => 'Passwort + Schlüssel';

  @override
  String get serverCopySuffix => '(Kopie)';

  @override
  String get settingsDownloadLogs => 'Protokolle herunterladen';

  @override
  String get settingsSendLogs => 'Protokolle an Support senden';

  @override
  String get settingsLogsSaved => 'Protokolle erfolgreich gespeichert';

  @override
  String get settingsUpdated => 'Einstellung aktualisiert';

  @override
  String get settingsThemeChanged => 'Design geändert';

  @override
  String get settingsLanguageChanged => 'Sprache geändert';

  @override
  String get settingsPinSetSuccess => 'PIN gesetzt';

  @override
  String get settingsPinRemovedSuccess => 'PIN entfernt';

  @override
  String get settingsDuressPinSetSuccess => 'Duress-PIN gesetzt';

  @override
  String get settingsDuressPinRemovedSuccess => 'Duress-PIN entfernt';

  @override
  String get settingsBiometricEnabled => 'Biometrische Entsperrung aktiviert';

  @override
  String get settingsBiometricDisabled =>
      'Biometrische Entsperrung deaktiviert';

  @override
  String get settingsDnsServerAdded => 'DNS-Server hinzugefügt';

  @override
  String get settingsDnsServerRemoved => 'DNS-Server entfernt';

  @override
  String get settingsDnsResetSuccess => 'DNS-Server zurückgesetzt';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Schriftgröße verringern';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Schriftgröße vergrößern';

  @override
  String get settingsDnsRemoveServerTooltip => 'DNS-Server entfernen';

  @override
  String get settingsLogsEmpty => 'Keine Protokolleinträge vorhanden';

  @override
  String get authLogin => 'Anmelden';

  @override
  String get authRegister => 'Registrieren';

  @override
  String get authForgotPassword => 'Passwort vergessen?';

  @override
  String get authWhyLogin =>
      'Melde dich an, um verschlüsselte Cloud-Synchronisation auf allen Geräten zu aktivieren. Die App funktioniert auch ohne Konto komplett offline.';

  @override
  String get authEmailLabel => 'E-Mail';

  @override
  String get authEmailRequired => 'E-Mail ist erforderlich';

  @override
  String get authEmailInvalid => 'Ungültige E-Mail-Adresse';

  @override
  String get authPasswordLabel => 'Passwort';

  @override
  String get authConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get authPasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get authNoAccount => 'Kein Konto?';

  @override
  String get authHasAccount => 'Bereits ein Konto?';

  @override
  String get authResetEmailSent =>
      'Falls ein Konto existiert, wurde ein Rücksetz-Link an deine E-Mail gesendet.';

  @override
  String get authResetDescription =>
      'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen deines Passworts.';

  @override
  String get authSendResetLink => 'Rücksetz-Link senden';

  @override
  String get authBackToLogin => 'Zurück zur Anmeldung';

  @override
  String get syncPasswordTitle => 'Sync-Passwort';

  @override
  String get syncPasswordTitleCreate => 'Sync-Passwort festlegen';

  @override
  String get syncPasswordTitleEnter => 'Sync-Passwort eingeben';

  @override
  String get syncPasswordDescription =>
      'Lege ein separates Passwort fest, um deine Vault-Daten zu verschlüsseln. Dieses Passwort verlässt niemals dein Gerät — der Server speichert nur verschlüsselte Daten.';

  @override
  String get syncPasswordHintEnter =>
      'Gib das Passwort ein, das du bei der Kontoerstellung festgelegt hast.';

  @override
  String get syncPasswordWarning =>
      'Wenn du dieses Passwort vergisst, können deine synchronisierten Daten nicht wiederhergestellt werden. Es gibt keine Rücksetz-Option.';

  @override
  String get syncPasswordLabel => 'Sync-Passwort';

  @override
  String get syncPasswordWrong => 'Falsches Passwort. Bitte erneut versuchen.';

  @override
  String get firstSyncTitle => 'Vorhandene Daten gefunden';

  @override
  String get firstSyncMessage =>
      'Dieses Gerät hat vorhandene Daten und der Server hat einen Vault. Wie sollen wir fortfahren?';

  @override
  String get firstSyncMerge => 'Zusammenführen (Server hat Priorität)';

  @override
  String get firstSyncOverwriteLocal => 'Lokale Daten überschreiben';

  @override
  String get firstSyncKeepLocal => 'Lokal behalten & hochladen';

  @override
  String get firstSyncDeleteLocal => 'Lokal löschen & herunterladen';

  @override
  String get changeEncryptionPassword => 'Verschlüsselungspasswort ändern';

  @override
  String get changeEncryptionWarning =>
      'Du wirst auf allen anderen Geräten abgemeldet.';

  @override
  String get changeEncryptionOldPassword => 'Aktuelles Passwort';

  @override
  String get changeEncryptionNewPassword => 'Neues Passwort';

  @override
  String get changeEncryptionSuccess => 'Passwort erfolgreich geändert.';

  @override
  String get logoutAllDevices => 'Von allen Geräten abmelden';

  @override
  String get logoutAllDevicesConfirm =>
      'Dies widerruft alle aktiven Sitzungen. Du musst dich auf allen Geräten erneut anmelden.';

  @override
  String get logoutAllDevicesSuccess => 'Alle Geräte abgemeldet.';

  @override
  String get syncSettingsTitle => 'Sync-Einstellungen';

  @override
  String get syncAutoSync => 'Auto-Sync';

  @override
  String get syncAutoSyncDescription =>
      'Automatisch synchronisieren beim App-Start';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get syncSyncing => 'Synchronisiert...';

  @override
  String get syncSuccess => 'Synchronisierung abgeschlossen';

  @override
  String get syncError => 'Sync-Fehler';

  @override
  String get syncServerUnreachable => 'Server nicht erreichbar';

  @override
  String get syncServerUnreachableHint =>
      'Der Sync-Server konnte nicht erreicht werden. Prüfe deine Internetverbindung und die Server-URL.';

  @override
  String get syncNetworkError =>
      'Verbindung zum Server fehlgeschlagen. Bitte prüfe deine Internetverbindung oder versuche es später erneut.';

  @override
  String get syncNeverSynced => 'Noch nie synchronisiert';

  @override
  String get syncVaultVersion => 'Vault-Version';

  @override
  String get syncBackgroundSync => 'Im Hintergrund synchronisieren';

  @override
  String get syncBackgroundSyncDescription =>
      'Vault-Sync periodisch via WorkManager auch bei geschlossener App.';

  @override
  String get syncTitle => 'Sync';

  @override
  String get settingsSectionNetwork => 'Netzwerk & DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS Server';

  @override
  String get settingsDnsDefault => 'Standard (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Gib benutzerdefinierte DoH-Server-URLs ein, getrennt durch Kommas. Mindestens 2 Server werden für die Kreuzprüfung benötigt.';

  @override
  String get settingsDnsLabel => 'DoH-Server-URLs';

  @override
  String get settingsDnsReset => 'Auf Standard zurücksetzen';

  @override
  String get settingsSectionSync => 'Synchronisierung';

  @override
  String get settingsSyncAccount => 'Konto';

  @override
  String get settingsSyncNotLoggedIn => 'Nicht angemeldet';

  @override
  String get settingsSyncStatus => 'Sync';

  @override
  String get settingsSyncServerUrl => 'Server-URL';

  @override
  String get settingsSyncDefaultServer => 'Standard (sshvault.app)';

  @override
  String get accountTitle => 'Konto';

  @override
  String get accountNotLoggedIn => 'Nicht angemeldet';

  @override
  String get accountVerified => 'Verifiziert';

  @override
  String get accountMemberSince => 'Mitglied seit';

  @override
  String get accountDevices => 'Geräte';

  @override
  String get accountNoDevices => 'Keine Geräte registriert';

  @override
  String get accountLastSync => 'Letzte Sync';

  @override
  String get accountChangePassword => 'Passwort ändern';

  @override
  String get accountOldPassword => 'Aktuelles Passwort';

  @override
  String get accountNewPassword => 'Neues Passwort';

  @override
  String get accountDeleteAccount => 'Konto löschen';

  @override
  String get accountDeleteWarning =>
      'Dies löscht dein Konto und alle synchronisierten Daten unwiderruflich.';

  @override
  String get accountLogout => 'Abmelden';

  @override
  String get serverConfigTitle => 'Server-Konfiguration';

  @override
  String get serverConfigUrlLabel => 'Server-URL';

  @override
  String get serverConfigTest => 'Verbindung testen';

  @override
  String get serverSetupTitle => 'Server einrichten';

  @override
  String get serverSetupInfoCard =>
      'ShellVault benötigt einen selbst gehosteten Server für Ende-zu-Ende-verschlüsselte Synchronisation. Stelle deine eigene Instanz bereit, um loszulegen.';

  @override
  String get serverSetupRepoLink => 'Auf GitHub ansehen';

  @override
  String get serverSetupContinue => 'Weiter';

  @override
  String get settingsServerNotConfigured => 'Kein Server konfiguriert';

  @override
  String get settingsSetupSync => 'Sync einrichten, um deine Daten zu sichern';

  @override
  String get settingsChangeServer => 'Server wechseln';

  @override
  String get settingsChangeServerConfirm =>
      'Ein Serverwechsel meldet dich ab. Fortfahren?';

  @override
  String get auditLogTitle => 'Aktivitätsprotokoll';

  @override
  String get auditLogAll => 'Alle';

  @override
  String get auditLogEmpty => 'Keine Aktivitätsprotokolle gefunden';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Dateimanager';

  @override
  String get sftpLocalDevice => 'Lokales Gerät';

  @override
  String get sftpSelectServer => 'Server auswählen...';

  @override
  String get sftpConnecting => 'Verbinde...';

  @override
  String get sftpEmptyDirectory => 'Dieses Verzeichnis ist leer';

  @override
  String get sftpNoConnection => 'Kein Server verbunden';

  @override
  String get sftpPathLabel => 'Pfad';

  @override
  String get sftpUpload => 'Hochladen';

  @override
  String get sftpDownload => 'Herunterladen';

  @override
  String get sftpDelete => 'Löschen';

  @override
  String get sftpRename => 'Umbenennen';

  @override
  String get sftpNewFolder => 'Neuer Ordner';

  @override
  String get sftpNewFolderName => 'Ordnername';

  @override
  String get sftpChmod => 'Berechtigungen';

  @override
  String get sftpChmodTitle => 'Berechtigungen ändern';

  @override
  String get sftpChmodOctal => 'Oktal';

  @override
  String get sftpChmodOwner => 'Besitzer';

  @override
  String get sftpChmodGroup => 'Gruppe';

  @override
  String get sftpChmodOther => 'Andere';

  @override
  String get sftpChmodRead => 'Lesen';

  @override
  String get sftpChmodWrite => 'Schreiben';

  @override
  String get sftpChmodExecute => 'Ausführen';

  @override
  String get sftpCreateSymlink => 'Symlink erstellen';

  @override
  String get sftpSymlinkTarget => 'Zielpfad';

  @override
  String get sftpSymlinkName => 'Linkname';

  @override
  String get sftpFilePreview => 'Dateivorschau';

  @override
  String get sftpFileInfo => 'Dateiinfo';

  @override
  String get sftpFileSize => 'Größe';

  @override
  String get sftpFileModified => 'Geändert';

  @override
  String get sftpFilePermissions => 'Berechtigungen';

  @override
  String get sftpFileOwner => 'Besitzer';

  @override
  String get sftpFileType => 'Typ';

  @override
  String get sftpFileLinkTarget => 'Linkziel';

  @override
  String get sftpTransfers => 'Übertragungen';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current von $total';
  }

  @override
  String get sftpTransferQueued => 'Wartend';

  @override
  String get sftpTransferActive => 'Übertrage...';

  @override
  String get sftpTransferPaused => 'Pausiert';

  @override
  String get sftpTransferCompleted => 'Abgeschlossen';

  @override
  String get sftpTransferFailed => 'Fehlgeschlagen';

  @override
  String get sftpTransferCancelled => 'Abgebrochen';

  @override
  String get sftpPauseTransfer => 'Pausieren';

  @override
  String get sftpResumeTransfer => 'Fortsetzen';

  @override
  String get sftpCancelTransfer => 'Abbrechen';

  @override
  String get sftpClearCompleted => 'Abgeschlossene entfernen';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active von $total Übertragungen';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktiv',
      one: '1 aktiv',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count abgeschlossen',
      one: '1 abgeschlossen',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fehlgeschlagen',
      one: '1 fehlgeschlagen',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'In anderen Bereich kopieren';

  @override
  String sftpConfirmDelete(int count) {
    return '$count Elemente löschen?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return '\"$name\" löschen?';
  }

  @override
  String get sftpDeleteSuccess => 'Erfolgreich gelöscht';

  @override
  String get sftpRenameTitle => 'Umbenennen';

  @override
  String get sftpRenameLabel => 'Neuer Name';

  @override
  String get sftpSortByName => 'Name';

  @override
  String get sftpSortBySize => 'Größe';

  @override
  String get sftpSortByDate => 'Datum';

  @override
  String get sftpSortByType => 'Typ';

  @override
  String get sftpShowHidden => 'Versteckte Dateien anzeigen';

  @override
  String get sftpHideHidden => 'Versteckte Dateien ausblenden';

  @override
  String get sftpSelectAll => 'Alle auswählen';

  @override
  String get sftpDeselectAll => 'Auswahl aufheben';

  @override
  String sftpItemsSelected(int count) {
    return '$count ausgewählt';
  }

  @override
  String get sftpRefresh => 'Aktualisieren';

  @override
  String sftpConnectionError(String message) {
    return 'Verbindung fehlgeschlagen: $message';
  }

  @override
  String get sftpPermissionDenied => 'Zugriff verweigert';

  @override
  String sftpOperationFailed(String message) {
    return 'Vorgang fehlgeschlagen: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Datei existiert bereits';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" existiert bereits. Überschreiben?';
  }

  @override
  String get sftpOverwrite => 'Überschreiben';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Transfer gestartet: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'Wähle zuerst ein Ziel im anderen Bereich';

  @override
  String get sftpDirectoryTransferNotSupported => 'Ordner-Transfer kommt bald';

  @override
  String get sftpSelect => 'Auswählen';

  @override
  String get sftpOpen => 'Öffnen';

  @override
  String get sftpExtractArchive => 'Hier entpacken';

  @override
  String get sftpExtractSuccess => 'Archiv entpackt';

  @override
  String sftpExtractFailed(String message) {
    return 'Entpacken fehlgeschlagen: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Nicht unterstütztes Archivformat';

  @override
  String get sftpExtracting => 'Entpacke...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Uploads gestartet',
      one: 'Upload gestartet',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Downloads gestartet',
      one: 'Download gestartet',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" heruntergeladen';
  }

  @override
  String get sftpSavedToDownloads => 'Gespeichert in Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'In Dateien sichern';

  @override
  String get sftpFileSaved => 'Datei gespeichert';

  @override
  String get fileChooserOpenFile => 'Datei öffnen';

  @override
  String get fileChooserSaveFile => 'Datei speichern';

  @override
  String get fileChooserOpenDirectory => 'Ordner wählen';

  @override
  String get fileChooserImportArchive => 'Sicherung importieren';

  @override
  String get fileChooserImportSshConfig => 'SSH-Konfiguration importieren';

  @override
  String get fileChooserImportSettings => 'Einstellungen importieren';

  @override
  String get fileChooserPickKeyFile => 'SSH-Schlüsseldatei wählen';

  @override
  String get fileChooserUploadFiles => 'Dateien hochladen';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH-Sitzungen aktiv',
      one: 'SSH-Sitzung aktiv',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Tippen zum Terminal wechseln';

  @override
  String get settingsAccountAndSync => 'Konto & Sync';

  @override
  String get settingsAccountSubtitleAuth => 'Angemeldet';

  @override
  String get settingsAccountSubtitleUnauth => 'Nicht angemeldet';

  @override
  String get settingsSecuritySubtitle => 'Auto-Sperre, Biometrie, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Benutzer root';

  @override
  String get settingsAppearanceSubtitle => 'Design, Sprache, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Verschlüsselte Export-Standards';

  @override
  String get settingsAboutSubtitle => 'Version, Lizenzen';

  @override
  String get settingsSearchHint => 'Einstellungen durchsuchen...';

  @override
  String get settingsSearchNoResults => 'Keine Einstellungen gefunden';

  @override
  String get aboutDeveloper => 'Entwickelt von Kiefer Networks';

  @override
  String get aboutDonate => 'Spenden';

  @override
  String get aboutOpenSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get aboutWebsite => 'Webseite';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS verschlüsselt DNS-Anfragen und verhindert DNS-Spoofing. SSHVault prüft Hostnamen gegen mehrere Provider, um Angriffe zu erkennen.';

  @override
  String get settingsDnsAddServer => 'DNS-Server hinzufügen';

  @override
  String get settingsDnsServerUrl => 'Server-URL';

  @override
  String get settingsDnsDefaultBadge => 'Standard';

  @override
  String get settingsDnsResetDefaults => 'Auf Standards zurücksetzen';

  @override
  String get settingsDnsInvalidUrl => 'Bitte eine gültige HTTPS-URL eingeben';

  @override
  String get settingsDefaultAuthMethod => 'Authentifizierungsmethode';

  @override
  String get settingsAuthPassword => 'Passwort';

  @override
  String get settingsAuthKey => 'SSH-Schlüssel';

  @override
  String get settingsConnectionTimeout => 'Verbindungs-Timeout';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Keep-Alive-Intervall';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Kompression';

  @override
  String get settingsCompressionDescription =>
      'zlib-Kompression für SSH-Verbindungen aktivieren';

  @override
  String get settingsTerminalType => 'Terminal-Typ';

  @override
  String get settingsSectionConnection => 'Verbindung';

  @override
  String get settingsClipboardAutoClear => 'Zwischenablage automatisch löschen';

  @override
  String get settingsClipboardAutoClearOff => 'Aus';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Sitzungs-Timeout';

  @override
  String get settingsSessionTimeoutOff => 'Aus';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get settingsDuressPin => 'Notfall-PIN';

  @override
  String get settingsDuressPinDescription =>
      'Ein separater PIN, der bei Eingabe alle Daten löscht';

  @override
  String get settingsDuressPinSet => 'Notfall-PIN ist gesetzt';

  @override
  String get settingsDuressPinNotSet => 'Nicht konfiguriert';

  @override
  String get settingsDuressPinWarning =>
      'Die Eingabe dieses PINs löscht unwiderruflich alle lokalen Daten einschließlich Zugangsdaten, Schlüssel und Einstellungen.';

  @override
  String get settingsKeyRotationReminder => 'Schlüsselrotations-Erinnerung';

  @override
  String get settingsKeyRotationOff => 'Aus';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days Tage';
  }

  @override
  String get settingsFailedAttempts => 'Fehlgeschlagene PIN-Versuche';

  @override
  String get settingsSectionAppLock => 'App-Sperre';

  @override
  String get settingsSectionPrivacy => 'Datenschutz';

  @override
  String get settingsSectionReminders => 'Erinnerungen';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle => 'Export, Import & Backup';

  @override
  String get settingsExportJson => 'Als JSON exportieren';

  @override
  String get settingsExportEncrypted => 'Verschlüsselt exportieren';

  @override
  String get settingsImportFile => 'Aus Datei importieren';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Server filtern';

  @override
  String get filterApply => 'Filter anwenden';

  @override
  String get filterClearAll => 'Alle zurücksetzen';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Filter aktiv',
      one: '1 Filter aktiv',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Ordner';

  @override
  String get filterTags => 'Tags';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Aufgelöste Vorschau';

  @override
  String get variableInsert => 'Einfügen';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Server',
      one: '1 Server',
    );
    return '$_temp0';
  }

  @override
  String tagSnippetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Snippets',
      one: '1 Snippet',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sitzungen widerrufen.',
      one: '1 Sitzung widerrufen.',
    );
    return '$_temp0 Du wurdest abgemeldet.';
  }

  @override
  String get keyGenPassphrase => 'Passphrase';

  @override
  String get keyGenPassphraseHint =>
      'Optional — schützt den privaten Schlüssel';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Standard (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Ein Schlüssel mit demselben Fingerabdruck existiert bereits: \"$name\". Jeder SSH-Schlüssel muss einzigartig sein.';
  }

  @override
  String get sshKeyFingerprint => 'Fingerabdruck';

  @override
  String get sshKeyPublicKey => 'Öffentlicher Schlüssel';

  @override
  String get jumpHost => 'Sprunghost';

  @override
  String get jumpHostNone => 'Keiner';

  @override
  String get jumpHostLabel => 'Über Sprunghost verbinden';

  @override
  String get jumpHostSelfError =>
      'Ein Server kann nicht sein eigener Sprunghost sein';

  @override
  String get jumpHostConnecting => 'Verbinde mit Sprunghost…';

  @override
  String get jumpHostCircularError => 'Zirkuläre Sprunghost-Kette erkannt';

  @override
  String get logoutDialogTitle => 'Abmelden';

  @override
  String get logoutDialogMessage =>
      'Möchtest du alle lokalen Daten löschen? Server, SSH-Keys, Snippets und Einstellungen werden von diesem Gerät entfernt.';

  @override
  String get logoutOnly => 'Nur abmelden';

  @override
  String get logoutAndDelete => 'Abmelden & Daten löschen';

  @override
  String get changeAvatar => 'Avatar ändern';

  @override
  String get removeAvatar => 'Avatar entfernen';

  @override
  String get avatarUploadFailed => 'Avatar-Upload fehlgeschlagen';

  @override
  String get avatarTooLarge => 'Bild ist zu groß';

  @override
  String get deviceLastSeen => 'Zuletzt gesehen';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Server-URL kann nicht geändert werden, solange du angemeldet bist. Melde dich zuerst ab.';

  @override
  String get serverListNoFolder => 'Unsortiert';

  @override
  String get autoSyncInterval => 'Sync-Intervall';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get proxySettings => 'Proxy-Einstellungen';

  @override
  String get proxyType => 'Proxy-Typ';

  @override
  String get proxyNone => 'Kein Proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxy-Host';

  @override
  String get proxyPort => 'Proxy-Port';

  @override
  String get proxyUsername => 'Proxy-Benutzer';

  @override
  String get proxyPassword => 'Proxy-Passwort';

  @override
  String get proxyUseGlobal => 'Globalen Proxy nutzen';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Server-spezifisch';

  @override
  String get proxyTestConnection => 'Verbindung testen';

  @override
  String get proxyTestSuccess => 'Proxy erreichbar';

  @override
  String get proxyTestFailed => 'Proxy nicht erreichbar';

  @override
  String get proxyDefaultProxy => 'Standard-Proxy';

  @override
  String get vpnRequired => 'VPN erforderlich';

  @override
  String get vpnRequiredTooltip =>
      'Warnung anzeigen, wenn ohne aktives VPN verbunden wird';

  @override
  String get vpnActive => 'VPN aktiv';

  @override
  String get vpnInactive => 'VPN inaktiv';

  @override
  String get vpnWarningTitle => 'VPN nicht aktiv';

  @override
  String get vpnWarningMessage =>
      'Dieser Server erfordert eine VPN-Verbindung, aber es ist kein VPN aktiv. Trotzdem verbinden?';

  @override
  String get vpnConnectAnyway => 'Trotzdem verbinden';

  @override
  String get postConnectCommands => 'Post-Connect Befehle';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Befehle, die nach dem Verbindungsaufbau automatisch ausgeführt werden (einer pro Zeile)';

  @override
  String get dashboardFavorites => 'Favoriten';

  @override
  String get dashboardRecent => 'Zuletzt verbunden';

  @override
  String get dashboardActiveSessions => 'Aktive Sitzungen';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get noRecentConnections => 'Keine kürzlichen Verbindungen';

  @override
  String get terminalSplit => 'Geteilte Ansicht';

  @override
  String get terminalUnsplit => 'Teilung schließen';

  @override
  String get terminalSelectSession => 'Sitzung für geteilte Ansicht auswählen';

  @override
  String get knownHostsTitle => 'Bekannte Hosts';

  @override
  String get knownHostsSubtitle =>
      'Vertrauenswürdige Server-Fingerprints verwalten';

  @override
  String get hostKeyNewTitle => 'Neuer Host';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Erste Verbindung zu $hostname:$port. Überprüfe den Fingerprint vor der Verbindung.';
  }

  @override
  String get hostKeyChangedTitle => 'Host-Key geändert!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Der Host-Key für $hostname:$port hat sich geändert. Dies könnte auf eine Sicherheitsbedrohung hinweisen.';
  }

  @override
  String get hostKeyFingerprint => 'Fingerprint';

  @override
  String get hostKeyType => 'Key-Typ';

  @override
  String get hostKeyTrustConnect => 'Vertrauen & Verbinden';

  @override
  String get hostKeyAcceptNew => 'Neuen Key akzeptieren';

  @override
  String get hostKeyReject => 'Ablehnen';

  @override
  String get hostKeyPreviousFingerprint => 'Vorheriger Fingerprint';

  @override
  String get hostKeyDeleteAll => 'Alle bekannten Hosts löschen';

  @override
  String get hostKeyDeleteConfirm =>
      'Bist du sicher, dass du alle bekannten Hosts entfernen möchtest? Du wirst bei der nächsten Verbindung erneut gefragt.';

  @override
  String get hostKeyEmpty => 'Noch keine bekannten Hosts';

  @override
  String get hostKeyEmptySubtitle =>
      'Host-Fingerprints werden hier nach deiner ersten Verbindung gespeichert';

  @override
  String get hostKeyFirstSeen => 'Erstmals gesehen';

  @override
  String get hostKeyLastSeen => 'Zuletzt gesehen';

  @override
  String get sshConfigImportTitle => 'SSH-Config importieren';

  @override
  String get sshConfigImportPickFile => 'SSH-Config-Datei auswählen';

  @override
  String get sshConfigImportOrPaste => 'Oder Config-Inhalt einfügen';

  @override
  String sshConfigImportParsed(int count) {
    return '$count Hosts gefunden';
  }

  @override
  String get sshConfigImportButton => 'Ausgewählte importieren';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count Server importiert';
  }

  @override
  String get sshConfigImportDuplicate => 'Existiert bereits';

  @override
  String get sshConfigImportNoHosts => 'Keine Hosts in der Config gefunden';

  @override
  String get sftpBookmarkAdd => 'Lesezeichen hinzufügen';

  @override
  String get sftpBookmarkLabel => 'Bezeichnung';

  @override
  String get disconnect => 'Trennen';

  @override
  String get reportAndDisconnect => 'Melden & Trennen';

  @override
  String get continueAnyway => 'Trotzdem fortfahren';

  @override
  String get insertSnippet => 'Snippet einfügen';

  @override
  String get seconds => 'Sekunden';

  @override
  String get heartbeatLostMessage =>
      'Der Server konnte nach mehreren Versuchen nicht erreicht werden. Zu deiner Sicherheit wurde die Sitzung beendet.';

  @override
  String get attestationFailedTitle => 'Server-Verifizierung fehlgeschlagen';

  @override
  String get attestationFailedMessage =>
      'Der Server konnte nicht als legitimes SSHVault-Backend verifiziert werden. Dies kann auf einen Man-in-the-Middle-Angriff oder einen falsch konfigurierten Server hindeuten.';

  @override
  String get attestationKeyChangedTitle => 'Serverschlüssel geändert';

  @override
  String get attestationKeyChangedMessage =>
      'Der Attestierungsschlüssel des Servers hat sich seit der ersten Verbindung geändert. Dies kann auf einen Man-in-the-Middle-Angriff hindeuten. Fahre NICHT fort, es sei denn, der Serveradministrator hat eine Schlüsselrotation bestätigt.';

  @override
  String get sectionLinks => 'Links';

  @override
  String get sectionDeveloper => 'Entwickler';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Seite nicht gefunden';

  @override
  String get connectionTestSuccess => 'Verbindung erfolgreich';

  @override
  String connectionTestFailed(String message) {
    return 'Verbindung fehlgeschlagen: $message';
  }

  @override
  String get serverVerificationFailed => 'Server-Verifizierung fehlgeschlagen';

  @override
  String get importSuccessful => 'Import erfolgreich';

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
  String get deviceDeleteConfirmTitle => 'Gerät entfernen';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Möchtest du \"$name\" wirklich entfernen? Das Gerät wird sofort abgemeldet.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Dies ist dein aktuelles Gerät. Du wirst sofort abgemeldet.';

  @override
  String get deviceDeleteSuccess => 'Gerät entfernt';

  @override
  String get deviceDeletedCurrentLogout =>
      'Aktuelles Gerät entfernt. Du wurdest abgemeldet.';

  @override
  String get thisDevice => 'Dieses Gerät';
}
