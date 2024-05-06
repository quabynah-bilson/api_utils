import 'dart:async';

import 'package:api_utils/src/common/typedef.dart' show FutureEither;
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart' as $grpc;

/// global function to cancel a grpc call.
Completer<void> cancellationToken = Completer<void>();

/// error message for server not available.
const _errorMessage =
    'It seems our servers are currently unavailable. Please try again later';

/// wrapper for grpc unary calls.
FutureEither<L, R> runWithGrpcUnaryZonedGuarded<L, R>(
  $grpc.ResponseFuture<R> run, {
  Either<L, R> Function($grpc.GrpcError)? onError,
  String? errMessage,
  Duration timeout = const Duration(seconds: 15),
}) async {
  try {
    // run the call.
    final result = await run.timeout(timeout, onTimeout: () {
      if (!cancellationToken.isCompleted) {
        run.cancel();
        cancellationToken.complete();
      }
      return Future.error('Request timed out');
    });
    return right(result);
  } on $grpc.GrpcError catch (err) {
    // if server is unavailable, return the error message.
    if (err.code == $grpc.StatusCode.unavailable) {
      return left(_errorMessage as L);
    }

    // if there is a custom error handler, use it.
    if (onError != null) return onError.call(err);
    return left((err.message ?? errMessage ?? _errorMessage) as L);
  } on PlatformException catch (err) {
    return left((err.message ?? errMessage ?? _errorMessage) as L);
  } catch (err) {
    return left(err.toString() as L);
  }
}

/// wrapper for grpc stream calls.
FutureEither<L, Stream<R>> runWithGrpcStreamZonedGuarded<L, R>(
  $grpc.ResponseStream<R> run, {
  Either<L, Stream<R>> Function($grpc.GrpcError)? onError,
  String? errMessage,
  int maxRetries = 3,
  Duration timeout = const Duration(minutes: 50),
}) async {
  for (var i = 0; i < maxRetries; i++) {
    final result = await _retryGrpcStreamCall<L, R>(
      run,
      onError: onError,
      errMessage: errMessage,
      timeout: timeout,
    );

    if (result.isRight()) {
      return result;
    }
  }

  return left('Failed to get response' as L);
}

// retry a streaming call when it fails or times out
FutureEither<L, Stream<R>> _retryGrpcStreamCall<L, R>(
  $grpc.ResponseStream<R> run, {
  Either<L, Stream<R>> Function($grpc.GrpcError)? onError,
  String? errMessage,
  Duration timeout = const Duration(minutes: 50),
}) async {
  try {
    // run the stream.
    final result = run.timeout(timeout, onTimeout: (sink) {
      if (!cancellationToken.isCompleted) {
        run.cancel();
        cancellationToken.complete();
      }
      sink.addError('Request timed out');
    }).asBroadcastStream();
    return right(result);
  } on $grpc.GrpcError catch (err) {
    // if server is unavailable, return the error message.
    if (err.code == $grpc.StatusCode.unavailable) {
      return left(_errorMessage as L);
    }

    // if there is a custom error handler, use it.
    if (onError != null) return onError.call(err);
    return left((err.message ?? errMessage ?? _errorMessage) as L);
  } on PlatformException catch (err) {
    return left((err.message ?? errMessage ?? _errorMessage) as L);
  } catch (err) {
    return left(err.toString() as L);
  }
}
