class UpdateBankDto {
  final String? codigo;
  final String? numeroBanco;
  final String? nome;

  UpdateBankDto({
    this.codigo,
    this.numeroBanco,
    this.nome,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (codigo != null) map['codigo'] = codigo;
    if (numeroBanco != null) map['numero_banco'] = numeroBanco;
    if (nome != null) map['nome'] = nome;
    return map;
  }
}
