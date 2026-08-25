import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

abstract class UseCase<T, Params> {
  ResultFuture<T> call(Params params);
}

class NoParams {
  const NoParams();
}
