import 'package:yachid/app/features/home/module/partners/model/address.dart';
import 'package:yachid/app/features/home/module/partners/model/partner_model.dart';

class PartnerDetails {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String codigo;
  final String document;
  final String ieRg;
  final String name;
  final String fantasyName;
  final String mainPhone;
  final String secondaryPhone;
  final String cellphone;
  final String personType;
  final String partnerType;
  final String suframa;
  final String businessSector;
  final String emailNfe;
  final String email;
  final String site;
  final String status;
  final String? accountingAccount;
  final String type;
  final bool provision;
  final bool fixedExpenses;

  final Address address;
  final dynamic carriers;
  final dynamic branch;

  PartnerDetails({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.codigo,
    required this.document,
    required this.ieRg,
    required this.name,
    required this.fantasyName,
    required this.mainPhone,
    required this.secondaryPhone,
    required this.cellphone,
    required this.personType,
    required this.partnerType,
    required this.suframa,
    required this.businessSector,
    required this.emailNfe,
    required this.email,
    required this.site,
    required this.status,
    this.accountingAccount,
    required this.type,
    required this.provision,
    required this.fixedExpenses,
    required this.address,
    this.carriers,
    this.branch,
  });

  factory PartnerDetails.fromJson(Map<String, dynamic> json) {
    print('json: $json');
    return PartnerDetails(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      codigo: json['codigo'] as String,
      document: json['document'] as String,
      ieRg: json['ie_rg'] as String,
      name: json['name'] as String,
      fantasyName: json['fantasy_name'] as String,
      mainPhone: json['main_phone'] as String,
      secondaryPhone: json['secondary_phone'] as String,
      cellphone: json['cellphone'] as String,
      personType: json['person_type'] as String,
      partnerType: json['partner_type'] as String,
      suframa: json['suframa'] as String,
      businessSector: json['business_sector'] as String,
      emailNfe: json['email_nfe'] as String,
      email: json['email'] as String,
      site: json['site'] as String,
      status: json['status'],
      accountingAccount: json['accounting_account'] as String?,
      type: json['type'] as String,
      provision: json['provision'] as bool,
      fixedExpenses: json['fixed_expenses'] as bool,
      address: Address.fromJson(json['address']),
      carriers: json['carriers'],
      branch: json['branch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'codigo': codigo,
      'document': document,
      'ie_rg': ieRg,
      'name': name,
      'fantasy_name': fantasyName,
      'main_phone': mainPhone,
      'secondary_phone': secondaryPhone,
      'cellphone': cellphone,
      'person_type': personType,
      'partner_type': partnerType,
      'suframa': suframa,
      'business_sector': businessSector,
      'email_nfe': emailNfe,
      'email': email,
      'site': site,
      'status': status,
      'accounting_account': accountingAccount,
      'type': type,
      'provision': provision,
      'fixed_expenses': fixedExpenses,
      'address': address.toJson(),
      'carriers': carriers,
      'branch': branch,
    };
  }
}
