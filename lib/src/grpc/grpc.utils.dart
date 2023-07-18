import 'package:api_utils/src/common/typedef.dart' show FutureEither;
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';

/// error message for server not available.
const _errorMessage =
    'It seems our servers are currently unavailable. Please try again later';

/// wrapper for grpc unary calls.
FutureEither<L, R> runWithGrpcUnaryZonedGuarded<L, R>(
  Future<R> Function() run, {
  Either<L, R> Function(GrpcError)? onError,
  String? errMessage,
}) async {
  try {
    // run the call.
    final result = await run();
    return right(result);
  } on GrpcError catch (err) {
    // if server is unavailable, return the error message.
    if (err.code == StatusCode.unavailable) {
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
  Future<Stream<R>> Function() run, {
  Either<L, Stream<R>> Function(GrpcError)? onError,
  String? errMessage,
}) async {
  try {
    // run the stream.
    final result = await run();
    return right(result);
  } on GrpcError catch (err) {
    // if server is unavailable, return the error message.
    if (err.code == StatusCode.unavailable) {
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
