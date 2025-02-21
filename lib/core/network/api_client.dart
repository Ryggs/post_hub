
import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: NetworkConstants.connectionTimeout);
    _dio.options.receiveTimeout = const Duration(milliseconds: NetworkConstants.receiveTimeout);
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

 Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw Exception(NetworkConstants.connectionTimeout);
      case DioExceptionType.badResponse:
        return Exception('Server error: ${error.response?.statusCode}');
      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return Exception('No internet connection');
        }
        return Exception('Unexpected error occurred');
      default:
        return Exception('Something went wrong');

    }
 }
}