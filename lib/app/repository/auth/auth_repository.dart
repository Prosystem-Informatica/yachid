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
      prefs.setString("entrepreneurId", jsonData.user!.id ?? '');
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

  Future<EnterpriseModel> createCompanies({
    required CreateEnterpriseModel companie,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();

      var entrepreneurId = prefs.getString("entrepreneurId");

      print("ID do cara > ${entrepreneurId}");

      print('Body ${companie.toJson()}');

      var response = await _rest.post(
        '/enterprise/$entrepreneurId',
        data: companie.toJson(),
      );

      print('Oq aconteceu no create ? ${response.data}');

      var jsonData = EnterpriseModel.fromJson(response.data);

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
