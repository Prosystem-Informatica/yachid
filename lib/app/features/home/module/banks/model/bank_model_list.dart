class BankModelList {
  final String id;
  final String codigo;
  final String numeroBanco;
  final String nome;

  BankModelList({
    required this.id,
    required this.codigo,
    required this.numeroBanco,
    required this.nome,
  });

  factory BankModelList.fromJson(Map<String, dynamic> json) {
    return BankModelList(
      id: json['id'] as String,
      codigo: json['codigo'] as String? ?? '',
      numeroBanco: json['numero_banco'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
    );
  }
}
