// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'SSH Vault';

  @override
  String get navHosts => 'Hosts';

  @override
  String get navSnippets => 'Snippets';

  @override
  String get navGroups => 'Gruppen';

  @override
  String get navTags => 'Tags';

  @override
  String get navSshKeys => 'SSH-Schlüssel';

  @override
  String get navExportImport => 'Export / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navAbout => 'Über';

  @override
  String get lockScreenTitle => 'SSH Vault ist gesperrt';

  @override
  String get lockScreenUnlock => 'Entsperren';

  @override
  String get lockScreenEnterPin => 'PIN eingeben';

  @override
  String get pinDialogSetTitle => 'PIN festlegen';

  @override
  String get pinDialogSetSubtitle =>
      'Gib eine 6-stellige PIN ein, um SSH Vault zu schützen';

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
    return 'Falsche PIN ($attempts/5)';
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
  String get settingsEncryptExport => 'Exporte standardmäßig verschlüsseln';

  @override
  String get settingsAbout => 'Über SSH Vault';

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
  String get serverNoGroup => 'Keine Gruppe';

  @override
  String get serverFormTitleEdit => 'Server bearbeiten';

  @override
  String get serverFormTitleAdd => 'Server hinzufügen';

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
  String get filterAllGroups => 'Alle Gruppen';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterActive => 'Aktiv';

  @override
  String get filterInactive => 'Inaktiv';

  @override
  String get filterClear => 'Zurücksetzen';

  @override
  String get groupListTitle => 'Gruppen';

  @override
  String get groupListEmpty => 'Noch keine Gruppen';

  @override
  String get groupListEmptySubtitle =>
      'Erstelle Gruppen, um deine Server zu organisieren.';

  @override
  String get groupAddButton => 'Gruppe hinzufügen';

  @override
  String get groupDeleteTitle => 'Gruppe löschen';

  @override
  String groupDeleteMessage(String name) {
    return '\"$name\" löschen? Server in dieser Gruppe werden nicht zugeordnet.';
  }

  @override
  String get groupCollapse => 'Einklappen';

  @override
  String get groupShowHosts => 'Hosts anzeigen';

  @override
  String get groupFormTitleEdit => 'Gruppe bearbeiten';

  @override
  String get groupFormTitleNew => 'Neue Gruppe';

  @override
  String get groupFormNameLabel => 'Gruppenname';

  @override
  String get groupFormParentLabel => 'Übergeordnete Gruppe';

  @override
  String get groupFormParentNone => 'Keine (Stammebene)';

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
  String get snippetFormGroupLabel => 'Gruppe';

  @override
  String get snippetFormNoGroup => 'Keine Gruppe';

  @override
  String get snippetFormNameRequired => 'Name ist erforderlich';

  @override
  String get snippetFormContentRequired => 'Inhalt ist erforderlich';

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
}
