# SSHVault Quick Look Extension (macOS)

Renders a Quick Look preview when the user presses Space on a `.pub`,
`.pem` or `.ppk` file in Finder. Shows: type, SHA-256 fingerprint,
comment, and an 80-character snippet of the key data.

The extension is intentionally small. Full key parsing and editing
remains in Dart inside the host app.

## File layout

```
macos/QuickLookExtension/
├── Info.plist                         # NSExtension + UTImportedTypeDeclarations
├── QuickLookExtension.entitlements    # sandbox + user-selected read-only
└── PreviewProvider.swift              # QLPreviewProvider implementation
```

## Code signing

The extension is bundled inside the host `.app` at
`Contents/PlugIns/QuickLookExtension.appex` and is **signed and
provisioned separately** from the host. Both bundles must be signed by
the same Apple Developer team (`DEVELOPMENT_TEAM = 2W8Z745MAL`).

### One-time setup in Apple Developer portal

1. Register the App ID
   `de.kiefer_networks.SSHVault.QuickLookExtension`.
   - Capabilities: App Sandbox, App Groups
     (`de.kiefer-networks.sshvault`).
2. Create a Provisioning Profile (Mac App Store **and** Developer ID
   variants) for that App ID.
3. Download both profiles and install in Xcode.

### In Xcode (per build configuration)

For the `QuickLookExtension` target:

| Setting                              | Value                                                  |
|--------------------------------------|--------------------------------------------------------|
| `PRODUCT_BUNDLE_IDENTIFIER`          | `de.kiefer_networks.SSHVault.QuickLookExtension`       |
| `CODE_SIGN_ENTITLEMENTS`             | `QuickLookExtension/QuickLookExtension.entitlements`   |
| `CODE_SIGN_STYLE`                    | `Automatic` (Debug) / `Manual` (Release for notarizing) |
| `DEVELOPMENT_TEAM`                   | `2W8Z745MAL`                                           |
| `INFOPLIST_FILE`                     | `QuickLookExtension/Info.plist`                        |
| `MACOSX_DEPLOYMENT_TARGET`           | inherits from Runner (currently `26.0`)                |
| `SWIFT_VERSION`                      | `5.0`                                                  |
| `SKIP_INSTALL`                       | `NO` (must be embedded in host)                        |

The host `Runner` target needs an **Embed App Extensions** copy-files
build phase (destination `PlugIns`) that copies
`QuickLookExtension.appex` into the host `.app`. This phase already
runs after the existing **Bundle Framework** phase.

### Notarization

`xcrun notarytool submit sshvault.zip --apple-id ... --team-id 2W8Z745MAL --wait`

Both the host and the embedded `.appex` must be hardened-runtime
signed (`--options runtime`). `codesign --deep --verify` should pass
on the staged app.

## UTI registration

Three UTIs are defined:

| UTI                                      | Extension | Conforms to                |
|------------------------------------------|-----------|----------------------------|
| `de.kiefer-networks.sshvault.public-key` | `.pub`    | `public.text`              |
| `de.kiefer-networks.sshvault.pem-key`    | `.pem`    | `public.text`              |
| `de.kiefer-networks.sshvault.ppk-key`    | `.ppk`    | `public.text`              |

These are **exported** by the host app's `Info.plist`
(`UTExportedTypeDeclarations`) and **imported** by the extension's
`Info.plist` (`UTImportedTypeDeclarations`) so the extension still
matches its UTIs even before the host has been launched once.

## Manual QA

The extension cannot be exercised by Xcode unit tests. Follow these
steps after every change:

1. `flutter build macos --release`
2. Drag the resulting `build/macos/Build/Products/Release/sshvault.app`
   into `/Applications/`. (Quick Look only loads extensions from
   signed apps Launch Services has indexed at least once.)
3. `killall Finder && qlmanage -r && qlmanage -r cache`
4. In Finder, select a test file and press Space:
   - `~/.ssh/id_ed25519.pub`     — should show "SSH Public Key (Ed25519)" + SHA256 fingerprint + comment.
   - `~/.ssh/id_rsa.pub`         — should show "SSH Public Key (RSA)" + SHA256.
   - any `*_rsa` (no extension)  — won't trigger; that's expected.
   - a `.pem`                    — should show "RSA Private Key (PEM)" or similar; no fingerprint.
   - a `.ppk` exported by PuTTYgen — should show the embedded `Comment:` and SHA256 fingerprint of the public blob.
5. Verify in Console.app: filter for `quicklookd`. No crashes, no
   sandbox violations.
6. Sanity check: `qlmanage -p ~/.ssh/id_ed25519.pub` from Terminal
   produces a window with the same HTML.

## Updating the parser

The recogniser in `PreviewProvider.swift` (`KeyInspector`) is
deliberately ~80 lines and separate from the Dart parser. If a new
key format needs to surface in Quick Look, update both:

- Dart side: `lib/.../ssh_key_parser.dart` (full parsing).
- Swift side: `KeyInspector` (just enough to identify + fingerprint).
