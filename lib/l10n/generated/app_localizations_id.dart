// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'SSHVault';

  @override
  String get navHosts => 'Host';

  @override
  String get navSnippets => 'Snippet';

  @override
  String get navFolders => 'Folder';

  @override
  String get navTags => 'Tag';

  @override
  String get navSshKeys => 'Kunci SSH';

  @override
  String get navExportImport => 'Ekspor / Impor';

  @override
  String get navTerminal => 'Terminal';

  @override
  String get navMore => 'Lainnya';

  @override
  String get navManagement => 'Manajemen';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get navAbout => 'Tentang';

  @override
  String get lockScreenTitle => 'SSHVault terkunci';

  @override
  String get lockScreenUnlock => 'Buka Kunci';

  @override
  String get lockScreenEnterPin => 'Masukkan PIN';

  @override
  String lockScreenLockedOut(int minutes) {
    return 'Terlalu banyak percobaan gagal. Coba lagi dalam $minutes menit.';
  }

  @override
  String get pinDialogSetTitle => 'Atur Kode PIN';

  @override
  String get pinDialogSetSubtitle =>
      'Masukkan PIN 6 digit untuk melindungi SSHVault';

  @override
  String get pinDialogLabel => 'PIN';

  @override
  String get pinDialogHint => '000000';

  @override
  String get pinDialogConfirmLabel => 'Konfirmasi PIN';

  @override
  String get pinDialogErrorLength => 'PIN harus tepat 6 digit';

  @override
  String get pinDialogErrorMismatch => 'PIN tidak cocok';

  @override
  String get pinDialogVerifyTitle => 'Masukkan PIN';

  @override
  String pinDialogWrongPin(int attempts) {
    return 'PIN salah. $attempts percobaan tersisa.';
  }

  @override
  String get securityBannerMessage =>
      'Kredensial SSH Anda tidak dilindungi. Atur PIN atau kunci biometrik di Pengaturan.';

  @override
  String get securityBannerDismiss => 'Tutup';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsSectionAppearance => 'Tampilan';

  @override
  String get settingsSectionTerminal => 'Terminal';

  @override
  String get settingsSectionSshDefaults => 'Default SSH';

  @override
  String get settingsSectionSecurity => 'Keamanan';

  @override
  String get settingsSectionExport => 'Ekspor';

  @override
  String get settingsSectionAbout => 'Tentang';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get settingsThemeLight => 'Terang';

  @override
  String get settingsThemeDark => 'Gelap';

  @override
  String get settingsTerminalTheme => 'Tema Terminal';

  @override
  String get settingsTerminalThemeDefault => 'Gelap Default';

  @override
  String get settingsFontSize => 'Ukuran Font';

  @override
  String settingsFontSizeValue(int size) {
    return '$size px';
  }

  @override
  String get settingsDefaultPort => 'Port Default';

  @override
  String get settingsDefaultPortDialog => 'Port SSH Default';

  @override
  String get settingsPortLabel => 'Port';

  @override
  String get settingsPortHint => '22';

  @override
  String get settingsDefaultUsername => 'Nama Pengguna Default';

  @override
  String get settingsDefaultUsernameDialog => 'Nama Pengguna Default';

  @override
  String get settingsUsernameLabel => 'Nama Pengguna';

  @override
  String get settingsUsernameHint => 'root';

  @override
  String get settingsAutoLock => 'Kunci Otomatis';

  @override
  String get settingsAutoLockDisabled => 'Nonaktif';

  @override
  String settingsAutoLockMinutes(int minutes) {
    return '$minutes menit';
  }

  @override
  String get settingsAutoLockOff => 'Mati';

  @override
  String get settingsAutoLock1Min => '1 menit';

  @override
  String get settingsAutoLock5Min => '5 menit';

  @override
  String get settingsAutoLock15Min => '15 menit';

  @override
  String get settingsAutoLock30Min => '30 menit';

  @override
  String get settingsBiometricUnlock => 'Buka Kunci Biometrik';

  @override
  String get settingsBiometricNotAvailable => 'Tidak tersedia di perangkat ini';

  @override
  String get settingsBiometricError => 'Kesalahan saat memeriksa biometrik';

  @override
  String get settingsBiometricReason =>
      'Verifikasi identitas Anda untuk mengaktifkan buka kunci biometrik';

  @override
  String get settingsBiometricRequiresPin =>
      'Atur PIN terlebih dahulu untuk mengaktifkan buka kunci biometrik';

  @override
  String get settingsPinCode => 'Kode PIN';

  @override
  String get settingsPinIsSet => 'PIN telah diatur';

  @override
  String get settingsPinNotConfigured => 'PIN belum dikonfigurasi';

  @override
  String get settingsPinRemove => 'Hapus';

  @override
  String get settingsPinRemoveWarning =>
      'Menghapus PIN akan mendekripsi semua field database dan menonaktifkan buka kunci biometrik. Lanjutkan?';

  @override
  String get settingsPinRemoveTitle => 'Hapus PIN';

  @override
  String get settingsPreventScreenshots => 'Cegah Tangkapan Layar';

  @override
  String get settingsPreventScreenshotsDescription =>
      'Blokir tangkapan layar dan perekaman layar';

  @override
  String get settingsEncryptExport => 'Enkripsi Ekspor secara Default';

  @override
  String get settingsAbout => 'Tentang SSHVault';

  @override
  String get settingsAboutLegalese => 'oleh Kiefer Networks';

  @override
  String get settingsAboutDescription =>
      'Klien SSH Aman yang Dihosting Sendiri';

  @override
  String get settingsLanguage => 'Bahasa';

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
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get delete => 'Hapus';

  @override
  String get close => 'Tutup';

  @override
  String get update => 'Perbarui';

  @override
  String get create => 'Buat';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get copy => 'Salin';

  @override
  String get edit => 'Edit';

  @override
  String get loading => '...';

  @override
  String error(String message) {
    return 'Kesalahan: $message';
  }

  @override
  String get serverListTitle => 'Host';

  @override
  String get serverListEmpty => 'Belum ada server';

  @override
  String get serverListEmptySubtitle =>
      'Tambahkan server SSH pertama Anda untuk memulai.';

  @override
  String get serverAddButton => 'Tambah Server';

  @override
  String sshConfigImportMessage(int count) {
    return 'Ditemukan $count host di ~/.ssh/config. Impor?';
  }

  @override
  String get sshConfigNotFound => 'File konfigurasi SSH tidak ditemukan';

  @override
  String get sshConfigEmpty => 'Tidak ada host ditemukan di konfigurasi SSH';

  @override
  String get sshConfigAddManually => 'Tambah Manual';

  @override
  String get sshConfigImportAgain => 'Impor konfigurasi SSH lagi?';

  @override
  String get sshConfigImportKeys =>
      'Impor kunci SSH yang dirujuk oleh host yang dipilih?';

  @override
  String sshConfigKeysImported(int count) {
    return '$count kunci SSH diimpor';
  }

  @override
  String get serverDuplicated => 'Server diduplikasi';

  @override
  String get serverDeleteTitle => 'Hapus Server';

  @override
  String serverDeleteMessage(String name) {
    return 'Apakah Anda yakin ingin menghapus \"$name\"? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String serverDeleteShort(String name) {
    return 'Hapus \"$name\"?';
  }

  @override
  String get serverConnect => 'Hubungkan';

  @override
  String get serverDetails => 'Detail';

  @override
  String get serverDuplicate => 'Duplikasi';

  @override
  String get serverActive => 'Aktif';

  @override
  String get serverNoFolder => 'Tanpa Folder';

  @override
  String get serverFormTitleEdit => 'Edit Server';

  @override
  String get serverFormTitleAdd => 'Tambah Server';

  @override
  String get serverSaved => 'Server saved successfully';

  @override
  String get serverFormUpdateButton => 'Perbarui Server';

  @override
  String get serverFormAddButton => 'Tambah Server';

  @override
  String get serverFormPublicKeyExtracted => 'Kunci publik berhasil diekstrak';

  @override
  String serverFormPublicKeyError(String message) {
    return 'Tidak dapat mengekstrak kunci publik: $message';
  }

  @override
  String serverFormKeyGenerated(String type) {
    return 'Pasangan kunci $type dihasilkan';
  }

  @override
  String get serverDetailTitle => 'Detail Server';

  @override
  String get serverDetailDeleteMessage =>
      'Tindakan ini tidak dapat dibatalkan.';

  @override
  String get serverDetailConnection => 'Koneksi';

  @override
  String get serverDetailHost => 'Host';

  @override
  String get serverDetailPort => 'Port';

  @override
  String get serverDetailUsername => 'Nama Pengguna';

  @override
  String get serverDetailFolder => 'Folder';

  @override
  String get serverDetailTags => 'Tag';

  @override
  String get serverDetailNotes => 'Catatan';

  @override
  String get serverDetailInfo => 'Info';

  @override
  String get serverDetailCreated => 'Dibuat';

  @override
  String get serverDetailUpdated => 'Diperbarui';

  @override
  String get serverDetailDistro => 'Sistem';

  @override
  String get copiedToClipboard => 'Disalin ke clipboard';

  @override
  String get serverFormNameLabel => 'Nama Server';

  @override
  String get serverFormHostnameLabel => 'Hostname / IP';

  @override
  String get serverFormPortLabel => 'Port';

  @override
  String get serverFormUsernameLabel => 'Nama Pengguna';

  @override
  String get serverFormPasswordLabel => 'Kata Sandi';

  @override
  String get serverFormUseManagedKey => 'Gunakan Kunci Terkelola';

  @override
  String get serverFormManagedKeySubtitle =>
      'Pilih dari kunci SSH yang dikelola secara terpusat';

  @override
  String get serverFormDirectKeySubtitle =>
      'Tempel kunci langsung ke server ini';

  @override
  String get serverFormGenerateKey => 'Hasilkan Pasangan Kunci SSH';

  @override
  String get serverFormPrivateKeyLabel => 'Kunci Privat';

  @override
  String get serverFormPrivateKeyHint => 'Tempel kunci privat SSH...';

  @override
  String get serverFormExtractPublicKey => 'Ekstrak Kunci Publik';

  @override
  String get serverFormPublicKeyLabel => 'Kunci Publik';

  @override
  String get serverFormPublicKeyHint =>
      'Dihasilkan otomatis dari kunci privat jika kosong';

  @override
  String get serverFormPassphraseLabel => 'Frasa Sandi Kunci (opsional)';

  @override
  String get serverFormNotesLabel => 'Catatan (opsional)';

  @override
  String get searchServers => 'Cari server...';

  @override
  String get filterAllFolders => 'Semua Folder';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterActive => 'Aktif';

  @override
  String get filterInactive => 'Tidak Aktif';

  @override
  String get filterClear => 'Hapus';

  @override
  String get folderListTitle => 'Folder';

  @override
  String get folderListEmpty => 'Belum ada folder';

  @override
  String get folderListEmptySubtitle =>
      'Buat folder untuk mengorganisir server Anda.';

  @override
  String get folderAddButton => 'Tambah Folder';

  @override
  String get folderDeleteTitle => 'Hapus Folder';

  @override
  String folderDeleteMessage(String name) {
    return 'Hapus \"$name\"? Server menjadi tidak terkategori.';
  }

  @override
  String folderServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count server',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String get folderCollapse => 'Lipat';

  @override
  String get folderShowHosts => 'Tampilkan host';

  @override
  String get folderConnectAll => 'Hubungkan Semua';

  @override
  String get folderFormTitleEdit => 'Edit Folder';

  @override
  String get folderFormTitleNew => 'Folder Baru';

  @override
  String get folderFormNameLabel => 'Nama Folder';

  @override
  String get folderFormParentLabel => 'Folder Induk';

  @override
  String get folderFormParentNone => 'Tidak Ada (Root)';

  @override
  String get tagListTitle => 'Tag';

  @override
  String get tagListEmpty => 'Belum ada tag';

  @override
  String get tagListEmptySubtitle =>
      'Buat tag untuk memberi label dan memfilter server Anda.';

  @override
  String get tagAddButton => 'Tambah Tag';

  @override
  String get tagDeleteTitle => 'Hapus Tag';

  @override
  String tagDeleteMessage(String name) {
    return 'Hapus \"$name\"? Tag akan dihapus dari semua server.';
  }

  @override
  String get tagFormTitleEdit => 'Edit Tag';

  @override
  String get tagFormTitleNew => 'Tag Baru';

  @override
  String get tagFormNameLabel => 'Nama Tag';

  @override
  String get sshKeyListTitle => 'Kunci SSH';

  @override
  String get sshKeyListEmpty => 'Belum ada kunci SSH';

  @override
  String get sshKeyListEmptySubtitle =>
      'Hasilkan atau impor kunci SSH untuk mengelolanya secara terpusat';

  @override
  String get sshKeyCannotDeleteTitle => 'Tidak Dapat Dihapus';

  @override
  String sshKeyCannotDeleteMessage(String name, int count) {
    return 'Tidak dapat menghapus \"$name\". Digunakan oleh $count server. Lepaskan dari semua server terlebih dahulu.';
  }

  @override
  String get sshKeyDeleteTitle => 'Hapus Kunci SSH';

  @override
  String sshKeyDeleteMessage(String name) {
    return 'Hapus \"$name\"? Ini tidak dapat dibatalkan.';
  }

  @override
  String get sshKeyAddButton => 'Tambah Kunci SSH';

  @override
  String get sshKeyFormTitleEdit => 'Edit Kunci SSH';

  @override
  String get sshKeyFormTitleAdd => 'Tambah Kunci SSH';

  @override
  String get sshKeyFormTabGenerate => 'Hasilkan';

  @override
  String get sshKeyFormTabImport => 'Impor';

  @override
  String get sshKeyFormNameLabel => 'Nama Kunci';

  @override
  String get sshKeyFormNameHint => 'contoh: Kunci Produksi Saya';

  @override
  String get sshKeyFormKeyType => 'Jenis Kunci';

  @override
  String get sshKeyFormKeySize => 'Ukuran Kunci';

  @override
  String sshKeyFormKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get sshKeyFormCommentLabel => 'Komentar';

  @override
  String get sshKeyFormCommentHint => 'pengguna@host atau deskripsi';

  @override
  String get sshKeyFormCommentOptional => 'Komentar (opsional)';

  @override
  String get sshKeyFormImportFromFile => 'Impor dari File';

  @override
  String get sshKeyFormPrivateKeyLabel => 'Kunci Privat';

  @override
  String get sshKeyFormPrivateKeyHint =>
      'Tempel kunci privat SSH atau gunakan tombol di atas...';

  @override
  String get sshKeyFormPassphraseLabel => 'Frasa Sandi (opsional)';

  @override
  String get sshKeyFormNameRequired => 'Nama wajib diisi';

  @override
  String get sshKeyFormPrivateKeyRequired => 'Kunci privat wajib diisi';

  @override
  String get sshKeyFormFileReadError => 'Tidak dapat membaca file yang dipilih';

  @override
  String get sshKeyFormInvalidFormat =>
      'Format kunci tidak valid — format PEM diharapkan (-----BEGIN ...)';

  @override
  String sshKeyFormFileError(String message) {
    return 'Gagal membaca file: $message';
  }

  @override
  String get sshKeyFormSaving => 'Menyimpan...';

  @override
  String get sshKeySelectorLabel => 'Kunci SSH';

  @override
  String get sshKeySelectorNone => 'Tanpa kunci terkelola';

  @override
  String get sshKeySelectorManage => 'Kelola Kunci...';

  @override
  String get sshKeySelectorError => 'Gagal memuat kunci SSH';

  @override
  String get sshKeyTileCopyPublicKey => 'Salin kunci publik';

  @override
  String get sshKeyTilePublicKeyCopied => 'Kunci publik disalin';

  @override
  String sshKeyTileLinkedServers(int count) {
    return 'Digunakan oleh $count server';
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
      'Lepaskan dari semua server terlebih dahulu';

  @override
  String get exportImportTitle => 'Ekspor / Impor';

  @override
  String get exportSectionTitle => 'Ekspor';

  @override
  String get exportJsonButton => 'Ekspor sebagai JSON (tanpa kredensial)';

  @override
  String get exportZipButton => 'Ekspor ZIP Terenkripsi (dengan kredensial)';

  @override
  String get importSectionTitle => 'Impor';

  @override
  String get importButton => 'Impor dari File';

  @override
  String get importSupportedFormats =>
      'Mendukung file JSON (biasa) dan ZIP (terenkripsi).';

  @override
  String exportedTo(String path) {
    return 'Diekspor ke: $path';
  }

  @override
  String get share => 'Bagikan';

  @override
  String importResult(int servers, int groups, int tags, int skipped) {
    return '$servers server, $groups grup, $tags tag diimpor. $skipped dilewati.';
  }

  @override
  String get importPasswordTitle => 'Masukkan Kata Sandi';

  @override
  String get importPasswordLabel => 'Kata Sandi Ekspor';

  @override
  String get importPasswordDecrypt => 'Dekripsi';

  @override
  String get exportPasswordTitle => 'Atur Kata Sandi Ekspor';

  @override
  String get exportPasswordDescription =>
      'Kata sandi ini akan digunakan untuk mengenkripsi file ekspor Anda termasuk kredensial.';

  @override
  String get exportPasswordLabel => 'Kata Sandi';

  @override
  String get exportPasswordConfirmLabel => 'Konfirmasi Kata Sandi';

  @override
  String get exportPasswordMismatch => 'Kata sandi tidak cocok';

  @override
  String get exportPasswordButton => 'Enkripsi & Ekspor';

  @override
  String get importConflictTitle => 'Tangani Konflik';

  @override
  String get importConflictDescription =>
      'Bagaimana entri yang sudah ada harus ditangani selama impor?';

  @override
  String get importConflictSkip => 'Lewati yang Ada';

  @override
  String get importConflictRename => 'Ganti Nama Baru';

  @override
  String get importConflictOverwrite => 'Timpa';

  @override
  String get confirmDeleteLabel => 'Hapus';

  @override
  String get keyGenTitle => 'Hasilkan Pasangan Kunci SSH';

  @override
  String get keyGenKeyType => 'Jenis Kunci';

  @override
  String get keyGenKeySize => 'Ukuran Kunci';

  @override
  String get keyGenComment => 'Komentar';

  @override
  String get keyGenCommentHint => 'pengguna@host atau deskripsi';

  @override
  String keyGenKeySizeBit(int bits) {
    return '$bits bit';
  }

  @override
  String get keyGenGenerating => 'Menghasilkan...';

  @override
  String get keyGenGenerate => 'Hasilkan';

  @override
  String keyGenResultTitle(String type) {
    return 'Kunci $type Dihasilkan';
  }

  @override
  String get keyGenPublicKey => 'Kunci Publik';

  @override
  String get keyGenPrivateKey => 'Kunci Privat';

  @override
  String keyGenCommentInfo(String comment) {
    return 'Komentar: $comment';
  }

  @override
  String get keyGenAnother => 'Hasilkan Lagi';

  @override
  String get keyGenUseThisKey => 'Gunakan Kunci Ini';

  @override
  String get keyGenCopyTooltip => 'Salin ke clipboard';

  @override
  String keyGenCopied(String label) {
    return '$label disalin';
  }

  @override
  String get colorPickerLabel => 'Warna';

  @override
  String get iconPickerLabel => 'Ikon';

  @override
  String get tagSelectorLabel => 'Tag';

  @override
  String get tagSelectorEmpty => 'Belum ada tag';

  @override
  String get tagSelectorError => 'Gagal memuat tag';

  @override
  String get snippetListTitle => 'Snippet';

  @override
  String get snippetSearchHint => 'Cari snippet...';

  @override
  String get snippetListEmpty => 'Belum ada snippet';

  @override
  String get snippetListEmptySubtitle =>
      'Buat snippet kode dan perintah yang dapat digunakan kembali.';

  @override
  String get snippetAddButton => 'Tambah Snippet';

  @override
  String get snippetDeleteTitle => 'Hapus Snippet';

  @override
  String snippetDeleteMessage(String name) {
    return 'Hapus \"$name\"? Ini tidak dapat dibatalkan.';
  }

  @override
  String get snippetFormTitleEdit => 'Edit Snippet';

  @override
  String get snippetFormTitleNew => 'Snippet Baru';

  @override
  String get snippetFormNameLabel => 'Nama';

  @override
  String get snippetFormNameHint => 'contoh: Pembersihan Docker';

  @override
  String get snippetFormLanguageLabel => 'Bahasa';

  @override
  String get snippetFormContentLabel => 'Konten';

  @override
  String get snippetFormContentHint => 'Masukkan kode snippet Anda...';

  @override
  String get snippetFormDescriptionLabel => 'Deskripsi';

  @override
  String get snippetFormDescriptionHint => 'Deskripsi opsional...';

  @override
  String get snippetFormFolderLabel => 'Folder';

  @override
  String get snippetFormNoFolder => 'Tanpa Folder';

  @override
  String get snippetFormNameRequired => 'Nama wajib diisi';

  @override
  String get snippetFormContentRequired => 'Konten wajib diisi';

  @override
  String get snippetFormSaved => 'Snippet disimpan';

  @override
  String get snippetFormUpdateButton => 'Perbarui Snippet';

  @override
  String get snippetFormCreateButton => 'Buat Snippet';

  @override
  String get snippetDetailTitle => 'Detail Snippet';

  @override
  String get snippetDetailDeleteTitle => 'Hapus Snippet';

  @override
  String get snippetDetailDeleteMessage =>
      'Tindakan ini tidak dapat dibatalkan.';

  @override
  String get snippetDetailContent => 'Konten';

  @override
  String get snippetDetailFillVariables => 'Isi Variabel';

  @override
  String get snippetDetailDescription => 'Deskripsi';

  @override
  String get snippetDetailVariables => 'Variabel';

  @override
  String get snippetDetailTags => 'Tag';

  @override
  String get snippetDetailInfo => 'Info';

  @override
  String get snippetDetailCreated => 'Dibuat';

  @override
  String get snippetDetailUpdated => 'Diperbarui';

  @override
  String get variableEditorTitle => 'Variabel Template';

  @override
  String get variableEditorAdd => 'Tambah';

  @override
  String get variableEditorEmpty =>
      'Tidak ada variabel. Gunakan sintaks kurung kurawal di konten untuk merujuknya.';

  @override
  String get variableEditorNameLabel => 'Nama';

  @override
  String get variableEditorNameHint => 'contoh: hostname';

  @override
  String get variableEditorDefaultLabel => 'Default';

  @override
  String get variableEditorDefaultHint => 'opsional';

  @override
  String get variableFillTitle => 'Isi Variabel';

  @override
  String variableFillHint(String name) {
    return 'Masukkan nilai untuk $name';
  }

  @override
  String get variableFillPreview => 'Pratinjau';

  @override
  String get terminalTitle => 'Terminal';

  @override
  String get terminalEmpty => 'Tidak ada sesi aktif';

  @override
  String get terminalEmptySubtitle =>
      'Hubungkan ke host untuk membuka sesi terminal.';

  @override
  String get terminalGoToHosts => 'Ke Host';

  @override
  String get terminalCloseAll => 'Tutup Semua Sesi';

  @override
  String get terminalCloseTitle => 'Tutup Sesi';

  @override
  String terminalCloseMessage(String title) {
    return 'Tutup koneksi aktif ke \"$title\"?';
  }

  @override
  String get connectionAuthenticating => 'Mengautentikasi...';

  @override
  String connectionConnecting(String name) {
    return 'Menghubungkan ke $name...';
  }

  @override
  String get connectionError => 'Kesalahan Koneksi';

  @override
  String get connectionLost => 'Koneksi Terputus';

  @override
  String get connectionReconnect => 'Hubungkan Ulang';

  @override
  String get snippetQuickPanelTitle => 'Sisipkan Snippet';

  @override
  String get snippetQuickPanelSearch => 'Cari snippet...';

  @override
  String get snippetQuickPanelEmpty => 'Tidak ada snippet tersedia';

  @override
  String get snippetQuickPanelNoMatch => 'Tidak ada snippet yang cocok';

  @override
  String get snippetQuickPanelInsertTooltip => 'Sisipkan Snippet';

  @override
  String get terminalThemePickerTitle => 'Tema Terminal';

  @override
  String get validatorHostnameRequired => 'Hostname wajib diisi';

  @override
  String get validatorHostnameInvalid => 'Hostname atau alamat IP tidak valid';

  @override
  String get validatorPortRequired => 'Port wajib diisi';

  @override
  String get validatorPortRange => 'Port harus antara 1 dan 65535';

  @override
  String get validatorUsernameRequired => 'Nama pengguna wajib diisi';

  @override
  String get validatorUsernameInvalid => 'Format nama pengguna tidak valid';

  @override
  String get validatorServerNameRequired => 'Nama server wajib diisi';

  @override
  String get validatorServerNameLength =>
      'Nama server harus 100 karakter atau kurang';

  @override
  String get validatorSshKeyInvalid => 'Format kunci SSH tidak valid';

  @override
  String get validatorPasswordRequired => 'Kata sandi wajib diisi';

  @override
  String get validatorPasswordLength => 'Kata sandi harus minimal 8 karakter';

  @override
  String get authMethodPassword => 'Kata Sandi';

  @override
  String get authMethodKey => 'Kunci SSH';

  @override
  String get authMethodBoth => 'Kata Sandi + Kunci';

  @override
  String get serverCopySuffix => '(Salinan)';

  @override
  String get settingsDownloadLogs => 'Unduh Log';

  @override
  String get settingsSendLogs => 'Kirim Log ke Dukungan';

  @override
  String get settingsLogsSaved => 'Log berhasil disimpan';

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
  String get settingsLogsEmpty => 'Tidak ada entri log tersedia';

  @override
  String get authLogin => 'Masuk';

  @override
  String get authRegister => 'Daftar';

  @override
  String get authForgotPassword => 'Lupa kata sandi?';

  @override
  String get authWhyLogin =>
      'Masuk untuk mengaktifkan sinkronisasi cloud terenkripsi di semua perangkat Anda. Aplikasi berfungsi sepenuhnya offline tanpa akun.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailRequired => 'Email wajib diisi';

  @override
  String get authEmailInvalid => 'Alamat email tidak valid';

  @override
  String get authPasswordLabel => 'Kata Sandi';

  @override
  String get authConfirmPasswordLabel => 'Konfirmasi Kata Sandi';

  @override
  String get authPasswordMismatch => 'Kata sandi tidak cocok';

  @override
  String get authNoAccount => 'Belum punya akun?';

  @override
  String get authHasAccount => 'Sudah punya akun?';

  @override
  String get authResetEmailSent =>
      'Jika akun ada, tautan reset telah dikirim ke email Anda.';

  @override
  String get authResetDescription =>
      'Masukkan alamat email Anda dan kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda.';

  @override
  String get authSendResetLink => 'Kirim Tautan Reset';

  @override
  String get authBackToLogin => 'Kembali ke Masuk';

  @override
  String get syncPasswordTitle => 'Kata Sandi Sinkronisasi';

  @override
  String get syncPasswordTitleCreate => 'Atur Kata Sandi Sinkronisasi';

  @override
  String get syncPasswordTitleEnter => 'Masukkan Kata Sandi Sinkronisasi';

  @override
  String get syncPasswordDescription =>
      'Atur kata sandi terpisah untuk mengenkripsi data vault Anda. Kata sandi ini tidak pernah meninggalkan perangkat Anda — server hanya menyimpan data terenkripsi.';

  @override
  String get syncPasswordHintEnter =>
      'Masukkan kata sandi yang Anda atur saat membuat akun.';

  @override
  String get syncPasswordWarning =>
      'Jika Anda lupa kata sandi ini, data yang disinkronkan tidak dapat dipulihkan. Tidak ada opsi reset.';

  @override
  String get syncPasswordLabel => 'Kata Sandi Sinkronisasi';

  @override
  String get syncPasswordWrong => 'Kata sandi salah. Silakan coba lagi.';

  @override
  String get firstSyncTitle => 'Data yang Ada Ditemukan';

  @override
  String get firstSyncMessage =>
      'Perangkat ini memiliki data yang ada dan server memiliki vault. Bagaimana harus dilanjutkan?';

  @override
  String get firstSyncMerge => 'Gabung (server menang)';

  @override
  String get firstSyncOverwriteLocal => 'Timpa data lokal';

  @override
  String get firstSyncKeepLocal => 'Pertahankan lokal & push';

  @override
  String get firstSyncDeleteLocal => 'Hapus lokal & pull';

  @override
  String get changeEncryptionPassword => 'Ubah kata sandi enkripsi';

  @override
  String get changeEncryptionWarning =>
      'Anda akan keluar dari semua perangkat lain.';

  @override
  String get changeEncryptionOldPassword => 'Kata sandi saat ini';

  @override
  String get changeEncryptionNewPassword => 'Kata sandi baru';

  @override
  String get changeEncryptionSuccess => 'Kata sandi berhasil diubah.';

  @override
  String get logoutAllDevices => 'Keluar dari semua perangkat';

  @override
  String get logoutAllDevicesConfirm =>
      'Ini akan mencabut semua sesi aktif. Anda perlu masuk lagi di semua perangkat.';

  @override
  String get logoutAllDevicesSuccess => 'Semua perangkat telah keluar.';

  @override
  String get syncSettingsTitle => 'Pengaturan Sinkronisasi';

  @override
  String get syncAutoSync => 'Sinkronisasi Otomatis';

  @override
  String get syncAutoSyncDescription =>
      'Sinkronisasi otomatis saat aplikasi dimulai';

  @override
  String get syncNow => 'Sinkronkan Sekarang';

  @override
  String get syncSyncing => 'Menyinkronkan...';

  @override
  String get syncSuccess => 'Sinkronisasi selesai';

  @override
  String get syncError => 'Kesalahan sinkronisasi';

  @override
  String get syncServerUnreachable => 'Server tidak dapat dijangkau';

  @override
  String get syncServerUnreachableHint =>
      'Server sinkronisasi tidak dapat dijangkau. Periksa koneksi internet dan URL server Anda.';

  @override
  String get syncNetworkError =>
      'Koneksi ke server gagal. Periksa koneksi internet Anda atau coba lagi nanti.';

  @override
  String get syncNeverSynced => 'Belum pernah disinkronkan';

  @override
  String get syncVaultVersion => 'Versi Vault';

  @override
  String get syncTitle => 'Sinkronisasi';

  @override
  String get settingsSectionNetwork => 'Jaringan & DNS';

  @override
  String get settingsDnsServers => 'Server DNS-over-HTTPS';

  @override
  String get settingsDnsDefault => 'Default (Quad9 + Mullvad)';

  @override
  String get settingsDnsHint =>
      'Masukkan URL server DoH kustom, dipisahkan dengan koma. Minimal 2 server diperlukan untuk verifikasi silang.';

  @override
  String get settingsDnsLabel => 'URL Server DoH';

  @override
  String get settingsDnsReset => 'Reset ke Default';

  @override
  String get settingsSectionSync => 'Sinkronisasi';

  @override
  String get settingsSyncAccount => 'Akun';

  @override
  String get settingsSyncNotLoggedIn => 'Belum masuk';

  @override
  String get settingsSyncStatus => 'Sinkronisasi';

  @override
  String get settingsSyncServerUrl => 'URL Server';

  @override
  String get settingsSyncDefaultServer => 'Default (sshvault.app)';

  @override
  String get accountTitle => 'Akun';

  @override
  String get accountNotLoggedIn => 'Belum masuk';

  @override
  String get accountVerified => 'Terverifikasi';

  @override
  String get accountMemberSince => 'Anggota sejak';

  @override
  String get accountDevices => 'Perangkat';

  @override
  String get accountNoDevices => 'Tidak ada perangkat terdaftar';

  @override
  String get accountLastSync => 'Sinkronisasi terakhir';

  @override
  String get accountChangePassword => 'Ubah Kata Sandi';

  @override
  String get accountOldPassword => 'Kata Sandi Saat Ini';

  @override
  String get accountNewPassword => 'Kata Sandi Baru';

  @override
  String get accountDeleteAccount => 'Hapus Akun';

  @override
  String get accountDeleteWarning =>
      'Ini akan menghapus akun Anda dan semua data yang disinkronkan secara permanen. Ini tidak dapat dibatalkan.';

  @override
  String get accountLogout => 'Keluar';

  @override
  String get serverConfigTitle => 'Konfigurasi Server';

  @override
  String get serverConfigUrlLabel => 'URL Server';

  @override
  String get serverConfigTest => 'Tes Koneksi';

  @override
  String get serverSetupTitle => 'Pengaturan Server';

  @override
  String get serverSetupInfoCard =>
      'ShellVault memerlukan server yang dihosting sendiri untuk sinkronisasi terenkripsi ujung ke ujung. Deploy instansi Anda sendiri untuk memulai.';

  @override
  String get serverSetupRepoLink => 'Lihat di GitHub';

  @override
  String get serverSetupContinue => 'Lanjutkan';

  @override
  String get settingsServerNotConfigured =>
      'Tidak ada server yang dikonfigurasi';

  @override
  String get settingsSetupSync =>
      'Atur sinkronisasi untuk mencadangkan data Anda';

  @override
  String get settingsChangeServer => 'Ubah Server';

  @override
  String get settingsChangeServerConfirm =>
      'Mengubah server akan mengeluarkan Anda. Lanjutkan?';

  @override
  String get auditLogTitle => 'Log Aktivitas';

  @override
  String get auditLogAll => 'Semua';

  @override
  String get auditLogEmpty => 'Tidak ada log aktivitas ditemukan';

  @override
  String get navSftp => 'SFTP';

  @override
  String get sftpTitle => 'Manajer File';

  @override
  String get sftpLocalDevice => 'Perangkat Lokal';

  @override
  String get sftpSelectServer => 'Pilih server...';

  @override
  String get sftpConnecting => 'Menghubungkan...';

  @override
  String get sftpEmptyDirectory => 'Direktori ini kosong';

  @override
  String get sftpNoConnection => 'Tidak ada server terhubung';

  @override
  String get sftpPathLabel => 'Path';

  @override
  String get sftpUpload => 'Unggah';

  @override
  String get sftpDownload => 'Unduh';

  @override
  String get sftpDelete => 'Hapus';

  @override
  String get sftpRename => 'Ganti Nama';

  @override
  String get sftpNewFolder => 'Folder Baru';

  @override
  String get sftpNewFolderName => 'Nama folder';

  @override
  String get sftpChmod => 'Izin';

  @override
  String get sftpChmodTitle => 'Ubah Izin';

  @override
  String get sftpChmodOctal => 'Oktal';

  @override
  String get sftpChmodOwner => 'Pemilik';

  @override
  String get sftpChmodGroup => 'Grup';

  @override
  String get sftpChmodOther => 'Lainnya';

  @override
  String get sftpChmodRead => 'Baca';

  @override
  String get sftpChmodWrite => 'Tulis';

  @override
  String get sftpChmodExecute => 'Eksekusi';

  @override
  String get sftpCreateSymlink => 'Buat Symlink';

  @override
  String get sftpSymlinkTarget => 'Path target';

  @override
  String get sftpSymlinkName => 'Nama link';

  @override
  String get sftpFilePreview => 'Pratinjau File';

  @override
  String get sftpFileInfo => 'Info File';

  @override
  String get sftpFileSize => 'Ukuran';

  @override
  String get sftpFileModified => 'Dimodifikasi';

  @override
  String get sftpFilePermissions => 'Izin';

  @override
  String get sftpFileOwner => 'Pemilik';

  @override
  String get sftpFileType => 'Jenis';

  @override
  String get sftpFileLinkTarget => 'Target link';

  @override
  String get sftpTransfers => 'Transfer';

  @override
  String sftpTransferProgress(int current, int total) {
    return '$current dari $total';
  }

  @override
  String get sftpTransferQueued => 'Dalam Antrean';

  @override
  String get sftpTransferActive => 'Mentransfer...';

  @override
  String get sftpTransferPaused => 'Dijeda';

  @override
  String get sftpTransferCompleted => 'Selesai';

  @override
  String get sftpTransferFailed => 'Gagal';

  @override
  String get sftpTransferCancelled => 'Dibatalkan';

  @override
  String get sftpPauseTransfer => 'Jeda';

  @override
  String get sftpResumeTransfer => 'Lanjutkan';

  @override
  String get sftpCancelTransfer => 'Batal';

  @override
  String get sftpClearCompleted => 'Hapus yang selesai';

  @override
  String sftpTransferCount(int active, int total) {
    return '$active dari $total transfer';
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
      other: '$count selesai',
      one: '1 selesai',
    );
    return '$_temp0';
  }

  @override
  String sftpTransferCountFailed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gagal',
      one: '1 gagal',
    );
    return '$_temp0';
  }

  @override
  String get sftpCopyToOtherPane => 'Salin ke panel lain';

  @override
  String sftpConfirmDelete(int count) {
    return 'Hapus $count item?';
  }

  @override
  String sftpConfirmDeleteSingle(String name) {
    return 'Hapus \"$name\"?';
  }

  @override
  String get sftpDeleteSuccess => 'Berhasil dihapus';

  @override
  String get sftpRenameTitle => 'Ganti Nama';

  @override
  String get sftpRenameLabel => 'Nama baru';

  @override
  String get sftpSortByName => 'Nama';

  @override
  String get sftpSortBySize => 'Ukuran';

  @override
  String get sftpSortByDate => 'Tanggal';

  @override
  String get sftpSortByType => 'Jenis';

  @override
  String get sftpShowHidden => 'Tampilkan file tersembunyi';

  @override
  String get sftpHideHidden => 'Sembunyikan file tersembunyi';

  @override
  String get sftpSelectAll => 'Pilih semua';

  @override
  String get sftpDeselectAll => 'Batal pilih semua';

  @override
  String sftpItemsSelected(int count) {
    return '$count dipilih';
  }

  @override
  String get sftpRefresh => 'Segarkan';

  @override
  String sftpConnectionError(String message) {
    return 'Koneksi gagal: $message';
  }

  @override
  String get sftpPermissionDenied => 'Izin ditolak';

  @override
  String sftpOperationFailed(String message) {
    return 'Operasi gagal: $message';
  }

  @override
  String get sftpOverwriteTitle => 'File sudah ada';

  @override
  String sftpOverwriteMessage(String fileName) {
    return '\"$fileName\" sudah ada. Timpa?';
  }

  @override
  String get sftpOverwrite => 'Timpa';

  @override
  String sftpTransferStarted(String fileName) {
    return 'Transfer dimulai: $fileName';
  }

  @override
  String get sftpNoPaneSelected => 'Pilih tujuan di panel lain terlebih dahulu';

  @override
  String get sftpDirectoryTransferNotSupported =>
      'Transfer direktori segera hadir';

  @override
  String get sftpSelect => 'Pilih';

  @override
  String get sftpOpen => 'Buka';

  @override
  String get sftpExtractArchive => 'Ekstrak di Sini';

  @override
  String get sftpExtractSuccess => 'Arsip diekstrak';

  @override
  String sftpExtractFailed(String message) {
    return 'Ekstraksi gagal: $message';
  }

  @override
  String get sftpExtractUnsupported => 'Format arsip tidak didukung';

  @override
  String get sftpExtracting => 'Mengekstrak...';

  @override
  String sftpUploadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unggahan dimulai',
      one: 'Unggahan dimulai',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadStarted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unduhan dimulai',
      one: 'Unduhan dimulai',
    );
    return '$_temp0';
  }

  @override
  String sftpDownloadComplete(String fileName) {
    return '\"$fileName\" diunduh';
  }

  @override
  String get sftpSavedToDownloads => 'Disimpan ke Downloads/SSHVault';

  @override
  String get sftpSaveToFiles => 'Simpan ke File';

  @override
  String get sftpFileSaved => 'File disimpan';

  @override
  String notificationTerminalTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesi SSH aktif',
      one: 'Sesi SSH aktif',
    );
    return '$_temp0';
  }

  @override
  String get notificationTerminalTap => 'Ketuk untuk membuka terminal';

  @override
  String get settingsAccountAndSync => 'Akun & Sinkronisasi';

  @override
  String get settingsAccountSubtitleAuth => 'Sudah masuk';

  @override
  String get settingsAccountSubtitleUnauth => 'Belum masuk';

  @override
  String get settingsSecuritySubtitle => 'Kunci Otomatis, Biometrik, PIN';

  @override
  String get settingsSshSubtitle => 'Port 22, Pengguna root';

  @override
  String get settingsAppearanceSubtitle => 'Tema, Bahasa, Terminal';

  @override
  String get settingsNetworkSubtitle => 'DNS-over-HTTPS';

  @override
  String get settingsExportSubtitle => 'Default ekspor terenkripsi';

  @override
  String get settingsAboutSubtitle => 'Versi, Lisensi';

  @override
  String get settingsSearchHint => 'Cari pengaturan...';

  @override
  String get settingsSearchNoResults => 'Pengaturan tidak ditemukan';

  @override
  String get aboutDeveloper => 'Dikembangkan oleh Kiefer Networks';

  @override
  String get aboutDonate => 'Donasi';

  @override
  String get aboutOpenSourceLicenses => 'Lisensi Sumber Terbuka';

  @override
  String get aboutWebsite => 'Situs Web';

  @override
  String get aboutVersion => 'Versi';

  @override
  String get aboutBuild => 'Build';

  @override
  String get settingsDohDescription =>
      'DNS-over-HTTPS mengenkripsi kueri DNS dan mencegah DNS spoofing. SSHVault memeriksa hostname terhadap beberapa penyedia untuk mendeteksi serangan.';

  @override
  String get settingsDnsAddServer => 'Tambah Server DNS';

  @override
  String get settingsDnsServerUrl => 'URL Server';

  @override
  String get settingsDnsDefaultBadge => 'Default';

  @override
  String get settingsDnsResetDefaults => 'Reset ke Default';

  @override
  String get settingsDnsInvalidUrl => 'Masukkan URL HTTPS yang valid';

  @override
  String get settingsDefaultAuthMethod => 'Metode Autentikasi';

  @override
  String get settingsAuthPassword => 'Kata Sandi';

  @override
  String get settingsAuthKey => 'Kunci SSH';

  @override
  String get settingsConnectionTimeout => 'Batas Waktu Koneksi';

  @override
  String settingsConnectionTimeoutValue(int seconds) {
    return '${seconds}d';
  }

  @override
  String get settingsKeepaliveInterval => 'Interval Keep-Alive';

  @override
  String settingsKeepaliveIntervalValue(int seconds) {
    return '${seconds}d';
  }

  @override
  String get settingsCompression => 'Kompresi';

  @override
  String get settingsCompressionDescription =>
      'Aktifkan kompresi zlib untuk koneksi SSH';

  @override
  String get settingsTerminalType => 'Jenis Terminal';

  @override
  String get settingsSectionConnection => 'Koneksi';

  @override
  String get settingsClipboardAutoClear => 'Hapus Clipboard Otomatis';

  @override
  String get settingsClipboardAutoClearOff => 'Mati';

  @override
  String settingsClipboardAutoClearValue(int seconds) {
    return '${seconds}d';
  }

  @override
  String get settingsSessionTimeout => 'Batas Waktu Sesi';

  @override
  String get settingsSessionTimeoutOff => 'Mati';

  @override
  String settingsSessionTimeoutValue(int minutes) {
    return '$minutes menit';
  }

  @override
  String get settingsDuressPin => 'PIN Darurat';

  @override
  String get settingsDuressPinDescription =>
      'PIN terpisah yang menghapus semua data saat dimasukkan';

  @override
  String get settingsDuressPinSet => 'PIN Darurat telah diatur';

  @override
  String get settingsDuressPinNotSet => 'Belum dikonfigurasi';

  @override
  String get settingsDuressPinWarning =>
      'Memasukkan PIN ini akan menghapus semua data lokal secara permanen termasuk kredensial, kunci, dan pengaturan. Ini tidak dapat dibatalkan.';

  @override
  String get settingsKeyRotationReminder => 'Pengingat Rotasi Kunci';

  @override
  String get settingsKeyRotationOff => 'Mati';

  @override
  String settingsKeyRotationValue(int days) {
    return '$days hari';
  }

  @override
  String get settingsFailedAttempts => 'Percobaan PIN Gagal';

  @override
  String get settingsSectionAppLock => 'Kunci Aplikasi';

  @override
  String get settingsSectionPrivacy => 'Privasi';

  @override
  String get settingsSectionReminders => 'Pengingat';

  @override
  String get settingsSectionStatus => 'Status';

  @override
  String get settingsExportBackupSubtitle => 'Ekspor, Impor & Cadangan';

  @override
  String get settingsExportJson => 'Ekspor sebagai JSON';

  @override
  String get settingsExportEncrypted => 'Ekspor Terenkripsi';

  @override
  String get settingsImportFile => 'Impor dari File';

  @override
  String get settingsSectionImport => 'Impor';

  @override
  String get filterTitle => 'Filter Server';

  @override
  String get filterApply => 'Terapkan Filter';

  @override
  String get filterClearAll => 'Hapus Semua';

  @override
  String filterActiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filter aktif',
      one: '1 filter aktif',
    );
    return '$_temp0';
  }

  @override
  String get filterFolder => 'Folder';

  @override
  String get filterTags => 'Tag';

  @override
  String get filterStatus => 'Status';

  @override
  String get variablePreviewResolved => 'Pratinjau Resolved';

  @override
  String get variableInsert => 'Sisipkan';

  @override
  String tagServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count server',
      one: '1 server',
    );
    return '$_temp0';
  }

  @override
  String logoutAllDevicesSuccessCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesi dicabut.',
      one: '1 sesi dicabut.',
    );
    return '$_temp0 Anda telah keluar.';
  }

  @override
  String get keyGenPassphrase => 'Frasa Sandi';

  @override
  String get keyGenPassphraseHint => 'Opsional — melindungi kunci privat';

  @override
  String get settingsDnsDefaultQuad9Mullvad => 'Default (Quad9 + Mullvad)';

  @override
  String sshKeyDuplicate(String name) {
    return 'Kunci dengan sidik jari yang sama sudah ada: \"$name\". Setiap kunci SSH harus unik.';
  }

  @override
  String get sshKeyFingerprint => 'Sidik Jari';

  @override
  String get sshKeyPublicKey => 'Kunci Publik';

  @override
  String get jumpHost => 'Jump Host';

  @override
  String get jumpHostNone => 'Tidak Ada';

  @override
  String get jumpHostLabel => 'Hubungkan melalui jump host';

  @override
  String get jumpHostSelfError =>
      'Server tidak dapat menjadi jump host-nya sendiri';

  @override
  String get jumpHostConnecting => 'Menghubungkan ke jump host...';

  @override
  String get jumpHostCircularError => 'Rantai jump host sirkuler terdeteksi';

  @override
  String get logoutDialogTitle => 'Keluar';

  @override
  String get logoutDialogMessage =>
      'Apakah Anda ingin menghapus semua data lokal? Server, kunci SSH, snippet, dan pengaturan akan dihapus dari perangkat ini.';

  @override
  String get logoutOnly => 'Keluar saja';

  @override
  String get logoutAndDelete => 'Keluar & hapus data';

  @override
  String get changeAvatar => 'Ubah Avatar';

  @override
  String get removeAvatar => 'Hapus Avatar';

  @override
  String get avatarUploadFailed => 'Gagal mengunggah avatar';

  @override
  String get avatarTooLarge => 'Gambar terlalu besar';

  @override
  String get deviceLastSeen => 'Terakhir terlihat';

  @override
  String get deviceIpAddress => 'IP';

  @override
  String get serverUrlLockedWhileLoggedIn =>
      'URL server tidak dapat diubah saat masuk. Keluar terlebih dahulu.';

  @override
  String get serverListNoFolder => 'Tidak Terkategori';

  @override
  String get autoSyncInterval => 'Interval Sinkronisasi';

  @override
  String autoSyncIntervalValue(int minutes) {
    return '$minutes menit';
  }

  @override
  String get proxySettings => 'Pengaturan Proxy';

  @override
  String get proxyType => 'Jenis Proxy';

  @override
  String get proxyNone => 'Tanpa Proxy';

  @override
  String get proxySocks5 => 'SOCKS5';

  @override
  String get proxyHttpConnect => 'HTTP CONNECT';

  @override
  String get proxyHost => 'Host Proxy';

  @override
  String get proxyPort => 'Port Proxy';

  @override
  String get proxyUsername => 'Nama Pengguna Proxy';

  @override
  String get proxyPassword => 'Kata Sandi Proxy';

  @override
  String get proxyUseGlobal => 'Gunakan Proxy Global';

  @override
  String get proxyGlobal => 'Global';

  @override
  String get proxyServerSpecific => 'Spesifik server';

  @override
  String get proxyTestConnection => 'Tes Koneksi';

  @override
  String get proxyTestSuccess => 'Proxy dapat dijangkau';

  @override
  String get proxyTestFailed => 'Proxy tidak dapat dijangkau';

  @override
  String get proxyDefaultProxy => 'Proxy Default';

  @override
  String get vpnRequired => 'VPN Diperlukan';

  @override
  String get vpnRequiredTooltip =>
      'Tampilkan peringatan saat menghubungkan tanpa VPN aktif';

  @override
  String get vpnActive => 'VPN Aktif';

  @override
  String get vpnInactive => 'VPN Tidak Aktif';

  @override
  String get vpnWarningTitle => 'VPN Tidak Aktif';

  @override
  String get vpnWarningMessage =>
      'Server ini ditandai memerlukan koneksi VPN, tetapi tidak ada VPN yang aktif saat ini. Apakah Anda ingin tetap terhubung?';

  @override
  String get vpnConnectAnyway => 'Tetap Hubungkan';

  @override
  String get postConnectCommands => 'Perintah Pasca-Koneksi';

  @override
  String get postConnectCommandsHint => 'cd /var/log\ntail -f syslog';

  @override
  String get postConnectCommandsSubtitle =>
      'Perintah yang dieksekusi otomatis setelah koneksi (satu per baris)';

  @override
  String get dashboardFavorites => 'Favorit';

  @override
  String get dashboardRecent => 'Terbaru';

  @override
  String get dashboardActiveSessions => 'Sesi Aktif';

  @override
  String get addToFavorites => 'Tambah ke Favorit';

  @override
  String get removeFromFavorites => 'Hapus dari Favorit';

  @override
  String get noRecentConnections => 'Tidak ada koneksi terbaru';

  @override
  String get terminalSplit => 'Tampilan Terpisah';

  @override
  String get terminalUnsplit => 'Tutup Pemisahan';

  @override
  String get terminalSelectSession => 'Pilih sesi untuk tampilan terpisah';

  @override
  String get knownHostsTitle => 'Host yang Dikenal';

  @override
  String get knownHostsSubtitle => 'Kelola sidik jari server terpercaya';

  @override
  String get hostKeyNewTitle => 'Host Baru';

  @override
  String hostKeyNewMessage(String hostname, int port) {
    return 'Koneksi pertama ke $hostname:$port. Verifikasi sidik jari sebelum menghubungkan.';
  }

  @override
  String get hostKeyChangedTitle => 'Kunci Host Berubah!';

  @override
  String hostKeyChangedMessage(String hostname, int port) {
    return 'Kunci host untuk $hostname:$port telah berubah. Ini bisa menunjukkan ancaman keamanan.';
  }

  @override
  String get hostKeyFingerprint => 'Sidik Jari';

  @override
  String get hostKeyType => 'Jenis Kunci';

  @override
  String get hostKeyTrustConnect => 'Percaya & Hubungkan';

  @override
  String get hostKeyAcceptNew => 'Terima Kunci Baru';

  @override
  String get hostKeyReject => 'Tolak';

  @override
  String get hostKeyPreviousFingerprint => 'Sidik Jari Sebelumnya';

  @override
  String get hostKeyDeleteAll => 'Hapus Semua Host yang Dikenal';

  @override
  String get hostKeyDeleteConfirm =>
      'Apakah Anda yakin ingin menghapus semua host yang dikenal? Anda akan diminta lagi pada koneksi berikutnya.';

  @override
  String get hostKeyEmpty => 'Belum ada host yang dikenal';

  @override
  String get hostKeyEmptySubtitle =>
      'Sidik jari host akan disimpan di sini setelah koneksi pertama Anda';

  @override
  String get hostKeyFirstSeen => 'Pertama kali terlihat';

  @override
  String get hostKeyLastSeen => 'Terakhir terlihat';

  @override
  String get sshConfigImportTitle => 'Impor Konfigurasi SSH';

  @override
  String get sshConfigImportPickFile => 'Pilih File Konfigurasi SSH';

  @override
  String get sshConfigImportOrPaste => 'Atau tempel konten konfigurasi';

  @override
  String sshConfigImportParsed(int count) {
    return '$count host ditemukan';
  }

  @override
  String get sshConfigImportButton => 'Impor';

  @override
  String sshConfigImportSuccess(int count) {
    return '$count server diimpor';
  }

  @override
  String get sshConfigImportDuplicate => 'Sudah ada';

  @override
  String get sshConfigImportNoHosts =>
      'Tidak ada host ditemukan di konfigurasi';

  @override
  String get sftpBookmarkAdd => 'Tambah Penanda';

  @override
  String get sftpBookmarkLabel => 'Label';

  @override
  String get disconnect => 'Putuskan';

  @override
  String get reportAndDisconnect => 'Laporkan & Putuskan';

  @override
  String get continueAnyway => 'Tetap Lanjutkan';

  @override
  String get insertSnippet => 'Sisipkan Snippet';

  @override
  String get seconds => 'Detik';

  @override
  String get heartbeatLostMessage =>
      'Server tidak dapat dijangkau setelah beberapa percobaan. Demi keamanan Anda, sesi telah dihentikan.';

  @override
  String get attestationFailedTitle => 'Verifikasi Server Gagal';

  @override
  String get attestationFailedMessage =>
      'Server tidak dapat diverifikasi sebagai backend SSHVault yang sah. Ini mungkin menunjukkan serangan man-in-the-middle atau server yang salah konfigurasi.';

  @override
  String get attestationKeyChangedTitle => 'Kunci Server Berubah';

  @override
  String get attestationKeyChangedMessage =>
      'Kunci attestasi server telah berubah sejak koneksi awal. Ini mungkin menunjukkan serangan man-in-the-middle. JANGAN lanjutkan kecuali administrator server telah mengonfirmasi rotasi kunci.';

  @override
  String get sectionLinks => 'Tautan';

  @override
  String get sectionDeveloper => 'Pengembang';

  @override
  String get sectionDnsOverHttps => 'DNS-over-HTTPS';

  @override
  String get pageNotFound => 'Halaman tidak ditemukan';

  @override
  String get connectionTestSuccess => 'Koneksi berhasil';

  @override
  String connectionTestFailed(String message) {
    return 'Koneksi gagal: $message';
  }

  @override
  String get serverVerificationFailed => 'Verifikasi server gagal';

  @override
  String get importSuccessful => 'Impor berhasil';

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
  String get deviceDeleteConfirmTitle => 'Hapus Perangkat';

  @override
  String deviceDeleteConfirmMessage(String name) {
    return 'Yakin ingin menghapus \"$name\"? Perangkat akan segera keluar.';
  }

  @override
  String get deviceDeleteCurrentConfirmMessage =>
      'Ini adalah perangkat Anda saat ini. Anda akan segera keluar.';

  @override
  String get deviceDeleteSuccess => 'Perangkat dihapus';

  @override
  String get deviceDeletedCurrentLogout =>
      'Perangkat saat ini dihapus. Anda telah keluar.';

  @override
  String get thisDevice => 'Perangkat ini';
}
