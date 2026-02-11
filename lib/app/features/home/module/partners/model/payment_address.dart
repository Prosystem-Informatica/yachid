class PaymentAddressDto {
  final String? representative;
  final String cep;
  final String street;
  final String neighborhood;
  final String city;
  final String uf;
  final String phone;
  final String email;
  final String observations;
  final bool? hasCredit;

  PaymentAddressDto({
    this.representative,
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.uf,
    required this.phone,
    required this.email,
    required this.observations,
    this.hasCredit,
  });

  factory PaymentAddressDto.fromJson(Map<String, dynamic> json) {
    return PaymentAddressDto(
      representative: json['representative'],
      cep: json['cep'],
      street: json['street'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      uf: json['uf'],
      phone: json['phone'],
      email: json['email'],
      observations: json['observations'],
      hasCredit: json['has_credit'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'cep': cep,
      'street': street,
      'neighborhood': neighborhood,
      'city': city,
      'uf': uf,
      'phone': phone,
      'email': email,
      'observations': observations,
      'representative': representative,
      'credit_account': hasCredit,
    };

    if (representative != null) {
      data['representative'] = representative;
    }

    if (hasCredit != null) {
      data['has_credit'] = hasCredit;
    }

    return data;
  }

  PaymentAddressDto copyWith({
    String? representative,
    String? cep,
    String? street,
    String? neighborhood,
    String? city,
    String? uf,
    String? phone,
    String? email,
    String? observations,
    bool? hasCredit,
  }) {
    return PaymentAddressDto(
      hasCredit: hasCredit ?? this.hasCredit,

      representative: representative ?? this.representative,
      cep: cep ?? this.cep,
      street: street ?? this.street,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      uf: uf ?? this.uf,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      observations: observations ?? this.observations,
    );
  }
}
