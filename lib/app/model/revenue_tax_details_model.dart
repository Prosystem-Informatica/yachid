class RevenueTaxDetailsModel {
  final String? bcIrpj;
  final String? bcCsll;
  final String? aliquotaIrpj;
  final String? aliquotaCsll;
  final String? ibsUf;
  final String? ibsMun;
  final String? cbs;
  final String? over;
  final String? valueOver;

  final String? aliquota;
  final String? cofins;
  final String? pis;
  final String? icms;
  final String? receitaBrutaAnual;

  RevenueTaxDetailsModel({
    this.bcIrpj,
    this.bcCsll,
    this.aliquotaIrpj,
    this.aliquotaCsll,
    this.ibsUf,
    this.ibsMun,
    this.cbs,
    this.over,
    this.valueOver,
    this.aliquota,
    this.cofins,
    this.pis,
    this.icms,
    this.receitaBrutaAnual,
  });

  factory RevenueTaxDetailsModel.fromJson(Map<String, dynamic> json) {
    return RevenueTaxDetailsModel(
      bcIrpj: json['bc_irpj'],
      bcCsll: json['bc_csll'],
      aliquotaIrpj: json['aliquota_irpj'],
      aliquotaCsll: json['aliquota_csll'],
      ibsUf: json['ibs_uf'],
      ibsMun: json['ibs_mun'],
      cbs: json['cbs'],
      over: json['over'],
      valueOver: json['value_over'],
      aliquota: json['aliquota'],
      cofins: json['cofins'],
      pis: json['pis'],
      icms: json['icms'],
      receitaBrutaAnual: json['receita_bruta_anual'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bc_irpj': bcIrpj,
      'bc_csll': bcCsll,
      'aliquota_irpj': aliquotaIrpj,
      'aliquota_csll': aliquotaCsll,
      'ibs_uf': ibsUf,
      'ibs_mun': ibsMun,
      'cbs': cbs,
      'over': over,
      'value_over': valueOver,
      'aliquota': aliquota,
      'cofins': cofins,
      'pis': pis,
      'icms': icms,
      'receita_bruta_anual': receitaBrutaAnual,
    };
  }
}
