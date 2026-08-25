import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/exception_mapper.dart';
import 'package:fitsho/core/error/failures.dart';

Future<Either<Failure, T>> guard<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } on Object catch (error) {
    return Left(ExceptionMapper.mapException(error));
  }
}
