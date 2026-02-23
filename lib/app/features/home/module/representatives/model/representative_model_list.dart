class RepresentativeModelList {
  final String id;
  final String codigo;
  final String nome;
  final String? telefone;
  final String? celular;
  final double comissao;
  final bool status;
  final String? documento;
  final String? ieRg;
  final String? contato;
  final String? email;
  final String tipoComissao;
  final bool prePedido;
  final bool aplicativo;
  final String? city;
  final String? uf;

  RepresentativeModelList({
    required this.id,
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
    this.city,
    this.uf,
  });

  factory RepresentativeModelList.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>?;
    return RepresentativeModelList(
      id: json['id'] as String,
      codigo: json['codigo'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      telefone: json['telefone'] as String?,
      celular: json['celular'] as String?,
      comissao: _parseComissao(json['comissao']),
      status: json['status'] as bool? ?? true,
      documento: json['documento'] as String?,
      ieRg: json['ie_rg'] as String?,
      contato: json['contato'] as String?,
      email: json['email'] as String?,
      tipoComissao: _formatTipoComissao(json['tipo_comissao'] as String?),
      prePedido: json['pre_pedido'] as bool? ?? false,
      aplicativo: json['aplicativo'] as bool? ?? false,
      city: address?['city'] as String?,
      uf: address?['uf'] as String?,
    );
  }

  static double _parseComissao(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0;
    return 0;
  }

  static String _formatTipoComissao(String? v) {
    if (v == null) return 'Sem Comissão';
    switch (v) {
      case 'PEDIDO':
        return 'Pedido';
      case 'CONTAS_A_RECEBER_BAIXADO':
        return 'Contas a Receber Baixado';
      case 'NOTA_FISCAL':
        return 'Nota Fiscal';
      case 'SEM_COMISSAO':
      default:
        return 'Sem Comissão';
    }
  }
}
