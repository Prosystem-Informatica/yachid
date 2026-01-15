import 'package:dio/dio.dart';
import '../../core/rest/rest_client.dart';

class LoginRepository {
  final RestClient _api;
  String? _token;

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
      if (data == null || data["token"] == null) {
        throw Exception("Resposta inválida do servidor");
      }

      _token = data["token"];
      if (_api is RestClient) {
        (_api as dynamic).setAuthHeader(_token);
      }
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Erro ao fazer login";
      throw Exception(message);
    } catch (e) {
      throw Exception("Erro inesperado: $e");
    }
  }
}
