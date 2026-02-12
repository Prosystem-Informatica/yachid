import 'dart:convert';
import 'package:http/http.dart' as http;
import '../rest_client.dart';
import '../rest_client_response.dart';

class HttpRestClient implements RestClient {
  late final http.Client rest;
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  HttpRestClient({required this.baseUrl})
    : rest = http.Client(),
      defaultHeaders = {'content-type': 'application/json'};

  @override
  RestClient auth() {
    defaultHeaders['authorization'] = 'token';
    return this;
  }

  @override
  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.https(baseUrl, path, queryParameters);
    final response = await rest.get(uri, headers: joinHeaders(headers));
    return RestClientResponse.fromHttp(response);
  }

  @override
  Future<RestClientResponse<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.https(baseUrl, path, queryParameters);
      final headersMap = joinHeaders(headers);
      final bodyData = _prepareBody(data, headersMap);
      
      final response = await rest.post(
        uri,
        body: bodyData,
        headers: headersMap,
      );
      return RestClientResponse.fromHttp(response);
    } on Exception {
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
      final uri = Uri.https(baseUrl, path, queryParameters);
      final headersMap = joinHeaders(headers);
      final bodyData = _prepareBody(data, headersMap);
      
      final response = await rest.patch(
        uri,
        body: bodyData,
        headers: headersMap,
      );
      return RestClientResponse.fromHttp(response);
    } on Exception {
      rethrow;
    }
  }

  @override
  RestClient unAuth() {
    defaultHeaders.remove("authorization");
    return this;
  }

  Map<String, String> joinHeaders(Map<String, String>? h) {
    Map<String, String> headers = Map<String, String>.from(defaultHeaders);
    h?.forEach((key, value) {
      headers[key] = value;
    });
    return headers;
  }

  dynamic _prepareBody(dynamic data, Map<String, String> headers) {
    if (data == null) return null;
    
    final contentType = headers['content-type']?.toLowerCase() ?? 
                       headers['Content-Type']?.toLowerCase() ?? '';
    
    if (contentType.contains('application/json')) {
      if (data is String) {
        return data;
      } else if (data is Map || data is List) {
        return jsonEncode(data);
      }
    }
    
    return data;
  }
}
