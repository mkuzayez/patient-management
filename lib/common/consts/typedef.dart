import 'package:dartz/dartz.dart';

import '../../core/network/exceptions.dart';

typedef FromJson<T> = T Function(dynamic body);

typedef QueryParams = Map<String, String?>;

typedef BodyMap = Map<String, dynamic>;

typedef DataResponse<T> = Future<Either<Failure, T>>;

abstract class UseCase<Type, Params> {
  DataResponse<Type> call(Params params);
}

mixin Params {
  BodyMap getBody() => {};

  QueryParams getParams() => {};
}

class NoParams with Params {}
