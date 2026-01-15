import '../../core/rest/rest_client.dart';

class CreateEmployeeRepository {
  final RestClient _api;

  CreateEmployeeRepository(this._api);

  Future<Map<String, dynamic>> createEmployee(Map<String, dynamic> data) async {
    try {
      final response = await _api.post("/employee", data: data);
      return Map<String, dynamic>.from(response.data ?? {});
    } catch (e) {
      throw Exception("Erro ao criar funcionário: $e");
    }
  }
}
