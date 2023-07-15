import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:retrofit/retrofit.dart';

/// error message for server not available.
const _errorMessage =
    'It seems our servers are currently unavailable. Please try again later';

/// wrapper for REST API calls
Future<Either<L, R>> runApiCall<L, R>(
  Future<HttpResponse<L>> Function() run, {
  String? errMessage,
}) async {
  try {
    // run the call
    final result = await run();

    if (result.response.statusCode == HttpStatus.ok) {
      return left(result.data);
    }

    return right(
        (result.response.statusMessage ?? errMessage ?? _errorMessage) as R);
  } on DioException catch (err) {
    return right((err.message ?? errMessage ?? _errorMessage) as R);
  } on PlatformException catch (err) {
    return right((err.message ?? errMessage ?? _errorMessage) as R);
  } catch (err) {
    return right(err.toString() as R);
  }
}
