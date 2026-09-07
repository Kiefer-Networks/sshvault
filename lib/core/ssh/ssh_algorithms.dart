import 'package:dartssh2/dartssh2.dart';

/// Retain SSHVault's SHA-2-only MAC policy on top of upstream secure defaults.
const sshVaultAlgorithms = SSHAlgorithms(
  mac: [
    SSHMacType.hmacSha256Etm,
    SSHMacType.hmacSha512Etm,
    SSHMacType.hmacSha256,
    SSHMacType.hmacSha512,
  ],
);
