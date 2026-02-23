class BankDetail {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String codigo;
  final String numeroBanco;
  final String nome;

  BankDetail({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.codigo,
    required this.numeroBanco,
    required this.nome,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) {
    return BankDetail(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      codigo: json['codigo'] as String? ?? '',
      numeroBanco: json['numero_banco'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
    );
  }
}
