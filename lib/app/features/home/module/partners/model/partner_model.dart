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

class PartnerModel {
  final String id;
  final String codigo;
  final String name;
  final String document;
  final String fantasyName;
  final String city;
  final String mainPhone;
  final String secondaryPhone;
  final String cellphone;
  final String uf;
  final String cep;
  final PartnerStatus status;
  final PartnerType personType;
  final String ieRg;
  final String businessSector;

  PartnerModel({
    required this.id,
    required this.codigo,
    required this.name,
    required this.document,
    required this.fantasyName,
    required this.city,
    required this.mainPhone,
    required this.secondaryPhone,
    required this.cellphone,
    required this.uf,
    required this.cep,
    required this.status,
    required this.personType,
    required this.ieRg,
    required this.businessSector,
  });

  /// Telefone principal para exibição (principal ou celular).
  String get displayPhone => mainPhone.isNotEmpty ? mainPhone : cellphone;

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['id'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      name: json['name'] as String? ?? '',
      document: json['document'] as String? ?? '',
      fantasyName: json['fantasy_name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      mainPhone: json['main_phone'] as String? ?? '',
      secondaryPhone: json['secondary_phone'] as String? ?? '',
      cellphone: json['cellphone'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
      cep: json['cep'] as String? ?? '',
      status: _parseStatus(json['status']),
      personType: _parsePersonType(json['person_type']),
      ieRg: json['ie_rg'] as String? ?? '',
      businessSector: json['business_sector'] as String? ?? '',
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
    return {
      'id': id,
      'codigo': codigo,
      'name': name,
      'document': document,
      'fantasy_name': fantasyName,
      'city': city,
      'main_phone': mainPhone,
      'secondary_phone': secondaryPhone,
      'cellphone': cellphone,
      'uf': uf,
      'cep': cep,
      'status': status.name,
      'person_type': personType.name,
      'ie_rg': ieRg,
      'business_sector': businessSector,
    };
  }
}
