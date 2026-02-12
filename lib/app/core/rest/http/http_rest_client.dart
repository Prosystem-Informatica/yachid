import 'dart:developer';
import 'package:http/http.dart' as http;
import '../rest_client.dart';
import '../rest_client_response.dart';

class HttpRestClient implements RestClient {
  late final http.Client rest;
  final String baseUrl;
  final String env;
  final String port;
  final Map<String, String> defaultHeaders;

  Uri buildUri(String path, {Map<String, dynamic>? queryParameters}) {
    final scheme = env == 'development' ? 'http' : 'https';
    return Uri(
      scheme: scheme,
      host: baseUrl,
      path: path,
      port: env == 'development' ? int.parse(port) : null,
      queryParameters: queryParameters?.map(
        (k, v) => MapEntry(k, v?.toString()),
      ),
    );
  }

  HttpRestClient({required this.baseUrl, required this.env, required this.port})
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
    final response = await rest.get(
      buildUri(path, queryParameters: queryParameters),
      headers: joinHeaders(headers),
    );
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
      print(buildUri(path, queryParameters: queryParameters).toString());
      final response = await rest.post(
        buildUri(path, queryParameters: queryParameters),
        body: data,
        headers: joinHeaders(headers),
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
      final response = await rest.patch(
        buildUri(path, queryParameters: queryParameters),
        body: data,
        headers: joinHeaders(headers),
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
    Map<String, String> headers = defaultHeaders;
    h?.forEach((key, value) {
      headers[key] = value;
    });
    return headers;
  }
}
