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
  <a href="LICENSE"><img src="https://img.shields.io/github/license/Kiefer-Networks/sshvault?style=flat-square" alt="License"></a>
  <a href="https://kiefer-networks.de"><img src="https://img.shields.io/badge/by-Kiefer%20Networks-blue?style=flat-square" alt="Kiefer Networks"></a>
  <a href="https://de.liberapay.com/beli3ver"><img src="https://img.shields.io/liberapay/receives/beli3ver.svg?logo=liberapay" alt="Donate"></a>
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
| **SSH Terminal** | Split view, tabs, multiple simultaneous sessions |
| **SFTP File Manager** | Browse, transfer, rename, archive extraction, bookmarks |
| **Zero-Knowledge Encryption** | AES-256-GCM with Argon2id key derivation |
| **Host Key Verification** | Trust On First Use (TOFU) with known hosts management |
| **SSH Key Management** | Ed25519, RSA, ECDSA key generation and import |
| **SSH Config Import** | Import hosts and keys from `~/.ssh/config` on desktop |
| **Jump Hosts** | ProxyJump support for multi-hop connections |
| **Code Snippets** | Save and organize frequently used commands |
| **Server Organization** | Folders, tags, color codes, search and filtering |
| **Post-Connect Commands** | Auto-run commands after connection |
| **Biometric Lock** | Fingerprint/Face ID with PIN fallback and duress PIN |
| **Cross-Device Sync** | End-to-end encrypted via self-hosted backend |

## Platforms

| Platform | Status |
|----------|--------|
| Android | Supported |
| iOS / iPadOS | Supported |
| macOS | Supported |
| Linux | Supported (Flatpak) |
| Windows | Supported |

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

## Architecture

- **Client:** Flutter 3.41+ / Dart 3.11+
- **Backend:** [sshvault-server](https://github.com/Kiefer-Networks/sshvault-api) — Go 1.26+, PostgreSQL 16+, chi router
- **State Management:** Riverpod (no setState)
- **Local Database:** Drift (SQLite) + Platform Secure Storage
- **Routing:** go_router (declarative)
- **SSH:** dartssh2 (hardened fork)
- **Design:** Material 3 on all platforms

Clean Architecture with feature-based folder structure. Structured logging only.

## Building

### Prerequisites

- Flutter SDK 3.41+
- For Linux: `sudo dnf install libsecret-devel` (Fedora) or `sudo apt install libsecret-1-dev` (Debian/Ubuntu)

### Build

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

### Release builds

```bash
flutter build appbundle --release   # Android
flutter build ipa --release         # iOS
flutter build linux --release       # Linux
flutter build macos --release       # macOS
flutter build windows --release     # Windows
```

### Tests

```bash
flutter test
```

## Backend

The self-hosted backend handles encrypted vault sync and authentication. It never processes plaintext user data.

See [sshvault-server](https://github.com/Kiefer-Networks/sshvault-api) for setup instructions.

## Localization

Available in English, German, and Spanish. Translation files are in `lib/l10n/`.

## Donate

If you find SSHVault useful, consider supporting development:

[Donate via Liberapay](https://de.liberapay.com/beli3ver)

## License

Copyright (C) 2024-2026 [Kiefer Networks](https://kiefer-networks.de)

This program is licensed under the [GNU Affero General Public License v3.0](LICENSE).

The bundled `dartssh2` fork (`packages/dartssh2/`) is licensed under the [MIT License](packages/dartssh2/LICENSE).
