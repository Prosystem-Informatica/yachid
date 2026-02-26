import 'enterprise_model.dart';

class CreateEnterpriseResponse {
  final int statusCode;
  final EnterpriseModel? enterprise;
  final bool isSuccess;

  CreateEnterpriseResponse({
    required this.statusCode,
    this.enterprise,
    required this.isSuccess,
  });
}
