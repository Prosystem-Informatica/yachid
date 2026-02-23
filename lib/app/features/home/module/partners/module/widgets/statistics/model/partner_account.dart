class PartnerCreditConfig {
  final String creditValue;
  final bool serasaCheck;
  final String date;
  final bool newOrder;
  final bool orderRelease;
  final bool nfeIssuance;
  final bool creditAnalysis;

  PartnerCreditConfig({
    required this.creditValue,
    required this.serasaCheck,
    required this.date,
    required this.newOrder,
    required this.orderRelease,
    required this.nfeIssuance,
    required this.creditAnalysis,
  });

  factory PartnerCreditConfig.fromJson(Map<String, dynamic> json) {
    final date = json['date'];
    String dateStr = '';
    if (date != null) {
      if (date is String) {
        dateStr = date.length > 10 ? date.substring(0, 10) : date;
      } else {
        try {
          dateStr = DateTime.parse(date.toString()).toIso8601String().split('T').first;
        } catch (_) {
          dateStr = '';
        }
      }
    }
    return PartnerCreditConfig(
      creditValue: json['credit_value']?.toString() ?? '0',
      serasaCheck: json['serasa_check'] ?? false,
      date: dateStr,
      newOrder: json['new_order'] ?? false,
      orderRelease: json['order_release'] ?? false,
      nfeIssuance: json['nfe_issuance'] ?? false,
      creditAnalysis: json['credit_analysis'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'credit_value': creditValue,
      'serasa_check': serasaCheck,
      'date': date,
      'new_order': newOrder,
      'order_release': orderRelease,
      'nfe_issuance': nfeIssuance,
      'credit_analysis': creditAnalysis,
    };
  }

  PartnerCreditConfig copyWith({
    String? creditValue,
    bool? serasaCheck,
    String? date,
    bool? newOrder,
    bool? orderRelease,
    bool? nfeIssuance,
    bool? creditAnalysis,
  }) {
    return PartnerCreditConfig(
      creditValue: creditValue ?? this.creditValue,
      serasaCheck: serasaCheck ?? this.serasaCheck,
      date: date ?? this.date,
      newOrder: newOrder ?? this.newOrder,
      orderRelease: orderRelease ?? this.orderRelease,
      nfeIssuance: nfeIssuance ?? this.nfeIssuance,
      creditAnalysis: creditAnalysis ?? this.creditAnalysis,
    );
  }
}

String _parseDateFromJson(dynamic value) {
  if (value == null) return '';
  if (value is String) return value.length > 10 ? value.substring(0, 10) : value;
  try {
    return DateTime.parse(value.toString()).toIso8601String().split('T').first;
  } catch (_) {
    return '';
  }
}

class AccountsPayableModel {
  final String saldoDevedor;
  final String maiorAtraso;
  final String maiorFat;
  final String valorMaiorAtraso;
  final String primeiraCompra;
  final String valorPrimeiraCompra;
  final String ultimaCompra;
  final String valorUltimaCompra;
  final String atrasadas;
  final String cartorio;
  final String protesto;
  final String normal;
  final String observation;

  AccountsPayableModel({
    required this.saldoDevedor,
    required this.maiorAtraso,
    required this.maiorFat,
    required this.valorMaiorAtraso,
    required this.primeiraCompra,
    required this.valorPrimeiraCompra,
    required this.ultimaCompra,
    required this.valorUltimaCompra,
    required this.atrasadas,
    required this.cartorio,
    required this.protesto,
    required this.normal,
    required this.observation,
  });

  factory AccountsPayableModel.fromJson(Map<String, dynamic> json) {
    return AccountsPayableModel(
      saldoDevedor: json['saldo_devedor']?.toString() ?? '0',
      maiorAtraso: json['maior_atraso']?.toString() ?? '',
      maiorFat: _parseDateFromJson(json['maior_fat']),
      valorMaiorAtraso: json['valor_maior_atraso']?.toString() ?? '0',
      primeiraCompra: _parseDateFromJson(json['primeira_compra']),
      valorPrimeiraCompra: json['valor_primeira_compra']?.toString() ?? '0',
      ultimaCompra: _parseDateFromJson(json['ultima_compra']),
      valorUltimaCompra: json['valor_ultima_compra']?.toString() ?? '0',
      atrasadas: json['atrasadas']?.toString() ?? '',
      cartorio: json['cartorio']?.toString() ?? '',
      protesto: json['protesto']?.toString() ?? '',
      normal: json['normal']?.toString() ?? '',
      observation: json['observation']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'saldo_devedor': saldoDevedor,
        'maior_atraso': maiorAtraso,
        'maior_fat': maiorFat,
        'valor_maior_atraso': valorMaiorAtraso,
        'primeira_compra': primeiraCompra,
        'valor_primeira_compra': valorPrimeiraCompra,
        'ultima_compra': ultimaCompra,
        'valor_ultima_compra': valorUltimaCompra,
        'atrasadas': atrasadas,
        'cartorio': cartorio,
        'protesto': protesto,
        'normal': normal,
        'observation': observation,
      };
}

class AccountsReceivableModel {
  final String saldoDevedor;
  final String maiorAtraso;
  final String maiorFat;
  final String valorMaiorAtraso;
  final String primeiraCompra;
  final String valorPrimeiraCompra;
  final String ultimaCompra;
  final String valorUltimaCompra;
  final String atrasadas;
  final String cartorio;
  final String protesto;
  final String normal;
  final String observation;
  final String recebertoAberto;
  final String cheqEmAberto;
  final String cheqAVencer;
  final String serasa;
  final String averageOrders;
  final String processedOrders;

  AccountsReceivableModel({
    required this.saldoDevedor,
    required this.maiorAtraso,
    required this.maiorFat,
    required this.valorMaiorAtraso,
    required this.primeiraCompra,
    required this.valorPrimeiraCompra,
    required this.ultimaCompra,
    required this.valorUltimaCompra,
    required this.atrasadas,
    required this.cartorio,
    required this.protesto,
    required this.normal,
    required this.observation,
    required this.recebertoAberto,
    required this.cheqEmAberto,
    required this.cheqAVencer,
    required this.serasa,
    required this.averageOrders,
    required this.processedOrders,
  });

  factory AccountsReceivableModel.fromJson(Map<String, dynamic> json) {
    return AccountsReceivableModel(
      saldoDevedor: json['saldo_devedor']?.toString() ?? '0',
      maiorAtraso: json['maior_atraso']?.toString() ?? '',
      maiorFat: _parseDateFromJson(json['maior_fat']),
      valorMaiorAtraso: json['valor_maior_atraso']?.toString() ?? '0',
      primeiraCompra: _parseDateFromJson(json['primeira_compra']),
      valorPrimeiraCompra: json['valor_primeira_compra']?.toString() ?? '0',
      ultimaCompra: _parseDateFromJson(json['ultima_compra']),
      valorUltimaCompra: json['valor_ultima_compra']?.toString() ?? '0',
      atrasadas: json['atrasadas']?.toString() ?? '',
      cartorio: json['cartorio']?.toString() ?? '',
      protesto: json['protesto']?.toString() ?? '',
      normal: json['normal']?.toString() ?? '',
      observation: json['observation']?.toString() ?? '',
      recebertoAberto: json['receberto_aberto']?.toString() ?? '0',
      cheqEmAberto: json['cheq_em_aberto']?.toString() ?? '0',
      cheqAVencer: json['cheq_a_vencer']?.toString() ?? '0',
      serasa: json['serasa']?.toString() ?? '0',
      averageOrders: json['average_orders']?.toString() ?? '0',
      processedOrders: json['processed_orders']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
        'saldo_devedor': saldoDevedor,
        'maior_atraso': maiorAtraso,
        'maior_fat': maiorFat,
        'valor_maior_atraso': valorMaiorAtraso,
        'primeira_compra': primeiraCompra,
        'valor_primeira_compra': valorPrimeiraCompra,
        'ultima_compra': ultimaCompra,
        'valor_ultima_compra': valorUltimaCompra,
        'atrasadas': atrasadas,
        'cartorio': cartorio,
        'protesto': protesto,
        'normal': normal,
        'observation': observation,
        'receberto_aberto': recebertoAberto,
        'cheq_em_aberto': cheqEmAberto,
        'cheq_a_vencer': cheqAVencer,
        'serasa': serasa,
        'average_orders': averageOrders,
        'processed_orders': processedOrders,
      };
}
