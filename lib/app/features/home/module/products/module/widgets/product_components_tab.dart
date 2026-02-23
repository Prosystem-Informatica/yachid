import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_component_dto.dart';
import 'package:yachid/app/features/home/module/products/model/product_model.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_cell.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_header.dart';

class ProductComponentsTab extends StatelessWidget {
  const ProductComponentsTab({
    super.key,
    required this.product,
    required this.productId,
    required this.isSaving,
    required this.onCreate,
  });

  final ProductModel product;
  final String productId;
  final bool isSaving;
  final void Function(CreateProductComponentDto) onCreate;

  static const _columns = [
    'Código',
    'Componente',
    'Unidade',
    'Prc Custo',
    'Quantidade',
    'Peso',
    'Total',
  ];

  static const _colWidth = 120.0;

  @override
  Widget build(BuildContext context) {
    final components = product.components ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ComponentRegisterCard(
            productId: productId,
            isSaving: isSaving,
            onCreate: onCreate,
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.06),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        _columns
                            .map(
                              (label) => PartnersTableHeaderCell(
                                label: label,
                                width: _colWidth,
                              ),
                            )
                            .toList(),
                  ),
                ),
                if (components.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Nenhum componente cadastrado.',
                      style: TextStyle(fontSize: 14, color: AppColors.gray600),
                    ),
                  )
                else
                  ...components.asMap().entries.map((entry) {
                    final index = entry.key;
                    final c = entry.value;
                    return Container(
                      key: ValueKey(c.id),
                      decoration: BoxDecoration(
                        color:
                            index.isEven
                                ? Colors.white
                                : AppColors.gray300.withValues(alpha: 0.12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PartnersTableCell(text: c.codigo, width: _colWidth),
                            PartnersTableCell(
                              text: c.componente,
                              width: _colWidth,
                              bold: true,
                            ),
                            PartnersTableCell(
                              text: c.unidade ?? '—',
                              width: _colWidth,
                            ),
                            PartnersTableCell(
                              text: _formatNum(c.prcCusto),
                              width: _colWidth,
                            ),
                            PartnersTableCell(
                              text: _formatNum(c.quantidade),
                              width: _colWidth,
                            ),
                            PartnersTableCell(
                              text: _formatNum(c.peso),
                              width: _colWidth,
                            ),
                            PartnersTableCell(
                              text: _formatNum(c.total),
                              width: _colWidth,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatNum(double v) {
    if (v == 0 && v.toString() == '0.0') return '0,00';
    return v.toStringAsFixed(2).replaceAll('.', ',');
  }
}

class _ComponentRegisterCard extends StatefulWidget {
  final String productId;
  final bool isSaving;
  final void Function(CreateProductComponentDto) onCreate;

  const _ComponentRegisterCard({
    required this.productId,
    required this.isSaving,
    required this.onCreate,
  });

  @override
  State<_ComponentRegisterCard> createState() => _ComponentRegisterCardState();
}

class _ComponentRegisterCardState extends State<_ComponentRegisterCard> {
  final _codigoController = TextEditingController();
  final _componenteController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _prcCustoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _totalController = TextEditingController();

  @override
  void dispose() {
    _codigoController.dispose();
    _componenteController.dispose();
    _unidadeController.dispose();
    _prcCustoController.dispose();
    _quantidadeController.dispose();
    _pesoController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  double? _parseDouble(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return double.tryParse(v.replaceAll(',', '.'));
  }

  InputDecoration _dec(String label) => InputDecoration(
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.gray300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
  );

  void _submit() {
    final codigo = _codigoController.text.trim();
    final componente = _componenteController.text.trim();
    if (codigo.isEmpty || componente.isEmpty) return;

    widget.onCreate(
      CreateProductComponentDto(
        codigo: codigo,
        componente: componente,
        unidade:
            _unidadeController.text.trim().isEmpty
                ? null
                : _unidadeController.text.trim(),
        prcCusto: _parseDouble(_prcCustoController.text),
        quantidade: _parseDouble(_quantidadeController.text),
        peso: _parseDouble(_pesoController.text),
        total: _parseDouble(_totalController.text),
      ),
    );
    _codigoController.clear();
    _componenteController.clear();
    _unidadeController.clear();
    _prcCustoController.clear();
    _quantidadeController.clear();
    _pesoController.clear();
    _totalController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray300.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        controller: _codigoController,
                        decoration: _dec('Código *'),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: _componenteController,
                        decoration: _dec('Componente *'),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _unidadeController,
                        decoration: _dec('Unidade'),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _prcCustoController,
                        decoration: _dec('Prc Custo'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _quantidadeController,
                        decoration: _dec('Quantidade'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _pesoController,
                        decoration: _dec('Peso'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _totalController,
                        decoration: _dec('Total'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: widget.isSaving ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          widget.isSaving
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text('Adicionar componente'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.view_module_rounded,
              size: 24,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Novo componente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preencha os campos abaixo para adicionar um componente ao produto.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
