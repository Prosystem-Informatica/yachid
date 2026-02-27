class UpdateProductNotaFiscalDto {
  // IVA
  final String? ivaEstado;
  final double? ivaValor;
  final List<UpdateIvaItemDto>? ivaTabela;

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

  UpdateProductNotaFiscalDto({
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (ivaEstado != null) map['iva_estado'] = ivaEstado;
    if (ivaValor != null) map['iva_valor'] = ivaValor;
    if (ivaTabela != null)
      map['iva_tabela'] = ivaTabela!.map((e) => e.toJson()).toList();
    if (ncm != null) map['ncm'] = ncm;
    if (cest != null) map['cest'] = cest;
    if (reducaoPerc != null) map['reducao_perc'] = reducaoPerc;
    if (origemIcms != null) map['origem_icms'] = origemIcms;
    if (sitTributariaIcms != null)
      map['sit_tributaria_icms'] = sitTributariaIcms;
    if (cstIbs != null) map['cst_ibs'] = cstIbs;
    if (classificacaoTributariaIbs != null)
      map['classificacao_tributaria_ibs'] = classificacaoTributariaIbs;
    if (cstCbs != null) map['cst_cbs'] = cstCbs;
    if (classificacaoTributariaCbs != null)
      map['classificacao_tributaria_cbs'] = classificacaoTributariaCbs;
    if (classeEnquadramentoIpi != null)
      map['classe_enquadramento_ipi'] = classeEnquadramentoIpi;
    if (codigoEnquadramentoIpi != null)
      map['codigo_enquadramento_ipi'] = codigoEnquadramentoIpi;
    if (aliquotaIpi != null) map['aliquota_ipi'] = aliquotaIpi;
    if (sitTributariaIpi != null)
      map['sit_tributaria_ipi'] = sitTributariaIpi;
    if (sitTributariaPis != null)
      map['sit_tributaria_pis'] = sitTributariaPis;
    if (aliquotaPis != null) map['aliquota_pis'] = aliquotaPis;
    if (sitTributariaCofins != null)
      map['sit_tributaria_cofins'] = sitTributariaCofins;
    if (aliquotaCofins != null) map['aliquota_cofins'] = aliquotaCofins;

    return map;
  }
}

class UpdateIvaItemDto {
  final String estado;
  final double valor;

  UpdateIvaItemDto({
    required this.estado,
    required this.valor,
  });

  Map<String, dynamic> toJson() => {
        'estado': estado,
        'valor': valor,
      };
}
