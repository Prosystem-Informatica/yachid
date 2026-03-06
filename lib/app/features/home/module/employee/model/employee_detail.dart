import 'package:yachid/app/features/home/module/employee/model/branch_model.dart';
import 'package:yachid/app/features/home/module/employee/model/employee_enums.dart';

class EmployeeDetail {
  final String id;
  final String name;
  final String phone;
  final String document;
  final EmployeeStatus status;
  final EmployeeRole role;
  final String? email;
  final BranchModel? branch;
  final String? imageUrl;

  EmployeeDetail({
    required this.id,
    required this.name,
    required this.phone,
    required this.document,
    required this.status,
    required this.role,
    this.email,
    this.branch,
    this.imageUrl,
  });

  factory EmployeeDetail.fromJson(Map<String, dynamic> json) {
    BranchModel? branch;
    final branchData = json['branch'];
    if (branchData is Map<String, dynamic>) {
      final bid = branchData['id'] as String?;
      final bname = branchData['name'] as String? ?? '';
      if (bid != null && bid.isNotEmpty) {
        branch = BranchModel(id: bid, name: bname);
      }
    }

    final user = json['user'];
    String? email;
    if (user is Map<String, dynamic>) {
      email = user['email'] as String?;
    }

    return EmployeeDetail(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      document: json['document'] as String? ?? '',
      status: _parseStatus(json['status']),
      role: _parseRole(json['role']),
      email: email,
      branch: branch,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  static String? _parseString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    return v.toString();
  }

  static EmployeeStatus _parseStatus(dynamic v) {
    final s = _parseString(v)?.toUpperCase();
    if (s == 'INACTIVE') return EmployeeStatus.INATIVO;
    return EmployeeStatus.ATIVO;
  }

  static EmployeeRole _parseRole(dynamic v) {
    final s = _parseString(v)?.toUpperCase();
    if (s == 'ADMIN') return EmployeeRole.ADMINISTRADOR;
    return EmployeeRole.USUARIO;
  }
}
