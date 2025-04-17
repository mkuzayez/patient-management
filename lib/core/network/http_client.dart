import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:patient_managment/core/network/interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';


import '../config/app_config.dart';

@factoryMethod
abstract class HTTPClient {
  Future<Response> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    CancelToken? cancelToken,
  });

  Future<Response> post(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken});

  Future<Response> put(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken});

  Future<Response> delete(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken});
}

@LazySingleton(as: HTTPClient)
class DioClient implements HTTPClient {
  final Dio dio;

  DioClient() : dio = _createDio();

  static Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: AppUrl.appUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    )..interceptors.addAll([PrettyDioLogger(requestBody: true, responseBody: true, request: true, requestHeader: true), AppDioInterceptor()]);
  }

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    CancelToken? cancelToken,
  }) {
    return dio.get(url, options: Options(headers: headers, responseType: responseType), queryParameters: queryParameters, cancelToken: cancelToken);
  }

  @override
  Future<Response> post(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken}) {
    return dio.post(url, data: data, options: Options(headers: headers), cancelToken: cancelToken);
  }

  @override
  Future<Response> put(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken}) {
    return dio.put(url, data: data, options: Options(headers: headers), cancelToken: cancelToken);
  }

  @override
  Future<Response> delete(String url, {Map<String, dynamic>? headers, dynamic data, CancelToken? cancelToken}) {
    return dio.delete(url, data: data, options: Options(headers: headers), cancelToken: cancelToken);
  }
}
//
// class AppDioInterceptor extends Interceptor {
//   AppDioInterceptor();
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     try {
//       final token = await ShPH.getData(key: AppKeys.token);
//       options.headers['Authorization'] = 'Bearer $token';
//     } catch (e) {
//       handler.reject(DioException(requestOptions: options, error: e));
//       return;
//     }
//     handler.next(options);
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     if ((response.data is String && response.data.contains('<!DOCTYPE html>')) ||
//         (response.data is String && response.data.contains('<html>')) ||
//         (response.data is String && response.data.contains('<html lang="ar">')) ||
//         (response.data is String && response.data.contains('html') && response.data.contains('href')) ||
//         (response.headers['content-type']?.first == 'text/html')) {
//       throw const NetworkFailure(message: "خطأ بالاتصال، يرجى المحاولة مجددًا");
//     }
//     handler.next(response);
//   }
//
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     handler.next(err);
//   }
// }
