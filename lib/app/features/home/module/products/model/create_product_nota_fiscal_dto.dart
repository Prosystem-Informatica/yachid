class CreateProductNotaFiscalDto {
  // IVA
  final String? ivaEstado;
  final double? ivaValor;
  final List<CreateIvaItemDto>? ivaTabela;

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
  final double aliquotaIpi;
  final String? sitTributariaIpi;

  // PIS
  final String? sitTributariaPis;
  final double aliquotaPis;

  // COFINS
  final String? sitTributariaCofins;
  final double aliquotaCofins;

  CreateProductNotaFiscalDto({
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
    this.aliquotaIpi = 0,
    this.sitTributariaIpi,
    this.sitTributariaPis,
    this.aliquotaPis = 1.65,
    this.sitTributariaCofins,
    this.aliquotaCofins = 7.6,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'aliquota_ipi': aliquotaIpi,
      'aliquota_pis': aliquotaPis,
      'aliquota_cofins': aliquotaCofins,
    };

    if (ivaEstado != null && ivaEstado!.isNotEmpty)
      map['iva_estado'] = ivaEstado;
    if (ivaValor != null) map['iva_valor'] = ivaValor;
    if (ivaTabela != null && ivaTabela!.isNotEmpty)
      map['iva_tabela'] = ivaTabela!.map((e) => e.toJson()).toList();
    if (ncm != null && ncm!.isNotEmpty) map['ncm'] = ncm;
    if (cest != null && cest!.isNotEmpty) map['cest'] = cest;
    if (reducaoPerc != null) map['reducao_perc'] = reducaoPerc;
    if (origemIcms != null && origemIcms!.isNotEmpty)
      map['origem_icms'] = origemIcms;
    if (sitTributariaIcms != null && sitTributariaIcms!.isNotEmpty)
      map['sit_tributaria_icms'] = sitTributariaIcms;
    if (cstIbs != null && cstIbs!.isNotEmpty) map['cst_ibs'] = cstIbs;
    if (classificacaoTributariaIbs != null &&
        classificacaoTributariaIbs!.isNotEmpty)
      map['classificacao_tributaria_ibs'] = classificacaoTributariaIbs;
    if (cstCbs != null && cstCbs!.isNotEmpty) map['cst_cbs'] = cstCbs;
    if (classificacaoTributariaCbs != null &&
        classificacaoTributariaCbs!.isNotEmpty)
      map['classificacao_tributaria_cbs'] = classificacaoTributariaCbs;
    if (classeEnquadramentoIpi != null && classeEnquadramentoIpi!.isNotEmpty)
      map['classe_enquadramento_ipi'] = classeEnquadramentoIpi;
    if (codigoEnquadramentoIpi != null && codigoEnquadramentoIpi!.isNotEmpty)
      map['codigo_enquadramento_ipi'] = codigoEnquadramentoIpi;
    if (sitTributariaIpi != null && sitTributariaIpi!.isNotEmpty)
      map['sit_tributaria_ipi'] = sitTributariaIpi;
    if (sitTributariaPis != null && sitTributariaPis!.isNotEmpty)
      map['sit_tributaria_pis'] = sitTributariaPis;
    if (sitTributariaCofins != null && sitTributariaCofins!.isNotEmpty)
      map['sit_tributaria_cofins'] = sitTributariaCofins;

    return map;
  }
}

class CreateIvaItemDto {
  final String estado;
  final double valor;

  CreateIvaItemDto({
    required this.estado,
    required this.valor,
  });

  Map<String, dynamic> toJson() => {
        'estado': estado,
        'valor': valor,
      };
}
