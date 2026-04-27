//
//  PreviewProvider.swift
//  SSHVault Quick Look Extension
//
//  Renders a Quick Look preview for SSH key files (.pub / .pem / .ppk).
//  Full key parsing happens in Dart inside the host app — this extension
//  only needs to recognise the format and surface a few human-readable
//  fields (type, SHA-256 fingerprint, comment, snippet).
//

import Foundation
import QuickLookUI
import CryptoKit

@available(macOS 12.0, *)
final class PreviewProvider: QLPreviewProvider, QLPreviewingController {

    // MARK: - QLPreviewProvider

    func providePreview(for request: QLFilePreviewRequest,
                        completionHandler handler: @escaping (QLPreviewReply?, Error?) -> Void) {
        let url = request.fileURL
        let reply = QLPreviewReply(dataOfContentType: .html,
                                   contentSize: CGSize(width: 640, height: 360)) { reply in
            reply.stringEncoding = .utf8
            reply.title = url.lastPathComponent

            let data: Data
            do {
                data = try Data(contentsOf: url)
            } catch {
                return Self.errorHTML("Could not read \(url.lastPathComponent): \(error.localizedDescription)")
                    .data(using: .utf8) ?? Data()
            }

            // Cap reads at ~1 MiB. Real key files are tiny; anything bigger is
            // probably not a key and we don't want to OOM the preview agent.
            let bounded = data.prefix(1024 * 1024)
            let info = KeyInspector.inspect(filename: url.lastPathComponent, data: Data(bounded))
            return Self.previewHTML(for: info).data(using: .utf8) ?? Data()
        }
        handler(reply, nil)
    }

    // For older entry-point compatibility.
    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        try await withCheckedThrowingContinuation { cont in
            providePreview(for: request) { reply, error in
                if let error = error { cont.resume(throwing: error) }
                else if let reply = reply { cont.resume(returning: reply) }
                else { cont.resume(throwing: NSError(domain: "SSHVault.QL", code: -1)) }
            }
        }
    }

    // MARK: - HTML rendering

    private static func previewHTML(for info: KeyInspector.KeyInfo) -> String {
        let title = escape(info.kindDescription)
        let fingerprint = escape(info.fingerprint ?? "—")
        let comment = escape(info.comment ?? "—")
        let snippet = escape(info.snippet ?? "—")

        return """
        <!doctype html>
        <html><head><meta charset="utf-8"/>
        <style>
          :root { color-scheme: light dark; }
          body {
            font-family: -apple-system, "SF Pro Text", "Helvetica Neue", sans-serif;
            margin: 24px; line-height: 1.45; color: #222;
          }
          @media (prefers-color-scheme: dark) {
            body { color: #eee; background: transparent; }
            .label { color: #9aa; }
            code { background: rgba(255,255,255,0.08); }
          }
          h1 { font-size: 18px; margin: 0 0 4px; }
          .sub { color: #888; font-size: 12px; margin-bottom: 18px; }
          dl { display: grid; grid-template-columns: 110px 1fr; gap: 6px 14px; margin: 0; }
          dt { color: #777; font-size: 12px; text-transform: uppercase; letter-spacing: .04em; }
          dd { margin: 0; font-size: 13px; word-break: break-all; }
          code, .mono {
            font-family: "SF Mono", Menlo, Consolas, monospace;
            font-size: 12px;
            background: rgba(0,0,0,0.05);
            padding: 1px 5px; border-radius: 4px;
          }
        </style></head>
        <body>
          <h1>\(title)</h1>
          <div class="sub">SSHVault key preview</div>
          <dl>
            <dt>Type</dt><dd>\(title)</dd>
            <dt>Fingerprint</dt><dd><code>\(fingerprint)</code></dd>
            <dt>Comment</dt><dd>\(comment)</dd>
            <dt>Snippet</dt><dd class="mono">\(snippet)</dd>
          </dl>
        </body></html>
        """
    }

    private static func errorHTML(_ message: String) -> String {
        """
        <!doctype html><html><body style="font-family:-apple-system;margin:24px;color:#a00">
        <h2>SSHVault preview unavailable</h2><p>\(escape(message))</p>
        </body></html>
        """
    }

    private static func escape(_ s: String) -> String {
        s.replacingOccurrences(of: "&", with: "&amp;")
         .replacingOccurrences(of: "<", with: "&lt;")
         .replacingOccurrences(of: ">", with: "&gt;")
         .replacingOccurrences(of: "\"", with: "&quot;")
    }
}

