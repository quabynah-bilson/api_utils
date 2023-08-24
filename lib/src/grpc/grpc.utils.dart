import 'package:api_utils/src/common/typedef.dart' show FutureEither;
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart' as $grpc;

/// global function to cancel a grpc call.
Function() cancellationToken = () => debugPrint('cancellation token called');

/// error message for server not available.
const _errorMessage =
    'It seems our servers are currently unavailable. Please try again later';

/// wrapper for grpc unary calls.
FutureEither<L, R> runWithGrpcUnaryZonedGuarded<L, R>(
  $grpc.ResponseFuture<R> run, {
  Either<L, R> Function($grpc.GrpcError)? onError,
  String? errMessage,
}) async {
  try {
    // run the call.
    cancellationToken = run.cancel;
    final result = await run.timeout(const Duration(seconds: 5));
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
}) async {
  try {
    // run the stream.
    cancellationToken = run.cancel;
    final result = run.asBroadcastStream();
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
