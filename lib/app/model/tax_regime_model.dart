class TaxRegimeModel {
  final String taxRegime;
  final String regimeTributarioIssqn;
  final String indRatIssqn;

  TaxRegimeModel({
    required this.taxRegime,
    required this.regimeTributarioIssqn,
    required this.indRatIssqn,
  });

  factory TaxRegimeModel.fromJson(Map<String, dynamic> json) {
    return TaxRegimeModel(
      taxRegime: json['tax_regime'] ?? '',
      regimeTributarioIssqn: json['regime_tributario_issqn'] ?? '',
      indRatIssqn: json['ind_rat_issqn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tax_regime': taxRegime,
      'regime_tributario_issqn': regimeTributarioIssqn,
      'ind_rat_issqn': indRatIssqn,
    };
  }
}
