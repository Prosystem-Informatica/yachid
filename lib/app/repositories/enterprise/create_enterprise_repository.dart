import '../../core/rest/rest_client.dart';

class CreateEnterpriseRepository {
  final RestClient api;

  CreateEnterpriseRepository(this.api);

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    try {
      final response = await api.post("/enterprise", data: data);

      final responseData = Map<String, dynamic>.from(response.data ?? {});

      final enterpriseId = responseData["id"];
      final subEnterprise = responseData["subEnterprise"];
      final subEnterpriseId = subEnterprise != null ? subEnterprise["id"] : null;


      return {
        "enterprise_id": enterpriseId,
        "sub_enterprise_id": subEnterpriseId,
        "data": responseData,
      };
    } catch (e) {
      throw Exception("Erro ao criar empresa: $e");
    }
  }
}
