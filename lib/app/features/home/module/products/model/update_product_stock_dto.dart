class UpdateProductStockDto {
  final double? saldoDisponivel;
  final double? empenho;
  final String? dataUltVenda;
  final double? valorUltVenda;
  final double? saldoEmpresa;
  final double? empenhoEmpresa;
  final double? prodProgramada;
  final UpdateStockAddressDto? address;

  UpdateProductStockDto({
    this.saldoDisponivel,
    this.empenho,
    this.dataUltVenda,
    this.valorUltVenda,
    this.saldoEmpresa,
    this.empenhoEmpresa,
    this.prodProgramada,
    this.address,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (saldoDisponivel != null) map['saldo_disponivel'] = saldoDisponivel;
    if (empenho != null) map['empenho'] = empenho;
    if (dataUltVenda != null && dataUltVenda!.isNotEmpty) {
      map['data_ult_venda'] = dataUltVenda;
    }
    if (valorUltVenda != null) map['valor_ult_venda'] = valorUltVenda;
    if (saldoEmpresa != null) map['saldo_empresa'] = saldoEmpresa;
    if (empenhoEmpresa != null) map['empenho_empresa'] = empenhoEmpresa;
    if (prodProgramada != null) map['prod_programada'] = prodProgramada;
    if (address != null) map['address'] = address!.toJson();
    return map;
  }
}

class UpdateStockAddressDto {
  final String? rua;
  final String? prateleiras;
  final double? estoqueMinimo;
  final double? estoqueMaximo;

  UpdateStockAddressDto({
    this.rua,
    this.prateleiras,
    this.estoqueMinimo,
    this.estoqueMaximo,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (rua != null && rua!.isNotEmpty) map['rua'] = rua;
    if (prateleiras != null && prateleiras!.isNotEmpty) {
      map['prateleiras'] = prateleiras;
    }
    if (estoqueMinimo != null) map['estoque_minimo'] = estoqueMinimo;
    if (estoqueMaximo != null) map['estoque_maximo'] = estoqueMaximo;
    return map;
  }
}
