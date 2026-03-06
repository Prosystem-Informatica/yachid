enum LayoutRemessa { cnab240, cnab400 }

extension LayoutRemessaX on LayoutRemessa {
  String get apiValue => switch (this) {
        LayoutRemessa.cnab240 => 'CNAB_240',
        LayoutRemessa.cnab400 => 'CNAB_400',
      };
  static LayoutRemessa? fromApi(String? v) {
    if (v == null || v.toString().trim().isEmpty) return null;
    return switch (v.toString().toUpperCase()) {
      'CNAB_400' => LayoutRemessa.cnab400,
      'CNAB_240' => LayoutRemessa.cnab240,
      _ => LayoutRemessa.cnab240,
    };
  }
}

class BankDetail {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int codigo;
  final String numeroBanco;
  final String nome;
  final String? agenciaNumero;
  final String? agenciaDv;
  final String? contaNumero;
  final String? contaDv;
  final String? codigoCedente;
  final String? codigoConvenio;
  final String? codigoEmpresa;
  final int? ultimoBoletoEmitido;
  final String? codigoTransmissao;
  final double? moraDiariaPercent;
  final String? carteira;
  final String? variacaoCarteira;
  final double? multaPercent;
  final int? diasProtesto;
  final LayoutRemessa? layoutRemessa;
  final String? instrucoesBoleto;

  BankDetail({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.codigo,
    required this.numeroBanco,
    required this.nome,
    this.agenciaNumero,
    this.agenciaDv,
    this.contaNumero,
    this.contaDv,
    this.codigoCedente,
    this.codigoConvenio,
    this.codigoEmpresa,
    this.ultimoBoletoEmitido,
    this.codigoTransmissao,
    this.moraDiariaPercent,
    this.carteira,
    this.variacaoCarteira,
    this.multaPercent,
    this.diasProtesto,
    this.layoutRemessa,
    this.instrucoesBoleto,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) {
    return BankDetail(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      codigo: json['codigo'] as int? ?? 0,
      numeroBanco: json['numero_banco'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      agenciaNumero: json['agencia_numero'] as String?,
      agenciaDv: json['agencia_dv'] as String?,
      contaNumero: json['conta_numero'] as String?,
      contaDv: json['conta_dv'] as String?,
      codigoCedente: json['codigo_cedente'] as String?,
      codigoConvenio: json['codigo_convenio'] as String?,
      codigoEmpresa: json['codigo_empresa'] as String?,
      ultimoBoletoEmitido: json['ultimo_boleto_emitido'] as int?,
      codigoTransmissao: json['codigo_transmissao'] as String?,
      moraDiariaPercent: _parseDouble(json['mora_diaria_percent']),
      carteira: json['carteira'] as String?,
      variacaoCarteira: json['variacao_carteira'] as String?,
      multaPercent: _parseDouble(json['multa_percent']),
      diasProtesto: json['dias_protesto'] as int?,
      layoutRemessa: LayoutRemessaX.fromApi(json['layout_remessa'] as String?),
      instrucoesBoleto: json['instrucoes_boleto'] as String?,
    );
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '.'));
    return null;
  }
}
