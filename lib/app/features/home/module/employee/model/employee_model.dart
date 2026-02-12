class EmployeeModel {
  final String id;
  final String name;
  final String phone;
  final String document;
  final String status;
  final String role;
  final String? imageUrl;
  final String branchId;
  final String branchName;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.document,
    required this.status,
    required this.role,
    this.imageUrl,
    required this.branchId,
    required this.branchName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['employee_id'] as String? ?? '',
      name: json['employee_name'] as String? ?? '',
      phone: json['employee_phone'] as String? ?? '',
      document: json['employee_document'] as String? ?? '',
      status: json['employee_status'] as String? ?? '',
      role: json['employee_role'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      branchId:
          json['branchId'] as String? ?? json['branch']?['id'] as String? ?? '',
      branchName:
          json['branchName'] as String? ??
          json['branch']?['name'] as String? ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'document': document,
      'status': status,
      'role': role,
      'imageUrl': imageUrl,
      'branchId': branchId,
      'branchName': branchName,
    };
  }
}
