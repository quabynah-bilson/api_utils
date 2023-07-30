import 'package:equatable/equatable.dart';

/// result wrapper for a [UseCase] execution
sealed class UseCaseResult<T> extends Equatable {
  const UseCaseResult();

  /// success
  factory UseCaseResult.success(T data) => UseCaseResultSuccess<T>.create(data);

  /// error/failure
  factory UseCaseResult.error(String cause) =>
      UseCaseResultError<T>.create(cause);

  B fold<B>(B Function(String r) ifError, B Function(T l) ifSuccess);
}

/// success result wrapper
final class UseCaseResultSuccess<T> extends UseCaseResult<T> {
  const UseCaseResultSuccess._(this.value) : super();

  factory UseCaseResultSuccess.create(T data) => UseCaseResultSuccess._(data);
  final T value;

  @override
  List<Object> get props => [value as Object];

  @override
  B fold<B>(B Function(String r) ifError, B Function(T l) ifSuccess) =>
      ifSuccess(value);
}

/// error result wrapper
final class UseCaseResultError<E> extends UseCaseResult<E> {
  const UseCaseResultError._(this.cause) : super();

  factory UseCaseResultError.create(String cause) =>
      UseCaseResultError._(cause);
  final String cause;

  @override
  List<Object> get props => [cause];

  @override
  B fold<B>(B Function(String r) ifError, B Function(E l) ifSuccess) =>
      ifError(cause);
}
