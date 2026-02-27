import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_dto.dart';

import '../../../../../core/widgets/widgets.dart';

class ProductRegisterCard extends StatefulWidget {
  const ProductRegisterCard({super.key, this.onSaved, this.onCancel});

  final ValueChanged<CreateProductDto>? onSaved;
  final VoidCallback? onCancel;

  @override
  State<ProductRegisterCard> createState() => _ProductRegisterCardState();
}

class _ProductRegisterCardState extends State<ProductRegisterCard> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _ultimoCodigoController = TextEditingController();
  final _penultimoCodigoController = TextEditingController();
  final _produtoController = TextEditingController();
  final _linhaController = TextEditingController();
  final _codBarrasController = TextEditingController();
  final _tipoController = TextEditingController();
  final _familiaController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _fabricanteController = TextEditingController();
  final _gramaturaController = TextEditingController();
  final _codTributarioController = TextEditingController();
  final _embalagemController = TextEditingController();
  final _classificacaoController = TextEditingController();
  final _pesoBrutoController = TextEditingController();
  final _pesoLiquidoController = TextEditingController();
  final _pesoProdutoController = TextEditingController();
  final _validadeController = TextEditingController();
  final _custoCalculadoController = TextEditingController();
  final _custoDigitadoController = TextEditingController();
  final _custoMedioController = TextEditingController();
  final _ultimoCustoController = TextEditingController();
  final _penultimoCustoController = TextEditingController();
  final _antPenCustoController = TextEditingController();
  final _precoMin7Controller = TextEditingController();
  final _precoMin12Controller = TextEditingController();
  final _precoMin18Controller = TextEditingController();
  final _precoTabelaController = TextEditingController();
  final _precoAnteriorController = TextEditingController();
  final _ruaController = TextEditingController();
  final _prateleirasController = TextEditingController();
  final _estoqueMinController = TextEditingController(text: '0');
  final _estoqueMaxController = TextEditingController(text: '0');

  bool _status = true;
  bool _calculaIcms = false;
  bool _produtoAvulso = false;
  String _tipoCusto = 'CALCULADO';
  bool _includeStock = false;

  final Map<String, bool> _openSections = {
    'dados': true,
    'pesos': false,
    'custos': false,
    'estoque': false,
  };

  void _toggle(String key) {
    setState(() => _openSections[key] = !_openSections[key]!);
  }

  InputDecoration _dec(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
    );
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
    if (!_formKey.currentState!.validate()) return;

    CreateProductStockDto? stock;
    if (_includeStock) {
      stock = CreateProductStockDto(
        address: CreateStockAddressDto(
          rua: _ruaController.text.trim(),
          prateleiras: _prateleirasController.text.trim(),
          estoqueMinimo: _parseDouble(_estoqueMinController.text) ?? 0,
          estoqueMaximo: _parseDouble(_estoqueMaxController.text) ?? 0,
        ),
      );
    }

    final dto = CreateProductDto(
      codigo: _codigoController.text.trim(),
      ultimoCodigo:
          _ultimoCodigoController.text.trim().isEmpty
              ? null
              : _ultimoCodigoController.text.trim(),
      penultimoCodigo:
          _penultimoCodigoController.text.trim().isEmpty
              ? null
              : _penultimoCodigoController.text.trim(),
      produto: _produtoController.text.trim(),
      status: _status,
      linha:
          _linhaController.text.trim().isEmpty
              ? null
              : _linhaController.text.trim(),
      codBarras:
          _codBarrasController.text.trim().isEmpty
              ? null
              : _codBarrasController.text.trim(),
      tipo:
          _tipoController.text.trim().isEmpty
              ? null
              : _tipoController.text.trim(),
      familia:
          _familiaController.text.trim().isEmpty
              ? null
              : _familiaController.text.trim(),
      unidade:
          _unidadeController.text.trim().isEmpty
              ? null
              : _unidadeController.text.trim(),
      fabricante:
          _fabricanteController.text.trim().isEmpty
              ? null
              : _fabricanteController.text.trim(),
      gramatura:
          _gramaturaController.text.trim().isEmpty
              ? null
              : _gramaturaController.text.trim(),
      calculaIcms: _calculaIcms,
      codTributario:
          _codTributarioController.text.trim().isEmpty
              ? null
              : _codTributarioController.text.trim(),
      pesoBruto: _parseDouble(_pesoBrutoController.text),
      pesoLiquido: _parseDouble(_pesoLiquidoController.text),
      pesoProduto: _parseDouble(_pesoProdutoController.text),
      embalagem:
          _embalagemController.text.trim().isEmpty
              ? null
              : _embalagemController.text.trim(),
      classificacao:
          _classificacaoController.text.trim().isEmpty
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
      stock: stock,
    );

    widget.onSaved?.call(dto);
    _clearForm();
  }

  void _clearForm() {
    _codigoController.clear();
    _ultimoCodigoController.clear();
    _penultimoCodigoController.clear();
    _produtoController.clear();
    _linhaController.clear();
    _codBarrasController.clear();
    _tipoController.clear();
    _familiaController.clear();
    _unidadeController.clear();
    _fabricanteController.clear();
    _gramaturaController.clear();
    _codTributarioController.clear();
    _embalagemController.clear();
    _classificacaoController.clear();
    _pesoBrutoController.clear();
    _pesoLiquidoController.clear();
    _pesoProdutoController.clear();
    _validadeController.clear();
    _custoCalculadoController.clear();
    _custoDigitadoController.clear();
    _custoMedioController.clear();
    _ultimoCustoController.clear();
    _penultimoCustoController.clear();
    _antPenCustoController.clear();
    _precoMin7Controller.clear();
    _precoMin12Controller.clear();
    _precoMin18Controller.clear();
    _precoTabelaController.clear();
    _precoAnteriorController.clear();
    _ruaController.clear();
    _prateleirasController.clear();
    _estoqueMinController.text = '0';
    _estoqueMaxController.text = '0';
    setState(() {
      _status = true;
      _calculaIcms = false;
      _produtoAvulso = false;
      _tipoCusto = 'CALCULADO';
      _includeStock = false;
    });
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
    _ruaController.dispose();
    _prateleirasController.dispose();
    _estoqueMinController.dispose();
    _estoqueMaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 16),
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
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    sectionDropdown(
                      keyName: 'dados',
                      title: 'Dados do Produto',
                      openSections: _openSections,
                      toggle: _toggle,
                      children: [
                        const SizedBox(height: 12),
                        _buildFormRow([
                          _field(
                            180,
                            TextFormField(
                              controller: _codigoController,
                              decoration: _dec('Código *'),
                              validator:
                                  (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'Obrigatório'
                                          : null,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _ultimoCodigoController,
                              decoration: _dec('Último Código'),
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _penultimoCodigoController,
                              decoration: _dec('Penúltimo Código'),
                            ),
                          ),
                          _field(
                            320,
                            TextFormField(
                              controller: _produtoController,
                              decoration: _dec('Produto *'),
                              validator:
                                  (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'Obrigatório'
                                          : null,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _linhaController,
                              decoration: _dec('Linha'),
                            ),
                          ),
                          _field(
                            160,
                            TextFormField(
                              controller: _codBarrasController,
                              decoration: _dec('Cód. Barras'),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buildFormRow([
                          _field(
                            140,
                            TextFormField(
                              controller: _tipoController,
                              decoration: _dec('Tipo'),
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _familiaController,
                              decoration: _dec('Família'),
                            ),
                          ),
                          _field(
                            120,
                            TextFormField(
                              controller: _unidadeController,
                              decoration: _dec('Unidade'),
                            ),
                          ),
                          _field(
                            180,
                            TextFormField(
                              controller: _fabricanteController,
                              decoration: _dec('Fabricante'),
                            ),
                          ),
                          _field(
                            120,
                            TextFormField(
                              controller: _gramaturaController,
                              decoration: _dec('Gramatura'),
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _codTributarioController,
                              decoration: _dec('Cód. Tributário'),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buildFormRow([
                          _field(
                            140,
                            TextFormField(
                              controller: _embalagemController,
                              decoration: _dec('Embalagem'),
                            ),
                          ),
                          _field(
                            180,
                            TextFormField(
                              controller: _classificacaoController,
                              decoration: _dec('Classificação'),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _status,
                                  onChanged:
                                      (v) =>
                                          setState(() => _status = v ?? true),
                                ),
                                const Text('Ativo'),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _calculaIcms,
                                  onChanged:
                                      (v) => setState(
                                        () => _calculaIcms = v ?? false,
                                      ),
                                ),
                                const Text('Calcula ICMS'),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: _produtoAvulso,
                                  onChanged:
                                      (v) => setState(
                                        () => _produtoAvulso = v ?? false,
                                      ),
                                ),
                                const Text('Produto Avulso'),
                              ],
                            ),
                            SizedBox(
                              width: 200,
                              child: DropdownButtonFormField<String>(
                                value: _tipoCusto,
                                decoration: _dec('Tipo Custo'),
                                items:
                                    ['CALCULADO', 'DIGITADO']
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (v) => setState(
                                      () => _tipoCusto = v ?? 'CALCULADO',
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    sectionDropdown(
                      keyName: 'pesos',
                      title: 'Pesos',
                      openSections: _openSections,
                      toggle: _toggle,
                      children: [
                        const SizedBox(height: 12),
                        _buildFormRow([
                          _field(
                            120,
                            TextFormField(
                              controller: _pesoBrutoController,
                              decoration: _dec('Peso Bruto'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            120,
                            TextFormField(
                              controller: _pesoLiquidoController,
                              decoration: _dec('Peso Líquido'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            120,
                            TextFormField(
                              controller: _pesoProdutoController,
                              decoration: _dec('Peso Produto'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            120,
                            TextFormField(
                              controller: _validadeController,
                              decoration: _dec('Validade (dias)'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ]),
                      ],
                    ),
                    sectionDropdown(
                      keyName: 'custos',
                      title: 'Custos e Preços',
                      openSections: _openSections,
                      toggle: _toggle,
                      children: [
                        const SizedBox(height: 12),
                        _buildFormRow([
                          _field(
                            140,
                            TextFormField(
                              controller: _custoCalculadoController,
                              decoration: _dec('Custo Calculado'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _custoDigitadoController,
                              decoration: _dec('Custo Digitado'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _custoMedioController,
                              decoration: _dec('Custo Médio'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _ultimoCustoController,
                              decoration: _dec('Último Custo'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _penultimoCustoController,
                              decoration: _dec('Penúltimo Custo'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _antPenCustoController,
                              decoration: _dec('Ant. Pen. Custo'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        _buildFormRow([
                          _field(
                            140,
                            TextFormField(
                              controller: _precoMin7Controller,
                              decoration: _dec('Preço Mín. 7%'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _precoMin12Controller,
                              decoration: _dec('Preço Mín. 12%'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _precoMin18Controller,
                              decoration: _dec('Preço Mín. 18%'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _precoTabelaController,
                              decoration: _dec('Preço Tabela'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          _field(
                            140,
                            TextFormField(
                              controller: _precoAnteriorController,
                              decoration: _dec('Preço Anterior'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ]),
                      ],
                    ),
                    sectionDropdown(
                      keyName: 'estoque',
                      title: 'Estoque / Endereço',
                      openSections: _openSections,
                      toggle: _toggle,
                      children: [
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          value: _includeStock,
                          onChanged:
                              (v) => setState(() => _includeStock = v ?? false),
                          title: const Text('Incluir endereço de estoque'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (_includeStock) ...[
                          const SizedBox(height: 12),
                          _buildFormRow([
                            _field(
                              200,
                              TextFormField(
                                controller: _ruaController,
                                decoration: _dec('Rua *'),
                                validator:
                                    _includeStock
                                        ? (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Obrigatório'
                                                : null
                                        : null,
                              ),
                            ),
                            _field(
                              180,
                              TextFormField(
                                controller: _prateleirasController,
                                decoration: _dec('Prateleiras *'),
                                validator:
                                    _includeStock
                                        ? (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Obrigatório'
                                                : null
                                        : null,
                              ),
                            ),
                            _field(
                              120,
                              TextFormField(
                                controller: _estoqueMinController,
                                decoration: _dec('Estoque Mín'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            _field(
                              120,
                              TextFormField(
                                controller: _estoqueMaxController,
                                decoration: _dec('Estoque Máx'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ]),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _clearForm();
                            widget.onCancel?.call();
                          },
                          child: const Text('Limpar'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: _submit,
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
                          child: const Text('Cadastrar produto'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
              Icons.add_box_rounded,
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
                  'Novo produto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preencha os campos abaixo para cadastrar um novo produto.',
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

  Widget _buildFormRow(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          Expanded(flex: i == 0 ? 1 : 2, child: children[i]),
        ],
      ],
    );
  }

  Widget _field(double width, Widget child) {
    return SizedBox(width: width, child: child);
  }
}
