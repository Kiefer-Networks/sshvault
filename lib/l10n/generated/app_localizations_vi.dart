// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'May chu';

  @override
  String get navSnippets => 'Doan ma';

  @override
  String get navFolders => 'Thu muc';

  @override
  String get navTags => 'Nhan';

  @override
  String get navSshKeys => 'Khoa SSH';

  @override
  String get navExportImport => 'Xuat / Nhap';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Them';

  @override
  String get navManagement => 'Quan ly';

  @override
  String get navSettings => 'Cai dat';

  @override
  String get navAbout => 'Gioi thieu';

  @override
  String get lockScreenTitle => 'SSHVault da bi khoa';

  @override
  String get lockScreenUnlock => 'Mo khoa';

  @override
  String get lockScreenEnterPin => 'Nhap PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Qua nhieu lan thu that bai. Thu lai sau $minutes phut.';
  }

  @override
  String get pinDialogSetTitle => 'Dat ma PIN';

  @override
  String get pinDialogSetSubtitle => 'Nhap PIN 6 chu so de bao ve SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Xac nhan PIN';

  @override
  String get pinDialogErrorLength => 'PIN phai co dung 6 chu so';

  @override
  String get pinDialogErrorMismatch => 'PIN khong khop';

  @override
  String get pinDialogVerifyTitle => 'Nhap PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Sai PIN. Con $attempts lan thu.';
  }

  @override
  String get securityBannerMessage =>
      'Thong tin dang nhap SSH chua duoc bao ve. Thiet lap PIN hoac khoa sinh trac hoc trong Cai dat.';

  @override
  String get securityBannerDismiss => 'Bo qua';

  @override
  String get settingsTitle => 'Cai dat';

  @override
  String get settingsSectionAppearance => 'Giao dien';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'Mac dinh SSH';

  @override
  String get settingsSectionSecurity => 'Bao mat';

  @override
  String get settingsSectionExport => 'Xuat';

  @override
  String get settingsSectionAbout => 'Gioi thieu';

  @override
  String get settingsTheme => 'Giao dien';

  @override
  String get settingsThemeSystem => 'He thong';

  @override
  String get settingsThemeLight => 'Sang';

  @override
  String get settingsThemeDark => 'Toi';

  @override
  String get settingsTerminalTheme => 'Giao dien terminal';

  @override
  String get settingsTerminalThemeDefault => 'Toi mac dinh';

  @override
  String get settingsFontSize => 'Co chu';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Cong mac dinh';

  @override
  String get settingsDefaultPortDialog => 'Cong SSH mac dinh';

  @override
  String get settingsPortLabel => 'Cong';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Ten nguoi dung mac dinh';

  @override
  String get settingsDefaultUsernameDialog => 'Ten nguoi dung mac dinh';

  @override
  String get settingsUsernameLabel => 'Ten nguoi dung';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Tu dong khoa';

  @override
  String get settingsAutoLockDisabled => 'Tat';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes phut';
  }

  @override
  String get settingsAutoLockOff => 'Tat';

  @override
  String get settingsAutoLock1Min => '1 phut';

  @override
  String get settingsAutoLock5Min => '5 phut';

  @override
  String get settingsAutoLock15Min => '15 phut';

  @override
  String get settingsAutoLock30Min => '30 phut';

  @override
  String get settingsBiometricUnlock => 'Mo khoa sinh trac hoc';

  @override
  String get settingsBiometricNotAvailable =>
      'Khong kha dung tren thiet bi nay';

  @override
  String get settingsBiometricError => 'Loi khi kiem tra sinh trac hoc';

  @override
  String get settingsBiometricReason =>
      'Xac minh danh tinh de bat mo khoa sinh trac hoc';

  @override
  String get settingsBiometricRequiresPin =>
      'Dat PIN truoc de bat mo khoa sinh trac hoc';

  @override
  String get settingsPinCode => 'Ma PIN';

  @override
  String get settingsPinIsSet => 'Da dat PIN';

  @override
  String get settingsPinNotConfigured => 'Chua cau hinh PIN';

  @override
  String get settingsPinRemove => 'Xoa';

  @override
  String get settingsPinRemoveWarning =>
      'Xoa PIN se giai ma tat ca cac truong co so du lieu va tat mo khoa sinh trac hoc. Tiep tuc?';

  @override
  String get settingsPinRemoveTitle => 'Xoa PIN';

  @override
  String get settingsPreventScreenshots => 'Chan chup man hinh';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Chan chup man hinh va ghi man hinh';

  @override
  String get settingsEncryptExport => 'Ma hoa xuat theo mac dinh';

  @override
  String get settingsAbout => 'Gioi thieu SSHVault';

  @override
  String get settingsAboutLegalese => 'boi Kiefer Networks';

  @override
  String get settingsAboutDescription => 'Ung dung SSH an toan, tu luu tru';

  @override
  String get settingsLanguage => 'Ngon ngu';

  @override
  String get settingsLanguageSystem => 'He thong';

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
  String get cancel => 'Huy';

  @override
  String get save => 'Luu';

  @override
  String get delete => 'Xoa';

  @override
  String get close => 'Dong';

  @override
  String get update => 'Cap nhat';

  @override
  String get create => 'Tao';

  @override
  String get retry => 'Thu lai';

  @override
  String get copy => 'Sao chep';

  @override
  String get edit => 'Chinh sua';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Loi: $message';
  }

  @override
  String get serverListTitle => 'May chu';

  @override
  String get serverListEmpty => 'Chua co may chu nao';

  @override
  String get serverListEmptySubtitle => 'Them may chu SSH dau tien de bat dau.';

  @override
  String get serverAddButton => 'Them may chu';

  @override
  String sshConfigImportMessage(int count) {
    return 'Tim thay $count may chu trong ~/.ssh/config. Nhap chung?';
  }

  @override
  String get sshConfigNotFound => 'Khong tim thay tep cau hinh SSH';

  @override
  String get sshConfigEmpty => 'Khong tim thay may chu trong cau hinh SSH';

  @override
  String get sshConfigAddManually => 'Them thu cong';

  @override
  String get sshConfigImportAgain => 'Nhap lai cau hinh SSH?';

  @override
  String get sshConfigImportKeys =>
      'Nhap khoa SSH duoc tham chieu boi cac may chu da chon?';

  @override
  String sshConfigKeysImported(int count) {
    return 'Da nhap $count khoa SSH';
  }

  @override
  String get serverDuplicated => 'Da nhan ban may chu';

  @override
  String get serverDeleteTitle => 'Xoa may chu';

  @override
  String serverDeleteMessage(String name) {
    return 'Ban co chac chan muon xoa \"$name\"? Hanh dong nay khong the hoan tac.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Xoa \"$name\"?';
  }

  @override
  String get serverConnect => 'Ket noi';

  @override
  String get serverDetails => 'Chi tiet';

  @override
  String get serverDuplicate => 'Nhan ban';

  @override
  String get serverActive => 'Hoat dong';

  @override
  String get serverNoFolder => 'Khong co thu muc';

  @override
  String get serverFormTitleEdit => 'Chinh sua may chu';

  @override
  String get serverFormTitleAdd => 'Them may chu';

  @override
  String get serverSaved => 'Đã lưu máy chủ';

  @override
  String get serverFormUpdateButton => 'Cap nhat may chu';

  @override
  String get serverFormAddButton => 'Them may chu';

  @override
  String get serverFormPublicKeyExtracted =>
      'Trich xuat khoa cong khai thanh cong';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Khong the trich xuat khoa cong khai: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Da tao cap khoa $type';
  }

  @override
  String get serverDetailTitle => 'Chi tiet may chu';

  @override
  String get serverDetailDeleteMessage => 'Hanh dong nay khong the hoan tac.';

  @override
  String get serverDetailConnection => 'Ket noi';

  @override
  String get serverDetailHost => 'May chu';

  @override
  String get serverDetailPort => 'Cong';

  @override
  String get serverDetailUsername => 'Ten nguoi dung';

  @override
  String get serverDetailFolder => 'Thu muc';

  @override
  String get serverDetailTags => 'Nhan';

  @override
  String get serverDetailNotes => 'Ghi chu';

  @override
  String get serverDetailInfo => 'Thong tin';

  @override
  String get serverDetailCreated => 'Ngay tao';

  @override
  String get serverDetailUpdated => 'Ngay cap nhat';

  @override
  String get serverDetailDistro => 'He thong';

  @override
  String get copiedToClipboard => 'Da sao chep vao clipboard';

  @override
  String get serverFormNameLabel => 'Ten may chu';

  @override
  String get serverFormHostnameLabel => 'Ten may chu / IP';

  @override
  String get serverFormPortLabel => 'Cong';

  @override
  String get serverFormUsernameLabel => 'Ten nguoi dung';

  @override
  String get serverFormPasswordLabel => 'Mat khau';

  @override
  String get serverFormUseManagedKey => 'Su dung khoa duoc quan ly';

  @override
  String get serverFormManagedKeySubtitle =>
      'Chon tu cac khoa SSH duoc quan ly tap trung';

  @override
  String get serverFormDirectKeySubtitle =>
      'Dan khoa truc tiep vao may chu nay';

  @override
  String get serverFormGenerateKey => 'Tao cap khoa SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Khoa rieng tu';

  @override
  String get serverFormPrivateKeyHint => 'Dan khoa rieng tu SSH...';

  @override
  String get serverFormExtractPublicKey => 'Trich xuat khoa cong khai';

  @override
  String get serverFormPublicKeyLabel => 'Khoa cong khai';

  @override
  String get serverFormPublicKeyHint =>
      'Tu dong tao tu khoa rieng tu neu de trong';

  @override
  String get serverFormPassphraseLabel => 'Cum tu mat khau (tuy chon)';

  @override
  String get serverFormNotesLabel => 'Ghi chu (tuy chon)';

  @override
  String get searchServers => 'Tim kiem may chu...';

  @override
  String get filterAllFolders => 'Tat ca thu muc';

  @override
  String get filterAll => 'Tat ca';

  @override
  String get filterActive => 'Hoat dong';

  @override
  String get filterInactive => 'Khong hoat dong';

  @override
  String get filterClear => 'Xoa';

  @override
  String get folderListTitle => 'Thu muc';

  @override
  String get folderListEmpty => 'Chua co thu muc nao';

  @override
  String get folderListEmptySubtitle => 'Tao thu muc de to chuc may chu.';

  @override
  String get folderAddButton => 'Them thu muc';

  @override
  String get folderDeleteTitle => 'Xoa thu muc';

  @override
  String folderDeleteMessage(String name) {
    return 'Xoa \"$name\"? May chu se khong duoc phan loai.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count may chu',
      one: '1 may chu',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Thu gon';

  @override
  String get folderShowHosts => 'Hien thi may chu';

  @override
  String get folderConnectAll => 'Ket noi tat ca';

  @override
  String get folderFormTitleEdit => 'Chinh sua thu muc';

  @override
  String get folderFormTitleNew => 'Thu muc moi';

  @override
  String get folderFormNameLabel => 'Ten thu muc';

  @override
  String get folderFormParentLabel => 'Thu muc cha';

  @override
  String get folderFormParentNone => 'Khong (Goc)';

  @override
  String get tagListTitle => 'Nhan';

  @override
  String get tagListEmpty => 'Chua co nhan nao';

  @override
  String get tagListEmptySubtitle => 'Tao nhan de danh dau va loc may chu.';

  @override
  String get tagAddButton => 'Them nhan';

  @override
  String get tagDeleteTitle => 'Xoa nhan';

  @override
  String tagDeleteMessage(String name) {
    return 'Xoa \"$name\"? No se bi xoa khoi tat ca may chu.';
  }

  @override
  String get tagFormTitleEdit => 'Chinh sua nhan';

  @override
  String get tagFormTitleNew => 'Nhan moi';

  @override
  String get tagFormNameLabel => 'Ten nhan';

  @override
  String get sshKeyListTitle => 'Khoa SSH';

  @override
  String get sshKeyListEmpty => 'Chua co khoa SSH nao';

  @override
  String get sshKeyListEmptySubtitle =>
      'Tao hoac nhap khoa SSH de quan ly tap trung';

  @override
  String get sshKeyCannotDeleteTitle => 'Khong the xoa';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Khong the xoa \"$name\". Dang duoc su dung boi $count may chu. Huy lien ket voi tat ca may chu truoc.';
  }

  @override
  String get sshKeyDeleteTitle => 'Xoa khoa SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Xoa \"$name\"? Hanh dong nay khong the hoan tac.';
  }

  @override
  String get sshKeyAddButton => 'Them khoa SSH';

  @override
  String get sshKeyFormTitleEdit => 'Chinh sua khoa SSH';

  @override
  String get sshKeyFormTitleAdd => 'Them khoa SSH';

  @override
  String get sshKeyFormTabGenerate => 'Tao';

  @override
  String get sshKeyFormTabImport => 'Nhap';

  @override
  String get sshKeyFormNameLabel => 'Ten khoa';

  @override
  String get sshKeyFormNameHint => 'vd. Khoa san xuat cua toi';

  @override
  String get sshKeyFormKeyType => 'Loai khoa';

  @override
  String get sshKeyFormKeySize => 'Kich thuoc khoa';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Ghi chu';

  @override
  String get sshKeyFormCommentHint => 'nguoidung@maychu hoac mo ta';

  @override
  String get sshKeyFormCommentOptional => 'Ghi chu (tuy chon)';

  @override
  String get sshKeyFormImportFromFile => 'Nhap tu tep';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Khoa rieng tu';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Dan khoa rieng tu SSH hoac su dung nut phia tren...';

  @override
  String get sshKeyFormPassphraseLabel => 'Cum tu mat khau (tuy chon)';

  @override
  String get sshKeyFormNameRequired => 'Ten la bat buoc';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Khoa rieng tu la bat buoc';

  @override
  String get sshKeyFormFileReadError => 'Khong the doc tep da chon';

  @override
  String get sshKeyFormInvalidFormat =>
      'Dinh dang khoa khong hop le — can dinh dang PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Khong the doc tep: $message';
  }

  @override
  String get sshKeyFormSaving => 'Dang luu...';

  @override
  String get sshKeySelectorLabel => 'Khoa SSH';

  @override
  String get sshKeySelectorNone => 'Khong co khoa duoc quan ly';

  @override
  String get sshKeySelectorManage => 'Quan ly khoa...';

  @override
  String get sshKeySelectorError => 'Khong the tai khoa SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Sao chep khoa cong khai';

  @override
  String get sshKeyTilePublicKeyCopied => 'Da sao chep khoa cong khai';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Duoc su dung boi $count may chu';
  }

  @override
  String get sshKeySavedSuccess => 'Đã lưu khóa SSH';

  @override
  String get sshKeyDeletedSuccess => 'Đã xóa khóa SSH';

  @override
  String get tagSavedSuccess => 'Đã lưu thẻ';

  @override
  String get tagDeletedSuccess => 'Đã xóa thẻ';

  @override
  String get folderDeletedSuccess => 'Đã xóa thư mục';

  @override
  String get sshKeyTileUnlinkFirst => 'Huy lien ket voi tat ca may chu truoc';

  @override
  String get exportImportTitle => 'Xuat / Nhap';

  @override
  String get exportSectionTitle => 'Xuat';

  @override
  String get exportJsonButton =>
      'Xuat dang JSON (khong co thong tin dang nhap)';

  @override
  String get exportZipButton => 'Xuat ZIP ma hoa (voi thong tin dang nhap)';

  @override
  String get importSectionTitle => 'Nhap';

  @override
  String get importButton => 'Nhap tu tep';

  @override
  String get importSupportedFormats =>
      'Ho tro tep JSON (thuong) va ZIP (ma hoa).';

  @override
  String exportedTo(String path) {
    return 'Da xuat den: $path';
  }

  @override
  String get share => 'Chia se';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'Da nhap $servers may chu, $groups nhom, $tags nhan. Bo qua $skipped.';
  }

  @override
  String get importPasswordTitle => 'Nhap mat khau';

  @override
  String get importPasswordLabel => 'Mat khau xuat';

  @override
  String get importPasswordDecrypt => 'Giai ma';

  @override
  String get exportPasswordTitle => 'Dat mat khau xuat';

  @override
  String get exportPasswordDescription =>
      'Mat khau nay se duoc su dung de ma hoa tep xuat bao gom thong tin dang nhap.';

  @override
  String get exportPasswordLabel => 'Mat khau';

  @override
  String get exportPasswordConfirmLabel => 'Xac nhan mat khau';

  @override
  String get exportPasswordMismatch => 'Mat khau khong khop';

  @override
  String get exportPasswordButton => 'Ma hoa va xuat';

  @override
  String get importConflictTitle => 'Xu ly xung dot';

  @override
  String get importConflictDescription =>
      'Xu ly cac muc da ton tai nhu the nao khi nhap?';

  @override
  String get importConflictSkip => 'Bo qua muc da ton tai';

  @override
  String get importConflictRename => 'Doi ten muc moi';

  @override
  String get importConflictOverwrite => 'Ghi de';

  @override
  String get confirmDeleteLabel => 'Xoa';

  @override
  String get keyGenTitle => 'Tao cap khoa SSH';

  @override
  String get keyGenKeyType => 'Loai khoa';

  @override
  String get keyGenKeySize => 'Kich thuoc khoa';

  @override
  String get keyGenComment => 'Ghi chu';

  @override
  String get keyGenCommentHint => 'nguoidung@maychu hoac mo ta';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Dang tao...';

  @override
  String get keyGenGenerate => 'Tao';

  @override
  String keyGenResultTitle(String type) {
    return 'Da tao khoa $type';
  }

  @override
  String get keyGenPublicKey => 'Khoa cong khai';

  @override
  String get keyGenPrivateKey => 'Khoa rieng tu';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Ghi chu: $comment';
  }

  @override
  String get keyGenAnother => 'Tao khoa khac';

  @override
  String get keyGenUseThisKey => 'Su dung khoa nay';

  @override
  String get keyGenCopyTooltip => 'Sao chep vao clipboard';

  @override
  String keyGenCopied(String label) {
    return 'Da sao chep $label';
  }

  @override
  String get colorPickerLabel => 'Mau sac';

  @override
  String get iconPickerLabel => 'Bieu tuong';

  @override
  String get tagSelectorLabel => 'Nhan';

  @override
  String get tagSelectorEmpty => 'Chua co nhan nao';

  @override
  String get tagSelectorError => 'Khong the tai nhan';

  @override
  String get snippetListTitle => 'Doan ma';

  @override
  String get snippetSearchHint => 'Tim kiem doan ma...';

  @override
  String get snippetListEmpty => 'Chua co doan ma nao';

  @override
  String get snippetListEmptySubtitle =>
      'Tao cac doan ma va lenh co the tai su dung.';

  @override
  String get snippetAddButton => 'Them doan ma';

  @override
  String get snippetDeleteTitle => 'Xoa doan ma';

  @override
  String snippetDeleteMessage(String name) {
    return 'Xoa \"$name\"? Hanh dong nay khong the hoan tac.';
  }

  @override
  String get snippetFormTitleEdit => 'Chinh sua doan ma';

  @override
  String get snippetFormTitleNew => 'Doan ma moi';

  @override
  String get snippetFormNameLabel => 'Ten';

  @override
  String get snippetFormNameHint => 'vd. Don dep Docker';

  @override
  String get snippetFormLanguageLabel => 'Ngon ngu';

  @override
  String get snippetFormContentLabel => 'Noi dung';

  @override
  String get snippetFormContentHint => 'Nhap ma doan ma...';

  @override
  String get snippetFormDescriptionLabel => 'Mo ta';

  @override
  String get snippetFormDescriptionHint => 'Mo ta tuy chon...';

  @override
  String get snippetFormFolderLabel => 'Thu muc';

  @override
  String get snippetFormNoFolder => 'Khong co thu muc';

  @override
  String get snippetFormNameRequired => 'Ten la bat buoc';

  @override
  String get snippetFormContentRequired => 'Noi dung la bat buoc';

  @override
  String get snippetFormSaved => 'Snippet da duoc luu';

  @override
  String get snippetFormUpdateButton => 'Cap nhat doan ma';

  @override
  String get snippetFormCreateButton => 'Tao doan ma';

  @override
  String get snippetDetailTitle => 'Chi tiet doan ma';

  @override
  String get snippetDetailDeleteTitle => 'Xoa doan ma';

  @override
  String get snippetDetailDeleteMessage => 'Hanh dong nay khong the hoan tac.';

  @override
  String get snippetDetailContent => 'Noi dung';

  @override
  String get snippetDetailFillVariables => 'Dien bien';

  @override
  String get snippetDetailDescription => 'Mo ta';

  @override
  String get snippetDetailVariables => 'Bien';

  @override
  String get snippetDetailTags => 'Nhan';

  @override
  String get snippetDetailInfo => 'Thong tin';

  @override
  String get snippetDetailCreated => 'Ngay tao';

  @override
  String get snippetDetailUpdated => 'Ngay cap nhat';

  @override
  String get variableEditorTitle => 'Bien mau';

  @override
  String get variableEditorAdd => 'Them';

  @override
  String get variableEditorEmpty =>
      'Khong co bien. Su dung cu phap ngoac nhon trong noi dung de tham chieu.';

  @override
  String get variableEditorNameLabel => 'Ten';

  @override
  String get variableEditorNameHint => 'vd. tenmaychu';

  @override
  String get variableEditorDefaultLabel => 'Mac dinh';

  @override
  String get variableEditorDefaultHint => 'tuy chon';

  @override
  String get variableFillTitle => 'Dien bien';

  @override
  String variableFillHint(String name) {
    return 'Nhap gia tri cho $name';
  }

  @override
  String get variableFillPreview => 'Xem truoc';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Khong co phien hoat dong';

  @override
  String get terminalEmptySubtitle =>
      'Ket noi den may chu de mo phien terminal.';

  @override
  String get terminalGoToHosts => 'Di den May chu';

  @override
  String get terminalCloseAll => 'Dong tat ca phien';

  @override
  String get terminalCloseTitle => 'Dong phien';

  @override
  String terminalCloseMessage(String title) {
    return 'Dong ket noi hoat dong den \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Dang xac thuc...';

  @override
  String connectionConnecting(String name) {
    return 'Dang ket noi den $name...';
  }

  @override
  String get connectionError => 'Loi ket noi';

  @override
  String get connectionLost => 'Mat ket noi';

  @override
  String get connectionReconnect => 'Ket noi lai';

  @override
  String get snippetQuickPanelTitle => 'Chen doan ma';

  @override
  String get snippetQuickPanelSearch => 'Tim kiem doan ma...';

  @override
  String get snippetQuickPanelEmpty => 'Khong co doan ma nao';

  @override
  String get snippetQuickPanelNoMatch => 'Khong tim thay doan ma phu hop';

  @override
  String get snippetQuickPanelInsertTooltip => 'Chen doan ma';

  @override
  String get terminalThemePickerTitle => 'Giao dien terminal';

  @override
  String get validatorHostnameRequired => 'Ten may chu la bat buoc';

  @override
  String get validatorHostnameInvalid =>
      'Ten may chu hoac dia chi IP khong hop le';

  @override
  String get validatorPortRequired => 'Cong la bat buoc';

  @override
  String get validatorPortRange => 'Cong phai tu 1 den 65535';

  @override
  String get validatorUsernameRequired => 'Ten nguoi dung la bat buoc';

  @override
  String get validatorUsernameInvalid =>
      'Dinh dang ten nguoi dung khong hop le';

  @override
  String get validatorServerNameRequired => 'Ten may chu la bat buoc';

  @override
  String get validatorServerNameLength =>
      'Ten may chu phai co toi da 100 ky tu';

  @override
  String get validatorSshKeyInvalid => 'Dinh dang khoa SSH khong hop le';

  @override
  String get validatorPasswordRequired => 'Mat khau la bat buoc';

  @override
  String get validatorPasswordLength => 'Mat khau phai co it nhat 8 ky tu';

  @override
  String get authMethodPassword => 'Mat khau';

  @override
  String get authMethodKey => 'Khoa SSH';

  @override
  String get authMethodBoth => 'Mat khau + Khoa';

  @override
  String get serverCopySuffix => '(Ban sao)';

  @override
  String get settingsDownloadLogs => 'Tai nhat ky';

  @override
  String get settingsSendLogs => 'Gui nhat ky cho ho tro';

  @override
  String get settingsLogsSaved => 'Da luu nhat ky thanh cong';

  @override
  String get settingsUpdated => 'Đã cập nhật cài đặt';

  @override
  String get settingsThemeChanged => 'Đã đổi giao diện';

  @override
  String get settingsLanguageChanged => 'Đã đổi ngôn ngữ';

  @override
  String get settingsPinSetSuccess => 'Đã đặt PIN';

  @override
  String get settingsPinRemovedSuccess => 'Đã xóa PIN';

  @override
  String get settingsDuressPinSetSuccess => 'Đã đặt PIN cưỡng ép';

  @override
  String get settingsDuressPinRemovedSuccess => 'Đã xóa PIN cưỡng ép';

  @override
  String get settingsBiometricEnabled => 'Đã bật mở khóa sinh trắc học';

  @override
  String get settingsBiometricDisabled => 'Đã tắt mở khóa sinh trắc học';

  @override
  String get settingsDnsServerAdded => 'Đã thêm máy chủ DNS';

  @override
  String get settingsDnsServerRemoved => 'Đã xóa máy chủ DNS';

  @override
  String get settingsDnsResetSuccess => 'Đã đặt lại máy chủ DNS';

  @override
  String get settingsFontSizeDecreaseTooltip => 'Thu nhỏ chữ';

  @override
  String get settingsFontSizeIncreaseTooltip => 'Phóng to chữ';

  @override
  String get settingsDnsRemoveServerTooltip => 'Xóa máy chủ DNS';

  @override
  String get settingsLogsEmpty => 'Khong co muc nhat ky nao';

  @override
  String get authLogin => 'Dang nhap';

  @override
  String get authRegister => 'Dang ky';

  @override
  String get authForgotPassword => 'Quen mat khau?';

  @override
  String get authWhyLogin =>
      'Dang nhap de bat dong bo dam may ma hoa tren tat ca thiet bi. Ung dung hoat dong day du ngoai tuyen ma khong can tai khoan.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'Email la bat buoc';

  @override
  String get authEmailInvalid => 'Dia chi email khong hop le';

  @override
  String get authPasswordLabel => 'Mat khau';

  @override
  String get authConfirmPasswordLabel => 'Xac nhan mat khau';

  @override
  String get authPasswordMismatch => 'Mat khau khong khop';

  @override
  String get authNoAccount => 'Chua co tai khoan?';

  @override
  String get authHasAccount => 'Da co tai khoan?';

  @override
  String get authResetEmailSent =>
      'Neu tai khoan ton tai, lien ket dat lai da duoc gui den email cua ban.';

  @override
  String get authResetDescription =>
      'Nhap dia chi email va chung toi se gui cho ban lien ket de dat lai mat khau.';

  @override
  String get authSendResetLink => 'Gui lien ket dat lai';

  @override
  String get authBackToLogin => 'Quay lai dang nhap';

  @override
  String get syncPasswordTitle => 'Mat khau dong bo';

  @override
  String get syncPasswordTitleCreate => 'Dat mat khau dong bo';

  @override
  String get syncPasswordTitleEnter => 'Nhap mat khau dong bo';

  @override
  String get syncPasswordDescription =>
      'Dat mat khau rieng de ma hoa du lieu kho. Mat khau nay khong bao gio roi khoi thiet bi cua ban — may chu chi luu tru du lieu da ma hoa.';

  @override
  String get syncPasswordHintEnter =>
      'Nhap mat khau ban da dat khi tao tai khoan.';

  @override
  String get syncPasswordWarning =>
      'Neu ban quen mat khau nay, du lieu dong bo khong the khoi phuc. Khong co tuy chon dat lai.';

  @override
  String get syncPasswordLabel => 'Mat khau dong bo';

  @override
  String get syncPasswordWrong => 'Sai mat khau. Vui long thu lai.';

  @override
  String get firstSyncTitle => 'Tim thay du lieu hien co';

  @override
  String get firstSyncMessage =>
      'Thiet bi nay co du lieu hien co va may chu co kho. Chung ta nen xu ly the nao?';

  @override
  String get firstSyncMerge => 'Hop nhat (may chu uu tien)';

  @override
  String get firstSyncOverwriteLocal => 'Ghi de du lieu cuc bo';

  @override
  String get firstSyncKeepLocal => 'Giu cuc bo va day len';

  @override
  String get firstSyncDeleteLocal => 'Xoa cuc bo va keo ve';

  @override
  String get changeEncryptionPassword => 'Doi mat khau ma hoa';

  @override
  String get changeEncryptionWarning =>
      'Ban se bi dang xuat tren tat ca thiet bi khac.';

  @override
  String get changeEncryptionOldPassword => 'Mat khau hien tai';

  @override
  String get changeEncryptionNewPassword => 'Mat khau moi';

  @override
  String get changeEncryptionSuccess => 'Doi mat khau thanh cong.';

  @override
  String get logoutAllDevices => 'Dang xuat khoi tat ca thiet bi';

  @override
  String get logoutAllDevicesConfirm =>
      'Dieu nay se thu hoi tat ca phien hoat dong. Ban se can dang nhap lai tren tat ca thiet bi.';

  @override
  String get logoutAllDevicesSuccess => 'Da dang xuat tat ca thiet bi.';

  @override
  String get syncSettingsTitle => 'Cai dat dong bo';

  @override
  String get syncAutoSync => 'Dong bo tu dong';

  @override
  String get syncAutoSyncDescription =>
      'Tu dong dong bo khi ung dung khoi dong';

  @override
  String get syncNow => 'Dong bo ngay';

  @override
  String get syncSyncing => 'Dang dong bo...';

  @override
  String get syncSuccess => 'Dong bo hoan tat';

  @override
  String get syncError => 'Loi dong bo';

  @override
  String get syncServerUnreachable => 'Khong the lien lac may chu';

  @override
  String get syncServerUnreachableHint =>
      'Khong the ket noi den may chu dong bo. Kiem tra ket noi internet va URL may chu.';

  @override
  String get syncNetworkError =>
      'Ket noi den may chu that bai. Vui long kiem tra ket noi internet hoac thu lai sau.';

  @override
  String get syncNeverSynced => 'Chua bao gio dong bo';

  @override
  String get syncVaultVersion => 'Phien ban kho';

  @override
  String get syncBackgroundSync => 'Đồng bộ nền';

  @override
  String get syncBackgroundSyncDescription =>
      'Đồng bộ vault định kỳ qua WorkManager ngay cả khi đóng ứng dụng.';

  @override
  String get syncTitle => 'Dong bo';

  @override
  String get settingsSectionNetwork => 'Mang va DNS';

  @override
  String get settingsDnsServers => 'May chu DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Mac dinh (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Nhap URL may chu DoH tuy chinh, phan cach bang dau phay. Can it nhat 2 may chu de xac minh cheo.';

  @override
  String get settingsDnsLabel => 'URL may chu DoH';

  @override
  String get settingsDnsReset => 'Dat lai mac dinh';

  @override
  String get settingsSectionSync => 'Dong bo';

  @override
  String get settingsSyncAccount => 'Tai khoan';

  @override
  String get settingsSyncNotLoggedIn => 'Chua dang nhap';

  @override
  String get settingsSyncStatus => 'Dong bo';

  @override
  String get settingsSyncServerUrl => 'URL may chu';

  @override
  String get settingsSyncDefaultServer => 'Mac dinh (sshvault.app)';

  @override
  String get accountTitle => 'Tai khoan';

  @override
  String get accountNotLoggedIn => 'Chua dang nhap';

  @override
  String get accountVerified => 'Da xac minh';

  @override
  String get accountMemberSince => 'Thanh vien tu';

  @override
  String get accountDevices => 'Thiet bi';

  @override
  String get accountNoDevices => 'Khong co thiet bi nao dang ky';

  @override
  String get accountLastSync => 'Dong bo cuoi';

  @override
  String get accountChangePassword => 'Doi mat khau';

  @override
  String get accountOldPassword => 'Mat khau hien tai';

  @override
  String get accountNewPassword => 'Mat khau moi';

  @override
  String get accountDeleteAccount => 'Xoa tai khoan';

  @override
  String get accountDeleteWarning =>
      'Dieu nay se xoa vinh vien tai khoan va tat ca du lieu dong bo. Khong the hoan tac.';

  @override
  String get accountLogout => 'Dang xuat';

  @override
  String get serverConfigTitle => 'Cau hinh may chu';

  @override
  String get serverConfigUrlLabel => 'URL may chu';

  @override
  String get serverConfigTest => 'Kiem tra ket noi';

  @override
  String get serverSetupTitle => 'Cài đặt máy chủ';

  @override
  String get serverSetupInfoCard =>
      'ShellVault yêu cầu máy chủ tự host để đồng bộ mã hóa đầu cuối. Triển khai phiên bản của bạn để bắt đầu.';

  @override
  String get serverSetupRepoLink => 'Xem trên GitHub';

  @override
  String get serverSetupContinue => 'Tiếp tục';

  @override
  String get settingsServerNotConfigured => 'Chưa cấu hình máy chủ';

  @override
  String get settingsSetupSync =>
      'Thiết lập đồng bộ để sao lưu dữ liệu của bạn';

  @override
  String get settingsChangeServer => 'Đổi máy chủ';

  @override
  String get settingsChangeServerConfirm =>
      'Đổi máy chủ sẽ đăng xuất bạn. Tiếp tục?';

  @override
  String get auditLogTitle => 'Nhat ky hoat dong';

  @override
  String get auditLogAll => 'Tat ca';

  @override
  String get auditLogEmpty => 'Khong tim thay nhat ky hoat dong';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Quan ly tep';

  @override
  String get sftpLocalDevice => 'Thiet bi cuc bo';

  @override
  String get sftpSelectServer => 'Chon may chu...';

  @override
  String get sftpConnecting => 'Dang ket noi...';

  @override
  String get sftpEmptyDirectory => 'Thu muc nay trong';

  @override
  String get sftpNoConnection => 'Khong co may chu ket noi';

  @override
  String get sftpPathLabel => 'Duong dan';

  @override
  String get sftpUpload => 'Tai len';

  @override
  String get sftpDownload => 'Tai xuong';

  @override
  String get sftpDelete => 'Xoa';

  @override
  String get sftpRename => 'Doi ten';

  @override
  String get sftpNewFolder => 'Thu muc moi';

  @override
  String get sftpNewFolderName => 'Ten thu muc';

  @override
  String get sftpChmod => 'Quyen';

  @override
  String get sftpChmodTitle => 'Doi quyen';

  @override
  String get sftpChmodOctal => 'Octal';

  @override
  String get sftpChmodOwner => 'Chu so huu';

  @override
  String get sftpChmodGroup => 'Nhom';

  @override
  String get sftpChmodOther => 'Khac';

  @override
  String get sftpChmodRead => 'Doc';

  @override
  String get sftpChmodWrite => 'Ghi';

  @override
  String get sftpChmodExecute => 'Thuc thi';

  @override
  String get sftpCreateSymlink => 'Tao Symlink';

  @override
  String get sftpSymlinkTarget => 'Duong dan dich';

  @override
  String get sftpSymlinkName => 'Ten lien ket';

  @override
  String get sftpFilePreview => 'Xem truoc tep';

  @override
  String get sftpFileInfo => 'Thong tin tep';

  @override
  String get sftpFileSize => 'Kich thuoc';

  @override
  String get sftpFileModified => 'Ngay sua doi';

  @override
  String get sftpFilePermissions => 'Quyen';

  @override
  String get sftpFileOwner => 'Chu so huu';

  @override
  String get sftpFileType => 'Loai';

  @override
  String get sftpFileLinkTarget => 'Dich lien ket';

  @override
  String get sftpTransfers => 'Truyen tai';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current trong $total';
  }

  @override
  String get sftpTransferQueued => 'Trong hang doi';

  @override
  String get sftpTransferActive => 'Dang truyen...';

  @override
  String get sftpTransferPaused => 'Tam dung';

  @override
  String get sftpTransferCompleted => 'Hoan tat';

  @override
  String get sftpTransferFailed => 'That bai';

  @override
  String get sftpTransferCancelled => 'Da huy';

  @override
  String get sftpPauseTransfer => 'Tam dung';

  @override
  String get sftpResumeTransfer => 'Tiep tuc';

  @override
  String get sftpCancelTransfer => 'Huy';

  @override
  String get sftpClearCompleted => 'Xoa da hoan tat';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active trong $total truyen tai';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dang hoat dong',
      one: '1 dang hoat dong',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hoan tat',
      one: '1 hoan tat',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count that bai',
      one: '1 that bai',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Sao chep sang khung khac';

  @override
  String sftpConfirmDelete(int count) {
    return 'Xoa $count muc?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Xoa \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Xoa thanh cong';

  @override
  String get sftpRenameTitle => 'Doi ten';

  @override
  String get sftpRenameLabel => 'Ten moi';

  @override
  String get sftpSortByName => 'Ten';

  @override
  String get sftpSortBySize => 'Kich thuoc';

  @override
  String get sftpSortByDate => 'Ngay';

  @override
  String get sftpSortByType => 'Loai';

  @override
  String get sftpShowHidden => 'Hien thi tep an';

  @override
  String get sftpHideHidden => 'An tep an';

  @override
  String get sftpSelectAll => 'Chon tat ca';

  @override
  String get sftpDeselectAll => 'Bo chon tat ca';

  @override
  String sftpItemsSelected(int count) {
    return 'Da chon $count';
  }

  @override
  String get sftpRefresh => 'Lam moi';

  @override
  String sftpConnectionError(String message) {
    return 'Ket noi that bai: $message';
  }

  @override
  String get sftpPermissionDenied => 'Truy cap bi tu choi';

  @override
  String sftpOperationFailed(String message) {
    return 'Thao tac that bai: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Tep da ton tai';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" da ton tai. Ghi de?';
  }

  @override
  String get sftpOverwrite => 'Ghi de';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Bat dau truyen: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'Chon dich den trong khung khac truoc';

  @override
  String get sftpDirectoryTransferNotSupported => 'Truyen thu muc se som co';

  @override
  String get sftpSelect => 'Chon';

  @override
  String get sftpOpen => 'Mo';

  @override
  String get sftpExtractArchive => 'Giai nen tai day';

  @override
  String get sftpExtractSuccess => 'Da giai nen';

  @override
  String sftpExtractFailed(String message) {
    return 'Giai nen that bai: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Dinh dang nen khong duoc ho tro';

  @override
  String get sftpExtracting => 'Dang giai nen...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bat dau $count tai len',
      one: 'Bat dau tai len',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bat dau $count tai xuong',
      one: 'Bat dau tai xuong',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return 'Da tai \"$fileName\"';
  }

  @override
  String get sftpSavedToDownloads => 'Da luu vao Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Luu vao Tep';

  @override
  String get sftpFileSaved => 'Da luu tep';

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
      other: '$count phien SSH dang hoat dong',
      one: 'Phien SSH dang hoat dong',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Cham de mo terminal';

  @override
  String get settingsAccountAndSync => 'Tai khoan va dong bo';

  @override
  String get settingsAccountSubtitleAuth => 'Da dang nhap';

  @override
  String get settingsAccountSubtitleUnauth => 'Chua dang nhap';

  @override
  String get settingsSecuritySubtitle => 'Tu dong khoa, Sinh trac hoc, PIN';

  @override
  String get settingsSshSubtitle => 'Cong 22, Nguoi dung root';

  @override
  String get settingsAppearanceSubtitle => 'Giao dien, Ngon ngu, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Mac dinh xuat ma hoa';

  @override
  String get settingsAboutSubtitle => 'Phien ban, Giay phep';

  @override
  String get settingsSearchHint => 'Tim kiem cai dat...';

  @override
  String get settingsSearchNoResults => 'Khong tim thay cai dat';

  @override
  String get aboutDeveloper => 'Phat trien boi Kiefer Networks';

  @override
  String get aboutDonate => 'Quyen gop';

  @override
  String get aboutOpenSourceLicenses => 'Giay phep ma nguon mo';

  @override
  String get aboutWebsite => 'Trang web';

  @override
  String get aboutVersion => 'Phien ban';

  @override
  String get aboutBuild => 'Ban dung';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS ma hoa truy van DNS va ngan chan gia mao DNS. SSHVault kiem tra ten may chu voi nhieu nha cung cap de phat hien tan cong.';

  @override
  String get settingsDnsAddServer => 'Them may chu DNS';

  @override
  String get settingsDnsServerUrl => 'URL may chu';

  @override
  String get settingsDnsDefaultBadge => 'Mac dinh';

  @override
  String get settingsDnsResetDefaults => 'Dat lai mac dinh';

  @override
  String get settingsDnsInvalidUrl => 'Vui long nhap URL HTTPS hop le';

  @override
  String get settingsDefaultAuthMethod => 'Phuong thuc xac thuc';

  @override
  String get settingsAuthPassword => 'Mat khau';

  @override
  String get settingsAuthKey => 'Khoa SSH';

  @override
  String get settingsConnectionTimeout => 'Thoi gian cho ket noi';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Khoang thoi gian Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Nen';

  @override
  String get settingsCompressionDescription => 'Bat nen zlib cho ket noi SSH';

  @override
  String get settingsTerminalType => 'Loai terminal';

  @override
  String get settingsSectionConnection => 'Ket noi';

  @override
  String get settingsClipboardAutoClear => 'Tu dong xoa clipboard';

  @override
  String get settingsClipboardAutoClearOff => 'Tat';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Het phien';

  @override
  String get settingsSessionTimeoutOff => 'Tat';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes phut';
  }

  @override
  String get settingsDuressPin => 'PIN cuong buc';

  @override
  String get settingsDuressPinDescription =>
      'PIN rieng se xoa tat ca du lieu khi nhap';

  @override
  String get settingsDuressPinSet => 'Da dat PIN cuong buc';

  @override
  String get settingsDuressPinNotSet => 'Chua cau hinh';

  @override
  String get settingsDuressPinWarning =>
      'Nhap PIN nay se xoa vinh vien tat ca du lieu cuc bo bao gom thong tin dang nhap, khoa va cai dat. Khong the hoan tac.';

  @override
  String get settingsKeyRotationReminder => 'Nhac nho xoay khoa';

  @override
  String get settingsKeyRotationOff => 'Tat';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days ngay';
  }

  @override
  String get settingsFailedAttempts => 'So lan nhap PIN that bai';

  @override
  String get settingsSectionAppLock => 'Khoa ung dung';

  @override
  String get settingsSectionPrivacy => 'Quyen rieng tu';

  @override
  String get settingsSectionReminders => 'Nhac nho';

  @override
  String get settingsSectionStatus => 'Trang thai';

  @override
  String get settingsExportBackupSubtitle => 'Xuat, Nhap va Sao luu';

  @override
  String get settingsExportJson => 'Xuat dang JSON';

  @override
  String get settingsExportEncrypted => 'Xuat ma hoa';

  @override
  String get settingsImportFile => 'Nhap tu tep';

  @override
  String get settingsSectionImport => 'Nhap';

  @override
  String get filterTitle => 'Loc may chu';

  @override
  String get filterApply => 'Ap dung bo loc';

  @override
  String get filterClearAll => 'Xoa tat ca';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bo loc dang hoat dong',
      one: '1 bo loc dang hoat dong',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Thu muc';

  @override
  String get filterTags => 'Nhan';

  @override
  String get filterStatus => 'Trang thai';

  @override
  String get variablePreviewResolved => 'Xem truoc da giai quyet';

  @override
  String get variableInsert => 'Chen';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count may chu',
      one: '1 may chu',
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
      other: 'Da thu hoi $count phien.',
      one: 'Da thu hoi 1 phien.',
    );
    return '$_temp0 Ban da bi dang xuat.';
  }

  @override
  String get keyGenPassphrase => 'Cum tu mat khau';

  @override
  String get keyGenPassphraseHint => 'Tuy chon — bao ve khoa rieng tu';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Mac dinh (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Khoa co cung van tay da ton tai: \"$name\". Moi khoa SSH phai la duy nhat.';
  }

  @override
  String get sshKeyFingerprint => 'Van tay';

  @override
  String get sshKeyPublicKey => 'Khoa cong khai';

  @override
  String get jumpHost => 'May chu trung gian';

  @override
  String get jumpHostNone => 'Khong co';

  @override
  String get jumpHostLabel => 'Ket noi qua may chu trung gian';

  @override
  String get jumpHostSelfError =>
      'May chu khong the la may chu trung gian cua chinh no';

  @override
  String get jumpHostConnecting => 'Dang ket noi den may chu trung gian...';

  @override
  String get jumpHostCircularError => 'Phat hien chuoi may chu trung gian vong';

  @override
  String get logoutDialogTitle => 'Dang xuat';

  @override
  String get logoutDialogMessage =>
      'Ban co muon xoa tat ca du lieu cuc bo? May chu, khoa SSH, doan ma va cai dat se bi xoa khoi thiet bi nay.';

  @override
  String get logoutOnly => 'Chi dang xuat';

  @override
  String get logoutAndDelete => 'Dang xuat va xoa du lieu';

  @override
  String get changeAvatar => 'Doi anh dai dien';

  @override
  String get removeAvatar => 'Xoa anh dai dien';

  @override
  String get avatarUploadFailed => 'Tai anh dai dien that bai';

  @override
  String get avatarTooLarge => 'Anh qua lon';

  @override
  String get deviceLastSeen => 'Lan cuoi thay';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Khong the thay doi URL may chu khi dang dang nhap. Dang xuat truoc.';

  @override
  String get serverListNoFolder => 'Chua phan loai';

  @override
  String get autoSyncInterval => 'Khoang thoi gian dong bo';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes phut';
  }

  @override
  String get proxySettings => 'Cai dat proxy';

  @override
  String get proxyType => 'Loai proxy';

  @override
  String get proxyNone => 'Khong co proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'May chu proxy';

  @override
  String get proxyPort => 'Cong proxy';

  @override
  String get proxyUsername => 'Ten nguoi dung proxy';

  @override
  String get proxyPassword => 'Mat khau proxy';

  @override
  String get proxyUseGlobal => 'Su dung proxy toan cuc';

  @override
  String get proxyGlobal => 'Toan cuc';

  @override
  String get proxyServerSpecific => 'Rieng may chu';

  @override
  String get proxyTestConnection => 'Kiem tra ket noi';

  @override
  String get proxyTestSuccess => 'Proxy co the truy cap';

  @override
  String get proxyTestFailed => 'Khong the truy cap proxy';

  @override
  String get proxyDefaultProxy => 'Proxy mac dinh';

  @override
  String get vpnRequired => 'Yeu cau VPN';

  @override
  String get vpnRequiredTooltip =>
      'Hien thi canh bao khi ket noi ma khong co VPN hoat dong';

  @override
  String get vpnActive => 'VPN hoat dong';

  @override
  String get vpnInactive => 'VPN khong hoat dong';

  @override
  String get vpnWarningTitle => 'VPN khong hoat dong';

  @override
  String get vpnWarningMessage =>
      'May chu nay yeu cau ket noi VPN, nhung hien tai khong co VPN hoat dong. Ban co muon ket noi khong?';

  @override
  String get vpnConnectAnyway => 'Ket noi du sao';

  @override
  String get postConnectCommands => 'Lenh sau ket noi';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Lenh duoc thuc thi tu dong sau khi ket noi (moi dong mot lenh)';

  @override
  String get dashboardFavorites => 'Yeu thich';

  @override
  String get dashboardRecent => 'Gan day';

  @override
  String get dashboardActiveSessions => 'Phien hoat dong';

  @override
  String get addToFavorites => 'Them vao yeu thich';

  @override
  String get removeFromFavorites => 'Xoa khoi yeu thich';

  @override
  String get noRecentConnections => 'Khong co ket noi gan day';

  @override
  String get terminalSplit => 'Chia man hinh';

  @override
  String get terminalUnsplit => 'Dong chia man hinh';

  @override
  String get terminalSelectSession => 'Chon phien cho che do chia man hinh';

  @override
  String get knownHostsTitle => 'May chu da biet';

  @override
  String get knownHostsSubtitle => 'Quan ly van tay may chu dang tin cay';

  @override
  String get hostKeyNewTitle => 'May chu moi';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Ket noi dau tien den $hostname:$port. Xac minh van tay truoc khi ket noi.';
  }

  @override
  String get hostKeyChangedTitle => 'Khoa may chu da thay doi!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Khoa may chu cho $hostname:$port da thay doi. Dieu nay co the cho thay moi de doa bao mat.';
  }

  @override
  String get hostKeyFingerprint => 'Van tay';

  @override
  String get hostKeyType => 'Loai khoa';

  @override
  String get hostKeyTrustConnect => 'Tin tuong va ket noi';

  @override
  String get hostKeyAcceptNew => 'Chap nhan khoa moi';

  @override
  String get hostKeyReject => 'Tu choi';

  @override
  String get hostKeyPreviousFingerprint => 'Van tay truoc do';

  @override
  String get hostKeyDeleteAll => 'Xoa tat ca may chu da biet';

  @override
  String get hostKeyDeleteConfirm =>
      'Ban co chac chan muon xoa tat ca may chu da biet? Ban se duoc hoi lai khi ket noi lan sau.';

  @override
  String get hostKeyEmpty => 'Chua co may chu da biet nao';

  @override
  String get hostKeyEmptySubtitle =>
      'Van tay may chu se duoc luu o day sau lan ket noi dau tien';

  @override
  String get hostKeyFirstSeen => 'Lan dau thay';

  @override
  String get hostKeyLastSeen => 'Lan cuoi thay';

  @override
  String get sshConfigImportTitle => 'Nhap cau hinh SSH';

  @override
  String get sshConfigImportPickFile => 'Chon tep cau hinh SSH';

  @override
  String get sshConfigImportOrPaste => 'Hoac dan noi dung cau hinh';

  @override
  String sshConfigImportParsed(int count) {
    return 'Tim thay $count may chu';
  }

  @override
  String get sshConfigImportButton => 'Nhap';

  @override
  String sshConfigImportSuccess(int count) {
    return 'Da nhap $count may chu';
  }

  @override
  String get sshConfigImportDuplicate => 'Da ton tai';

  @override
  String get sshConfigImportNoHosts => 'Khong tim thay may chu trong cau hinh';

  @override
  String get sftpBookmarkAdd => 'Them danh dau';

  @override
  String get sftpBookmarkLabel => 'Nhan';

  @override
  String get disconnect => 'Ngat ket noi';

  @override
  String get reportAndDisconnect => 'Bao cao va ngat ket noi';

  @override
  String get continueAnyway => 'Tiep tuc du sao';

  @override
  String get insertSnippet => 'Chen doan ma';

  @override
  String get seconds => 'Giay';

  @override
  String get heartbeatLostMessage =>
      'Khong the lien lac may chu sau nhieu lan thu. De bao mat cho ban, phien da bi cham dut.';

  @override
  String get attestationFailedTitle => 'Xac minh may chu that bai';

  @override
  String get attestationFailedMessage =>
      'Khong the xac minh may chu la backend SSHVault hop le. Dieu nay co the cho thay tan cong man-in-the-middle hoac may chu cau hinh sai.';

  @override
  String get attestationKeyChangedTitle =>
      'Khoa chung thuc may chu da thay doi';

  @override
  String get attestationKeyChangedMessage =>
      'Khoa chung thuc cua may chu da thay doi ke tu lan ket noi dau tien. Dieu nay co the cho thay tan cong man-in-the-middle. KHONG tiep tuc tru khi quan tri vien may chu da xac nhan viec xoay khoa.';

  @override
  String get sectionLinks => 'Lien ket';

  @override
  String get sectionDeveloper => 'Nha phat trien';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Khong tim thay trang';

  @override
  String get connectionTestSuccess => 'Ket noi thanh cong';

  @override
  String connectionTestFailed(String message) {
    return 'Ket noi that bai: $message';
  }

  @override
  String get serverVerificationFailed => 'Xac minh may chu that bai';

  @override
  String get importSuccessful => 'Nhap thanh cong';

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
  String get deviceDeleteConfirmTitle => 'Xóa thiết bị';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Bạn có chắc muốn xóa \"$name\"? Thiết bị sẽ bị đăng xuất ngay lập tức.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Đây là thiết bị hiện tại của bạn. Bạn sẽ bị đăng xuất ngay lập tức.';

  @override
  String get deviceDeleteSuccess => 'Đã xóa thiết bị';

  @override
  String get deviceDeletedCurrentLogout =>
      'Đã xóa thiết bị hiện tại. Bạn đã được đăng xuất.';

  @override
  String get thisDevice => 'Thiết bị này';
}
