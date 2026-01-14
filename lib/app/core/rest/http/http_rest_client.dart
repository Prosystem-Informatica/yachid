import 'package:dio/dio.dart';
import '../rest_client_response.dart';
import '../rest_client.dart';

class HttpRestClient implements RestClient {
  final Dio _dio;
  String? _token;
  final String _baseUrl;

  HttpRestClient({required String baseUrl})
      : _dio = Dio(BaseOptions(baseUrl: baseUrl)),
        _baseUrl = baseUrl {
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      logPrint: (obj) => print("[HTTP] $obj"),
    ));
  }

  void setAuthHeader(String token) {
    _token = token;
    _dio.options.headers["Authorization"] = "Bearer $token";
  }

  void clearAuthHeader() {
    _token = null;
    _dio.options.headers.remove("Authorization");
  }

  @override
  RestClient auth() {
    if (_token == null) {
      throw Exception("Token JWT não definido. Faça login primeiro.");
    }
    return this;
  }

  @override
  RestClient unAuth() {
    clearAuthHeader();
    return this;
  }

  String _fullUrl(String path) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$_baseUrl$cleanPath';
  }

  @override
  Future<RestClientResponse<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
      }) async {
    try {
      final response = await _dio.get(
        _fullUrl(path),
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return RestClientResponse<T>(
        data: response.data,
        statusCode: response.statusCode ?? 0,
      );
    } on DioError catch (e) {
      print("[HTTP ERROR GET] ${e.response?.statusCode} ${e.response?.data}");
      rethrow;
    }
  }

  @override
  Future<RestClientResponse<T>> post<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
      }) async {
    try {
      final response = await _dio.post(
        _fullUrl(path),
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return RestClientResponse<T>(
        data: response.data,
        statusCode: response.statusCode ?? 0,
      );
    } on DioError catch (e) {
      print("[HTTP ERROR POST] ${e.response?.statusCode} ${e.response?.data}");
      rethrow;
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
      }) async {
    try {
      final response = await _dio.patch(
        _fullUrl(path),
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return RestClientResponse<T>(
        data: response.data,
        statusCode: response.statusCode ?? 0,
      );
    } on DioError catch (e) {
      print("[HTTP ERROR PATCH] ${e.response?.statusCode} ${e.response?.data}");
      rethrow;
    }
  }
  @override
  Future<RestClientResponse<T>> put<T>(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, String>? headers,
      }) async {
    try {
      final response = await _dio.put(
        _fullUrl(path),
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return RestClientResponse<T>(
        data: response.data,
        statusCode: response.statusCode ?? 0,
      );
    } on DioError catch (e) {
      print("[HTTP ERROR PUT] ${e.response?.statusCode} ${e.response?.data}");
      rethrow;
    }
  }

}
