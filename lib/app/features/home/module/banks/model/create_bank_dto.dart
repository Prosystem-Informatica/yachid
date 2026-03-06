import 'package:yachid/app/features/home/module/banks/model/bank_detail.dart';

class CreateBankDto {
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

  CreateBankDto({
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'numero_banco': numeroBanco,
      'nome': nome,
    };
    if (agenciaNumero != null && agenciaNumero!.isNotEmpty) map['agencia_numero'] = agenciaNumero;
    if (agenciaDv != null && agenciaDv!.isNotEmpty) map['agencia_dv'] = agenciaDv;
    if (contaNumero != null && contaNumero!.isNotEmpty) map['conta_numero'] = contaNumero;
    if (contaDv != null && contaDv!.isNotEmpty) map['conta_dv'] = contaDv;
    if (codigoCedente != null && codigoCedente!.isNotEmpty) map['codigo_cedente'] = codigoCedente;
    if (codigoConvenio != null && codigoConvenio!.isNotEmpty) map['codigo_convenio'] = codigoConvenio;
    if (codigoEmpresa != null && codigoEmpresa!.isNotEmpty) map['codigo_empresa'] = codigoEmpresa;
    if (ultimoBoletoEmitido != null) map['ultimo_boleto_emitido'] = ultimoBoletoEmitido;
    if (codigoTransmissao != null && codigoTransmissao!.isNotEmpty) map['codigo_transmissao'] = codigoTransmissao;
    if (moraDiariaPercent != null) map['mora_diaria_percent'] = moraDiariaPercent;
    if (carteira != null && carteira!.isNotEmpty) map['carteira'] = carteira;
    if (variacaoCarteira != null && variacaoCarteira!.isNotEmpty) map['variacao_carteira'] = variacaoCarteira;
    if (multaPercent != null) map['multa_percent'] = multaPercent;
    if (diasProtesto != null) map['dias_protesto'] = diasProtesto;
    if (layoutRemessa != null) map['layout_remessa'] = layoutRemessa!.apiValue;
    if (instrucoesBoleto != null && instrucoesBoleto!.isNotEmpty) map['instrucoes_boleto'] = instrucoesBoleto;
    return map;
  }
}
