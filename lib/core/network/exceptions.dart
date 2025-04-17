import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode = -1});

  Failure copyWith({String? message, int? statusCode}) {
    return Failure(
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
    );
  }

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({required super.message, int? statusCode});
}

class BadRequestFailure extends Failure {
  const BadRequestFailure({required super.message, int? statusCode});
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({required super.message, int? statusCode});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, int? statusCode});
}

class RateLimitFailure extends Failure {
  const RateLimitFailure({required super.message, int? statusCode});
}
