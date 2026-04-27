// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'โฮสต์';

  @override
  String get navSnippets => 'สนิปเพ็ต';

  @override
  String get navFolders => 'โฟลเดอร์';

  @override
  String get navTags => 'แท็ก';

  @override
  String get navSshKeys => 'คีย์ SSH';

  @override
  String get navExportImport => 'ส่งออก / นำเข้า';

  @override
  String get navTerminal => 'เทอร์มินัล';

  @override
  String get navMore => 'เพิ่มเติม';

  @override
  String get navManagement => 'การจัดการ';

  @override
  String get navSettings => 'การตั้งค่า';

  @override
  String get navAbout => 'เกี่ยวกับ';

  @override
  String get lockScreenTitle => 'SSHVault ถูกล็อก';

  @override
  String get lockScreenUnlock => 'ปลดล็อก';

  @override
  String get lockScreenEnterPin => 'ใส่ PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'ลองผิดหลายครั้งเกินไป ลองอีกครั้งใน $minutes นาที';
  }

  @override
  String get pinDialogSetTitle => 'ตั้งรหัส PIN';

  @override
  String get pinDialogSetSubtitle => 'ใส่ PIN 6 หลักเพื่อปกป้อง SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'ยืนยัน PIN';

  @override
  String get pinDialogErrorLength => 'PIN ต้องมี 6 หลักเท่านั้น';

  @override
  String get pinDialogErrorMismatch => 'PIN ไม่ตรงกัน';

  @override
  String get pinDialogVerifyTitle => 'ใส่ PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN ผิด เหลือ $attempts ครั้ง';
  }

  @override
  String get securityBannerMessage =>
      'ข้อมูลรับรอง SSH ของคุณไม่ได้รับการป้องกัน ตั้งค่า PIN หรือล็อกไบโอเมตริกในการตั้งค่า';

  @override
  String get securityBannerDismiss => 'ปิด';

  @override
  String get settingsTitle => 'การตั้งค่า';

  @override
  String get settingsSectionAppearance => 'รูปลักษณ์';

  @override
  String get settingsSectionTerminal => 'เทอร์มินัล';

  @override
  String get settingsSectionSshDefaults => 'ค่าเริ่มต้น SSH';

  @override
  String get settingsSectionSecurity => 'ความปลอดภัย';

  @override
  String get settingsSectionExport => 'ส่งออก';

  @override
  String get settingsSectionAbout => 'เกี่ยวกับ';

  @override
  String get settingsTheme => 'ธีม';

  @override
  String get settingsThemeSystem => 'ระบบ';

  @override
  String get settingsThemeLight => 'สว่าง';

  @override
  String get settingsThemeDark => 'มืด';

  @override
  String get settingsTerminalTheme => 'ธีมเทอร์มินัล';

  @override
  String get settingsTerminalThemeDefault => 'มืดเริ่มต้น';

  @override
  String get settingsFontSize => 'ขนาดตัวอักษร';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'พอร์ตเริ่มต้น';

  @override
  String get settingsDefaultPortDialog => 'พอร์ต SSH เริ่มต้น';

  @override
  String get settingsPortLabel => 'พอร์ต';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'ชื่อผู้ใช้เริ่มต้น';

  @override
  String get settingsDefaultUsernameDialog => 'ชื่อผู้ใช้เริ่มต้น';

  @override
  String get settingsUsernameLabel => 'ชื่อผู้ใช้';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'ล็อกอัตโนมัติ';

  @override
  String get settingsAutoLockDisabled => 'ปิดใช้งาน';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes นาที';
  }

  @override
  String get settingsAutoLockOff => 'ปิด';

  @override
  String get settingsAutoLock1Min => '1 นาที';

  @override
  String get settingsAutoLock5Min => '5 นาที';

  @override
  String get settingsAutoLock15Min => '15 นาที';

  @override
  String get settingsAutoLock30Min => '30 นาที';

  @override
  String get settingsBiometricUnlock => 'ปลดล็อกด้วยไบโอเมตริก';

  @override
  String get settingsBiometricNotAvailable => 'ไม่พร้อมใช้งานบนอุปกรณ์นี้';

  @override
  String get settingsBiometricError => 'เกิดข้อผิดพลาดในการตรวจสอบไบโอเมตริก';

  @override
  String get settingsBiometricReason =>
      'ยืนยันตัวตนเพื่อเปิดใช้งานการปลดล็อกด้วยไบโอเมตริก';

  @override
  String get settingsBiometricRequiresPin =>
      'ตั้ง PIN ก่อนเพื่อเปิดใช้งานการปลดล็อกด้วยไบโอเมตริก';

  @override
  String get settingsPinCode => 'รหัส PIN';

  @override
  String get settingsPinIsSet => 'ตั้ง PIN แล้ว';

  @override
  String get settingsPinNotConfigured => 'ไม่ได้ตั้ง PIN';

  @override
  String get settingsPinRemove => 'ลบ';

  @override
  String get settingsPinRemoveWarning =>
      'การลบ PIN จะถอดรหัสฟิลด์ฐานข้อมูลทั้งหมดและปิดใช้งานการปลดล็อกด้วยไบโอเมตริก ดำเนินการต่อหรือไม่?';

  @override
  String get settingsPinRemoveTitle => 'ลบ PIN';

  @override
  String get settingsPreventScreenshots => 'ป้องกันการจับภาพหน้าจอ';

  @override
  String get settingsPreventScreenshotsDescription =>
      'บล็อกการจับภาพหน้าจอและการบันทึกหน้าจอ';

  @override
  String get settingsEncryptExport => 'เข้ารหัสการส่งออกโดยค่าเริ่มต้น';

  @override
  String get settingsAbout => 'เกี่ยวกับ SSHVault';

  @override
  String get settingsAboutLegalese => 'โดย Kiefer Networks';

  @override
  String get settingsAboutDescription => 'ไคลเอนต์ SSH ที่ปลอดภัยและโฮสต์เอง';

  @override
  String get settingsLanguage => 'ภาษา';

  @override
  String get settingsLanguageSystem => 'ระบบ';

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
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get delete => 'ลบ';

  @override
  String get close => 'ปิด';

  @override
  String get update => 'อัปเดต';

  @override
  String get create => 'สร้าง';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get copy => 'คัดลอก';

  @override
  String get edit => 'แก้ไข';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'ข้อผิดพลาด: $message';
  }

  @override
  String get serverListTitle => 'โฮสต์';

  @override
  String get serverListEmpty => 'ยังไม่มีเซิร์ฟเวอร์';

  @override
  String get serverListEmptySubtitle => 'เพิ่มเซิร์ฟเวอร์ SSH แรกเพื่อเริ่มต้น';

  @override
  String get serverAddButton => 'เพิ่มเซิร์ฟเวอร์';

  @override
  String sshConfigImportMessage(int count) {
    return 'พบ $count โฮสต์ใน ~/.ssh/config นำเข้าหรือไม่?';
  }

  @override
  String get sshConfigNotFound => 'ไม่พบไฟล์ตั้งค่า SSH';

  @override
  String get sshConfigEmpty => 'ไม่พบโฮสต์ในการตั้งค่า SSH';

  @override
  String get sshConfigAddManually => 'เพิ่มด้วยตนเอง';

  @override
  String get sshConfigImportAgain => 'นำเข้าการตั้งค่า SSH อีกครั้งหรือไม่?';

  @override
  String get sshConfigImportKeys =>
      'นำเข้าคีย์ SSH ที่อ้างอิงโดยโฮสต์ที่เลือกหรือไม่?';

  @override
  String sshConfigKeysImported(int count) {
    return 'นำเข้า $count คีย์ SSH แล้ว';
  }

  @override
  String get serverDuplicated => 'ทำซ้ำเซิร์ฟเวอร์แล้ว';

  @override
  String get serverDeleteTitle => 'ลบเซิร์ฟเวอร์';

  @override
  String serverDeleteMessage(String name) {
    return 'คุณแน่ใจหรือว่าต้องการลบ \"$name\"? การดำเนินการนี้ไม่สามารถย้อนกลับได้';
  }

  @override
  String serverDeleteShort(String name) {
    return 'ลบ \"$name\"?';
  }

  @override
  String get serverConnect => 'เชื่อมต่อ';

  @override
  String get serverDetails => 'รายละเอียด';

  @override
  String get serverDuplicate => 'ทำซ้ำ';

  @override
  String get serverActive => 'ใช้งานอยู่';

  @override
  String get serverNoFolder => 'ไม่มีโฟลเดอร์';

  @override
  String get serverFormTitleEdit => 'แก้ไขเซิร์ฟเวอร์';

  @override
  String get serverFormTitleAdd => 'เพิ่มเซิร์ฟเวอร์';

  @override
  String get serverSaved => 'บันทึกเซิร์ฟเวอร์แล้ว';

  @override
  String get serverFormUpdateButton => 'อัปเดตเซิร์ฟเวอร์';

  @override
  String get serverFormAddButton => 'เพิ่มเซิร์ฟเวอร์';

  @override
  String get serverFormPublicKeyExtracted => 'แยกคีย์สาธารณะสำเร็จ';

  @override
  String serverFormPublicKeyError(String message) {
    return 'ไม่สามารถแยกคีย์สาธารณะ: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'สร้างคู่คีย์ $type แล้ว';
  }

  @override
  String get serverDetailTitle => 'รายละเอียดเซิร์ฟเวอร์';

  @override
  String get serverDetailDeleteMessage => 'การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get serverDetailConnection => 'การเชื่อมต่อ';

  @override
  String get serverDetailHost => 'โฮสต์';

  @override
  String get serverDetailPort => 'พอร์ต';

  @override
  String get serverDetailUsername => 'ชื่อผู้ใช้';

  @override
  String get serverDetailFolder => 'โฟลเดอร์';

  @override
  String get serverDetailTags => 'แท็ก';

  @override
  String get serverDetailNotes => 'บันทึก';

  @override
  String get serverDetailInfo => 'ข้อมูล';

  @override
  String get serverDetailCreated => 'สร้างเมื่อ';

  @override
  String get serverDetailUpdated => 'อัปเดตเมื่อ';

  @override
  String get serverDetailDistro => 'ระบบ';

  @override
  String get copiedToClipboard => 'คัดลอกไปยังคลิปบอร์ดแล้ว';

  @override
  String get serverFormNameLabel => 'ชื่อเซิร์ฟเวอร์';

  @override
  String get serverFormHostnameLabel => 'ชื่อโฮสต์ / IP';

  @override
  String get serverFormPortLabel => 'พอร์ต';

  @override
  String get serverFormUsernameLabel => 'ชื่อผู้ใช้';

  @override
  String get serverFormPasswordLabel => 'รหัสผ่าน';

  @override
  String get serverFormUseManagedKey => 'ใช้คีย์ที่จัดการ';

  @override
  String get serverFormManagedKeySubtitle =>
      'เลือกจากคีย์ SSH ที่จัดการส่วนกลาง';

  @override
  String get serverFormDirectKeySubtitle => 'วางคีย์โดยตรงในเซิร์ฟเวอร์นี้';

  @override
  String get serverFormGenerateKey => 'สร้างคู่คีย์ SSH';

  @override
  String get serverFormPrivateKeyLabel => 'คีย์ส่วนตัว';

  @override
  String get serverFormPrivateKeyHint => 'วางคีย์ส่วนตัว SSH...';

  @override
  String get serverFormExtractPublicKey => 'แยกคีย์สาธารณะ';

  @override
  String get serverFormPublicKeyLabel => 'คีย์สาธารณะ';

  @override
  String get serverFormPublicKeyHint =>
      'สร้างอัตโนมัติจากคีย์ส่วนตัวหากว่างเปล่า';

  @override
  String get serverFormPassphraseLabel => 'วลีรหัสผ่านคีย์ (ไม่บังคับ)';

  @override
  String get serverFormNotesLabel => 'บันทึก (ไม่บังคับ)';

  @override
  String get searchServers => 'ค้นหาเซิร์ฟเวอร์...';

  @override
  String get filterAllFolders => 'ทุกโฟลเดอร์';

  @override
  String get filterAll => 'ทั้งหมด';

  @override
  String get filterActive => 'ใช้งานอยู่';

  @override
  String get filterInactive => 'ไม่ได้ใช้งาน';

  @override
  String get filterClear => 'ล้าง';

  @override
  String get folderListTitle => 'โฟลเดอร์';

  @override
  String get folderListEmpty => 'ยังไม่มีโฟลเดอร์';

  @override
  String get folderListEmptySubtitle =>
      'สร้างโฟลเดอร์เพื่อจัดระเบียบเซิร์ฟเวอร์';

  @override
  String get folderAddButton => 'เพิ่มโฟลเดอร์';

  @override
  String get folderDeleteTitle => 'ลบโฟลเดอร์';

  @override
  String folderDeleteMessage(String name) {
    return 'ลบ \"$name\"? เซิร์ฟเวอร์จะไม่ถูกจัดหมวดหมู่';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count เซิร์ฟเวอร์',
      one: '1 เซิร์ฟเวอร์',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'ยุบ';

  @override
  String get folderShowHosts => 'แสดงโฮสต์';

  @override
  String get folderConnectAll => 'เชื่อมต่อทั้งหมด';

  @override
  String get folderFormTitleEdit => 'แก้ไขโฟลเดอร์';

  @override
  String get folderFormTitleNew => 'โฟลเดอร์ใหม่';

  @override
  String get folderFormNameLabel => 'ชื่อโฟลเดอร์';

  @override
  String get folderFormParentLabel => 'โฟลเดอร์หลัก';

  @override
  String get folderFormParentNone => 'ไม่มี (ราก)';

  @override
  String get tagListTitle => 'แท็ก';

  @override
  String get tagListEmpty => 'ยังไม่มีแท็ก';

  @override
  String get tagListEmptySubtitle =>
      'สร้างแท็กเพื่อติดป้ายกำกับและกรองเซิร์ฟเวอร์';

  @override
  String get tagAddButton => 'เพิ่มแท็ก';

  @override
  String get tagDeleteTitle => 'ลบแท็ก';

  @override
  String tagDeleteMessage(String name) {
    return 'ลบ \"$name\"? จะถูกลบออกจากเซิร์ฟเวอร์ทั้งหมด';
  }

  @override
  String get tagFormTitleEdit => 'แก้ไขแท็ก';

  @override
  String get tagFormTitleNew => 'แท็กใหม่';

  @override
  String get tagFormNameLabel => 'ชื่อแท็ก';

  @override
  String get sshKeyListTitle => 'คีย์ SSH';

  @override
  String get sshKeyListEmpty => 'ยังไม่มีคีย์ SSH';

  @override
  String get sshKeyListEmptySubtitle =>
      'สร้างหรือนำเข้าคีย์ SSH เพื่อจัดการส่วนกลาง';

  @override
  String get sshKeyCannotDeleteTitle => 'ไม่สามารถลบได้';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'ไม่สามารถลบ \"$name\" ถูกใช้โดย $count เซิร์ฟเวอร์ ยกเลิกการเชื่อมโยงจากเซิร์ฟเวอร์ทั้งหมดก่อน';
  }

  @override
  String get sshKeyDeleteTitle => 'ลบคีย์ SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'ลบ \"$name\"? การดำเนินการนี้ไม่สามารถย้อนกลับได้';
  }

  @override
  String get sshKeyAddButton => 'เพิ่มคีย์ SSH';

  @override
  String get sshKeyFormTitleEdit => 'แก้ไขคีย์ SSH';

  @override
  String get sshKeyFormTitleAdd => 'เพิ่มคีย์ SSH';

  @override
  String get sshKeyFormTabGenerate => 'สร้าง';

  @override
  String get sshKeyFormTabImport => 'นำเข้า';

  @override
  String get sshKeyFormNameLabel => 'ชื่อคีย์';

  @override
  String get sshKeyFormNameHint => 'เช่น คีย์โปรดักชันของฉัน';

  @override
  String get sshKeyFormKeyType => 'ประเภทคีย์';

  @override
  String get sshKeyFormKeySize => 'ขนาดคีย์';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits บิต';
  }

  @override
  String get sshKeyFormCommentLabel => 'ความคิดเห็น';

  @override
  String get sshKeyFormCommentHint => 'ผู้ใช้@โฮสต์ หรือคำอธิบาย';

  @override
  String get sshKeyFormCommentOptional => 'ความคิดเห็น (ไม่บังคับ)';

  @override
  String get sshKeyFormImportFromFile => 'นำเข้าจากไฟล์';

  @override
  String get sshKeyFormPrivateKeyLabel => 'คีย์ส่วนตัว';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'วางคีย์ส่วนตัว SSH หรือใช้ปุ่มด้านบน...';

  @override
  String get sshKeyFormPassphraseLabel => 'วลีรหัสผ่าน (ไม่บังคับ)';

  @override
  String get sshKeyFormNameRequired => 'จำเป็นต้องระบุชื่อ';

  @override
  String get sshKeyFormPrivateKeyRequired => 'จำเป็นต้องระบุคีย์ส่วนตัว';

  @override
  String get sshKeyFormFileReadError => 'ไม่สามารถอ่านไฟล์ที่เลือกได้';

  @override
  String get sshKeyFormInvalidFormat =>
      'รูปแบบคีย์ไม่ถูกต้อง — ต้องเป็นรูปแบบ PEM (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'ไม่สามารถอ่านไฟล์: $message';
  }

  @override
  String get sshKeyFormSaving => 'กำลังบันทึก...';

  @override
  String get sshKeySelectorLabel => 'คีย์ SSH';

  @override
  String get sshKeySelectorNone => 'ไม่มีคีย์ที่จัดการ';

  @override
  String get sshKeySelectorManage => 'จัดการคีย์...';

  @override
  String get sshKeySelectorError => 'ไม่สามารถโหลดคีย์ SSH ได้';

  @override
  String get sshKeyTileCopyPublicKey => 'คัดลอกคีย์สาธารณะ';

  @override
  String get sshKeyTilePublicKeyCopied => 'คัดลอกคีย์สาธารณะแล้ว';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'ใช้โดย $count เซิร์ฟเวอร์';
  }

  @override
  String get sshKeySavedSuccess => 'บันทึกคีย์ SSH แล้ว';

  @override
  String get sshKeyDeletedSuccess => 'ลบคีย์ SSH แล้ว';

  @override
  String get tagSavedSuccess => 'บันทึกแท็กแล้ว';

  @override
  String get tagDeletedSuccess => 'ลบแท็กแล้ว';

  @override
  String get folderDeletedSuccess => 'ลบโฟลเดอร์แล้ว';

  @override
  String get sshKeyTileUnlinkFirst =>
      'ยกเลิกการเชื่อมโยงจากเซิร์ฟเวอร์ทั้งหมดก่อน';

  @override
  String get exportImportTitle => 'ส่งออก / นำเข้า';

  @override
  String get exportSectionTitle => 'ส่งออก';

  @override
  String get exportJsonButton => 'ส่งออกเป็น JSON (ไม่มีข้อมูลรับรอง)';

  @override
  String get exportZipButton => 'ส่งออก ZIP เข้ารหัส (พร้อมข้อมูลรับรอง)';

  @override
  String get importSectionTitle => 'นำเข้า';

  @override
  String get importButton => 'นำเข้าจากไฟล์';

  @override
  String get importSupportedFormats =>
      'รองรับไฟล์ JSON (ธรรมดา) และ ZIP (เข้ารหัส)';

  @override
  String exportedTo(String path) {
    return 'ส่งออกไปยัง: $path';
  }

  @override
  String get share => 'แชร์';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return 'นำเข้า $servers เซิร์ฟเวอร์, $groups กลุ่ม, $tags แท็ก ข้าม $skipped รายการ';
  }

  @override
  String get importPasswordTitle => 'ใส่รหัสผ่าน';

  @override
  String get importPasswordLabel => 'รหัสผ่านส่งออก';

  @override
  String get importPasswordDecrypt => 'ถอดรหัส';

  @override
  String get exportPasswordTitle => 'ตั้งรหัสผ่านส่งออก';

  @override
  String get exportPasswordDescription =>
      'รหัสผ่านนี้จะใช้เข้ารหัสไฟล์ส่งออกรวมถึงข้อมูลรับรอง';

  @override
  String get exportPasswordLabel => 'รหัสผ่าน';

  @override
  String get exportPasswordConfirmLabel => 'ยืนยันรหัสผ่าน';

  @override
  String get exportPasswordMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get exportPasswordButton => 'เข้ารหัสและส่งออก';

  @override
  String get importConflictTitle => 'จัดการข้อขัดแย้ง';

  @override
  String get importConflictDescription =>
      'ควรจัดการรายการที่มีอยู่แล้วอย่างไรระหว่างการนำเข้า?';

  @override
  String get importConflictSkip => 'ข้ามรายการที่มีอยู่';

  @override
  String get importConflictRename => 'เปลี่ยนชื่อรายการใหม่';

  @override
  String get importConflictOverwrite => 'เขียนทับ';

  @override
  String get confirmDeleteLabel => 'ลบ';

  @override
  String get keyGenTitle => 'สร้างคู่คีย์ SSH';

  @override
  String get keyGenKeyType => 'ประเภทคีย์';

  @override
  String get keyGenKeySize => 'ขนาดคีย์';

  @override
  String get keyGenComment => 'ความคิดเห็น';

  @override
  String get keyGenCommentHint => 'ผู้ใช้@โฮสต์ หรือคำอธิบาย';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits บิต';
  }

  @override
  String get keyGenGenerating => 'กำลังสร้าง...';

  @override
  String get keyGenGenerate => 'สร้าง';

  @override
  String keyGenResultTitle(String type) {
    return 'สร้างคีย์ $type แล้ว';
  }

  @override
  String get keyGenPublicKey => 'คีย์สาธารณะ';

  @override
  String get keyGenPrivateKey => 'คีย์ส่วนตัว';

  @override
  String keyGenCommentInfo(String comment) {
    return 'ความคิดเห็น: $comment';
  }

  @override
  String get keyGenAnother => 'สร้างอีกคีย์';

  @override
  String get keyGenUseThisKey => 'ใช้คีย์นี้';

  @override
  String get keyGenCopyTooltip => 'คัดลอกไปยังคลิปบอร์ด';

  @override
  String keyGenCopied(String label) {
    return 'คัดลอก $label แล้ว';
  }

  @override
  String get colorPickerLabel => 'สี';

  @override
  String get iconPickerLabel => 'ไอคอน';

  @override
  String get tagSelectorLabel => 'แท็ก';

  @override
  String get tagSelectorEmpty => 'ยังไม่มีแท็ก';

  @override
  String get tagSelectorError => 'ไม่สามารถโหลดแท็กได้';

  @override
  String get snippetListTitle => 'สนิปเพ็ต';

  @override
  String get snippetSearchHint => 'ค้นหาสนิปเพ็ต...';

  @override
  String get snippetListEmpty => 'ยังไม่มีสนิปเพ็ต';

  @override
  String get snippetListEmptySubtitle =>
      'สร้างสนิปเพ็ตโค้ดและคำสั่งที่ใช้ซ้ำได้';

  @override
  String get snippetAddButton => 'เพิ่มสนิปเพ็ต';

  @override
  String get snippetDeleteTitle => 'ลบสนิปเพ็ต';

  @override
  String snippetDeleteMessage(String name) {
    return 'ลบ \"$name\"? การดำเนินการนี้ไม่สามารถย้อนกลับได้';
  }

  @override
  String get snippetFormTitleEdit => 'แก้ไขสนิปเพ็ต';

  @override
  String get snippetFormTitleNew => 'สนิปเพ็ตใหม่';

  @override
  String get snippetFormNameLabel => 'ชื่อ';

  @override
  String get snippetFormNameHint => 'เช่น Docker cleanup';

  @override
  String get snippetFormLanguageLabel => 'ภาษา';

  @override
  String get snippetFormContentLabel => 'เนื้อหา';

  @override
  String get snippetFormContentHint => 'ใส่โค้ดสนิปเพ็ต...';

  @override
  String get snippetFormDescriptionLabel => 'คำอธิบาย';

  @override
  String get snippetFormDescriptionHint => 'คำอธิบายเพิ่มเติม...';

  @override
  String get snippetFormFolderLabel => 'โฟลเดอร์';

  @override
  String get snippetFormNoFolder => 'ไม่มีโฟลเดอร์';

  @override
  String get snippetFormNameRequired => 'จำเป็นต้องระบุชื่อ';

  @override
  String get snippetFormContentRequired => 'จำเป็นต้องระบุเนื้อหา';

  @override
  String get snippetFormSaved => 'บันทึกสนิปเพ็ตแล้ว';

  @override
  String get snippetFormUpdateButton => 'อัปเดตสนิปเพ็ต';

  @override
  String get snippetFormCreateButton => 'สร้างสนิปเพ็ต';

  @override
  String get snippetDetailTitle => 'รายละเอียดสนิปเพ็ต';

  @override
  String get snippetDetailDeleteTitle => 'ลบสนิปเพ็ต';

  @override
  String get snippetDetailDeleteMessage =>
      'การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get snippetDetailContent => 'เนื้อหา';

  @override
  String get snippetDetailFillVariables => 'กรอกตัวแปร';

  @override
  String get snippetDetailDescription => 'คำอธิบาย';

  @override
  String get snippetDetailVariables => 'ตัวแปร';

  @override
  String get snippetDetailTags => 'แท็ก';

  @override
  String get snippetDetailInfo => 'ข้อมูล';

  @override
  String get snippetDetailCreated => 'สร้างเมื่อ';

  @override
  String get snippetDetailUpdated => 'อัปเดตเมื่อ';

  @override
  String get variableEditorTitle => 'ตัวแปรเทมเพลต';

  @override
  String get variableEditorAdd => 'เพิ่ม';

  @override
  String get variableEditorEmpty =>
      'ไม่มีตัวแปร ใช้ไวยากรณ์วงเล็บปีกกาในเนื้อหาเพื่ออ้างอิง';

  @override
  String get variableEditorNameLabel => 'ชื่อ';

  @override
  String get variableEditorNameHint => 'เช่น hostname';

  @override
  String get variableEditorDefaultLabel => 'ค่าเริ่มต้น';

  @override
  String get variableEditorDefaultHint => 'ไม่บังคับ';

  @override
  String get variableFillTitle => 'กรอกตัวแปร';

  @override
  String variableFillHint(String name) {
    return 'ใส่ค่าสำหรับ $name';
  }

  @override
  String get variableFillPreview => 'ตัวอย่าง';

  @override
  String get terminalTitle => 'เทอร์มินัล';

  @override
  String get terminalEmpty => 'ไม่มีเซสชันที่ใช้งานอยู่';

  @override
  String get terminalEmptySubtitle =>
      'เชื่อมต่อกับโฮสต์เพื่อเปิดเซสชันเทอร์มินัล';

  @override
  String get terminalGoToHosts => 'ไปที่โฮสต์';

  @override
  String get terminalCloseAll => 'ปิดเซสชันทั้งหมด';

  @override
  String get terminalCloseTitle => 'ปิดเซสชัน';

  @override
  String terminalCloseMessage(String title) {
    return 'ปิดการเชื่อมต่อที่ใช้งานอยู่กับ \"$title\" หรือไม่?';
  }

  @override
  String get connectionAuthenticating => 'กำลังตรวจสอบสิทธิ์...';

  @override
  String connectionConnecting(String name) {
    return 'กำลังเชื่อมต่อกับ $name...';
  }

  @override
  String get connectionError => 'ข้อผิดพลาดการเชื่อมต่อ';

  @override
  String get connectionLost => 'การเชื่อมต่อหายไป';

  @override
  String get connectionReconnect => 'เชื่อมต่อใหม่';

  @override
  String get snippetQuickPanelTitle => 'แทรกสนิปเพ็ต';

  @override
  String get snippetQuickPanelSearch => 'ค้นหาสนิปเพ็ต...';

  @override
  String get snippetQuickPanelEmpty => 'ไม่มีสนิปเพ็ตที่พร้อมใช้งาน';

  @override
  String get snippetQuickPanelNoMatch => 'ไม่พบสนิปเพ็ตที่ตรงกัน';

  @override
  String get snippetQuickPanelInsertTooltip => 'แทรกสนิปเพ็ต';

  @override
  String get terminalThemePickerTitle => 'ธีมเทอร์มินัล';

  @override
  String get validatorHostnameRequired => 'จำเป็นต้องระบุชื่อโฮสต์';

  @override
  String get validatorHostnameInvalid => 'ชื่อโฮสต์หรือที่อยู่ IP ไม่ถูกต้อง';

  @override
  String get validatorPortRequired => 'จำเป็นต้องระบุพอร์ต';

  @override
  String get validatorPortRange => 'พอร์ตต้องอยู่ระหว่าง 1 ถึง 65535';

  @override
  String get validatorUsernameRequired => 'จำเป็นต้องระบุชื่อผู้ใช้';

  @override
  String get validatorUsernameInvalid => 'รูปแบบชื่อผู้ใช้ไม่ถูกต้อง';

  @override
  String get validatorServerNameRequired => 'จำเป็นต้องระบุชื่อเซิร์ฟเวอร์';

  @override
  String get validatorServerNameLength =>
      'ชื่อเซิร์ฟเวอร์ต้องไม่เกิน 100 ตัวอักษร';

  @override
  String get validatorSshKeyInvalid => 'รูปแบบคีย์ SSH ไม่ถูกต้อง';

  @override
  String get validatorPasswordRequired => 'จำเป็นต้องระบุรหัสผ่าน';

  @override
  String get validatorPasswordLength => 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร';

  @override
  String get authMethodPassword => 'รหัสผ่าน';

  @override
  String get authMethodKey => 'คีย์ SSH';

  @override
  String get authMethodBoth => 'รหัสผ่าน + คีย์';

  @override
  String get serverCopySuffix => '(สำเนา)';

  @override
  String get settingsDownloadLogs => 'ดาวน์โหลดบันทึก';

  @override
  String get settingsSendLogs => 'ส่งบันทึกไปยังฝ่ายสนับสนุน';

  @override
  String get settingsLogsSaved => 'บันทึกสำเร็จ';

  @override
  String get settingsUpdated => 'อัปเดตการตั้งค่าแล้ว';

  @override
  String get settingsThemeChanged => 'เปลี่ยนธีมแล้ว';

  @override
  String get settingsLanguageChanged => 'เปลี่ยนภาษาแล้ว';

  @override
  String get settingsPinSetSuccess => 'ตั้ง PIN แล้ว';

  @override
  String get settingsPinRemovedSuccess => 'ลบ PIN แล้ว';

  @override
  String get settingsDuressPinSetSuccess => 'ตั้งรหัสฉุกเฉินแล้ว';

  @override
  String get settingsDuressPinRemovedSuccess => 'ลบรหัสฉุกเฉินแล้ว';

  @override
  String get settingsBiometricEnabled => 'เปิดการปลดล็อกด้วยไบโอเมตริก';

  @override
  String get settingsBiometricDisabled => 'ปิดการปลดล็อกด้วยไบโอเมตริก';

  @override
  String get settingsDnsServerAdded => 'เพิ่มเซิร์ฟเวอร์ DNS แล้ว';

  @override
  String get settingsDnsServerRemoved => 'ลบเซิร์ฟเวอร์ DNS แล้ว';

  @override
  String get settingsDnsResetSuccess => 'รีเซ็ตเซิร์ฟเวอร์ DNS แล้ว';

  @override
  String get settingsFontSizeDecreaseTooltip => 'ลดขนาดตัวอักษร';

  @override
  String get settingsFontSizeIncreaseTooltip => 'เพิ่มขนาดตัวอักษร';

  @override
  String get settingsDnsRemoveServerTooltip => 'ลบเซิร์ฟเวอร์ DNS';

  @override
  String get settingsLogsEmpty => 'ไม่มีรายการบันทึก';

  @override
  String get authLogin => 'เข้าสู่ระบบ';

  @override
  String get authRegister => 'ลงทะเบียน';

  @override
  String get authForgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get authWhyLogin =>
      'เข้าสู่ระบบเพื่อเปิดใช้งานการซิงค์คลาวด์เข้ารหัสในทุกอุปกรณ์ แอปทำงานออฟไลน์ได้เต็มที่โดยไม่ต้องมีบัญชี';

  @override
  String get authEmailLabel => 'อีเมล';

  @override
  String get authEmailRequired => 'จำเป็นต้องระบุอีเมล';

  @override
  String get authEmailInvalid => 'ที่อยู่อีเมลไม่ถูกต้อง';

  @override
  String get authPasswordLabel => 'รหัสผ่าน';

  @override
  String get authConfirmPasswordLabel => 'ยืนยันรหัสผ่าน';

  @override
  String get authPasswordMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get authNoAccount => 'ไม่มีบัญชี?';

  @override
  String get authHasAccount => 'มีบัญชีอยู่แล้ว?';

  @override
  String get authResetEmailSent =>
      'หากมีบัญชีอยู่ ลิงก์รีเซ็ตจะถูกส่งไปยังอีเมลของคุณ';

  @override
  String get authResetDescription =>
      'ใส่ที่อยู่อีเมลแล้วเราจะส่งลิงก์เพื่อรีเซ็ตรหัสผ่านให้คุณ';

  @override
  String get authSendResetLink => 'ส่งลิงก์รีเซ็ต';

  @override
  String get authBackToLogin => 'กลับไปเข้าสู่ระบบ';

  @override
  String get syncPasswordTitle => 'รหัสผ่านซิงค์';

  @override
  String get syncPasswordTitleCreate => 'ตั้งรหัสผ่านซิงค์';

  @override
  String get syncPasswordTitleEnter => 'ใส่รหัสผ่านซิงค์';

  @override
  String get syncPasswordDescription =>
      'ตั้งรหัสผ่านแยกต่างหากเพื่อเข้ารหัสข้อมูลในตู้นิรภัย รหัสผ่านนี้จะไม่ออกจากอุปกรณ์ — เซิร์ฟเวอร์จัดเก็บเฉพาะข้อมูลที่เข้ารหัสแล้ว';

  @override
  String get syncPasswordHintEnter => 'ใส่รหัสผ่านที่คุณตั้งไว้เมื่อสร้างบัญชี';

  @override
  String get syncPasswordWarning =>
      'หากคุณลืมรหัสผ่านนี้ ข้อมูลที่ซิงค์จะไม่สามารถกู้คืนได้ ไม่มีตัวเลือกรีเซ็ต';

  @override
  String get syncPasswordLabel => 'รหัสผ่านซิงค์';

  @override
  String get syncPasswordWrong => 'รหัสผ่านผิด กรุณาลองอีกครั้ง';

  @override
  String get firstSyncTitle => 'พบข้อมูลที่มีอยู่';

  @override
  String get firstSyncMessage =>
      'อุปกรณ์นี้มีข้อมูลอยู่แล้วและเซิร์ฟเวอร์มีตู้นิรภัย ต้องการดำเนินการอย่างไร?';

  @override
  String get firstSyncMerge => 'รวม (เซิร์ฟเวอร์เป็นหลัก)';

  @override
  String get firstSyncOverwriteLocal => 'เขียนทับข้อมูลในเครื่อง';

  @override
  String get firstSyncKeepLocal => 'เก็บข้อมูลในเครื่องและส่งขึ้น';

  @override
  String get firstSyncDeleteLocal => 'ลบข้อมูลในเครื่องและดึงลงมา';

  @override
  String get changeEncryptionPassword => 'เปลี่ยนรหัสผ่านเข้ารหัส';

  @override
  String get changeEncryptionWarning =>
      'คุณจะถูกออกจากระบบบนอุปกรณ์อื่นทั้งหมด';

  @override
  String get changeEncryptionOldPassword => 'รหัสผ่านปัจจุบัน';

  @override
  String get changeEncryptionNewPassword => 'รหัสผ่านใหม่';

  @override
  String get changeEncryptionSuccess => 'เปลี่ยนรหัสผ่านสำเร็จ';

  @override
  String get logoutAllDevices => 'ออกจากระบบจากทุกอุปกรณ์';

  @override
  String get logoutAllDevicesConfirm =>
      'การดำเนินการนี้จะเพิกถอนเซสชันที่ใช้งานอยู่ทั้งหมด คุณจะต้องเข้าสู่ระบบใหม่บนทุกอุปกรณ์';

  @override
  String get logoutAllDevicesSuccess => 'ออกจากระบบทุกอุปกรณ์แล้ว';

  @override
  String get syncSettingsTitle => 'การตั้งค่าการซิงค์';

  @override
  String get syncAutoSync => 'ซิงค์อัตโนมัติ';

  @override
  String get syncAutoSyncDescription => 'ซิงค์อัตโนมัติเมื่อเปิดแอป';

  @override
  String get syncBackgroundSync => 'ซิงค์ในเบื้องหลัง';

  @override
  String get syncBackgroundSyncDescription =>
      'ซิงค์วอลต์เป็นระยะผ่าน WorkManager แม้แอปจะปิดอยู่';

  @override
  String get syncNow => 'ซิงค์ตอนนี้';

  @override
  String get syncSyncing => 'กำลังซิงค์...';

  @override
  String get syncSuccess => 'ซิงค์เสร็จสมบูรณ์';

  @override
  String get syncError => 'ข้อผิดพลาดการซิงค์';

  @override
  String get syncServerUnreachable => 'ไม่สามารถเข้าถึงเซิร์ฟเวอร์ได้';

  @override
  String get syncServerUnreachableHint =>
      'ไม่สามารถเข้าถึงเซิร์ฟเวอร์ซิงค์ได้ ตรวจสอบการเชื่อมต่ออินเทอร์เน็ตและ URL เซิร์ฟเวอร์';

  @override
  String get syncNetworkError =>
      'การเชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตหรือลองอีกครั้งในภายหลัง';

  @override
  String get syncNeverSynced => 'ไม่เคยซิงค์';

  @override
  String get syncVaultVersion => 'เวอร์ชันตู้นิรภัย';

  @override
  String get syncTitle => 'ซิงค์';

  @override
  String get settingsSectionNetwork => 'เครือข่ายและ DNS';

  @override
  String get settingsDnsServers => 'เซิร์ฟเวอร์ DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'ค่าเริ่มต้น (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'ใส่ URL เซิร์ฟเวอร์ DoH แบบกำหนดเอง คั่นด้วยเครื่องหมายจุลภาค ต้องใช้เซิร์ฟเวอร์อย่างน้อย 2 แห่งสำหรับการตรวจสอบข้ามกัน';

  @override
  String get settingsDnsLabel => 'URL เซิร์ฟเวอร์ DoH';

  @override
  String get settingsDnsReset => 'รีเซ็ตเป็นค่าเริ่มต้น';

  @override
  String get settingsSectionSync => 'การซิงค์';

  @override
  String get settingsSyncAccount => 'บัญชี';

  @override
  String get settingsSyncNotLoggedIn => 'ไม่ได้เข้าสู่ระบบ';

  @override
  String get settingsSyncStatus => 'ซิงค์';

  @override
  String get settingsSyncServerUrl => 'URL เซิร์ฟเวอร์';

  @override
  String get settingsSyncDefaultServer => 'ค่าเริ่มต้น (sshvault.app)';

  @override
  String get accountTitle => 'บัญชี';

  @override
  String get accountNotLoggedIn => 'ไม่ได้เข้าสู่ระบบ';

  @override
  String get accountVerified => 'ยืนยันแล้ว';

  @override
  String get accountMemberSince => 'เป็นสมาชิกตั้งแต่';

  @override
  String get accountDevices => 'อุปกรณ์';

  @override
  String get accountNoDevices => 'ไม่มีอุปกรณ์ที่ลงทะเบียน';

  @override
  String get accountLastSync => 'ซิงค์ล่าสุด';

  @override
  String get accountChangePassword => 'เปลี่ยนรหัสผ่าน';

  @override
  String get accountOldPassword => 'รหัสผ่านปัจจุบัน';

  @override
  String get accountNewPassword => 'รหัสผ่านใหม่';

  @override
  String get accountDeleteAccount => 'ลบบัญชี';

  @override
  String get accountDeleteWarning =>
      'การดำเนินการนี้จะลบบัญชีและข้อมูลซิงค์ทั้งหมดอย่างถาวร ไม่สามารถย้อนกลับได้';

  @override
  String get accountLogout => 'ออกจากระบบ';

  @override
  String get serverConfigTitle => 'การกำหนดค่าเซิร์ฟเวอร์';

  @override
  String get serverConfigUrlLabel => 'URL เซิร์ฟเวอร์';

  @override
  String get serverConfigTest => 'ทดสอบการเชื่อมต่อ';

  @override
  String get serverSetupTitle => 'ตั้งค่าเซิร์ฟเวอร์';

  @override
  String get serverSetupInfoCard =>
      'ShellVault ต้องการเซิร์ฟเวอร์ที่โฮสต์เองสำหรับการซิงค์แบบเข้ารหัสจากต้นทางถึงปลายทาง ปรับใช้อินสแตนซ์ของคุณเองเพื่อเริ่มต้น';

  @override
  String get serverSetupRepoLink => 'ดูบน GitHub';

  @override
  String get serverSetupContinue => 'ดำเนินการต่อ';

  @override
  String get settingsServerNotConfigured => 'ยังไม่ได้กำหนดค่าเซิร์ฟเวอร์';

  @override
  String get settingsSetupSync => 'ตั้งค่าการซิงค์เพื่อสำรองข้อมูลของคุณ';

  @override
  String get settingsChangeServer => 'เปลี่ยนเซิร์ฟเวอร์';

  @override
  String get settingsChangeServerConfirm =>
      'การเปลี่ยนเซิร์ฟเวอร์จะทำให้คุณออกจากระบบ ดำเนินการต่อหรือไม่?';

  @override
  String get auditLogTitle => 'บันทึกกิจกรรม';

  @override
  String get auditLogAll => 'ทั้งหมด';

  @override
  String get auditLogEmpty => 'ไม่พบบันทึกกิจกรรม';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'จัดการไฟล์';

  @override
  String get sftpLocalDevice => 'อุปกรณ์ในเครื่อง';

  @override
  String get sftpSelectServer => 'เลือกเซิร์ฟเวอร์...';

  @override
  String get sftpConnecting => 'กำลังเชื่อมต่อ...';

  @override
  String get sftpEmptyDirectory => 'ไดเรกทอรีนี้ว่างเปล่า';

  @override
  String get sftpNoConnection => 'ไม่มีเซิร์ฟเวอร์ที่เชื่อมต่อ';

  @override
  String get sftpPathLabel => 'เส้นทาง';

  @override
  String get sftpUpload => 'อัปโหลด';

  @override
  String get sftpDownload => 'ดาวน์โหลด';

  @override
  String get sftpDelete => 'ลบ';

  @override
  String get sftpRename => 'เปลี่ยนชื่อ';

  @override
  String get sftpNewFolder => 'โฟลเดอร์ใหม่';

  @override
  String get sftpNewFolderName => 'ชื่อโฟลเดอร์';

  @override
  String get sftpChmod => 'สิทธิ์';

  @override
  String get sftpChmodTitle => 'เปลี่ยนสิทธิ์';

  @override
  String get sftpChmodOctal => 'Octal';

  @override
  String get sftpChmodOwner => 'เจ้าของ';

  @override
  String get sftpChmodGroup => 'กลุ่ม';

  @override
  String get sftpChmodOther => 'อื่นๆ';

  @override
  String get sftpChmodRead => 'อ่าน';

  @override
  String get sftpChmodWrite => 'เขียน';

  @override
  String get sftpChmodExecute => 'ประมวลผล';

  @override
  String get sftpCreateSymlink => 'สร้าง Symlink';

  @override
  String get sftpSymlinkTarget => 'เส้นทางเป้าหมาย';

  @override
  String get sftpSymlinkName => 'ชื่อลิงก์';

  @override
  String get sftpFilePreview => 'ดูตัวอย่างไฟล์';

  @override
  String get sftpFileInfo => 'ข้อมูลไฟล์';

  @override
  String get sftpFileSize => 'ขนาด';

  @override
  String get sftpFileModified => 'แก้ไขเมื่อ';

  @override
  String get sftpFilePermissions => 'สิทธิ์';

  @override
  String get sftpFileOwner => 'เจ้าของ';

  @override
  String get sftpFileType => 'ประเภท';

  @override
  String get sftpFileLinkTarget => 'เป้าหมายลิงก์';

  @override
  String get sftpTransfers => 'การถ่ายโอน';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current จาก $total';
  }

  @override
  String get sftpTransferQueued => 'อยู่ในคิว';

  @override
  String get sftpTransferActive => 'กำลังถ่ายโอน...';

  @override
  String get sftpTransferPaused => 'หยุดชั่วคราว';

  @override
  String get sftpTransferCompleted => 'เสร็จสมบูรณ์';

  @override
  String get sftpTransferFailed => 'ล้มเหลว';

  @override
  String get sftpTransferCancelled => 'ยกเลิกแล้ว';

  @override
  String get sftpPauseTransfer => 'หยุดชั่วคราว';

  @override
  String get sftpResumeTransfer => 'ดำเนินการต่อ';

  @override
  String get sftpCancelTransfer => 'ยกเลิก';

  @override
  String get sftpClearCompleted => 'ล้างรายการเสร็จสมบูรณ์';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active จาก $total การถ่ายโอน';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count กำลังทำงาน',
      one: '1 กำลังทำงาน',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count เสร็จสมบูรณ์',
      one: '1 เสร็จสมบูรณ์',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ล้มเหลว',
      one: '1 ล้มเหลว',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'คัดลอกไปยังแผงอื่น';

  @override
  String sftpConfirmDelete(int count) {
    return 'ลบ $count รายการ?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'ลบ \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'ลบสำเร็จ';

  @override
  String get sftpRenameTitle => 'เปลี่ยนชื่อ';

  @override
  String get sftpRenameLabel => 'ชื่อใหม่';

  @override
  String get sftpSortByName => 'ชื่อ';

  @override
  String get sftpSortBySize => 'ขนาด';

  @override
  String get sftpSortByDate => 'วันที่';

  @override
  String get sftpSortByType => 'ประเภท';

  @override
  String get sftpShowHidden => 'แสดงไฟล์ที่ซ่อน';

  @override
  String get sftpHideHidden => 'ซ่อนไฟล์ที่ซ่อน';

  @override
  String get sftpSelectAll => 'เลือกทั้งหมด';

  @override
  String get sftpDeselectAll => 'ยกเลิกการเลือกทั้งหมด';

  @override
  String sftpItemsSelected(int count) {
    return 'เลือก $count รายการ';
  }

  @override
  String get sftpRefresh => 'รีเฟรช';

  @override
  String sftpConnectionError(String message) {
    return 'การเชื่อมต่อล้มเหลว: $message';
  }

  @override
  String get sftpPermissionDenied => 'ไม่ได้รับอนุญาต';

  @override
  String sftpOperationFailed(String message) {
    return 'การดำเนินการล้มเหลว: $message';
  }

  @override
  String get sftpOverwriteTitle => 'ไฟล์มีอยู่แล้ว';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" มีอยู่แล้ว เขียนทับหรือไม่?';
  }

  @override
  String get sftpOverwrite => 'เขียนทับ';

  @override
  String sftpTransferStarted(String fileName) {
    return 'เริ่มถ่ายโอน: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'เลือกปลายทางในแผงอื่นก่อน';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'การถ่ายโอนไดเรกทอรีจะมาเร็วๆ นี้';

  @override
  String get sftpSelect => 'เลือก';

  @override
  String get sftpOpen => 'เปิด';

  @override
  String get sftpExtractArchive => 'แตกไฟล์ที่นี่';

  @override
  String get sftpExtractSuccess => 'แตกไฟล์สำเร็จ';

  @override
  String sftpExtractFailed(String message) {
    return 'การแตกไฟล์ล้มเหลว: $message';
  }

  @override
  String get sftpExtractUnsupported => 'รูปแบบไฟล์บีบอัดไม่รองรับ';

  @override
  String get sftpExtracting => 'กำลังแตกไฟล์...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เริ่มอัปโหลด $count รายการ',
      one: 'เริ่มอัปโหลด',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'เริ่มดาวน์โหลด $count รายการ',
      one: 'เริ่มดาวน์โหลด',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return 'ดาวน์โหลด \"$fileName\" แล้ว';
  }

  @override
  String get sftpSavedToDownloads => 'บันทึกไปที่ Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'บันทึกไปที่ไฟล์';

  @override
  String get sftpFileSaved => 'บันทึกไฟล์แล้ว';

  @override
  String get fileChooserOpenFile => 'เปิดไฟล์';

  @override
  String get fileChooserSaveFile => 'บันทึกไฟล์';

  @override
  String get fileChooserOpenDirectory => 'เลือกโฟลเดอร์';

  @override
  String get fileChooserImportArchive => 'นำเข้าข้อมูลสำรอง';

  @override
  String get fileChooserImportSshConfig => 'นำเข้าการกำหนดค่า SSH';

  @override
  String get fileChooserImportSettings => 'นำเข้าการตั้งค่า';

  @override
  String get fileChooserPickKeyFile => 'เลือกไฟล์คีย์ SSH';

  @override
  String get fileChooserUploadFiles => 'อัปโหลดไฟล์';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count เซสชัน SSH ที่ใช้งานอยู่',
      one: 'เซสชัน SSH ที่ใช้งานอยู่',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'แตะเพื่อเปิดเทอร์มินัล';

  @override
  String get settingsAccountAndSync => 'บัญชีและซิงค์';

  @override
  String get settingsAccountSubtitleAuth => 'เข้าสู่ระบบแล้ว';

  @override
  String get settingsAccountSubtitleUnauth => 'ไม่ได้เข้าสู่ระบบ';

  @override
  String get settingsSecuritySubtitle => 'ล็อกอัตโนมัติ, ไบโอเมตริก, PIN';

  @override
  String get settingsSshSubtitle => 'พอร์ต 22, ผู้ใช้ root';

  @override
  String get settingsAppearanceSubtitle => 'ธีม, ภาษา, เทอร์มินัล';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'ค่าเริ่มต้นส่งออกเข้ารหัส';

  @override
  String get settingsAboutSubtitle => 'เวอร์ชัน, ใบอนุญาต';

  @override
  String get settingsSearchHint => 'ค้นหาการตั้งค่า...';

  @override
  String get settingsSearchNoResults => 'ไม่พบการตั้งค่า';

  @override
  String get aboutDeveloper => 'พัฒนาโดย Kiefer Networks';

  @override
  String get aboutDonate => 'บริจาค';

  @override
  String get aboutOpenSourceLicenses => 'ใบอนุญาตโอเพนซอร์ส';

  @override
  String get aboutWebsite => 'เว็บไซต์';

  @override
  String get aboutVersion => 'เวอร์ชัน';

  @override
  String get aboutBuild => 'บิลด์';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS เข้ารหัสการสอบถาม DNS และป้องกันการปลอมแปลง DNS SSHVault ตรวจสอบชื่อโฮสต์กับผู้ให้บริการหลายรายเพื่อตรวจจับการโจมตี';

  @override
  String get settingsDnsAddServer => 'เพิ่มเซิร์ฟเวอร์ DNS';

  @override
  String get settingsDnsServerUrl => 'URL เซิร์ฟเวอร์';

  @override
  String get settingsDnsDefaultBadge => 'ค่าเริ่มต้น';

  @override
  String get settingsDnsResetDefaults => 'รีเซ็ตเป็นค่าเริ่มต้น';

  @override
  String get settingsDnsInvalidUrl => 'กรุณาใส่ URL HTTPS ที่ถูกต้อง';

  @override
  String get settingsDefaultAuthMethod => 'วิธีการตรวจสอบสิทธิ์';

  @override
  String get settingsAuthPassword => 'รหัสผ่าน';

  @override
  String get settingsAuthKey => 'คีย์ SSH';

  @override
  String get settingsConnectionTimeout => 'หมดเวลาการเชื่อมต่อ';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '$seconds วินาที';
  }

  @override
  String get settingsKeepaliveInterval => 'ช่วง Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '$seconds วินาที';
  }

  @override
  String get settingsCompression => 'การบีบอัด';

  @override
  String get settingsCompressionDescription =>
      'เปิดใช้งานการบีบอัด zlib สำหรับการเชื่อมต่อ SSH';

  @override
  String get settingsTerminalType => 'ประเภทเทอร์มินัล';

  @override
  String get settingsSectionConnection => 'การเชื่อมต่อ';

  @override
  String get settingsClipboardAutoClear => 'ล้างคลิปบอร์ดอัตโนมัติ';

  @override
  String get settingsClipboardAutoClearOff => 'ปิด';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '$seconds วินาที';
  }

  @override
  String get settingsSessionTimeout => 'หมดเวลาเซสชัน';

  @override
  String get settingsSessionTimeoutOff => 'ปิด';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes นาที';
  }

  @override
  String get settingsDuressPin => 'PIN ฉุกเฉิน';

  @override
  String get settingsDuressPinDescription =>
      'PIN แยกต่างหากที่ลบข้อมูลทั้งหมดเมื่อป้อน';

  @override
  String get settingsDuressPinSet => 'ตั้ง PIN ฉุกเฉินแล้ว';

  @override
  String get settingsDuressPinNotSet => 'ไม่ได้กำหนดค่า';

  @override
  String get settingsDuressPinWarning =>
      'การป้อน PIN นี้จะลบข้อมูลในเครื่องทั้งหมดอย่างถาวร รวมถึงข้อมูลรับรอง คีย์ และการตั้งค่า ไม่สามารถย้อนกลับได้';

  @override
  String get settingsKeyRotationReminder => 'แจ้งเตือนการหมุนเวียนคีย์';

  @override
  String get settingsKeyRotationOff => 'ปิด';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days วัน';
  }

  @override
  String get settingsFailedAttempts => 'ความพยายาม PIN ที่ล้มเหลว';

  @override
  String get settingsSectionAppLock => 'ล็อกแอป';

  @override
  String get settingsSectionPrivacy => 'ความเป็นส่วนตัว';

  @override
  String get settingsSectionReminders => 'การแจ้งเตือน';

  @override
  String get settingsSectionStatus => 'สถานะ';

  @override
  String get settingsExportBackupSubtitle => 'ส่งออก, นำเข้าและสำรองข้อมูล';

  @override
  String get settingsExportJson => 'ส่งออกเป็น JSON';

  @override
  String get settingsExportEncrypted => 'ส่งออกแบบเข้ารหัส';

  @override
  String get settingsImportFile => 'นำเข้าจากไฟล์';

  @override
  String get settingsSectionImport => 'นำเข้า';

  @override
  String get filterTitle => 'กรองเซิร์ฟเวอร์';

  @override
  String get filterApply => 'ใช้ตัวกรอง';

  @override
  String get filterClearAll => 'ล้างทั้งหมด';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ตัวกรองที่ใช้งาน',
      one: '1 ตัวกรองที่ใช้งาน',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'โฟลเดอร์';

  @override
  String get filterTags => 'แท็ก';

  @override
  String get filterStatus => 'สถานะ';

  @override
  String get variablePreviewResolved => 'ตัวอย่างที่แก้ไขแล้ว';

  @override
  String get variableInsert => 'แทรก';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count เซิร์ฟเวอร์',
      one: '1 เซิร์ฟเวอร์',
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
      other: 'เพิกถอน $count เซสชัน',
      one: 'เพิกถอน 1 เซสชัน',
    );
    return '$_temp0 คุณถูกออกจากระบบแล้ว';
  }

  @override
  String get keyGenPassphrase => 'วลีรหัสผ่าน';

  @override
  String get keyGenPassphraseHint => 'ไม่บังคับ — ปกป้องคีย์ส่วนตัว';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'ค่าเริ่มต้น (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'คีย์ที่มีลายนิ้วมือเดียวกันมีอยู่แล้ว: \"$name\" คีย์ SSH แต่ละคีย์ต้องไม่ซ้ำกัน';
  }

  @override
  String get sshKeyFingerprint => 'ลายนิ้วมือ';

  @override
  String get sshKeyPublicKey => 'คีย์สาธารณะ';

  @override
  String get jumpHost => 'โฮสต์กลาง';

  @override
  String get jumpHostNone => 'ไม่มี';

  @override
  String get jumpHostLabel => 'เชื่อมต่อผ่านโฮสต์กลาง';

  @override
  String get jumpHostSelfError =>
      'เซิร์ฟเวอร์ไม่สามารถเป็นโฮสต์กลางของตัวเองได้';

  @override
  String get jumpHostConnecting => 'กำลังเชื่อมต่อกับโฮสต์กลาง...';

  @override
  String get jumpHostCircularError => 'ตรวจพบห่วงโซ่โฮสต์กลางแบบวงกลม';

  @override
  String get logoutDialogTitle => 'ออกจากระบบ';

  @override
  String get logoutDialogMessage =>
      'คุณต้องการลบข้อมูลในเครื่องทั้งหมดหรือไม่? เซิร์ฟเวอร์ คีย์ SSH สนิปเพ็ต และการตั้งค่าจะถูกลบออกจากอุปกรณ์นี้';

  @override
  String get logoutOnly => 'ออกจากระบบเท่านั้น';

  @override
  String get logoutAndDelete => 'ออกจากระบบและลบข้อมูล';

  @override
  String get changeAvatar => 'เปลี่ยนรูปโปรไฟล์';

  @override
  String get removeAvatar => 'ลบรูปโปรไฟล์';

  @override
  String get avatarUploadFailed => 'อัปโหลดรูปโปรไฟล์ล้มเหลว';

  @override
  String get avatarTooLarge => 'รูปภาพมีขนาดใหญ่เกินไป';

  @override
  String get deviceLastSeen => 'เห็นล่าสุด';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'ไม่สามารถเปลี่ยน URL เซิร์ฟเวอร์ขณะเข้าสู่ระบบ ออกจากระบบก่อน';

  @override
  String get serverListNoFolder => 'ไม่จัดหมวดหมู่';

  @override
  String get autoSyncInterval => 'ช่วงเวลาซิงค์';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes นาที';
  }

  @override
  String get proxySettings => 'การตั้งค่าพร็อกซี';

  @override
  String get proxyType => 'ประเภทพร็อกซี';

  @override
  String get proxyNone => 'ไม่มีพร็อกซี';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'โฮสต์พร็อกซี';

  @override
  String get proxyPort => 'พอร์ตพร็อกซี';

  @override
  String get proxyUsername => 'ชื่อผู้ใช้พร็อกซี';

  @override
  String get proxyPassword => 'รหัสผ่านพร็อกซี';

  @override
  String get proxyUseGlobal => 'ใช้พร็อกซีทั่วไป';

  @override
  String get proxyGlobal => 'ทั่วไป';

  @override
  String get proxyServerSpecific => 'เฉพาะเซิร์ฟเวอร์';

  @override
  String get proxyTestConnection => 'ทดสอบการเชื่อมต่อ';

  @override
  String get proxyTestSuccess => 'เข้าถึงพร็อกซีได้';

  @override
  String get proxyTestFailed => 'ไม่สามารถเข้าถึงพร็อกซี';

  @override
  String get proxyDefaultProxy => 'พร็อกซีเริ่มต้น';

  @override
  String get vpnRequired => 'จำเป็นต้องใช้ VPN';

  @override
  String get vpnRequiredTooltip =>
      'แสดงคำเตือนเมื่อเชื่อมต่อโดยไม่มี VPN ที่ใช้งานอยู่';

  @override
  String get vpnActive => 'VPN ใช้งานอยู่';

  @override
  String get vpnInactive => 'VPN ไม่ได้ใช้งาน';

  @override
  String get vpnWarningTitle => 'VPN ไม่ได้ใช้งาน';

  @override
  String get vpnWarningMessage =>
      'เซิร์ฟเวอร์นี้ระบุว่าต้องการการเชื่อมต่อ VPN แต่ขณะนี้ไม่มี VPN ที่ใช้งานอยู่ คุณต้องการเชื่อมต่อต่อไปหรือไม่?';

  @override
  String get vpnConnectAnyway => 'เชื่อมต่อต่อไป';

  @override
  String get postConnectCommands => 'คำสั่งหลังเชื่อมต่อ';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'คำสั่งที่ทำงานอัตโนมัติหลังเชื่อมต่อ (บรรทัดละคำสั่ง)';

  @override
  String get dashboardFavorites => 'รายการโปรด';

  @override
  String get dashboardRecent => 'ล่าสุด';

  @override
  String get dashboardActiveSessions => 'เซสชันที่ใช้งานอยู่';

  @override
  String get addToFavorites => 'เพิ่มในรายการโปรด';

  @override
  String get removeFromFavorites => 'ลบออกจากรายการโปรด';

  @override
  String get noRecentConnections => 'ไม่มีการเชื่อมต่อล่าสุด';

  @override
  String get terminalSplit => 'มุมมองแยก';

  @override
  String get terminalUnsplit => 'ปิดมุมมองแยก';

  @override
  String get terminalSelectSession => 'เลือกเซสชันสำหรับมุมมองแยก';

  @override
  String get knownHostsTitle => 'โฮสต์ที่รู้จัก';

  @override
  String get knownHostsSubtitle => 'จัดการลายนิ้วมือเซิร์ฟเวอร์ที่เชื่อถือได้';

  @override
  String get hostKeyNewTitle => 'โฮสต์ใหม่';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'การเชื่อมต่อครั้งแรกกับ $hostname:$port ตรวจสอบลายนิ้วมือก่อนเชื่อมต่อ';
  }

  @override
  String get hostKeyChangedTitle => 'คีย์โฮสต์เปลี่ยนแปลง!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'คีย์โฮสต์สำหรับ $hostname:$port มีการเปลี่ยนแปลง สิ่งนี้อาจบ่งบอกถึงภัยคุกคามด้านความปลอดภัย';
  }

  @override
  String get hostKeyFingerprint => 'ลายนิ้วมือ';

  @override
  String get hostKeyType => 'ประเภทคีย์';

  @override
  String get hostKeyTrustConnect => 'เชื่อถือและเชื่อมต่อ';

  @override
  String get hostKeyAcceptNew => 'ยอมรับคีย์ใหม่';

  @override
  String get hostKeyReject => 'ปฏิเสธ';

  @override
  String get hostKeyPreviousFingerprint => 'ลายนิ้วมือก่อนหน้า';

  @override
  String get hostKeyDeleteAll => 'ลบโฮสต์ที่รู้จักทั้งหมด';

  @override
  String get hostKeyDeleteConfirm =>
      'คุณแน่ใจหรือว่าต้องการลบโฮสต์ที่รู้จักทั้งหมด? คุณจะถูกถามอีกครั้งเมื่อเชื่อมต่อครั้งถัดไป';

  @override
  String get hostKeyEmpty => 'ยังไม่มีโฮสต์ที่รู้จัก';

  @override
  String get hostKeyEmptySubtitle =>
      'ลายนิ้วมือโฮสต์จะถูกเก็บที่นี่หลังจากการเชื่อมต่อครั้งแรก';

  @override
  String get hostKeyFirstSeen => 'พบครั้งแรก';

  @override
  String get hostKeyLastSeen => 'พบล่าสุด';

  @override
  String get sshConfigImportTitle => 'นำเข้าการตั้งค่า SSH';

  @override
  String get sshConfigImportPickFile => 'เลือกไฟล์การตั้งค่า SSH';

  @override
  String get sshConfigImportOrPaste => 'หรือวางเนื้อหาการตั้งค่า';

  @override
  String sshConfigImportParsed(int count) {
    return 'พบ $count โฮสต์';
  }

  @override
  String get sshConfigImportButton => 'นำเข้า';

  @override
  String sshConfigImportSuccess(int count) {
    return 'นำเข้า $count เซิร์ฟเวอร์แล้ว';
  }

  @override
  String get sshConfigImportDuplicate => 'มีอยู่แล้ว';

  @override
  String get sshConfigImportNoHosts => 'ไม่พบโฮสต์ในการตั้งค่า';

  @override
  String get sftpBookmarkAdd => 'เพิ่มบุ๊กมาร์ก';

  @override
  String get sftpBookmarkLabel => 'ป้ายกำกับ';

  @override
  String get disconnect => 'ตัดการเชื่อมต่อ';

  @override
  String get reportAndDisconnect => 'รายงานและตัดการเชื่อมต่อ';

  @override
  String get continueAnyway => 'ดำเนินการต่อ';

  @override
  String get insertSnippet => 'แทรกสนิปเพ็ต';

  @override
  String get seconds => 'วินาที';

  @override
  String get heartbeatLostMessage =>
      'ไม่สามารถเข้าถึงเซิร์ฟเวอร์ได้หลังจากพยายามหลายครั้ง เพื่อความปลอดภัยของคุณ เซสชันถูกยุติแล้ว';

  @override
  String get attestationFailedTitle => 'การตรวจสอบเซิร์ฟเวอร์ล้มเหลว';

  @override
  String get attestationFailedMessage =>
      'ไม่สามารถยืนยันเซิร์ฟเวอร์ว่าเป็นแบ็กเอนด์ SSHVault ที่ถูกต้อง สิ่งนี้อาจบ่งบอกถึงการโจมตีแบบ man-in-the-middle หรือเซิร์ฟเวอร์ที่กำหนดค่าไม่ถูกต้อง';

  @override
  String get attestationKeyChangedTitle =>
      'คีย์การรับรองเซิร์ฟเวอร์เปลี่ยนแปลง';

  @override
  String get attestationKeyChangedMessage =>
      'คีย์การรับรองของเซิร์ฟเวอร์มีการเปลี่ยนแปลงตั้งแต่การเชื่อมต่อครั้งแรก สิ่งนี้อาจบ่งบอกถึงการโจมตีแบบ man-in-the-middle อย่าดำเนินการต่อเว้นแต่ผู้ดูแลเซิร์ฟเวอร์ยืนยันการหมุนเวียนคีย์';

  @override
  String get sectionLinks => 'ลิงก์';

  @override
  String get sectionDeveloper => 'นักพัฒนา';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'ไม่พบหน้า';

  @override
  String get connectionTestSuccess => 'เชื่อมต่อสำเร็จ';

  @override
  String connectionTestFailed(String message) {
    return 'การเชื่อมต่อล้มเหลว: $message';
  }

  @override
  String get serverVerificationFailed => 'การตรวจสอบเซิร์ฟเวอร์ล้มเหลว';

  @override
  String get importSuccessful => 'นำเข้าสำเร็จ';

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
  String get deviceDeleteConfirmTitle => 'ลบอุปกรณ์';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'คุณแน่ใจหรือไม่ว่าต้องการลบ \"$name\"? อุปกรณ์จะถูกออกจากระบบทันที';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'นี่คืออุปกรณ์ปัจจุบันของคุณ คุณจะถูกออกจากระบบทันที';

  @override
  String get deviceDeleteSuccess => 'ลบอุปกรณ์แล้ว';

  @override
  String get deviceDeletedCurrentLogout =>
      'ลบอุปกรณ์ปัจจุบันแล้ว คุณออกจากระบบแล้ว';

  @override
  String get thisDevice => 'อุปกรณ์นี้';
}
