class CreateBankDto {
  final String? codigo;
  final String numeroBanco;
  final String nome;

  CreateBankDto({
    this.codigo,
    required this.numeroBanco,
    required this.nome,
  });

  Map<String, dynamic> toJson() {
    return {
      if (codigo != null && codigo!.isNotEmpty) 'codigo': codigo,
      'numero_banco': numeroBanco,
      'nome': nome,
    };
  }
}
