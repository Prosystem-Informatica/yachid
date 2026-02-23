class PaymentAddressModel {
  final String? id;
  final String? representative;
  final String number;
  final String cep;
  final String street;
  final String neighborhood;
  final String city;
  final String uf;
  final String phone;
  final String email;
  final String observations;
  final bool? hasCredit;

  PaymentAddressModel({
    this.id,
    this.representative,
    required this.number,
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

  factory PaymentAddressModel.fromJson(Map<String, dynamic> json) {
    return PaymentAddressModel(
      id: json['id'],
      number: json['number'] ?? "",
      representative: json['representative'],
      cep: json['cep'],
      street: json['street'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      uf: json['uf'],
      phone: json['phone'],
      email: json['email'],
      observations: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'representative': representative,
      'cep': cep,
      'street': street,
      'neighborhood': neighborhood,
      'city': city,
      'uf': uf,
      'phone': phone,
      'email': email,
      'number': number,
      'observations': observations,
      'hasCredit': hasCredit,
    };
  }
}
