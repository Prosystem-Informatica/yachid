import 'package:yachid/app/features/home/module/banks/model/bank_detail.dart';

class UpdateBankDto {
  final String? numeroBanco;
  final String? nome;
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

  UpdateBankDto({
    this.numeroBanco,
    this.nome,
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
    final map = <String, dynamic>{};
    if (numeroBanco != null) map['numero_banco'] = numeroBanco;
    if (nome != null) map['nome'] = nome;
    if (agenciaNumero != null) map['agencia_numero'] = agenciaNumero;
    if (agenciaDv != null) map['agencia_dv'] = agenciaDv;
    if (contaNumero != null) map['conta_numero'] = contaNumero;
    if (contaDv != null) map['conta_dv'] = contaDv;
    if (codigoCedente != null) map['codigo_cedente'] = codigoCedente;
    if (codigoConvenio != null) map['codigo_convenio'] = codigoConvenio;
    if (codigoEmpresa != null) map['codigo_empresa'] = codigoEmpresa;
    if (ultimoBoletoEmitido != null) map['ultimo_boleto_emitido'] = ultimoBoletoEmitido;
    if (codigoTransmissao != null) map['codigo_transmissao'] = codigoTransmissao;
    if (moraDiariaPercent != null) map['mora_diaria_percent'] = moraDiariaPercent;
    if (carteira != null) map['carteira'] = carteira;
    if (variacaoCarteira != null) map['variacao_carteira'] = variacaoCarteira;
    if (multaPercent != null) map['multa_percent'] = multaPercent;
    if (diasProtesto != null) map['dias_protesto'] = diasProtesto;
    if (layoutRemessa != null) map['layout_remessa'] = layoutRemessa!.apiValue;
    if (instrucoesBoleto != null) map['instrucoes_boleto'] = instrucoesBoleto;
    return map;
  }
}
