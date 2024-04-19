import 'dart:async';
import 'dart:isolate';

import 'package:api_utils/src/common/usecase.result.dart';

/// [UseCase] class is an abstraction of logic for creating
/// and maintaining use cases for the business logic
/// [T] -> the type to be returned by the [UseCase] to the Presenter.
/// [P] -> the object passed to the usecase containing
/// all the needed parameters for the [UseCase]
abstract interface class UseCase<T, P> {
  const UseCase();

  FutureOr<UseCaseResult<T>> call(P params);
}

/// A special type of [UseCase] that returns a [Stream] of [T] and accepts [P] as params.
abstract interface class ObservableUseCase<T, P> {
  const ObservableUseCase();

  Stream<UseCaseResult<T>> call(P params);
}

/// A special type of [UseCase] that does not return any value and accepts no params.
abstract interface class VoidableUseCase extends UseCase<void, void> {
  const VoidableUseCase();
}

/// A special type of [UseCase] that does not return any value.
abstract interface class CompletableUseCase<P> extends UseCase<void, P> {
  const CompletableUseCase();
}

/// A special type of [UseCase] that does not take any parameters.
abstract interface class NoParamsUseCase<T> extends UseCase<T, void> {
  const NoParamsUseCase();
}

/// A special type of [UseCase] that executes on a different isolate.
/// It is useful when performing expensive operations that ideally should
/// not be performed on the main isolate.
/// Responses are sent back to the main isolate using [SendPort] as [UseCaseResult]
abstract class BackgroundUseCase<T, P> extends UseCase<T, P> {
  const BackgroundUseCase();

  void execute(BackgroundUseCaseParams<P> params);

  @override
  FutureOr<UseCaseResult<T>> call(P params) async {
    final completer = Completer<UseCaseResult<T>>();
    try {
      final receivePort = ReceivePort();
      final isolate = await Isolate.spawn(
          execute,
          BackgroundUseCaseParams(
              params: params, sendPort: receivePort.sendPort),
          onError: receivePort.sendPort);
      receivePort.listen((message) {
        if (message is UseCaseResult<T>) {
          completer.complete(message);

          receivePort.close();
          isolate.kill();
        }

        if (message is Exception) {
          completer.completeError(message);
          receivePort.close();
          isolate.kill();
        }
      });
    } on Exception catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }
}

/// Message returned from [BackgroundUseCaseParams]
final class BackgroundUseCaseMessage<T> {
  final T? data;
  final Exception? error;

  const BackgroundUseCaseMessage({this.data, this.error});
}

/// Parameters passed to [BackgroundUseCase]
final class BackgroundUseCaseParams<P> {
  final P params;
  final SendPort sendPort;

  const BackgroundUseCaseParams({required this.params, required this.sendPort});
}
