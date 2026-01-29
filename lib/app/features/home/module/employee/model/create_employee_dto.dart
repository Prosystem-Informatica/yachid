import 'employee_enums.dart';

class CreateEmployeeDto {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String document;
  final EmployeeStatus status;
  final EmployeeRole role;
  final String base64;
  final String branch;

  CreateEmployeeDto({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.document,
    required this.status,
    required this.role,
    required this.base64,
    required this.branch,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'document': document,
      'status': status.value,
      'role': role.value,
      'base64': base64,
      'branch': branch,
    };
  }
}
