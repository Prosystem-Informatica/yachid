class UpdateProductDto {
  final String? codigo;
  final String? ultimoCodigo;
  final String? penultimoCodigo;
  final String? linha;
  final String? codBarras;
  final bool? status;
  final String? produto;
  final String? tipo;
  final String? familia;
  final String? unidade;
  final String? fabricante;
  final String? gramatura;
  final bool? calculaIcms;
  final String? codTributario;
  final double? pesoBruto;
  final double? pesoLiquido;
  final double? pesoProduto;
  final String? embalagem;
  final String? classificacao;
  final int? validade;
  final bool? produtoAvulso;
  final String? tipoCusto;
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

  UpdateProductDto({
    this.codigo,
    this.ultimoCodigo,
    this.penultimoCodigo,
    this.linha,
    this.codBarras,
    this.status,
    this.produto,
    this.tipo,
    this.familia,
    this.unidade,
    this.fabricante,
    this.gramatura,
    this.calculaIcms,
    this.codTributario,
    this.pesoBruto,
    this.pesoLiquido,
    this.pesoProduto,
    this.embalagem,
    this.classificacao,
    this.validade,
    this.produtoAvulso,
    this.tipoCusto,
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
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (codigo != null) map['codigo'] = codigo;
    if (ultimoCodigo != null) map['ultimo_codigo'] = ultimoCodigo;
    if (penultimoCodigo != null) map['penultimo_codigo'] = penultimoCodigo;
    if (linha != null) map['linha'] = linha;
    if (codBarras != null) map['cod_barras'] = codBarras;
    if (status != null) map['status'] = status;
    if (produto != null) map['produto'] = produto;
    if (tipo != null) map['tipo'] = tipo;
    if (familia != null) map['familia'] = familia;
    if (unidade != null) map['unidade'] = unidade;
    if (fabricante != null) map['fabricante'] = fabricante;
    if (gramatura != null) map['gramatura'] = gramatura;
    if (calculaIcms != null) map['calcula_icms'] = calculaIcms;
    if (codTributario != null) map['cod_tributario'] = codTributario;
    if (pesoBruto != null) map['peso_bruto'] = pesoBruto;
    if (pesoLiquido != null) map['peso_liquido'] = pesoLiquido;
    if (pesoProduto != null) map['peso_produto'] = pesoProduto;
    if (embalagem != null) map['embalagem'] = embalagem;
    if (classificacao != null) map['classificacao'] = classificacao;
    if (validade != null) map['validade'] = validade;
    if (produtoAvulso != null) map['produto_avulso'] = produtoAvulso;
    if (tipoCusto != null) map['tipo_custo'] = tipoCusto;
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
    return map;
  }
}
