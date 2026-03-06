import 'employee_enums.dart';

class CreateEmployeeDto {
  final String name;
  final String email;
  final String phone;
  final String document;
  final EmployeeStatus status;
  final EmployeeRole role;
  final String? base64;
  final String branch;

  CreateEmployeeDto({
    required this.name,
    required this.email,
    required this.phone,
    required this.document,
    required this.status,
    required this.role,
    this.base64,
    required this.branch,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'document': document,
      'status':
          status.value == EmployeeStatus.ATIVO.value ? 'ACTIVE' : 'INACTIVE',
      'role': role.value == EmployeeRole.ADMINISTRADOR.value ? 'ADMIN' : 'USER',
      'branch': branch,
    };

    if (base64 != null && base64!.isNotEmpty) {
      data['base64'] = base64;
    }

    return data;
  }
}
