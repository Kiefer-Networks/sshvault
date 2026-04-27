// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => '호스트';

  @override
  String get navSnippets => '스니펫';

  @override
  String get navFolders => '폴더';

  @override
  String get navTags => '태그';

  @override
  String get navSshKeys => 'SSH 키';

  @override
  String get navExportImport => '내보내기 / 가져오기';

  @override
  String get navTerminal => '터미널';

  @override
  String get navMore => '더 보기';

  @override
  String get navManagement => '관리';

  @override
  String get navSettings => '설정';

  @override
  String get navAbout => 'SSHVault 정보';

  @override
  String get lockScreenTitle => 'SSHVault가 잠겨 있습니다';

  @override
  String get lockScreenUnlock => '잠금 해제';

  @override
  String get lockScreenEnterPin => 'PIN 입력';

  @override
  String lockScreenLockedOut(int minutes) {
    return '시도 횟수가 너무 많습니다. $minutes분 후에 다시 시도하세요.';
  }

  @override
  String get pinDialogSetTitle => 'PIN 코드 설정';

  @override
  String get pinDialogSetSubtitle => 'SSHVault를 보호할 6자리 PIN을 입력하세요';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'PIN 확인';

  @override
  String get pinDialogErrorLength => 'PIN은 정확히 6자리여야 합니다';

  @override
  String get pinDialogErrorMismatch => 'PIN이 일치하지 않습니다';

  @override
  String get pinDialogVerifyTitle => 'PIN 입력';

  @override
  String pinDialogWrongPin(int attempts) {
    return '잘못된 PIN입니다. $attempts회 시도 남음.';
  }

  @override
  String get securityBannerMessage =>
      'SSH 자격 증명이 보호되지 않고 있습니다. 설정에서 PIN 또는 생체 인식 잠금을 설정하세요.';

  @override
  String get securityBannerDismiss => '닫기';

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsSectionAppearance => '외관';

  @override
  String get settingsSectionTerminal => '터미널';

  @override
  String get settingsSectionSshDefaults => 'SSH 기본값';

  @override
  String get settingsSectionSecurity => '보안';

  @override
  String get settingsSectionExport => '내보내기';

  @override
  String get settingsSectionAbout => 'SSHVault 정보';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsThemeSystem => '시스템';

  @override
  String get settingsThemeLight => '라이트';

  @override
  String get settingsThemeDark => '다크';

  @override
  String get settingsTerminalTheme => '터미널 테마';

  @override
  String get settingsTerminalThemeDefault => '기본 다크';

  @override
  String get settingsFontSize => '글꼴 크기';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => '기본 포트';

  @override
  String get settingsDefaultPortDialog => '기본 SSH 포트';

  @override
  String get settingsPortLabel => '포트';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => '기본 사용자 이름';

  @override
  String get settingsDefaultUsernameDialog => '기본 사용자 이름';

  @override
  String get settingsUsernameLabel => '사용자 이름';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => '자동 잠금 시간';

  @override
  String get settingsAutoLockDisabled => '비활성화';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get settingsAutoLockOff => '끄기';

  @override
  String get settingsAutoLock1Min => '1분';

  @override
  String get settingsAutoLock5Min => '5분';

  @override
  String get settingsAutoLock15Min => '15분';

  @override
  String get settingsAutoLock30Min => '30분';

  @override
  String get settingsBiometricUnlock => '생체 인식 잠금 해제';

  @override
  String get settingsBiometricNotAvailable => '이 기기에서는 사용할 수 없습니다';

  @override
  String get settingsBiometricError => '생체 인식 확인 중 오류 발생';

  @override
  String get settingsBiometricReason => '생체 인식 잠금 해제를 활성화하기 위해 본인 확인을 합니다';

  @override
  String get settingsBiometricRequiresPin =>
      '생체 인식 잠금 해제를 활성화하려면 먼저 PIN을 설정하세요';

  @override
  String get settingsPinCode => 'PIN 코드';

  @override
  String get settingsPinIsSet => 'PIN 설정됨';

  @override
  String get settingsPinNotConfigured => 'PIN 미설정';

  @override
  String get settingsPinRemove => '제거';

  @override
  String get settingsPinRemoveWarning =>
      'PIN을 제거하면 모든 데이터베이스 필드가 복호화되고 생체 인식 잠금 해제가 비활성화됩니다. 계속하시겠습니까?';

  @override
  String get settingsPinRemoveTitle => 'PIN 제거';

  @override
  String get settingsPreventScreenshots => '스크린샷 방지';

  @override
  String get settingsPreventScreenshotsDescription => '스크린샷 및 화면 녹화 차단';

  @override
  String get settingsEncryptExport => '기본으로 내보내기 암호화';

  @override
  String get settingsAbout => 'SSHVault 정보';

  @override
  String get settingsAboutLegalese => 'Kiefer Networks 제공';

  @override
  String get settingsAboutDescription => '안전한 셀프 호스트 SSH 클라이언트';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '시스템';

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
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get close => '닫기';

  @override
  String get update => '업데이트';

  @override
  String get create => '생성';

  @override
  String get retry => '재시도';

  @override
  String get copy => '복사';

  @override
  String get edit => '편집';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return '오류: $message';
  }

  @override
  String get serverListTitle => '호스트';

  @override
  String get serverListEmpty => '서버가 아직 없습니다';

  @override
  String get serverListEmptySubtitle => '첫 번째 SSH 서버를 추가하여 시작하세요.';

  @override
  String get serverAddButton => '서버 추가';

  @override
  String sshConfigImportMessage(int count) {
    return '~/.ssh/config에서 $count개의 호스트를 찾았습니다. 가져오시겠습니까?';
  }

  @override
  String get sshConfigNotFound => 'SSH 설정 파일을 찾을 수 없습니다';

  @override
  String get sshConfigEmpty => 'SSH 설정에서 호스트를 찾을 수 없습니다';

  @override
  String get sshConfigAddManually => '수동으로 추가';

  @override
  String get sshConfigImportAgain => 'SSH 설정을 다시 가져오시겠습니까?';

  @override
  String get sshConfigImportKeys => '선택한 호스트에서 참조하는 SSH 키를 가져오시겠습니까?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count개의 SSH 키를 가져왔습니다';
  }

  @override
  String get serverDuplicated => '서버가 복제되었습니다';

  @override
  String get serverDeleteTitle => '서버 삭제';

  @override
  String serverDeleteMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String serverDeleteShort(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get serverConnect => '연결';

  @override
  String get serverDetails => '상세 정보';

  @override
  String get serverDuplicate => '복제';

  @override
  String get serverActive => '활성';

  @override
  String get serverNoFolder => '폴더 없음';

  @override
  String get serverFormTitleEdit => '서버 편집';

  @override
  String get serverFormTitleAdd => '서버 추가';

  @override
  String get serverSaved => '서버 저장됨';

  @override
  String get serverFormUpdateButton => '서버 업데이트';

  @override
  String get serverFormAddButton => '서버 추가';

  @override
  String get serverFormPublicKeyExtracted => '공개 키 추출 성공';

  @override
  String serverFormPublicKeyError(String message) {
    return '공개 키를 추출할 수 없습니다: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type 키 쌍이 생성되었습니다';
  }

  @override
  String get serverDetailTitle => '서버 상세 정보';

  @override
  String get serverDetailDeleteMessage => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get serverDetailConnection => '연결';

  @override
  String get serverDetailHost => '호스트';

  @override
  String get serverDetailPort => '포트';

  @override
  String get serverDetailUsername => '사용자 이름';

  @override
  String get serverDetailFolder => '폴더';

  @override
  String get serverDetailTags => '태그';

  @override
  String get serverDetailNotes => '메모';

  @override
  String get serverDetailInfo => '정보';

  @override
  String get serverDetailCreated => '생성일';

  @override
  String get serverDetailUpdated => '수정일';

  @override
  String get serverDetailDistro => '시스템';

  @override
  String get copiedToClipboard => '클립보드에 복사되었습니다';

  @override
  String get serverFormNameLabel => '서버 이름';

  @override
  String get serverFormHostnameLabel => '호스트 이름 / IP';

  @override
  String get serverFormPortLabel => '포트';

  @override
  String get serverFormUsernameLabel => '사용자 이름';

  @override
  String get serverFormPasswordLabel => '비밀번호';

  @override
  String get serverFormUseManagedKey => '관리 키 사용';

  @override
  String get serverFormManagedKeySubtitle => '중앙 관리되는 SSH 키에서 선택';

  @override
  String get serverFormDirectKeySubtitle => '이 서버에 직접 키 붙여넣기';

  @override
  String get serverFormGenerateKey => 'SSH 키 쌍 생성';

  @override
  String get serverFormPrivateKeyLabel => '개인 키';

  @override
  String get serverFormPrivateKeyHint => 'SSH 개인 키를 붙여넣으세요...';

  @override
  String get serverFormExtractPublicKey => '공개 키 추출';

  @override
  String get serverFormPublicKeyLabel => '공개 키';

  @override
  String get serverFormPublicKeyHint => '비어 있으면 개인 키에서 자동 생성';

  @override
  String get serverFormPassphraseLabel => '키 암호 (선택사항)';

  @override
  String get serverFormNotesLabel => '메모 (선택사항)';

  @override
  String get searchServers => '서버 검색...';

  @override
  String get filterAllFolders => '모든 폴더';

  @override
  String get filterAll => '전체';

  @override
  String get filterActive => '활성';

  @override
  String get filterInactive => '비활성';

  @override
  String get filterClear => '지우기';

  @override
  String get folderListTitle => '폴더';

  @override
  String get folderListEmpty => '폴더가 아직 없습니다';

  @override
  String get folderListEmptySubtitle => '폴더를 만들어 서버를 정리하세요.';

  @override
  String get folderAddButton => '폴더 추가';

  @override
  String get folderDeleteTitle => '폴더 삭제';

  @override
  String folderDeleteMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 서버가 미분류됩니다.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '서버 $count개',
      one: '서버 1개',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => '접기';

  @override
  String get folderShowHosts => '호스트 표시';

  @override
  String get folderConnectAll => '모두 연결';

  @override
  String get folderFormTitleEdit => '폴더 편집';

  @override
  String get folderFormTitleNew => '새 폴더';

  @override
  String get folderFormNameLabel => '폴더 이름';

  @override
  String get folderFormParentLabel => '상위 폴더';

  @override
  String get folderFormParentNone => '없음 (루트)';

  @override
  String get tagListTitle => '태그';

  @override
  String get tagListEmpty => '태그가 아직 없습니다';

  @override
  String get tagListEmptySubtitle => '태그를 만들어 서버에 라벨을 붙이고 필터링하세요.';

  @override
  String get tagAddButton => '태그 추가';

  @override
  String get tagDeleteTitle => '태그 삭제';

  @override
  String tagDeleteMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 모든 서버에서 제거됩니다.';
  }

  @override
  String get tagFormTitleEdit => '태그 편집';

  @override
  String get tagFormTitleNew => '새 태그';

  @override
  String get tagFormNameLabel => '태그 이름';

  @override
  String get sshKeyListTitle => 'SSH 키';

  @override
  String get sshKeyListEmpty => 'SSH 키가 아직 없습니다';

  @override
  String get sshKeyListEmptySubtitle => 'SSH 키를 생성하거나 가져와서 중앙에서 관리하세요';

  @override
  String get sshKeyCannotDeleteTitle => '삭제할 수 없음';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return '\"$name\"을(를) 삭제할 수 없습니다. $count개의 서버에서 사용 중입니다. 먼저 모든 서버에서 연결을 해제하세요.';
  }

  @override
  String get sshKeyDeleteTitle => 'SSH 키 삭제';

  @override
  String sshKeyDeleteMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get sshKeyAddButton => 'SSH 키 추가';

  @override
  String get sshKeyFormTitleEdit => 'SSH 키 편집';

  @override
  String get sshKeyFormTitleAdd => 'SSH 키 추가';

  @override
  String get sshKeyFormTabGenerate => '생성';

  @override
  String get sshKeyFormTabImport => '가져오기';

  @override
  String get sshKeyFormNameLabel => '키 이름';

  @override
  String get sshKeyFormNameHint => '예: 프로덕션 키';

  @override
  String get sshKeyFormKeyType => '키 유형';

  @override
  String get sshKeyFormKeySize => '키 크기';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits비트';
  }

  @override
  String get sshKeyFormCommentLabel => '코멘트';

  @override
  String get sshKeyFormCommentHint => 'user@host 또는 설명';

  @override
  String get sshKeyFormCommentOptional => '코멘트 (선택사항)';

  @override
  String get sshKeyFormImportFromFile => '파일에서 가져오기';

  @override
  String get sshKeyFormPrivateKeyLabel => '개인 키';

  @override
  String get sshKeyFormPrivateKeyHint => 'SSH 개인 키를 붙여넣거나 위 버튼을 사용하세요...';

  @override
  String get sshKeyFormPassphraseLabel => '암호 (선택사항)';

  @override
  String get sshKeyFormNameRequired => '이름은 필수입니다';

  @override
  String get sshKeyFormPrivateKeyRequired => '개인 키는 필수입니다';

  @override
  String get sshKeyFormFileReadError => '선택한 파일을 읽을 수 없습니다';

  @override
  String get sshKeyFormInvalidFormat =>
      '잘못된 키 파일 — PEM 형식이 필요합니다 (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return '파일 읽기 실패: $message';
  }

  @override
  String get sshKeyFormSaving => '저장 중...';

  @override
  String get sshKeySelectorLabel => 'SSH 키';

  @override
  String get sshKeySelectorNone => '관리 키 없음';

  @override
  String get sshKeySelectorManage => '키 관리...';

  @override
  String get sshKeySelectorError => 'SSH 키를 불러오지 못했습니다';

  @override
  String get sshKeyTileCopyPublicKey => '공개 키 복사';

  @override
  String get sshKeyTilePublicKeyCopied => '공개 키가 복사되었습니다';

  @override
  String sshKeyTileLinkedServers(int count) {
    return '$count개의 서버에서 사용 중';
  }

  @override
  String get sshKeySavedSuccess => 'SSH 키 저장됨';

  @override
  String get sshKeyDeletedSuccess => 'SSH 키 삭제됨';

  @override
  String get tagSavedSuccess => '태그 저장됨';

  @override
  String get tagDeletedSuccess => '태그 삭제됨';

  @override
  String get folderDeletedSuccess => '폴더 삭제됨';

  @override
  String get sshKeyTileUnlinkFirst => '먼저 모든 서버에서 연결을 해제하세요';

  @override
  String get exportImportTitle => '내보내기 / 가져오기';

  @override
  String get exportSectionTitle => '내보내기';

  @override
  String get exportJsonButton => 'JSON으로 내보내기 (자격 증명 제외)';

  @override
  String get exportZipButton => '암호화 ZIP으로 내보내기 (자격 증명 포함)';

  @override
  String get importSectionTitle => '가져오기';

  @override
  String get importButton => '파일에서 가져오기';

  @override
  String get importSupportedFormats => 'JSON (일반) 및 ZIP (암호화) 파일을 지원합니다.';

  @override
  String exportedTo(String path) {
    return '내보내기 위치: $path';
  }

  @override
  String get share => '공유';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '서버 $servers개, 그룹 $groups개, 태그 $tags개를 가져왔습니다. $skipped개 건너뜀.';
  }

  @override
  String get importPasswordTitle => '비밀번호 입력';

  @override
  String get importPasswordLabel => '내보내기 비밀번호';

  @override
  String get importPasswordDecrypt => '복호화';

  @override
  String get exportPasswordTitle => '내보내기 비밀번호 설정';

  @override
  String get exportPasswordDescription =>
      '이 비밀번호는 자격 증명을 포함한 내보내기 파일을 암호화하는 데 사용됩니다.';

  @override
  String get exportPasswordLabel => '비밀번호';

  @override
  String get exportPasswordConfirmLabel => '비밀번호 확인';

  @override
  String get exportPasswordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get exportPasswordButton => '암호화 및 내보내기';

  @override
  String get importConflictTitle => '충돌 처리';

  @override
  String get importConflictDescription => '가져오기 중 기존 항목을 어떻게 처리하시겠습니까?';

  @override
  String get importConflictSkip => '기존 항목 건너뛰기';

  @override
  String get importConflictRename => '새 항목 이름 변경';

  @override
  String get importConflictOverwrite => '덮어쓰기';

  @override
  String get confirmDeleteLabel => '삭제';

  @override
  String get keyGenTitle => 'SSH 키 쌍 생성';

  @override
  String get keyGenKeyType => '키 유형';

  @override
  String get keyGenKeySize => '키 크기';

  @override
  String get keyGenComment => '코멘트';

  @override
  String get keyGenCommentHint => 'user@host 또는 설명';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits비트';
  }

  @override
  String get keyGenGenerating => '생성 중...';

  @override
  String get keyGenGenerate => '생성';

  @override
  String keyGenResultTitle(String type) {
    return '$type 키가 생성되었습니다';
  }

  @override
  String get keyGenPublicKey => '공개 키';

  @override
  String get keyGenPrivateKey => '개인 키';

  @override
  String keyGenCommentInfo(String comment) {
    return '코멘트: $comment';
  }

  @override
  String get keyGenAnother => '다른 키 생성';

  @override
  String get keyGenUseThisKey => '이 키 사용';

  @override
  String get keyGenCopyTooltip => '클립보드에 복사';

  @override
  String keyGenCopied(String label) {
    return '$label 복사됨';
  }

  @override
  String get colorPickerLabel => '색상';

  @override
  String get iconPickerLabel => '아이콘';

  @override
  String get tagSelectorLabel => '태그';

  @override
  String get tagSelectorEmpty => '태그가 아직 없습니다';

  @override
  String get tagSelectorError => '태그를 불러오지 못했습니다';

  @override
  String get snippetListTitle => '스니펫';

  @override
  String get snippetSearchHint => '스니펫 검색...';

  @override
  String get snippetListEmpty => '스니펫이 아직 없습니다';

  @override
  String get snippetListEmptySubtitle => '재사용 가능한 코드 스니펫과 명령을 만드세요.';

  @override
  String get snippetAddButton => '스니펫 추가';

  @override
  String get snippetDeleteTitle => '스니펫 삭제';

  @override
  String snippetDeleteMessage(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get snippetFormTitleEdit => '스니펫 편집';

  @override
  String get snippetFormTitleNew => '새 스니펫';

  @override
  String get snippetFormNameLabel => '이름';

  @override
  String get snippetFormNameHint => '예: Docker 정리';

  @override
  String get snippetFormLanguageLabel => '언어';

  @override
  String get snippetFormContentLabel => '내용';

  @override
  String get snippetFormContentHint => '스니펫 코드를 입력하세요...';

  @override
  String get snippetFormDescriptionLabel => '설명';

  @override
  String get snippetFormDescriptionHint => '선택사항 설명...';

  @override
  String get snippetFormFolderLabel => '폴더';

  @override
  String get snippetFormNoFolder => '폴더 없음';

  @override
  String get snippetFormNameRequired => '이름은 필수입니다';

  @override
  String get snippetFormContentRequired => '내용은 필수입니다';

  @override
  String get snippetFormSaved => '스니펫이 저장되었습니다';

  @override
  String get snippetFormUpdateButton => '스니펫 업데이트';

  @override
  String get snippetFormCreateButton => '스니펫 생성';

  @override
  String get snippetDetailTitle => '스니펫 상세 정보';

  @override
  String get snippetDetailDeleteTitle => '스니펫 삭제';

  @override
  String get snippetDetailDeleteMessage => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get snippetDetailContent => '내용';

  @override
  String get snippetDetailFillVariables => '변수 입력';

  @override
  String get snippetDetailDescription => '설명';

  @override
  String get snippetDetailVariables => '변수';

  @override
  String get snippetDetailTags => '태그';

  @override
  String get snippetDetailInfo => '정보';

  @override
  String get snippetDetailCreated => '생성일';

  @override
  String get snippetDetailUpdated => '수정일';

  @override
  String get variableEditorTitle => '템플릿 변수';

  @override
  String get variableEditorAdd => '추가';

  @override
  String get variableEditorEmpty => '변수가 없습니다. 내용에서 중괄호 구문을 사용하여 참조하세요.';

  @override
  String get variableEditorNameLabel => '이름';

  @override
  String get variableEditorNameHint => '예: hostname';

  @override
  String get variableEditorDefaultLabel => '기본값';

  @override
  String get variableEditorDefaultHint => '선택사항';

  @override
  String get variableFillTitle => '변수 입력';

  @override
  String variableFillHint(String name) {
    return '$name의 값을 입력하세요';
  }

  @override
  String get variableFillPreview => '미리보기';

  @override
  String get terminalTitle => '터미널';

  @override
  String get terminalEmpty => '활성 세션이 없습니다';

  @override
  String get terminalEmptySubtitle => '호스트에 연결하여 터미널 세션을 여세요.';

  @override
  String get terminalGoToHosts => '호스트로 이동';

  @override
  String get terminalCloseAll => '모든 세션 닫기';

  @override
  String get terminalCloseTitle => '세션 닫기';

  @override
  String terminalCloseMessage(String title) {
    return '\"$title\"에 대한 활성 연결을 닫으시겠습니까?';
  }

  @override
  String get connectionAuthenticating => '인증 중...';

  @override
  String connectionConnecting(String name) {
    return '$name에 연결 중...';
  }

  @override
  String get connectionError => '연결 오류';

  @override
  String get connectionLost => '연결이 끊어졌습니다';

  @override
  String get connectionReconnect => '재연결';

  @override
  String get snippetQuickPanelTitle => '스니펫 삽입';

  @override
  String get snippetQuickPanelSearch => '스니펫 검색...';

  @override
  String get snippetQuickPanelEmpty => '사용 가능한 스니펫이 없습니다';

  @override
  String get snippetQuickPanelNoMatch => '일치하는 스니펫이 없습니다';

  @override
  String get snippetQuickPanelInsertTooltip => '스니펫 삽입';

  @override
  String get terminalThemePickerTitle => '터미널 테마';

  @override
  String get validatorHostnameRequired => '호스트 이름은 필수입니다';

  @override
  String get validatorHostnameInvalid => '잘못된 호스트 이름 또는 IP 주소입니다';

  @override
  String get validatorPortRequired => '포트는 필수입니다';

  @override
  String get validatorPortRange => '포트는 1에서 65535 사이여야 합니다';

  @override
  String get validatorUsernameRequired => '사용자 이름은 필수입니다';

  @override
  String get validatorUsernameInvalid => '잘못된 사용자 이름 형식입니다';

  @override
  String get validatorServerNameRequired => '서버 이름은 필수입니다';

  @override
  String get validatorServerNameLength => '서버 이름은 100자 이하여야 합니다';

  @override
  String get validatorSshKeyInvalid => '잘못된 SSH 키 형식입니다';

  @override
  String get validatorPasswordRequired => '비밀번호는 필수입니다';

  @override
  String get validatorPasswordLength => '비밀번호는 8자 이상이어야 합니다';

  @override
  String get authMethodPassword => '비밀번호';

  @override
  String get authMethodKey => 'SSH 키';

  @override
  String get authMethodBoth => '비밀번호 + 키';

  @override
  String get serverCopySuffix => '(복사)';

  @override
  String get settingsDownloadLogs => '로그 다운로드';

  @override
  String get settingsSendLogs => '지원팀에 로그 보내기';

  @override
  String get settingsLogsSaved => '로그가 저장되었습니다';

  @override
  String get settingsUpdated => '설정 업데이트됨';

  @override
  String get settingsThemeChanged => '테마 변경됨';

  @override
  String get settingsLanguageChanged => '언어 변경됨';

  @override
  String get settingsPinSetSuccess => 'PIN 설정됨';

  @override
  String get settingsPinRemovedSuccess => 'PIN 제거됨';

  @override
  String get settingsDuressPinSetSuccess => '긴급 PIN 설정됨';

  @override
  String get settingsDuressPinRemovedSuccess => '긴급 PIN 제거됨';

  @override
  String get settingsBiometricEnabled => '생체 인증 활성화됨';

  @override
  String get settingsBiometricDisabled => '생체 인증 비활성화됨';

  @override
  String get settingsDnsServerAdded => 'DNS 서버 추가됨';

  @override
  String get settingsDnsServerRemoved => 'DNS 서버 제거됨';

  @override
  String get settingsDnsResetSuccess => 'DNS 서버 초기화됨';

  @override
  String get settingsFontSizeDecreaseTooltip => '글꼴 축소';

  @override
  String get settingsFontSizeIncreaseTooltip => '글꼴 확대';

  @override
  String get settingsDnsRemoveServerTooltip => 'DNS 서버 제거';

  @override
  String get settingsLogsEmpty => '로그 항목이 없습니다';

  @override
  String get authLogin => '로그인';

  @override
  String get authRegister => '회원가입';

  @override
  String get authForgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get authWhyLogin =>
      '모든 기기에서 암호화된 클라우드 동기화를 활성화하려면 로그인하세요. 계정 없이도 앱은 완전히 오프라인으로 작동합니다.';

  @override
  String get authEmailLabel => '이메일';

  @override
  String get authEmailRequired => '이메일은 필수입니다';

  @override
  String get authEmailInvalid => '잘못된 이메일 주소입니다';

  @override
  String get authPasswordLabel => '비밀번호';

  @override
  String get authConfirmPasswordLabel => '비밀번호 확인';

  @override
  String get authPasswordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get authNoAccount => '계정이 없으신가요?';

  @override
  String get authHasAccount => '이미 계정이 있으신가요?';

  @override
  String get authResetEmailSent => '계정이 존재하면 이메일로 재설정 링크가 전송됩니다.';

  @override
  String get authResetDescription => '이메일 주소를 입력하시면 비밀번호 재설정 링크를 보내드립니다.';

  @override
  String get authSendResetLink => '재설정 링크 보내기';

  @override
  String get authBackToLogin => '로그인으로 돌아가기';

  @override
  String get syncPasswordTitle => '동기화 비밀번호';

  @override
  String get syncPasswordTitleCreate => '동기화 비밀번호 설정';

  @override
  String get syncPasswordTitleEnter => '동기화 비밀번호 입력';

  @override
  String get syncPasswordDescription =>
      '볼트 데이터를 암호화할 별도의 비밀번호를 설정합니다. 이 비밀번호는 기기에서 전송되지 않으며 서버는 암호화된 데이터만 저장합니다.';

  @override
  String get syncPasswordHintEnter => '계정 생성 시 설정한 비밀번호를 입력하세요.';

  @override
  String get syncPasswordWarning =>
      '이 비밀번호를 잊으면 동기화된 데이터를 복구할 수 없습니다. 재설정 옵션이 없습니다.';

  @override
  String get syncPasswordLabel => '동기화 비밀번호';

  @override
  String get syncPasswordWrong => '잘못된 비밀번호입니다. 다시 시도하세요.';

  @override
  String get firstSyncTitle => '기존 데이터 발견';

  @override
  String get firstSyncMessage =>
      '이 기기에 기존 데이터가 있고 서버에도 볼트가 있습니다. 어떻게 진행하시겠습니까?';

  @override
  String get firstSyncMerge => '병합 (서버 우선)';

  @override
  String get firstSyncOverwriteLocal => '로컬 데이터 덮어쓰기';

  @override
  String get firstSyncKeepLocal => '로컬 유지 후 푸시';

  @override
  String get firstSyncDeleteLocal => '로컬 삭제 후 풀';

  @override
  String get changeEncryptionPassword => '암호화 비밀번호 변경';

  @override
  String get changeEncryptionWarning => '다른 모든 기기에서 로그아웃됩니다.';

  @override
  String get changeEncryptionOldPassword => '현재 비밀번호';

  @override
  String get changeEncryptionNewPassword => '새 비밀번호';

  @override
  String get changeEncryptionSuccess => '비밀번호가 변경되었습니다.';

  @override
  String get logoutAllDevices => '모든 기기에서 로그아웃';

  @override
  String get logoutAllDevicesConfirm =>
      '모든 활성 세션이 취소됩니다. 모든 기기에서 다시 로그인해야 합니다.';

  @override
  String get logoutAllDevicesSuccess => '모든 기기에서 로그아웃되었습니다.';

  @override
  String get syncSettingsTitle => '동기화 설정';

  @override
  String get syncAutoSync => '자동 동기화';

  @override
  String get syncAutoSyncDescription => '앱 시작 시 자동으로 동기화';

  @override
  String get syncNow => '지금 동기화';

  @override
  String get syncSyncing => '동기화 중...';

  @override
  String get syncSuccess => '동기화 완료';

  @override
  String get syncError => '동기화 오류';

  @override
  String get syncServerUnreachable => '서버에 연결할 수 없음';

  @override
  String get syncServerUnreachableHint =>
      '동기화 서버에 연결할 수 없습니다. 인터넷 연결과 서버 URL을 확인하세요.';

  @override
  String get syncNetworkError => '서버 연결에 실패했습니다. 인터넷 연결을 확인하거나 나중에 다시 시도하세요.';

  @override
  String get syncNeverSynced => '동기화한 적 없음';

  @override
  String get syncVaultVersion => '볼트 버전';

  @override
  String get syncBackgroundSync => '백그라운드 동기화';

  @override
  String get syncBackgroundSyncDescription =>
      '앱이 닫혀 있어도 WorkManager로 주기적으로 동기화.';

  @override
  String get syncTitle => '동기화';

  @override
  String get settingsSectionNetwork => '네트워크 및 DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS 서버';

  @override
  String get settingsDnsDefault => '기본값 (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      '사용자 지정 DoH 서버 URL을 쉼표로 구분하여 입력하세요. 교차 확인 검증을 위해 최소 2개의 서버가 필요합니다.';

  @override
  String get settingsDnsLabel => 'DoH 서버 URL';

  @override
  String get settingsDnsReset => '기본값으로 재설정';

  @override
  String get settingsSectionSync => '동기화';

  @override
  String get settingsSyncAccount => '계정';

  @override
  String get settingsSyncNotLoggedIn => '로그인되지 않음';

  @override
  String get settingsSyncStatus => '동기화';

  @override
  String get settingsSyncServerUrl => '서버 URL';

  @override
  String get settingsSyncDefaultServer => '기본값 (sshvault.app)';

  @override
  String get accountTitle => '계정';

  @override
  String get accountNotLoggedIn => '로그인되지 않음';

  @override
  String get accountVerified => '인증됨';

  @override
  String get accountMemberSince => '가입일';

  @override
  String get accountDevices => '기기';

  @override
  String get accountNoDevices => '등록된 기기가 없습니다';

  @override
  String get accountLastSync => '마지막 동기화';

  @override
  String get accountChangePassword => '비밀번호 변경';

  @override
  String get accountOldPassword => '현재 비밀번호';

  @override
  String get accountNewPassword => '새 비밀번호';

  @override
  String get accountDeleteAccount => '계정 삭제';

  @override
  String get accountDeleteWarning =>
      '계정과 모든 동기화 데이터가 영구적으로 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get accountLogout => '로그아웃';

  @override
  String get serverConfigTitle => '서버 설정';

  @override
  String get serverConfigUrlLabel => '서버 URL';

  @override
  String get serverConfigTest => '연결 테스트';

  @override
  String get serverSetupTitle => '서버 설정';

  @override
  String get serverSetupInfoCard =>
      'ShellVault는 엔드투엔드 암호화 동기화를 위해 자체 호스팅 서버가 필요합니다. 시작하려면 자체 인스턴스를 배포하세요.';

  @override
  String get serverSetupRepoLink => 'GitHub에서 보기';

  @override
  String get serverSetupContinue => '계속';

  @override
  String get settingsServerNotConfigured => '서버가 구성되지 않았습니다';

  @override
  String get settingsSetupSync => '데이터를 백업하려면 동기화를 설정하세요';

  @override
  String get settingsChangeServer => '서버 변경';

  @override
  String get settingsChangeServerConfirm => '서버를 변경하면 로그아웃됩니다. 계속하시겠습니까?';

  @override
  String get auditLogTitle => '활동 로그';

  @override
  String get auditLogAll => '전체';

  @override
  String get auditLogEmpty => '활동 로그가 없습니다';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => '파일 관리자';

  @override
  String get sftpLocalDevice => '로컬 기기';

  @override
  String get sftpSelectServer => '서버 선택...';

  @override
  String get sftpConnecting => '연결 중...';

  @override
  String get sftpEmptyDirectory => '이 디렉터리는 비어 있습니다';

  @override
  String get sftpNoConnection => '서버가 연결되지 않았습니다';

  @override
  String get sftpPathLabel => '경로';

  @override
  String get sftpUpload => '업로드';

  @override
  String get sftpDownload => '다운로드';

  @override
  String get sftpDelete => '삭제';

  @override
  String get sftpRename => '이름 변경';

  @override
  String get sftpNewFolder => '새 폴더';

  @override
  String get sftpNewFolderName => '폴더 이름';

  @override
  String get sftpChmod => '권한';

  @override
  String get sftpChmodTitle => '권한 변경';

  @override
  String get sftpChmodOctal => '8진수';

  @override
  String get sftpChmodOwner => '소유자';

  @override
  String get sftpChmodGroup => '그룹';

  @override
  String get sftpChmodOther => '기타';

  @override
  String get sftpChmodRead => '읽기';

  @override
  String get sftpChmodWrite => '쓰기';

  @override
  String get sftpChmodExecute => '실행';

  @override
  String get sftpCreateSymlink => '심볼릭 링크 생성';

  @override
  String get sftpSymlinkTarget => '대상 경로';

  @override
  String get sftpSymlinkName => '링크 이름';

  @override
  String get sftpFilePreview => '파일 미리보기';

  @override
  String get sftpFileInfo => '파일 정보';

  @override
  String get sftpFileSize => '크기';

  @override
  String get sftpFileModified => '수정일';

  @override
  String get sftpFilePermissions => '권한';

  @override
  String get sftpFileOwner => '소유자';

  @override
  String get sftpFileType => '유형';

  @override
  String get sftpFileLinkTarget => '링크 대상';

  @override
  String get sftpTransfers => '전송';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get sftpTransferQueued => '대기 중';

  @override
  String get sftpTransferActive => '전송 중...';

  @override
  String get sftpTransferPaused => '일시 정지';

  @override
  String get sftpTransferCompleted => '완료';

  @override
  String get sftpTransferFailed => '실패';

  @override
  String get sftpTransferCancelled => '취소됨';

  @override
  String get sftpPauseTransfer => '일시 정지';

  @override
  String get sftpResumeTransfer => '재개';

  @override
  String get sftpCancelTransfer => '취소';

  @override
  String get sftpClearCompleted => '완료 항목 지우기';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active / $total개 전송';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 활성',
      one: '1개 활성',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 완료',
      one: '1개 완료',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 실패',
      one: '1개 실패',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => '다른 창으로 복사';

  @override
  String sftpConfirmDelete(int count) {
    return '$count개 항목을 삭제하시겠습니까?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String get sftpDeleteSuccess => '삭제되었습니다';

  @override
  String get sftpRenameTitle => '이름 변경';

  @override
  String get sftpRenameLabel => '새 이름';

  @override
  String get sftpSortByName => '이름';

  @override
  String get sftpSortBySize => '크기';

  @override
  String get sftpSortByDate => '날짜';

  @override
  String get sftpSortByType => '유형';

  @override
  String get sftpShowHidden => '숨김 파일 표시';

  @override
  String get sftpHideHidden => '숨김 파일 숨기기';

  @override
  String get sftpSelectAll => '전체 선택';

  @override
  String get sftpDeselectAll => '전체 선택 해제';

  @override
  String sftpItemsSelected(int count) {
    return '$count개 선택됨';
  }

  @override
  String get sftpRefresh => '새로 고침';

  @override
  String sftpConnectionError(String message) {
    return '연결 실패: $message';
  }

  @override
  String get sftpPermissionDenied => '권한이 거부되었습니다';

  @override
  String sftpOperationFailed(String message) {
    return '작업 실패: $message';
  }

  @override
  String get sftpOverwriteTitle => '파일이 이미 존재합니다';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\"이(가) 이미 존재합니다. 덮어쓰시겠습니까?';
  }

  @override
  String get sftpOverwrite => '덮어쓰기';

  @override
  String sftpTransferStarted(String fileName) {
    return '전송 시작: $fileName';
  }

  @override
  String get sftpNoPaneSelected => '먼저 다른 창에서 대상을 선택하세요';

  @override
  String get sftpDirectoryTransferNotSupported => '디렉터리 전송은 곧 지원될 예정입니다';

  @override
  String get sftpSelect => '선택';

  @override
  String get sftpOpen => '열기';

  @override
  String get sftpExtractArchive => '여기에 추출';

  @override
  String get sftpExtractSuccess => '아카이브가 추출되었습니다';

  @override
  String sftpExtractFailed(String message) {
    return '추출 실패: $message';
  }

  @override
  String get sftpExtractUnsupported => '지원되지 않는 아카이브 형식입니다';

  @override
  String get sftpExtracting => '추출 중...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 업로드가 시작되었습니다',
      one: '업로드가 시작되었습니다',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count개 다운로드가 시작되었습니다',
      one: '다운로드가 시작되었습니다',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" 다운로드 완료';
  }

  @override
  String get sftpSavedToDownloads => 'Downloads/SSHVault에 저장되었습니다';

  @override
  String get sftpSaveToFiles => '파일에 저장';

  @override
  String get sftpFileSaved => '파일이 저장되었습니다';

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
      other: '$count개 SSH 세션 활성',
      one: 'SSH 세션 활성',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => '터미널을 열려면 탭하세요';

  @override
  String get settingsAccountAndSync => '계정 및 동기화';

  @override
  String get settingsAccountSubtitleAuth => '로그인됨';

  @override
  String get settingsAccountSubtitleUnauth => '로그인되지 않음';

  @override
  String get settingsSecuritySubtitle => '자동 잠금, 생체 인식, PIN';

  @override
  String get settingsSshSubtitle => '포트 22, 사용자 root';

  @override
  String get settingsAppearanceSubtitle => '테마, 언어, 터미널';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => '암호화 내보내기 기본값';

  @override
  String get settingsAboutSubtitle => '버전, 라이선스';

  @override
  String get settingsSearchHint => '설정 검색...';

  @override
  String get settingsSearchNoResults => '설정을 찾을 수 없습니다';

  @override
  String get aboutDeveloper => 'Kiefer Networks 개발';

  @override
  String get aboutDonate => '후원하기';

  @override
  String get aboutOpenSourceLicenses => '오픈 소스 라이선스';

  @override
  String get aboutWebsite => '웹사이트';

  @override
  String get aboutVersion => '버전';

  @override
  String get aboutBuild => '빌드';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS는 DNS 쿼리를 암호화하고 DNS 스푸핑을 방지합니다. SSHVault는 여러 프로바이더에 대해 호스트 이름을 확인하여 공격을 감지합니다.';

  @override
  String get settingsDnsAddServer => 'DNS 서버 추가';

  @override
  String get settingsDnsServerUrl => '서버 URL';

  @override
  String get settingsDnsDefaultBadge => '기본값';

  @override
  String get settingsDnsResetDefaults => '기본값으로 재설정';

  @override
  String get settingsDnsInvalidUrl => '유효한 HTTPS URL을 입력하세요';

  @override
  String get settingsDefaultAuthMethod => '인증 방법';

  @override
  String get settingsAuthPassword => '비밀번호';

  @override
  String get settingsAuthKey => 'SSH 키';

  @override
  String get settingsConnectionTimeout => '연결 시간 초과';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds초';
  }

  @override
  String get settingsKeepaliveInterval => '킵얼라이브 간격';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds초';
  }

  @override
  String get settingsCompression => '압축';

  @override
  String get settingsCompressionDescription => 'SSH 연결에 zlib 압축 활성화';

  @override
  String get settingsTerminalType => '터미널 유형';

  @override
  String get settingsSectionConnection => '연결';

  @override
  String get settingsClipboardAutoClear => '클립보드 자동 지우기';

  @override
  String get settingsClipboardAutoClearOff => '끄기';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds초';
  }

  @override
  String get settingsSessionTimeout => '세션 시간 초과';

  @override
  String get settingsSessionTimeoutOff => '끄기';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes분';
  }

  @override
  String get settingsDuressPin => '긴급 PIN';

  @override
  String get settingsDuressPinDescription => '입력 시 모든 데이터를 삭제하는 별도의 PIN';

  @override
  String get settingsDuressPinSet => '긴급 PIN 설정됨';

  @override
  String get settingsDuressPinNotSet => '미설정';

  @override
  String get settingsDuressPinWarning =>
      '이 PIN을 입력하면 자격 증명, 키, 설정을 포함한 모든 로컬 데이터가 영구 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get settingsKeyRotationReminder => '키 순환 알림';

  @override
  String get settingsKeyRotationOff => '끄기';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days일';
  }

  @override
  String get settingsFailedAttempts => 'PIN 입력 실패 횟수';

  @override
  String get settingsSectionAppLock => '앱 잠금';

  @override
  String get settingsSectionPrivacy => '개인 정보';

  @override
  String get settingsSectionReminders => '알림';

  @override
  String get settingsSectionStatus => '상태';

  @override
  String get settingsExportBackupSubtitle => '내보내기, 가져오기 및 백업';

  @override
  String get settingsExportJson => 'JSON으로 내보내기';

  @override
  String get settingsExportEncrypted => '암호화하여 내보내기';

  @override
  String get settingsImportFile => '파일에서 가져오기';

  @override
  String get settingsSectionImport => '가져오기';

  @override
  String get filterTitle => '서버 필터';

  @override
  String get filterApply => '필터 적용';

  @override
  String get filterClearAll => '모두 지우기';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '필터 $count개 활성',
      one: '필터 1개 활성',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => '폴더';

  @override
  String get filterTags => '태그';

  @override
  String get filterStatus => '상태';

  @override
  String get variablePreviewResolved => '해결된 미리보기';

  @override
  String get variableInsert => '삽입';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '서버 $count개',
      one: '서버 1개',
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
      other: '세션 $count개가 취소되었습니다.',
      one: '세션 1개가 취소되었습니다.',
    );
    return '$_temp0 로그아웃되었습니다.';
  }

  @override
  String get keyGenPassphrase => '암호';

  @override
  String get keyGenPassphraseHint => '선택사항 — 개인 키를 보호합니다';

  @override
  String get settingsDnsDefaultQuad9Mullvad => '기본값 (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return '동일한 핑거프린트의 키가 이미 존재합니다: \"$name\". 각 SSH 키는 고유해야 합니다.';
  }

  @override
  String get sshKeyFingerprint => '핑거프린트';

  @override
  String get sshKeyPublicKey => '공개 키';

  @override
  String get jumpHost => '점프 호스트';

  @override
  String get jumpHostNone => '없음';

  @override
  String get jumpHostLabel => '점프 호스트를 통해 연결';

  @override
  String get jumpHostSelfError => '서버 자체를 점프 호스트로 설정할 수 없습니다';

  @override
  String get jumpHostConnecting => '점프 호스트에 연결 중…';

  @override
  String get jumpHostCircularError => '순환 점프 호스트 체인이 감지되었습니다';

  @override
  String get logoutDialogTitle => '로그아웃';

  @override
  String get logoutDialogMessage =>
      '모든 로컬 데이터를 삭제하시겠습니까? 서버, SSH 키, 스니펫, 설정이 이 기기에서 제거됩니다.';

  @override
  String get logoutOnly => '로그아웃만';

  @override
  String get logoutAndDelete => '로그아웃 및 데이터 삭제';

  @override
  String get changeAvatar => '아바타 변경';

  @override
  String get removeAvatar => '아바타 제거';

  @override
  String get avatarUploadFailed => '아바타 업로드에 실패했습니다';

  @override
  String get avatarTooLarge => '이미지가 너무 큽니다';

  @override
  String get deviceLastSeen => '마지막 확인';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      '로그인 중에는 서버 URL을 변경할 수 없습니다. 먼저 로그아웃하세요.';

  @override
  String get serverListNoFolder => '미분류';

  @override
  String get autoSyncInterval => '동기화 간격';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes분';
  }

  @override
  String get proxySettings => '프록시 설정';

  @override
  String get proxyType => '프록시 유형';

  @override
  String get proxyNone => '프록시 없음';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => '프록시 호스트';

  @override
  String get proxyPort => '프록시 포트';

  @override
  String get proxyUsername => '프록시 사용자 이름';

  @override
  String get proxyPassword => '프록시 비밀번호';

  @override
  String get proxyUseGlobal => '글로벌 프록시 사용';

  @override
  String get proxyGlobal => '글로벌';

  @override
  String get proxyServerSpecific => '서버별';

  @override
  String get proxyTestConnection => '연결 테스트';

  @override
  String get proxyTestSuccess => '프록시에 연결 가능';

  @override
  String get proxyTestFailed => '프록시에 연결할 수 없음';

  @override
  String get proxyDefaultProxy => '기본 프록시';

  @override
  String get vpnRequired => 'VPN 필요';

  @override
  String get vpnRequiredTooltip => 'VPN 없이 연결 시 경고 표시';

  @override
  String get vpnActive => 'VPN 활성';

  @override
  String get vpnInactive => 'VPN 비활성';

  @override
  String get vpnWarningTitle => 'VPN이 활성화되지 않았습니다';

  @override
  String get vpnWarningMessage =>
      '이 서버는 VPN 연결이 필요하지만 현재 VPN이 활성화되어 있지 않습니다. 그래도 연결하시겠습니까?';

  @override
  String get vpnConnectAnyway => '그래도 연결';

  @override
  String get postConnectCommands => '연결 후 명령';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle => '연결 후 자동 실행되는 명령 (한 줄에 하나씩)';

  @override
  String get dashboardFavorites => '즐겨찾기';

  @override
  String get dashboardRecent => '최근';

  @override
  String get dashboardActiveSessions => '활성 세션';

  @override
  String get addToFavorites => '즐겨찾기에 추가';

  @override
  String get removeFromFavorites => '즐겨찾기에서 제거';

  @override
  String get noRecentConnections => '최근 연결이 없습니다';

  @override
  String get terminalSplit => '화면 분할';

  @override
  String get terminalUnsplit => '분할 닫기';

  @override
  String get terminalSelectSession => '화면 분할용 세션 선택';

  @override
  String get knownHostsTitle => '알려진 호스트';

  @override
  String get knownHostsSubtitle => '신뢰할 수 있는 서버 핑거프린트 관리';

  @override
  String get hostKeyNewTitle => '새 호스트';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return '$hostname:$port에 처음 연결합니다. 연결 전에 핑거프린트를 확인하세요.';
  }

  @override
  String get hostKeyChangedTitle => '호스트 키가 변경되었습니다!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return '$hostname:$port의 호스트 키가 변경되었습니다. 이는 보안 위협을 나타낼 수 있습니다.';
  }

  @override
  String get hostKeyFingerprint => '핑거프린트';

  @override
  String get hostKeyType => '키 유형';

  @override
  String get hostKeyTrustConnect => '신뢰 후 연결';

  @override
  String get hostKeyAcceptNew => '새 키 수락';

  @override
  String get hostKeyReject => '거부';

  @override
  String get hostKeyPreviousFingerprint => '이전 핑거프린트';

  @override
  String get hostKeyDeleteAll => '모든 알려진 호스트 삭제';

  @override
  String get hostKeyDeleteConfirm =>
      '모든 알려진 호스트를 제거하시겠습니까? 다음 연결 시 다시 확인이 표시됩니다.';

  @override
  String get hostKeyEmpty => '알려진 호스트가 아직 없습니다';

  @override
  String get hostKeyEmptySubtitle => '첫 연결 후 호스트 핑거프린트가 여기에 저장됩니다';

  @override
  String get hostKeyFirstSeen => '최초 확인';

  @override
  String get hostKeyLastSeen => '마지막 확인';

  @override
  String get sshConfigImportTitle => 'SSH 설정 가져오기';

  @override
  String get sshConfigImportPickFile => 'SSH 설정 파일 선택';

  @override
  String get sshConfigImportOrPaste => '또는 설정 내용을 붙여넣기';

  @override
  String sshConfigImportParsed(int count) {
    return '$count개의 호스트를 찾았습니다';
  }

  @override
  String get sshConfigImportButton => '가져오기';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count개의 서버를 가져왔습니다';
  }

  @override
  String get sshConfigImportDuplicate => '이미 존재합니다';

  @override
  String get sshConfigImportNoHosts => '설정에서 호스트를 찾을 수 없습니다';

  @override
  String get sftpBookmarkAdd => '북마크 추가';

  @override
  String get sftpBookmarkLabel => '라벨';

  @override
  String get disconnect => '연결 해제';

  @override
  String get reportAndDisconnect => '신고 후 연결 해제';

  @override
  String get continueAnyway => '그래도 계속';

  @override
  String get insertSnippet => '스니펫 삽입';

  @override
  String get seconds => '초';

  @override
  String get heartbeatLostMessage =>
      '여러 번 시도한 후에도 서버에 연결할 수 없었습니다. 보안을 위해 세션이 종료되었습니다.';

  @override
  String get attestationFailedTitle => '서버 검증 실패';

  @override
  String get attestationFailedMessage =>
      '서버를 정규 SSHVault 백엔드로 검증할 수 없었습니다. 이는 중간자 공격이나 서버 구성 오류를 나타낼 수 있습니다.';

  @override
  String get attestationKeyChangedTitle => '서버 키 변경됨';

  @override
  String get attestationKeyChangedMessage =>
      '초기 연결 이후 서버의 인증 키가 변경되었습니다. 이는 중간자 공격을 나타낼 수 있습니다. 서버 관리자가 키 순환을 확인하지 않는 한 계속하지 마세요.';

  @override
  String get sectionLinks => '링크';

  @override
  String get sectionDeveloper => '개발자';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => '페이지를 찾을 수 없습니다';

  @override
  String get connectionTestSuccess => '연결 성공';

  @override
  String connectionTestFailed(String message) {
    return '연결 실패: $message';
  }

  @override
  String get serverVerificationFailed => '서버 검증 실패';

  @override
  String get importSuccessful => '가져오기 성공';

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
  String get deviceDeleteConfirmTitle => '기기 제거';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return '\"$name\"을(를) 제거하시겠습니까? 기기가 즉시 로그아웃됩니다.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage => '현재 사용 중인 기기입니다. 즉시 로그아웃됩니다.';

  @override
  String get deviceDeleteSuccess => '기기가 제거되었습니다';

  @override
  String get deviceDeletedCurrentLogout => '현재 기기가 제거되었습니다. 로그아웃되었습니다.';

  @override
  String get thisDevice => '이 기기';
}
