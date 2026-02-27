import 'package:yachid/app/features/home/module/partners/model/payment_address.dart';
import 'package:yachid/app/model/address_model.dart';

/// Status do parceiro (cliente/fornecedor).
enum PartnerStatus {
  ACTIVE('Ativo'),
  INACTIVE('Inativo');

  final String label;
  const PartnerStatus(this.label);
}

/// Tipo de pessoa.
enum PartnerType {
  PF('Pessoa Física'),
  PJ('Pessoa Jurídica');

  final String label;
  const PartnerType(this.label);
}

class PartnerModelDto {
  final String? id;
  final PartnerType personType;
  final String document;
  final String name;
  final String fantasyName;
  final PartnerStatus status;
  final String mainPhone;
  final String secondaryPhone;
  final String cellphone;
  final String ieRg;
  final String businessSector;
  final String type;
  final Address address;
  final String? accountingAccount;
  final String? fixedExpenses;
  final String? provision;
  final String emailNfe;
  final String email;
  final String site;
  final String suframa;
  final PaymentAddressDto? paymentAddress;
  final String groupId;

  PartnerModelDto({
    this.id,
    required this.name,
    required this.document,
    required this.fantasyName,
    required this.mainPhone,
    required this.secondaryPhone,
    required this.cellphone,
    required this.status,
    required this.address,
    required this.personType,
    required this.ieRg,
    required this.businessSector,
    required this.type,
    this.accountingAccount,
    this.fixedExpenses,
    this.provision,
    required this.emailNfe,
    required this.email,
    required this.site,
    this.paymentAddress,
    required this.suframa,
    required this.groupId,
  });

  /// Telefone principal para exibição (principal ou celular).
  String get displayPhone => mainPhone.isNotEmpty ? mainPhone : cellphone;

  factory PartnerModelDto.fromJson(Map<String, dynamic> json) {
    return PartnerModelDto(
      address:
          json['address'] != null
              ? Address.fromJson(json['address'] as Map<String, dynamic>)
              : Address(
                cep: '',
                street: '',
                number: '',
                city: '',
                neighborhood: '',
                uf: '',
                complement: '',
              ),
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      document: json['document'] as String? ?? '',
      fantasyName: json['fantasy_name'] as String? ?? '',
      mainPhone: json['main_phone'] as String? ?? '',
      secondaryPhone: json['secondary_phone'] as String? ?? '',
      cellphone: json['cellphone'] as String? ?? '',
      status: _parseStatus(json['status']),
      personType: _parsePersonType(json['person_type']),
      ieRg: json['ie_rg'] as String? ?? '',
      businessSector: json['business_sector'] as String? ?? '',
      type: json['type'] as String? ?? '',
      accountingAccount: json['accounting_account'] as String? ?? '',
      fixedExpenses: json['fixed_expenses'] as bool? ?? false ? 'SIM' : 'NÃO',
      provision: json['provision'] as bool? ?? false ? 'SIM' : 'NÃO',
      emailNfe: json['email_nfe'] as String? ?? '',
      email: json['email'] as String? ?? '',
      site: json['site'] as String? ?? '',
      suframa: json['suframa'] as String? ?? '',
      paymentAddress:
          json['payment_address'] != null
              ? PaymentAddressDto.fromJson(
                json['payment_address'] as Map<String, dynamic>,
              )
              : null,
      groupId: json['groupId'] as String? ?? json['group_id'] as String? ?? '',
    );
  }

  static PartnerStatus _parseStatus(dynamic value) {
    if (value == null) return PartnerStatus.ACTIVE;
    if (value is String) {
      return PartnerStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => PartnerStatus.ACTIVE,
      );
    }
    return PartnerStatus.ACTIVE;
  }

  static PartnerType _parsePersonType(dynamic value) {
    if (value == null) return PartnerType.PJ;
    if (value is String) {
      return PartnerType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => PartnerType.PJ,
      );
    }
    return PartnerType.PJ;
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        'codigo': "1",
        'name': name,
        'document': document,
        'fantasy_name': fantasyName,
        'address': address.toJson(),
        'main_phone': mainPhone,
        'secondary_phone': secondaryPhone,
        'cellphone': cellphone,
        'status': status.name,
        'person_type':
            personType.name == PartnerType.PF.name ? 'Fisica' : 'Juridica',
        'ie_rg': ieRg,
        'business_sector': businessSector,
        'type': type,
        'accounting_account': accountingAccount,
        'fixed_expenses': fixedExpenses == 'SIM' ? true : false,
        'provision': provision == 'SIM' ? true : false,
        'email_nfe': emailNfe,
        'email': email,
        'site': site,
        'payment_address': paymentAddress?.toJson(),
        'suframa': suframa,
        'groupId': groupId,
      };
    } catch (e, s) {
      print(e.toString());
      return {};
    }
  }
}
