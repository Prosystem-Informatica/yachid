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

      var jsonData = AuthModel.fromJson(response.data);

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

      var res = EnterpriseModel.fromJsonList(response.data);

      return res;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<CreateEnterpriseResponse> createCompanies({
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

      final statusCode = response.statusCode ?? 0;
      final isSuccess =
          statusCode == 200 ||
          statusCode == 201 ||
          statusCode == 203 ||
          statusCode == 204;

      print("isSuccess : $isSuccess");

      EnterpriseModel? enterprise;
      if (response.data != null && response.data is Map) {
        final data = response.data as Map<String, dynamic>;
        final enterpriseJson = data['data'] ?? data['enterprise'] ?? data;
        if (enterpriseJson is Map<String, dynamic>) {
          enterprise = EnterpriseModel.fromJson(enterpriseJson);
        }
      }

      return CreateEnterpriseResponse(
        statusCode: statusCode,
        enterprise: enterprise,
        isSuccess: isSuccess,
      );
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
