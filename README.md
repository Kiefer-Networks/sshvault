<p align="center">
  <img src="assets/images/app_icon.png" alt="SSHVault" width="128" height="128">
</p>

<h1 align="center">SSHVault</h1>

<p align="center">
  <strong>Zero-Knowledge Encrypted SSH Client</strong><br>
  Secure, self-hosted, cross-platform terminal and SFTP manager
</p>

<p align="center">
  <a href="https://github.com/Kiefer-Networks/sshvault/releases"><img src="https://img.shields.io/github/v/release/Kiefer-Networks/sshvault?style=flat-square" alt="Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-AGPL--3.0-blue?style=flat-square" alt="License: AGPL-3.0"></a>
  <a href="https://github.com/Kiefer-Networks/sshvault/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/Kiefer-Networks/sshvault/ci.yml?style=flat-square&label=CI" alt="CI"></a>
  <a href="https://github.com/Kiefer-Networks/sshvault/issues"><img src="https://img.shields.io/github/issues/Kiefer-Networks/sshvault?style=flat-square" alt="Issues"></a>
  <a href="https://github.com/Kiefer-Networks/sshvault/stargazers"><img src="https://img.shields.io/github/stars/Kiefer-Networks/sshvault?style=flat-square" alt="Stars"></a>
</p>

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=de.kiefer_networks.sshvault"><img src="https://img.shields.io/badge/Google%20Play-414141?style=flat-square&logo=google-play&logoColor=white" alt="Google Play"></a>
  <a href="https://fdroid.kiefer-networks.de/fdroid/repo/"><img src="https://img.shields.io/badge/F--Droid-repo-1976D2?style=flat-square&logo=f-droid" alt="F-Droid Repo"></a>
  <a href="https://kiefer-networks.de"><img src="https://img.shields.io/badge/by-Kiefer%20Networks-blue?style=flat-square" alt="Kiefer Networks"></a>
  <a href="https://de.liberapay.com/beli3ver"><img src="https://img.shields.io/badge/donate-Liberapay-F6C915?style=flat-square&logo=liberapay" alt="Donate via Liberapay"></a>
</p>

---

SSHVault is a cross-platform SSH terminal and SFTP file manager that encrypts all data client-side before syncing. The server never sees your plaintext credentials, keys, or session data.

## Screenshots

<p align="center">
  <img src="metadata/en-US/images/phoneScreenshots/1.png" alt="Host List" width="180">
  <img src="metadata/en-US/images/phoneScreenshots/2.png" alt="Navigation" width="180">
  <img src="metadata/en-US/images/phoneScreenshots/3.png" alt="Add Server" width="180">
  <img src="metadata/en-US/images/phoneScreenshots/4.png" alt="SSH Keys" width="180">
</p>
<p align="center">
  <img src="metadata/en-US/images/phoneScreenshots/5.png" alt="SSH Terminal" width="180">
  <img src="metadata/en-US/images/phoneScreenshots/6.png" alt="SFTP File Manager" width="180">
  <img src="metadata/en-US/images/phoneScreenshots/7.png" alt="Settings" width="180">
</p>

## Features

| Feature | Description |
|---------|-------------|
| **SSH Terminal** | Split view, tabs, multiple simultaneous sessions, xterm-256color emulation |
| **SFTP File Manager** | Browse, transfer, rename, chmod, symlinks, archive extraction, bookmarks |
| **Zero-Knowledge Encryption** | AES-256-GCM with Argon2id key derivation |
| **Host Key Verification** | Trust On First Use (TOFU) with known hosts management |
| **SSH Key Management** | Ed25519, RSA, ECDSA key generation and import |
| **SSH Config Import** | Import hosts and keys from `~/.ssh/config` on desktop |
| **Jump Hosts** | ProxyJump support for multi-hop connections |
| **Proxy Support** | SOCKS5 and HTTP CONNECT, global or per-server configuration |
| **Code Snippets** | Save and organize frequently used commands |
| **Server Organization** | Folders, tags, color codes, icons, search and filtering |
| **Post-Connect Commands** | Auto-run commands after connection |
| **Biometric Lock** | Fingerprint/Face ID with PIN fallback and duress PIN |
| **Cross-Device Sync** | End-to-end encrypted via self-hosted backend |
| **Keep-Alive & Timeouts** | Configurable keep-alive interval and connection timeout |
| **SSH Compression** | Optional compression toggle for slow connections |
| **Export & Import** | Full backup and restore of all data |
| **No Tracking** | No analytics, no telemetry, no ads, no in-app purchases |

## Platforms

| Platform | Status |
|----------|--------|
| Android | Supported |
| iOS / iPadOS | Supported |
| macOS | Supported |
| Linux | Supported (Flatpak) |
| Windows | Supported |

## Install via F-Droid Repo

Add the Kiefer Networks F-Droid repository to your F-Droid client:

```
https://fdroid.kiefer-networks.de/fdroid/repo/
```

## Install via Obtainium

