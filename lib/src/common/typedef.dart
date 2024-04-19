import 'dart:async';

import 'package:dartz/dartz.dart';

/// A typedef for a function that returns a [Future] of [Either] of [E] as error and [T] as data.
typedef FutureEither<E, T> = FutureOr<Either<E, T>>;

/// A typedef for a function that returns a [Future] of [Either] of [String] as error message and [T] as data.
typedef FutureEither2<T> = FutureOr<Either<String, T>>;
