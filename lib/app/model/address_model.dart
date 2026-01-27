class Address {
  final String? id;
  final String? cep;
  final String? street;
  final String? number;
  final String? complement;
  final String? neighborhood;
  final String? city;
  final String? cityIbgeCode;
  final String? country;
  final String? state;
  final String? uf;

  const Address({
    this.id,
    this.cep,
    this.street,
    this.number,
    this.complement,
    this.neighborhood,
    this.city,
    this.cityIbgeCode,
    this.country,
    this.state,
    this.uf,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String?,
      cep: json['cep'] as String?,
      street: json['street'] as String?,
      number: json['number'] as String?,
      complement: json['complement'] as String?,
      neighborhood: json['neighborhood'] as String?,
      city: json['city'] as String?,
      cityIbgeCode: json['city_ibge_code'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      uf: json['uf'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cep': cep,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'city_ibge_code': cityIbgeCode,
      'country': country,
      'state': state,
      'uf': uf,
    };
  }

  @override
  String toString() {
    return 'Address{id: $id, cep: $cep, street: $street, number: $number, complement: $complement, neighborhood: $neighborhood, city: $city, cityIbgeCode: $cityIbgeCode, country: $country, state: $state, uf: $uf}';
  }
}
