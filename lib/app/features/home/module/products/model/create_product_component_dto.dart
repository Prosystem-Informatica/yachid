class CreateProductComponentDto {
  final String codigo;
  final String componente;
  final String? unidade;
  final double? prcCusto;
  final double? quantidade;
  final double? peso;
  final double? total;

  CreateProductComponentDto({
    required this.codigo,
    required this.componente,
    this.unidade,
    this.prcCusto,
    this.quantidade,
    this.peso,
    this.total,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'codigo': codigo,
      'componente': componente,
    };
    if (unidade != null && unidade!.isNotEmpty) map['unidade'] = unidade;
    if (prcCusto != null) map['prc_custo'] = prcCusto;
    if (quantidade != null) map['quantidade'] = quantidade;
    if (peso != null) map['peso'] = peso;
    if (total != null) map['total'] = total;
    return map;
  }
}
