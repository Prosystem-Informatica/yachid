class CnpjResponseModel {
  final String taxId;
  final String? alias;
  final String name;
  final String? status;
  final bool simplesOptant;
  final CnpjAddress? address;
  final List<CnpjPhone>? phones;
  final List<CnpjEmail>? emails;
  final List<CnpjRegistration>? registrations;

  CnpjResponseModel({
    required this.taxId,
    this.alias,
    required this.name,
    this.status,
    required this.simplesOptant,
    this.address,
    this.phones,
    this.emails,
    this.registrations,
  });

  factory CnpjResponseModel.fromJson(Map<String, dynamic> json) {
    return CnpjResponseModel(
      taxId: json['taxId'] ?? '',
      alias: json['alias'],
      name: json['company']?['name'] ?? '',
      status: json['status']?['text'],
      simplesOptant: json['company']?['simples']?['optant'] ?? false,
      address: json['address'] != null
          ? CnpjAddress.fromJson(json['address'])
          : null,
      phones: json['phones'] != null
          ? (json['phones'] as List)
              .map((e) => CnpjPhone.fromJson(e))
              .toList()
          : null,
      emails: json['emails'] != null
          ? (json['emails'] as List)
              .map((e) => CnpjEmail.fromJson(e))
              .toList()
          : null,
      registrations: json['registrations'] != null
          ? (json['registrations'] as List)
              .map((e) => CnpjRegistration.fromJson(e))
              .toList()
          : null,
    );
  }
}

class CnpjAddress {
  final String? street;
  final String? number;
  final String? district;
  final String? city;
  final String? state;
  final String? zip;

  CnpjAddress({
    this.street,
    this.number,
    this.district,
    this.city,
    this.state,
    this.zip,
  });

  factory CnpjAddress.fromJson(Map<String, dynamic> json) {
    return CnpjAddress(
      street: json['street'],
      number: json['number'],
      district: json['district'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }
}

class CnpjPhone {
  final String? type;
  final String? area;
  final String? number;

  CnpjPhone({
    this.type,
    this.area,
    this.number,
  });

  factory CnpjPhone.fromJson(Map<String, dynamic> json) {
    return CnpjPhone(
      type: json['type'],
      area: json['area'],
      number: json['number'],
    );
  }

  String get formatted {
    if (area != null && number != null) {
      return '($area) $number';
    }
    return number ?? '';
  }
}

class CnpjEmail {
  final String? address;

  CnpjEmail({
    this.address,
  });

  factory CnpjEmail.fromJson(Map<String, dynamic> json) {
    return CnpjEmail(
      address: json['address'],
    );
  }
}

class CnpjRegistration {
  final String? number;
  final String? state;
  final bool? enabled;

  CnpjRegistration({
    this.number,
    this.state,
    this.enabled,
  });

  factory CnpjRegistration.fromJson(Map<String, dynamic> json) {
    return CnpjRegistration(
      number: json['number'],
      state: json['state'],
      enabled: json['enabled'],
    );
  }
}
