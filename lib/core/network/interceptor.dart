import 'package:dio/dio.dart';

import 'exceptions.dart';

class AppDioInterceptor extends Interceptor {
  AppDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // final token = await ShPH.getData(key: AppKeys.token);
      options.headers['access'] =
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ0OTg3NTQxLCJpYXQiOjE3NDQ5ODM5NDEsImp0aSI6ImRkYTliOGEyMTdlNjQ2NzFiZGYzODc5NmYxODBiZGQyIiwidXNlcl9pZCI6M30.vD6BSQbnfUjH6RAEFTVB_V3GUJ5KBwiI-Bi2WHjgudc";
    } catch (e) {
      handler.reject(DioException(requestOptions: options, error: e));
      return;
    }

    print(options.headers);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if ((response.data is String && response.data.contains('<!DOCTYPE html>')) ||
        (response.data is String && response.data.contains('<html>')) ||
        (response.data is String && response.data.contains('<html lang="ar">')) ||
        (response.data is String && response.data.contains('html') && response.data.contains('href')) ||
        (response.headers['content-type']?.first == 'text/html')) {
      throw const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