// MARK: - Tiny key recognizer
//
// Goal: identify the file as a public key / OpenSSH private / PEM private /
// PuTTY private key, and pull out (type, fingerprint, comment, snippet).
// We deliberately do NOT attempt full key decryption. That stays in Dart.

enum KeyInspector {
    struct KeyInfo {
        var kindDescription: String
        var fingerprint: String?
        var comment: String?
        var snippet: String?
    }

    static func inspect(filename: String, data: Data) -> KeyInfo {
        guard let text = String(data: data, encoding: .utf8) ??
                         String(data: data, encoding: .ascii) else {
            return KeyInfo(kindDescription: "Unknown key file",
                           fingerprint: nil, comment: nil,
                           snippet: "<binary, \(data.count) bytes>")
        }

        // 1. PuTTY private key
        if let head = text.split(separator: "\n").first,
           head.hasPrefix("PuTTY-User-Key-File-") {
            return inspectPPK(text: text)
        }

        // 2. PEM-style headers (OpenSSH or RSA/EC/DSA private)
        if let pemKind = detectPEMKind(in: text) {
            return KeyInfo(kindDescription: pemKind,
                           fingerprint: nil,
                           comment: extractPEMComment(in: text),
                           snippet: snippet(of: text))
        }

        // 3. Single-line SSH public key (ssh-ed25519 / ssh-rsa / ecdsa-... )
        if let pubInfo = inspectOpenSSHPublic(text: text) {
            return pubInfo
        }

        return KeyInfo(kindDescription: "Unrecognised key file",
                       fingerprint: nil,
                       comment: nil,
                       snippet: snippet(of: text))
    }

    // MARK: OpenSSH public (one line: "<type> <base64> <comment>")

