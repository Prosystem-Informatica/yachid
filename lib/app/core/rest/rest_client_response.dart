import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class RestClientResponse<T> {
  T? data;
  int? statusCode;
  RestClientResponse({this.data, this.statusCode});

  factory RestClientResponse.fromHttp(http.Response response) {
    try {
      if (response.statusCode != 204) {
        final res = jsonDecode(response.body);
        return RestClientResponse(data: res, statusCode: response.statusCode);
      }
      return RestClientResponse(data: null, statusCode: response.statusCode);
    } on Exception catch (e) {
      rethrow;
    }
  }
}
