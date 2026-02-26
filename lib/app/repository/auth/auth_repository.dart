import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
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

      print('response: ${response.data}');

      var jsonData = AuthModel.fromJson(response.data);

      prefs.setString("token", jsonData.token ?? "");

      return jsonData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<EnterpriseModel>> getCompanies(
    String entrepreneurId,
    String token,
  ) async {
    try {
      final response = await _rest.get(
        '/enterprise/$entrepreneurId',
        headers: {'Authorization': 'Bearer $token'},
      );
      print('response: ${response.data}');

      var res = EnterpriseModel.fromJsonList(response.data);

      return res;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<EnterpriseModel> createCompanies({
    required CreateEnterpriseModel companie,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();

      var entrepreneurId = prefs.getString("entrepreneurId");

      print("ID do cara > ${entrepreneurId}");

      var response = await _rest.post(
        '/enterprise/$entrepreneurId',
        data: jsonEncode(companie.toJson()),
        headers: headers,
      );

      var jsonData = EnterpriseModel.fromJson(response.data);

      return jsonData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _rest.post(
        '/auth/forgot-password',
        data: jsonEncode({'email': email}),
        headers: headers,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    prefs = await SharedPreferences.getInstance();
  }
}
