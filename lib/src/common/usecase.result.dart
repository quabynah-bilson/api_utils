import 'package:equatable/equatable.dart';

/// result wrapper for a [UseCase] execution
sealed class UseCaseResult<T> extends Equatable {
  const UseCaseResult();

  /// success
  factory UseCaseResult.success(T data) => UseCaseResultSuccess<T>.create(data);

  /// error/failure
  factory UseCaseResult.error(String cause) =>
      UseCaseResultError<T>.create(cause);

  UseCaseResult<T> fold(UseCaseResultSuccess<T> Function(T l) ifSuccess,
      UseCaseResultError<T> Function(String r) ifError);
}

/// success result wrapper
final class UseCaseResultSuccess<T> extends UseCaseResult<T> {
  const UseCaseResultSuccess._(this.value) : super();

  factory UseCaseResultSuccess.create(T data) => UseCaseResultSuccess._(data);
  final T value;

  @override
  List<Object> get props => [value as Object];

  @override
  UseCaseResult<T> fold(UseCaseResultSuccess<T> Function(T l) ifSuccess,
          UseCaseResultError<T> Function(String r) ifError) =>
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
  UseCaseResult<E> fold(UseCaseResultSuccess<E> Function(E l) ifSuccess,
          UseCaseResultError<E> Function(String r) ifError) =>
      ifError(cause);
}
