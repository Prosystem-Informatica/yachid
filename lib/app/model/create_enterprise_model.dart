import 'models.dart';

class CreateEnterpriseModel {
  final String document;
  final String socialReason;
  final String fantasyName;
  final String status;
  final String phone;
  final String email;
  final String website;
  final Address address;
  final RevenueTaxDetailsModel? revenueTaxDetails;
  final TaxRegimeModel taxRegime;

  CreateEnterpriseModel({
    required this.document,
    required this.socialReason,
    required this.fantasyName,
    required this.status,
    required this.phone,
    required this.email,
    required this.website,
    required this.address,
    required this.revenueTaxDetails,
    required this.taxRegime,
  });

  factory CreateEnterpriseModel.fromJson(Map<String, dynamic> json) {
    return CreateEnterpriseModel(
      document: json['document'] ?? '',
      socialReason: json['social_reason'] ?? '',
      fantasyName: json['fantasy_name'] ?? '',
      status: json['status'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
      revenueTaxDetails:
          json['revenueTaxDetails'] != null
              ? RevenueTaxDetailsModel.fromJson(json['revenueTaxDetails'])
              : null,
      taxRegime: TaxRegimeModel.fromJson(json['tax_regime'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document': document,
      'social_reason': socialReason,
      'fantasy_name': fantasyName,
      'status': status,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address.toJson(),
      'revenueTaxDetails': revenueTaxDetails?.toJson(),
      'tax_regime': taxRegime.toJson(),
    };
  }
}
