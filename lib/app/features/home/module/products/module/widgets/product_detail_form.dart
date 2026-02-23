import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/product_model.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_stock_dto.dart';
import 'package:yachid/app/features/home/module/products/module/widgets/product_stock_form_card.dart';

class ProductDetailForm extends StatefulWidget {
  final ProductModel product;
  final bool isSaving;
  final bool isSavingStock;
  final void Function(UpdateProductDto) onSave;
  final void Function(CreateProductStockDto) onCreateStock;
  final void Function(String stockId, UpdateProductStockDto) onUpdateStock;

  const ProductDetailForm({
    super.key,
    required this.product,
    required this.isSaving,
    this.isSavingStock = false,
    required this.onSave,
    required this.onCreateStock,
    required this.onUpdateStock,
  });

  @override
  State<ProductDetailForm> createState() => _ProductDetailFormState();
}

class _ProductDetailFormState extends State<ProductDetailForm> {
  late TextEditingController _codigoController;
  late TextEditingController _ultimoCodigoController;
  late TextEditingController _penultimoCodigoController;
  late TextEditingController _produtoController;
  late TextEditingController _linhaController;
  late TextEditingController _codBarrasController;
  late TextEditingController _tipoController;
  late TextEditingController _familiaController;
  late TextEditingController _unidadeController;
  late TextEditingController _fabricanteController;
  late TextEditingController _gramaturaController;
  late TextEditingController _codTributarioController;
  late TextEditingController _embalagemController;
  late TextEditingController _classificacaoController;
  late TextEditingController _pesoBrutoController;
  late TextEditingController _pesoLiquidoController;
  late TextEditingController _pesoProdutoController;
  late TextEditingController _validadeController;
  late TextEditingController _custoCalculadoController;
  late TextEditingController _custoDigitadoController;
  late TextEditingController _custoMedioController;
  late TextEditingController _ultimoCustoController;
  late TextEditingController _penultimoCustoController;
  late TextEditingController _antPenCustoController;
  late TextEditingController _precoMin7Controller;
  late TextEditingController _precoMin12Controller;
  late TextEditingController _precoMin18Controller;
  late TextEditingController _precoTabelaController;
  late TextEditingController _precoAnteriorController;

  late bool _status;
  late bool _calculaIcms;
  late bool _produtoAvulso;
  late String _tipoCusto;

  @override
  void initState() {
    super.initState();
    _initFromProduct(widget.product);
  }

