class RepresentativeAddressDto {
  final String cep;
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String? cityIbgeCode;
  final String country;
  final String uf;

  RepresentativeAddressDto({
    required this.cep,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.city,
    this.cityIbgeCode,
    required this.country,
    required this.uf,
  });

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'street': street,
      'number': number,
      if (complement != null && complement!.isNotEmpty) 'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      if (cityIbgeCode != null) 'city_ibge_code': cityIbgeCode,
      'country': country,
      'uf': uf,
    };
  }
}
