class ProductNotaFiscalModel {
  // IVA
  final String? ivaEstado;
  final double? ivaValor;
  final List<ProductIvaItemModel>? ivaTabela;

  // Classificação fiscal
  final String? ncm;
  final String? cest;
  final double? reducaoPerc;

  // ICMS
  final String? origemIcms;
  final String? sitTributariaIcms;

  // IBS / CBS
  final String? cstIbs;
  final String? classificacaoTributariaIbs;
  final String? cstCbs;
  final String? classificacaoTributariaCbs;

  // IPI
  final String? classeEnquadramentoIpi;
  final String? codigoEnquadramentoIpi;
  final double? aliquotaIpi;
  final String? sitTributariaIpi;

  // PIS
  final String? sitTributariaPis;
  final double? aliquotaPis;

  // COFINS
  final String? sitTributariaCofins;
  final double? aliquotaCofins;

  ProductNotaFiscalModel({
    this.ivaEstado,
    this.ivaValor,
    this.ivaTabela,
    this.ncm,
    this.cest,
    this.reducaoPerc,
    this.origemIcms,
    this.sitTributariaIcms,
    this.cstIbs,
    this.classificacaoTributariaIbs,
    this.cstCbs,
    this.classificacaoTributariaCbs,
    this.classeEnquadramentoIpi,
    this.codigoEnquadramentoIpi,
    this.aliquotaIpi,
    this.sitTributariaIpi,
    this.sitTributariaPis,
    this.aliquotaPis,
    this.sitTributariaCofins,
    this.aliquotaCofins,
  });

  factory ProductNotaFiscalModel.fromJson(Map<String, dynamic> json) {
    final ivaTabelaList = json['iva_tabela'] as List<dynamic>?;
    final ivaTabela = ivaTabelaList
        ?.map((e) => ProductIvaItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ProductNotaFiscalModel(
      ivaEstado: json['iva_estado'] as String?,
      ivaValor: _parseDouble(json['iva_valor']),
      ivaTabela: ivaTabela,
      ncm: json['ncm'] as String?,
      cest: json['cest'] as String?,
      reducaoPerc: _parseDouble(json['reducao_perc']),
      origemIcms: json['origem_icms'] as String?,
      sitTributariaIcms: json['sit_tributaria_icms'] as String?,
      cstIbs: json['cst_ibs'] as String?,
      classificacaoTributariaIbs:
          json['classificacao_tributaria_ibs'] as String?,
      cstCbs: json['cst_cbs'] as String?,
      classificacaoTributariaCbs:
          json['classificacao_tributaria_cbs'] as String?,
      classeEnquadramentoIpi: json['classe_enquadramento_ipi'] as String?,
      codigoEnquadramentoIpi: json['codigo_enquadramento_ipi'] as String?,
      aliquotaIpi: _parseDouble(json['aliquota_ipi']),
      sitTributariaIpi: json['sit_tributaria_ipi'] as String?,
      sitTributariaPis: json['sit_tributaria_pis'] as String?,
      aliquotaPis: _parseDouble(json['aliquota_pis']),
      sitTributariaCofins: json['sit_tributaria_cofins'] as String?,
      aliquotaCofins: _parseDouble(json['aliquota_cofins']),
    );
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

class ProductIvaItemModel {
  final String estado;
  final double valor;

  ProductIvaItemModel({
    required this.estado,
    required this.valor,
  });

  factory ProductIvaItemModel.fromJson(Map<String, dynamic> json) {
    return ProductIvaItemModel(
      estado: json['estado'] as String? ?? '',
      valor: ProductNotaFiscalModel._parseDouble(json['valor']) ?? 0,
    );
  }
}
