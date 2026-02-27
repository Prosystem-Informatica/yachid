import 'package:yachid/app/features/home/module/representatives/model/representative_address_dto.dart';

enum TipoComissao {
  pedido('PEDIDO', 'Pedido'),
  contasAReceberBaixado('CONTAS_A_RECEBER_BAIXADO', 'Contas a Receber Baixado'),
  notaFiscal('NOTA_FISCAL', 'Nota Fiscal'),
  semComissao('SEM_COMISSAO', 'Sem Comissão');

  final String value;
  final String label;
  const TipoComissao(this.value, this.label);
}

class CreateRepresentativeDto {
  final String? codigo;
  final String nome;
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
  final RepresentativeAddressDto? address;

  CreateRepresentativeDto({
    this.codigo,
    required this.nome,
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
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      if (codigo != null && codigo!.isNotEmpty) 'codigo': codigo,
      'nome': nome,
      if (telefone != null && telefone!.isNotEmpty) 'telefone': telefone,
      if (comissao != null) 'comissao': comissao,
      if (status != null) 'status': status,
      if (documento != null && documento!.isNotEmpty) 'documento': documento,
      if (ieRg != null && ieRg!.isNotEmpty) 'ie_rg': ieRg,
      if (celular != null && celular!.isNotEmpty) 'celular': celular,
      if (contato != null && contato!.isNotEmpty) 'contato': contato,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (tipoComissao != null) 'tipo_comissao': tipoComissao!.value,
      if (prePedido != null) 'pre_pedido': prePedido,
      if (aplicativo != null) 'aplicativo': aplicativo,
      if (address != null) 'address': address!.toJson(),
    };
  }
}
