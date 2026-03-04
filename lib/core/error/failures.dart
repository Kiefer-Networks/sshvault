sealed class Failure {
  final String message;
  final Object? cause;

  const Failure(this.message, {this.cause});

  @override
  String toString() => '$runtimeType: $message';
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.cause});
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.cause});
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause});
}

final class CryptoFailure extends Failure {
  const CryptoFailure(super.message, {super.cause});
}

final class ExportFailure extends Failure {
  const ExportFailure(super.message, {super.cause});
}

final class ImportFailure extends Failure {
  const ImportFailure(super.message, {super.cause});
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.cause});
}

final class SshConnectionFailure extends Failure {
  const SshConnectionFailure(super.message, {super.cause});
}

final class SftpFailure extends Failure {
  const SftpFailure(super.message, {super.cause});
}

final class NetworkFailure extends Failure {
  final int? statusCode;
  const NetworkFailure(super.message, {this.statusCode, super.cause});
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.cause});
}

final class SyncFailure extends Failure {
  final int? conflictVersion;
  final int? statusCode;
  const SyncFailure(
    super.message, {
    this.conflictVersion,
    this.statusCode,
    super.cause,
  });
}

final class DnsDivergence extends Failure {
  final String hostname;
  final List<String> cloudflareIPs;
  final List<String> googleIPs;
  const DnsDivergence({
    required this.hostname,
    required this.cloudflareIPs,
    required this.googleIPs,
  }) : super('DNS divergence detected');
}

final class SecurityViolation extends Failure {
  const SecurityViolation(super.message, {super.cause});
}

final class DuplicateSshKeyFailure extends Failure {
  final String existingKeyName;
  const DuplicateSshKeyFailure(this.existingKeyName)
    : super('SSH key already exists: "$existingKeyName"');
}

/// Extracts a human-readable message from any error object.
/// For [Failure] subclasses returns [Failure.message] directly,
/// avoiding the `ClassName: message` format of [toString].
String errorMessage(Object error) {
  if (error is Failure) return error.message;
  return error.toString();
}
