class ProductModelList {
  final String id;
  final String codigo;
  final String produto;
  final String? tipo;
  final String? unidade;
  final bool status;
  final String? codBarras;
  final double? precoTabela;
  final double? saldoDisponivel;

  ProductModelList({
    required this.id,
    required this.codigo,
    required this.produto,
    this.tipo,
    this.unidade,
    required this.status,
    this.codBarras,
    this.precoTabela,
    this.saldoDisponivel,
  });

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory ProductModelList.fromJson(Map<String, dynamic> json) {
    final stocks = json['stocks'] as List<dynamic>?;
    double? saldo;
    if (stocks != null && stocks.isNotEmpty) {
      final firstStock = stocks.first as Map<String, dynamic>;
      final val = firstStock['saldo_disponivel'];
      if (val != null) saldo = (val is num) ? val.toDouble() : double.tryParse(val.toString());
    }

    return ProductModelList(
      id: json['id'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      produto: json['produto'] as String? ?? '',
      tipo: json['tipo'] as String?,
      unidade: json['unidade'] as String?,
      status: json['status'] as bool? ?? true,
      codBarras: json['cod_barras'] as String?,
      precoTabela: _parseDouble(json['preco_tabela']),
      saldoDisponivel: saldo ?? _parseDouble(json['saldo_disponivel']),
    );
  }
}
