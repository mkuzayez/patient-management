import 'package:dio/dio.dart';

import 'exceptions.dart';

class AppDioInterceptor extends Interceptor {
  AppDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // final token = await ShPH.getData(key: AppKeys.token);
      options.headers['Authorization'] =
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzQ0ODMxMzU5LCJpYXQiOjE3NDQ4Mjc3NTksImp0aSI6IjBlMjYxN2I2ZTk1YTQ4YThiNjcxNjU1NzQ2ZTI5ZDExIiwidXNlcl9pZCI6Mn0.HPjAd8dBZyMALMcQSjBjhwPnJRqq7-edCSHu8C4T9yk";
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
