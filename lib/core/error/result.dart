import 'package:shellvault/core/error/failures.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  T get value => (this as Success<T>).data;
  Failure get failure => (this as Err<T>).error;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      Err(:final error) => onFailure(error),
    };
  }

  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Success(transform(data)),
      Err(:final error) => Err(error),
    };
  }

  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return switch (this) {
      Success(:final data) => transform(data),
      Err(:final error) => Err(error),
    };
  }
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Err<T> extends Result<T> {
  final Failure error;
  const Err(this.error);
}
