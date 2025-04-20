import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../common/consts/typedef.dart';
import 'error_handler.dart';
import 'exceptions.dart';

mixin ApiHandler {
  Future<Either<Failure, T>> handleApiCall<T>({required Future<Response> Function() apiCall, FromJson<T>? jsonConvert}) async {
    try {
      final response = await apiCall();

      print("RESPONSE ${response.data}");
      if ((response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) && jsonConvert == null) return Right(response.data);
      if ((response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202)  && jsonConvert != null) return Right(jsonConvert(response.data));

      return Left(ExceptionHandler.handleException(response));
    } catch (error) {
      return Left(ExceptionHandler.handleException(error));
    }
  }

  Future<Either<Failure, T>> getFile<T>({required Future<Response> Function() apiCall}) async {
    try {
      final response = await apiCall();
      if (response.statusCode == 200) Right(response);
      return Left(ExceptionHandler.handleException(response));
    } catch (error) {
      return Left(ExceptionHandler.handleException(error));
    }
  }
}
