import 'package:yachid/app/features/home/module/representatives/model/create_representative_dto.dart';

class UpdateRepresentativeDto {
  final String? codigo;
  final String? nome;
  final String? telefone;
  final double? comissao;
  final bool? status;
  final String? documento;
  final String? ieRg;
  final String? celular;
  final String? contato;
  final String? email;
  final TipoComissao? tipoComissao;
  final bool? prePedido;
  final bool? aplicativo;

  UpdateRepresentativeDto({
    this.codigo,
    this.nome,
    this.telefone,
    this.comissao,
    this.status,
    this.documento,
    this.ieRg,
    this.celular,
    this.contato,
    this.email,
    this.tipoComissao,
    this.prePedido,
    this.aplicativo,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (codigo != null) map['codigo'] = codigo;
    if (nome != null) map['nome'] = nome;
    if (telefone != null) map['telefone'] = telefone;
    if (comissao != null) map['comissao'] = comissao;
    if (status != null) map['status'] = status;
    if (documento != null) map['documento'] = documento;
    if (ieRg != null) map['ie_rg'] = ieRg;
    if (celular != null) map['celular'] = celular;
    if (contato != null) map['contato'] = contato;
    if (email != null) map['email'] = email;
    if (tipoComissao != null) map['tipo_comissao'] = tipoComissao!.value;
    if (prePedido != null) map['pre_pedido'] = prePedido;
    if (aplicativo != null) map['aplicativo'] = aplicativo;
    return map;
  }
}
