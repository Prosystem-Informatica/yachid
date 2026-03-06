import 'package:yachid/app/features/home/module/representatives/model/create_representative_dto.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_address_dto.dart';

class RepresentativeDetail {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int codigo;
  final String nome;
  final String? telefone;
  final String? celular;
  final double comissao;
  final bool status;
  final String? documento;
  final String? ieRg;
  final String? contato;
  final String? email;
  final TipoComissao tipoComissao;
  final bool prePedido;
  final bool aplicativo;
  final RepresentativeAddressDto? address;

  RepresentativeDetail({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.codigo,
    required this.nome,
    this.telefone,
    this.celular,
    required this.comissao,
    required this.status,
    this.documento,
    this.ieRg,
    this.contato,
    this.email,
    required this.tipoComissao,
    required this.prePedido,
    required this.aplicativo,
    this.address,
  });

  factory RepresentativeDetail.fromJson(Map<String, dynamic> json) {
    final addr = json['address'] as Map<String, dynamic>?;
    RepresentativeAddressDto? addressDto;
    if (addr != null) {
      addressDto = RepresentativeAddressDto(
        cep: addr['cep'] as String? ?? '',
        street: addr['street'] as String? ?? '',
        number: addr['number'] as String? ?? '',
        complement: addr['complement'] as String?,
        neighborhood: addr['neighborhood'] as String? ?? '',
        city: addr['city'] as String? ?? '',
        cityIbgeCode: addr['city_ibge_code'] as String?,
        country: addr['country'] as String? ?? 'Brasil',
        uf: addr['uf'] as String? ?? '',
      );
    }

    return RepresentativeDetail(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      codigo: json['codigo'] as int,
      nome: json['nome'] as String? ?? '',
      telefone: json['telefone'] as String?,
      celular: json['celular'] as String?,
      comissao: _parseComissao(json['comissao']),
      status: json['status'] as bool? ?? true,
      documento: json['documento'] as String?,
      ieRg: json['ie_rg'] as String?,
      contato: json['contato'] as String?,
      email: json['email'] as String?,
      tipoComissao: _parseTipoComissao(json['tipo_comissao'] as String?),
      prePedido: json['pre_pedido'] as bool? ?? false,
      aplicativo: json['aplicativo'] as bool? ?? false,
      address: addressDto,
    );
  }

  static double _parseComissao(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  static TipoComissao _parseTipoComissao(String? v) {
    if (v == null) return TipoComissao.semComissao;
    switch (v) {
      case 'PEDIDO':
        return TipoComissao.pedido;
      case 'CONTAS_A_RECEBER_BAIXADO':
        return TipoComissao.contasAReceberBaixado;
      case 'NOTA_FISCAL':
        return TipoComissao.notaFiscal;
      default:
        return TipoComissao.semComissao;
    }
  }
}
