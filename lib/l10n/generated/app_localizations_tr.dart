// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Sunucular';

  @override
  String get navSnippets => 'Kod Parçaları';

  @override
  String get navFolders => 'Klasörler';

  @override
  String get navTags => 'Etiketler';

  @override
  String get navSshKeys => 'SSH Anahtarları';

  @override
  String get navExportImport => 'Dışa / İçe Aktar';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Diğer';

  @override
  String get navManagement => 'Yönetim';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get navAbout => 'Hakkında';

  @override
  String get lockScreenTitle => 'SSHVault kilitli';

  @override
  String get lockScreenUnlock => 'Kilidi Aç';

  @override
  String get lockScreenEnterPin => 'PIN girin';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Çok fazla başarısız deneme. $minutes dk sonra tekrar deneyin.';
  }

  @override
  String get pinDialogSetTitle => 'PIN Kodu Belirle';

  @override
  String get pinDialogSetSubtitle =>
      'SSHVault\'u korumak için 6 haneli bir PIN girin';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'PIN\'i Onayla';

  @override
  String get pinDialogErrorLength => 'PIN tam olarak 6 haneli olmalıdır';

  @override
  String get pinDialogErrorMismatch => 'PIN\'ler eşleşmiyor';

  @override
  String get pinDialogVerifyTitle => 'PIN Girin';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'Yanlış PIN. $attempts deneme kaldı.';
  }

  @override
  String get securityBannerMessage =>
      'SSH kimlik bilgileriniz korunmuyor. Ayarlar\'da PIN veya biyometrik kilit ayarlayın.';

  @override
  String get securityBannerDismiss => 'Kapat';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsSectionAppearance => 'Görünüm';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'SSH Varsayılanları';

  @override
  String get settingsSectionSecurity => 'Güvenlik';

  @override
  String get settingsSectionExport => 'Dışa Aktarma';

  @override
  String get settingsSectionAbout => 'Hakkında';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get settingsThemeLight => 'Açık';

  @override
  String get settingsThemeDark => 'Koyu';

  @override
  String get settingsTerminalTheme => 'Terminal Teması';

  @override
  String get settingsTerminalThemeDefault => 'Varsayılan Koyu';

  @override
  String get settingsFontSize => 'Yazı Tipi Boyutu';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Varsayılan Port';

  @override
  String get settingsDefaultPortDialog => 'Varsayılan SSH Portu';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Varsayılan Kullanıcı Adı';

  @override
  String get settingsDefaultUsernameDialog => 'Varsayılan Kullanıcı Adı';

  @override
  String get settingsUsernameLabel => 'Kullanıcı Adı';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Otomatik Kilitleme Süresi';

  @override
  String get settingsAutoLockDisabled => 'Devre Dışı';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes dakika';
  }

  @override
  String get settingsAutoLockOff => 'Kapalı';

  @override
  String get settingsAutoLock1Min => '1 dk';

  @override
  String get settingsAutoLock5Min => '5 dk';

  @override
  String get settingsAutoLock15Min => '15 dk';

  @override
  String get settingsAutoLock30Min => '30 dk';

  @override
  String get settingsBiometricUnlock => 'Biyometrik Kilit Açma';

  @override
  String get settingsBiometricNotAvailable => 'Bu cihazda kullanılamıyor';

  @override
  String get settingsBiometricError => 'Biyometri denetimi hatası';

  @override
  String get settingsBiometricReason =>
      'Biyometrik kilit açmayı etkinleştirmek için kimliğinizi doğrulayın';

  @override
  String get settingsBiometricRequiresPin =>
      'Biyometrik kilit açmayı etkinleştirmek için önce PIN belirleyin';

  @override
  String get settingsPinCode => 'PIN Kodu';

  @override
  String get settingsPinIsSet => 'PIN belirlendi';

  @override
  String get settingsPinNotConfigured => 'PIN yapılandırılmadı';

  @override
  String get settingsPinRemove => 'Kaldır';

  @override
  String get settingsPinRemoveWarning =>
      'PIN\'i kaldırmak tüm veritabanı alanlarını şifre çözecek ve biyometrik kilit açmayı devre dışı bırakacak. Devam edilsin mi?';

  @override
  String get settingsPinRemoveTitle => 'PIN\'i Kaldır';

  @override
  String get settingsPreventScreenshots => 'Ekran Görüntülerini Engelle';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Ekran görüntüsü ve ekran kaydını engelle';

  @override
  String get settingsEncryptExport =>
      'Dışa Aktarmaları Varsayılan Olarak Şifrele';

  @override
  String get settingsAbout => 'SSHVault Hakkında';

  @override
  String get settingsAboutLegalese => 'Kiefer Networks tarafından';

  @override
  String get settingsAboutDescription =>
      'Güvenli, Kendi Sunucunuzda Barındırılan SSH İstemcisi';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsLanguageSystem => 'Sistem';

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
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get delete => 'Sil';

  @override
  String get close => 'Kapat';

  @override
  String get update => 'Güncelle';

  @override
  String get create => 'Oluştur';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get copy => 'Kopyala';

  @override
  String get edit => 'Düzenle';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Hata: $message';
  }

  @override
  String get serverListTitle => 'Sunucular';

  @override
  String get serverListEmpty => 'Henüz sunucu yok';

  @override
  String get serverListEmptySubtitle =>
      'Başlamak için ilk SSH sunucunuzu ekleyin.';

  @override
  String get serverAddButton => 'Sunucu Ekle';

  @override
  String get sshConfigImportTitle => 'SSH Yapılandırmasını İçe Aktar';

  @override
  String sshConfigImportMessage(int count) {
    return '~/.ssh/config dosyasında $count sunucu bulundu. İçe aktarılsın mı?';
  }

  @override
  String get sshConfigImportButton => 'Seçilenleri İçe Aktar';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count sunucu içe aktarıldı';
  }

  @override
  String get sshConfigNotFound => 'SSH yapılandırma dosyası bulunamadı';

  @override
  String get sshConfigEmpty => 'SSH yapılandırmasında sunucu bulunamadı';

  @override
  String get sshConfigAddManually => 'Manuel Ekle';

  @override
  String get sshConfigImportAgain => 'SSH yapılandırmasını tekrar içe aktar?';

  @override
  String get sshConfigImportKeys =>
      'Seçilen sunucuların referans verdiği SSH anahtarları içe aktarılsın mı?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count SSH anahtarı içe aktarıldı';
  }

  @override
  String get serverDuplicated => 'Sunucu kopyalandı';

  @override
  String get serverDeleteTitle => 'Sunucuyu Sil';

  @override
  String serverDeleteMessage(String name) {
    return '\"$name\" silinsin mi? Bu işlem geri alınamaz.';
  }

  @override
  String serverDeleteShort(String name) {
    return '\"$name\" silinsin mi?';
  }

  @override
  String get serverConnect => 'Bağlan';

  @override
  String get serverDetails => 'Detaylar';

  @override
  String get serverDuplicate => 'Kopyala';

  @override
  String get serverActive => 'Aktif';

  @override
  String get serverNoFolder => 'Klasör Yok';

  @override
  String get serverFormTitleEdit => 'Sunucuyu Düzenle';

  @override
  String get serverFormTitleAdd => 'Sunucu Ekle';

  @override
  String get serverFormUpdateButton => 'Sunucuyu Güncelle';

  @override
  String get serverFormAddButton => 'Sunucu Ekle';

  @override
  String get serverFormPublicKeyExtracted => 'Açık anahtar başarıyla çıkarıldı';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Açık anahtar çıkarılamadı: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return '$type anahtar çifti oluşturuldu';
  }

  @override
  String get serverDetailTitle => 'Sunucu Detayları';

  @override
  String get serverDetailDeleteMessage => 'Bu işlem geri alınamaz.';

  @override
  String get serverDetailConnection => 'Bağlantı';

  @override
  String get serverDetailHost => 'Sunucu';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Kullanıcı Adı';

  @override
  String get serverDetailFolder => 'Klasör';

  @override
  String get serverDetailTags => 'Etiketler';

  @override
  String get serverDetailNotes => 'Notlar';

  @override
  String get serverDetailInfo => 'Bilgi';

  @override
  String get serverDetailCreated => 'Oluşturulma';

  @override
  String get serverDetailUpdated => 'Güncellenme';

  @override
  String get serverDetailDistro => 'Sistem';

  @override
  String get copiedToClipboard => 'Panoya kopyalandı';

  @override
  String get serverFormNameLabel => 'Sunucu Adı';

  @override
  String get serverFormHostnameLabel => 'Ana Bilgisayar Adı / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Kullanıcı Adı';

  @override
  String get serverFormPasswordLabel => 'Parola';

  @override
  String get serverFormUseManagedKey => 'Yönetilen Anahtar Kullan';

  @override
  String get serverFormManagedKeySubtitle =>
      'Merkezi olarak yönetilen SSH anahtarlarından seçin';

  @override
  String get serverFormDirectKeySubtitle =>
      'Anahtarı doğrudan bu sunucuya yapıştırın';

  @override
  String get serverFormGenerateKey => 'SSH Anahtar Çifti Oluştur';

  @override
  String get serverFormPrivateKeyLabel => 'Özel Anahtar';

  @override
  String get serverFormPrivateKeyHint => 'SSH özel anahtarını yapıştırın...';

  @override
  String get serverFormExtractPublicKey => 'Açık Anahtarı Çıkar';

  @override
  String get serverFormPublicKeyLabel => 'Açık Anahtar';

  @override
  String get serverFormPublicKeyHint =>
      'Boşsa özel anahtardan otomatik oluşturulur';

  @override
  String get serverFormPassphraseLabel => 'Anahtar Parolası (isteğe bağlı)';

  @override
  String get serverFormNotesLabel => 'Notlar (isteğe bağlı)';

  @override
  String get searchServers => 'Sunucu ara...';

  @override
  String get filterAllFolders => 'Tüm Klasörler';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterActive => 'Aktif';

  @override
  String get filterInactive => 'Pasif';

  @override
  String get filterClear => 'Temizle';

  @override
  String get folderListTitle => 'Klasörler';

  @override
  String get folderListEmpty => 'Henüz klasör yok';

  @override
  String get folderListEmptySubtitle =>
      'Sunucularınızı düzenlemek için klasör oluşturun.';

  @override
  String get folderAddButton => 'Klasör Ekle';

  @override
  String get folderDeleteTitle => 'Klasörü Sil';

  @override
  String folderDeleteMessage(String name) {
    return '\"$name\" silinsin mi? Sunucular sınıflandırılmamış olacak.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sunucu',
      one: '1 sunucu',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Daralt';

  @override
  String get folderShowHosts => 'Sunucuları göster';

  @override
  String get folderConnectAll => 'Tümüne Bağlan';

  @override
  String get folderFormTitleEdit => 'Klasörü Düzenle';

  @override
  String get folderFormTitleNew => 'Yeni Klasör';

  @override
  String get folderFormNameLabel => 'Klasör Adı';

  @override
  String get folderFormParentLabel => 'Üst Klasör';

  @override
  String get folderFormParentNone => 'Yok (Kök)';

  @override
  String get tagListTitle => 'Etiketler';

  @override
  String get tagListEmpty => 'Henüz etiket yok';

  @override
  String get tagListEmptySubtitle =>
      'Sunucularınızı etiketlemek ve filtrelemek için etiket oluşturun.';

  @override
  String get tagAddButton => 'Etiket Ekle';

  @override
  String get tagDeleteTitle => 'Etiketi Sil';

  @override
  String tagDeleteMessage(String name) {
    return '\"$name\" silinsin mi? Tüm sunuculardan kaldırılacak.';
  }

  @override
  String get tagFormTitleEdit => 'Etiketi Düzenle';

  @override
  String get tagFormTitleNew => 'Yeni Etiket';

  @override
  String get tagFormNameLabel => 'Etiket Adı';

  @override
  String get sshKeyListTitle => 'SSH Anahtarları';

  @override
  String get sshKeyListEmpty => 'Henüz SSH anahtarı yok';

  @override
  String get sshKeyListEmptySubtitle =>
      'SSH anahtarlarını merkezi olarak yönetmek için oluşturun veya içe aktarın';

  @override
  String get sshKeyCannotDeleteTitle => 'Silinemez';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return '\"$name\" silinemez. $count sunucu tarafından kullanılıyor. Önce tüm sunuculardan bağlantısını kesin.';
  }

  @override
  String get sshKeyDeleteTitle => 'SSH Anahtarını Sil';

  @override
  String sshKeyDeleteMessage(String name) {
    return '\"$name\" silinsin mi? Bu geri alınamaz.';
  }

  @override
  String get sshKeyAddButton => 'SSH Anahtarı Ekle';

  @override
  String get sshKeyFormTitleEdit => 'SSH Anahtarını Düzenle';

  @override
  String get sshKeyFormTitleAdd => 'SSH Anahtarı Ekle';

  @override
  String get sshKeyFormTabGenerate => 'Oluştur';

  @override
  String get sshKeyFormTabImport => 'İçe Aktar';

  @override
  String get sshKeyFormNameLabel => 'Anahtar Adı';

  @override
  String get sshKeyFormNameHint => 'ör. Üretim Anahtarım';

  @override
  String get sshKeyFormKeyType => 'Anahtar Türü';

  @override
  String get sshKeyFormKeySize => 'Anahtar Boyutu';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Yorum';

  @override
  String get sshKeyFormCommentHint => 'user@host veya açıklama';

  @override
  String get sshKeyFormCommentOptional => 'Yorum (isteğe bağlı)';

  @override
  String get sshKeyFormImportFromFile => 'Dosyadan İçe Aktar';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Özel Anahtar';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'SSH özel anahtarını yapıştırın veya yukarıdaki düğmeyi kullanın...';

  @override
  String get sshKeyFormPassphraseLabel => 'Parola (isteğe bağlı)';

  @override
  String get sshKeyFormNameRequired => 'Ad gerekli';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Özel anahtar gerekli';

  @override
  String get sshKeyFormFileReadError => 'Seçilen dosya okunamadı';

  @override
  String get sshKeyFormInvalidFormat =>
      'Geçersiz anahtar dosyası — PEM biçimi bekleniyor (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Dosya okunamadı: $message';
  }

  @override
  String get sshKeyFormSaving => 'Kaydediliyor...';

  @override
  String get sshKeySelectorLabel => 'SSH Anahtarı';

  @override
  String get sshKeySelectorNone => 'Yönetilen anahtar yok';

  @override
  String get sshKeySelectorManage => 'Anahtarları Yönet...';

  @override
  String get sshKeySelectorError => 'SSH anahtarları yüklenemedi';

  @override
  String get sshKeyTileCopyPublicKey => 'Açık anahtarı kopyala';

  @override
  String get sshKeyTilePublicKeyCopied => 'Açık anahtar kopyalandı';

  @override
  String sshKeyTileLinkedServers(int count) {
    return '$count sunucu tarafından kullanılıyor';
  }

  @override
  String get sshKeyTileUnlinkFirst =>
      'Önce tüm sunuculardan bağlantısını kesin';

  @override
  String get exportImportTitle => 'Dışa / İçe Aktar';

  @override
  String get exportSectionTitle => 'Dışa Aktar';

  @override
  String get exportJsonButton => 'JSON olarak dışa aktar (kimlik bilgisi yok)';

  @override
  String get exportZipButton =>
      'Şifreli ZIP dışa aktar (kimlik bilgileri dahil)';

  @override
  String get importSectionTitle => 'İçe Aktar';

  @override
  String get importButton => 'Dosyadan İçe Aktar';

  @override
  String get importSupportedFormats =>
      'JSON (düz) ve ZIP (şifreli) dosyalar desteklenir.';

  @override
  String exportedTo(String path) {
    return 'Dışa aktarıldı: $path';
  }

  @override
  String get share => 'Paylaş';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers sunucu, $groups grup, $tags etiket içe aktarıldı. $skipped atlandı.';
  }

  @override
  String get importPasswordTitle => 'Parola Girin';

  @override
  String get importPasswordLabel => 'Dışa Aktarma Parolası';

  @override
  String get importPasswordDecrypt => 'Şifre Çöz';

  @override
  String get exportPasswordTitle => 'Dışa Aktarma Parolası Belirle';

  @override
  String get exportPasswordDescription =>
      'Bu parola, kimlik bilgileri dahil dışa aktarma dosyanızı şifrelemek için kullanılacak.';

  @override
  String get exportPasswordLabel => 'Parola';

  @override
  String get exportPasswordConfirmLabel => 'Parolayı Onayla';

  @override
  String get exportPasswordMismatch => 'Parolalar eşleşmiyor';

  @override
  String get exportPasswordButton => 'Şifrele ve Dışa Aktar';

  @override
  String get importConflictTitle => 'Çakışmaları Yönet';

  @override
  String get importConflictDescription =>
      'İçe aktarma sırasında mevcut kayıtlar nasıl ele alınsın?';

  @override
  String get importConflictSkip => 'Mevcutu Atla';

  @override
  String get importConflictRename => 'Yeniyi Yeniden Adlandır';

  @override
  String get importConflictOverwrite => 'Üzerine Yaz';

  @override
  String get confirmDeleteLabel => 'Sil';

  @override
  String get keyGenTitle => 'SSH Anahtar Çifti Oluştur';

  @override
  String get keyGenKeyType => 'Anahtar Türü';

  @override
  String get keyGenKeySize => 'Anahtar Boyutu';

  @override
  String get keyGenComment => 'Yorum';

  @override
  String get keyGenCommentHint => 'user@host veya açıklama';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Oluşturuluyor...';

  @override
  String get keyGenGenerate => 'Oluştur';

  @override
  String keyGenResultTitle(String type) {
    return '$type Anahtarı Oluşturuldu';
  }

  @override
  String get keyGenPublicKey => 'Açık Anahtar';

  @override
  String get keyGenPrivateKey => 'Özel Anahtar';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Yorum: $comment';
  }

  @override
  String get keyGenAnother => 'Başka Bir Tane Oluştur';

  @override
  String get keyGenUseThisKey => 'Bu Anahtarı Kullan';

  @override
  String get keyGenCopyTooltip => 'Panoya kopyala';

  @override
  String keyGenCopied(String label) {
    return '$label kopyalandı';
  }

  @override
  String get colorPickerLabel => 'Renk';

  @override
  String get iconPickerLabel => 'Simge';

  @override
  String get tagSelectorLabel => 'Etiketler';

  @override
  String get tagSelectorEmpty => 'Henüz etiket yok';

  @override
  String get tagSelectorError => 'Etiketler yüklenemedi';

  @override
  String get snippetListTitle => 'Kod Parçaları';

  @override
  String get snippetSearchHint => 'Kod parçası ara...';

  @override
  String get snippetListEmpty => 'Henüz kod parçası yok';

  @override
  String get snippetListEmptySubtitle =>
      'Yeniden kullanılabilir kod parçaları ve komutlar oluşturun.';

  @override
  String get snippetAddButton => 'Kod Parçası Ekle';

  @override
  String get snippetDeleteTitle => 'Kod Parçasını Sil';

  @override
  String snippetDeleteMessage(String name) {
    return '\"$name\" silinsin mi? Bu geri alınamaz.';
  }

  @override
  String get snippetFormTitleEdit => 'Kod Parçasını Düzenle';

  @override
  String get snippetFormTitleNew => 'Yeni Kod Parçası';

  @override
  String get snippetFormNameLabel => 'Ad';

  @override
  String get snippetFormNameHint => 'ör. Docker temizliği';

  @override
  String get snippetFormLanguageLabel => 'Dil';

  @override
  String get snippetFormContentLabel => 'İçerik';

  @override
  String get snippetFormContentHint => 'Kod parçası kodunuzu girin...';

  @override
  String get snippetFormDescriptionLabel => 'Açıklama';

  @override
  String get snippetFormDescriptionHint => 'İsteğe bağlı açıklama...';

  @override
  String get snippetFormFolderLabel => 'Klasör';

  @override
  String get snippetFormNoFolder => 'Klasör Yok';

  @override
  String get snippetFormNameRequired => 'Ad gerekli';

  @override
  String get snippetFormContentRequired => 'İçerik gerekli';

  @override
  String get snippetFormUpdateButton => 'Kod Parçasını Güncelle';

  @override
  String get snippetFormCreateButton => 'Kod Parçası Oluştur';

  @override
  String get snippetDetailTitle => 'Kod Parçası Detayları';

  @override
  String get snippetDetailDeleteTitle => 'Kod Parçasını Sil';

  @override
  String get snippetDetailDeleteMessage => 'Bu işlem geri alınamaz.';

  @override
  String get snippetDetailContent => 'İçerik';

  @override
  String get snippetDetailFillVariables => 'Değişkenleri Doldur';

  @override
  String get snippetDetailDescription => 'Açıklama';

  @override
  String get snippetDetailVariables => 'Değişkenler';

  @override
  String get snippetDetailTags => 'Etiketler';

  @override
  String get snippetDetailInfo => 'Bilgi';

  @override
  String get snippetDetailCreated => 'Oluşturulma';

  @override
  String get snippetDetailUpdated => 'Güncellenme';

  @override
  String get variableEditorTitle => 'Şablon Değişkenleri';

  @override
  String get variableEditorAdd => 'Ekle';

  @override
  String get variableEditorEmpty =>
      'Değişken yok. İçerikte süslü parantez sözdizimi kullanarak bunlara başvurun.';

  @override
  String get variableEditorNameLabel => 'Ad';

  @override
  String get variableEditorNameHint => 'ör. hostname';

  @override
  String get variableEditorDefaultLabel => 'Varsayılan';

  @override
  String get variableEditorDefaultHint => 'isteğe bağlı';

  @override
  String get variableFillTitle => 'Değişkenleri Doldur';

  @override
  String variableFillHint(String name) {
    return '$name için değer girin';
  }

  @override
  String get variableFillPreview => 'Önizleme';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Aktif oturum yok';

  @override
  String get terminalEmptySubtitle =>
      'Terminal oturumu açmak için bir sunucuya bağlanın.';

  @override
  String get terminalGoToHosts => 'Sunuculara Git';

  @override
  String get terminalCloseAll => 'Tüm Oturumları Kapat';

  @override
  String get terminalCloseTitle => 'Oturumu Kapat';

  @override
  String terminalCloseMessage(String title) {
    return '\"$title\" ile olan aktif bağlantı kapatılsın mı?';
  }

  @override
  String get connectionAuthenticating => 'Kimlik doğrulanıyor...';

  @override
  String connectionConnecting(String name) {
    return '$name sunucusuna bağlanılıyor...';
  }

  @override
  String get connectionError => 'Bağlantı Hatası';

  @override
  String get connectionLost => 'Bağlantı Kesildi';

  @override
  String get connectionReconnect => 'Yeniden Bağlan';

  @override
  String get snippetQuickPanelTitle => 'Kod Parçası Ekle';

  @override
  String get snippetQuickPanelSearch => 'Kod parçası ara...';

  @override
  String get snippetQuickPanelEmpty => 'Kod parçası mevcut değil';

  @override
  String get snippetQuickPanelNoMatch => 'Eşleşen kod parçası yok';

  @override
  String get snippetQuickPanelInsertTooltip => 'Kod Parçası Ekle';

  @override
  String get terminalThemePickerTitle => 'Terminal Teması';

  @override
  String get validatorHostnameRequired => 'Ana bilgisayar adı gerekli';

  @override
  String get validatorHostnameInvalid =>
      'Geçersiz ana bilgisayar adı veya IP adresi';

  @override
  String get validatorPortRequired => 'Port gerekli';

  @override
  String get validatorPortRange => 'Port 1 ile 65535 arasında olmalıdır';

  @override
  String get validatorUsernameRequired => 'Kullanıcı adı gerekli';

  @override
  String get validatorUsernameInvalid => 'Geçersiz kullanıcı adı biçimi';

  @override
  String get validatorServerNameRequired => 'Sunucu adı gerekli';

  @override
  String get validatorServerNameLength =>
      'Sunucu adı 100 karakter veya daha kısa olmalıdır';

  @override
  String get validatorSshKeyInvalid => 'Geçersiz SSH anahtar biçimi';

  @override
  String get validatorPasswordRequired => 'Parola gerekli';

  @override
  String get validatorPasswordLength => 'Parola en az 8 karakter olmalıdır';

  @override
  String get authMethodPassword => 'Parola';

  @override
  String get authMethodKey => 'SSH Anahtarı';

  @override
  String get authMethodBoth => 'Parola + Anahtar';

  @override
  String get serverCopySuffix => '(Kopya)';

  @override
  String get settingsDownloadLogs => 'Günlükleri İndir';

  @override
  String get settingsSendLogs => 'Günlükleri Desteğe Gönder';

  @override
  String get settingsLogsSaved => 'Günlükler başarıyla kaydedildi';

  @override
  String get settingsLogsEmpty => 'Günlük kaydı mevcut değil';

  @override
  String get authLogin => 'Giriş Yap';

  @override
  String get authRegister => 'Kayıt Ol';

  @override
  String get authForgotPassword => 'Parolanızı mı unuttunuz?';

  @override
  String get authWhyLogin =>
      'Tüm cihazlarınızda şifreli bulut senkronizasyonunu etkinleştirmek için giriş yapın. Uygulama hesap olmadan tamamen çevrimdışı çalışır.';

  @override
  String get authEmailLabel => 'E-posta';

  @override
  String get authEmailRequired => 'E-posta gerekli';

  @override
  String get authEmailInvalid => 'Geçersiz e-posta adresi';

  @override
  String get authPasswordLabel => 'Parola';

  @override
  String get authConfirmPasswordLabel => 'Parolayı Onayla';

  @override
  String get authPasswordMismatch => 'Parolalar eşleşmiyor';

  @override
  String get authNoAccount => 'Hesabınız yok mu?';

  @override
  String get authHasAccount => 'Zaten hesabınız var mı?';

  @override
  String get authSelfHosted => 'Kendi Sunucunuz';

  @override
  String get authResetEmailSent =>
      'Hesap mevcutsa, e-postanıza bir sıfırlama bağlantısı gönderildi.';

  @override
  String get authResetDescription =>
      'E-posta adresinizi girin, parolanızı sıfırlamanız için bir bağlantı göndereceğiz.';

  @override
  String get authSendResetLink => 'Sıfırlama Bağlantısı Gönder';

  @override
  String get authBackToLogin => 'Girişe Dön';

  @override
  String get syncPasswordTitle => 'Senkronizasyon Parolası';

  @override
  String get syncPasswordTitleCreate => 'Senkronizasyon Parolası Belirle';

  @override
  String get syncPasswordTitleEnter => 'Senkronizasyon Parolası Girin';

  @override
  String get syncPasswordDescription =>
      'Kasa verilerinizi şifrelemek için ayrı bir parola belirleyin. Bu parola cihazınızdan asla ayrılmaz — sunucu yalnızca şifreli verileri saklar.';

  @override
  String get syncPasswordHintEnter =>
      'Hesabınızı oluştururken belirlediğiniz parolayı girin.';

  @override
  String get syncPasswordWarning =>
      'Bu parolayı unutursanız, senkronize verileriniz kurtarılamaz. Sıfırlama seçeneği yoktur.';

  @override
  String get syncPasswordLabel => 'Senkronizasyon Parolası';

  @override
  String get syncPasswordWrong => 'Yanlış parola. Lütfen tekrar deneyin.';

  @override
  String get firstSyncTitle => 'Mevcut Veri Bulundu';

  @override
  String get firstSyncMessage =>
      'Bu cihazda mevcut veri var ve sunucuda bir kasa var. Nasıl devam edelim?';

  @override
  String get firstSyncMerge => 'Birleştir (sunucu öncelikli)';

  @override
  String get firstSyncOverwriteLocal => 'Yerel veriyi üzerine yaz';

  @override
  String get firstSyncKeepLocal => 'Yereli koru ve gönder';

  @override
  String get firstSyncDeleteLocal => 'Yereli sil ve çek';

  @override
  String get changeEncryptionPassword => 'Şifreleme parolasını değiştir';

  @override
  String get changeEncryptionWarning =>
      'Diğer tüm cihazlardan çıkış yapılacak.';

  @override
  String get changeEncryptionOldPassword => 'Mevcut parola';

  @override
  String get changeEncryptionNewPassword => 'Yeni parola';

  @override
  String get changeEncryptionSuccess => 'Parola başarıyla değiştirildi.';

  @override
  String get logoutAllDevices => 'Tüm cihazlardan çıkış yap';

  @override
  String get logoutAllDevicesConfirm =>
      'Bu, tüm aktif oturumları iptal edecek. Tüm cihazlarda tekrar giriş yapmanız gerekecek.';

  @override
  String get logoutAllDevicesSuccess => 'Tüm cihazlardan çıkış yapıldı.';

  @override
  String get syncSettingsTitle => 'Senkronizasyon Ayarları';

  @override
  String get syncAutoSync => 'Otomatik Senkronizasyon';

  @override
  String get syncAutoSyncDescription =>
      'Uygulama başladığında otomatik senkronize et';

  @override
  String get syncNow => 'Şimdi Senkronize Et';

  @override
  String get syncSyncing => 'Senkronize ediliyor...';

  @override
  String get syncSuccess => 'Senkronizasyon tamamlandı';

  @override
  String get syncError => 'Senkronizasyon hatası';

  @override
  String get syncServerUnreachable => 'Sunucuya ulaşılamıyor';

  @override
  String get syncServerUnreachableHint =>
      'Senkronizasyon sunucusuna ulaşılamadı. İnternet bağlantınızı ve sunucu URL\'sini kontrol edin.';

  @override
  String get syncNetworkError =>
      'Sunucuya bağlantı başarısız oldu. Lütfen internet bağlantınızı kontrol edin veya daha sonra tekrar deneyin.';

  @override
  String get syncNeverSynced => 'Hiç senkronize edilmedi';

  @override
  String get syncVaultVersion => 'Kasa Sürümü';

  @override
  String get syncTitle => 'Senkronizasyon';

  @override
  String get settingsSectionNetwork => 'Ağ ve DNS';

  @override
  String get settingsDnsServers => 'DNS-over-HTTPS Sunucuları';

  @override
  String get settingsDnsDefault => 'Varsayılan (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Özel DoH sunucu URL\'lerini virgülle ayırarak girin. Çapraz doğrulama için en az 2 sunucu gereklidir.';

  @override
  String get settingsDnsLabel => 'DoH Sunucu URL\'leri';

  @override
  String get settingsDnsReset => 'Varsayılana Sıfırla';

  @override
  String get settingsSectionSync => 'Senkronizasyon';

  @override
  String get settingsSyncAccount => 'Hesap';

  @override
  String get settingsSyncNotLoggedIn => 'Giriş yapılmadı';

  @override
  String get settingsSyncStatus => 'Senkronizasyon';

  @override
  String get settingsSyncServerUrl => 'Sunucu URL';

  @override
  String get settingsSyncDefaultServer => 'Varsayılan (sshvault.app)';

  @override
  String get accountTitle => 'Hesap';

  @override
  String get accountNotLoggedIn => 'Giriş yapılmadı';

  @override
  String get accountVerified => 'Doğrulandı';

  @override
  String get accountMemberSince => 'Üyelik başlangıcı';

  @override
  String get accountDevices => 'Cihazlar';

  @override
  String get accountNoDevices => 'Kayıtlı cihaz yok';

  @override
  String get accountLastSync => 'Son senkronizasyon';

  @override
  String get accountChangePassword => 'Parolayı Değiştir';

  @override
  String get accountOldPassword => 'Mevcut Parola';

  @override
  String get accountNewPassword => 'Yeni Parola';

  @override
  String get accountDeleteAccount => 'Hesabı Sil';

  @override
  String get accountDeleteWarning =>
      'Bu, hesabınızı ve tüm senkronize verileri kalıcı olarak silecek. Bu geri alınamaz.';

  @override
  String get accountLogout => 'Çıkış Yap';

  @override
  String get serverConfigTitle => 'Sunucu Yapılandırması';

  @override
  String get serverConfigSelfHosted => 'Kendi Sunucunuz';

  @override
  String get serverConfigSelfHostedDescription =>
      'Kendi SSHVault sunucunuzu kullanın';

  @override
  String get serverConfigUrlLabel => 'Sunucu URL';

  @override
  String get serverConfigTest => 'Bağlantıyı Test Et';

  @override
  String get auditLogTitle => 'Etkinlik Günlüğü';

  @override
  String get auditLogAll => 'Tümü';

  @override
  String get auditLogEmpty => 'Etkinlik günlüğü bulunamadı';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Dosya Yöneticisi';

  @override
  String get sftpLocalDevice => 'Yerel Cihaz';

  @override
  String get sftpSelectServer => 'Sunucu seçin...';

  @override
  String get sftpConnecting => 'Bağlanılıyor...';

  @override
  String get sftpEmptyDirectory => 'Bu dizin boş';

  @override
  String get sftpNoConnection => 'Bağlı sunucu yok';

  @override
  String get sftpPathLabel => 'Yol';

  @override
  String get sftpUpload => 'Yükle';

  @override
  String get sftpDownload => 'İndir';

  @override
  String get sftpDelete => 'Sil';

  @override
  String get sftpRename => 'Yeniden Adlandır';

  @override
  String get sftpNewFolder => 'Yeni Klasör';

  @override
  String get sftpNewFolderName => 'Klasör adı';

  @override
  String get sftpChmod => 'İzinler';

  @override
  String get sftpChmodTitle => 'İzinleri Değiştir';

  @override
  String get sftpChmodOctal => 'Sekizlik';

  @override
  String get sftpChmodOwner => 'Sahip';

  @override
  String get sftpChmodGroup => 'Grup';

  @override
  String get sftpChmodOther => 'Diğer';

  @override
  String get sftpChmodRead => 'Okuma';

  @override
  String get sftpChmodWrite => 'Yazma';

  @override
  String get sftpChmodExecute => 'Çalıştırma';

  @override
  String get sftpCreateSymlink => 'Sembolik Bağ Oluştur';

  @override
  String get sftpSymlinkTarget => 'Hedef yol';

  @override
  String get sftpSymlinkName => 'Bağ adı';

  @override
  String get sftpFilePreview => 'Dosya Önizleme';

  @override
  String get sftpFileInfo => 'Dosya Bilgisi';

  @override
  String get sftpFileSize => 'Boyut';

  @override
  String get sftpFileModified => 'Değiştirilme';

  @override
  String get sftpFilePermissions => 'İzinler';

  @override
  String get sftpFileOwner => 'Sahip';

  @override
  String get sftpFileType => 'Tür';

  @override
  String get sftpFileLinkTarget => 'Bağ hedefi';

  @override
  String get sftpTransfers => 'Aktarımlar';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$total içinden $current';
  }

  @override
  String get sftpTransferQueued => 'Sırada';

  @override
  String get sftpTransferActive => 'Aktarılıyor...';

  @override
  String get sftpTransferPaused => 'Duraklatıldı';

  @override
  String get sftpTransferCompleted => 'Tamamlandı';

  @override
  String get sftpTransferFailed => 'Başarısız';

  @override
  String get sftpTransferCancelled => 'İptal Edildi';

  @override
  String get sftpPauseTransfer => 'Duraklat';

  @override
  String get sftpResumeTransfer => 'Devam Et';

  @override
  String get sftpCancelTransfer => 'İptal';

  @override
  String get sftpClearCompleted => 'Tamamlananları temizle';

  @override
  String sftpTransferCount(int active, int total) {
    return '$total içinden $active aktarım';
  }

  @override
  String sftpTransferCountActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktif',
      one: '1 aktif',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tamamlandı',
      one: '1 tamamlandı',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count başarısız',
      one: '1 başarısız',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Diğer panele kopyala';

  @override
  String sftpConfirmDelete(int count) {
    return '$count öğe silinsin mi?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return '\"$name\" silinsin mi?';
  }

  @override
  String get sftpDeleteSuccess => 'Başarıyla silindi';

  @override
  String get sftpRenameTitle => 'Yeniden Adlandır';

  @override
  String get sftpRenameLabel => 'Yeni ad';

  @override
  String get sftpSortByName => 'Ad';

  @override
  String get sftpSortBySize => 'Boyut';

  @override
  String get sftpSortByDate => 'Tarih';

  @override
  String get sftpSortByType => 'Tür';

  @override
  String get sftpShowHidden => 'Gizli dosyaları göster';

  @override
  String get sftpHideHidden => 'Gizli dosyaları gizle';

  @override
  String get sftpSelectAll => 'Tümünü seç';

  @override
  String get sftpDeselectAll => 'Tümünün seçimini kaldır';

  @override
  String sftpItemsSelected(int count) {
    return '$count seçili';
  }

  @override
  String get sftpRefresh => 'Yenile';

  @override
  String sftpConnectionError(String message) {
    return 'Bağlantı başarısız: $message';
  }

  @override
  String get sftpPermissionDenied => 'İzin reddedildi';

  @override
  String sftpOperationFailed(String message) {
    return 'İşlem başarısız: $message';
  }

  @override
  String get sftpOverwriteTitle => 'Dosya zaten mevcut';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" zaten mevcut. Üzerine yazılsın mı?';
  }

  @override
  String get sftpOverwrite => 'Üzerine Yaz';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Aktarım başladı: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'Önce diğer panelde bir hedef seçin';

  @override
  String get sftpDirectoryTransferNotSupported => 'Dizin aktarımı yakında';

  @override
  String get sftpSelect => 'Seç';

  @override
  String get sftpOpen => 'Aç';

  @override
  String get sftpExtractArchive => 'Buraya Çıkar';

  @override
  String get sftpExtractSuccess => 'Arşiv çıkarıldı';

  @override
  String sftpExtractFailed(String message) {
    return 'Çıkarma başarısız: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Desteklenmeyen arşiv biçimi';

  @override
  String get sftpExtracting => 'Çıkarılıyor...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yükleme başladı',
      one: 'Yükleme başladı',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count indirme başladı',
      one: 'İndirme başladı',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" indirildi';
  }

  @override
  String get sftpSavedToDownloads => 'Downloads/SSHVault klasörüne kaydedildi';

  @override
  String get sftpSaveToFiles => 'Dosyalara Kaydet';

  @override
  String get sftpFileSaved => 'Dosya kaydedildi';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count SSH oturumu aktif',
      one: 'SSH oturumu aktif',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Terminali açmak için dokunun';

  @override
  String get settingsAccountAndSync => 'Hesap ve Senkronizasyon';

  @override
  String get settingsAccountSubtitleAuth => 'Giriş yapıldı';

  @override
  String get settingsAccountSubtitleUnauth => 'Giriş yapılmadı';

  @override
  String get settingsSecuritySubtitle => 'Otomatik Kilitleme, Biyometri, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Kullanıcı root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, Dil, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Şifreli dışa aktarma varsayılanları';

  @override
  String get settingsAboutSubtitle => 'Sürüm, Lisanslar';

  @override
  String get settingsSearchHint => 'Ayarlarda ara...';

  @override
  String get settingsSearchNoResults => 'Ayar bulunamadı';

  @override
  String get aboutDeveloper => 'Kiefer Networks tarafından geliştirildi';

  @override
  String get aboutDonate => 'Bağış Yap';

  @override
  String get aboutOpenSourceLicenses => 'Açık Kaynak Lisansları';

  @override
  String get aboutWebsite => 'Web Sitesi';

  @override
  String get aboutVersion => 'Sürüm';

  @override
  String get aboutBuild => 'Derleme';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS DNS sorgularını şifreler ve DNS sahteciliğini önler. SSHVault, saldırıları tespit etmek için ana bilgisayar adlarını birden fazla sağlayıcıya karşı kontrol eder.';

  @override
  String get settingsDnsAddServer => 'DNS Sunucusu Ekle';

  @override
  String get settingsDnsServerUrl => 'Sunucu URL';

  @override
  String get settingsDnsDefaultBadge => 'Varsayılan';

  @override
  String get settingsDnsResetDefaults => 'Varsayılanlara Sıfırla';

  @override
  String get settingsDnsInvalidUrl => 'Lütfen geçerli bir HTTPS URL girin';

  @override
  String get settingsDefaultAuthMethod => 'Kimlik Doğrulama Yöntemi';

  @override
  String get settingsAuthPassword => 'Parola';

  @override
  String get settingsAuthKey => 'SSH Anahtarı';

  @override
  String get settingsConnectionTimeout => 'Bağlantı Zaman Aşımı';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsKeepaliveInterval => 'Keep-Alive Aralığı';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsCompression => 'Sıkıştırma';

  @override
  String get settingsCompressionDescription =>
      'SSH bağlantıları için zlib sıkıştırmayı etkinleştir';

  @override
  String get settingsTerminalType => 'Terminal Türü';

  @override
  String get settingsSectionConnection => 'Bağlantı';

  @override
  String get settingsClipboardAutoClear => 'Pano Otomatik Temizleme';

  @override
  String get settingsClipboardAutoClearOff => 'Kapalı';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}s';
  }

  @override
  String get settingsSessionTimeout => 'Oturum Zaman Aşımı';

  @override
  String get settingsSessionTimeoutOff => 'Kapalı';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes dk';
  }

  @override
  String get settingsDuressPin => 'Acil Durum PIN\'i';

  @override
  String get settingsDuressPinDescription =>
      'Girildiğinde tüm verileri silen ayrı bir PIN';

  @override
  String get settingsDuressPinSet => 'Acil durum PIN\'i belirlendi';

  @override
  String get settingsDuressPinNotSet => 'Yapılandırılmadı';

  @override
  String get settingsDuressPinWarning =>
      'Bu PIN girildiğinde kimlik bilgileri, anahtarlar ve ayarlar dahil tüm yerel veriler kalıcı olarak silinecek. Bu geri alınamaz.';

  @override
  String get settingsKeyRotationReminder => 'Anahtar Rotasyon Hatırlatıcısı';

  @override
  String get settingsKeyRotationOff => 'Kapalı';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days gün';
  }

  @override
  String get settingsFailedAttempts => 'Başarısız PIN Denemeleri';

  @override
  String get settingsSectionAppLock => 'Uygulama Kilidi';

  @override
  String get settingsSectionPrivacy => 'Gizlilik';

  @override
  String get settingsSectionReminders => 'Hatırlatıcılar';

  @override
  String get settingsSectionStatus => 'Durum';

  @override
  String get settingsExportBackupSubtitle =>
      'Dışa Aktarma, İçe Aktarma ve Yedekleme';

  @override
  String get settingsExportJson => 'JSON Olarak Dışa Aktar';

  @override
  String get settingsExportEncrypted => 'Şifreli Dışa Aktar';

  @override
  String get settingsImportFile => 'Dosyadan İçe Aktar';

  @override
  String get settingsSectionImport => 'İçe Aktarma';

  @override
  String get filterTitle => 'Sunucuları Filtrele';

  @override
  String get filterApply => 'Filtreleri Uygula';

  @override
  String get filterClearAll => 'Tümünü Temizle';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtre aktif',
      one: '1 filtre aktif',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Klasör';

  @override
  String get filterTags => 'Etiketler';

  @override
  String get filterStatus => 'Durum';

  @override
  String get variablePreviewResolved => 'Çözümlenmiş Önizleme';

  @override
  String get variableInsert => 'Ekle';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sunucu',
      one: '1 sunucu',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oturum iptal edildi.',
      one: '1 oturum iptal edildi.',
    );
    return '$_temp0 Çıkış yapıldı.';
  }

  @override
  String get keyGenPassphrase => 'Parola';

  @override
  String get keyGenPassphraseHint => 'İsteğe bağlı — özel anahtarı korur';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Varsayılan (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Aynı parmak izine sahip bir anahtar zaten mevcut: \"$name\". Her SSH anahtarı benzersiz olmalıdır.';
  }

  @override
  String get sshKeyFingerprint => 'Parmak İzi';

  @override
  String get sshKeyPublicKey => 'Açık Anahtar';

  @override
  String get jumpHost => 'Atlama Sunucusu';

  @override
  String get jumpHostNone => 'Yok';

  @override
  String get jumpHostLabel => 'Atlama sunucusu üzerinden bağlan';

  @override
  String get jumpHostSelfError => 'Bir sunucu kendi atlama sunucusu olamaz';

  @override
  String get jumpHostConnecting => 'Atlama sunucusuna bağlanılıyor…';

  @override
  String get jumpHostCircularError =>
      'Döngüsel atlama sunucusu zinciri tespit edildi';

  @override
  String get logoutDialogTitle => 'Çıkış Yap';

  @override
  String get logoutDialogMessage =>
      'Tüm yerel veriler silinsin mi? Sunucular, SSH anahtarları, kod parçaları ve ayarlar bu cihazdan kaldırılacak.';

  @override
  String get logoutOnly => 'Sadece çıkış yap';

  @override
  String get logoutAndDelete => 'Çıkış yap ve verileri sil';

  @override
  String get changeAvatar => 'Avatarı Değiştir';

  @override
  String get removeAvatar => 'Avatarı Kaldır';

  @override
  String get avatarUploadFailed => 'Avatar yüklenemedi';

  @override
  String get avatarTooLarge => 'Görüntü çok büyük';

  @override
  String get deviceLastSeen => 'Son görülme';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'Giriş yapılıyken sunucu URL\'si değiştirilemez. Önce çıkış yapın.';

  @override
  String get serverListNoFolder => 'Sınıflandırılmamış';

  @override
  String get autoSyncInterval => 'Senkronizasyon Aralığı';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes dk';
  }

  @override
  String get proxySettings => 'Proxy Ayarları';

  @override
  String get proxyType => 'Proxy Türü';

  @override
  String get proxyNone => 'Proxy Yok';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Proxy Sunucusu';

  @override
  String get proxyPort => 'Proxy Portu';

  @override
  String get proxyUsername => 'Proxy Kullanıcı Adı';

  @override
  String get proxyPassword => 'Proxy Parolası';

  @override
  String get proxyUseGlobal => 'Genel Proxy Kullan';

  @override
  String get proxyGlobal => 'Genel';

  @override
  String get proxyServerSpecific => 'Sunucuya özel';

  @override
  String get proxyTestConnection => 'Bağlantıyı Test Et';

  @override
  String get proxyTestSuccess => 'Proxy\'ye erişilebilir';

  @override
  String get proxyTestFailed => 'Proxy\'ye erişilemiyor';

  @override
  String get proxyDefaultProxy => 'Varsayılan Proxy';

  @override
  String get vpnRequired => 'VPN Gerekli';

  @override
  String get vpnRequiredTooltip => 'Aktif VPN olmadan bağlanırken uyarı göster';

  @override
  String get vpnActive => 'VPN Aktif';

  @override
  String get vpnInactive => 'VPN Pasif';

  @override
  String get vpnWarningTitle => 'VPN Aktif Değil';

  @override
  String get vpnWarningMessage =>
      'Bu sunucu VPN bağlantısı gerektiren olarak işaretlenmiş, ancak şu anda aktif bir VPN yok. Yine de bağlanmak istiyor musunuz?';

  @override
  String get vpnConnectAnyway => 'Yine de Bağlan';

  @override
  String get postConnectCommands => 'Bağlantı Sonrası Komutlar';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Bağlantıdan sonra otomatik çalıştırılan komutlar (satır başına bir tane)';

  @override
  String get dashboardFavorites => 'Favoriler';

  @override
  String get dashboardRecent => 'Son Kullanılan';

  @override
  String get dashboardActiveSessions => 'Aktif Oturumlar';

  @override
  String get addToFavorites => 'Favorilere Ekle';

  @override
  String get removeFromFavorites => 'Favorilerden Kaldır';

  @override
  String get noRecentConnections => 'Son bağlantı yok';

  @override
  String get terminalSplit => 'Bölünmüş Görünüm';

  @override
  String get terminalUnsplit => 'Bölmeyi Kapat';

  @override
  String get terminalSelectSession => 'Bölünmüş görünüm için oturum seçin';

  @override
  String get knownHostsTitle => 'Bilinen Sunucular';

  @override
  String get knownHostsSubtitle => 'Güvenilen sunucu parmak izlerini yönet';

  @override
  String get hostKeyNewTitle => 'Yeni Sunucu';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return '$hostname:$port ile ilk bağlantı. Bağlanmadan önce parmak izini doğrulayın.';
  }

  @override
  String get hostKeyChangedTitle => 'Sunucu Anahtarı Değişti!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return '$hostname:$port için sunucu anahtarı değişti. Bu bir güvenlik tehdidi olabilir.';
  }

  @override
  String get hostKeyFingerprint => 'Parmak İzi';

  @override
  String get hostKeyType => 'Anahtar Türü';

  @override
  String get hostKeyTrustConnect => 'Güven ve Bağlan';

  @override
  String get hostKeyAcceptNew => 'Yeni Anahtarı Kabul Et';

  @override
  String get hostKeyReject => 'Reddet';

  @override
  String get hostKeyPreviousFingerprint => 'Önceki Parmak İzi';

  @override
  String get hostKeyDeleteAll => 'Tüm Bilinen Sunucuları Sil';

  @override
  String get hostKeyDeleteConfirm =>
      'Tüm bilinen sunucular kaldırılsın mı? Bir sonraki bağlantıda tekrar sorulacak.';

  @override
  String get hostKeyEmpty => 'Henüz bilinen sunucu yok';

  @override
  String get hostKeyEmptySubtitle =>
      'İlk bağlantınızdan sonra sunucu parmak izleri burada saklanacak';

  @override
  String get hostKeyFirstSeen => 'İlk görülme';

  @override
  String get hostKeyLastSeen => 'Son görülme';

  @override
  String get sshConfigImportPickFile => 'SSH Yapılandırma Dosyasını Seçin';

  @override
  String get sshConfigImportOrPaste => 'Veya yapılandırma içeriğini yapıştırın';

  @override
  String sshConfigImportParsed(int count) {
    return '$count sunucu bulundu';
  }

  @override
  String get sshConfigImportDuplicate => 'Zaten mevcut';

  @override
  String get sshConfigImportNoHosts => 'Yapılandırmada sunucu bulunamadı';

  @override
  String get sftpBookmarkAdd => 'Yer İmi Ekle';

  @override
  String get sftpBookmarkLabel => 'Etiket';

  @override
  String get disconnect => 'Bağlantıyı Kes';

  @override
  String get reportAndDisconnect => 'Bildir ve Kes';

  @override
  String get continueAnyway => 'Yine de Devam Et';

  @override
  String get insertSnippet => 'Kod Parçası Ekle';

  @override
  String get seconds => 'Saniye';

  @override
  String get heartbeatLostMessage =>
      'Birden fazla denemeden sonra sunucuya ulaşılamadı. Güvenliğiniz için oturum sonlandırıldı.';

  @override
  String get attestationFailedTitle => 'Sunucu Doğrulama Başarısız';

  @override
  String get attestationFailedMessage =>
      'Sunucu, meşru bir SSHVault arka ucu olarak doğrulanamadı. Bu, ortadaki adam saldırısı veya yanlış yapılandırılmış bir sunucu olabilir.';

  @override
  String get attestationKeyChangedTitle => 'Sunucu Doğrulama Anahtarı Değişti';

  @override
  String get attestationKeyChangedMessage =>
      'Sunucunun doğrulama anahtarı ilk bağlantıdan bu yana değişti. Bu, ortadaki adam saldırısı olabilir. Sunucu yöneticisi anahtar rotasyonunu onaylamadıkça devam ETMEYİN.';

  @override
  String get sectionLinks => 'Bağlantılar';

  @override
  String get sectionDeveloper => 'Geliştirici';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Sayfa bulunamadı';

  @override
  String get connectionTestSuccess => 'Bağlantı başarılı';

  @override
  String connectionTestFailed(String message) {
    return 'Bağlantı başarısız: $message';
  }

  @override
  String get serverVerificationFailed => 'Sunucu doğrulama başarısız';

  @override
  String get importSuccessful => 'İçe aktarma başarılı';

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
