class CreateProductDto {
  final String codigo;
  final String? ultimoCodigo;
  final String? penultimoCodigo;
  final String? linha;
  final String? codBarras;
  final bool status;
  final String produto;
  final String? tipo;
  final String? familia;
  final String? unidade;
  final String? fabricante;
  final String? gramatura;
  final bool calculaIcms;
  final String? codTributario;
  final double? pesoBruto;
  final double? pesoLiquido;
  final double? pesoProduto;
  final String? embalagem;
  final String? classificacao;
  final int? validade;
  final bool produtoAvulso;
  final String tipoCusto;
  final double? custoCalculado;
  final double? custoDigitado;
  final double? custoMedio;
  final double? ultimoCusto;
  final double? penultimoCusto;
  final double? antPenCusto;
  final double? precoMin7;
  final double? precoMin12;
  final double? precoMin18;
  final double? precoTabela;
  final double? precoAnterior;
  final CreateProductStockDto? stock;

  CreateProductDto({
    required this.codigo,
    this.ultimoCodigo,
    this.penultimoCodigo,
    this.linha,
    this.codBarras,
    this.status = true,
    required this.produto,
    this.tipo,
    this.familia,
    this.unidade,
    this.fabricante,
    this.gramatura,
    this.calculaIcms = false,
    this.codTributario,
    this.pesoBruto,
    this.pesoLiquido,
    this.pesoProduto,
    this.embalagem,
    this.classificacao,
    this.validade,
    this.produtoAvulso = false,
    this.tipoCusto = 'CALCULADO',
    this.custoCalculado,
    this.custoDigitado,
    this.custoMedio,
    this.ultimoCusto,
    this.penultimoCusto,
    this.antPenCusto,
    this.precoMin7,
    this.precoMin12,
    this.precoMin18,
    this.precoTabela,
    this.precoAnterior,
    this.stock,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'codigo': codigo,
      'produto': produto,
      'status': status,
      'calcula_icms': calculaIcms,
      'produto_avulso': produtoAvulso,
      'tipo_custo': tipoCusto,
    };
    if (ultimoCodigo != null && ultimoCodigo!.isNotEmpty)
      map['ultimo_codigo'] = ultimoCodigo;
    if (penultimoCodigo != null && penultimoCodigo!.isNotEmpty)
      map['penultimo_codigo'] = penultimoCodigo;
    if (linha != null && linha!.isNotEmpty) map['linha'] = linha;
    if (codBarras != null && codBarras!.isNotEmpty)
      map['cod_barras'] = codBarras;
    if (tipo != null && tipo!.isNotEmpty) map['tipo'] = tipo;
    if (familia != null && familia!.isNotEmpty) map['familia'] = familia;
    if (unidade != null && unidade!.isNotEmpty) map['unidade'] = unidade;
    if (fabricante != null && fabricante!.isNotEmpty)
      map['fabricante'] = fabricante;
    if (gramatura != null && gramatura!.isNotEmpty)
      map['gramatura'] = gramatura;
    if (codTributario != null && codTributario!.isNotEmpty)
      map['cod_tributario'] = codTributario;
    if (pesoBruto != null) map['peso_bruto'] = pesoBruto;
    if (pesoLiquido != null) map['peso_liquido'] = pesoLiquido;
    if (pesoProduto != null) map['peso_produto'] = pesoProduto;
    if (embalagem != null && embalagem!.isNotEmpty)
      map['embalagem'] = embalagem;
    if (classificacao != null && classificacao!.isNotEmpty)
      map['classificacao'] = classificacao;
    if (validade != null) map['validade'] = validade;
    if (custoCalculado != null) map['custo_calculado'] = custoCalculado;
    if (custoDigitado != null) map['custo_digitado'] = custoDigitado;
    if (custoMedio != null) map['custo_medio'] = custoMedio;
    if (ultimoCusto != null) map['ultimo_custo'] = ultimoCusto;
    if (penultimoCusto != null) map['penultimo_custo'] = penultimoCusto;
    if (antPenCusto != null) map['ant_pen_custo'] = antPenCusto;
    if (precoMin7 != null) map['preco_min_7'] = precoMin7;
    if (precoMin12 != null) map['preco_min_12'] = precoMin12;
    if (precoMin18 != null) map['preco_min_18'] = precoMin18;
    if (precoTabela != null) map['preco_tabela'] = precoTabela;
    if (precoAnterior != null) map['preco_anterior'] = precoAnterior;

    if (stock != null) {
      map['stock'] = stock!.toJson();
    }
    return map;
  }
}

class CreateProductStockDto {
  final double? saldoDisponivel;
  final double? empenho;
  final String? dataUltVenda;
  final double? valorUltVenda;
  final double? saldoEmpresa;
  final double? empenhoEmpresa;
  final double? prodProgramada;
  final CreateStockAddressDto? address;

  CreateProductStockDto({
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
    if (dataUltVenda != null && dataUltVenda!.isNotEmpty)
      map['data_ult_venda'] = dataUltVenda;
    if (valorUltVenda != null) map['valor_ult_venda'] = valorUltVenda;
    if (saldoEmpresa != null) map['saldo_empresa'] = saldoEmpresa;
    if (empenhoEmpresa != null) map['empenho_empresa'] = empenhoEmpresa;
    if (prodProgramada != null) map['prod_programada'] = prodProgramada;
    if (address != null) map['address'] = address!.toJson();
    return map;
  }
}

class CreateStockAddressDto {
  final String rua;
  final String prateleiras;
  final double estoqueMinimo;
  final double estoqueMaximo;

  CreateStockAddressDto({
    required this.rua,
    required this.prateleiras,
    this.estoqueMinimo = 0,
    this.estoqueMaximo = 0,
  });

  Map<String, dynamic> toJson() => {
    'rua': rua,
    'prateleiras': prateleiras,
    'estoque_minimo': estoqueMinimo,
    'estoque_maximo': estoqueMaximo,
  };
}
