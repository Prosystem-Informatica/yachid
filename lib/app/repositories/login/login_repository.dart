import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';
import '../../core/rest/http/http_rest_client.dart';
import '../../core/rest/rest_client.dart';

class LoginRepository {
  final RestClient _api;
  String? _loggedIdentifier;
  String? _employeeId;

  LoginRepository(this._api);

  Future<void> login(String identifier, String password) async {
    try {
      final response = await _api.post(
        "/employee/login",
        data: {
          "identifier": identifier.trim(),
          "password": password.trim(),
        },
      );

      final data = response.data;

      if (data == null ||
          data["user"] == null ||
          data["token"] == null ||
          data["user"]["id"] == null) {
        throw Exception("Resposta inválida do servidor");
      }

      final token = data["token"];
      _employeeId = data["user"]["id"];

      if (_api is HttpRestClient) {
        (_api as dynamic).setAuthHeader(token);
      }

      _loggedIdentifier = identifier.trim().toLowerCase();

      if (_loggedIdentifier == "prosystem@informatica.com") {
        final enterpriseResponse = await _api.get("/enterprise");
        final enterprises = enterpriseResponse.data as List? ?? [];

        Get.offAllNamed(Routes.ENTERPRISE_LIST);
        Get.snackbar(
          "Login",
          "Login master: acesso total concedido",
          backgroundColor: const Color(0xFF1E6F4F),
          colorText: const Color(0xFFFFFFFF),
        );
        return;
      }

      final enterpriseResponse =
      await _api.get("/employee/$_employeeId/enterprises");
      final enterprises = enterpriseResponse.data as List? ?? [];

      if (enterprises.length == 1) {
        final enterpriseId = enterprises.first['id'];
        await _api.post("/auth/impersonate", data: {"enterpriseId": enterpriseId});
        Get.offAllNamed("/dashboard");
      } else {
        Get.offAllNamed(Routes.ENTERPRISE_LIST);
      }

      Get.snackbar(
        "Login",
        "Login efetuado com sucesso",
        backgroundColor: const Color(0xFF1E6F4F),
        colorText: const Color(0xFFFFFFFF),
      );
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Erro ao fazer login";
      throw Exception(message);
    } catch (e) {
      throw Exception("Erro inesperado: $e");
    }
  }

  String getLoggedIdentifier() {
    if (_loggedIdentifier == null) {
      throw Exception("Nenhum usuário logado");
    }
    return _loggedIdentifier!;
  }
}
