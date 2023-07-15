import 'dart:async';

/// [UseCase] class is an abstraction of logic for creating
/// and maintaining use cases for the business logic
abstract interface class UseCase<T, P> {
  FutureOr<T> call(P params);
}
