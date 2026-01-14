import 'package:dio/dio.dart';


class RestClientResponse<T> {
  final T? data;
  final int statusCode;

  RestClientResponse({
    this.data,
    required this.statusCode,
  });

  factory RestClientResponse.fromDio(Response response) {
    return RestClientResponse(
      data: response.data,
      statusCode: response.statusCode ?? 0,
    );
  }
}

