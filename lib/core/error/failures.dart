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

final class NetworkFailure extends Failure {
  final int? statusCode;
  const NetworkFailure(super.message, {this.statusCode, super.cause});
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.cause});
}

final class SyncFailure extends Failure {
  final int? conflictVersion;
  const SyncFailure(super.message, {this.conflictVersion, super.cause});
}
