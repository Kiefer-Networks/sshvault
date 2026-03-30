// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Hôtes';

  @override
  String get navSnippets => 'Extraits';

  @override
  String get navFolders => 'Dossiers';

  @override
  String get navTags => 'Étiquettes';

  @override
  String get navSshKeys => 'Clés SSH';

  @override
  String get navExportImport => 'Export / Import';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Plus';

  @override
  String get navManagement => 'Gestion';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navAbout => 'À propos';

  @override
  String get lockScreenTitle => 'SSHVault est verrouillé';

  @override
  String get lockScreenUnlock => 'Déverrouiller';

  @override
  String get lockScreenEnterPin => 'Entrez le PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Trop de tentatives échouées. Réessayez dans $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Définir le code PIN';

  @override
  String get pinDialogSetSubtitle =>
      'Entrez un PIN à 6 chiffres pour protéger SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Confirmer le PIN';

  @override
  String get pinDialogErrorLength =>
      'Le PIN doit contenir exactement 6 chiffres';

  @override
  String get pinDialogErrorMismatch => 'Les PIN ne correspondent pas';

  @override
  String get pinDialogVerifyTitle => 'Entrez le PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN incorrect. $attempts tentatives restantes.';
  }

  @override
  String get securityBannerMessage =>
      'Vos identifiants SSH ne sont pas protégés. Configurez un PIN ou un verrouillage biométrique dans les Paramètres.';

  @override
  String get securityBannerDismiss => 'Ignorer';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'Paramètres SSH par défaut';

  @override
  String get settingsSectionSecurity => 'Sécurité';

  @override
  String get settingsSectionExport => 'Export';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsTerminalTheme => 'Thème du terminal';

  @override
  String get settingsTerminalThemeDefault => 'Sombre par défaut';

  @override
  String get settingsFontSize => 'Taille de la police';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Port par défaut';

  @override
  String get settingsDefaultPortDialog => 'Port SSH par défaut';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Nom d\'utilisateur par défaut';

  @override
  String get settingsDefaultUsernameDialog => 'Nom d\'utilisateur par défaut';

  @override
  String get settingsUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Verrouillage automatique';

  @override
  String get settingsAutoLockDisabled => 'Désactivé';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get settingsAutoLockOff => 'Désactivé';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Déverrouillage biométrique';

  @override
  String get settingsBiometricNotAvailable => 'Non disponible sur cet appareil';

  @override
  String get settingsBiometricError =>
      'Erreur lors de la vérification biométrique';

  @override
  String get settingsBiometricReason =>
      'Vérifiez votre identité pour activer le déverrouillage biométrique';

  @override
  String get settingsBiometricRequiresPin =>
      'Définissez d\'abord un PIN pour activer le déverrouillage biométrique';

  @override
  String get settingsPinCode => 'Code PIN';

  @override
  String get settingsPinIsSet => 'Le PIN est défini';

  @override
  String get settingsPinNotConfigured => 'Aucun PIN configuré';

  @override
  String get settingsPinRemove => 'Supprimer';

  @override
  String get settingsPinRemoveWarning =>
      'La suppression du PIN déchiffrera tous les champs de la base de données et désactivera le déverrouillage biométrique. Continuer ?';

  @override
  String get settingsPinRemoveTitle => 'Supprimer le PIN';

  @override
  String get settingsPreventScreenshots => 'Empêcher les captures d\'écran';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Bloquer les captures d\'écran et l\'enregistrement d\'écran';

  @override
  String get settingsEncryptExport => 'Chiffrer les exports par défaut';

  @override
  String get settingsAbout => 'À propos de SSHVault';

  @override
  String get settingsAboutLegalese => 'par Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Client SSH sécurisé et auto-hébergé';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Système';

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
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get close => 'Fermer';

  @override
  String get update => 'Mettre à jour';

  @override
  String get create => 'Créer';

  @override
  String get retry => 'Réessayer';

  @override
  String get copy => 'Copier';

  @override
  String get edit => 'Modifier';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Erreur : $message';
  }

  @override
  String get serverListTitle => 'Hôtes';

  @override
  String get serverListEmpty => 'Aucun serveur pour le moment';

  @override
  String get serverListEmptySubtitle =>
      'Ajoutez votre premier serveur SSH pour commencer.';

  @override
  String get serverAddButton => 'Ajouter un serveur';

  @override
  String sshConfigImportMessage(int count) {
    return '$count hôte(s) trouvé(s) dans ~/.ssh/config. Les importer ?';
  }

  @override
  String get sshConfigNotFound => 'Aucun fichier de configuration SSH trouvé';

  @override
  String get sshConfigEmpty => 'Aucun hôte trouvé dans la configuration SSH';

  @override
  String get sshConfigAddManually => 'Ajouter manuellement';

  @override
  String get sshConfigImportAgain =>
      'Importer à nouveau la configuration SSH ?';

  @override
  String get sshConfigImportKeys =>
      'Importer les clés SSH référencées par les hôtes sélectionnés ?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count clé(s) SSH importée(s)';
  }

  @override
  String get serverDuplicated => 'Serveur dupliqué';

  @override
  String get serverDeleteTitle => 'Supprimer le serveur';

  @override
  String serverDeleteMessage(String name) {
    return 'Êtes-vous sûr de vouloir supprimer « $name » ? Cette action est irréversible.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get serverConnect => 'Connexion';

  @override
  String get serverDetails => 'Détails';

  @override
  String get serverDuplicate => 'Dupliquer';

  @override
  String get serverActive => 'Actif';

  @override
  String get serverNoFolder => 'Aucun dossier';

  @override
  String get serverFormTitleEdit => 'Modifier le serveur';

  @override
  String get serverFormTitleAdd => 'Ajouter un serveur';

  @override
  String get serverFormUpdateButton => 'Mettre à jour le serveur';

  @override
  String get serverFormAddButton => 'Ajouter un serveur';

  @override
  String get serverFormPublicKeyExtracted =>
      'Clé publique extraite avec succès';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Impossible d\'extraire la clé publique : $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Paire de clés $type générée';
  }

  @override
  String get serverDetailTitle => 'Détails du serveur';

  @override
  String get serverDetailDeleteMessage => 'Cette action est irréversible.';

  @override
  String get serverDetailConnection => 'Connexion';

  @override
  String get serverDetailHost => 'Hôte';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Nom d\'utilisateur';

  @override
  String get serverDetailFolder => 'Dossier';

  @override
  String get serverDetailTags => 'Étiquettes';

  @override
  String get serverDetailNotes => 'Notes';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Créé';

  @override
  String get serverDetailUpdated => 'Mis à jour';

  @override
  String get serverDetailDistro => 'Système';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get serverFormNameLabel => 'Nom du serveur';

  @override
  String get serverFormHostnameLabel => 'Nom d\'hôte / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get serverFormPasswordLabel => 'Mot de passe';

  @override
  String get serverFormUseManagedKey => 'Utiliser une clé gérée';

  @override
  String get serverFormManagedKeySubtitle =>
      'Sélectionner parmi les clés SSH gérées de manière centralisée';

  @override
  String get serverFormDirectKeySubtitle =>
      'Coller la clé directement dans ce serveur';

  @override
  String get serverFormGenerateKey => 'Générer une paire de clés SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Clé privée';

  @override
  String get serverFormPrivateKeyHint => 'Coller la clé privée SSH...';

  @override
  String get serverFormExtractPublicKey => 'Extraire la clé publique';

  @override
  String get serverFormPublicKeyLabel => 'Clé publique';

  @override
  String get serverFormPublicKeyHint =>
      'Générée automatiquement à partir de la clé privée si vide';

  @override
  String get serverFormPassphraseLabel =>
      'Phrase de passe de la clé (optionnel)';

  @override
  String get serverFormNotesLabel => 'Notes (optionnel)';

  @override
  String get searchServers => 'Rechercher des serveurs...';

  @override
  String get filterAllFolders => 'Tous les dossiers';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterActive => 'Actifs';

  @override
  String get filterInactive => 'Inactifs';

  @override
  String get filterClear => 'Effacer';

  @override
  String get folderListTitle => 'Dossiers';

  @override
  String get folderListEmpty => 'Aucun dossier pour le moment';

  @override
  String get folderListEmptySubtitle =>
      'Créez des dossiers pour organiser vos serveurs.';

  @override
  String get folderAddButton => 'Ajouter un dossier';

  @override
  String get folderDeleteTitle => 'Supprimer le dossier';

  @override
  String folderDeleteMessage(String name) {
    return 'Supprimer « $name » ? Les serveurs ne seront plus classés.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serveurs',
      one: '1 serveur',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Réduire';

  @override
  String get folderShowHosts => 'Afficher les hôtes';

  @override
  String get folderConnectAll => 'Tout connecter';

  @override
  String get folderFormTitleEdit => 'Modifier le dossier';

  @override
  String get folderFormTitleNew => 'Nouveau dossier';

  @override
  String get folderFormNameLabel => 'Nom du dossier';

  @override
  String get folderFormParentLabel => 'Dossier parent';

  @override
  String get folderFormParentNone => 'Aucun (Racine)';

  @override
  String get tagListTitle => 'Étiquettes';

  @override
  String get tagListEmpty => 'Aucune étiquette pour le moment';

  @override
  String get tagListEmptySubtitle =>
      'Créez des étiquettes pour classer et filtrer vos serveurs.';

  @override
  String get tagAddButton => 'Ajouter une étiquette';

  @override
  String get tagDeleteTitle => 'Supprimer l\'étiquette';

  @override
  String tagDeleteMessage(String name) {
    return 'Supprimer « $name » ? Elle sera retirée de tous les serveurs.';
  }

  @override
  String get tagFormTitleEdit => 'Modifier l\'étiquette';

  @override
  String get tagFormTitleNew => 'Nouvelle étiquette';

  @override
  String get tagFormNameLabel => 'Nom de l\'étiquette';

  @override
  String get sshKeyListTitle => 'Clés SSH';

  @override
  String get sshKeyListEmpty => 'Aucune clé SSH pour le moment';

  @override
  String get sshKeyListEmptySubtitle =>
      'Générez ou importez des clés SSH pour les gérer de manière centralisée';

  @override
  String get sshKeyCannotDeleteTitle => 'Suppression impossible';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Impossible de supprimer « $name ». Utilisée par $count serveur(s). Dissociez-la d\'abord de tous les serveurs.';
  }

  @override
  String get sshKeyDeleteTitle => 'Supprimer la clé SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Supprimer « $name » ? Cette action est irréversible.';
  }

  @override
  String get sshKeyAddButton => 'Ajouter une clé SSH';

  @override
  String get sshKeyFormTitleEdit => 'Modifier la clé SSH';

  @override
  String get sshKeyFormTitleAdd => 'Ajouter une clé SSH';

  @override
  String get sshKeyFormTabGenerate => 'Générer';

  @override
  String get sshKeyFormTabImport => 'Importer';

  @override
  String get sshKeyFormNameLabel => 'Nom de la clé';

  @override
  String get sshKeyFormNameHint => 'ex. Ma clé de production';

  @override
  String get sshKeyFormKeyType => 'Type de clé';

  @override
  String get sshKeyFormKeySize => 'Taille de la clé';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Commentaire';

  @override
  String get sshKeyFormCommentHint => 'utilisateur@hôte ou description';

  @override
  String get sshKeyFormCommentOptional => 'Commentaire (optionnel)';

  @override
  String get sshKeyFormImportFromFile => 'Importer depuis un fichier';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Clé privée';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Collez la clé privée SSH ou utilisez le bouton ci-dessus...';

  @override
  String get sshKeyFormPassphraseLabel => 'Phrase de passe (optionnel)';

  @override
  String get sshKeyFormNameRequired => 'Le nom est requis';

  @override
  String get sshKeyFormPrivateKeyRequired => 'La clé privée est requise';

  @override
  String get sshKeyFormFileReadError =>
      'Impossible de lire le fichier sélectionné';

  @override
  String get sshKeyFormInvalidFormat =>
      'Format de clé invalide — format PEM attendu (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Échec de la lecture du fichier : $message';
  }

  @override
  String get sshKeyFormSaving => 'Enregistrement...';

  @override
  String get sshKeySelectorLabel => 'Clé SSH';

  @override
  String get sshKeySelectorNone => 'Aucune clé gérée';

  @override
  String get sshKeySelectorManage => 'Gérer les clés...';

  @override
  String get sshKeySelectorError => 'Échec du chargement des clés SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Copier la clé publique';

  @override
  String get sshKeyTilePublicKeyCopied => 'Clé publique copiée';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Utilisée par $count serveur(s)';
  }

  @override
  String get sshKeyTileUnlinkFirst => 'Dissociez d\'abord de tous les serveurs';

  @override
  String get exportImportTitle => 'Export / Import';

  @override
  String get exportSectionTitle => 'Export';

  @override
  String get exportJsonButton => 'Exporter en JSON (sans identifiants)';

  @override
  String get exportZipButton => 'Exporter en ZIP chiffré (avec identifiants)';

  @override
  String get importSectionTitle => 'Import';

  @override
  String get importButton => 'Importer depuis un fichier';

  @override
  String get importSupportedFormats =>
      'Prend en charge les fichiers JSON (non chiffrés) et ZIP (chiffrés).';

  @override
  String exportedTo(String path) {
    return 'Exporté vers : $path';
  }

  @override
  String get share => 'Partager';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers serveurs, $groups groupes, $tags étiquettes importés. $skipped ignorés.';
  }

  @override
  String get importPasswordTitle => 'Entrer le mot de passe';

  @override
  String get importPasswordLabel => 'Mot de passe d\'export';

  @override
  String get importPasswordDecrypt => 'Déchiffrer';

  @override
  String get exportPasswordTitle => 'Définir le mot de passe d\'export';

  @override
  String get exportPasswordDescription =>
      'Ce mot de passe sera utilisé pour chiffrer votre fichier d\'export, y compris les identifiants.';

  @override
  String get exportPasswordLabel => 'Mot de passe';

  @override
  String get exportPasswordConfirmLabel => 'Confirmer le mot de passe';

  @override
  String get exportPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get exportPasswordButton => 'Chiffrer et exporter';

  @override
  String get importConflictTitle => 'Gérer les conflits';

  @override
  String get importConflictDescription =>
      'Comment les entrées existantes doivent-elles être traitées lors de l\'import ?';

  @override
  String get importConflictSkip => 'Ignorer les existants';

  @override
  String get importConflictRename => 'Renommer les nouveaux';

  @override
  String get importConflictOverwrite => 'Écraser';

  @override
  String get confirmDeleteLabel => 'Supprimer';

  @override
  String get keyGenTitle => 'Générer une paire de clés SSH';

  @override
  String get keyGenKeyType => 'Type de clé';

  @override
  String get keyGenKeySize => 'Taille de la clé';

  @override
  String get keyGenComment => 'Commentaire';

  @override
  String get keyGenCommentHint => 'utilisateur@hôte ou description';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Génération...';

  @override
  String get keyGenGenerate => 'Générer';

  @override
  String keyGenResultTitle(String type) {
    return 'Clé $type générée';
  }

  @override
  String get keyGenPublicKey => 'Clé publique';

  @override
  String get keyGenPrivateKey => 'Clé privée';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Commentaire : $comment';
  }

  @override
  String get keyGenAnother => 'Générer une autre';

  @override
  String get keyGenUseThisKey => 'Utiliser cette clé';

  @override
  String get keyGenCopyTooltip => 'Copier dans le presse-papiers';

  @override
  String keyGenCopied(String label) {
    return '$label copié';
  }

  @override
  String get colorPickerLabel => 'Couleur';

  @override
  String get iconPickerLabel => 'Icône';

  @override
  String get tagSelectorLabel => 'Étiquettes';

  @override
  String get tagSelectorEmpty => 'Aucune étiquette pour le moment';

  @override
  String get tagSelectorError => 'Échec du chargement des étiquettes';

  @override
  String get snippetListTitle => 'Extraits';

  @override
  String get snippetSearchHint => 'Rechercher des extraits...';

  @override
  String get snippetListEmpty => 'Aucun extrait pour le moment';

  @override
  String get snippetListEmptySubtitle =>
      'Créez des extraits de code et des commandes réutilisables.';

  @override
  String get snippetAddButton => 'Ajouter un extrait';

  @override
  String get snippetDeleteTitle => 'Supprimer l\'extrait';

  @override
  String snippetDeleteMessage(String name) {
    return 'Supprimer « $name » ? Cette action est irréversible.';
  }

  @override
  String get snippetFormTitleEdit => 'Modifier l\'extrait';

  @override
  String get snippetFormTitleNew => 'Nouvel extrait';

  @override
  String get snippetFormNameLabel => 'Nom';

  @override
  String get snippetFormNameHint => 'ex. Nettoyage Docker';

  @override
  String get snippetFormLanguageLabel => 'Langage';

  @override
  String get snippetFormContentLabel => 'Contenu';

  @override
  String get snippetFormContentHint => 'Entrez votre code d\'extrait...';

  @override
  String get snippetFormDescriptionLabel => 'Description';

  @override
  String get snippetFormDescriptionHint => 'Description optionnelle...';

  @override
  String get snippetFormFolderLabel => 'Dossier';

  @override
  String get snippetFormNoFolder => 'Aucun dossier';

  @override
  String get snippetFormNameRequired => 'Le nom est requis';

  @override
  String get snippetFormContentRequired => 'Le contenu est requis';

  @override
  String get snippetFormUpdateButton => 'Mettre à jour l\'extrait';

  @override
  String get snippetFormCreateButton => 'Créer l\'extrait';

  @override
  String get snippetDetailTitle => 'Détails de l\'extrait';

  @override
  String get snippetDetailDeleteTitle => 'Supprimer l\'extrait';

  @override
  String get snippetDetailDeleteMessage => 'Cette action est irréversible.';

  @override
  String get snippetDetailContent => 'Contenu';

  @override
  String get snippetDetailFillVariables => 'Remplir les variables';

  @override
  String get snippetDetailDescription => 'Description';

  @override
  String get snippetDetailVariables => 'Variables';

  @override
  String get snippetDetailTags => 'Étiquettes';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Créé';

  @override
  String get snippetDetailUpdated => 'Mis à jour';

  @override
  String get variableEditorTitle => 'Variables de modèle';

  @override
  String get variableEditorAdd => 'Ajouter';

  @override
  String get variableEditorEmpty =>
      'Aucune variable. Utilisez la syntaxe à accolades dans le contenu pour les référencer.';

  @override
  String get variableEditorNameLabel => 'Nom';

  @override
  String get variableEditorNameHint => 'ex. hostname';

  @override
  String get variableEditorDefaultLabel => 'Par défaut';

  @override
  String get variableEditorDefaultHint => 'optionnel';

  @override
  String get variableFillTitle => 'Remplir les variables';

  @override
  String variableFillHint(String name) {
    return 'Entrez la valeur pour $name';
  }

  @override
  String get variableFillPreview => 'Aperçu';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Aucune session active';

  @override
  String get terminalEmptySubtitle =>
      'Connectez-vous à un hôte pour ouvrir une session terminal.';

  @override
  String get terminalGoToHosts => 'Aller aux hôtes';

  @override
  String get terminalCloseAll => 'Fermer toutes les sessions';

  @override
  String get terminalCloseTitle => 'Fermer la session';

  @override
  String terminalCloseMessage(String title) {
    return 'Fermer la connexion active vers « $title » ?';
  }

  @override
  String get connectionAuthenticating => 'Authentification...';

  @override
  String connectionConnecting(String name) {
    return 'Connexion à $name...';
  }

  @override
  String get connectionError => 'Erreur de connexion';

  @override
  String get connectionLost => 'Connexion perdue';

  @override
  String get connectionReconnect => 'Reconnecter';

  @override
  String get snippetQuickPanelTitle => 'Insérer un extrait';

  @override
  String get snippetQuickPanelSearch => 'Rechercher des extraits...';

  @override
  String get snippetQuickPanelEmpty => 'Aucun extrait disponible';

  @override
  String get snippetQuickPanelNoMatch => 'Aucun extrait correspondant';

  @override
  String get snippetQuickPanelInsertTooltip => 'Insérer l\'extrait';

  @override
  String get terminalThemePickerTitle => 'Thème du terminal';

  @override
  String get validatorHostnameRequired => 'Le nom d\'hôte est requis';

  @override
  String get validatorHostnameInvalid => 'Nom d\'hôte ou adresse IP invalide';

  @override
  String get validatorPortRequired => 'Le port est requis';

  @override
  String get validatorPortRange => 'Le port doit être entre 1 et 65535';

  @override
  String get validatorUsernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get validatorUsernameInvalid =>
      'Format de nom d\'utilisateur invalide';

  @override
  String get validatorServerNameRequired => 'Le nom du serveur est requis';

  @override
  String get validatorServerNameLength =>
      'Le nom du serveur doit contenir 100 caractères ou moins';

  @override
  String get validatorSshKeyInvalid => 'Format de clé SSH invalide';

  @override
  String get validatorPasswordRequired => 'Le mot de passe est requis';

  @override
  String get validatorPasswordLength =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get authMethodPassword => 'Mot de passe';

  @override
  String get authMethodKey => 'Clé SSH';

  @override
  String get authMethodBoth => 'Mot de passe + Clé';

  @override
  String get serverCopySuffix => '(Copie)';

  @override
  String get settingsDownloadLogs => 'Télécharger les journaux';

  @override
  String get settingsSendLogs => 'Envoyer les journaux au support';

  @override
  String get settingsLogsSaved => 'Journaux enregistrés avec succès';

  @override
  String get settingsLogsEmpty => 'Aucune entrée de journal disponible';

  @override
  String get authLogin => 'Connexion';

  @override
  String get authRegister => 'Inscription';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authWhyLogin =>
      'Connectez-vous pour activer la synchronisation cloud chiffrée sur tous vos appareils. L\'application fonctionne entièrement hors ligne sans compte.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailRequired => 'L\'e-mail est requis';

  @override
  String get authEmailInvalid => 'Adresse e-mail invalide';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get authPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get authNoAccount => 'Pas de compte ?';

  @override
  String get authHasAccount => 'Vous avez déjà un compte ?';

  @override
  String get authResetEmailSent =>
      'Si un compte existe, un lien de réinitialisation a été envoyé à votre adresse e-mail.';

  @override
  String get authResetDescription =>
      'Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.';

  @override
  String get authSendResetLink => 'Envoyer le lien de réinitialisation';

  @override
  String get authBackToLogin => 'Retour à la connexion';

  @override
  String get syncPasswordTitle => 'Mot de passe de synchronisation';

  @override
  String get syncPasswordTitleCreate =>
      'Définir le mot de passe de synchronisation';

  @override
  String get syncPasswordTitleEnter =>
      'Entrer le mot de passe de synchronisation';

  @override
  String get syncPasswordDescription =>
      'Définissez un mot de passe séparé pour chiffrer les données de votre coffre-fort. Ce mot de passe ne quitte jamais votre appareil — le serveur ne stocke que des données chiffrées.';

  @override
  String get syncPasswordHintEnter =>
      'Entrez le mot de passe que vous avez défini lors de la création de votre compte.';

  @override
  String get syncPasswordWarning =>
      'Si vous oubliez ce mot de passe, vos données synchronisées ne pourront pas être récupérées. Il n\'y a pas d\'option de réinitialisation.';

  @override
  String get syncPasswordLabel => 'Mot de passe de synchronisation';

  @override
  String get syncPasswordWrong => 'Mot de passe incorrect. Veuillez réessayer.';

  @override
  String get firstSyncTitle => 'Données existantes trouvées';

  @override
  String get firstSyncMessage =>
      'Cet appareil contient des données existantes et le serveur possède un coffre-fort. Comment procéder ?';

  @override
  String get firstSyncMerge => 'Fusionner (le serveur prime)';

  @override
  String get firstSyncOverwriteLocal => 'Écraser les données locales';

  @override
  String get firstSyncKeepLocal => 'Garder les locales et pousser';

  @override
  String get firstSyncDeleteLocal => 'Supprimer les locales et tirer';

  @override
  String get changeEncryptionPassword =>
      'Changer le mot de passe de chiffrement';

  @override
  String get changeEncryptionWarning =>
      'Vous serez déconnecté de tous les autres appareils.';

  @override
  String get changeEncryptionOldPassword => 'Mot de passe actuel';

  @override
  String get changeEncryptionNewPassword => 'Nouveau mot de passe';

  @override
  String get changeEncryptionSuccess => 'Mot de passe changé avec succès.';

  @override
  String get logoutAllDevices => 'Se déconnecter de tous les appareils';

  @override
  String get logoutAllDevicesConfirm =>
      'Cela révoquera toutes les sessions actives. Vous devrez vous reconnecter sur tous les appareils.';

  @override
  String get logoutAllDevicesSuccess => 'Tous les appareils déconnectés.';

  @override
  String get syncSettingsTitle => 'Paramètres de synchronisation';

  @override
  String get syncAutoSync => 'Synchronisation automatique';

  @override
  String get syncAutoSyncDescription =>
      'Synchroniser automatiquement au démarrage de l\'application';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get syncSyncing => 'Synchronisation...';

  @override
  String get syncSuccess => 'Synchronisation terminée';

  @override
  String get syncError => 'Erreur de synchronisation';

  @override
  String get syncServerUnreachable => 'Serveur injoignable';

  @override
  String get syncServerUnreachableHint =>
      'Le serveur de synchronisation n\'a pas pu être atteint. Vérifiez votre connexion Internet et l\'URL du serveur.';

  @override
  String get syncNetworkError =>
      'La connexion au serveur a échoué. Veuillez vérifier votre connexion Internet ou réessayer plus tard.';

  @override
  String get syncNeverSynced => 'Jamais synchronisé';

  @override
  String get syncVaultVersion => 'Version du coffre-fort';

  @override
  String get syncTitle => 'Synchronisation';

  @override
  String get settingsSectionNetwork => 'Réseau et DNS';

  @override
  String get settingsDnsServers => 'Serveurs DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Par défaut (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Entrez les URL des serveurs DoH personnalisés, séparées par des virgules. Au moins 2 serveurs sont nécessaires pour la vérification croisée.';

  @override
  String get settingsDnsLabel => 'URL des serveurs DoH';

  @override
  String get settingsDnsReset => 'Réinitialiser par défaut';

  @override
  String get settingsSectionSync => 'Synchronisation';

  @override
  String get settingsSyncAccount => 'Compte';

  @override
  String get settingsSyncNotLoggedIn => 'Non connecté';

  @override
  String get settingsSyncStatus => 'Synchronisation';

  @override
  String get settingsSyncServerUrl => 'URL du serveur';

  @override
  String get settingsSyncDefaultServer => 'Par défaut (sshvault.app)';

  @override
  String get accountTitle => 'Compte';

  @override
  String get accountNotLoggedIn => 'Non connecté';

  @override
  String get accountVerified => 'Vérifié';

  @override
  String get accountMemberSince => 'Membre depuis';

  @override
  String get accountDevices => 'Appareils';

  @override
  String get accountNoDevices => 'Aucun appareil enregistré';

  @override
  String get accountLastSync => 'Dernière synchronisation';

  @override
  String get accountChangePassword => 'Changer le mot de passe';

  @override
  String get accountOldPassword => 'Mot de passe actuel';

  @override
  String get accountNewPassword => 'Nouveau mot de passe';

  @override
  String get accountDeleteAccount => 'Supprimer le compte';

  @override
  String get accountDeleteWarning =>
      'Cela supprimera définitivement votre compte et toutes les données synchronisées. Cette action est irréversible.';

  @override
  String get accountLogout => 'Se déconnecter';

  @override
  String get serverConfigTitle => 'Configuration du serveur';

  @override
  String get serverConfigUrlLabel => 'URL du serveur';

  @override
  String get serverConfigTest => 'Tester la connexion';

  @override
  String get serverSetupTitle => 'Configuration du serveur';

  @override
  String get serverSetupInfoCard =>
      'ShellVault nécessite un serveur auto-hébergé pour la synchronisation chiffrée de bout en bout. Déployez votre propre instance pour commencer.';

  @override
  String get serverSetupRepoLink => 'Voir sur GitHub';

  @override
  String get serverSetupContinue => 'Continuer';

  @override
  String get settingsServerNotConfigured => 'No server configured';

  @override
  String get settingsSetupSync => 'Set up sync to back up your data';

  @override
  String get settingsChangeServer => 'Change Server';

  @override
  String get settingsChangeServerConfirm =>
      'Changing the server will log you out. Continue?';

  @override
  String get auditLogTitle => 'Journal d\'activité';

  @override
  String get auditLogAll => 'Tous';

  @override
  String get auditLogEmpty => 'Aucun journal d\'activité trouvé';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Gestionnaire de fichiers';

  @override
  String get sftpLocalDevice => 'Appareil local';

  @override
  String get sftpSelectServer => 'Sélectionner un serveur...';

  @override
  String get sftpConnecting => 'Connexion...';

  @override
  String get sftpEmptyDirectory => 'Ce répertoire est vide';

  @override
  String get sftpNoConnection => 'Aucun serveur connecté';

  @override
  String get sftpPathLabel => 'Chemin';

  @override
  String get sftpUpload => 'Téléverser';

  @override
  String get sftpDownload => 'Télécharger';

  @override
  String get sftpDelete => 'Supprimer';

  @override
  String get sftpRename => 'Renommer';

  @override
  String get sftpNewFolder => 'Nouveau dossier';

  @override
  String get sftpNewFolderName => 'Nom du dossier';

  @override
  String get sftpChmod => 'Permissions';

  @override
  String get sftpChmodTitle => 'Modifier les permissions';

  @override
  String get sftpChmodOctal => 'Octal';

  @override
  String get sftpChmodOwner => 'Propriétaire';

  @override
  String get sftpChmodGroup => 'Groupe';

  @override
  String get sftpChmodOther => 'Autres';

  @override
  String get sftpChmodRead => 'Lecture';

  @override
  String get sftpChmodWrite => 'Écriture';

  @override
  String get sftpChmodExecute => 'Exécution';

  @override
  String get sftpCreateSymlink => 'Créer un lien symbolique';

  @override
  String get sftpSymlinkTarget => 'Chemin cible';

  @override
  String get sftpSymlinkName => 'Nom du lien';

  @override
  String get sftpFilePreview => 'Aperçu du fichier';

  @override
  String get sftpFileInfo => 'Infos du fichier';

  @override
  String get sftpFileSize => 'Taille';

  @override
  String get sftpFileModified => 'Modifié';

  @override
  String get sftpFilePermissions => 'Permissions';

  @override
  String get sftpFileOwner => 'Propriétaire';

  @override
  String get sftpFileType => 'Type';

  @override
  String get sftpFileLinkTarget => 'Cible du lien';

  @override
  String get sftpTransfers => 'Transferts';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get sftpTransferQueued => 'En file d\'attente';

  @override
  String get sftpTransferActive => 'Transfert en cours...';

  @override
  String get sftpTransferPaused => 'En pause';

  @override
  String get sftpTransferCompleted => 'Terminé';

  @override
  String get sftpTransferFailed => 'Échoué';

  @override
  String get sftpTransferCancelled => 'Annulé';

  @override
  String get sftpPauseTransfer => 'Pause';

  @override
  String get sftpResumeTransfer => 'Reprendre';

  @override
  String get sftpCancelTransfer => 'Annuler';

  @override
  String get sftpClearCompleted => 'Effacer les terminés';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active sur $total transferts';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actifs',
      one: '1 actif',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count terminés',
      one: '1 terminé',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count échoués',
      one: '1 échoué',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Copier vers l\'autre panneau';

  @override
  String sftpConfirmDelete(int count) {
    return 'Supprimer $count éléments ?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get sftpDeleteSuccess => 'Supprimé avec succès';

  @override
  String get sftpRenameTitle => 'Renommer';

  @override
  String get sftpRenameLabel => 'Nouveau nom';

  @override
  String get sftpSortByName => 'Nom';

  @override
  String get sftpSortBySize => 'Taille';

  @override
  String get sftpSortByDate => 'Date';

  @override
  String get sftpSortByType => 'Type';

  @override
  String get sftpShowHidden => 'Afficher les fichiers cachés';

  @override
  String get sftpHideHidden => 'Masquer les fichiers cachés';

  @override
  String get sftpSelectAll => 'Tout sélectionner';

  @override
  String get sftpDeselectAll => 'Tout désélectionner';

  @override
  String sftpItemsSelected(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get sftpRefresh => 'Actualiser';

  @override
  String sftpConnectionError(String message) {
    return 'Échec de la connexion : $message';
  }

  @override
  String get sftpPermissionDenied => 'Permission refusée';

  @override
  String sftpOperationFailed(String message) {
    return 'Opération échouée : $message';
  }

  @override
  String get sftpOverwriteTitle => 'Le fichier existe déjà';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '« $fileName » existe déjà. Écraser ?';
  }

  @override
  String get sftpOverwrite => 'Écraser';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Transfert démarré : $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Sélectionnez d\'abord une destination dans l\'autre panneau';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Transfert de répertoire bientôt disponible';

  @override
  String get sftpSelect => 'Sélectionner';

  @override
  String get sftpOpen => 'Ouvrir';

  @override
  String get sftpExtractArchive => 'Extraire ici';

  @override
  String get sftpExtractSuccess => 'Archive extraite';

  @override
  String sftpExtractFailed(String message) {
    return 'Échec de l\'extraction : $message';
  }

  @override
  String get sftpExtractUnsupported => 'Format d\'archive non pris en charge';

  @override
  String get sftpExtracting => 'Extraction...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count téléversements démarrés',
      one: 'Téléversement démarré',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count téléchargements démarrés',
      one: 'Téléchargement démarré',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '« $fileName » téléchargé';
  }

  @override
  String get sftpSavedToDownloads => 'Enregistré dans Téléchargements/SSHVault';

  @override
  String get sftpSaveToFiles => 'Enregistrer dans les fichiers';

  @override
  String get sftpFileSaved => 'Fichier enregistré';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions SSH actives',
      one: 'Session SSH active',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Appuyez pour ouvrir le terminal';

  @override
  String get settingsAccountAndSync => 'Compte et synchronisation';

  @override
  String get settingsAccountSubtitleAuth => 'Connecté';

  @override
  String get settingsAccountSubtitleUnauth => 'Non connecté';

  @override
  String get settingsSecuritySubtitle => 'Verrouillage auto, Biométrie, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Utilisateur root';

  @override
  String get settingsAppearanceSubtitle => 'Thème, Langue, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Paramètres d\'export chiffré';

  @override
  String get settingsAboutSubtitle => 'Version, Licences';

  @override
  String get settingsSearchHint => 'Rechercher dans les paramètres...';

  @override
  String get settingsSearchNoResults => 'Aucun paramètre trouvé';

  @override
  String get aboutDeveloper => 'Développé par Kiefer Networks';

  @override
  String get aboutDonate => 'Faire un don';

  @override
  String get aboutOpenSourceLicenses => 'Licences Open Source';

  @override
  String get aboutWebsite => 'Site web';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS chiffre les requêtes DNS et empêche l\'usurpation DNS. SSHVault vérifie les noms d\'hôtes auprès de plusieurs fournisseurs pour détecter les attaques.';

  @override
  String get settingsDnsAddServer => 'Ajouter un serveur DNS';

  @override
  String get settingsDnsServerUrl => 'URL du serveur';

  @override
  String get settingsDnsDefaultBadge => 'Par défaut';

  @override
  String get settingsDnsResetDefaults => 'Réinitialiser aux valeurs par défaut';

  @override
  String get settingsDnsInvalidUrl => 'Veuillez entrer une URL HTTPS valide';

  @override
  String get settingsDefaultAuthMethod => 'Méthode d\'authentification';

  @override
  String get settingsAuthPassword => 'Mot de passe';

  @override
  String get settingsAuthKey => 'Clé SSH';

  @override
  String get settingsConnectionTimeout => 'Délai de connexion';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Intervalle Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Compression';

  @override
  String get settingsCompressionDescription =>
      'Activer la compression zlib pour les connexions SSH';

  @override
  String get settingsTerminalType => 'Type de terminal';

  @override
  String get settingsSectionConnection => 'Connexion';

  @override
  String get settingsClipboardAutoClear =>
      'Effacement automatique du presse-papiers';

  @override
  String get settingsClipboardAutoClearOff => 'Désactivé';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Expiration de la session';

  @override
  String get settingsSessionTimeoutOff => 'Désactivé';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'PIN de contrainte';

  @override
  String get settingsDuressPinDescription =>
      'Un PIN séparé qui efface toutes les données lorsqu\'il est saisi';

  @override
  String get settingsDuressPinSet => 'Le PIN de contrainte est défini';

  @override
  String get settingsDuressPinNotSet => 'Non configuré';

  @override
  String get settingsDuressPinWarning =>
      'La saisie de ce PIN supprimera définitivement toutes les données locales, y compris les identifiants, les clés et les paramètres. Cette action est irréversible.';

  @override
  String get settingsKeyRotationReminder => 'Rappel de rotation des clés';

  @override
  String get settingsKeyRotationOff => 'Désactivé';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days jours';
  }

  @override
  String get settingsFailedAttempts => 'Tentatives PIN échouées';

  @override
  String get settingsSectionAppLock => 'Verrouillage de l\'application';

  @override
  String get settingsSectionPrivacy => 'Confidentialité';

  @override
  String get settingsSectionReminders => 'Rappels';

  @override
  String get settingsSectionStatus => 'Statut';

  @override
  String get settingsExportBackupSubtitle => 'Export, Import et sauvegarde';

  @override
  String get settingsExportJson => 'Exporter en JSON';

  @override
  String get settingsExportEncrypted => 'Exporter chiffré';

  @override
  String get settingsImportFile => 'Importer depuis un fichier';

  @override
  String get settingsSectionImport => 'Import';

  @override
  String get filterTitle => 'Filtrer les serveurs';

  @override
  String get filterApply => 'Appliquer les filtres';

  @override
  String get filterClearAll => 'Tout effacer';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtres actifs',
      one: '1 filtre actif',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Dossier';

  @override
  String get filterTags => 'Étiquettes';

  @override
  String get filterStatus => 'Statut';

  @override
  String get variablePreviewResolved => 'Aperçu résolu';

  @override
  String get variableInsert => 'Insérer';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serveurs',
      one: '1 serveur',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions révoquées.',
      one: '1 session révoquée.',
    );
    return '$_temp0 Vous avez été déconnecté.';
  }

  @override
  String get keyGenPassphrase => 'Phrase de passe';

  @override
  String get keyGenPassphraseHint => 'Optionnel — protège la clé privée';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Par défaut (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Une clé avec la même empreinte existe déjà : « $name ». Chaque clé SSH doit être unique.';
  }

  @override
  String get sshKeyFingerprint => 'Empreinte';

  @override
  String get sshKeyPublicKey => 'Clé publique';

  @override
  String get jumpHost => 'Hôte de rebond';

  @override
  String get jumpHostNone => 'Aucun';

  @override
  String get jumpHostLabel => 'Se connecter via un hôte de rebond';

  @override
  String get jumpHostSelfError =>
      'Un serveur ne peut pas être son propre hôte de rebond';

  @override
  String get jumpHostConnecting => 'Connexion à l\'hôte de rebond…';

  @override
  String get jumpHostCircularError =>
      'Chaîne d\'hôtes de rebond circulaire détectée';

  @override
  String get logoutDialogTitle => 'Se déconnecter';

  @override
  String get logoutDialogMessage =>
      'Voulez-vous supprimer toutes les données locales ? Les serveurs, clés SSH, extraits et paramètres seront supprimés de cet appareil.';

  @override
  String get logoutOnly => 'Se déconnecter uniquement';

  @override
  String get logoutAndDelete => 'Se déconnecter et supprimer les données';

  @override
  String get changeAvatar => 'Changer l\'avatar';

  @override
  String get removeAvatar => 'Supprimer l\'avatar';

  @override
  String get avatarUploadFailed => 'Échec du téléversement de l\'avatar';

  @override
  String get avatarTooLarge => 'L\'image est trop volumineuse';

  @override
  String get deviceLastSeen => 'Vu pour la dernière fois';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'L\'URL du serveur ne peut pas être modifiée tant que vous êtes connecté. Déconnectez-vous d\'abord.';

  @override
  String get serverListNoFolder => 'Non classé';

  @override
  String get autoSyncInterval => 'Intervalle de synchronisation';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Paramètres du proxy';

  @override
  String get proxyType => 'Type de proxy';

  @override
  String get proxyNone => 'Aucun proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Hôte du proxy';

  @override
  String get proxyPort => 'Port du proxy';

  @override
  String get proxyUsername => 'Nom d\'utilisateur du proxy';

  @override
  String get proxyPassword => 'Mot de passe du proxy';

  @override
  String get proxyUseGlobal => 'Utiliser le proxy global';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Spécifique au serveur';

  @override
  String get proxyTestConnection => 'Tester la connexion';

  @override
  String get proxyTestSuccess => 'Proxy joignable';

  @override
  String get proxyTestFailed => 'Proxy injoignable';

  @override
  String get proxyDefaultProxy => 'Proxy par défaut';

  @override
  String get vpnRequired => 'VPN requis';

  @override
  String get vpnRequiredTooltip =>
      'Afficher un avertissement lors de la connexion sans VPN actif';

  @override
  String get vpnActive => 'VPN actif';

  @override
  String get vpnInactive => 'VPN inactif';

  @override
  String get vpnWarningTitle => 'VPN non actif';

  @override
  String get vpnWarningMessage =>
      'Ce serveur nécessite une connexion VPN, mais aucun VPN n\'est actuellement actif. Voulez-vous vous connecter quand même ?';

  @override
  String get vpnConnectAnyway => 'Se connecter quand même';

  @override
  String get postConnectCommands => 'Commandes post-connexion';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Commandes exécutées automatiquement après la connexion (une par ligne)';

  @override
  String get dashboardFavorites => 'Favoris';

  @override
  String get dashboardRecent => 'Récents';

  @override
  String get dashboardActiveSessions => 'Sessions actives';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get noRecentConnections => 'Aucune connexion récente';

  @override
  String get terminalSplit => 'Vue divisée';

  @override
  String get terminalUnsplit => 'Fermer la division';

  @override
  String get terminalSelectSession =>
      'Sélectionner une session pour la vue divisée';

  @override
  String get knownHostsTitle => 'Hôtes connus';

  @override
  String get knownHostsSubtitle =>
      'Gérer les empreintes de serveurs de confiance';

  @override
  String get hostKeyNewTitle => 'Nouvel hôte';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Première connexion à $hostname:$port. Vérifiez l\'empreinte avant de vous connecter.';
  }

  @override
  String get hostKeyChangedTitle => 'Clé de l\'hôte modifiée !';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'La clé de l\'hôte pour $hostname:$port a changé. Cela pourrait indiquer une menace de sécurité.';
  }

  @override
  String get hostKeyFingerprint => 'Empreinte';

  @override
  String get hostKeyType => 'Type de clé';

  @override
  String get hostKeyTrustConnect => 'Faire confiance et connecter';

  @override
  String get hostKeyAcceptNew => 'Accepter la nouvelle clé';

  @override
  String get hostKeyReject => 'Rejeter';

  @override
  String get hostKeyPreviousFingerprint => 'Empreinte précédente';

  @override
  String get hostKeyDeleteAll => 'Supprimer tous les hôtes connus';

  @override
  String get hostKeyDeleteConfirm =>
      'Êtes-vous sûr de vouloir supprimer tous les hôtes connus ? Vous serez à nouveau invité lors de la prochaine connexion.';

  @override
  String get hostKeyEmpty => 'Aucun hôte connu pour le moment';

  @override
  String get hostKeyEmptySubtitle =>
      'Les empreintes des hôtes seront stockées ici après votre première connexion';

  @override
  String get hostKeyFirstSeen => 'Vu pour la première fois';

  @override
  String get hostKeyLastSeen => 'Vu pour la dernière fois';

  @override
  String get sshConfigImportTitle => 'Importer la configuration SSH';

  @override
  String get sshConfigImportPickFile =>
      'Sélectionner le fichier de configuration SSH';

  @override
  String get sshConfigImportOrPaste =>
      'Ou coller le contenu de la configuration';

  @override
  String sshConfigImportParsed(int count) {
    return '$count hôte(s) trouvé(s)';
  }

  @override
  String get sshConfigImportButton => 'Importer la sélection';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count serveur(s) importé(s)';
  }

  @override
  String get sshConfigImportDuplicate => 'Existe déjà';

  @override
  String get sshConfigImportNoHosts =>
      'Aucun hôte trouvé dans la configuration';

  @override
  String get sftpBookmarkAdd => 'Ajouter un signet';

  @override
  String get sftpBookmarkLabel => 'Libellé';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get reportAndDisconnect => 'Signaler et déconnecter';

  @override
  String get continueAnyway => 'Continuer quand même';

  @override
  String get insertSnippet => 'Insérer un extrait';

  @override
  String get seconds => 'Secondes';

  @override
  String get heartbeatLostMessage =>
      'Le serveur n\'a pas pu être atteint après plusieurs tentatives. Pour votre sécurité, la session a été terminée.';

  @override
  String get attestationFailedTitle => 'Vérification du serveur échouée';

  @override
  String get attestationFailedMessage =>
      'Le serveur n\'a pas pu être vérifié comme un backend SSHVault légitime. Cela peut indiquer une attaque de type man-in-the-middle ou un serveur mal configuré.';

  @override
  String get attestationKeyChangedTitle =>
      'Clé d\'attestation du serveur modifiée';

  @override
  String get attestationKeyChangedMessage =>
      'La clé d\'attestation du serveur a changé depuis la connexion initiale. Cela peut indiquer une attaque de type man-in-the-middle. Ne continuez PAS sauf si l\'administrateur du serveur a confirmé une rotation de clé.';

  @override
  String get sectionLinks => 'Liens';

  @override
  String get sectionDeveloper => 'Développeur';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Page non trouvée';

  @override
  String get connectionTestSuccess => 'Connexion réussie';

  @override
  String connectionTestFailed(String message) {
    return 'Échec de la connexion : $message';
  }

  @override
  String get serverVerificationFailed => 'Échec de la vérification du serveur';

  @override
  String get importSuccessful => 'Import réussi';

  @override
  String get hintExampleServerUrl => 'https://votre-serveur.example.com';

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
  String get deviceDeleteConfirmTitle => 'Supprimer l\'appareil';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Voulez-vous vraiment supprimer \"$name\" ? L\'appareil sera déconnecté immédiatement.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Ceci est votre appareil actuel. Vous serez déconnecté immédiatement.';

  @override
  String get deviceDeleteSuccess => 'Appareil supprimé';

  @override
  String get deviceDeletedCurrentLogout =>
      'Appareil actuel supprimé. Vous avez été déconnecté.';

  @override
  String get thisDevice => 'Cet appareil';
}