  @override
  void didUpdateWidget(ProductDetailForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _initFromProduct(widget.product);
    }
  }

  void _initFromProduct(ProductModel p) {
    _codigoController = TextEditingController(text: p.codigo);
    _ultimoCodigoController = TextEditingController(text: p.ultimoCodigo ?? '');
    _penultimoCodigoController = TextEditingController(text: p.penultimoCodigo ?? '');
    _produtoController = TextEditingController(text: p.produto);
    _linhaController = TextEditingController(text: p.linha ?? '');
    _codBarrasController = TextEditingController(text: p.codBarras ?? '');
    _tipoController = TextEditingController(text: p.tipo ?? '');
    _familiaController = TextEditingController(text: p.familia ?? '');
    _unidadeController = TextEditingController(text: p.unidade ?? '');
    _fabricanteController = TextEditingController(text: p.fabricante ?? '');
    _gramaturaController = TextEditingController(text: p.gramatura ?? '');
    _codTributarioController = TextEditingController(text: p.codTributario ?? '');
    _embalagemController = TextEditingController(text: p.embalagem ?? '');
    _classificacaoController = TextEditingController(text: p.classificacao ?? '');
    _pesoBrutoController = TextEditingController(
        text: p.pesoBruto?.toString() ?? '');
    _pesoLiquidoController = TextEditingController(
        text: p.pesoLiquido?.toString() ?? '');
    _pesoProdutoController = TextEditingController(
        text: p.pesoProduto?.toString() ?? '');
    _validadeController = TextEditingController(
        text: p.validade?.toString() ?? '');
    _custoCalculadoController = TextEditingController(
        text: p.custoCalculado?.toString() ?? '');
    _custoDigitadoController = TextEditingController(
        text: p.custoDigitado?.toString() ?? '');
    _custoMedioController = TextEditingController(
        text: p.custoMedio?.toString() ?? '');
    _ultimoCustoController = TextEditingController(
        text: p.ultimoCusto?.toString() ?? '');
    _penultimoCustoController = TextEditingController(
        text: p.penultimoCusto?.toString() ?? '');
    _antPenCustoController = TextEditingController(
        text: p.antPenCusto?.toString() ?? '');
    _precoMin7Controller = TextEditingController(
        text: p.precoMin7?.toString() ?? '');
    _precoMin12Controller = TextEditingController(
        text: p.precoMin12?.toString() ?? '');
    _precoMin18Controller = TextEditingController(
        text: p.precoMin18?.toString() ?? '');
    _precoTabelaController = TextEditingController(
        text: p.precoTabela?.toString() ?? '');
    _precoAnteriorController = TextEditingController(
        text: p.precoAnterior?.toString() ?? '');
    _status = p.status;
    _calculaIcms = p.calculaIcms;
    _produtoAvulso = p.produtoAvulso;
    _tipoCusto = p.tipoCusto;
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _ultimoCodigoController.dispose();
    _penultimoCodigoController.dispose();
    _produtoController.dispose();
    _linhaController.dispose();
    _codBarrasController.dispose();
    _tipoController.dispose();
    _familiaController.dispose();
    _unidadeController.dispose();
    _fabricanteController.dispose();
    _gramaturaController.dispose();
    _codTributarioController.dispose();
    _embalagemController.dispose();
    _classificacaoController.dispose();
    _pesoBrutoController.dispose();
    _pesoLiquidoController.dispose();
    _pesoProdutoController.dispose();
    _validadeController.dispose();
    _custoCalculadoController.dispose();
    _custoDigitadoController.dispose();
    _custoMedioController.dispose();
    _ultimoCustoController.dispose();
    _penultimoCustoController.dispose();
    _antPenCustoController.dispose();
    _precoMin7Controller.dispose();
    _precoMin12Controller.dispose();
    _precoMin18Controller.dispose();
    _precoTabelaController.dispose();
    _precoAnteriorController.dispose();
    super.dispose();
  }

  double? _parseDouble(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return double.tryParse(v.replaceAll(',', '.'));
  }

  int? _parseInt(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return int.tryParse(v);
  }

  void _submit() {
    final dto = UpdateProductDto(
      codigo: _codigoController.text.trim(),
      ultimoCodigo: _ultimoCodigoController.text.trim().isEmpty
          ? null
          : _ultimoCodigoController.text.trim(),
      penultimoCodigo: _penultimoCodigoController.text.trim().isEmpty
          ? null
          : _penultimoCodigoController.text.trim(),
      produto: _produtoController.text.trim(),
      status: _status,
      linha: _linhaController.text.trim().isEmpty
          ? null
          : _linhaController.text.trim(),
      codBarras: _codBarrasController.text.trim().isEmpty
          ? null
          : _codBarrasController.text.trim(),
      tipo: _tipoController.text.trim().isEmpty ? null : _tipoController.text.trim(),
      familia: _familiaController.text.trim().isEmpty
          ? null
          : _familiaController.text.trim(),
      unidade: _unidadeController.text.trim().isEmpty
          ? null
          : _unidadeController.text.trim(),
      fabricante: _fabricanteController.text.trim().isEmpty
          ? null
          : _fabricanteController.text.trim(),
      gramatura: _gramaturaController.text.trim().isEmpty
          ? null
          : _gramaturaController.text.trim(),
      calculaIcms: _calculaIcms,
      codTributario: _codTributarioController.text.trim().isEmpty
          ? null
          : _codTributarioController.text.trim(),
      pesoBruto: _parseDouble(_pesoBrutoController.text),
      pesoLiquido: _parseDouble(_pesoLiquidoController.text),
      pesoProduto: _parseDouble(_pesoProdutoController.text),
      embalagem: _embalagemController.text.trim().isEmpty
          ? null
          : _embalagemController.text.trim(),
      classificacao: _classificacaoController.text.trim().isEmpty
          ? null
          : _classificacaoController.text.trim(),
      validade: _parseInt(_validadeController.text),
      produtoAvulso: _produtoAvulso,
      tipoCusto: _tipoCusto,
      custoCalculado: _parseDouble(_custoCalculadoController.text),
      custoDigitado: _parseDouble(_custoDigitadoController.text),
      custoMedio: _parseDouble(_custoMedioController.text),
      ultimoCusto: _parseDouble(_ultimoCustoController.text),
      penultimoCusto: _parseDouble(_penultimoCustoController.text),
      antPenCusto: _parseDouble(_antPenCustoController.text),
      precoMin7: _parseDouble(_precoMin7Controller.text),
      precoMin12: _parseDouble(_precoMin12Controller.text),
      precoMin18: _parseDouble(_precoMin18Controller.text),
      precoTabela: _parseDouble(_precoTabelaController.text),
      precoAnterior: _parseDouble(_precoAnteriorController.text),
    );
    widget.onSave(dto);
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
      );

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.gray800,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 120,
      ),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Editar Produto',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Dados do Produto'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
                  SizedBox(
                    width: 220,
                    child: TextFormField(
                      controller: _codigoController,
                      decoration: _dec('Código'),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      controller: _ultimoCodigoController,
                      decoration: _dec('Último Código'),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      controller: _penultimoCodigoController,
                      decoration: _dec('Penúltimo Código'),
                    ),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextFormField(
                      controller: _produtoController,
                      decoration: _dec('Produto'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: _linhaController,
                      decoration: _dec('Linha'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: _codBarrasController,
                      decoration: _dec('Cód. Barras'),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      controller: _tipoController,
                      decoration: _dec('Tipo'),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      controller: _familiaController,
                      decoration: _dec('Família'),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: _unidadeController,
                      decoration: _dec('Unidade'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: _fabricanteController,
                      decoration: _dec('Fabricante'),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: TextFormField(
                      controller: _gramaturaController,
                      decoration: _dec('Gramatura'),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: _codTributarioController,
                      decoration: _dec('Cód. Tributário'),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      controller: _embalagemController,
                      decoration: _dec('Embalagem'),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: _classificacaoController,
                      decoration: _dec('Classificação'),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _pesoBrutoController,
                      decoration: _dec('Peso Bruto'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _pesoLiquidoController,
                      decoration: _dec('Peso Líquido'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _pesoProdutoController,
                      decoration: _dec('Peso Produto'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _validadeController,
                      decoration: _dec('Validade'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 28),
          _sectionTitle('Custos e Preços'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _custoCalculadoController,
                  decoration: _dec('Custo Calculado'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _custoDigitadoController,
                  decoration: _dec('Custo Digitado'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _custoMedioController,
                  decoration: _dec('Custo Médio'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _ultimoCustoController,
                  decoration: _dec('Último Custo'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _penultimoCustoController,
                  decoration: _dec('Penúltimo Custo'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _antPenCustoController,
                  decoration: _dec('Ant. Pen. Custo'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _precoMin7Controller,
                  decoration: _dec('Preço Mín. 7%'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _precoMin12Controller,
                  decoration: _dec('Preço Mín. 12%'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _precoMin18Controller,
                  decoration: _dec('Preço Mín. 18%'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _precoTabelaController,
                  decoration: _dec('Preço Tabela'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _precoAnteriorController,
                  decoration: _dec('Preço Anterior'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _status,
                onChanged: (v) => setState(() => _status = v ?? true),
              ),
              const Text('Ativo'),
              const SizedBox(width: 24),
              Checkbox(
                value: _calculaIcms,
                onChanged: (v) => setState(() => _calculaIcms = v ?? false),
              ),
              const Text('Calcula ICMS'),
              const SizedBox(width: 24),
              Checkbox(
                value: _produtoAvulso,
                onChanged: (v) => setState(() => _produtoAvulso = v ?? false),
              ),
              const Text('Produto Avulso'),
              const SizedBox(width: 24),
              DropdownButton<String>(
                value: _tipoCusto,
                items: ['CALCULADO', 'DIGITADO']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _tipoCusto = v ?? 'CALCULADO'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _sectionTitle('Estoque'),
          const SizedBox(height: 12),
          if (widget.product.stocks != null &&
              widget.product.stocks!.isNotEmpty) ...[
            ...widget.product.stocks!.map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProductStockFormCard(
                  stock: s,
                  isSaving: widget.isSavingStock,
                  onCreate: (_) {},
                  onUpdate: (stockId, dto) =>
                      widget.onUpdateStock(stockId, dto),
                ),
              ),
            ),
          ] else ...[
            ProductStockFormCard(
              isSaving: widget.isSavingStock,
              onCreate: widget.onCreateStock,
              onUpdate: (_, __) {},
            ),
          ],
          const SizedBox(height: 32),
          Center(
            child: FilledButton.icon(
            onPressed: widget.isSaving ? null : _submit,
            icon: widget.isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save, size: 20),
            label: Text(widget.isSaving ? 'Salvando...' : 'Salvar alterações'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
