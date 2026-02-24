class PaymentAddressDto {
  final String? representative;
  final String? number;
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
    this.number,
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
      number: json['number'],
      cep: json['cep'] ?? '',
      street: json['street'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      city: json['city'] ?? '',
      uf: json['uf'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      observations: json['observations'] ?? '',
      hasCredit: json['credit_account'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['cep'] = cep;
    data['street'] = street;
    data['number'] = number ?? '';
    data['neighborhood'] = neighborhood;
    data['city'] = city;
    data['uf'] = uf;
    data['phone'] = phone;
    data['email'] = email;
    data['observations'] = observations;
    data['representative'] = representative ?? '';
    data['credit_account'] = hasCredit;
    return data;
  }

  PaymentAddressDto copyWith({
    String? representative,
    String? number,
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
      representative: representative ?? this.representative,
      number: number ?? this.number,
      cep: cep ?? this.cep,
      street: street ?? this.street,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      uf: uf ?? this.uf,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      observations: observations ?? this.observations,
      hasCredit: hasCredit ?? this.hasCredit,
    );
  }
}
