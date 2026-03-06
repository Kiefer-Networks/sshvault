# SSHVault

Secure, self-hosted SSH client with zero-knowledge sync.

SSHVault is a cross-platform SSH terminal and SFTP file manager that encrypts all data client-side before syncing. The server never sees your plaintext credentials, keys, or session data.

## Features

- **SSH Terminal** — Split view, tabs, multiple simultaneous sessions
- **SFTP File Manager** — Browse, transfer, rename, archive extraction, bookmarks
- **Zero-Knowledge Encryption** — AES-256-GCM with Argon2id key derivation
- **Host Key Verification** — Trust On First Use (TOFU) with known hosts management
- **SSH Key Management** — Ed25519, RSA, ECDSA key generation and import
- **Jump Hosts** — ProxyJump support for multi-hop connections
- **Code Snippets** — Save and organize frequently used commands
- **Server Organization** — Folders, tags, color codes, search
- **Post-Connect Commands** — Auto-run commands after connection
- **Biometric Lock** — Fingerprint/Face ID with PIN fallback and duress PIN
- **Cross-Device Sync** — End-to-end encrypted via self-hosted backend
- **Multi-Platform** — iOS, Android, macOS, Linux, Windows

## Security

| Layer | Implementation |
|-------|---------------|
| Encryption | AES-256-GCM, 12-byte counter nonces |
| Key Derivation | Argon2id (256 MiB, 3 iterations, p=1) |
| SSH Transport | CSPRNG padding, SHA-256 fingerprints, constant-time MAC |
| TLS | Certificate pinning (SPKI SHA-256) |
| DNS | DNS-over-HTTPS with cross-provider verification |
| Storage | Platform keychain (Keystore/Keychain/libsecret/DPAPI) |
| PIN | Argon2id hashed, brute-force lockout, duress wipe |

Weak algorithms (DH-group1, CBC ciphers, HMAC-MD5/SHA1, ssh-rsa) are excluded from default negotiation.

## Architecture

- **Client:** Flutter 3.41+ / Dart 3.11+
- **Backend:** [shellvault-server](https://github.com/Kiefer-Networks/sshvault-api) — Go 1.24+, PostgreSQL 16+, chi router
- **State Management:** Riverpod
- **Local Database:** Drift (SQLite)
- **Routing:** go_router
- **SSH:** dartssh2 (hardened fork)

Clean Architecture with feature-based folder structure. No `setState()`, no `print()` — structured logging only.

## Building

### Prerequisites

- Flutter SDK 3.41+
- For Linux: `sudo dnf install libsecret-devel` (Fedora) or `sudo apt install libsecret-1-dev` (Debian/Ubuntu)

### Build

```bash
# Install dependencies
flutter pub get

# Generate code (drift, freezed, riverpod)
dart run build_runner build --delete-conflicting-outputs

# Generate localizations
flutter gen-l10n

# Run
flutter run

# Build Android AAB
flutter build appbundle --release

# Build iOS
flutter build ipa --release

# Build Linux
flutter build linux --release
```

### Tests

```bash
flutter test
```

## Backend

The self-hosted backend handles encrypted vault sync, authentication, and subscription management. It never processes plaintext user data.

See [shellvault-server](https://github.com/Kiefer-Networks/sshvault-api) for setup instructions.

## Localization

Available in English, German, and Spanish. Translation files are in `lib/l10n/`.

## License

Copyright (C) 2024-2026 [Kiefer Networks](https://kiefer-network.de)

This program is licensed under the [GNU Affero General Public License v3.0](LICENSE).

The bundled `dartssh2` fork (`packages/dartssh2/`) is licensed under the [MIT License](packages/dartssh2/LICENSE).
