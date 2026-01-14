import 'package:yachid/app/core/rest/rest_client.dart';

class EnterpriseRepository {
  final RestClient _api;

  EnterpriseRepository(this._api);

  Future<List<Map<String, dynamic>>> list() async {
    try {
      final response = await _api.get("/enterprise");
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception("Erro ao buscar empresas: $e");
    }
  }

  Future<Map<String, dynamic>> impersonate(String enterpriseId) async {
    try {
      final response = await _api.post(
        "/auth/impersonate",
        data: {"enterpriseId": enterpriseId},
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw Exception("Erro ao entrar na empresa: $e");
    }
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      final response = await _api.post("/enterprise", data: data);
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw Exception("Erro ao criar empresa: $e");
    }
  }

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) async {
    try {
      final response = await _api.put("/enterprise/$id", data: data);
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw Exception("Erro ao atualizar empresa: $e");
    }
  }

  Future<Map<String, dynamic>> getById(String id) async {
    try {
      final response = await _api.get("/enterprise/$id");
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw Exception("Erro ao buscar empresa: $e");
    }
  }
}
