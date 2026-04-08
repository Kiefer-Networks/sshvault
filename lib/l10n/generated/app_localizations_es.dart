// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Hosts';

  @override
  String get navSnippets => 'Snippets';

  @override
  String get navFolders => 'Carpetas';

  @override
  String get navTags => 'Etiquetas';

  @override
  String get navSshKeys => 'Claves SSH';

  @override
  String get navExportImport => 'Exportar / Importar';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Más';

  @override
  String get navManagement => 'Gestión';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navAbout => 'Acerca de';

  @override
  String get lockScreenTitle => 'SSHVault está bloqueado';

  @override
  String get lockScreenUnlock => 'Desbloquear';

  @override
  String get lockScreenEnterPin => 'Ingresar PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Demasiados intentos fallidos. Intenta de nuevo en $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Establecer PIN';

  @override
  String get pinDialogSetSubtitle =>
      'Ingresa un PIN de 6 dígitos para proteger SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Confirmar PIN';

  @override
  String get pinDialogErrorLength => 'El PIN debe tener exactamente 6 dígitos';

  @override
  String get pinDialogErrorMismatch => 'Los PINs no coinciden';

  @override
  String get pinDialogVerifyTitle => 'Ingresar PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN incorrecto. $attempts intentos restantes.';
  }

  @override
  String get securityBannerMessage =>
      'Tus credenciales SSH no están protegidas. Configura un PIN o bloqueo biométrico en Ajustes.';

  @override
  String get securityBannerDismiss => 'Descartar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'SSH predeterminado';

  @override
  String get settingsSectionSecurity => 'Seguridad';

  @override
  String get settingsSectionExport => 'Exportar';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsTerminalTheme => 'Tema del terminal';

  @override
  String get settingsTerminalThemeDefault => 'Oscuro por defecto';

  @override
  String get settingsFontSize => 'Tamaño de fuente';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Puerto predeterminado';

  @override
  String get settingsDefaultPortDialog => 'Puerto SSH predeterminado';

  @override
  String get settingsPortLabel => 'Puerto';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Usuario predeterminado';

  @override
  String get settingsDefaultUsernameDialog => 'Usuario predeterminado';

  @override
  String get settingsUsernameLabel => 'Usuario';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Bloqueo automático';

  @override
  String get settingsAutoLockDisabled => 'Desactivado';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get settingsAutoLockOff => 'Desactivado';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Desbloqueo biométrico';

  @override
  String get settingsBiometricNotAvailable =>
      'No disponible en este dispositivo';

  @override
  String get settingsBiometricError => 'Error al verificar biometría';

  @override
  String get settingsBiometricReason =>
      'Verifica tu identidad para activar el desbloqueo biométrico';

  @override
  String get settingsBiometricRequiresPin =>
      'Establece un PIN primero para activar el desbloqueo biométrico';

  @override
  String get settingsPinCode => 'Código PIN';

  @override
  String get settingsPinIsSet => 'PIN establecido';

  @override
  String get settingsPinNotConfigured => 'PIN no configurado';

  @override
  String get settingsPinRemove => 'Eliminar';

  @override
  String get settingsPinRemoveWarning =>
      'Eliminar el PIN descifrará todos los campos de la base de datos y desactivará el desbloqueo biométrico. ¿Continuar?';

  @override
  String get settingsPinRemoveTitle => 'Eliminar PIN';

  @override
  String get settingsPreventScreenshots => 'Prevenir capturas de pantalla';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Bloquear capturas de pantalla y grabación de pantalla';

  @override
  String get settingsEncryptExport => 'Cifrar exportaciones por defecto';

  @override
  String get settingsAbout => 'Acerca de SSHVault';

  @override
  String get settingsAboutLegalese => 'por Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Cliente SSH seguro y autoalojado';

  @override
  String get settingsLanguage => 'Idioma';

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
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get close => 'Cerrar';

  @override
  String get update => 'Actualizar';

  @override
  String get create => 'Crear';

  @override
  String get retry => 'Reintentar';

  @override
  String get copy => 'Copiar';

  @override
  String get edit => 'Editar';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get serverListTitle => 'Hosts';

  @override
  String get serverListEmpty => 'Aún no hay servidores';

  @override
  String get serverListEmptySubtitle =>
      'Agrega tu primer servidor SSH para comenzar.';

  @override
  String get serverAddButton => 'Agregar servidor';

  @override
  String sshConfigImportMessage(int count) {
    return '$count host(s) encontrados en ~/.ssh/config. ¿Importar?';
  }

  @override
  String get sshConfigNotFound =>
      'No se encontró el archivo de configuración SSH';

  @override
  String get sshConfigEmpty =>
      'No se encontraron hosts en la configuración SSH';

  @override
  String get sshConfigAddManually => 'Agregar manualmente';

  @override
  String get sshConfigImportAgain => '¿Importar configuración SSH de nuevo?';

  @override
  String get sshConfigImportKeys =>
      '¿Importar las claves SSH referenciadas por los hosts seleccionados?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count clave(s) SSH importada(s)';
  }

  @override
  String get serverDuplicated => 'Servidor duplicado';

  @override
  String get serverDeleteTitle => 'Eliminar servidor';

  @override
  String serverDeleteMessage(String name) {
    return '¿Estás seguro de que deseas eliminar \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String serverDeleteShort(String name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get serverConnect => 'Conectar';

  @override
  String get serverDetails => 'Detalles';

  @override
  String get serverDuplicate => 'Duplicar';

  @override
  String get serverActive => 'Activo';

  @override
  String get serverNoFolder => 'Sin carpeta';

  @override
  String get serverFormTitleEdit => 'Editar servidor';

  @override
  String get serverFormTitleAdd => 'Agregar servidor';

  @override
  String get serverSaved => 'Server saved successfully';

  @override
  String get serverFormUpdateButton => 'Actualizar servidor';

  @override
  String get serverFormAddButton => 'Agregar servidor';

  @override
  String get serverFormPublicKeyExtracted =>
      'Clave pública extraída exitosamente';

  @override
  String serverFormPublicKeyError(String message) {
    return 'No se pudo extraer la clave pública: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Par de claves $type generado';
  }

  @override
  String get serverDetailTitle => 'Detalles del servidor';

  @override
  String get serverDetailDeleteMessage => 'Esta acción no se puede deshacer.';

  @override
  String get serverDetailConnection => 'Conexión';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Puerto';

  @override
  String get serverDetailUsername => 'Usuario';

  @override
  String get serverDetailFolder => 'Carpeta';

  @override
  String get serverDetailTags => 'Etiquetas';

  @override
  String get serverDetailNotes => 'Notas';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Creado';

  @override
  String get serverDetailUpdated => 'Actualizado';

  @override
  String get serverDetailDistro => 'Sistema';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get serverFormNameLabel => 'Nombre del servidor';

  @override
  String get serverFormHostnameLabel => 'Hostname / IP';

  @override
  String get serverFormPortLabel => 'Puerto';

  @override
  String get serverFormUsernameLabel => 'Usuario';

  @override
  String get serverFormPasswordLabel => 'Contraseña';

  @override
  String get serverFormUseManagedKey => 'Usar clave administrada';

  @override
  String get serverFormManagedKeySubtitle =>
      'Seleccionar de claves SSH administradas centralmente';

  @override
  String get serverFormDirectKeySubtitle =>
      'Pegar clave directamente en este servidor';

  @override
  String get serverFormGenerateKey => 'Generar par de claves SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Clave privada';

  @override
  String get serverFormPrivateKeyHint => 'Pegar clave privada SSH...';

  @override
  String get serverFormExtractPublicKey => 'Extraer clave pública';

  @override
  String get serverFormPublicKeyLabel => 'Clave pública';

  @override
  String get serverFormPublicKeyHint =>
      'Se genera automáticamente desde la clave privada';

  @override
  String get serverFormPassphraseLabel => 'Passphrase de la clave (opcional)';

  @override
  String get serverFormNotesLabel => 'Notas (opcional)';

  @override
  String get searchServers => 'Buscar servidores...';

  @override
  String get filterAllFolders => 'Todas las carpetas';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterActive => 'Activo';

  @override
  String get filterInactive => 'Inactivo';

  @override
  String get filterClear => 'Limpiar';

  @override
  String get folderListTitle => 'Carpetas';

  @override
  String get folderListEmpty => 'Aún no hay carpetas';

  @override
  String get folderListEmptySubtitle =>
      'Crea carpetas para organizar tus servidores.';

  @override
  String get folderAddButton => 'Agregar carpeta';

  @override
  String get folderDeleteTitle => 'Eliminar carpeta';

  @override
  String folderDeleteMessage(String name) {
    return '¿Eliminar \"$name\"? Los servidores quedarán sin organizar.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servidores',
      one: '1 servidor',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Colapsar';

  @override
  String get folderShowHosts => 'Mostrar hosts';

  @override
  String get folderConnectAll => 'Conectar todos';

  @override
  String get folderFormTitleEdit => 'Editar carpeta';

  @override
  String get folderFormTitleNew => 'Nueva carpeta';

  @override
  String get folderFormNameLabel => 'Nombre de la carpeta';

  @override
  String get folderFormParentLabel => 'Carpeta padre';

  @override
  String get folderFormParentNone => 'Ninguna (Raíz)';

  @override
  String get tagListTitle => 'Etiquetas';

  @override
  String get tagListEmpty => 'Aún no hay etiquetas';

  @override
  String get tagListEmptySubtitle =>
      'Crea etiquetas para etiquetar y filtrar tus servidores.';

  @override
  String get tagAddButton => 'Agregar etiqueta';

  @override
  String get tagDeleteTitle => 'Eliminar etiqueta';

  @override
  String tagDeleteMessage(String name) {
    return '¿Eliminar \"$name\"? Se eliminará de todos los servidores.';
  }

  @override
  String get tagFormTitleEdit => 'Editar etiqueta';

  @override
  String get tagFormTitleNew => 'Nueva etiqueta';

  @override
  String get tagFormNameLabel => 'Nombre de la etiqueta';

  @override
  String get sshKeyListTitle => 'Claves SSH';

  @override
  String get sshKeyListEmpty => 'Aún no hay claves SSH';

  @override
  String get sshKeyListEmptySubtitle =>
      'Genera o importa claves SSH para administrarlas centralmente';

  @override
  String get sshKeyCannotDeleteTitle => 'No se puede eliminar';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'No se puede eliminar \"$name\". Usada por $count servidor(es). Desvincula de todos los servidores primero.';
  }

  @override
  String get sshKeyDeleteTitle => 'Eliminar clave SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return '¿Eliminar \"$name\"? Esto no se puede deshacer.';
  }

  @override
  String get sshKeyAddButton => 'Agregar clave SSH';

  @override
  String get sshKeyFormTitleEdit => 'Editar clave SSH';

  @override
  String get sshKeyFormTitleAdd => 'Agregar clave SSH';

  @override
  String get sshKeyFormTabGenerate => 'Generar';

  @override
  String get sshKeyFormTabImport => 'Importar';

  @override
  String get sshKeyFormNameLabel => 'Nombre de la clave';

  @override
  String get sshKeyFormNameHint => 'ej. Mi clave de producción';

  @override
  String get sshKeyFormKeyType => 'Tipo de clave';

  @override
  String get sshKeyFormKeySize => 'Tamaño de clave';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Comentario';

  @override
  String get sshKeyFormCommentHint => 'usuario@host o descripción';

  @override
  String get sshKeyFormCommentOptional => 'Comentario (opcional)';

  @override
  String get sshKeyFormImportFromFile => 'Importar desde archivo';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Clave privada';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Pegar clave privada SSH o usar botón de arriba...';

  @override
  String get sshKeyFormPassphraseLabel => 'Passphrase (opcional)';

  @override
  String get sshKeyFormNameRequired => 'El nombre es obligatorio';

  @override
  String get sshKeyFormPrivateKeyRequired => 'La clave privada es obligatoria';

  @override
  String get sshKeyFormFileReadError =>
      'No se pudo leer el archivo seleccionado';

  @override
  String get sshKeyFormInvalidFormat =>
      'Formato de clave inválido — se esperaba formato PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Error al leer archivo: $message';
  }

  @override
  String get sshKeyFormSaving => 'Guardando...';

  @override
  String get sshKeySelectorLabel => 'Clave SSH';

  @override
  String get sshKeySelectorNone => 'Sin clave administrada';

  @override
  String get sshKeySelectorManage => 'Administrar claves...';

  @override
  String get sshKeySelectorError => 'Error al cargar claves SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Copiar clave pública';

  @override
  String get sshKeyTilePublicKeyCopied => 'Clave pública copiada';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Usada por $count servidor(es)';
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
  String get sshKeyTileUnlinkFirst =>
      'Desvincula de todos los servidores primero';

  @override
  String get exportImportTitle => 'Exportar / Importar';

  @override
  String get exportSectionTitle => 'Exportar';

  @override
  String get exportJsonButton => 'Exportar como JSON (sin credenciales)';

  @override
  String get exportZipButton => 'Exportar ZIP cifrado (con credenciales)';

  @override
  String get importSectionTitle => 'Importar';

  @override
  String get importButton => 'Importar desde archivo';

  @override
  String get importSupportedFormats =>
      'Soporta archivos JSON (sin cifrar) y ZIP (cifrados).';

  @override
  String exportedTo(String path) {
    return 'Exportado a: $path';
  }

  @override
  String get share => 'Compartir';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers servidores, $groups grupos, $tags etiquetas importados. $skipped omitidos.';
  }

  @override
  String get importPasswordTitle => 'Ingresar contraseña';

  @override
  String get importPasswordLabel => 'Contraseña de exportación';

  @override
  String get importPasswordDecrypt => 'Descifrar';

  @override
  String get exportPasswordTitle => 'Establecer contraseña de exportación';

  @override
  String get exportPasswordDescription =>
      'Esta contraseña se usará para cifrar tu archivo de exportación incluyendo las credenciales.';

  @override
  String get exportPasswordLabel => 'Contraseña';

  @override
  String get exportPasswordConfirmLabel => 'Confirmar contraseña';

  @override
  String get exportPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get exportPasswordButton => 'Cifrar y exportar';

  @override
  String get importConflictTitle => 'Manejar conflictos';

  @override
  String get importConflictDescription =>
      '¿Cómo se deben manejar las entradas existentes durante la importación?';

  @override
  String get importConflictSkip => 'Omitir existentes';

  @override
  String get importConflictRename => 'Renombrar nuevos';

  @override
  String get importConflictOverwrite => 'Sobrescribir';

  @override
  String get confirmDeleteLabel => 'Eliminar';

  @override
  String get keyGenTitle => 'Generar par de claves SSH';

  @override
  String get keyGenKeyType => 'Tipo de clave';

  @override
  String get keyGenKeySize => 'Tamaño de clave';

  @override
  String get keyGenComment => 'Comentario';

  @override
  String get keyGenCommentHint => 'usuario@host o descripción';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Generando...';

  @override
  String get keyGenGenerate => 'Generar';

  @override
  String keyGenResultTitle(String type) {
    return 'Clave $type generada';
  }

  @override
  String get keyGenPublicKey => 'Clave pública';

  @override
  String get keyGenPrivateKey => 'Clave privada';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Comentario: $comment';
  }

  @override
  String get keyGenAnother => 'Generar otra';

  @override
  String get keyGenUseThisKey => 'Usar esta clave';

  @override
  String get keyGenCopyTooltip => 'Copiar al portapapeles';

  @override
  String keyGenCopied(String label) {
    return '$label copiada';
  }

  @override
  String get colorPickerLabel => 'Color';

  @override
  String get iconPickerLabel => 'Icono';

  @override
  String get tagSelectorLabel => 'Etiquetas';

  @override
  String get tagSelectorEmpty => 'Aún no hay etiquetas';

  @override
  String get tagSelectorError => 'Error al cargar etiquetas';

  @override
  String get snippetListTitle => 'Snippets';

  @override
  String get snippetSearchHint => 'Buscar snippets...';

  @override
  String get snippetListEmpty => 'Aún no hay snippets';

  @override
  String get snippetListEmptySubtitle =>
      'Crea snippets de código reutilizables y comandos.';

  @override
  String get snippetAddButton => 'Agregar snippet';

  @override
  String get snippetDeleteTitle => 'Eliminar snippet';

  @override
  String snippetDeleteMessage(String name) {
    return '¿Eliminar \"$name\"? Esto no se puede deshacer.';
  }

  @override
  String get snippetFormTitleEdit => 'Editar snippet';

  @override
  String get snippetFormTitleNew => 'Nuevo snippet';

  @override
  String get snippetFormNameLabel => 'Nombre';

  @override
  String get snippetFormNameHint => 'ej. Limpieza de Docker';

  @override
  String get snippetFormLanguageLabel => 'Lenguaje';

  @override
  String get snippetFormContentLabel => 'Contenido';

  @override
  String get snippetFormContentHint => 'Ingresa tu código snippet...';

  @override
  String get snippetFormDescriptionLabel => 'Descripción';

  @override
  String get snippetFormDescriptionHint => 'Descripción opcional...';

  @override
  String get snippetFormFolderLabel => 'Carpeta';

  @override
  String get snippetFormNoFolder => 'Sin carpeta';

  @override
  String get snippetFormNameRequired => 'El nombre es obligatorio';

  @override
  String get snippetFormContentRequired => 'El contenido es obligatorio';

  @override
  String get snippetFormSaved => 'Snippet guardado';

  @override
  String get snippetFormUpdateButton => 'Actualizar snippet';

  @override
  String get snippetFormCreateButton => 'Crear snippet';

  @override
  String get snippetDetailTitle => 'Detalles del snippet';

  @override
  String get snippetDetailDeleteTitle => 'Eliminar snippet';

  @override
  String get snippetDetailDeleteMessage => 'Esta acción no se puede deshacer.';

  @override
  String get snippetDetailContent => 'Contenido';

  @override
  String get snippetDetailFillVariables => 'Llenar variables';

  @override
  String get snippetDetailDescription => 'Descripción';

  @override
  String get snippetDetailVariables => 'Variables';

  @override
  String get snippetDetailTags => 'Etiquetas';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Creado';

  @override
  String get snippetDetailUpdated => 'Actualizado';

  @override
  String get variableEditorTitle => 'Variables de plantilla';

  @override
  String get variableEditorAdd => 'Agregar';

  @override
  String get variableEditorEmpty =>
      'Sin variables. Usa sintaxis de llaves en el contenido para referenciarlas.';

  @override
  String get variableEditorNameLabel => 'Nombre';

  @override
  String get variableEditorNameHint => 'ej. hostname';

  @override
  String get variableEditorDefaultLabel => 'Predeterminado';

  @override
  String get variableEditorDefaultHint => 'opcional';

  @override
  String get variableFillTitle => 'Llenar variables';

  @override
  String variableFillHint(String name) {
    return 'Ingresa valor para $name';
  }

  @override
  String get variableFillPreview => 'Vista previa';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Sin sesiones activas';

  @override
  String get terminalEmptySubtitle =>
      'Conéctate a un host para abrir una sesión de terminal.';

  @override
  String get terminalGoToHosts => 'Ir a Hosts';

  @override
  String get terminalCloseAll => 'Cerrar todas las sesiones';

  @override
  String get terminalCloseTitle => 'Cerrar sesión';

  @override
  String terminalCloseMessage(String title) {
    return '¿Cerrar la conexión activa a \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Autenticando...';

  @override
  String connectionConnecting(String name) {
    return 'Conectando a $name...';
  }

  @override
  String get connectionError => 'Error de conexión';

  @override
  String get connectionLost => 'Conexión perdida';

  @override
  String get connectionReconnect => 'Reconectar';

  @override
  String get snippetQuickPanelTitle => 'Insertar snippet';

  @override
  String get snippetQuickPanelSearch => 'Buscar snippets...';

  @override
  String get snippetQuickPanelEmpty => 'No hay snippets disponibles';

  @override
  String get snippetQuickPanelNoMatch => 'No hay snippets coincidentes';

  @override
  String get snippetQuickPanelInsertTooltip => 'Insertar snippet';

  @override
  String get terminalThemePickerTitle => 'Tema del terminal';

  @override
  String get validatorHostnameRequired => 'El hostname es obligatorio';

  @override
  String get validatorHostnameInvalid => 'Hostname o dirección IP inválida';

  @override
  String get validatorPortRequired => 'El puerto es obligatorio';

  @override
  String get validatorPortRange => 'El puerto debe estar entre 1 y 65535';

  @override
  String get validatorUsernameRequired => 'El usuario es obligatorio';

  @override
  String get validatorUsernameInvalid => 'Formato de usuario inválido';

  @override
  String get validatorServerNameRequired =>
      'El nombre del servidor es obligatorio';

  @override
  String get validatorServerNameLength =>
      'El nombre del servidor debe tener 100 caracteres o menos';

  @override
  String get validatorSshKeyInvalid => 'Formato de clave SSH inválido';

  @override
  String get validatorPasswordRequired => 'La contraseña es obligatoria';

  @override
  String get validatorPasswordLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get authMethodPassword => 'Contraseña';

  @override
  String get authMethodKey => 'Clave SSH';

  @override
  String get authMethodBoth => 'Contraseña + Clave';

  @override
  String get serverCopySuffix => '(Copia)';

  @override
  String get settingsDownloadLogs => 'Descargar registros';

  @override
  String get settingsSendLogs => 'Enviar registros al soporte';

  @override
  String get settingsLogsSaved => 'Registros guardados exitosamente';

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
  String get settingsLogsEmpty => 'No hay entradas de registro disponibles';

  @override
  String get authLogin => 'Iniciar sesión';

  @override
  String get authRegister => 'Registrarse';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authWhyLogin =>
      'Inicia sesión para habilitar la sincronización cifrada en la nube en todos tus dispositivos. La app funciona completamente sin conexión sin una cuenta.';

  @override
  String get authEmailLabel => 'Correo electrónico';

  @override
  String get authEmailRequired => 'El correo electrónico es obligatorio';

  @override
  String get authEmailInvalid => 'Dirección de correo inválida';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get authPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get authNoAccount => '¿Sin cuenta?';

  @override
  String get authHasAccount => '¿Ya tienes una cuenta?';

  @override
  String get authResetEmailSent =>
      'Si existe una cuenta, se ha enviado un enlace de restablecimiento a tu correo.';

  @override
  String get authResetDescription =>
      'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.';

  @override
  String get authSendResetLink => 'Enviar enlace de restablecimiento';

  @override
  String get authBackToLogin => 'Volver al inicio de sesión';

  @override
  String get syncPasswordTitle => 'Contraseña de sincronización';

  @override
  String get syncPasswordTitleCreate =>
      'Establecer contraseña de sincronización';

  @override
  String get syncPasswordTitleEnter => 'Ingresar contraseña de sincronización';

  @override
  String get syncPasswordDescription =>
      'Establece una contraseña separada para cifrar tus datos del vault. Esta contraseña nunca sale de tu dispositivo — el servidor solo almacena datos cifrados.';

  @override
  String get syncPasswordHintEnter =>
      'Ingresa la contraseña que estableciste al crear tu cuenta.';

  @override
  String get syncPasswordWarning =>
      'Si olvidas esta contraseña, tus datos sincronizados no se pueden recuperar. No hay opción de restablecimiento.';

  @override
  String get syncPasswordLabel => 'Contraseña de sincronización';

  @override
  String get syncPasswordWrong => 'Contraseña incorrecta. Inténtalo de nuevo.';

  @override
  String get firstSyncTitle => 'Datos existentes encontrados';

  @override
  String get firstSyncMessage =>
      'Este dispositivo tiene datos existentes y el servidor tiene un vault. ¿Cómo proceder?';

  @override
  String get firstSyncMerge => 'Fusionar (servidor tiene prioridad)';

  @override
  String get firstSyncOverwriteLocal => 'Sobrescribir datos locales';

  @override
  String get firstSyncKeepLocal => 'Mantener local y subir';

  @override
  String get firstSyncDeleteLocal => 'Eliminar local y descargar';

  @override
  String get changeEncryptionPassword => 'Cambiar contraseña de cifrado';

  @override
  String get changeEncryptionWarning =>
      'Se cerrará la sesión en todos los demás dispositivos.';

  @override
  String get changeEncryptionOldPassword => 'Contraseña actual';

  @override
  String get changeEncryptionNewPassword => 'Nueva contraseña';

  @override
  String get changeEncryptionSuccess => 'Contraseña cambiada exitosamente.';

  @override
  String get logoutAllDevices => 'Cerrar sesión en todos los dispositivos';

  @override
  String get logoutAllDevicesConfirm =>
      'Esto revocará todas las sesiones activas. Necesitarás iniciar sesión nuevamente en todos los dispositivos.';

  @override
  String get logoutAllDevicesSuccess => 'Todos los dispositivos desconectados.';

  @override
  String get syncSettingsTitle => 'Ajustes de sincronización';

  @override
  String get syncAutoSync => 'Sincronización automática';

  @override
  String get syncAutoSyncDescription =>
      'Sincronizar automáticamente al iniciar la app';

  @override
  String get syncNow => 'Sincronizar ahora';

  @override
  String get syncSyncing => 'Sincronizando...';

  @override
  String get syncSuccess => 'Sincronización completada';

  @override
  String get syncError => 'Error de sincronización';

  @override
  String get syncServerUnreachable => 'Servidor no accesible';

  @override
  String get syncServerUnreachableHint =>
      'No se pudo conectar al servidor de sincronización. Verifica tu conexión a internet y la URL del servidor.';

  @override
  String get syncNetworkError =>
      'La conexión al servidor falló. Verifica tu conexión a internet o inténtalo más tarde.';

  @override
  String get syncNeverSynced => 'Nunca sincronizado';

  @override
  String get syncVaultVersion => 'Versión del vault';

  @override
  String get syncTitle => 'Sync';

  @override
  String get settingsSectionNetwork => 'Red y DNS';

  @override
  String get settingsDnsServers => 'Servidores DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Predeterminado (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Ingresa URLs personalizadas de servidores DoH, separadas por comas. Se necesitan al menos 2 servidores para la verificación cruzada.';

  @override
  String get settingsDnsLabel => 'URLs de servidores DoH';

  @override
  String get settingsDnsReset => 'Restablecer predeterminado';

  @override
  String get settingsSectionSync => 'Sincronización';

  @override
  String get settingsSyncAccount => 'Cuenta';

  @override
  String get settingsSyncNotLoggedIn => 'No conectado';

  @override
  String get settingsSyncStatus => 'Sync';

  @override
  String get settingsSyncServerUrl => 'URL del servidor';

  @override
  String get settingsSyncDefaultServer => 'Predeterminado (sshvault.app)';

  @override
  String get accountTitle => 'Cuenta';

  @override
  String get accountNotLoggedIn => 'No conectado';

  @override
  String get accountVerified => 'Verificado';

  @override
  String get accountMemberSince => 'Miembro desde';

  @override
  String get accountDevices => 'Dispositivos';

  @override
  String get accountNoDevices => 'No hay dispositivos registrados';

  @override
  String get accountLastSync => 'Última sincronización';

  @override
  String get accountChangePassword => 'Cambiar contraseña';

  @override
  String get accountOldPassword => 'Contraseña actual';

  @override
  String get accountNewPassword => 'Nueva contraseña';

  @override
  String get accountDeleteAccount => 'Eliminar cuenta';

  @override
  String get accountDeleteWarning =>
      'Esto eliminará permanentemente tu cuenta y todos los datos sincronizados. No se puede deshacer.';

  @override
  String get accountLogout => 'Cerrar sesión';

  @override
  String get serverConfigTitle => 'Configuración del servidor';

  @override
  String get serverConfigUrlLabel => 'URL del servidor';

  @override
  String get serverConfigTest => 'Probar conexión';

  @override
  String get serverSetupTitle => 'Configuración del servidor';

  @override
  String get serverSetupInfoCard =>
      'ShellVault requiere un servidor autohospedado para la sincronización cifrada de extremo a extremo. Despliega tu propia instancia para comenzar.';

  @override
  String get serverSetupRepoLink => 'Ver en GitHub';

  @override
  String get serverSetupContinue => 'Continuar';

  @override
  String get settingsServerNotConfigured => 'Servidor no configurado';

  @override
  String get settingsSetupSync =>
      'Configurar sincronización para respaldar tus datos';

  @override
  String get settingsChangeServer => 'Cambiar servidor';

  @override
  String get settingsChangeServerConfirm =>
      'Cambiar el servidor cerrará tu sesión. ¿Continuar?';

  @override
  String get auditLogTitle => 'Registro de actividad';

  @override
  String get auditLogAll => 'Todos';

  @override
  String get auditLogEmpty => 'No se encontraron registros de actividad';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Gestor de archivos';

  @override
  String get sftpLocalDevice => 'Dispositivo local';

  @override
  String get sftpSelectServer => 'Seleccionar servidor...';

  @override
  String get sftpConnecting => 'Conectando...';

  @override
  String get sftpEmptyDirectory => 'Este directorio está vacío';

  @override
  String get sftpNoConnection => 'Ningún servidor conectado';

  @override
  String get sftpPathLabel => 'Ruta';

  @override
  String get sftpUpload => 'Subir';

  @override
  String get sftpDownload => 'Descargar';

  @override
  String get sftpDelete => 'Eliminar';

  @override
  String get sftpRename => 'Renombrar';

  @override
  String get sftpNewFolder => 'Nueva carpeta';

  @override
  String get sftpNewFolderName => 'Nombre de carpeta';

  @override
  String get sftpChmod => 'Permisos';

  @override
  String get sftpChmodTitle => 'Cambiar permisos';

  @override
  String get sftpChmodOctal => 'Octal';

  @override
  String get sftpChmodOwner => 'Propietario';

  @override
  String get sftpChmodGroup => 'Grupo';

  @override
  String get sftpChmodOther => 'Otros';

  @override
  String get sftpChmodRead => 'Leer';

  @override
  String get sftpChmodWrite => 'Escribir';

  @override
  String get sftpChmodExecute => 'Ejecutar';

  @override
  String get sftpCreateSymlink => 'Crear enlace simbólico';

  @override
  String get sftpSymlinkTarget => 'Ruta destino';

  @override
  String get sftpSymlinkName => 'Nombre del enlace';

  @override
  String get sftpFilePreview => 'Vista previa';

  @override
  String get sftpFileInfo => 'Info del archivo';

  @override
  String get sftpFileSize => 'Tamaño';

  @override
  String get sftpFileModified => 'Modificado';

  @override
  String get sftpFilePermissions => 'Permisos';

  @override
  String get sftpFileOwner => 'Propietario';

  @override
  String get sftpFileType => 'Tipo';

  @override
  String get sftpFileLinkTarget => 'Destino del enlace';

  @override
  String get sftpTransfers => 'Transferencias';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current de $total';
  }

  @override
  String get sftpTransferQueued => 'En cola';

  @override
  String get sftpTransferActive => 'Transfiriendo...';

  @override
  String get sftpTransferPaused => 'Pausado';

  @override
  String get sftpTransferCompleted => 'Completado';

  @override
  String get sftpTransferFailed => 'Fallido';

  @override
  String get sftpTransferCancelled => 'Cancelado';

  @override
  String get sftpPauseTransfer => 'Pausar';

  @override
  String get sftpResumeTransfer => 'Reanudar';

  @override
  String get sftpCancelTransfer => 'Cancelar';

  @override
  String get sftpClearCompleted => 'Limpiar completados';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active de $total transferencias';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activas',
      one: '1 activa',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count completadas',
      one: '1 completada',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fallidas',
      one: '1 fallida',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Copiar al otro panel';

  @override
  String sftpConfirmDelete(int count) {
    return '¿Eliminar $count elementos?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Eliminado exitosamente';

  @override
  String get sftpRenameTitle => 'Renombrar';

  @override
  String get sftpRenameLabel => 'Nuevo nombre';

  @override
  String get sftpSortByName => 'Nombre';

  @override
  String get sftpSortBySize => 'Tamaño';

  @override
  String get sftpSortByDate => 'Fecha';

  @override
  String get sftpSortByType => 'Tipo';

  @override
  String get sftpShowHidden => 'Mostrar archivos ocultos';

  @override
  String get sftpHideHidden => 'Ocultar archivos ocultos';

  @override
  String get sftpSelectAll => 'Seleccionar todo';

  @override
  String get sftpDeselectAll => 'Deseleccionar todo';

  @override
  String sftpItemsSelected(int count) {
    return '$count seleccionados';
  }

  @override
  String get sftpRefresh => 'Actualizar';

  @override
  String sftpConnectionError(String message) {
    return 'Conexión fallida: $message';
  }

  @override
  String get sftpPermissionDenied => 'Permiso denegado';

  @override
  String sftpOperationFailed(String message) {
    return 'Operación fallida: $message';
  }

  @override
  String get sftpOverwriteTitle => 'El archivo ya existe';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" ya existe. ¿Sobrescribir?';
  }

  @override
  String get sftpOverwrite => 'Sobrescribir';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Transferencia iniciada: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Selecciona primero un destino en el otro panel';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Transferencia de carpetas próximamente';

  @override
  String get sftpSelect => 'Seleccionar';

  @override
  String get sftpOpen => 'Abrir';

  @override
  String get sftpExtractArchive => 'Extraer aquí';

  @override
  String get sftpExtractSuccess => 'Archivo extraído';

  @override
  String sftpExtractFailed(String message) {
    return 'Extracción fallida: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Formato no soportado';

  @override
  String get sftpExtracting => 'Extrayendo...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subidas iniciadas',
      one: 'Subida iniciada',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count descargas iniciadas',
      one: 'Descarga iniciada',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" descargado';
  }

  @override
  String get sftpSavedToDownloads => 'Guardado en Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Guardar en Archivos';

  @override
  String get sftpFileSaved => 'Archivo guardado';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones SSH activas',
      one: 'Sesión SSH activa',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Toca para abrir el terminal';

  @override
  String get settingsAccountAndSync => 'Cuenta y Sync';

  @override
  String get settingsAccountSubtitleAuth => 'Conectado';

  @override
  String get settingsAccountSubtitleUnauth => 'No conectado';

  @override
  String get settingsSecuritySubtitle => 'Bloqueo automático, Biometría, PIN';

  @override
  String get settingsSshSubtitle => 'Puerto 22, Usuario root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, Idioma, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Exportación cifrada por defecto';

  @override
  String get settingsAboutSubtitle => 'Versión, Licencias';

  @override
  String get settingsSearchHint => 'Buscar ajustes...';

  @override
  String get settingsSearchNoResults => 'No se encontraron ajustes';

  @override
  String get aboutDeveloper => 'Desarrollado por Kiefer Networks';

  @override
  String get aboutDonate => 'Donar';

  @override
  String get aboutOpenSourceLicenses => 'Licencias de código abierto';

  @override
  String get aboutWebsite => 'Sitio web';

  @override
  String get aboutVersion => 'Versión';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS cifra las consultas DNS y previene el envenenamiento DNS. SSHVault verifica los nombres de host contra múltiples proveedores para detectar ataques.';

  @override
  String get settingsDnsAddServer => 'Añadir servidor DNS';

  @override
  String get settingsDnsServerUrl => 'URL del servidor';

  @override
  String get settingsDnsDefaultBadge => 'Predeterminado';

  @override
  String get settingsDnsResetDefaults => 'Restablecer valores predeterminados';

  @override
  String get settingsDnsInvalidUrl => 'Introduce una URL HTTPS válida';

  @override
  String get settingsDefaultAuthMethod => 'Método de autenticación';

  @override
  String get settingsAuthPassword => 'Contraseña';

  @override
  String get settingsAuthKey => 'Clave SSH';

  @override
  String get settingsConnectionTimeout => 'Tiempo de espera de conexión';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Intervalo Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Compresión';

  @override
  String get settingsCompressionDescription =>
      'Habilitar compresión zlib para conexiones SSH';

  @override
  String get settingsTerminalType => 'Tipo de terminal';

  @override
  String get settingsSectionConnection => 'Conexión';

  @override
  String get settingsClipboardAutoClear =>
      'Limpiar portapapeles automáticamente';

  @override
  String get settingsClipboardAutoClearOff => 'Desactivado';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Tiempo de espera de sesión';

  @override
  String get settingsSessionTimeoutOff => 'Desactivado';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'PIN de emergencia';

  @override
  String get settingsDuressPinDescription =>
      'Un PIN separado que borra todos los datos al ingresarlo';

  @override
  String get settingsDuressPinSet => 'PIN de emergencia configurado';

  @override
  String get settingsDuressPinNotSet => 'No configurado';

  @override
  String get settingsDuressPinWarning =>
      'Al ingresar este PIN se eliminarán permanentemente todos los datos locales, incluyendo credenciales, claves y configuraciones.';

  @override
  String get settingsKeyRotationReminder =>
      'Recordatorio de rotación de claves';

  @override
  String get settingsKeyRotationOff => 'Desactivado';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days días';
  }

  @override
  String get settingsFailedAttempts => 'Intentos fallidos de PIN';

  @override
  String get settingsSectionAppLock => 'Bloqueo de app';

  @override
  String get settingsSectionPrivacy => 'Privacidad';

  @override
  String get settingsSectionReminders => 'Recordatorios';

  @override
  String get settingsSectionStatus => 'Estado';

  @override
  String get settingsExportBackupSubtitle => 'Exportar, Importar y Respaldo';

  @override
  String get settingsExportJson => 'Exportar como JSON';

  @override
  String get settingsExportEncrypted => 'Exportar cifrado';

  @override
  String get settingsImportFile => 'Importar desde archivo';

  @override
  String get settingsSectionImport => 'Importar';

  @override
  String get filterTitle => 'Filtrar servidores';

  @override
  String get filterApply => 'Aplicar filtros';

  @override
  String get filterClearAll => 'Limpiar todo';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtros activos',
      one: '1 filtro activo',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Carpeta';

  @override
  String get filterTags => 'Etiquetas';

  @override
  String get filterStatus => 'Estado';

  @override
  String get variablePreviewResolved => 'Vista previa resuelta';

  @override
  String get variableInsert => 'Insertar';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servidores',
      one: '1 servidor',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones revocadas.',
      one: '1 sesión revocada.',
    );
    return '$_temp0 Se ha cerrado tu sesión.';
  }

  @override
  String get keyGenPassphrase => 'Passphrase';

  @override
  String get keyGenPassphraseHint => 'Opcional — protege la clave privada';

  @override
  String get settingsDnsDefaultQuad9Mullvad =>
      'Predeterminado (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Ya existe una clave con la misma huella digital: \"$name\". Cada clave SSH debe ser única.';
  }

  @override
  String get sshKeyFingerprint => 'Huella digital';

  @override
  String get sshKeyPublicKey => 'Clave pública';

  @override
  String get jumpHost => 'Host de salto';

  @override
  String get jumpHostNone => 'Ninguno';

  @override
  String get jumpHostLabel => 'Conectar vía host de salto';

  @override
  String get jumpHostSelfError =>
      'Un servidor no puede ser su propio host de salto';

  @override
  String get jumpHostConnecting => 'Conectando al host de salto…';

  @override
  String get jumpHostCircularError =>
      'Cadena circular de host de salto detectada';

  @override
  String get logoutDialogTitle => 'Cerrar sesión';

  @override
  String get logoutDialogMessage =>
      '¿Quieres eliminar todos los datos locales? Servidores, claves SSH, snippets y configuraciones se eliminarán de este dispositivo.';

  @override
  String get logoutOnly => 'Solo cerrar sesión';

  @override
  String get logoutAndDelete => 'Cerrar sesión y eliminar datos';

  @override
  String get changeAvatar => 'Cambiar avatar';

  @override
  String get removeAvatar => 'Eliminar avatar';

  @override
  String get avatarUploadFailed => 'Error al subir el avatar';

  @override
  String get avatarTooLarge => 'La imagen es demasiado grande';

  @override
  String get deviceLastSeen => 'Visto por última vez';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'No se puede cambiar la URL del servidor mientras estás conectado. Cierra sesión primero.';

  @override
  String get serverListNoFolder => 'Sin categoría';

  @override
  String get autoSyncInterval => 'Intervalo de sincronización';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Configuración de proxy';

  @override
  String get proxyType => 'Tipo de proxy';

  @override
  String get proxyNone => 'Sin proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Host del proxy';

  @override
  String get proxyPort => 'Puerto del proxy';

  @override
  String get proxyUsername => 'Usuario del proxy';

  @override
  String get proxyPassword => 'Contraseña del proxy';

  @override
  String get proxyUseGlobal => 'Usar proxy global';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Específico del servidor';

  @override
  String get proxyTestConnection => 'Probar conexión';

  @override
  String get proxyTestSuccess => 'Proxy accesible';

  @override
  String get proxyTestFailed => 'Proxy no accesible';

  @override
  String get proxyDefaultProxy => 'Proxy predeterminado';

  @override
  String get vpnRequired => 'VPN requerido';

  @override
  String get vpnRequiredTooltip =>
      'Mostrar advertencia al conectar sin VPN activa';

  @override
  String get vpnActive => 'VPN activa';

  @override
  String get vpnInactive => 'VPN inactiva';

  @override
  String get vpnWarningTitle => 'VPN no activa';

  @override
  String get vpnWarningMessage =>
      'Este servidor requiere una conexión VPN, pero no hay VPN activa. ¿Conectar de todos modos?';

  @override
  String get vpnConnectAnyway => 'Conectar de todos modos';

  @override
  String get postConnectCommands => 'Comandos Post-Conexión';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Comandos ejecutados automáticamente después de la conexión (uno por línea)';

  @override
  String get dashboardFavorites => 'Favoritos';

  @override
  String get dashboardRecent => 'Recientes';

  @override
  String get dashboardActiveSessions => 'Sesiones activas';

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get removeFromFavorites => 'Quitar de favoritos';

  @override
  String get noRecentConnections => 'Sin conexiones recientes';

  @override
  String get terminalSplit => 'Vista dividida';

  @override
  String get terminalUnsplit => 'Cerrar división';

  @override
  String get terminalSelectSession => 'Seleccionar sesión para vista dividida';

  @override
  String get knownHostsTitle => 'Hosts conocidos';

  @override
  String get knownHostsSubtitle =>
      'Gestionar huellas digitales de servidores de confianza';

  @override
  String get hostKeyNewTitle => 'Nuevo host';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Primera conexión a $hostname:$port. Verifica la huella digital antes de conectar.';
  }

  @override
  String get hostKeyChangedTitle => '¡Clave del host cambiada!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'La clave del host para $hostname:$port ha cambiado. Esto podría indicar una amenaza de seguridad.';
  }

  @override
  String get hostKeyFingerprint => 'Huella digital';

  @override
  String get hostKeyType => 'Tipo de clave';

  @override
  String get hostKeyTrustConnect => 'Confiar y conectar';

  @override
  String get hostKeyAcceptNew => 'Aceptar nueva clave';

  @override
  String get hostKeyReject => 'Rechazar';

  @override
  String get hostKeyPreviousFingerprint => 'Huella digital anterior';

  @override
  String get hostKeyDeleteAll => 'Eliminar todos los hosts conocidos';

  @override
  String get hostKeyDeleteConfirm =>
      '¿Estás seguro de que quieres eliminar todos los hosts conocidos? Se te preguntará de nuevo en la próxima conexión.';

  @override
  String get hostKeyEmpty => 'Aún no hay hosts conocidos';

  @override
  String get hostKeyEmptySubtitle =>
      'Las huellas digitales de los hosts se almacenarán aquí después de tu primera conexión';

  @override
  String get hostKeyFirstSeen => 'Visto por primera vez';

  @override
  String get hostKeyLastSeen => 'Visto por última vez';

  @override
  String get sshConfigImportTitle => 'Importar config SSH';

  @override
  String get sshConfigImportPickFile => 'Seleccionar archivo de config SSH';

  @override
  String get sshConfigImportOrPaste => 'O pegar contenido de config';

  @override
  String sshConfigImportParsed(int count) {
    return '$count hosts encontrados';
  }

  @override
  String get sshConfigImportButton => 'Importar seleccionados';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count servidores importados';
  }

  @override
  String get sshConfigImportDuplicate => 'Ya existe';

  @override
  String get sshConfigImportNoHosts => 'No se encontraron hosts en la config';

  @override
  String get sftpBookmarkAdd => 'Agregar marcador';

  @override
  String get sftpBookmarkLabel => 'Etiqueta';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get reportAndDisconnect => 'Reportar y desconectar';

  @override
  String get continueAnyway => 'Continuar de todos modos';

  @override
  String get insertSnippet => 'Insertar snippet';

  @override
  String get seconds => 'Segundos';

  @override
  String get heartbeatLostMessage =>
      'No se pudo contactar al servidor tras múltiples intentos. Por tu seguridad, la sesión ha sido terminada.';

  @override
  String get attestationFailedTitle => 'Verificación del servidor fallida';

  @override
  String get attestationFailedMessage =>
      'No se pudo verificar el servidor como un backend legítimo de SSHVault. Esto puede indicar un ataque de intermediario o un servidor mal configurado.';

  @override
  String get attestationKeyChangedTitle => 'Clave del servidor cambiada';

  @override
  String get attestationKeyChangedMessage =>
      'La clave de atestación del servidor ha cambiado desde la conexión inicial. Esto puede indicar un ataque de intermediario. NO continúes a menos que el administrador del servidor haya confirmado una rotación de claves.';

  @override
  String get sectionLinks => 'Enlaces';

  @override
  String get sectionDeveloper => 'Desarrollador';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Página no encontrada';

  @override
  String get connectionTestSuccess => 'Conexión exitosa';

  @override
  String connectionTestFailed(String message) {
    return 'Conexión fallida: $message';
  }

  @override
  String get serverVerificationFailed => 'Verificación del servidor fallida';

  @override
  String get importSuccessful => 'Importación exitosa';

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
  String get deviceDeleteConfirmTitle => 'Eliminar dispositivo';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return '¿Seguro que quieres eliminar \"$name\"? El dispositivo se cerrará sesión inmediatamente.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Este es tu dispositivo actual. Se cerrará la sesión inmediatamente.';

  @override
  String get deviceDeleteSuccess => 'Dispositivo eliminado';

  @override
  String get deviceDeletedCurrentLogout =>
      'Dispositivo actual eliminado. Se ha cerrado la sesión.';

  @override
  String get thisDevice => 'Este dispositivo';
}
