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
    return PartnerModelList(
      id: json['id'],
      codigo: json['codigo'],
      document: json['document'],
      client: json['name'],
      fantasyName: json['fantasy_name'],
      city: json['city'],
      phone: json['main_phone'],
      uf: json['uf'],
      cep: json['cep'],
      status: json['status'] == 'ACTIVE' ? 'Ativo' : 'Inativo',
    );
  }
}
