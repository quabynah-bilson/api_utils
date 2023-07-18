import 'dart:async';
import 'dart:io';

import 'package:api_utils/src/common/typedef.dart' show FutureEither;
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:retrofit/retrofit.dart';

/// error message for server not available.
const _errorMessage =
    'It seems our servers are currently unavailable. Please try again later';

/// wrapper for REST API calls
FutureEither<L, R> runApiCall<L, R>(
  Future<HttpResponse<R>> Function() run, {
  String? errMessage,
}) async {
  try {
    // run the call
    final result = await run();

    if (result.response.statusCode == HttpStatus.ok) {
      return right(result.data);
    }

    return left(
        (result.response.statusMessage ?? errMessage ?? _errorMessage) as L);
  } on DioException catch (err) {
    return left((err.message ?? errMessage ?? _errorMessage) as L);
  } on PlatformException catch (err) {
    return left((err.message ?? errMessage ?? _errorMessage) as L);
  } catch (err) {
    return left(err.toString() as L);
  }
}
