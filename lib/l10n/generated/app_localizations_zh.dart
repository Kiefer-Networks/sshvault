// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => '主机';

  @override
  String get navSnippets => '代码片段';

  @override
  String get navFolders => '文件夹';

  @override
  String get navTags => '标签';

  @override
  String get navSshKeys => 'SSH 密钥';

  @override
  String get navExportImport => '导出 / 导入';

  @override
  String get navTerminal => '终端';

  @override
  String get navMore => '更多';

  @override
  String get navManagement => '管理';

  @override
  String get navSettings => '设置';

  @override
  String get navAbout => '关于';

  @override
  String get lockScreenTitle => 'SSHVault 已锁定';

  @override
  String get lockScreenUnlock => '解锁';

  @override
  String get lockScreenEnterPin => '输入 PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return '尝试次数过多。请在 $minutes 分钟后重试。';
  }

  @override
  String get pinDialogSetTitle => '设置 PIN 码';

  @override
  String get pinDialogSetSubtitle => '输入 6 位 PIN 码以保护 SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => '确认 PIN';

  @override
  String get pinDialogErrorLength => 'PIN 必须是 6 位数字';

  @override
  String get pinDialogErrorMismatch => 'PIN 不匹配';

  @override
  String get pinDialogVerifyTitle => '输入 PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN 错误。剩余 $attempts 次尝试。';
  }

  @override
  String get securityBannerMessage => '您的 SSH 凭据未受保护。请在设置中设置 PIN 或生物识别锁定。';

  @override
  String get securityBannerDismiss => '关闭';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionAppearance => '外观';

  @override
  String get settingsSectionTerminal => '终端';

  @override
  String get settingsSectionSshDefaults => 'SSH 默认值';

  @override
  String get settingsSectionSecurity => '安全';

  @override
  String get settingsSectionExport => '导出';

  @override
  String get settingsSectionAbout => '关于';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsTerminalTheme => '终端主题';

  @override
  String get settingsTerminalThemeDefault => '默认深色';

  @override
  String get settingsFontSize => '字体大小';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => '默认端口';

  @override
  String get settingsDefaultPortDialog => '默认 SSH 端口';

  @override
  String get settingsPortLabel => '端口';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => '默认用户名';

  @override
  String get settingsDefaultUsernameDialog => '默认用户名';

  @override
  String get settingsUsernameLabel => '用户名';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => '自动锁定超时';

  @override
  String get settingsAutoLockDisabled => '已禁用';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get settingsAutoLockOff => '关闭';

  @override
  String get settingsAutoLock1Min => '1 分钟';

  @override
  String get settingsAutoLock5Min => '5 分钟';

  @override
  String get settingsAutoLock15Min => '15 分钟';

  @override
  String get settingsAutoLock30Min => '30 分钟';

  @override
  String get settingsBiometricUnlock => '生物识别解锁';

  @override
  String get settingsBiometricNotAvailable => '此设备不可用';

  @override
  String get settingsBiometricError => '检查生物识别时出错';

  @override
  String get settingsBiometricReason => '验证身份以启用生物识别解锁';

  @override
  String get settingsBiometricRequiresPin => '请先设置 PIN 才能启用生物识别解锁';

  @override
  String get settingsPinCode => 'PIN 码';

  @override
  String get settingsPinIsSet => 'PIN 已设置';

  @override
  String get settingsPinNotConfigured => '未设置 PIN';

  @override
  String get settingsPinRemove => '移除';

  @override
  String get settingsPinRemoveWarning => '移除 PIN 将解密所有数据库字段并禁用生物识别解锁。是否继续？';

  @override
  String get settingsPinRemoveTitle => '移除 PIN';

  @override
  String get settingsPreventScreenshots => '防止截屏';

  @override
  String get settingsPreventScreenshotsDescription => '阻止截屏和屏幕录制';

  @override
  String get settingsEncryptExport => '默认加密导出';

  @override
  String get settingsAbout => '关于 SSHVault';

  @override
  String get settingsAboutLegalese => '由 Kiefer Networks 提供';

  @override
  String get settingsAboutDescription => '安全的自托管 SSH 客户端';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '系统';

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
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get close => '关闭';

  @override
  String get update => '更新';

  @override
  String get create => '创建';

  @override
  String get retry => '重试';

  @override
  String get copy => '复制';

  @override
  String get edit => '编辑';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return '错误：$message';
  }

  @override
  String get serverListTitle => '主机';

  @override
  String get serverListEmpty => '暂无服务器';

  @override
  String get serverListEmptySubtitle => '添加您的第一台 SSH 服务器以开始使用。';

  @override
  String get serverAddButton => '添加服务器';

  @override
  String get sshConfigImportTitle => '导入 SSH 配置';

  @override
  String sshConfigImportMessage(int count) {
    return '在 ~/.ssh/config 中找到 $count 个主机。是否导入？';
  }

  @override
  String get sshConfigImportButton => '导入';

  @override
  String sshConfigImportSuccess(int count) {
    return '已导入 $count 台服务器';
  }

  @override
  String get sshConfigNotFound => '未找到 SSH 配置文件';

  @override
  String get sshConfigEmpty => 'SSH 配置中未找到主机';

  @override
  String get sshConfigAddManually => '手动添加';

  @override
  String get sshConfigImportAgain => '再次导入 SSH 配置？';

  @override
  String get sshConfigImportKeys => '导入所选主机引用的 SSH 密钥？';

  @override
  String sshConfigKeysImported(int count) {
    return '已导入 $count 个 SSH 密钥';
  }

  @override
  String get serverDuplicated => '服务器已复制';

  @override
  String get serverDeleteTitle => '删除服务器';

  @override
  String serverDeleteMessage(String name) {
    return '确定要删除\"$name\"吗？此操作无法撤销。';
  }

  @override
  String serverDeleteShort(String name) {
    return '删除\"$name\"？';
  }

  @override
  String get serverConnect => '连接';

  @override
  String get serverDetails => '详情';

  @override
  String get serverDuplicate => '复制';

  @override
  String get serverActive => '活跃';

  @override
  String get serverNoFolder => '无文件夹';

  @override
  String get serverFormTitleEdit => '编辑服务器';

  @override
  String get serverFormTitleAdd => '添加服务器';

  @override
  String get serverFormUpdateButton => '更新服务器';

  @override
  String get serverFormAddButton => '添加服务器';

  @override
  String get serverFormPublicKeyExtracted => '公钥提取成功';

  @override
  String serverFormPublicKeyError(String message) {
    return '无法提取公钥：$message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type 密钥对已生成';
  }

  @override
  String get serverDetailTitle => '服务器详情';

  @override
  String get serverDetailDeleteMessage => '此操作无法撤销。';

  @override
  String get serverDetailConnection => '连接';

  @override
  String get serverDetailHost => '主机';

  @override
  String get serverDetailPort => '端口';

  @override
  String get serverDetailUsername => '用户名';

  @override
  String get serverDetailFolder => '文件夹';

  @override
  String get serverDetailTags => '标签';

  @override
  String get serverDetailNotes => '备注';

  @override
  String get serverDetailInfo => '信息';

  @override
  String get serverDetailCreated => '创建时间';

  @override
  String get serverDetailUpdated => '更新时间';

  @override
  String get serverDetailDistro => '系统';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get serverFormNameLabel => '服务器名称';

  @override
  String get serverFormHostnameLabel => '主机名 / IP';

  @override
  String get serverFormPortLabel => '端口';

  @override
  String get serverFormUsernameLabel => '用户名';

  @override
  String get serverFormPasswordLabel => '密码';

  @override
  String get serverFormUseManagedKey => '使用托管密钥';

  @override
  String get serverFormManagedKeySubtitle => '从集中管理的 SSH 密钥中选择';

  @override
  String get serverFormDirectKeySubtitle => '将密钥直接粘贴到此服务器';

  @override
  String get serverFormGenerateKey => '生成 SSH 密钥对';

  @override
  String get serverFormPrivateKeyLabel => '私钥';

  @override
  String get serverFormPrivateKeyHint => '粘贴 SSH 私钥...';

  @override
  String get serverFormExtractPublicKey => '提取公钥';

  @override
  String get serverFormPublicKeyLabel => '公钥';

  @override
  String get serverFormPublicKeyHint => '为空时从私钥自动生成';

  @override
  String get serverFormPassphraseLabel => '密钥口令（可选）';

  @override
  String get serverFormNotesLabel => '备注（可选）';

  @override
  String get searchServers => '搜索服务器...';

  @override
  String get filterAllFolders => '所有文件夹';

  @override
  String get filterAll => '全部';

  @override
  String get filterActive => '活跃';

  @override
  String get filterInactive => '不活跃';

  @override
  String get filterClear => '清除';

  @override
  String get folderListTitle => '文件夹';

  @override
  String get folderListEmpty => '暂无文件夹';

  @override
  String get folderListEmptySubtitle => '创建文件夹来组织您的服务器。';

  @override
  String get folderAddButton => '添加文件夹';

  @override
  String get folderDeleteTitle => '删除文件夹';

  @override
  String folderDeleteMessage(String name) {
    return '删除\"$name\"？服务器将变为未分类。';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 台服务器',
      one: '1 台服务器',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => '折叠';

  @override
  String get folderShowHosts => '显示主机';

  @override
  String get folderConnectAll => '全部连接';

  @override
  String get folderFormTitleEdit => '编辑文件夹';

  @override
  String get folderFormTitleNew => '新建文件夹';

  @override
  String get folderFormNameLabel => '文件夹名称';

  @override
  String get folderFormParentLabel => '上级文件夹';

  @override
  String get folderFormParentNone => '无（根目录）';

  @override
  String get tagListTitle => '标签';

  @override
  String get tagListEmpty => '暂无标签';

  @override
  String get tagListEmptySubtitle => '创建标签来标记和筛选服务器。';

  @override
  String get tagAddButton => '添加标签';

  @override
  String get tagDeleteTitle => '删除标签';

  @override
  String tagDeleteMessage(String name) {
    return '删除\"$name\"？将从所有服务器中移除。';
  }

  @override
  String get tagFormTitleEdit => '编辑标签';

  @override
  String get tagFormTitleNew => '新建标签';

  @override
  String get tagFormNameLabel => '标签名称';

  @override
  String get sshKeyListTitle => 'SSH 密钥';

  @override
  String get sshKeyListEmpty => '暂无 SSH 密钥';

  @override
  String get sshKeyListEmptySubtitle => '生成或导入 SSH 密钥以集中管理';

  @override
  String get sshKeyCannotDeleteTitle => '无法删除';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return '无法删除\"$name\"。$count 台服务器正在使用。请先从所有服务器取消关联。';
  }

  @override
  String get sshKeyDeleteTitle => '删除 SSH 密钥';

  @override
  String sshKeyDeleteMessage(String name) {
    return '删除\"$name\"？此操作无法撤销。';
  }

  @override
  String get sshKeyAddButton => '添加 SSH 密钥';

  @override
  String get sshKeyFormTitleEdit => '编辑 SSH 密钥';

  @override
  String get sshKeyFormTitleAdd => '添加 SSH 密钥';

  @override
  String get sshKeyFormTabGenerate => '生成';

  @override
  String get sshKeyFormTabImport => '导入';

  @override
  String get sshKeyFormNameLabel => '密钥名称';

  @override
  String get sshKeyFormNameHint => '例如：生产环境密钥';

  @override
  String get sshKeyFormKeyType => '密钥类型';

  @override
  String get sshKeyFormKeySize => '密钥大小';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits 位';
  }

  @override
  String get sshKeyFormCommentLabel => '注释';

  @override
  String get sshKeyFormCommentHint => 'user@host 或描述';

  @override
  String get sshKeyFormCommentOptional => '注释（可选）';

  @override
  String get sshKeyFormImportFromFile => '从文件导入';

  @override
  String get sshKeyFormPrivateKeyLabel => '私钥';

  @override
  String get sshKeyFormPrivateKeyHint => '粘贴 SSH 私钥或使用上方按钮...';

  @override
  String get sshKeyFormPassphraseLabel => '口令（可选）';

  @override
  String get sshKeyFormNameRequired => '名称为必填项';

  @override
  String get sshKeyFormPrivateKeyRequired => '私钥为必填项';

  @override
  String get sshKeyFormFileReadError => '无法读取所选文件';

  @override
  String get sshKeyFormInvalidFormat => '无效的密钥文件 — 需要 PEM 格式（-----BEGIN ...）';

  @override
  String sshKeyFormFileError(String message) {
    return '读取文件失败：$message';
  }

  @override
  String get sshKeyFormSaving => '保存中...';

  @override
  String get sshKeySelectorLabel => 'SSH 密钥';

  @override
  String get sshKeySelectorNone => '无托管密钥';

  @override
  String get sshKeySelectorManage => '管理密钥...';

  @override
  String get sshKeySelectorError => '加载 SSH 密钥失败';

  @override
  String get sshKeyTileCopyPublicKey => '复制公钥';

  @override
  String get sshKeyTilePublicKeyCopied => '公钥已复制';

  @override
  String sshKeyTileLinkedServers(int count) {
    return '$count 台服务器使用中';
  }

  @override
  String get sshKeyTileUnlinkFirst => '请先从所有服务器取消关联';

  @override
  String get exportImportTitle => '导出 / 导入';

  @override
  String get exportSectionTitle => '导出';

  @override
  String get exportJsonButton => '导出为 JSON（不含凭据）';

  @override
  String get exportZipButton => '导出为加密 ZIP（含凭据）';

  @override
  String get importSectionTitle => '导入';

  @override
  String get importButton => '从文件导入';

  @override
  String get importSupportedFormats => '支持 JSON（明文）和 ZIP（加密）文件。';

  @override
  String exportedTo(String path) {
    return '已导出至：$path';
  }

  @override
  String get share => '分享';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '已导入 $servers 台服务器、$groups 个分组、$tags 个标签。跳过 $skipped 个。';
  }

  @override
  String get importPasswordTitle => '输入密码';

  @override
  String get importPasswordLabel => '导出密码';

  @override
  String get importPasswordDecrypt => '解密';

  @override
  String get exportPasswordTitle => '设置导出密码';

  @override
  String get exportPasswordDescription => '此密码将用于加密包含凭据的导出文件。';

  @override
  String get exportPasswordLabel => '密码';

  @override
  String get exportPasswordConfirmLabel => '确认密码';

  @override
  String get exportPasswordMismatch => '密码不匹配';

  @override
  String get exportPasswordButton => '加密并导出';

  @override
  String get importConflictTitle => '处理冲突';

  @override
  String get importConflictDescription => '导入时如何处理已存在的条目？';

  @override
  String get importConflictSkip => '跳过已存在的';

  @override
  String get importConflictRename => '重命名新条目';

  @override
  String get importConflictOverwrite => '覆盖';

  @override
  String get confirmDeleteLabel => '删除';

  @override
  String get keyGenTitle => '生成 SSH 密钥对';

  @override
  String get keyGenKeyType => '密钥类型';

  @override
  String get keyGenKeySize => '密钥大小';

  @override
  String get keyGenComment => '注释';

  @override
  String get keyGenCommentHint => 'user@host 或描述';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits 位';
  }

  @override
  String get keyGenGenerating => '生成中...';

  @override
  String get keyGenGenerate => '生成';

  @override
  String keyGenResultTitle(String type) {
    return '$type 密钥已生成';
  }

  @override
  String get keyGenPublicKey => '公钥';

  @override
  String get keyGenPrivateKey => '私钥';

  @override
  String keyGenCommentInfo(String comment) {
    return '注释：$comment';
  }

  @override
  String get keyGenAnother => '生成另一个';

  @override
  String get keyGenUseThisKey => '使用此密钥';

  @override
  String get keyGenCopyTooltip => '复制到剪贴板';

  @override
  String keyGenCopied(String label) {
    return '$label已复制';
  }

  @override
  String get colorPickerLabel => '颜色';

  @override
  String get iconPickerLabel => '图标';

  @override
  String get tagSelectorLabel => '标签';

  @override
  String get tagSelectorEmpty => '暂无标签';

  @override
  String get tagSelectorError => '加载标签失败';

  @override
  String get snippetListTitle => '代码片段';

  @override
  String get snippetSearchHint => '搜索代码片段...';

  @override
  String get snippetListEmpty => '暂无代码片段';

  @override
  String get snippetListEmptySubtitle => '创建可重用的代码片段和命令。';

  @override
  String get snippetAddButton => '添加代码片段';

  @override
  String get snippetDeleteTitle => '删除代码片段';

  @override
  String snippetDeleteMessage(String name) {
    return '删除\"$name\"？此操作无法撤销。';
  }

  @override
  String get snippetFormTitleEdit => '编辑代码片段';

  @override
  String get snippetFormTitleNew => '新建代码片段';

  @override
  String get snippetFormNameLabel => '名称';

  @override
  String get snippetFormNameHint => '例如：Docker 清理';

  @override
  String get snippetFormLanguageLabel => '语言';

  @override
  String get snippetFormContentLabel => '内容';

  @override
  String get snippetFormContentHint => '输入代码片段...';

  @override
  String get snippetFormDescriptionLabel => '描述';

  @override
  String get snippetFormDescriptionHint => '可选描述...';

  @override
  String get snippetFormFolderLabel => '文件夹';

  @override
  String get snippetFormNoFolder => '无文件夹';

  @override
  String get snippetFormNameRequired => '名称为必填项';

  @override
  String get snippetFormContentRequired => '内容为必填项';

  @override
  String get snippetFormUpdateButton => '更新代码片段';

  @override
  String get snippetFormCreateButton => '创建代码片段';

  @override
  String get snippetDetailTitle => '代码片段详情';

  @override
  String get snippetDetailDeleteTitle => '删除代码片段';

  @override
  String get snippetDetailDeleteMessage => '此操作无法撤销。';

  @override
  String get snippetDetailContent => '内容';

  @override
  String get snippetDetailFillVariables => '填写变量';

  @override
  String get snippetDetailDescription => '描述';

  @override
  String get snippetDetailVariables => '变量';

  @override
  String get snippetDetailTags => '标签';

  @override
  String get snippetDetailInfo => '信息';

  @override
  String get snippetDetailCreated => '创建时间';

  @override
  String get snippetDetailUpdated => '更新时间';

  @override
  String get variableEditorTitle => '模板变量';

  @override
  String get variableEditorAdd => '添加';

  @override
  String get variableEditorEmpty => '暂无变量。在内容中使用花括号语法来引用变量。';

  @override
  String get variableEditorNameLabel => '名称';

  @override
  String get variableEditorNameHint => '例如：hostname';

  @override
  String get variableEditorDefaultLabel => '默认值';

  @override
  String get variableEditorDefaultHint => '可选';

  @override
  String get variableFillTitle => '填写变量';

  @override
  String variableFillHint(String name) {
    return '输入 $name 的值';
  }

  @override
  String get variableFillPreview => '预览';

  @override
  String get terminalTitle => '终端';

  @override
  String get terminalEmpty => '无活跃会话';

  @override
  String get terminalEmptySubtitle => '连接到主机以打开终端会话。';

  @override
  String get terminalGoToHosts => '前往主机';

  @override
  String get terminalCloseAll => '关闭所有会话';

  @override
  String get terminalCloseTitle => '关闭会话';

  @override
  String terminalCloseMessage(String title) {
    return '关闭与\"$title\"的活跃连接？';
  }

  @override
  String get connectionAuthenticating => '认证中...';

  @override
  String connectionConnecting(String name) {
    return '正在连接 $name...';
  }

  @override
  String get connectionError => '连接错误';

  @override
  String get connectionLost => '连接已断开';

  @override
  String get connectionReconnect => '重新连接';

  @override
  String get snippetQuickPanelTitle => '插入代码片段';

  @override
  String get snippetQuickPanelSearch => '搜索代码片段...';

  @override
  String get snippetQuickPanelEmpty => '无可用代码片段';

  @override
  String get snippetQuickPanelNoMatch => '无匹配的代码片段';

  @override
  String get snippetQuickPanelInsertTooltip => '插入代码片段';

  @override
  String get terminalThemePickerTitle => '终端主题';

  @override
  String get validatorHostnameRequired => '主机名为必填项';

  @override
  String get validatorHostnameInvalid => '无效的主机名或 IP 地址';

  @override
  String get validatorPortRequired => '端口为必填项';

  @override
  String get validatorPortRange => '端口必须在 1 到 65535 之间';

  @override
  String get validatorUsernameRequired => '用户名为必填项';

  @override
  String get validatorUsernameInvalid => '无效的用户名格式';

  @override
  String get validatorServerNameRequired => '服务器名称为必填项';

  @override
  String get validatorServerNameLength => '服务器名称不得超过 100 个字符';

  @override
  String get validatorSshKeyInvalid => '无效的 SSH 密钥格式';

  @override
  String get validatorPasswordRequired => '密码为必填项';

  @override
  String get validatorPasswordLength => '密码至少需要 8 个字符';

  @override
  String get authMethodPassword => '密码';

  @override
  String get authMethodKey => 'SSH 密钥';

  @override
  String get authMethodBoth => '密码 + 密钥';

  @override
  String get serverCopySuffix => '（副本）';

  @override
  String get settingsDownloadLogs => '下载日志';

  @override
  String get settingsSendLogs => '发送日志给支持团队';

  @override
  String get settingsLogsSaved => '日志已保存';

  @override
  String get settingsLogsEmpty => '无日志条目';

  @override
  String get authLogin => '登录';

  @override
  String get authRegister => '注册';

  @override
  String get authForgotPassword => '忘记密码？';

  @override
  String get authWhyLogin => '登录以在所有设备间启用加密云同步。无需账户，应用也可完全离线使用。';

  @override
  String get authEmailLabel => '邮箱';

  @override
  String get authEmailRequired => '邮箱为必填项';

  @override
  String get authEmailInvalid => '无效的邮箱地址';

  @override
  String get authPasswordLabel => '密码';

  @override
  String get authConfirmPasswordLabel => '确认密码';

  @override
  String get authPasswordMismatch => '密码不匹配';

  @override
  String get authNoAccount => '没有账户？';

  @override
  String get authHasAccount => '已有账户？';

  @override
  String get authSelfHosted => '自托管服务器';

  @override
  String get authResetEmailSent => '如果账户存在，重置链接已发送到您的邮箱。';

  @override
  String get authResetDescription => '输入您的邮箱地址，我们将发送密码重置链接。';

  @override
  String get authSendResetLink => '发送重置链接';

  @override
  String get authBackToLogin => '返回登录';

  @override
  String get syncPasswordTitle => '同步密码';

  @override
  String get syncPasswordTitleCreate => '设置同步密码';

  @override
  String get syncPasswordTitleEnter => '输入同步密码';

  @override
  String get syncPasswordDescription =>
      '设置一个单独的密码来加密您的保险库数据。此密码不会离开您的设备——服务器只存储加密数据。';

  @override
  String get syncPasswordHintEnter => '输入您创建账户时设置的密码。';

  @override
  String get syncPasswordWarning => '如果忘记此密码，您的同步数据将无法恢复。没有重置选项。';

  @override
  String get syncPasswordLabel => '同步密码';

  @override
  String get syncPasswordWrong => '密码错误。请重试。';

  @override
  String get firstSyncTitle => '发现现有数据';

  @override
  String get firstSyncMessage => '此设备有现有数据，服务器上也有保险库。如何处理？';

  @override
  String get firstSyncMerge => '合并（服务器优先）';

  @override
  String get firstSyncOverwriteLocal => '覆盖本地数据';

  @override
  String get firstSyncKeepLocal => '保留本地并推送';

  @override
  String get firstSyncDeleteLocal => '删除本地并拉取';

  @override
  String get changeEncryptionPassword => '更改加密密码';

  @override
  String get changeEncryptionWarning => '您将从所有其他设备上注销。';

  @override
  String get changeEncryptionOldPassword => '当前密码';

  @override
  String get changeEncryptionNewPassword => '新密码';

  @override
  String get changeEncryptionSuccess => '密码已更改。';

  @override
  String get logoutAllDevices => '从所有设备注销';

  @override
  String get logoutAllDevicesConfirm => '将撤销所有活跃会话。您需要在所有设备上重新登录。';

  @override
  String get logoutAllDevicesSuccess => '已从所有设备注销。';

  @override
  String get syncSettingsTitle => '同步设置';

  @override
  String get syncAutoSync => '自动同步';

  @override
  String get syncAutoSyncDescription => '应用启动时自动同步';

  @override
  String get syncNow => '立即同步';

  @override
  String get syncSyncing => '同步中...';

  @override
  String get syncSuccess => '同步完成';

  @override
  String get syncError => '同步错误';

  @override
  String get syncServerUnreachable => '服务器不可达';

  @override
  String get syncServerUnreachableHint => '无法连接到同步服务器。请检查网络连接和服务器 URL。';

  @override
  String get syncNetworkError => '无法连接到服务器。请检查网络连接或稍后重试。';

  @override
  String get syncNeverSynced => '从未同步';

  @override
  String get syncVaultVersion => '保险库版本';

  @override
  String get syncTitle => '同步';

  @override
  String get settingsSectionNetwork => '网络与 DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS 服务器';

  @override
  String get settingsDnsDefault => '默认（Quad9 + Mullvad）';

  @override
  String get settingsDnsHint => '输入自定义 DoH 服务器 URL，用逗号分隔。交叉验证至少需要 2 台服务器。';

  @override
  String get settingsDnsLabel => 'DoH 服务器 URL';

  @override
  String get settingsDnsReset => '重置为默认';

  @override
  String get settingsSectionSync => '同步';

  @override
  String get settingsSyncAccount => '账户';

  @override
  String get settingsSyncNotLoggedIn => '未登录';

  @override
  String get settingsSyncStatus => '同步';

  @override
  String get settingsSyncServerUrl => '服务器 URL';

  @override
  String get settingsSyncDefaultServer => '默认（sshvault.app）';

  @override
  String get accountTitle => '账户';

  @override
  String get accountNotLoggedIn => '未登录';

  @override
  String get accountVerified => '已验证';

  @override
  String get accountMemberSince => '注册时间';

  @override
  String get accountDevices => '设备';

  @override
  String get accountNoDevices => '无已注册设备';

  @override
  String get accountLastSync => '上次同步';

  @override
  String get accountChangePassword => '更改密码';

  @override
  String get accountOldPassword => '当前密码';

  @override
  String get accountNewPassword => '新密码';

  @override
  String get accountDeleteAccount => '删除账户';

  @override
  String get accountDeleteWarning => '这将永久删除您的账户和所有同步数据。此操作无法撤销。';

  @override
  String get accountLogout => '注销';

  @override
  String get serverConfigTitle => '服务器配置';

  @override
  String get serverConfigSelfHosted => '自托管';

  @override
  String get serverConfigSelfHostedDescription => '使用您自己的 SSHVault 服务器';

  @override
  String get serverConfigUrlLabel => '服务器 URL';

  @override
  String get serverConfigTest => '测试连接';

  @override
  String get auditLogTitle => '活动日志';

  @override
  String get auditLogAll => '全部';

  @override
  String get auditLogEmpty => '未找到活动日志';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => '文件管理器';

  @override
  String get sftpLocalDevice => '本地设备';

  @override
  String get sftpSelectServer => '选择服务器...';

  @override
  String get sftpConnecting => '连接中...';

  @override
  String get sftpEmptyDirectory => '此目录为空';

  @override
  String get sftpNoConnection => '未连接服务器';

  @override
  String get sftpPathLabel => '路径';

  @override
  String get sftpUpload => '上传';

  @override
  String get sftpDownload => '下载';

  @override
  String get sftpDelete => '删除';

  @override
  String get sftpRename => '重命名';

  @override
  String get sftpNewFolder => '新建文件夹';

  @override
  String get sftpNewFolderName => '文件夹名称';

  @override
  String get sftpChmod => '权限';

  @override
  String get sftpChmodTitle => '更改权限';

  @override
  String get sftpChmodOctal => '八进制';

  @override
  String get sftpChmodOwner => '所有者';

  @override
  String get sftpChmodGroup => '群组';

  @override
  String get sftpChmodOther => '其他';

  @override
  String get sftpChmodRead => '读取';

  @override
  String get sftpChmodWrite => '写入';

  @override
  String get sftpChmodExecute => '执行';

  @override
  String get sftpCreateSymlink => '创建符号链接';

  @override
  String get sftpSymlinkTarget => '目标路径';

  @override
  String get sftpSymlinkName => '链接名称';

  @override
  String get sftpFilePreview => '文件预览';

  @override
  String get sftpFileInfo => '文件信息';

  @override
  String get sftpFileSize => '大小';

  @override
  String get sftpFileModified => '修改时间';

  @override
  String get sftpFilePermissions => '权限';

  @override
  String get sftpFileOwner => '所有者';

  @override
  String get sftpFileType => '类型';

  @override
  String get sftpFileLinkTarget => '链接目标';

  @override
  String get sftpTransfers => '传输';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get sftpTransferQueued => '排队中';

  @override
  String get sftpTransferActive => '传输中...';

  @override
  String get sftpTransferPaused => '已暂停';

  @override
  String get sftpTransferCompleted => '已完成';

  @override
  String get sftpTransferFailed => '失败';

  @override
  String get sftpTransferCancelled => '已取消';

  @override
  String get sftpPauseTransfer => '暂停';

  @override
  String get sftpResumeTransfer => '恢复';

  @override
  String get sftpCancelTransfer => '取消';

  @override
  String get sftpClearCompleted => '清除已完成';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active / $total 个传输';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个活跃',
      one: '1 个活跃',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个完成',
      one: '1 个完成',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个失败',
      one: '1 个失败',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => '复制到另一面板';

  @override
  String sftpConfirmDelete(int count) {
    return '删除 $count 个项目？';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return '删除\"$name\"？';
  }

  @override
  String get sftpDeleteSuccess => '删除成功';

  @override
  String get sftpRenameTitle => '重命名';

  @override
  String get sftpRenameLabel => '新名称';

  @override
  String get sftpSortByName => '名称';

  @override
  String get sftpSortBySize => '大小';

  @override
  String get sftpSortByDate => '日期';

  @override
  String get sftpSortByType => '类型';

  @override
  String get sftpShowHidden => '显示隐藏文件';

  @override
  String get sftpHideHidden => '隐藏隐藏文件';

  @override
  String get sftpSelectAll => '全选';

  @override
  String get sftpDeselectAll => '取消全选';

  @override
  String sftpItemsSelected(int count) {
    return '已选择 $count 项';
  }

  @override
  String get sftpRefresh => '刷新';

  @override
  String sftpConnectionError(String message) {
    return '连接失败：$message';
  }

  @override
  String get sftpPermissionDenied => '权限被拒绝';

  @override
  String sftpOperationFailed(String message) {
    return '操作失败：$message';
  }

  @override
  String get sftpOverwriteTitle => '文件已存在';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\"已存在。是否覆盖？';
  }

  @override
  String get sftpOverwrite => '覆盖';

  @override
  String sftpTransferStarted(String fileName) {
    return '传输已开始：$fileName';
  }

  @override
  String get sftpNoPaneSelected => '请先在另一面板中选择目标位置';

  @override
  String get sftpDirectoryTransferNotSupported => '目录传输即将支持';

  @override
  String get sftpSelect => '选择';

  @override
  String get sftpOpen => '打开';

  @override
  String get sftpExtractArchive => '在此处解压';

  @override
  String get sftpExtractSuccess => '压缩包已解压';

  @override
  String sftpExtractFailed(String message) {
    return '解压失败：$message';
  }

  @override
  String get sftpExtractUnsupported => '不支持的压缩格式';

  @override
  String get sftpExtracting => '解压中...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个上传已开始',
      one: '上传已开始',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个下载已开始',
      one: '下载已开始',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\"下载完成';
  }

  @override
  String get sftpSavedToDownloads => '已保存到 Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => '保存到文件';

  @override
  String get sftpFileSaved => '文件已保存';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个 SSH 会话活跃',
      one: 'SSH 会话活跃',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => '点击打开终端';

  @override
  String get settingsAccountAndSync => '账户与同步';

  @override
  String get settingsAccountSubtitleAuth => '已登录';

  @override
  String get settingsAccountSubtitleUnauth => '未登录';

  @override
  String get settingsSecuritySubtitle => '自动锁定、生物识别、PIN';

  @override
  String get settingsSshSubtitle => '端口 22，用户 root';

  @override
  String get settingsAppearanceSubtitle => '主题、语言、终端';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => '加密导出默认值';

  @override
  String get settingsAboutSubtitle => '版本、许可证';

  @override
  String get settingsSearchHint => '搜索设置...';

  @override
  String get settingsSearchNoResults => '未找到设置';

  @override
  String get aboutDeveloper => '由 Kiefer Networks 开发';

  @override
  String get aboutDonate => '捐赠';

  @override
  String get aboutOpenSourceLicenses => '开源许可证';

  @override
  String get aboutWebsite => '网站';

  @override
  String get aboutVersion => '版本';

  @override
  String get aboutBuild => '构建';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS 加密 DNS 查询并防止 DNS 欺骗。SSHVault 通过多个提供商验证主机名以检测攻击。';

  @override
  String get settingsDnsAddServer => '添加 DNS 服务器';

  @override
  String get settingsDnsServerUrl => '服务器 URL';

  @override
  String get settingsDnsDefaultBadge => '默认';

  @override
  String get settingsDnsResetDefaults => '重置为默认值';

  @override
  String get settingsDnsInvalidUrl => '请输入有效的 HTTPS URL';

  @override
  String get settingsDefaultAuthMethod => '认证方式';

  @override
  String get settingsAuthPassword => '密码';

  @override
  String get settingsAuthKey => 'SSH 密钥';

  @override
  String get settingsConnectionTimeout => '连接超时';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds秒';
  }

  @override
  String get settingsKeepaliveInterval => '保活间隔';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds秒';
  }

  @override
  String get settingsCompression => '压缩';

  @override
  String get settingsCompressionDescription => '启用 SSH 连接的 zlib 压缩';

  @override
  String get settingsTerminalType => '终端类型';

  @override
  String get settingsSectionConnection => '连接';

  @override
  String get settingsClipboardAutoClear => '剪贴板自动清除';

  @override
  String get settingsClipboardAutoClearOff => '关闭';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds秒';
  }

  @override
  String get settingsSessionTimeout => '会话超时';

  @override
  String get settingsSessionTimeoutOff => '关闭';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get settingsDuressPin => '胁迫 PIN';

  @override
  String get settingsDuressPinDescription => '输入后会清除所有数据的独立 PIN';

  @override
  String get settingsDuressPinSet => '胁迫 PIN 已设置';

  @override
  String get settingsDuressPinNotSet => '未设置';

  @override
  String get settingsDuressPinWarning =>
      '输入此 PIN 将永久删除所有本地数据，包括凭据、密钥和设置。此操作无法撤销。';

  @override
  String get settingsKeyRotationReminder => '密钥轮换提醒';

  @override
  String get settingsKeyRotationOff => '关闭';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days 天';
  }

  @override
  String get settingsFailedAttempts => 'PIN 输入失败次数';

  @override
  String get settingsSectionAppLock => '应用锁定';

  @override
  String get settingsSectionPrivacy => '隐私';

  @override
  String get settingsSectionReminders => '提醒';

  @override
  String get settingsSectionStatus => '状态';

  @override
  String get settingsExportBackupSubtitle => '导出、导入和备份';

  @override
  String get settingsExportJson => '导出为 JSON';

  @override
  String get settingsExportEncrypted => '加密导出';

  @override
  String get settingsImportFile => '从文件导入';

  @override
  String get settingsSectionImport => '导入';

  @override
  String get filterTitle => '筛选服务器';

  @override
  String get filterApply => '应用筛选';

  @override
  String get filterClearAll => '全部清除';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个筛选器生效',
      one: '1 个筛选器生效',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => '文件夹';

  @override
  String get filterTags => '标签';

  @override
  String get filterStatus => '状态';

  @override
  String get variablePreviewResolved => '已解析预览';

  @override
  String get variableInsert => '插入';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 台服务器',
      one: '1 台服务器',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已撤销 $count 个会话。',
      one: '已撤销 1 个会话。',
    );
    return '$_temp0您已注销。';
  }

  @override
  String get keyGenPassphrase => '口令';

  @override
  String get keyGenPassphraseHint => '可选 — 保护私钥';

  @override
  String get settingsDnsDefaultQuad9Mullvad => '默认（Quad9 + Mullvad）';

  @override
  String sshKeyDuplicate(String name) {
    return '相同指纹的密钥已存在：\"$name\"。每个 SSH 密钥必须是唯一的。';
  }

  @override
  String get sshKeyFingerprint => '指纹';

  @override
  String get sshKeyPublicKey => '公钥';

  @override
  String get jumpHost => '跳板机';

  @override
  String get jumpHostNone => '无';

  @override
  String get jumpHostLabel => '通过跳板机连接';

  @override
  String get jumpHostSelfError => '服务器不能作为自己的跳板机';

  @override
  String get jumpHostConnecting => '正在连接跳板机…';

  @override
  String get jumpHostCircularError => '检测到循环跳板机链';

  @override
  String get logoutDialogTitle => '注销';

  @override
  String get logoutDialogMessage => '是否删除所有本地数据？服务器、SSH 密钥、代码片段和设置将从此设备中删除。';

  @override
  String get logoutOnly => '仅注销';

  @override
  String get logoutAndDelete => '注销并删除数据';

  @override
  String get changeAvatar => '更换头像';

  @override
  String get removeAvatar => '移除头像';

  @override
  String get avatarUploadFailed => '头像上传失败';

  @override
  String get avatarTooLarge => '图片太大';

  @override
  String get deviceLastSeen => '上次在线';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn => '登录状态下无法更改服务器 URL。请先注销。';

  @override
  String get serverListNoFolder => '未分类';

  @override
  String get autoSyncInterval => '同步间隔';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get proxySettings => '代理设置';

  @override
  String get proxyType => '代理类型';

  @override
  String get proxyNone => '无代理';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => '代理主机';

  @override
  String get proxyPort => '代理端口';

  @override
  String get proxyUsername => '代理用户名';

  @override
  String get proxyPassword => '代理密码';

  @override
  String get proxyUseGlobal => '使用全局代理';

  @override
  String get proxyGlobal => '全局';

  @override
  String get proxyServerSpecific => '服务器专用';

  @override
  String get proxyTestConnection => '测试连接';

  @override
  String get proxyTestSuccess => '代理可达';

  @override
  String get proxyTestFailed => '代理不可达';

  @override
  String get proxyDefaultProxy => '默认代理';

  @override
  String get vpnRequired => '需要 VPN';

  @override
  String get vpnRequiredTooltip => '未连接 VPN 时显示警告';

  @override
  String get vpnActive => 'VPN 已启用';

  @override
  String get vpnInactive => 'VPN 未启用';

  @override
  String get vpnWarningTitle => 'VPN 未启用';

  @override
  String get vpnWarningMessage => '此服务器标记为需要 VPN 连接，但当前 VPN 未启用。是否仍要连接？';

  @override
  String get vpnConnectAnyway => '仍然连接';

  @override
  String get postConnectCommands => '连接后命令';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle => '连接后自动执行的命令（每行一个）';

  @override
  String get dashboardFavorites => '收藏';

  @override
  String get dashboardRecent => '最近';

  @override
  String get dashboardActiveSessions => '活跃会话';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get noRecentConnections => '无最近连接';

  @override
  String get terminalSplit => '分屏视图';

  @override
  String get terminalUnsplit => '关闭分屏';

  @override
  String get terminalSelectSession => '选择分屏视图的会话';

  @override
  String get knownHostsTitle => '已知主机';

  @override
  String get knownHostsSubtitle => '管理受信任的服务器指纹';

  @override
  String get hostKeyNewTitle => '新主机';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return '首次连接到 $hostname:$port。请在连接前验证指纹。';
  }

  @override
  String get hostKeyChangedTitle => '主机密钥已更改！';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return '$hostname:$port 的主机密钥已更改。这可能表示存在安全威胁。';
  }

  @override
  String get hostKeyFingerprint => '指纹';

  @override
  String get hostKeyType => '密钥类型';

  @override
  String get hostKeyTrustConnect => '信任并连接';

  @override
  String get hostKeyAcceptNew => '接受新密钥';

  @override
  String get hostKeyReject => '拒绝';

  @override
  String get hostKeyPreviousFingerprint => '之前的指纹';

  @override
  String get hostKeyDeleteAll => '删除所有已知主机';

  @override
  String get hostKeyDeleteConfirm => '确定要删除所有已知主机吗？下次连接时将再次提示确认。';

  @override
  String get hostKeyEmpty => '暂无已知主机';

  @override
  String get hostKeyEmptySubtitle => '首次连接后，主机指纹将保存在此处';

  @override
  String get hostKeyFirstSeen => '首次发现';

  @override
  String get hostKeyLastSeen => '上次发现';

  @override
  String get sshConfigImportPickFile => '选择 SSH 配置文件';

  @override
  String get sshConfigImportOrPaste => '或粘贴配置内容';

  @override
  String sshConfigImportParsed(int count) {
    return '找到 $count 个主机';
  }

  @override
  String get sshConfigImportDuplicate => '已存在';

  @override
  String get sshConfigImportNoHosts => '配置中未找到主机';

  @override
  String get sftpBookmarkAdd => '添加书签';

  @override
  String get sftpBookmarkLabel => '标签';

  @override
  String get disconnect => '断开连接';

  @override
  String get reportAndDisconnect => '举报并断开';

  @override
  String get continueAnyway => '仍然继续';

  @override
  String get insertSnippet => '插入代码片段';

  @override
  String get seconds => '秒';

  @override
  String get heartbeatLostMessage => '多次尝试后无法连接到服务器。为了安全起见，会话已终止。';

  @override
  String get attestationFailedTitle => '服务器验证失败';

  @override
  String get attestationFailedMessage =>
      '无法将服务器验证为合法的 SSHVault 后端。这可能表示中间人攻击或服务器配置错误。';

  @override
  String get attestationKeyChangedTitle => '服务器密钥已更改';

  @override
  String get attestationKeyChangedMessage =>
      '自初次连接以来，服务器的认证密钥已更改。这可能表示中间人攻击。除非服务器管理员确认了密钥轮换，否则请勿继续。';

  @override
  String get sectionLinks => '链接';

  @override
  String get sectionDeveloper => '开发者';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => '页面未找到';

  @override
  String get connectionTestSuccess => '连接成功';

  @override
  String connectionTestFailed(String message) {
    return '连接失败：$message';
  }

  @override
  String get serverVerificationFailed => '服务器验证失败';

  @override
  String get importSuccessful => '导入成功';

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
}
