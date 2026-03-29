// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Hosts';

  @override
  String get navSnippets => 'Snippets';

  @override
  String get navFolders => 'Pastas';

  @override
  String get navTags => 'Tags';

  @override
  String get navSshKeys => 'Chaves SSH';

  @override
  String get navExportImport => 'Exportar / Importar';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Mais';

  @override
  String get navManagement => 'Gerenciamento';

  @override
  String get navSettings => 'Configurações';

  @override
  String get navAbout => 'Sobre';

  @override
  String get lockScreenTitle => 'SSHVault está bloqueado';

  @override
  String get lockScreenUnlock => 'Desbloquear';

  @override
  String get lockScreenEnterPin => 'Digite o PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Muitas tentativas falhas. Tente novamente em $minutes min.';
  }

  @override
  String get pinDialogSetTitle => 'Definir código PIN';

  @override
  String get pinDialogSetSubtitle =>
      'Digite um PIN de 6 dígitos para proteger o SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Confirmar PIN';

  @override
  String get pinDialogErrorLength => 'O PIN deve ter exatamente 6 dígitos';

  @override
  String get pinDialogErrorMismatch => 'Os PINs não coincidem';

  @override
  String get pinDialogVerifyTitle => 'Digite o PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN incorreto. $attempts tentativas restantes.';
  }

  @override
  String get securityBannerMessage =>
      'Suas credenciais SSH não estão protegidas. Configure um PIN ou bloqueio biométrico nas Configurações.';

  @override
  String get securityBannerDismiss => 'Ignorar';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionAppearance => 'Aparência';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'Padrões SSH';

  @override
  String get settingsSectionSecurity => 'Segurança';

  @override
  String get settingsSectionExport => 'Exportação';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsTerminalTheme => 'Tema do terminal';

  @override
  String get settingsTerminalThemeDefault => 'Escuro padrão';

  @override
  String get settingsFontSize => 'Tamanho da fonte';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Porta padrão';

  @override
  String get settingsDefaultPortDialog => 'Porta SSH padrão';

  @override
  String get settingsPortLabel => 'Porta';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Nome de usuário padrão';

  @override
  String get settingsDefaultUsernameDialog => 'Nome de usuário padrão';

  @override
  String get settingsUsernameLabel => 'Nome de usuário';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Bloqueio automático';

  @override
  String get settingsAutoLockDisabled => 'Desativado';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get settingsAutoLockOff => 'Desligado';

  @override
  String get settingsAutoLock1Min => '1 min';

  @override
  String get settingsAutoLock5Min => '5 min';

  @override
  String get settingsAutoLock15Min => '15 min';

  @override
  String get settingsAutoLock30Min => '30 min';

  @override
  String get settingsBiometricUnlock => 'Desbloqueio biométrico';

  @override
  String get settingsBiometricNotAvailable =>
      'Não disponível neste dispositivo';

  @override
  String get settingsBiometricError => 'Erro ao verificar biometria';

  @override
  String get settingsBiometricReason =>
      'Verifique sua identidade para ativar o desbloqueio biométrico';

  @override
  String get settingsBiometricRequiresPin =>
      'Defina um PIN primeiro para ativar o desbloqueio biométrico';

  @override
  String get settingsPinCode => 'Código PIN';

  @override
  String get settingsPinIsSet => 'PIN definido';

  @override
  String get settingsPinNotConfigured => 'Nenhum PIN configurado';

  @override
  String get settingsPinRemove => 'Remover';

  @override
  String get settingsPinRemoveWarning =>
      'Remover o PIN descriptografará todos os campos do banco de dados e desativará o desbloqueio biométrico. Continuar?';

  @override
  String get settingsPinRemoveTitle => 'Remover PIN';

  @override
  String get settingsPreventScreenshots => 'Impedir capturas de tela';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Bloquear capturas de tela e gravação de tela';

  @override
  String get settingsEncryptExport => 'Criptografar exportações por padrão';

  @override
  String get settingsAbout => 'Sobre o SSHVault';

  @override
  String get settingsAboutLegalese => 'por Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Cliente SSH seguro e auto-hospedado';

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
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get close => 'Fechar';

  @override
  String get update => 'Atualizar';

  @override
  String get create => 'Criar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get copy => 'Copiar';

  @override
  String get edit => 'Editar';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Erro: $message';
  }

  @override
  String get serverListTitle => 'Hosts';

  @override
  String get serverListEmpty => 'Nenhum servidor ainda';

  @override
  String get serverListEmptySubtitle =>
      'Adicione seu primeiro servidor SSH para começar.';

  @override
  String get serverAddButton => 'Adicionar servidor';

  @override
  String sshConfigImportMessage(int count) {
    return '$count host(s) encontrado(s) em ~/.ssh/config. Importar?';
  }

  @override
  String get sshConfigNotFound =>
      'Nenhum arquivo de configuração SSH encontrado';

  @override
  String get sshConfigEmpty => 'Nenhum host encontrado na configuração SSH';

  @override
  String get sshConfigAddManually => 'Adicionar manualmente';

  @override
  String get sshConfigImportAgain => 'Importar configuração SSH novamente?';

  @override
  String get sshConfigImportKeys =>
      'Importar chaves SSH referenciadas pelos hosts selecionados?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count chave(s) SSH importada(s)';
  }

  @override
  String get serverDuplicated => 'Servidor duplicado';

  @override
  String get serverDeleteTitle => 'Excluir servidor';

  @override
  String serverDeleteMessage(String name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get serverConnect => 'Conectar';

  @override
  String get serverDetails => 'Detalhes';

  @override
  String get serverDuplicate => 'Duplicar';

  @override
  String get serverActive => 'Ativo';

  @override
  String get serverNoFolder => 'Sem pasta';

  @override
  String get serverFormTitleEdit => 'Editar servidor';

  @override
  String get serverFormTitleAdd => 'Adicionar servidor';

  @override
  String get serverFormUpdateButton => 'Atualizar servidor';

  @override
  String get serverFormAddButton => 'Adicionar servidor';

  @override
  String get serverFormPublicKeyExtracted =>
      'Chave pública extraída com sucesso';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Não foi possível extrair a chave pública: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Par de chaves $type gerado';
  }

  @override
  String get serverDetailTitle => 'Detalhes do servidor';

  @override
  String get serverDetailDeleteMessage => 'Esta ação não pode ser desfeita.';

  @override
  String get serverDetailConnection => 'Conexão';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Porta';

  @override
  String get serverDetailUsername => 'Nome de usuário';

  @override
  String get serverDetailFolder => 'Pasta';

  @override
  String get serverDetailTags => 'Tags';

  @override
  String get serverDetailNotes => 'Notas';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Criado';

  @override
  String get serverDetailUpdated => 'Atualizado';

  @override
  String get serverDetailDistro => 'Sistema';

  @override
  String get copiedToClipboard => 'Copiado para a área de transferência';

  @override
  String get serverFormNameLabel => 'Nome do servidor';

  @override
  String get serverFormHostnameLabel => 'Nome do host / IP';

  @override
  String get serverFormPortLabel => 'Porta';

  @override
  String get serverFormUsernameLabel => 'Nome de usuário';

  @override
  String get serverFormPasswordLabel => 'Senha';

  @override
  String get serverFormUseManagedKey => 'Usar chave gerenciada';

  @override
  String get serverFormManagedKeySubtitle =>
      'Selecionar entre chaves SSH gerenciadas centralmente';

  @override
  String get serverFormDirectKeySubtitle =>
      'Colar a chave diretamente neste servidor';

  @override
  String get serverFormGenerateKey => 'Gerar par de chaves SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Chave privada';

  @override
  String get serverFormPrivateKeyHint => 'Cole a chave privada SSH...';

  @override
  String get serverFormExtractPublicKey => 'Extrair chave pública';

  @override
  String get serverFormPublicKeyLabel => 'Chave pública';

  @override
  String get serverFormPublicKeyHint =>
      'Gerada automaticamente a partir da chave privada se vazio';

  @override
  String get serverFormPassphraseLabel => 'Frase secreta da chave (opcional)';

  @override
  String get serverFormNotesLabel => 'Notas (opcional)';

  @override
  String get searchServers => 'Pesquisar servidores...';

  @override
  String get filterAllFolders => 'Todas as pastas';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterActive => 'Ativos';

  @override
  String get filterInactive => 'Inativos';

  @override
  String get filterClear => 'Limpar';

  @override
  String get folderListTitle => 'Pastas';

  @override
  String get folderListEmpty => 'Nenhuma pasta ainda';

  @override
  String get folderListEmptySubtitle =>
      'Crie pastas para organizar seus servidores.';

  @override
  String get folderAddButton => 'Adicionar pasta';

  @override
  String get folderDeleteTitle => 'Excluir pasta';

  @override
  String folderDeleteMessage(String name) {
    return 'Excluir \"$name\"? Os servidores ficarão desorganizados.';
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
  String get folderCollapse => 'Recolher';

  @override
  String get folderShowHosts => 'Mostrar hosts';

  @override
  String get folderConnectAll => 'Conectar todos';

  @override
  String get folderFormTitleEdit => 'Editar pasta';

  @override
  String get folderFormTitleNew => 'Nova pasta';

  @override
  String get folderFormNameLabel => 'Nome da pasta';

  @override
  String get folderFormParentLabel => 'Pasta pai';

  @override
  String get folderFormParentNone => 'Nenhuma (Raiz)';

  @override
  String get tagListTitle => 'Tags';

  @override
  String get tagListEmpty => 'Nenhuma tag ainda';

  @override
  String get tagListEmptySubtitle =>
      'Crie tags para rotular e filtrar seus servidores.';

  @override
  String get tagAddButton => 'Adicionar tag';

  @override
  String get tagDeleteTitle => 'Excluir tag';

  @override
  String tagDeleteMessage(String name) {
    return 'Excluir \"$name\"? Será removida de todos os servidores.';
  }

  @override
  String get tagFormTitleEdit => 'Editar tag';

  @override
  String get tagFormTitleNew => 'Nova tag';

  @override
  String get tagFormNameLabel => 'Nome da tag';

  @override
  String get sshKeyListTitle => 'Chaves SSH';

  @override
  String get sshKeyListEmpty => 'Nenhuma chave SSH ainda';

  @override
  String get sshKeyListEmptySubtitle =>
      'Gere ou importe chaves SSH para gerenciá-las centralmente';

  @override
  String get sshKeyCannotDeleteTitle => 'Não é possível excluir';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Não é possível excluir \"$name\". Usada por $count servidor(es). Desvincule de todos os servidores primeiro.';
  }

  @override
  String get sshKeyDeleteTitle => 'Excluir chave SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get sshKeyAddButton => 'Adicionar chave SSH';

  @override
  String get sshKeyFormTitleEdit => 'Editar chave SSH';

  @override
  String get sshKeyFormTitleAdd => 'Adicionar chave SSH';

  @override
  String get sshKeyFormTabGenerate => 'Gerar';

  @override
  String get sshKeyFormTabImport => 'Importar';

  @override
  String get sshKeyFormNameLabel => 'Nome da chave';

  @override
  String get sshKeyFormNameHint => 'ex. Minha chave de produção';

  @override
  String get sshKeyFormKeyType => 'Tipo de chave';

  @override
  String get sshKeyFormKeySize => 'Tamanho da chave';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Comentário';

  @override
  String get sshKeyFormCommentHint => 'usuário@host ou descrição';

  @override
  String get sshKeyFormCommentOptional => 'Comentário (opcional)';

  @override
  String get sshKeyFormImportFromFile => 'Importar de arquivo';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Chave privada';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Cole a chave privada SSH ou use o botão acima...';

  @override
  String get sshKeyFormPassphraseLabel => 'Frase secreta (opcional)';

  @override
  String get sshKeyFormNameRequired => 'O nome é obrigatório';

  @override
  String get sshKeyFormPrivateKeyRequired => 'A chave privada é obrigatória';

  @override
  String get sshKeyFormFileReadError =>
      'Não foi possível ler o arquivo selecionado';

  @override
  String get sshKeyFormInvalidFormat =>
      'Formato de chave inválido — formato PEM esperado (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Falha ao ler o arquivo: $message';
  }

  @override
  String get sshKeyFormSaving => 'Salvando...';

  @override
  String get sshKeySelectorLabel => 'Chave SSH';

  @override
  String get sshKeySelectorNone => 'Nenhuma chave gerenciada';

  @override
  String get sshKeySelectorManage => 'Gerenciar chaves...';

  @override
  String get sshKeySelectorError => 'Falha ao carregar chaves SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Copiar chave pública';

  @override
  String get sshKeyTilePublicKeyCopied => 'Chave pública copiada';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Usada por $count servidor(es)';
  }

  @override
  String get sshKeyTileUnlinkFirst =>
      'Desvincule de todos os servidores primeiro';

  @override
  String get exportImportTitle => 'Exportar / Importar';

  @override
  String get exportSectionTitle => 'Exportar';

  @override
  String get exportJsonButton => 'Exportar como JSON (sem credenciais)';

  @override
  String get exportZipButton => 'Exportar ZIP criptografado (com credenciais)';

  @override
  String get importSectionTitle => 'Importar';

  @override
  String get importButton => 'Importar de arquivo';

  @override
  String get importSupportedFormats =>
      'Suporta arquivos JSON (simples) e ZIP (criptografados).';

  @override
  String exportedTo(String path) {
    return 'Exportado para: $path';
  }

  @override
  String get share => 'Compartilhar';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers servidores, $groups grupos, $tags tags importados. $skipped ignorados.';
  }

  @override
  String get importPasswordTitle => 'Digite a senha';

  @override
  String get importPasswordLabel => 'Senha de exportação';

  @override
  String get importPasswordDecrypt => 'Descriptografar';

  @override
  String get exportPasswordTitle => 'Definir senha de exportação';

  @override
  String get exportPasswordDescription =>
      'Esta senha será usada para criptografar seu arquivo de exportação, incluindo credenciais.';

  @override
  String get exportPasswordLabel => 'Senha';

  @override
  String get exportPasswordConfirmLabel => 'Confirmar senha';

  @override
  String get exportPasswordMismatch => 'As senhas não coincidem';

  @override
  String get exportPasswordButton => 'Criptografar e exportar';

  @override
  String get importConflictTitle => 'Gerenciar conflitos';

  @override
  String get importConflictDescription =>
      'Como as entradas existentes devem ser tratadas durante a importação?';

  @override
  String get importConflictSkip => 'Ignorar existentes';

  @override
  String get importConflictRename => 'Renomear novos';

  @override
  String get importConflictOverwrite => 'Sobrescrever';

  @override
  String get confirmDeleteLabel => 'Excluir';

  @override
  String get keyGenTitle => 'Gerar par de chaves SSH';

  @override
  String get keyGenKeyType => 'Tipo de chave';

  @override
  String get keyGenKeySize => 'Tamanho da chave';

  @override
  String get keyGenComment => 'Comentário';

  @override
  String get keyGenCommentHint => 'usuário@host ou descrição';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Gerando...';

  @override
  String get keyGenGenerate => 'Gerar';

  @override
  String keyGenResultTitle(String type) {
    return 'Chave $type gerada';
  }

  @override
  String get keyGenPublicKey => 'Chave pública';

  @override
  String get keyGenPrivateKey => 'Chave privada';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Comentário: $comment';
  }

  @override
  String get keyGenAnother => 'Gerar outra';

  @override
  String get keyGenUseThisKey => 'Usar esta chave';

  @override
  String get keyGenCopyTooltip => 'Copiar para a área de transferência';

  @override
  String keyGenCopied(String label) {
    return '$label copiado';
  }

  @override
  String get colorPickerLabel => 'Cor';

  @override
  String get iconPickerLabel => 'Ícone';

  @override
  String get tagSelectorLabel => 'Tags';

  @override
  String get tagSelectorEmpty => 'Nenhuma tag ainda';

  @override
  String get tagSelectorError => 'Falha ao carregar tags';

  @override
  String get snippetListTitle => 'Snippets';

  @override
  String get snippetSearchHint => 'Pesquisar snippets...';

  @override
  String get snippetListEmpty => 'Nenhum snippet ainda';

  @override
  String get snippetListEmptySubtitle =>
      'Crie snippets de código e comandos reutilizáveis.';

  @override
  String get snippetAddButton => 'Adicionar snippet';

  @override
  String get snippetDeleteTitle => 'Excluir snippet';

  @override
  String snippetDeleteMessage(String name) {
    return 'Excluir \"$name\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get snippetFormTitleEdit => 'Editar snippet';

  @override
  String get snippetFormTitleNew => 'Novo snippet';

  @override
  String get snippetFormNameLabel => 'Nome';

  @override
  String get snippetFormNameHint => 'ex. Limpeza Docker';

  @override
  String get snippetFormLanguageLabel => 'Linguagem';

  @override
  String get snippetFormContentLabel => 'Conteúdo';

  @override
  String get snippetFormContentHint => 'Digite o código do snippet...';

  @override
  String get snippetFormDescriptionLabel => 'Descrição';

  @override
  String get snippetFormDescriptionHint => 'Descrição opcional...';

  @override
  String get snippetFormFolderLabel => 'Pasta';

  @override
  String get snippetFormNoFolder => 'Sem pasta';

  @override
  String get snippetFormNameRequired => 'O nome é obrigatório';

  @override
  String get snippetFormContentRequired => 'O conteúdo é obrigatório';

  @override
  String get snippetFormUpdateButton => 'Atualizar snippet';

  @override
  String get snippetFormCreateButton => 'Criar snippet';

  @override
  String get snippetDetailTitle => 'Detalhes do snippet';

  @override
  String get snippetDetailDeleteTitle => 'Excluir snippet';

  @override
  String get snippetDetailDeleteMessage => 'Esta ação não pode ser desfeita.';

  @override
  String get snippetDetailContent => 'Conteúdo';

  @override
  String get snippetDetailFillVariables => 'Preencher variáveis';

  @override
  String get snippetDetailDescription => 'Descrição';

  @override
  String get snippetDetailVariables => 'Variáveis';

  @override
  String get snippetDetailTags => 'Tags';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Criado';

  @override
  String get snippetDetailUpdated => 'Atualizado';

  @override
  String get variableEditorTitle => 'Variáveis de modelo';

  @override
  String get variableEditorAdd => 'Adicionar';

  @override
  String get variableEditorEmpty =>
      'Sem variáveis. Use a sintaxe de chaves no conteúdo para referenciá-las.';

  @override
  String get variableEditorNameLabel => 'Nome';

  @override
  String get variableEditorNameHint => 'ex. hostname';

  @override
  String get variableEditorDefaultLabel => 'Padrão';

  @override
  String get variableEditorDefaultHint => 'opcional';

  @override
  String get variableFillTitle => 'Preencher variáveis';

  @override
  String variableFillHint(String name) {
    return 'Digite o valor para $name';
  }

  @override
  String get variableFillPreview => 'Pré-visualização';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Nenhuma sessão ativa';

  @override
  String get terminalEmptySubtitle =>
      'Conecte-se a um host para abrir uma sessão de terminal.';

  @override
  String get terminalGoToHosts => 'Ir para hosts';

  @override
  String get terminalCloseAll => 'Fechar todas as sessões';

  @override
  String get terminalCloseTitle => 'Fechar sessão';

  @override
  String terminalCloseMessage(String title) {
    return 'Fechar a conexão ativa com \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Autenticando...';

  @override
  String connectionConnecting(String name) {
    return 'Conectando a $name...';
  }

  @override
  String get connectionError => 'Erro de conexão';

  @override
  String get connectionLost => 'Conexão perdida';

  @override
  String get connectionReconnect => 'Reconectar';

  @override
  String get snippetQuickPanelTitle => 'Inserir snippet';

  @override
  String get snippetQuickPanelSearch => 'Pesquisar snippets...';

  @override
  String get snippetQuickPanelEmpty => 'Nenhum snippet disponível';

  @override
  String get snippetQuickPanelNoMatch => 'Nenhum snippet correspondente';

  @override
  String get snippetQuickPanelInsertTooltip => 'Inserir snippet';

  @override
  String get terminalThemePickerTitle => 'Tema do terminal';

  @override
  String get validatorHostnameRequired => 'O nome do host é obrigatório';

  @override
  String get validatorHostnameInvalid => 'Nome do host ou endereço IP inválido';

  @override
  String get validatorPortRequired => 'A porta é obrigatória';

  @override
  String get validatorPortRange => 'A porta deve estar entre 1 e 65535';

  @override
  String get validatorUsernameRequired => 'O nome de usuário é obrigatório';

  @override
  String get validatorUsernameInvalid => 'Formato de nome de usuário inválido';

  @override
  String get validatorServerNameRequired => 'O nome do servidor é obrigatório';

  @override
  String get validatorServerNameLength =>
      'O nome do servidor deve ter no máximo 100 caracteres';

  @override
  String get validatorSshKeyInvalid => 'Formato de chave SSH inválido';

  @override
  String get validatorPasswordRequired => 'A senha é obrigatória';

  @override
  String get validatorPasswordLength =>
      'A senha deve ter pelo menos 8 caracteres';

  @override
  String get authMethodPassword => 'Senha';

  @override
  String get authMethodKey => 'Chave SSH';

  @override
  String get authMethodBoth => 'Senha + Chave';

  @override
  String get serverCopySuffix => '(Cópia)';

  @override
  String get settingsDownloadLogs => 'Baixar logs';

  @override
  String get settingsSendLogs => 'Enviar logs ao suporte';

  @override
  String get settingsLogsSaved => 'Logs salvos com sucesso';

  @override
  String get settingsLogsEmpty => 'Nenhuma entrada de log disponível';

  @override
  String get authLogin => 'Entrar';

  @override
  String get authRegister => 'Cadastrar';

  @override
  String get authForgotPassword => 'Esqueceu a senha?';

  @override
  String get authWhyLogin =>
      'Faça login para ativar a sincronização na nuvem criptografada em todos os seus dispositivos. O aplicativo funciona totalmente offline sem uma conta.';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailRequired => 'O e-mail é obrigatório';

  @override
  String get authEmailInvalid => 'Endereço de e-mail inválido';

  @override
  String get authPasswordLabel => 'Senha';

  @override
  String get authConfirmPasswordLabel => 'Confirmar senha';

  @override
  String get authPasswordMismatch => 'As senhas não coincidem';

  @override
  String get authNoAccount => 'Não tem conta?';

  @override
  String get authHasAccount => 'Já tem uma conta?';

  @override
  String get authSelfHosted => 'Servidor auto-hospedado';

  @override
  String get authResetEmailSent =>
      'Se uma conta existir, um link de redefinição foi enviado para seu e-mail.';

  @override
  String get authResetDescription =>
      'Digite seu endereço de e-mail e enviaremos um link para redefinir sua senha.';

  @override
  String get authSendResetLink => 'Enviar link de redefinição';

  @override
  String get authBackToLogin => 'Voltar ao login';

  @override
  String get syncPasswordTitle => 'Senha de sincronização';

  @override
  String get syncPasswordTitleCreate => 'Definir senha de sincronização';

  @override
  String get syncPasswordTitleEnter => 'Digitar senha de sincronização';

  @override
  String get syncPasswordDescription =>
      'Defina uma senha separada para criptografar os dados do seu cofre. Esta senha nunca sai do seu dispositivo — o servidor armazena apenas dados criptografados.';

  @override
  String get syncPasswordHintEnter =>
      'Digite a senha que você definiu ao criar sua conta.';

  @override
  String get syncPasswordWarning =>
      'Se você esquecer esta senha, seus dados sincronizados não poderão ser recuperados. Não há opção de redefinição.';

  @override
  String get syncPasswordLabel => 'Senha de sincronização';

  @override
  String get syncPasswordWrong => 'Senha incorreta. Tente novamente.';

  @override
  String get firstSyncTitle => 'Dados existentes encontrados';

  @override
  String get firstSyncMessage =>
      'Este dispositivo tem dados existentes e o servidor possui um cofre. Como devemos proceder?';

  @override
  String get firstSyncMerge => 'Mesclar (servidor prevalece)';

  @override
  String get firstSyncOverwriteLocal => 'Sobrescrever dados locais';

  @override
  String get firstSyncKeepLocal => 'Manter local e enviar';

  @override
  String get firstSyncDeleteLocal => 'Excluir local e baixar';

  @override
  String get changeEncryptionPassword => 'Alterar senha de criptografia';

  @override
  String get changeEncryptionWarning =>
      'Você será desconectado de todos os outros dispositivos.';

  @override
  String get changeEncryptionOldPassword => 'Senha atual';

  @override
  String get changeEncryptionNewPassword => 'Nova senha';

  @override
  String get changeEncryptionSuccess => 'Senha alterada com sucesso.';

  @override
  String get logoutAllDevices => 'Sair de todos os dispositivos';

  @override
  String get logoutAllDevicesConfirm =>
      'Isso revogará todas as sessões ativas. Você precisará fazer login novamente em todos os dispositivos.';

  @override
  String get logoutAllDevicesSuccess => 'Todos os dispositivos desconectados.';

  @override
  String get syncSettingsTitle => 'Configurações de sincronização';

  @override
  String get syncAutoSync => 'Sincronização automática';

  @override
  String get syncAutoSyncDescription =>
      'Sincronizar automaticamente ao iniciar o aplicativo';

  @override
  String get syncNow => 'Sincronizar agora';

  @override
  String get syncSyncing => 'Sincronizando...';

  @override
  String get syncSuccess => 'Sincronização concluída';

  @override
  String get syncError => 'Erro de sincronização';

  @override
  String get syncServerUnreachable => 'Servidor inacessível';

  @override
  String get syncServerUnreachableHint =>
      'Não foi possível acessar o servidor de sincronização. Verifique sua conexão com a internet e a URL do servidor.';

  @override
  String get syncNetworkError =>
      'Falha na conexão com o servidor. Verifique sua conexão com a internet ou tente novamente mais tarde.';

  @override
  String get syncNeverSynced => 'Nunca sincronizado';

  @override
  String get syncVaultVersion => 'Versão do cofre';

  @override
  String get syncTitle => 'Sincronização';

  @override
  String get settingsSectionNetwork => 'Rede e DNS';

  @override
  String get settingsDnsServers => 'Servidores DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Padrão (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Insira URLs de servidores DoH personalizados, separadas por vírgulas. São necessários pelo menos 2 servidores para verificação cruzada.';

  @override
  String get settingsDnsLabel => 'URLs dos servidores DoH';

  @override
  String get settingsDnsReset => 'Redefinir para padrão';

  @override
  String get settingsSectionSync => 'Sincronização';

  @override
  String get settingsSyncAccount => 'Conta';

  @override
  String get settingsSyncNotLoggedIn => 'Não conectado';

  @override
  String get settingsSyncStatus => 'Sincronização';

  @override
  String get settingsSyncServerUrl => 'URL do servidor';

  @override
  String get settingsSyncDefaultServer => 'Padrão (sshvault.app)';

  @override
  String get accountTitle => 'Conta';

  @override
  String get accountNotLoggedIn => 'Não conectado';

  @override
  String get accountVerified => 'Verificado';

  @override
  String get accountMemberSince => 'Membro desde';

  @override
  String get accountDevices => 'Dispositivos';

  @override
  String get accountNoDevices => 'Nenhum dispositivo registrado';

  @override
  String get accountLastSync => 'Última sincronização';

  @override
  String get accountChangePassword => 'Alterar senha';

  @override
  String get accountOldPassword => 'Senha atual';

  @override
  String get accountNewPassword => 'Nova senha';

  @override
  String get accountDeleteAccount => 'Excluir conta';

  @override
  String get accountDeleteWarning =>
      'Isso excluirá permanentemente sua conta e todos os dados sincronizados. Esta ação não pode ser desfeita.';

  @override
  String get accountLogout => 'Sair';

  @override
  String get serverConfigTitle => 'Configuração do servidor';

  @override
  String get serverConfigSelfHosted => 'Auto-hospedado';

  @override
  String get serverConfigSelfHostedDescription =>
      'Use seu próprio servidor SSHVault';

  @override
  String get serverConfigUrlLabel => 'URL do servidor';

  @override
  String get serverConfigTest => 'Testar conexão';

  @override
  String get auditLogTitle => 'Registro de atividades';

  @override
  String get auditLogAll => 'Todos';

  @override
  String get auditLogEmpty => 'Nenhum registro de atividade encontrado';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Gerenciador de arquivos';

  @override
  String get sftpLocalDevice => 'Dispositivo local';

  @override
  String get sftpSelectServer => 'Selecionar servidor...';

  @override
  String get sftpConnecting => 'Conectando...';

  @override
  String get sftpEmptyDirectory => 'Este diretório está vazio';

  @override
  String get sftpNoConnection => 'Nenhum servidor conectado';

  @override
  String get sftpPathLabel => 'Caminho';

  @override
  String get sftpUpload => 'Enviar';

  @override
  String get sftpDownload => 'Baixar';

  @override
  String get sftpDelete => 'Excluir';

  @override
  String get sftpRename => 'Renomear';

  @override
  String get sftpNewFolder => 'Nova pasta';

  @override
  String get sftpNewFolderName => 'Nome da pasta';

  @override
  String get sftpChmod => 'Permissões';

  @override
  String get sftpChmodTitle => 'Alterar permissões';

  @override
  String get sftpChmodOctal => 'Octal';

  @override
  String get sftpChmodOwner => 'Proprietário';

  @override
  String get sftpChmodGroup => 'Grupo';

  @override
  String get sftpChmodOther => 'Outros';

  @override
  String get sftpChmodRead => 'Leitura';

  @override
  String get sftpChmodWrite => 'Escrita';

  @override
  String get sftpChmodExecute => 'Execução';

  @override
  String get sftpCreateSymlink => 'Criar link simbólico';

  @override
  String get sftpSymlinkTarget => 'Caminho de destino';

  @override
  String get sftpSymlinkName => 'Nome do link';

  @override
  String get sftpFilePreview => 'Pré-visualização do arquivo';

  @override
  String get sftpFileInfo => 'Informações do arquivo';

  @override
  String get sftpFileSize => 'Tamanho';

  @override
  String get sftpFileModified => 'Modificado';

  @override
  String get sftpFilePermissions => 'Permissões';

  @override
  String get sftpFileOwner => 'Proprietário';

  @override
  String get sftpFileType => 'Tipo';

  @override
  String get sftpFileLinkTarget => 'Destino do link';

  @override
  String get sftpTransfers => 'Transferências';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current de $total';
  }

  @override
  String get sftpTransferQueued => 'Na fila';

  @override
  String get sftpTransferActive => 'Transferindo...';

  @override
  String get sftpTransferPaused => 'Pausado';

  @override
  String get sftpTransferCompleted => 'Concluído';

  @override
  String get sftpTransferFailed => 'Falhou';

  @override
  String get sftpTransferCancelled => 'Cancelado';

  @override
  String get sftpPauseTransfer => 'Pausar';

  @override
  String get sftpResumeTransfer => 'Retomar';

  @override
  String get sftpCancelTransfer => 'Cancelar';

  @override
  String get sftpClearCompleted => 'Limpar concluídos';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active de $total transferências';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ativos',
      one: '1 ativo',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count concluídos',
      one: '1 concluído',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count falharam',
      one: '1 falhou',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Copiar para o outro painel';

  @override
  String sftpConfirmDelete(int count) {
    return 'Excluir $count itens?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Excluir \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Excluído com sucesso';

  @override
  String get sftpRenameTitle => 'Renomear';

  @override
  String get sftpRenameLabel => 'Novo nome';

  @override
  String get sftpSortByName => 'Nome';

  @override
  String get sftpSortBySize => 'Tamanho';

  @override
  String get sftpSortByDate => 'Data';

  @override
  String get sftpSortByType => 'Tipo';

  @override
  String get sftpShowHidden => 'Mostrar arquivos ocultos';

  @override
  String get sftpHideHidden => 'Ocultar arquivos ocultos';

  @override
  String get sftpSelectAll => 'Selecionar tudo';

  @override
  String get sftpDeselectAll => 'Desmarcar tudo';

  @override
  String sftpItemsSelected(int count) {
    return '$count selecionado(s)';
  }

  @override
  String get sftpRefresh => 'Atualizar';

  @override
  String sftpConnectionError(String message) {
    return 'Falha na conexão: $message';
  }

  @override
  String get sftpPermissionDenied => 'Permissão negada';

  @override
  String sftpOperationFailed(String message) {
    return 'Operação falhou: $message';
  }

  @override
  String get sftpOverwriteTitle => 'O arquivo já existe';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" já existe. Sobrescrever?';
  }

  @override
  String get sftpOverwrite => 'Sobrescrever';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Transferência iniciada: $fileName';
  }

  @override
  String get sftpNoPaneSelected =>
      'Selecione um destino no outro painel primeiro';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Transferência de diretório disponível em breve';

  @override
  String get sftpSelect => 'Selecionar';

  @override
  String get sftpOpen => 'Abrir';

  @override
  String get sftpExtractArchive => 'Extrair aqui';

  @override
  String get sftpExtractSuccess => 'Arquivo extraído';

  @override
  String sftpExtractFailed(String message) {
    return 'Falha na extração: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Formato de arquivo não suportado';

  @override
  String get sftpExtracting => 'Extraindo...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count envios iniciados',
      one: 'Envio iniciado',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count downloads iniciados',
      one: 'Download iniciado',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" baixado';
  }

  @override
  String get sftpSavedToDownloads => 'Salvo em Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Salvar em Arquivos';

  @override
  String get sftpFileSaved => 'Arquivo salvo';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessões SSH ativas',
      one: 'Sessão SSH ativa',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Toque para abrir o terminal';

  @override
  String get settingsAccountAndSync => 'Conta e sincronização';

  @override
  String get settingsAccountSubtitleAuth => 'Conectado';

  @override
  String get settingsAccountSubtitleUnauth => 'Não conectado';

  @override
  String get settingsSecuritySubtitle => 'Bloqueio auto, Biometria, PIN';

  @override
  String get settingsSshSubtitle => 'Porta 22, Usuário root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, Idioma, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Padrões de exportação criptografada';

  @override
  String get settingsAboutSubtitle => 'Versão, Licenças';

  @override
  String get settingsSearchHint => 'Pesquisar configurações...';

  @override
  String get settingsSearchNoResults => 'Nenhuma configuração encontrada';

  @override
  String get aboutDeveloper => 'Desenvolvido por Kiefer Networks';

  @override
  String get aboutDonate => 'Doar';

  @override
  String get aboutOpenSourceLicenses => 'Licenças Open Source';

  @override
  String get aboutWebsite => 'Site';

  @override
  String get aboutVersion => 'Versão';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS criptografa consultas DNS e impede falsificação de DNS. O SSHVault verifica nomes de host com vários provedores para detectar ataques.';

  @override
  String get settingsDnsAddServer => 'Adicionar servidor DNS';

  @override
  String get settingsDnsServerUrl => 'URL do servidor';

  @override
  String get settingsDnsDefaultBadge => 'Padrão';

  @override
  String get settingsDnsResetDefaults => 'Redefinir para padrões';

  @override
  String get settingsDnsInvalidUrl => 'Insira uma URL HTTPS válida';

  @override
  String get settingsDefaultAuthMethod => 'Método de autenticação';

  @override
  String get settingsAuthPassword => 'Senha';

  @override
  String get settingsAuthKey => 'Chave SSH';

  @override
  String get settingsConnectionTimeout => 'Tempo limite de conexão';

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
  String get settingsCompression => 'Compressão';

  @override
  String get settingsCompressionDescription =>
      'Ativar compressão zlib para conexões SSH';

  @override
  String get settingsTerminalType => 'Tipo de terminal';

  @override
  String get settingsSectionConnection => 'Conexão';

  @override
  String get settingsClipboardAutoClear =>
      'Limpeza automática da área de transferência';

  @override
  String get settingsClipboardAutoClearOff => 'Desligado';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Tempo limite da sessão';

  @override
  String get settingsSessionTimeoutOff => 'Desligado';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get settingsDuressPin => 'PIN de coação';

  @override
  String get settingsDuressPinDescription =>
      'Um PIN separado que apaga todos os dados quando digitado';

  @override
  String get settingsDuressPinSet => 'PIN de coação definido';

  @override
  String get settingsDuressPinNotSet => 'Não configurado';

  @override
  String get settingsDuressPinWarning =>
      'Digitar este PIN excluirá permanentemente todos os dados locais, incluindo credenciais, chaves e configurações. Esta ação não pode ser desfeita.';

  @override
  String get settingsKeyRotationReminder => 'Lembrete de rotação de chaves';

  @override
  String get settingsKeyRotationOff => 'Desligado';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days dias';
  }

  @override
  String get settingsFailedAttempts => 'Tentativas PIN falhadas';

  @override
  String get settingsSectionAppLock => 'Bloqueio do aplicativo';

  @override
  String get settingsSectionPrivacy => 'Privacidade';

  @override
  String get settingsSectionReminders => 'Lembretes';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle => 'Exportar, Importar e Backup';

  @override
  String get settingsExportJson => 'Exportar como JSON';

  @override
  String get settingsExportEncrypted => 'Exportar criptografado';

  @override
  String get settingsImportFile => 'Importar de arquivo';

  @override
  String get settingsSectionImport => 'Importar';

  @override
  String get filterTitle => 'Filtrar servidores';

  @override
  String get filterApply => 'Aplicar filtros';

  @override
  String get filterClearAll => 'Limpar tudo';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtros ativos',
      one: '1 filtro ativo',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Pasta';

  @override
  String get filterTags => 'Tags';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Pré-visualização resolvida';

  @override
  String get variableInsert => 'Inserir';

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
      other: '$count sessões revogadas.',
      one: '1 sessão revogada.',
    );
    return '$_temp0 Você foi desconectado.';
  }

  @override
  String get keyGenPassphrase => 'Frase secreta';

  @override
  String get keyGenPassphraseHint => 'Opcional — protege a chave privada';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Padrão (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Uma chave com a mesma impressão digital já existe: \"$name\". Cada chave SSH deve ser única.';
  }

  @override
  String get sshKeyFingerprint => 'Impressão digital';

  @override
  String get sshKeyPublicKey => 'Chave pública';

  @override
  String get jumpHost => 'Host de salto';

  @override
  String get jumpHostNone => 'Nenhum';

  @override
  String get jumpHostLabel => 'Conectar via host de salto';

  @override
  String get jumpHostSelfError =>
      'Um servidor não pode ser seu próprio host de salto';

  @override
  String get jumpHostConnecting => 'Conectando ao host de salto…';

  @override
  String get jumpHostCircularError =>
      'Cadeia circular de hosts de salto detectada';

  @override
  String get logoutDialogTitle => 'Sair';

  @override
  String get logoutDialogMessage =>
      'Deseja excluir todos os dados locais? Servidores, chaves SSH, snippets e configurações serão removidos deste dispositivo.';

  @override
  String get logoutOnly => 'Apenas sair';

  @override
  String get logoutAndDelete => 'Sair e excluir dados';

  @override
  String get changeAvatar => 'Alterar avatar';

  @override
  String get removeAvatar => 'Remover avatar';

  @override
  String get avatarUploadFailed => 'Falha ao enviar o avatar';

  @override
  String get avatarTooLarge => 'A imagem é muito grande';

  @override
  String get deviceLastSeen => 'Visto por último';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'A URL do servidor não pode ser alterada enquanto estiver conectado. Saia primeiro.';

  @override
  String get serverListNoFolder => 'Sem categoria';

  @override
  String get autoSyncInterval => 'Intervalo de sincronização';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get proxySettings => 'Configurações de proxy';

  @override
  String get proxyType => 'Tipo de proxy';

  @override
  String get proxyNone => 'Sem proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Host do proxy';

  @override
  String get proxyPort => 'Porta do proxy';

  @override
  String get proxyUsername => 'Usuário do proxy';

  @override
  String get proxyPassword => 'Senha do proxy';

  @override
  String get proxyUseGlobal => 'Usar proxy global';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Específico do servidor';

  @override
  String get proxyTestConnection => 'Testar conexão';

  @override
  String get proxyTestSuccess => 'Proxy acessível';

  @override
  String get proxyTestFailed => 'Proxy inacessível';

  @override
  String get proxyDefaultProxy => 'Proxy padrão';

  @override
  String get vpnRequired => 'VPN obrigatória';

  @override
  String get vpnRequiredTooltip => 'Mostrar aviso ao conectar sem VPN ativa';

  @override
  String get vpnActive => 'VPN ativa';

  @override
  String get vpnInactive => 'VPN inativa';

  @override
  String get vpnWarningTitle => 'VPN não ativa';

  @override
  String get vpnWarningMessage =>
      'Este servidor requer uma conexão VPN, mas nenhuma VPN está ativa no momento. Deseja conectar mesmo assim?';

  @override
  String get vpnConnectAnyway => 'Conectar mesmo assim';

  @override
  String get postConnectCommands => 'Comandos pós-conexão';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Comandos executados automaticamente após a conexão (um por linha)';

  @override
  String get dashboardFavorites => 'Favoritos';

  @override
  String get dashboardRecent => 'Recentes';

  @override
  String get dashboardActiveSessions => 'Sessões ativas';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get noRecentConnections => 'Nenhuma conexão recente';

  @override
  String get terminalSplit => 'Dividir tela';

  @override
  String get terminalUnsplit => 'Fechar divisão';

  @override
  String get terminalSelectSession =>
      'Selecione uma sessão para a tela dividida';

  @override
  String get knownHostsTitle => 'Hosts conhecidos';

  @override
  String get knownHostsSubtitle =>
      'Gerenciar impressões digitais de servidores confiáveis';

  @override
  String get hostKeyNewTitle => 'Novo host';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Primeira conexão a $hostname:$port. Verifique a impressão digital antes de conectar.';
  }

  @override
  String get hostKeyChangedTitle => 'Chave do host alterada!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'A chave do host para $hostname:$port foi alterada. Isso pode indicar uma ameaça de segurança.';
  }

  @override
  String get hostKeyFingerprint => 'Impressão digital';

  @override
  String get hostKeyType => 'Tipo de chave';

  @override
  String get hostKeyTrustConnect => 'Confiar e conectar';

  @override
  String get hostKeyAcceptNew => 'Aceitar nova chave';

  @override
  String get hostKeyReject => 'Rejeitar';

  @override
  String get hostKeyPreviousFingerprint => 'Impressão digital anterior';

  @override
  String get hostKeyDeleteAll => 'Excluir todos os hosts conhecidos';

  @override
  String get hostKeyDeleteConfirm =>
      'Tem certeza de que deseja remover todos os hosts conhecidos? Você será solicitado novamente na próxima conexão.';

  @override
  String get hostKeyEmpty => 'Nenhum host conhecido ainda';

  @override
  String get hostKeyEmptySubtitle =>
      'As impressões digitais dos hosts serão armazenadas aqui após sua primeira conexão';

  @override
  String get hostKeyFirstSeen => 'Visto pela primeira vez';

  @override
  String get hostKeyLastSeen => 'Visto pela última vez';

  @override
  String get sshConfigImportTitle => 'Importar configuração SSH';

  @override
  String get sshConfigImportPickFile =>
      'Selecionar arquivo de configuração SSH';

  @override
  String get sshConfigImportOrPaste => 'Ou cole o conteúdo da configuração';

  @override
  String sshConfigImportParsed(int count) {
    return '$count host(s) encontrado(s)';
  }

  @override
  String get sshConfigImportButton => 'Importar selecionados';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count servidor(es) importado(s)';
  }

  @override
  String get sshConfigImportDuplicate => 'Já existe';

  @override
  String get sshConfigImportNoHosts => 'Nenhum host encontrado na configuração';

  @override
  String get sftpBookmarkAdd => 'Adicionar favorito';

  @override
  String get sftpBookmarkLabel => 'Rótulo';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get reportAndDisconnect => 'Reportar e desconectar';

  @override
  String get continueAnyway => 'Continuar mesmo assim';

  @override
  String get insertSnippet => 'Inserir snippet';

  @override
  String get seconds => 'Segundos';

  @override
  String get heartbeatLostMessage =>
      'Não foi possível acessar o servidor após várias tentativas. Para sua segurança, a sessão foi encerrada.';

  @override
  String get attestationFailedTitle => 'Falha na verificação do servidor';

  @override
  String get attestationFailedMessage =>
      'O servidor não pôde ser verificado como um backend SSHVault legítimo. Isso pode indicar um ataque man-in-the-middle ou um servidor mal configurado.';

  @override
  String get attestationKeyChangedTitle =>
      'Chave de atestação do servidor alterada';

  @override
  String get attestationKeyChangedMessage =>
      'A chave de atestação do servidor mudou desde a conexão inicial. Isso pode indicar um ataque man-in-the-middle. NÃO continue a menos que o administrador do servidor tenha confirmado uma rotação de chave.';

  @override
  String get sectionLinks => 'Links';

  @override
  String get sectionDeveloper => 'Desenvolvedor';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Página não encontrada';

  @override
  String get connectionTestSuccess => 'Conexão bem-sucedida';

  @override
  String connectionTestFailed(String message) {
    return 'Falha na conexão: $message';
  }

  @override
  String get serverVerificationFailed => 'Falha na verificação do servidor';

  @override
  String get importSuccessful => 'Importação bem-sucedida';

  @override
  String get hintExampleServerUrl => 'https://seu-servidor.example.com';

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
  String get deviceDeleteConfirmTitle => 'Remover dispositivo';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Tem certeza de que deseja remover \"$name\"? O dispositivo será desconectado imediatamente.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Este é o seu dispositivo atual. Você será desconectado imediatamente.';

  @override
  String get deviceDeleteSuccess => 'Dispositivo removido';

  @override
  String get deviceDeletedCurrentLogout =>
      'Dispositivo atual removido. Você foi desconectado.';

  @override
  String get thisDevice => 'Este dispositivo';
}
