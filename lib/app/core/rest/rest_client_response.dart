import 'dart:convert';
import 'package:http/http.dart' as http;

class RestClientResponse<T> {
  T? data;
  int? statusCode;
  RestClientResponse({this.data, this.statusCode});

  factory RestClientResponse.fromHttp(http.Response response) {
    try {
      final body = response.body.trim();
      if (body.isEmpty || response.statusCode == 204) {
        return RestClientResponse(data: null, statusCode: response.statusCode);
      }
      final res = jsonDecode(body);
      return RestClientResponse(data: res, statusCode: response.statusCode);
    } on Exception {
      rethrow;
    }
  }
}
