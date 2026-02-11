class Address {
  final String cep;
  final String street;
  final String number;
  final String city;
  final String neighborhood;
  final String uf;
  final String complement;

  Address({
    required this.cep,
    required this.street,
    required this.number,
    required this.city,
    required this.neighborhood,
    required this.uf,
    required this.complement,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      cep: json['cep'] as String? ?? '',
      street: json['street'] as String? ?? '',
      number: json['number'] as String? ?? '',
      city: json['city'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
      complement: json['complement'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'street': street,
      'number': number,
      'city': city,
      'neighborhood': neighborhood,
      'uf': uf,
      'complement': complement,
    };
  }

  @override
  String toString() {
    return 'Address(cep: $cep, street: $street, number: $number, city: $city, neighborhood: $neighborhood, uf: $uf, complement: $complement)';
  }

  Address copyWith({
    String? cep,
    String? street,
    String? number,
    String? city,
    String? neighborhood,
    String? uf,
    String? complement,
  }) {
    return Address(
      cep: cep ?? this.cep,
      street: street ?? this.street,
      number: number ?? this.number,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      uf: uf ?? this.uf,
      complement: complement ?? this.complement,
    );
  }
}
