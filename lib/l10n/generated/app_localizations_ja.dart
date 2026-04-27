// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'ホスト';

  @override
  String get navSnippets => 'スニペット';

  @override
  String get navFolders => 'フォルダ';

  @override
  String get navTags => 'タグ';

  @override
  String get navSshKeys => 'SSH鍵';

  @override
  String get navExportImport => 'エクスポート / インポート';

  @override
  String get navTerminal => 'ターミナル';

  @override
  String get navMore => 'その他';

  @override
  String get navManagement => '管理';

  @override
  String get navSettings => '設定';

  @override
  String get navAbout => 'SSHVaultについて';

  @override
  String get lockScreenTitle => 'SSHVaultはロックされています';

  @override
  String get lockScreenUnlock => 'ロック解除';

  @override
  String get lockScreenEnterPin => 'PINを入力';

  @override
  String lockScreenLockedOut(int minutes) {
    return '試行回数が多すぎます。$minutes分後に再試行してください。';
  }

  @override
  String get pinDialogSetTitle => 'PINコードを設定';

  @override
  String get pinDialogSetSubtitle => 'SSHVaultを保護する6桁のPINを入力してください';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'PINを確認';

  @override
  String get pinDialogErrorLength => 'PINは6桁でなければなりません';

  @override
  String get pinDialogErrorMismatch => 'PINが一致しません';

  @override
  String get pinDialogVerifyTitle => 'PINを入力';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PINが違います。残り$attempts回。';
  }

  @override
  String get securityBannerMessage =>
      'SSH認証情報は保護されていません。設定でPINまたは生体認証ロックを設定してください。';

  @override
  String get securityBannerDismiss => '閉じる';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionAppearance => '外観';

  @override
  String get settingsSectionTerminal => 'ターミナル';

  @override
  String get settingsSectionSshDefaults => 'SSHデフォルト';

  @override
  String get settingsSectionSecurity => 'セキュリティ';

  @override
  String get settingsSectionExport => 'エクスポート';

  @override
  String get settingsSectionAbout => 'SSHVaultについて';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeSystem => 'システム';

  @override
  String get settingsThemeLight => 'ライト';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsTerminalTheme => 'ターミナルテーマ';

  @override
  String get settingsTerminalThemeDefault => 'デフォルトダーク';

  @override
  String get settingsFontSize => 'フォントサイズ';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'デフォルトポート';

  @override
  String get settingsDefaultPortDialog => 'デフォルトSSHポート';

  @override
  String get settingsPortLabel => 'ポート';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'デフォルトユーザー名';

  @override
  String get settingsDefaultUsernameDialog => 'デフォルトユーザー名';

  @override
  String get settingsUsernameLabel => 'ユーザー名';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => '自動ロックタイムアウト';

  @override
  String get settingsAutoLockDisabled => '無効';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String get settingsAutoLockOff => 'オフ';

  @override
  String get settingsAutoLock1Min => '1分';

  @override
  String get settingsAutoLock5Min => '5分';

  @override
  String get settingsAutoLock15Min => '15分';

  @override
  String get settingsAutoLock30Min => '30分';

  @override
  String get settingsBiometricUnlock => '生体認証ロック解除';

  @override
  String get settingsBiometricNotAvailable => 'このデバイスでは利用できません';

  @override
  String get settingsBiometricError => '生体認証の確認中にエラーが発生しました';

  @override
  String get settingsBiometricReason => '生体認証ロック解除を有効にするために本人確認を行います';

  @override
  String get settingsBiometricRequiresPin => '生体認証ロック解除を有効にするには、まずPINを設定してください';

  @override
  String get settingsPinCode => 'PINコード';

  @override
  String get settingsPinIsSet => 'PINが設定済み';

  @override
  String get settingsPinNotConfigured => 'PINが未設定';

  @override
  String get settingsPinRemove => '削除';

  @override
  String get settingsPinRemoveWarning =>
      'PINを削除すると、すべてのデータベースフィールドが復号化され、生体認証ロック解除が無効になります。続行しますか？';

  @override
  String get settingsPinRemoveTitle => 'PINを削除';

  @override
  String get settingsPreventScreenshots => 'スクリーンショットの防止';

  @override
  String get settingsPreventScreenshotsDescription => 'スクリーンショットと画面録画をブロック';

  @override
  String get settingsEncryptExport => 'デフォルトでエクスポートを暗号化';

  @override
  String get settingsAbout => 'SSHVaultについて';

  @override
  String get settingsAboutLegalese => 'Kiefer Networks 提供';

  @override
  String get settingsAboutDescription => 'セキュアなセルフホスト型SSHクライアント';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => 'システム';

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
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get close => '閉じる';

  @override
  String get update => '更新';

  @override
  String get create => '作成';

  @override
  String get retry => '再試行';

  @override
  String get copy => 'コピー';

  @override
  String get edit => '編集';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'エラー: $message';
  }

  @override
  String get serverListTitle => 'ホスト';

  @override
  String get serverListEmpty => 'サーバーはまだありません';

  @override
  String get serverListEmptySubtitle => '最初のSSHサーバーを追加して始めましょう。';

  @override
  String get serverAddButton => 'サーバーを追加';

  @override
  String sshConfigImportMessage(int count) {
    return '~/.ssh/configに$count件のホストが見つかりました。インポートしますか？';
  }

  @override
  String get sshConfigNotFound => 'SSH設定ファイルが見つかりません';

  @override
  String get sshConfigEmpty => 'SSH設定にホストが見つかりません';

  @override
  String get sshConfigAddManually => '手動で追加';

  @override
  String get sshConfigImportAgain => 'SSH設定を再インポートしますか？';

  @override
  String get sshConfigImportKeys => '選択したホストが参照するSSH鍵をインポートしますか？';

  @override
  String sshConfigKeysImported(int count) {
    return '$count件のSSH鍵をインポートしました';
  }

  @override
  String get serverDuplicated => 'サーバーを複製しました';

  @override
  String get serverDeleteTitle => 'サーバーを削除';

  @override
  String serverDeleteMessage(String name) {
    return '「$name」を削除してもよろしいですか？この操作は取り消せません。';
  }

  @override
  String serverDeleteShort(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get serverConnect => '接続';

  @override
  String get serverDetails => '詳細';

  @override
  String get serverDuplicate => '複製';

  @override
  String get serverActive => 'アクティブ';

  @override
  String get serverNoFolder => 'フォルダなし';

  @override
  String get serverFormTitleEdit => 'サーバーを編集';

  @override
  String get serverFormTitleAdd => 'サーバーを追加';

  @override
  String get serverSaved => 'サーバーを保存しました';

  @override
  String get serverFormUpdateButton => 'サーバーを更新';

  @override
  String get serverFormAddButton => 'サーバーを追加';

  @override
  String get serverFormPublicKeyExtracted => '公開鍵の抽出に成功しました';

  @override
  String serverFormPublicKeyError(String message) {
    return '公開鍵を抽出できませんでした: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type鍵ペアを生成しました';
  }

  @override
  String get serverDetailTitle => 'サーバー詳細';

  @override
  String get serverDetailDeleteMessage => 'この操作は取り消せません。';

  @override
  String get serverDetailConnection => '接続';

  @override
  String get serverDetailHost => 'ホスト';

  @override
  String get serverDetailPort => 'ポート';

  @override
  String get serverDetailUsername => 'ユーザー名';

  @override
  String get serverDetailFolder => 'フォルダ';

  @override
  String get serverDetailTags => 'タグ';

  @override
  String get serverDetailNotes => 'メモ';

  @override
  String get serverDetailInfo => '情報';

  @override
  String get serverDetailCreated => '作成日';

  @override
  String get serverDetailUpdated => '更新日';

  @override
  String get serverDetailDistro => 'システム';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get serverFormNameLabel => 'サーバー名';

  @override
  String get serverFormHostnameLabel => 'ホスト名 / IP';

  @override
  String get serverFormPortLabel => 'ポート';

  @override
  String get serverFormUsernameLabel => 'ユーザー名';

  @override
  String get serverFormPasswordLabel => 'パスワード';

  @override
  String get serverFormUseManagedKey => '管理キーを使用';

  @override
  String get serverFormManagedKeySubtitle => '一元管理されたSSH鍵から選択';

  @override
  String get serverFormDirectKeySubtitle => 'このサーバーに鍵を直接貼り付け';

  @override
  String get serverFormGenerateKey => 'SSH鍵ペアを生成';

  @override
  String get serverFormPrivateKeyLabel => '秘密鍵';

  @override
  String get serverFormPrivateKeyHint => 'SSH秘密鍵を貼り付け...';

  @override
  String get serverFormExtractPublicKey => '公開鍵を抽出';

  @override
  String get serverFormPublicKeyLabel => '公開鍵';

  @override
  String get serverFormPublicKeyHint => '空の場合は秘密鍵から自動生成';

  @override
  String get serverFormPassphraseLabel => '鍵パスフレーズ（任意）';

  @override
  String get serverFormNotesLabel => 'メモ（任意）';

  @override
  String get searchServers => 'サーバーを検索...';

  @override
  String get filterAllFolders => 'すべてのフォルダ';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterActive => 'アクティブ';

  @override
  String get filterInactive => '非アクティブ';

  @override
  String get filterClear => 'クリア';

  @override
  String get folderListTitle => 'フォルダ';

  @override
  String get folderListEmpty => 'フォルダはまだありません';

  @override
  String get folderListEmptySubtitle => 'フォルダを作成してサーバーを整理しましょう。';

  @override
  String get folderAddButton => 'フォルダを追加';

  @override
  String get folderDeleteTitle => 'フォルダを削除';

  @override
  String folderDeleteMessage(String name) {
    return '「$name」を削除しますか？サーバーは未分類になります。';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count台のサーバー',
      one: '1台のサーバー',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => '折りたたむ';

  @override
  String get folderShowHosts => 'ホストを表示';

  @override
  String get folderConnectAll => 'すべて接続';

  @override
  String get folderFormTitleEdit => 'フォルダを編集';

  @override
  String get folderFormTitleNew => '新しいフォルダ';

  @override
  String get folderFormNameLabel => 'フォルダ名';

  @override
  String get folderFormParentLabel => '親フォルダ';

  @override
  String get folderFormParentNone => 'なし（ルート）';

  @override
  String get tagListTitle => 'タグ';

  @override
  String get tagListEmpty => 'タグはまだありません';

  @override
  String get tagListEmptySubtitle => 'タグを作成してサーバーにラベルを付けフィルタリングしましょう。';

  @override
  String get tagAddButton => 'タグを追加';

  @override
  String get tagDeleteTitle => 'タグを削除';

  @override
  String tagDeleteMessage(String name) {
    return '「$name」を削除しますか？すべてのサーバーから削除されます。';
  }

  @override
  String get tagFormTitleEdit => 'タグを編集';

  @override
  String get tagFormTitleNew => '新しいタグ';

  @override
  String get tagFormNameLabel => 'タグ名';

  @override
  String get sshKeyListTitle => 'SSH鍵';

  @override
  String get sshKeyListEmpty => 'SSH鍵はまだありません';

  @override
  String get sshKeyListEmptySubtitle => 'SSH鍵を生成またはインポートして一元管理しましょう';

  @override
  String get sshKeyCannotDeleteTitle => '削除できません';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return '「$name」を削除できません。$count台のサーバーで使用中です。まずすべてのサーバーからリンクを解除してください。';
  }

  @override
  String get sshKeyDeleteTitle => 'SSH鍵を削除';

  @override
  String sshKeyDeleteMessage(String name) {
    return '「$name」を削除しますか？この操作は取り消せません。';
  }

  @override
  String get sshKeyAddButton => 'SSH鍵を追加';

  @override
  String get sshKeyFormTitleEdit => 'SSH鍵を編集';

  @override
  String get sshKeyFormTitleAdd => 'SSH鍵を追加';

  @override
  String get sshKeyFormTabGenerate => '生成';

  @override
  String get sshKeyFormTabImport => 'インポート';

  @override
  String get sshKeyFormNameLabel => '鍵名';

  @override
  String get sshKeyFormNameHint => '例: 本番用キー';

  @override
  String get sshKeyFormKeyType => '鍵の種類';

  @override
  String get sshKeyFormKeySize => '鍵のサイズ';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bitsビット';
  }

  @override
  String get sshKeyFormCommentLabel => 'コメント';

  @override
  String get sshKeyFormCommentHint => 'user@host または説明';

  @override
  String get sshKeyFormCommentOptional => 'コメント（任意）';

  @override
  String get sshKeyFormImportFromFile => 'ファイルからインポート';

  @override
  String get sshKeyFormPrivateKeyLabel => '秘密鍵';

  @override
  String get sshKeyFormPrivateKeyHint => 'SSH秘密鍵を貼り付けるか上のボタンを使用...';

  @override
  String get sshKeyFormPassphraseLabel => 'パスフレーズ（任意）';

  @override
  String get sshKeyFormNameRequired => '名前は必須です';

  @override
  String get sshKeyFormPrivateKeyRequired => '秘密鍵は必須です';

  @override
  String get sshKeyFormFileReadError => '選択したファイルを読み取れませんでした';

  @override
  String get sshKeyFormInvalidFormat => '無効な鍵ファイル — PEM形式が必要です（-----BEGIN ...）';

  @override
  String sshKeyFormFileError(String message) {
    return 'ファイルの読み取りに失敗しました: $message';
  }

  @override
  String get sshKeyFormSaving => '保存中...';

  @override
  String get sshKeySelectorLabel => 'SSH鍵';

  @override
  String get sshKeySelectorNone => '管理キーなし';

  @override
  String get sshKeySelectorManage => '鍵を管理...';

  @override
  String get sshKeySelectorError => 'SSH鍵の読み込みに失敗しました';

  @override
  String get sshKeyTileCopyPublicKey => '公開鍵をコピー';

  @override
  String get sshKeyTilePublicKeyCopied => '公開鍵をコピーしました';

  @override
  String sshKeyTileLinkedServers(int count) {
    return '$count台のサーバーで使用中';
  }

  @override
  String get sshKeySavedSuccess => 'SSH鍵を保存しました';

  @override
  String get sshKeyDeletedSuccess => 'SSH鍵を削除しました';

  @override
  String get tagSavedSuccess => 'タグを保存しました';

  @override
  String get tagDeletedSuccess => 'タグを削除しました';

  @override
  String get folderDeletedSuccess => 'フォルダーを削除しました';

  @override
  String get sshKeyTileUnlinkFirst => 'まずすべてのサーバーからリンクを解除してください';

  @override
  String get exportImportTitle => 'エクスポート / インポート';

  @override
  String get exportSectionTitle => 'エクスポート';

  @override
  String get exportJsonButton => 'JSONとしてエクスポート（認証情報なし）';

  @override
  String get exportZipButton => '暗号化ZIPとしてエクスポート（認証情報あり）';

  @override
  String get importSectionTitle => 'インポート';

  @override
  String get importButton => 'ファイルからインポート';

  @override
  String get importSupportedFormats => 'JSON（プレーン）およびZIP（暗号化）ファイルに対応しています。';

  @override
  String exportedTo(String path) {
    return 'エクスポート先: $path';
  }

  @override
  String get share => '共有';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers件のサーバー、$groups件のグループ、$tags件のタグをインポートしました。$skipped件スキップ。';
  }

  @override
  String get importPasswordTitle => 'パスワードを入力';

  @override
  String get importPasswordLabel => 'エクスポートパスワード';

  @override
  String get importPasswordDecrypt => '復号化';

  @override
  String get exportPasswordTitle => 'エクスポートパスワードを設定';

  @override
  String get exportPasswordDescription =>
      'このパスワードは、認証情報を含むエクスポートファイルの暗号化に使用されます。';

  @override
  String get exportPasswordLabel => 'パスワード';

  @override
  String get exportPasswordConfirmLabel => 'パスワードを確認';

  @override
  String get exportPasswordMismatch => 'パスワードが一致しません';

  @override
  String get exportPasswordButton => '暗号化してエクスポート';

  @override
  String get importConflictTitle => '競合の処理';

  @override
  String get importConflictDescription => 'インポート中に既存のエントリをどのように処理しますか？';

  @override
  String get importConflictSkip => '既存をスキップ';

  @override
  String get importConflictRename => '新規をリネーム';

  @override
  String get importConflictOverwrite => '上書き';

  @override
  String get confirmDeleteLabel => '削除';

  @override
  String get keyGenTitle => 'SSH鍵ペアを生成';

  @override
  String get keyGenKeyType => '鍵の種類';

  @override
  String get keyGenKeySize => '鍵のサイズ';

  @override
  String get keyGenComment => 'コメント';

  @override
  String get keyGenCommentHint => 'user@host または説明';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bitsビット';
  }

  @override
  String get keyGenGenerating => '生成中...';

  @override
  String get keyGenGenerate => '生成';

  @override
  String keyGenResultTitle(String type) {
    return '$type鍵を生成しました';
  }

  @override
  String get keyGenPublicKey => '公開鍵';

  @override
  String get keyGenPrivateKey => '秘密鍵';

  @override
  String keyGenCommentInfo(String comment) {
    return 'コメント: $comment';
  }

  @override
  String get keyGenAnother => '別の鍵を生成';

  @override
  String get keyGenUseThisKey => 'この鍵を使用';

  @override
  String get keyGenCopyTooltip => 'クリップボードにコピー';

  @override
  String keyGenCopied(String label) {
    return '$labelをコピーしました';
  }

  @override
  String get colorPickerLabel => '色';

  @override
  String get iconPickerLabel => 'アイコン';

  @override
  String get tagSelectorLabel => 'タグ';

  @override
  String get tagSelectorEmpty => 'タグはまだありません';

  @override
  String get tagSelectorError => 'タグの読み込みに失敗しました';

  @override
  String get snippetListTitle => 'スニペット';

  @override
  String get snippetSearchHint => 'スニペットを検索...';

  @override
  String get snippetListEmpty => 'スニペットはまだありません';

  @override
  String get snippetListEmptySubtitle => '再利用可能なコードスニペットやコマンドを作成しましょう。';

  @override
  String get snippetAddButton => 'スニペットを追加';

  @override
  String get snippetDeleteTitle => 'スニペットを削除';

  @override
  String snippetDeleteMessage(String name) {
    return '「$name」を削除しますか？この操作は取り消せません。';
  }

  @override
  String get snippetFormTitleEdit => 'スニペットを編集';

  @override
  String get snippetFormTitleNew => '新しいスニペット';

  @override
  String get snippetFormNameLabel => '名前';

  @override
  String get snippetFormNameHint => '例: Docker クリーンアップ';

  @override
  String get snippetFormLanguageLabel => '言語';

  @override
  String get snippetFormContentLabel => '内容';

  @override
  String get snippetFormContentHint => 'スニペットコードを入力...';

  @override
  String get snippetFormDescriptionLabel => '説明';

  @override
  String get snippetFormDescriptionHint => '任意の説明...';

  @override
  String get snippetFormFolderLabel => 'フォルダ';

  @override
  String get snippetFormNoFolder => 'フォルダなし';

  @override
  String get snippetFormNameRequired => '名前は必須です';

  @override
  String get snippetFormContentRequired => '内容は必須です';

  @override
  String get snippetFormSaved => 'スニペットを保存しました';

  @override
  String get snippetFormUpdateButton => 'スニペットを更新';

  @override
  String get snippetFormCreateButton => 'スニペットを作成';

  @override
  String get snippetDetailTitle => 'スニペット詳細';

  @override
  String get snippetDetailDeleteTitle => 'スニペットを削除';

  @override
  String get snippetDetailDeleteMessage => 'この操作は取り消せません。';

  @override
  String get snippetDetailContent => '内容';

  @override
  String get snippetDetailFillVariables => '変数を入力';

  @override
  String get snippetDetailDescription => '説明';

  @override
  String get snippetDetailVariables => '変数';

  @override
  String get snippetDetailTags => 'タグ';

  @override
  String get snippetDetailInfo => '情報';

  @override
  String get snippetDetailCreated => '作成日';

  @override
  String get snippetDetailUpdated => '更新日';

  @override
  String get variableEditorTitle => 'テンプレート変数';

  @override
  String get variableEditorAdd => '追加';

  @override
  String get variableEditorEmpty => '変数がありません。内容で波括弧構文を使用して参照してください。';

  @override
  String get variableEditorNameLabel => '名前';

  @override
  String get variableEditorNameHint => '例: hostname';

  @override
  String get variableEditorDefaultLabel => 'デフォルト';

  @override
  String get variableEditorDefaultHint => '任意';

  @override
  String get variableFillTitle => '変数を入力';

  @override
  String variableFillHint(String name) {
    return '$nameの値を入力';
  }

  @override
  String get variableFillPreview => 'プレビュー';

  @override
  String get terminalTitle => 'ターミナル';

  @override
  String get terminalEmpty => 'アクティブなセッションはありません';

  @override
  String get terminalEmptySubtitle => 'ホストに接続してターミナルセッションを開きましょう。';

  @override
  String get terminalGoToHosts => 'ホストへ移動';

  @override
  String get terminalCloseAll => 'すべてのセッションを閉じる';

  @override
  String get terminalCloseTitle => 'セッションを閉じる';

  @override
  String terminalCloseMessage(String title) {
    return '「$title」へのアクティブな接続を閉じますか？';
  }

  @override
  String get connectionAuthenticating => '認証中...';

  @override
  String connectionConnecting(String name) {
    return '$nameに接続中...';
  }

  @override
  String get connectionError => '接続エラー';

  @override
  String get connectionLost => '接続が切断されました';

  @override
  String get connectionReconnect => '再接続';

  @override
  String get snippetQuickPanelTitle => 'スニペットを挿入';

  @override
  String get snippetQuickPanelSearch => 'スニペットを検索...';

  @override
  String get snippetQuickPanelEmpty => '利用可能なスニペットがありません';

  @override
  String get snippetQuickPanelNoMatch => '一致するスニペットがありません';

  @override
  String get snippetQuickPanelInsertTooltip => 'スニペットを挿入';

  @override
  String get terminalThemePickerTitle => 'ターミナルテーマ';

  @override
  String get validatorHostnameRequired => 'ホスト名は必須です';

  @override
  String get validatorHostnameInvalid => '無効なホスト名またはIPアドレスです';

  @override
  String get validatorPortRequired => 'ポートは必須です';

  @override
  String get validatorPortRange => 'ポートは1から65535の範囲でなければなりません';

  @override
  String get validatorUsernameRequired => 'ユーザー名は必須です';

  @override
  String get validatorUsernameInvalid => '無効なユーザー名形式です';

  @override
  String get validatorServerNameRequired => 'サーバー名は必須です';

  @override
  String get validatorServerNameLength => 'サーバー名は100文字以内でなければなりません';

  @override
  String get validatorSshKeyInvalid => '無効なSSH鍵形式です';

  @override
  String get validatorPasswordRequired => 'パスワードは必須です';

  @override
  String get validatorPasswordLength => 'パスワードは8文字以上でなければなりません';

  @override
  String get authMethodPassword => 'パスワード';

  @override
  String get authMethodKey => 'SSH鍵';

  @override
  String get authMethodBoth => 'パスワード + 鍵';

  @override
  String get serverCopySuffix => '（コピー）';

  @override
  String get settingsDownloadLogs => 'ログをダウンロード';

  @override
  String get settingsSendLogs => 'サポートにログを送信';

  @override
  String get settingsLogsSaved => 'ログを保存しました';

  @override
  String get settingsUpdated => '設定を更新しました';

  @override
  String get settingsThemeChanged => 'テーマを変更しました';

  @override
  String get settingsLanguageChanged => '言語を変更しました';

  @override
  String get settingsPinSetSuccess => 'PINを設定しました';

  @override
  String get settingsPinRemovedSuccess => 'PINを削除しました';

  @override
  String get settingsDuressPinSetSuccess => '緊急PINを設定しました';

  @override
  String get settingsDuressPinRemovedSuccess => '緊急PINを削除しました';

  @override
  String get settingsBiometricEnabled => '生体認証を有効にしました';

  @override
  String get settingsBiometricDisabled => '生体認証を無効にしました';

  @override
  String get settingsDnsServerAdded => 'DNSサーバーを追加しました';

  @override
  String get settingsDnsServerRemoved => 'DNSサーバーを削除しました';

  @override
  String get settingsDnsResetSuccess => 'DNSサーバーをリセットしました';

  @override
  String get settingsFontSizeDecreaseTooltip => 'フォントを小さく';

  @override
  String get settingsFontSizeIncreaseTooltip => 'フォントを大きく';

  @override
  String get settingsDnsRemoveServerTooltip => 'DNSサーバーを削除';

  @override
  String get settingsLogsEmpty => 'ログエントリがありません';

  @override
  String get authLogin => 'ログイン';

  @override
  String get authRegister => '登録';

  @override
  String get authForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get authWhyLogin =>
      'すべてのデバイス間で暗号化クラウド同期を有効にするにはサインインしてください。アカウントなしでもアプリは完全にオフラインで動作します。';

  @override
  String get authEmailLabel => 'メールアドレス';

  @override
  String get authEmailRequired => 'メールアドレスは必須です';

  @override
  String get authEmailInvalid => '無効なメールアドレスです';

  @override
  String get authPasswordLabel => 'パスワード';

  @override
  String get authConfirmPasswordLabel => 'パスワードを確認';

  @override
  String get authPasswordMismatch => 'パスワードが一致しません';

  @override
  String get authNoAccount => 'アカウントをお持ちでないですか？';

  @override
  String get authHasAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get authResetEmailSent => 'アカウントが存在する場合、リセットリンクをメールに送信しました。';

  @override
  String get authResetDescription => 'メールアドレスを入力すると、パスワードリセット用のリンクを送信します。';

  @override
  String get authSendResetLink => 'リセットリンクを送信';

  @override
  String get authBackToLogin => 'ログインに戻る';

  @override
  String get syncPasswordTitle => '同期パスワード';

  @override
  String get syncPasswordTitleCreate => '同期パスワードを設定';

  @override
  String get syncPasswordTitleEnter => '同期パスワードを入力';

  @override
  String get syncPasswordDescription =>
      'ボールトデータを暗号化するための個別のパスワードを設定します。このパスワードはデバイスから送信されません — サーバーは暗号化されたデータのみを保存します。';

  @override
  String get syncPasswordHintEnter => 'アカウント作成時に設定したパスワードを入力してください。';

  @override
  String get syncPasswordWarning =>
      'このパスワードを忘れると、同期されたデータを復元できません。リセットオプションはありません。';

  @override
  String get syncPasswordLabel => '同期パスワード';

  @override
  String get syncPasswordWrong => 'パスワードが間違っています。もう一度お試しください。';

  @override
  String get firstSyncTitle => '既存のデータが見つかりました';

  @override
  String get firstSyncMessage => 'このデバイスには既存のデータがあり、サーバーにもボールトがあります。どうしますか？';

  @override
  String get firstSyncMerge => 'マージ（サーバー優先）';

  @override
  String get firstSyncOverwriteLocal => 'ローカルデータを上書き';

  @override
  String get firstSyncKeepLocal => 'ローカルを保持してプッシュ';

  @override
  String get firstSyncDeleteLocal => 'ローカルを削除してプル';

  @override
  String get changeEncryptionPassword => '暗号化パスワードを変更';

  @override
  String get changeEncryptionWarning => '他のすべてのデバイスからログアウトされます。';

  @override
  String get changeEncryptionOldPassword => '現在のパスワード';

  @override
  String get changeEncryptionNewPassword => '新しいパスワード';

  @override
  String get changeEncryptionSuccess => 'パスワードを変更しました。';

  @override
  String get logoutAllDevices => 'すべてのデバイスからログアウト';

  @override
  String get logoutAllDevicesConfirm =>
      'すべてのアクティブなセッションが取り消されます。すべてのデバイスで再度ログインする必要があります。';

  @override
  String get logoutAllDevicesSuccess => 'すべてのデバイスからログアウトしました。';

  @override
  String get syncSettingsTitle => '同期設定';

  @override
  String get syncAutoSync => '自動同期';

  @override
  String get syncAutoSyncDescription => 'アプリ起動時に自動的に同期';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get syncSyncing => '同期中...';

  @override
  String get syncSuccess => '同期が完了しました';

  @override
  String get syncError => '同期エラー';

  @override
  String get syncServerUnreachable => 'サーバーに接続できません';

  @override
  String get syncServerUnreachableHint =>
      '同期サーバーに接続できませんでした。インターネット接続とサーバーURLを確認してください。';

  @override
  String get syncNetworkError => 'サーバーへの接続に失敗しました。インターネット接続を確認するか、後で再試行してください。';

  @override
  String get syncNeverSynced => '未同期';

  @override
  String get syncVaultVersion => 'ボールトバージョン';

  @override
  String get syncTitle => '同期';

  @override
  String get settingsSectionNetwork => 'ネットワークとDNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPSサーバー';

  @override
  String get settingsDnsDefault => 'デフォルト（Quad9 + Mullvad）';

  @override
  String get settingsDnsHint =>
      'カスタムDoHサーバーURLをカンマ区切りで入力してください。クロスチェック検証には少なくとも2つのサーバーが必要です。';

  @override
  String get settingsDnsLabel => 'DoHサーバーURL';

  @override
  String get settingsDnsReset => 'デフォルトにリセット';

  @override
  String get settingsSectionSync => '同期';

  @override
  String get settingsSyncAccount => 'アカウント';

  @override
  String get settingsSyncNotLoggedIn => '未ログイン';

  @override
  String get settingsSyncStatus => '同期';

  @override
  String get settingsSyncServerUrl => 'サーバーURL';

  @override
  String get settingsSyncDefaultServer => 'デフォルト（sshvault.app）';

  @override
  String get accountTitle => 'アカウント';

  @override
  String get accountNotLoggedIn => '未ログイン';

  @override
  String get accountVerified => '認証済み';

  @override
  String get accountMemberSince => '登録日';

  @override
  String get accountDevices => 'デバイス';

  @override
  String get accountNoDevices => '登録されたデバイスはありません';

  @override
  String get accountLastSync => '最終同期';

  @override
  String get accountChangePassword => 'パスワードを変更';

  @override
  String get accountOldPassword => '現在のパスワード';

  @override
  String get accountNewPassword => '新しいパスワード';

  @override
  String get accountDeleteAccount => 'アカウントを削除';

  @override
  String get accountDeleteWarning => 'アカウントとすべての同期データが完全に削除されます。この操作は取り消せません。';

  @override
  String get accountLogout => 'ログアウト';

  @override
  String get serverConfigTitle => 'サーバー設定';

  @override
  String get serverConfigUrlLabel => 'サーバーURL';

  @override
  String get serverConfigTest => '接続テスト';

  @override
  String get serverSetupTitle => 'サーバーセットアップ';

  @override
  String get serverSetupInfoCard =>
      'ShellVaultはエンドツーエンド暗号化同期のためにセルフホストサーバーが必要です。開始するには独自のインスタンスをデプロイしてください。';

  @override
  String get serverSetupRepoLink => 'GitHubで表示';

  @override
  String get serverSetupContinue => '続行';

  @override
  String get settingsServerNotConfigured => 'サーバーが設定されていません';

  @override
  String get settingsSetupSync => 'データをバックアップするために同期を設定してください';

  @override
  String get settingsChangeServer => 'サーバーを変更';

  @override
  String get settingsChangeServerConfirm => 'サーバーを変更するとログアウトされます。続行しますか？';

  @override
  String get auditLogTitle => 'アクティビティログ';

  @override
  String get auditLogAll => 'すべて';

  @override
  String get auditLogEmpty => 'アクティビティログが見つかりません';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'ファイルマネージャー';

  @override
  String get sftpLocalDevice => 'ローカルデバイス';

  @override
  String get sftpSelectServer => 'サーバーを選択...';

  @override
  String get sftpConnecting => '接続中...';

  @override
  String get sftpEmptyDirectory => 'このディレクトリは空です';

  @override
  String get sftpNoConnection => 'サーバーに接続されていません';

  @override
  String get sftpPathLabel => 'パス';

  @override
  String get sftpUpload => 'アップロード';

  @override
  String get sftpDownload => 'ダウンロード';

  @override
  String get sftpDelete => '削除';

  @override
  String get sftpRename => '名前を変更';

  @override
  String get sftpNewFolder => '新しいフォルダ';

  @override
  String get sftpNewFolderName => 'フォルダ名';

  @override
  String get sftpChmod => '権限';

  @override
  String get sftpChmodTitle => '権限を変更';

  @override
  String get sftpChmodOctal => '8進数';

  @override
  String get sftpChmodOwner => '所有者';

  @override
  String get sftpChmodGroup => 'グループ';

  @override
  String get sftpChmodOther => 'その他';

  @override
  String get sftpChmodRead => '読み取り';

  @override
  String get sftpChmodWrite => '書き込み';

  @override
  String get sftpChmodExecute => '実行';

  @override
  String get sftpCreateSymlink => 'シンボリックリンクを作成';

  @override
  String get sftpSymlinkTarget => 'ターゲットパス';

  @override
  String get sftpSymlinkName => 'リンク名';

  @override
  String get sftpFilePreview => 'ファイルプレビュー';

  @override
  String get sftpFileInfo => 'ファイル情報';

  @override
  String get sftpFileSize => 'サイズ';

  @override
  String get sftpFileModified => '更新日';

  @override
  String get sftpFilePermissions => '権限';

  @override
  String get sftpFileOwner => '所有者';

  @override
  String get sftpFileType => '種類';

  @override
  String get sftpFileLinkTarget => 'リンク先';

  @override
  String get sftpTransfers => '転送';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get sftpTransferQueued => '待機中';

  @override
  String get sftpTransferActive => '転送中...';

  @override
  String get sftpTransferPaused => '一時停止';

  @override
  String get sftpTransferCompleted => '完了';

  @override
  String get sftpTransferFailed => '失敗';

  @override
  String get sftpTransferCancelled => 'キャンセル済み';

  @override
  String get sftpPauseTransfer => '一時停止';

  @override
  String get sftpResumeTransfer => '再開';

  @override
  String get sftpCancelTransfer => 'キャンセル';

  @override
  String get sftpClearCompleted => '完了を消去';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active / $total件の転送';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件アクティブ',
      one: '1件アクティブ',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件完了',
      one: '1件完了',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件失敗',
      one: '1件失敗',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => '他のペインにコピー';

  @override
  String sftpConfirmDelete(int count) {
    return '$count件のアイテムを削除しますか？';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get sftpDeleteSuccess => '削除しました';

  @override
  String get sftpRenameTitle => '名前を変更';

  @override
  String get sftpRenameLabel => '新しい名前';

  @override
  String get sftpSortByName => '名前';

  @override
  String get sftpSortBySize => 'サイズ';

  @override
  String get sftpSortByDate => '日付';

  @override
  String get sftpSortByType => '種類';

  @override
  String get sftpShowHidden => '隠しファイルを表示';

  @override
  String get sftpHideHidden => '隠しファイルを非表示';

  @override
  String get sftpSelectAll => 'すべて選択';

  @override
  String get sftpDeselectAll => 'すべて選択解除';

  @override
  String sftpItemsSelected(int count) {
    return '$count件選択中';
  }

  @override
  String get sftpRefresh => '更新';

  @override
  String sftpConnectionError(String message) {
    return '接続に失敗しました: $message';
  }

  @override
  String get sftpPermissionDenied => '権限がありません';

  @override
  String sftpOperationFailed(String message) {
    return '操作に失敗しました: $message';
  }

  @override
  String get sftpOverwriteTitle => 'ファイルが既に存在します';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '「$fileName」は既に存在します。上書きしますか？';
  }

  @override
  String get sftpOverwrite => '上書き';

  @override
  String sftpTransferStarted(String fileName) {
    return '転送を開始しました: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'まず他のペインで保存先を選択してください';

  @override
  String get sftpDirectoryTransferNotSupported => 'ディレクトリ転送は近日対応予定です';

  @override
  String get sftpSelect => '選択';

  @override
  String get sftpOpen => '開く';

  @override
  String get sftpExtractArchive => 'ここに展開';

  @override
  String get sftpExtractSuccess => 'アーカイブを展開しました';

  @override
  String sftpExtractFailed(String message) {
    return '展開に失敗しました: $message';
  }

  @override
  String get sftpExtractUnsupported => 'サポートされていないアーカイブ形式です';

  @override
  String get sftpExtracting => '展開中...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のアップロードを開始しました',
      one: 'アップロードを開始しました',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のダウンロードを開始しました',
      one: 'ダウンロードを開始しました',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '「$fileName」をダウンロードしました';
  }

  @override
  String get sftpSavedToDownloads => 'Downloads/SSHVaultに保存しました';

  @override
  String get sftpSaveToFiles => 'ファイルに保存';

  @override
  String get sftpFileSaved => 'ファイルを保存しました';

  @override
  String get fileChooserOpenFile => 'Open file';

  @override
  String get fileChooserSaveFile => 'Save file';

  @override
  String get fileChooserOpenDirectory => 'Choose folder';

  @override
  String get fileChooserImportArchive => 'Import backup';

  @override
  String get fileChooserImportSshConfig => 'Import SSH config';

  @override
  String get fileChooserImportSettings => 'Import settings';

  @override
  String get fileChooserPickKeyFile => 'Pick SSH key file';

  @override
  String get fileChooserUploadFiles => 'Upload files';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のSSHセッションがアクティブです',
      one: 'SSHセッションがアクティブです',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'タップしてターミナルを開く';

  @override
  String get settingsAccountAndSync => 'アカウントと同期';

  @override
  String get settingsAccountSubtitleAuth => 'サインイン済み';

  @override
  String get settingsAccountSubtitleUnauth => '未サインイン';

  @override
  String get settingsSecuritySubtitle => '自動ロック、生体認証、PIN';

  @override
  String get settingsSshSubtitle => 'ポート22、ユーザー root';

  @override
  String get settingsAppearanceSubtitle => 'テーマ、言語、ターミナル';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => '暗号化エクスポートのデフォルト';

  @override
  String get settingsAboutSubtitle => 'バージョン、ライセンス';

  @override
  String get settingsSearchHint => '設定を検索...';

  @override
  String get settingsSearchNoResults => '設定が見つかりません';

  @override
  String get aboutDeveloper => 'Kiefer Networks が開発';

  @override
  String get aboutDonate => '寄付';

  @override
  String get aboutOpenSourceLicenses => 'オープンソースライセンス';

  @override
  String get aboutWebsite => 'ウェブサイト';

  @override
  String get aboutVersion => 'バージョン';

  @override
  String get aboutBuild => 'ビルド';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPSはDNSクエリを暗号化し、DNSスプーフィングを防止します。SSHVaultは複数のプロバイダーに対してホスト名を検証し、攻撃を検知します。';

  @override
  String get settingsDnsAddServer => 'DNSサーバーを追加';

  @override
  String get settingsDnsServerUrl => 'サーバーURL';

  @override
  String get settingsDnsDefaultBadge => 'デフォルト';

  @override
  String get settingsDnsResetDefaults => 'デフォルトにリセット';

  @override
  String get settingsDnsInvalidUrl => '有効なHTTPS URLを入力してください';

  @override
  String get settingsDefaultAuthMethod => '認証方法';

  @override
  String get settingsAuthPassword => 'パスワード';

  @override
  String get settingsAuthKey => 'SSH鍵';

  @override
  String get settingsConnectionTimeout => '接続タイムアウト';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds秒';
  }

  @override
  String get settingsKeepaliveInterval => 'キープアライブ間隔';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds秒';
  }

  @override
  String get settingsCompression => '圧縮';

  @override
  String get settingsCompressionDescription => 'SSH接続のzlib圧縮を有効にする';

  @override
  String get settingsTerminalType => 'ターミナルタイプ';

  @override
  String get settingsSectionConnection => '接続';

  @override
  String get settingsClipboardAutoClear => 'クリップボード自動消去';

  @override
  String get settingsClipboardAutoClearOff => 'オフ';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds秒';
  }

  @override
  String get settingsSessionTimeout => 'セッションタイムアウト';

  @override
  String get settingsSessionTimeoutOff => 'オフ';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes分';
  }

  @override
  String get settingsDuressPin => '緊急PIN';

  @override
  String get settingsDuressPinDescription => '入力するとすべてのデータを消去する別のPIN';

  @override
  String get settingsDuressPinSet => '緊急PINが設定済み';

  @override
  String get settingsDuressPinNotSet => '未設定';

  @override
  String get settingsDuressPinWarning =>
      'このPINを入力すると、認証情報、鍵、設定を含むすべてのローカルデータが完全に削除されます。この操作は取り消せません。';

  @override
  String get settingsKeyRotationReminder => '鍵ローテーションリマインダー';

  @override
  String get settingsKeyRotationOff => 'オフ';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days日';
  }

  @override
  String get settingsFailedAttempts => 'PIN入力失敗回数';

  @override
  String get settingsSectionAppLock => 'アプリロック';

  @override
  String get settingsSectionPrivacy => 'プライバシー';

  @override
  String get settingsSectionReminders => 'リマインダー';

  @override
  String get settingsSectionStatus => 'ステータス';

  @override
  String get settingsExportBackupSubtitle => 'エクスポート、インポート、バックアップ';

  @override
  String get settingsExportJson => 'JSONとしてエクスポート';

  @override
  String get settingsExportEncrypted => '暗号化してエクスポート';

  @override
  String get settingsImportFile => 'ファイルからインポート';

  @override
  String get settingsSectionImport => 'インポート';

  @override
  String get filterTitle => 'サーバーをフィルタ';

  @override
  String get filterApply => 'フィルタを適用';

  @override
  String get filterClearAll => 'すべてクリア';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のフィルタが有効',
      one: '1件のフィルタが有効',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'フォルダ';

  @override
  String get filterTags => 'タグ';

  @override
  String get filterStatus => 'ステータス';

  @override
  String get variablePreviewResolved => '解決済みプレビュー';

  @override
  String get variableInsert => '挿入';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count台のサーバー',
      one: '1台のサーバー',
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
      other: '$count件のセッションを取り消しました。',
      one: '1件のセッションを取り消しました。',
    );
    return '$_temp0ログアウトしました。';
  }

  @override
  String get keyGenPassphrase => 'パスフレーズ';

  @override
  String get keyGenPassphraseHint => '任意 — 秘密鍵を保護します';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'デフォルト（Quad9 + Mullvad）';

  @override
  String sshKeyDuplicate(String name) {
    return '同じフィンガープリントの鍵が既に存在します:「$name」。各SSH鍵は一意でなければなりません。';
  }

  @override
  String get sshKeyFingerprint => 'フィンガープリント';

  @override
  String get sshKeyPublicKey => '公開鍵';

  @override
  String get jumpHost => '踏み台ホスト';

  @override
  String get jumpHostNone => 'なし';

  @override
  String get jumpHostLabel => '踏み台ホスト経由で接続';

  @override
  String get jumpHostSelfError => 'サーバー自身を踏み台ホストに設定できません';

  @override
  String get jumpHostConnecting => '踏み台ホストに接続中…';

  @override
  String get jumpHostCircularError => '踏み台ホストチェーンの循環を検出しました';

  @override
  String get logoutDialogTitle => 'ログアウト';

  @override
  String get logoutDialogMessage =>
      'すべてのローカルデータを削除しますか？サーバー、SSH鍵、スニペット、設定がこのデバイスから削除されます。';

  @override
  String get logoutOnly => 'ログアウトのみ';

  @override
  String get logoutAndDelete => 'ログアウトしてデータを削除';

  @override
  String get changeAvatar => 'アバターを変更';

  @override
  String get removeAvatar => 'アバターを削除';

  @override
  String get avatarUploadFailed => 'アバターのアップロードに失敗しました';

  @override
  String get avatarTooLarge => '画像が大きすぎます';

  @override
  String get deviceLastSeen => '最終確認';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'ログイン中はサーバーURLを変更できません。まずログアウトしてください。';

  @override
  String get serverListNoFolder => '未分類';

  @override
  String get autoSyncInterval => '同期間隔';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes分';
  }

  @override
  String get proxySettings => 'プロキシ設定';

  @override
  String get proxyType => 'プロキシタイプ';

  @override
  String get proxyNone => 'プロキシなし';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'プロキシホスト';

  @override
  String get proxyPort => 'プロキシポート';

  @override
  String get proxyUsername => 'プロキシユーザー名';

  @override
  String get proxyPassword => 'プロキシパスワード';

  @override
  String get proxyUseGlobal => 'グローバルプロキシを使用';

  @override
  String get proxyGlobal => 'グローバル';

  @override
  String get proxyServerSpecific => 'サーバー固有';

  @override
  String get proxyTestConnection => '接続テスト';

  @override
  String get proxyTestSuccess => 'プロキシに接続可能';

  @override
  String get proxyTestFailed => 'プロキシに接続できません';

  @override
  String get proxyDefaultProxy => 'デフォルトプロキシ';

  @override
  String get vpnRequired => 'VPNが必要';

  @override
  String get vpnRequiredTooltip => 'VPN未接続時に警告を表示';

  @override
  String get vpnActive => 'VPN有効';

  @override
  String get vpnInactive => 'VPN無効';

  @override
  String get vpnWarningTitle => 'VPNが無効です';

  @override
  String get vpnWarningMessage =>
      'このサーバーにはVPN接続が必要とされていますが、現在VPNが有効ではありません。それでも接続しますか？';

  @override
  String get vpnConnectAnyway => 'そのまま接続';

  @override
  String get postConnectCommands => '接続後コマンド';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle => '接続後に自動実行されるコマンド（1行に1つ）';

  @override
  String get dashboardFavorites => 'お気に入り';

  @override
  String get dashboardRecent => '最近';

  @override
  String get dashboardActiveSessions => 'アクティブセッション';

  @override
  String get addToFavorites => 'お気に入りに追加';

  @override
  String get removeFromFavorites => 'お気に入りから削除';

  @override
  String get noRecentConnections => '最近の接続はありません';

  @override
  String get terminalSplit => '画面分割';

  @override
  String get terminalUnsplit => '分割を閉じる';

  @override
  String get terminalSelectSession => '画面分割用のセッションを選択';

  @override
  String get knownHostsTitle => '既知のホスト';

  @override
  String get knownHostsSubtitle => '信頼済みサーバーのフィンガープリントを管理';

  @override
  String get hostKeyNewTitle => '新しいホスト';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return '$hostname:$portへの初回接続です。接続前にフィンガープリントを確認してください。';
  }

  @override
  String get hostKeyChangedTitle => 'ホスト鍵が変更されました！';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return '$hostname:$portのホスト鍵が変更されました。これはセキュリティ上の脅威を示している可能性があります。';
  }

  @override
  String get hostKeyFingerprint => 'フィンガープリント';

  @override
  String get hostKeyType => '鍵の種類';

  @override
  String get hostKeyTrustConnect => '信頼して接続';

  @override
  String get hostKeyAcceptNew => '新しい鍵を受け入れる';

  @override
  String get hostKeyReject => '拒否';

  @override
  String get hostKeyPreviousFingerprint => '以前のフィンガープリント';

  @override
  String get hostKeyDeleteAll => 'すべての既知のホストを削除';

  @override
  String get hostKeyDeleteConfirm =>
      'すべての既知のホストを削除してもよろしいですか？次回の接続時に再度確認が表示されます。';

  @override
  String get hostKeyEmpty => '既知のホストはまだありません';

  @override
  String get hostKeyEmptySubtitle => '初回接続後にホストのフィンガープリントがここに保存されます';

  @override
  String get hostKeyFirstSeen => '初回確認';

  @override
  String get hostKeyLastSeen => '最終確認';

  @override
  String get sshConfigImportTitle => 'SSH設定をインポート';

  @override
  String get sshConfigImportPickFile => 'SSH設定ファイルを選択';

  @override
  String get sshConfigImportOrPaste => 'または設定内容を貼り付け';

  @override
  String sshConfigImportParsed(int count) {
    return '$count件のホストが見つかりました';
  }

  @override
  String get sshConfigImportButton => 'インポート';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count件のサーバーをインポートしました';
  }

  @override
  String get sshConfigImportDuplicate => '既に存在します';

  @override
  String get sshConfigImportNoHosts => '設定にホストが見つかりません';

  @override
  String get sftpBookmarkAdd => 'ブックマークを追加';

  @override
  String get sftpBookmarkLabel => 'ラベル';

  @override
  String get disconnect => '切断';

  @override
  String get reportAndDisconnect => '報告して切断';

  @override
  String get continueAnyway => '続行する';

  @override
  String get insertSnippet => 'スニペットを挿入';

  @override
  String get seconds => '秒';

  @override
  String get heartbeatLostMessage =>
      '複数回の試行後、サーバーに接続できませんでした。セキュリティのため、セッションを終了しました。';

  @override
  String get attestationFailedTitle => 'サーバー検証に失敗しました';

  @override
  String get attestationFailedMessage =>
      'サーバーを正規のSSHVaultバックエンドとして検証できませんでした。中間者攻撃またはサーバーの設定ミスの可能性があります。';

  @override
  String get attestationKeyChangedTitle => 'サーバー鍵が変更されました';

  @override
  String get attestationKeyChangedMessage =>
      '初回接続以降、サーバーの認証鍵が変更されました。中間者攻撃の可能性があります。サーバー管理者が鍵のローテーションを確認しない限り、続行しないでください。';

  @override
  String get sectionLinks => 'リンク';

  @override
  String get sectionDeveloper => '開発者';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'ページが見つかりません';

  @override
  String get connectionTestSuccess => '接続に成功しました';

  @override
  String connectionTestFailed(String message) {
    return '接続に失敗しました: $message';
  }

  @override
  String get serverVerificationFailed => 'サーバー検証に失敗しました';

  @override
  String get importSuccessful => 'インポートに成功しました';

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
  String get deviceDeleteConfirmTitle => 'デバイスを削除';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return '\"$name\"を削除してもよろしいですか？デバイスは直ちにログアウトされます。';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage => 'これは現在のデバイスです。直ちにログアウトされます。';

  @override
  String get deviceDeleteSuccess => 'デバイスを削除しました';

  @override
  String get deviceDeletedCurrentLogout => '現在のデバイスを削除しました。ログアウトされました。';

  @override
  String get thisDevice => 'このデバイス';
}
