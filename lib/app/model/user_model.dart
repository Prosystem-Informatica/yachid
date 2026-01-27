import 'models.dart';

class User {
  final String? email;
  final String? role;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? name;
  final String? phone;
  final String? document;
  final String? status;
  final List<EnterpriseModel>? enterpriseModel;

  User({
    this.email,
    this.role,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.phone,
    this.document,
    this.status,
    this.enterpriseModel,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String?,
      role: json['role'] as String?,
      id: json['id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      document: json['document'] as String?,
      status: json['status'] as String?,
      enterpriseModel:
          json['enterprises'] != null
              ? (json['enterprises'] as List)
                  .map(
                    (e) => EnterpriseModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList()
              : <EnterpriseModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'name': name,
      'phone': phone,
      'document': document,
      'status': status,
      'enterprises': enterpriseModel,
    };
  }

  // @override
  // String toString() {
  //   return 'User{email: $email, role: $role, id: $id, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, phone: $phone, document: $document, status: $status, enterpriseModel: $enterpriseModel}';
  // }
}
