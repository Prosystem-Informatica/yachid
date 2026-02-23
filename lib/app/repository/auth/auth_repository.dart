import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';
import '../../core/rest/rest_client.dart';
import '../../model/models.dart';

class AuthRepository {
  final RestClient _rest;
  late SharedPreferences prefs;

  AuthRepository({required RestClient rest}) : _rest = rest;
  var headers = {'Content-Type': 'application/json'};

  Future<AuthModel> auth({
    required String email,
    required String password,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();

      var response = await _rest.post(
        '/auth/login',
        data: jsonEncode({"email": email, "password": password}),
        headers: headers,
      );

      var jsonData = AuthModel.fromJson(response.data);

      prefs.setString("token", jsonData.token ?? "");
      prefs.setString("entrepreneurId", jsonData.user?.id ?? '');
      prefs.setString(
        'companies',
        jsonEncode(
          jsonData.user?.enterpriseModel?.map((e) => e.toJson()).toList() ?? [],
        ),
      );

      return jsonData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> createCompanies({
    required CreateEnterpriseModel companie,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();

      var entrepreneurId = prefs.getString("entrepreneurId");

      var response = await _rest.post(
        '/enterprise/$entrepreneurId',
        data: jsonEncode(companie.toJson()),
        headers: headers,
      );

      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    prefs = await SharedPreferences.getInstance();
  }
}
