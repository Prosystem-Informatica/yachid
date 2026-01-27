import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/rest/rest_client.dart';
import '../../model/models.dart';

class AuthRepository {
  final RestClient _rest;
  late SharedPreferences prefs;

  AuthRepository({required RestClient rest}) : _rest = rest;

  Future<AuthModel> auth({
    required String email,
    required String password,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();

      var response = await _rest.post(
        '/auth/login',
        data: jsonEncode({"email": email, "password": password}),
      );

      var jsonData = AuthModel.fromJson(response.data);

      prefs.setString("token", jsonData.token ?? "");

      return jsonData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    prefs = await SharedPreferences.getInstance();
  }
}