You can install SSHVault directly from GitHub releases using [Obtainium](https://github.com/ImranR98/Obtainium):

1. Open Obtainium and tap **Add App**
2. Enter the source URL:
   ```
   https://github.com/Kiefer-Networks/sshvault
   ```
3. Set **Release asset filter** to `arm64-v8a` (or your architecture)
4. Tap **Add** — Obtainium will track new releases and notify you of updates

## Security

| Layer | Implementation |
|-------|---------------|
| Encryption | AES-256-GCM, 12-byte counter nonces |
| Key Derivation | Argon2id (256 MiB, 3 iterations, p=1) |
| SSH Transport | CSPRNG padding, SHA-256 fingerprints, constant-time MAC |
| Server Attestation | Ed25519 TOFU key pinning (official + self-hosted) |
| DNS | DNS-over-HTTPS with multi-provider cross-verification |
| Storage | Platform keychain (Keystore / Keychain / libsecret / DPAPI) |
| PIN | Argon2id hashed, brute-force lockout, duress wipe |
| Server | Response padding, timing equalization, PoW challenges |

Weak algorithms (DH-group1, CBC ciphers, HMAC-MD5/SHA1, ssh-rsa) are excluded from default negotiation.

### Supported SSH algorithms

The bundled hardened `dartssh2` fork advertises only modern algorithms.
Connections to servers that require something not on this list will fail
during the SSH transport handshake (the connect dialog reports which
class — KEX, cipher, MAC, host key — was rejected).

| Layer | Supported (in negotiation order) |
|-------|----------------------------------|
| Key exchange | `mlkem768x25519-sha256`, `sntrup761x25519-sha512@openssh.com`, `curve25519-sha256@libssh.org`, `ecdh-sha2-nistp521`, `ecdh-sha2-nistp384`, `ecdh-sha2-nistp256`, `diffie-hellman-group-exchange-sha256`, `diffie-hellman-group14-sha256` |
| Host key | `ssh-ed25519`, `rsa-sha2-512`, `rsa-sha2-256`, `ecdsa-sha2-nistp521`, `ecdsa-sha2-nistp384`, `ecdsa-sha2-nistp256` |
| Cipher | `chacha20-poly1305@openssh.com`, `aes256-gcm@openssh.com`, `aes128-gcm@openssh.com`, `aes256-ctr`, `aes128-ctr` |
| MAC | `hmac-sha2-256-etm@openssh.com`, `hmac-sha2-512-etm@openssh.com`, `hmac-sha2-256`, `hmac-sha2-512`, `hmac-sha2-256-96`, `hmac-sha2-512-96` (ignored when an AEAD cipher is selected) |

The two hybrid post-quantum KEX algorithms (`mlkem768x25519-sha256`, `sntrup761x25519-sha512@openssh.com`) match the OpenSSH 9.9+ default order and are advertised first. The KEMs come from the [Open Quantum Safe](https://github.com/open-quantum-safe/liboqs) `liboqs` library bundled per platform via Dart FFI; on builds where `liboqs` is not present (e.g. Flutter web) the names are stripped from the advertised list at runtime and the client falls back to classical KEX without any error.

## Architecture

- **Client:** Flutter 3.11+ / Dart 3.11+
- **Backend:** [sshvault-server](https://github.com/Kiefer-Networks/sshvault-api) — Go 1.26+, PostgreSQL 16+, chi router
- **State Management:** Riverpod (no setState)
- **Local Database:** Drift (SQLite) + Platform Secure Storage
- **Routing:** go_router (declarative)
- **SSH:** dartssh2 (hardened fork)
- **Design:** Material 3 on all platforms

Clean Architecture with feature-based folder structure. Structured logging only.

## Building from Source

### Prerequisites

- Flutter SDK 3.11+ ([install guide](https://docs.flutter.dev/get-started/install))
- Android SDK with `minSdk 33` (Android 13+)
- Java 17+ (for Android builds)
- For Linux: `sudo dnf install libsecret-devel` (Fedora) or `sudo apt install libsecret-1-dev` (Debian/Ubuntu)

### Clone

```bash
git clone https://github.com/Kiefer-Networks/sshvault.git
cd sshvault
```

### Install dependencies and generate code

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### Build Android APK

```bash
# Per-ABI builds (~30 MB each, recommended)
flutter build apk --release --split-per-abi

# Universal build (~80 MB, all architectures)
flutter build apk --release
```

Per-ABI APKs will be at `build/app/outputs/flutter-apk/app-{arm64-v8a,armeabi-v7a,x86_64}-release.apk`.

### Build Android App Bundle (AAB)

```bash
flutter build appbundle --release
```

### Other platforms

```bash
flutter build ipa --release         # iOS
flutter build linux --release       # Linux
flutter build macos --release       # macOS
flutter build windows --release     # Windows
```

### Run tests

```bash
flutter test
```

## Backend

The self-hosted backend handles encrypted vault sync and authentication. It never processes plaintext user data.

See [sshvault-server](https://github.com/Kiefer-Networks/sshvault-api) for setup instructions.

## Localization

Available in 28 languages:

Arabic, Chinese, Czech, Danish, Dutch, English, Finnish, French, German, Greek, Hebrew, Hindi, Hungarian, Indonesian, Italian, Japanese, Korean, Norwegian, Polish, Portuguese, Romanian, Russian, Spanish, Swedish, Thai, Turkish, Ukrainian, Vietnamese

Translation files are in `lib/l10n/`.

## Donate

If you find SSHVault useful, consider supporting development:

[Donate via Liberapay](https://de.liberapay.com/beli3ver)

## License

Copyright (C) 2024-2026 [Kiefer Networks](https://kiefer-networks.de)

This program is licensed under the [GNU Affero General Public License v3.0](LICENSE).

The bundled `dartssh2` fork (`packages/dartssh2/`) is licensed under the [MIT License](packages/dartssh2/LICENSE).
