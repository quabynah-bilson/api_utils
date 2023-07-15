import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';

/// error message for server not available.
const _errorMessage =
    'It seems our servers are currently unavailable. Please try again later';

/// wrapper for grpc unary calls.
Future<Either<L, R>> runWithGrpcUnaryZonedGuarded<L, R>(
  Future<L> Function() run, {
  Either<L, R> Function(GrpcError)? onError,
  String? errMessage,
}) async {
  try {
    // run the call.
    final result = await run();
    return left(result);
  } on GrpcError catch (err) {
    // if server is unavailable, return the error message.
    if (err.code == StatusCode.unavailable) {
      return right(_errorMessage as R);
    }

    // if there is a custom error handler, use it.
    if (onError != null) return onError.call(err);
    return right((err.message ?? errMessage ?? _errorMessage) as R);
  } on PlatformException catch (err) {
    return right((err.message ?? errMessage ?? _errorMessage) as R);
  } catch (err) {
    return right(err.toString() as R);
  }
}

/// wrapper for grpc stream calls.
Future<Either<Stream<L>, R>> runWithGrpcStreamZonedGuarded<L, R>(
  Future<Stream<L>> Function() run, {
  Either<Stream<L>, R> Function(GrpcError)? onError,
  String? errMessage,
}) async {
  try {
    // run the stream.
    final result = await run();
    return left(result);
  } on GrpcError catch (err) {
    // if server is unavailable, return the error message.
    if (err.code == StatusCode.unavailable) {
      return right(_errorMessage as R);
    }

    // if there is a custom error handler, use it.
    if (onError != null) return onError.call(err);
    return right((err.message ?? errMessage ?? _errorMessage) as R);
  } on PlatformException catch (err) {
    return right((err.message ?? errMessage ?? _errorMessage) as R);
  } catch (err) {
    return right(err.toString() as R);
  }
}
