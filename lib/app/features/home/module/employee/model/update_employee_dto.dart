import 'package:yachid/app/features/home/module/employee/model/employee_enums.dart';

class UpdateEmployeeDto {
  final String? name;
  final String? phone;
  final String? document;
  final EmployeeStatus? status;
  final EmployeeRole? role;
  final String? email;
  final String? base64;

  UpdateEmployeeDto({
    this.name,
    this.phone,
    this.document,
    this.status,
    this.role,
    this.email,
    this.base64,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (phone != null) map['phone'] = phone;
    if (document != null) map['document'] = document;
    if (status != null) {
      map['status'] = status!.value == EmployeeStatus.ATIVO.value ? 'ACTIVE' : 'INACTIVE';
    }
    if (role != null) {
      map['role'] = role!.value == EmployeeRole.ADMINISTRADOR.value ? 'ADMIN' : 'USER';
    }
    if (email != null) map['email'] = email;
    if (base64 != null && base64!.isNotEmpty) map['base64'] = base64;
    return map;
  }
}