    private static func inspectOpenSSHPublic(text: String) -> KeyInfo? {
        let known = ["ssh-ed25519", "ssh-rsa", "ssh-dss",
                     "ecdsa-sha2-nistp256", "ecdsa-sha2-nistp384", "ecdsa-sha2-nistp521",
                     "sk-ssh-ed25519@openssh.com", "sk-ecdsa-sha2-nistp256@openssh.com"]

        // Find first non-empty, non-comment line.
        let line = text.split(whereSeparator: { $0.isNewline })
                        .first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty
                                        && !$0.hasPrefix("#") })
                        .map(String.init) ?? ""

        let parts = line.split(separator: " ", maxSplits: 2,
                               omittingEmptySubsequences: true).map(String.init)
        guard parts.count >= 2, known.contains(parts[0]) else { return nil }

        let type = parts[0]
        let base64 = parts[1]
        let comment = parts.count >= 3 ? parts[2] : nil

        var fingerprint: String? = nil
        if let raw = Data(base64Encoded: base64) {
            let digest = SHA256.hash(data: raw)
            let b64 = Data(digest).base64EncodedString()
                .trimmingCharacters(in: CharacterSet(charactersIn: "="))
            fingerprint = "SHA256:\(b64)"
        }

        return KeyInfo(
            kindDescription: friendlyTypeName(type),
            fingerprint: fingerprint,
            comment: comment,
            snippet: String(base64.prefix(80)) + (base64.count > 80 ? "…" : "")
        )
    }

    // MARK: PEM kind detection

    private static func detectPEMKind(in text: String) -> String? {
        if text.contains("BEGIN OPENSSH PRIVATE KEY") { return "OpenSSH Private Key" }
        if text.contains("BEGIN RSA PRIVATE KEY")     { return "RSA Private Key (PEM)" }
        if text.contains("BEGIN DSA PRIVATE KEY")     { return "DSA Private Key (PEM)" }
        if text.contains("BEGIN EC PRIVATE KEY")      { return "EC Private Key (PEM)" }
        if text.contains("BEGIN PRIVATE KEY")         { return "PKCS#8 Private Key (PEM)" }
        if text.contains("BEGIN ENCRYPTED PRIVATE KEY") { return "Encrypted PKCS#8 Private Key" }
        if text.contains("BEGIN CERTIFICATE")         { return "X.509 Certificate (PEM)" }
        if text.contains("BEGIN PUBLIC KEY")          { return "Public Key (PEM)" }
        return nil
    }

    private static func extractPEMComment(in text: String) -> String? {
        // OpenSSH wraps a comment inside the binary blob; we won't decode that.
        // Some tools prepend "Comment:" lines (PuTTY-exported PEMs do).
        for line in text.split(whereSeparator: { $0.isNewline }) {
            let l = line.trimmingCharacters(in: .whitespaces)
            if l.lowercased().hasPrefix("comment:") {
                return String(l.dropFirst("comment:".count)).trimmingCharacters(in: .whitespaces)
            }
        }
        return nil
    }

    // MARK: PuTTY .ppk

    private static func inspectPPK(text: String) -> KeyInfo {
        var type = "PuTTY Private Key"
        var comment: String?
        var publicLines: [String] = []
        var inPublic = false
        var publicRemaining = 0

        for raw in text.split(whereSeparator: { $0.isNewline }) {
            let line = String(raw)
            if line.hasPrefix("PuTTY-User-Key-File-") {
                // e.g. "PuTTY-User-Key-File-3: ssh-ed25519"
                let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
                if parts.count == 2 {
                    let algo = parts[1].trimmingCharacters(in: .whitespaces)
                    type = "PuTTY Private Key (\(algo))"
                }
            } else if line.hasPrefix("Comment:") {
                comment = String(line.dropFirst("Comment:".count))
                    .trimmingCharacters(in: .whitespaces)
            } else if line.hasPrefix("Public-Lines:") {
                publicRemaining = Int(line
                    .dropFirst("Public-Lines:".count)
                    .trimmingCharacters(in: .whitespaces)) ?? 0
                inPublic = publicRemaining > 0
            } else if inPublic {
                publicLines.append(line.trimmingCharacters(in: .whitespaces))
                publicRemaining -= 1
                if publicRemaining <= 0 { inPublic = false }
            }
        }

        let publicB64 = publicLines.joined()
        var fingerprint: String?
        if let raw = Data(base64Encoded: publicB64) {
            let digest = SHA256.hash(data: raw)
            let b64 = Data(digest).base64EncodedString()
                .trimmingCharacters(in: CharacterSet(charactersIn: "="))
            fingerprint = "SHA256:\(b64)"
        }

        return KeyInfo(
            kindDescription: type,
            fingerprint: fingerprint,
            comment: comment,
            snippet: String(publicB64.prefix(80)) + (publicB64.count > 80 ? "…" : "")
        )
    }

    // MARK: Helpers

    private static func friendlyTypeName(_ t: String) -> String {
        switch t {
        case "ssh-ed25519": return "SSH Public Key (Ed25519)"
        case "ssh-rsa":     return "SSH Public Key (RSA)"
        case "ssh-dss":     return "SSH Public Key (DSA)"
        case let s where s.hasPrefix("ecdsa-"):    return "SSH Public Key (ECDSA)"
        case let s where s.hasPrefix("sk-"):       return "SSH Public Key (FIDO/U2F-backed)"
        default: return "SSH Public Key (\(t))"
        }
    }

    private static func snippet(of text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let oneLine = trimmed.replacingOccurrences(of: "\n", with: " ")
        return String(oneLine.prefix(80)) + (oneLine.count > 80 ? "…" : "")
    }
}
