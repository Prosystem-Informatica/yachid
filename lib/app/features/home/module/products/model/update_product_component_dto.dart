class UpdateProductComponentDto {
  final String? codigo;
  final String? componente;
  final String? unidade;
  final double? prcCusto;
  final double? quantidade;
  final double? peso;
  final double? total;

  UpdateProductComponentDto({
    this.codigo,
    this.componente,
    this.unidade,
    this.prcCusto,
    this.quantidade,
    this.peso,
    this.total,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (codigo != null && codigo!.isNotEmpty) map['codigo'] = codigo;
    if (componente != null && componente!.isNotEmpty) {
      map['componente'] = componente;
    }
    if (unidade != null && unidade!.isNotEmpty) map['unidade'] = unidade;
    if (prcCusto != null) map['prc_custo'] = prcCusto;
    if (quantidade != null) map['quantidade'] = quantidade;
    if (peso != null) map['peso'] = peso;
    if (total != null) map['total'] = total;
    return map;
  }
}
