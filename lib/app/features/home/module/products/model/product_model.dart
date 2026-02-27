import 'product_nota_fiscal_model.dart';

class ProductModel {
  final String id;
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
  final List<ProductStockModel>? stocks;
  final List<ProductComponentModel>? components;
  final double? custoCalculado;
  final ProductNotaFiscalModel? notaFiscal;

  ProductModel({
    required this.id,
    required this.codigo,
    this.ultimoCodigo,
    this.penultimoCodigo,
    this.linha,
    this.codBarras,
    required this.status,
    required this.produto,
    this.tipo,
    this.familia,
    this.unidade,
    this.fabricante,
    this.gramatura,
    required this.calculaIcms,
    this.codTributario,
    this.pesoBruto,
    this.pesoLiquido,
    this.pesoProduto,
    this.embalagem,
    this.classificacao,
    this.validade,
    required this.produtoAvulso,
    required this.tipoCusto,
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
    this.stocks,
    this.components,
    this.notaFiscal,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final stocksList = json['stocks'] as List<dynamic>?;
    final stocks =
        stocksList
            ?.map((e) => ProductStockModel.fromJson(e as Map<String, dynamic>))
            .toList();
    final componentsList = json['components'] as List<dynamic>?;
    final components =
        componentsList
            ?.map(
              (e) =>
                  ProductComponentModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();

    return ProductModel(
      id: json['id'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      ultimoCodigo: json['ultimo_codigo'] as String?,
      penultimoCodigo: json['penultimo_codigo'] as String?,
      linha: json['linha'] as String?,
      codBarras: json['cod_barras'] as String?,
      status: json['status'] as bool? ?? true,
      produto: json['produto'] as String? ?? '',
      tipo: json['tipo'] as String?,
      familia: json['familia'] as String?,
      unidade: json['unidade'] as String?,
      fabricante: json['fabricante'] as String?,
      gramatura: json['gramatura'] as String?,
      calculaIcms: json['calcula_icms'] as bool? ?? false,
      codTributario: json['cod_tributario'] as String?,
      pesoBruto: _parseDouble(json['peso_bruto']),
      pesoLiquido: _parseDouble(json['peso_liquido']),
      pesoProduto: _parseDouble(json['peso_produto']),
      embalagem: json['embalagem'] as String?,
      classificacao: json['classificacao'] as String?,
      validade: json['validade'] as int?,
      produtoAvulso: json['produto_avulso'] as bool? ?? false,
      tipoCusto: json['tipo_custo'] as String? ?? 'CALCULADO',
      custoCalculado: _parseDouble(json['custo_calculado']),
      custoDigitado: _parseDouble(json['custo_digitado']),
      custoMedio: _parseDouble(json['custo_medio']),
      ultimoCusto: _parseDouble(json['ultimo_custo']),
      penultimoCusto: _parseDouble(json['penultimo_custo']),
      antPenCusto: _parseDouble(json['ant_pen_custo']),
      precoMin7: _parseDouble(json['preco_min_7']),
      precoMin12: _parseDouble(json['preco_min_12']),
      precoMin18: _parseDouble(json['preco_min_18']),
      precoTabela: _parseDouble(json['preco_tabela']),
      precoAnterior: _parseDouble(json['preco_anterior']),
      stocks: stocks,
      components: components,
      notaFiscal: json['nota_fiscal'] != null
          ? ProductNotaFiscalModel.fromJson(
              json['nota_fiscal'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

class ProductComponentModel {
  final String id;
  final String codigo;
  final String componente;
  final String? unidade;
  final double prcCusto;
  final double quantidade;
  final double peso;
  final double total;

  ProductComponentModel({
    required this.id,
    required this.codigo,
    required this.componente,
    this.unidade,
    this.prcCusto = 0,
    this.quantidade = 0,
    this.peso = 0,
    this.total = 0,
  });

  factory ProductComponentModel.fromJson(Map<String, dynamic> json) {
    return ProductComponentModel(
      id: json['id'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      componente: json['componente'] as String? ?? '',
      unidade: json['unidade'] as String?,
      prcCusto: ProductModel._parseDouble(json['prc_custo']) ?? 0,
      quantidade: ProductModel._parseDouble(json['quantidade']) ?? 0,
      peso: ProductModel._parseDouble(json['peso']) ?? 0,
      total: ProductModel._parseDouble(json['total']) ?? 0,
    );
  }
}

class ProductStockModel {
  final String id;
  final double saldoDisponivel;
  final double empenho;
  final String? dataUltVenda;
  final double? valorUltVenda;
  final double saldoEmpresa;
  final double empenhoEmpresa;
  final double prodProgramada;
  final ProductStockAddressModel? address;

  ProductStockModel({
    required this.id,
    required this.saldoDisponivel,
    required this.empenho,
    this.dataUltVenda,
    this.valorUltVenda,
    required this.saldoEmpresa,
    required this.empenhoEmpresa,
    required this.prodProgramada,
    this.address,
  });

  factory ProductStockModel.fromJson(Map<String, dynamic> json) {
    final addr = json['address'] as Map<String, dynamic>?;
    return ProductStockModel(
      id: json['id'] as String? ?? '',
      saldoDisponivel: ProductModel._parseDouble(json['saldo_disponivel']) ?? 0,
      empenho: ProductModel._parseDouble(json['empenho']) ?? 0,
      dataUltVenda: json['data_ult_venda'] as String?,
      valorUltVenda: ProductModel._parseDouble(json['valor_ult_venda']),
      saldoEmpresa: ProductModel._parseDouble(json['saldo_empresa']) ?? 0,
      empenhoEmpresa: ProductModel._parseDouble(json['empenho_empresa']) ?? 0,
      prodProgramada: ProductModel._parseDouble(json['prod_programada']) ?? 0,
      address: addr != null ? ProductStockAddressModel.fromJson(addr) : null,
    );
  }
}

class ProductStockAddressModel {
  final String id;
  final String rua;
  final String prateleiras;
  final double estoqueMinimo;
  final double estoqueMaximo;

  ProductStockAddressModel({
    required this.id,
    required this.rua,
    required this.prateleiras,
    required this.estoqueMinimo,
    required this.estoqueMaximo,
  });

  factory ProductStockAddressModel.fromJson(Map<String, dynamic> json) {
    return ProductStockAddressModel(
      id: json['id'] as String? ?? '',
      rua: json['rua'] as String? ?? '',
      prateleiras: json['prateleiras'] as String? ?? '',
      estoqueMinimo: ProductModel._parseDouble(json['estoque_minimo']) ?? 0,
      estoqueMaximo: ProductModel._parseDouble(json['estoque_maximo']) ?? 0,
    );
  }
}
