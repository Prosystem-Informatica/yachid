import 'package:flutter/material.dart';
import 'package:yachid/app/core/helpers/date_helpers.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/product_model.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_stock_dto.dart';

class ProductStockFormCard extends StatefulWidget {
  final ProductStockModel? stock;
  final bool isSaving;
  final void Function(CreateProductStockDto) onCreate;
  final void Function(String stockId, UpdateProductStockDto) onUpdate;

  const ProductStockFormCard({
    super.key,
    this.stock,
    required this.isSaving,
    required this.onCreate,
    required this.onUpdate,
  });

  @override
  State<ProductStockFormCard> createState() => _ProductStockFormCardState();
}

class _ProductStockFormCardState extends State<ProductStockFormCard> {
  late TextEditingController _saldoController;
  late TextEditingController _empenhoController;
  late TextEditingController _saldoEmpresaController;
  late TextEditingController _empenhoEmpresaController;
  late TextEditingController _prodProgramadaController;
  late TextEditingController _dataUltVendaController;
  late TextEditingController _valorUltVendaController;
  late TextEditingController _ruaController;
  late TextEditingController _prateleirasController;
  late TextEditingController _estoqueMinController;
  late TextEditingController _estoqueMaxController;

  bool get _isEdit => widget.stock != null;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  @override
  void didUpdateWidget(ProductStockFormCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stock?.id != widget.stock?.id) {
      _disposeControllers();
      _initControllers();
    }
  }

  void _disposeControllers() {
    _saldoController.dispose();
    _empenhoController.dispose();
    _saldoEmpresaController.dispose();
    _empenhoEmpresaController.dispose();
    _prodProgramadaController.dispose();
    _dataUltVendaController.dispose();
    _valorUltVendaController.dispose();
    _ruaController.dispose();
    _prateleirasController.dispose();
    _estoqueMinController.dispose();
    _estoqueMaxController.dispose();
  }

  void _initControllers() {
    final s = widget.stock;
    final addr = s?.address;
    _saldoController = TextEditingController(
      text: s?.saldoDisponivel.toString() ?? '',
    );
    _empenhoController = TextEditingController(
      text: s?.empenho.toString() ?? '',
    );
    _saldoEmpresaController = TextEditingController(
      text: s?.saldoEmpresa.toString() ?? '',
    );
    _empenhoEmpresaController = TextEditingController(
      text: s?.empenhoEmpresa.toString() ?? '',
    );
    _prodProgramadaController = TextEditingController(
      text: s?.prodProgramada.toString() ?? '',
    );
    _dataUltVendaController = TextEditingController(
      text: s?.dataUltVenda != null
          ? formatIsoDateForDisplay(s!.dataUltVenda)
          : '',
    );
    _valorUltVendaController = TextEditingController(
      text: s?.valorUltVenda?.toString() ?? '',
    );
    _ruaController = TextEditingController(text: addr?.rua ?? '');
    _prateleirasController = TextEditingController(
      text: addr?.prateleiras ?? '',
    );
    _estoqueMinController = TextEditingController(
      text: addr?.estoqueMinimo.toString() ?? '',
    );
    _estoqueMaxController = TextEditingController(
      text: addr?.estoqueMaximo.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  double? _parseDouble(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return double.tryParse(v.replaceAll(',', '.'));
  }

  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    isDense: true,
  );

  void _submit() {
    if (_isEdit) {
      widget.onUpdate(
        widget.stock!.id,
        UpdateProductStockDto(
          saldoDisponivel: _parseDouble(_saldoController.text),
          empenho: _parseDouble(_empenhoController.text),
          saldoEmpresa: _parseDouble(_saldoEmpresaController.text),
          empenhoEmpresa: _parseDouble(_empenhoEmpresaController.text),
          prodProgramada: _parseDouble(_prodProgramadaController.text),
          dataUltVenda: toIso8601DateString(_dataUltVendaController.text.trim()),
          valorUltVenda: _parseDouble(_valorUltVendaController.text),
          address: UpdateStockAddressDto(
            rua:
                _ruaController.text.trim().isEmpty
                    ? null
                    : _ruaController.text.trim(),
            prateleiras:
                _prateleirasController.text.trim().isEmpty
                    ? null
                    : _prateleirasController.text.trim(),
            estoqueMinimo: _parseDouble(_estoqueMinController.text),
            estoqueMaximo: _parseDouble(_estoqueMaxController.text),
          ),
        ),
      );
    } else {
      widget.onCreate(
        CreateProductStockDto(
          saldoDisponivel: _parseDouble(_saldoController.text) ?? 0,
          empenho: _parseDouble(_empenhoController.text) ?? 0,
          saldoEmpresa: _parseDouble(_saldoEmpresaController.text) ?? 0,
          empenhoEmpresa: _parseDouble(_empenhoEmpresaController.text) ?? 0,
          prodProgramada: _parseDouble(_prodProgramadaController.text) ?? 0,
          dataUltVenda: toIso8601DateString(_dataUltVendaController.text.trim()),
          valorUltVenda: _parseDouble(_valorUltVendaController.text),
          address:
              (_ruaController.text.trim().isNotEmpty &&
                      _prateleirasController.text.trim().isNotEmpty)
                  ? CreateStockAddressDto(
                    rua: _ruaController.text.trim(),
                    prateleiras: _prateleirasController.text.trim(),
                    estoqueMinimo:
                        _parseDouble(_estoqueMinController.text) ?? 0,
                    estoqueMaximo:
                        _parseDouble(_estoqueMaxController.text) ?? 0,
                  )
                  : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.gray300.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEdit ? 'Editar estoque' : 'Cadastrar estoque',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray800,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              spacing: 16,
              children: [
                Row(
                  spacing: 26,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _saldoController,
                        decoration: _dec('Saldo Disponível'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _empenhoController,
                        decoration: _dec('Empenho'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _saldoEmpresaController,
                        decoration: _dec('Saldo Empresa'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 26,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _empenhoEmpresaController,
                        decoration: _dec('Empenho Empresa'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _prodProgramadaController,
                        decoration: _dec('Prod. Programada'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _dataUltVendaController,
                        decoration: _dec('Data Última Venda', hint: 'dd/MM/yyyy'),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _valorUltVendaController,
                        decoration: _dec('Valor Última Venda'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 26,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ruaController,
                        decoration: _dec('Rua'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _prateleirasController,
                        decoration: _dec('Prateleiras'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _estoqueMinController,
                        decoration: _dec('Estoque Mín'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _estoqueMaxController,
                        decoration: _dec('Estoque Máx'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: widget.isSaving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
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
                      : Text(
                        _isEdit ? 'Atualizar estoque' : 'Cadastrar estoque',
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
