class PartnerModelList {
  final String id;
  final String codigo;
  final String document;
  final String client;
  final String fantasyName;
  final String city;
  final String phone;
  final String uf;
  final String cep;
  final String status;

  PartnerModelList({
    required this.id,
    required this.codigo,
    required this.document,
    required this.client,
    required this.fantasyName,
    required this.city,
    required this.phone,
    required this.uf,
    required this.cep,
    required this.status,
  });

  factory PartnerModelList.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>?;
    return PartnerModelList(
      id: json['id']?.toString() ?? '',
      codigo: json['codigo']?.toString() ?? '',
      document: json['document']?.toString() ?? '',
      client: json['name']?.toString() ?? '',
      fantasyName: json['fantasy_name']?.toString() ?? '',
      city: json['city']?.toString() ?? address?['city']?.toString() ?? '',
      phone: json['main_phone']?.toString() ?? json['phone']?.toString() ?? '',
      uf: json['uf']?.toString() ?? address?['uf']?.toString() ?? '',
      cep: json['cep']?.toString() ?? address?['cep']?.toString() ?? '',
      status: json['status'] == 'ACTIVE' ? 'Ativo' : 'Inativo',
    );
  }
}
