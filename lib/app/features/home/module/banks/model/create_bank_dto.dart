class CreateBankDto {
  final String codigo;
  final String numeroBanco;
  final String nome;

  CreateBankDto({
    required this.codigo,
    required this.numeroBanco,
    required this.nome,
  });

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'numero_banco': numeroBanco,
      'nome': nome,
    };
  }
}
