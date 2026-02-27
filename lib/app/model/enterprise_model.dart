import 'models.dart';

class EnterpriseModel {
  final String? id;
  final String? document;
  final String? socialReason;
  final String? fantasyName;
  final String? status;
  final String? phone;
  final String? email;
  final String? website;
  final String? accountingEmail;
  final Address? address;

  const EnterpriseModel({
    this.id,
    this.document,
    this.socialReason,
    this.fantasyName,
    this.status,
    this.phone,
    this.email,
    this.website,
    this.accountingEmail,
    this.address,
  });

  bool get isSuccess => id != null && document != null;

  factory EnterpriseModel.fromJson(Map<String, dynamic> json) {
    return EnterpriseModel(
      id: json['id'] as String?,
      document: json['document'] as String?,
      socialReason: json['social_reason'] as String?,
      fantasyName: json['fantasy_name'] as String?,
      status: json['status'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      accountingEmail: json['accounting_email'] as String?,
      address:
          json['address'] != null
              ? Address.fromJson(json['address'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'document': document,
      'social_reason': socialReason,
      'fantasy_name': fantasyName,
      'status': status,
      'phone': phone,
      'email': email,
      'website': website,
      'accounting_email': accountingEmail,
      'address': address?.toJson(),
    };
  }

  static List<EnterpriseModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => EnterpriseModel.fromJson(item)).toList();
  }

  @override
  String toString() {
    return 'EnterpriseModel{id: $id, document: $document, socialReason: $socialReason, fantasyName: $fantasyName, status: $status, phone: $phone, email: $email, website: $website, accountingEmail: $accountingEmail, address: $address}';
  }
}
