class DeliveryAddress {
  final String cep;
  final String street;
  final String region;
  final String neighborhood;
  final String city;
  final String uf;
  final String? observations;
  final bool bonification;

  DeliveryAddress({
    required this.cep,
    required this.street,
    required this.region,
    required this.neighborhood,
    required this.city,
    required this.uf,
    this.observations,
    required this.bonification,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      cep: json['cep'],
      street: json['street'],
      region: json['region'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      uf: json['uf'],
      observations: json['observations'],
      bonification: json['bonification'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'street': street,
      'region': region,
      'neighborhood': neighborhood,
      'city': city,
      'uf': uf,
      'observations': observations,
      'bonification': bonification,
    };
  }

  DeliveryAddress copyWith({
    String? cep,
    String? street,
    String? region,
    String? neighborhood,
    String? city,
    String? uf,
    String? observations,
    bool? bonification,
  }) {
    return DeliveryAddress(
      cep: cep ?? this.cep,
      street: street ?? this.street,
      region: region ?? this.region,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      uf: uf ?? this.uf,
      observations: observations ?? this.observations,
      bonification: bonification ?? this.bonification,
    );
  }
}
