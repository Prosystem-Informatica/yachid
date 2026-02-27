import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/products/model/product_model.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_nota_fiscal_dto.dart';

class ProductNotaFiscalTab extends StatefulWidget {
  const ProductNotaFiscalTab({
    super.key,
    required this.product,
    required this.isSaving,
    required this.onSave,
  });

  final ProductModel product;
  final bool isSaving;
  final void Function(UpdateProductNotaFiscalDto) onSave;

  @override
  State<ProductNotaFiscalTab> createState() => _ProductNotaFiscalTabState();
}

class _ProductNotaFiscalTabState extends State<ProductNotaFiscalTab> {
  late final TextEditingController _ncmController;
  late final TextEditingController _cestController;
  late final TextEditingController _reducaoPercController;
  late final TextEditingController _origemIcmsController;
  late final TextEditingController _sitTributariaIcmsController;
  late final TextEditingController _cstIbsController;
  late final TextEditingController _classifIbsController;
  late final TextEditingController _cstCbsController;
  late final TextEditingController _classifCbsController;
  late final TextEditingController _classeEnquadramentoIpiController;
  late final TextEditingController _codigoEnquadramentoIpiController;
  late final TextEditingController _aliquotaIpiController;
  late final TextEditingController _sitTributariaIpiController;
  late final TextEditingController _sitTributariaPisController;
  late final TextEditingController _aliquotaPisController;
  late final TextEditingController _sitTributariaCofinsController;
  late final TextEditingController _aliquotaCofinsController;

  @override
  void initState() {
    super.initState();
    final nf = widget.product.notaFiscal;
    _ncmController = TextEditingController(text: nf?.ncm ?? '');
    _cestController = TextEditingController(text: nf?.cest ?? '');
    _reducaoPercController = TextEditingController(
      text: nf?.reducaoPerc?.toString() ?? '',
    );
    _origemIcmsController = TextEditingController(text: nf?.origemIcms ?? '');
    _sitTributariaIcmsController = TextEditingController(
      text: nf?.sitTributariaIcms ?? '',
    );
    _cstIbsController = TextEditingController(text: nf?.cstIbs ?? '');
    _classifIbsController = TextEditingController(
      text: nf?.classificacaoTributariaIbs ?? '',
    );
    _cstCbsController = TextEditingController(text: nf?.cstCbs ?? '');
    _classifCbsController = TextEditingController(
      text: nf?.classificacaoTributariaCbs ?? '',
    );
    _classeEnquadramentoIpiController = TextEditingController(
      text: nf?.classeEnquadramentoIpi ?? '',
    );
    _codigoEnquadramentoIpiController = TextEditingController(
      text: nf?.codigoEnquadramentoIpi ?? '',
    );
    _aliquotaIpiController = TextEditingController(
      text: nf?.aliquotaIpi?.toStringAsFixed(2) ?? '0.00',
    );
    _sitTributariaIpiController = TextEditingController(
      text: nf?.sitTributariaIpi ?? '',
    );
    _sitTributariaPisController = TextEditingController(
      text: nf?.sitTributariaPis ?? '',
    );
    _aliquotaPisController = TextEditingController(
      text: nf?.aliquotaPis?.toStringAsFixed(2) ?? '1.65',
    );
    _sitTributariaCofinsController = TextEditingController(
      text: nf?.sitTributariaCofins ?? '',
    );
    _aliquotaCofinsController = TextEditingController(
      text: nf?.aliquotaCofins?.toStringAsFixed(2) ?? '7.60',
    );
  }

  @override
  void dispose() {
    _ncmController.dispose();
    _cestController.dispose();
    _reducaoPercController.dispose();
    _origemIcmsController.dispose();
    _sitTributariaIcmsController.dispose();
    _cstIbsController.dispose();
    _classifIbsController.dispose();
    _cstCbsController.dispose();
    _classifCbsController.dispose();
    _classeEnquadramentoIpiController.dispose();
    _codigoEnquadramentoIpiController.dispose();
    _aliquotaIpiController.dispose();
    _sitTributariaIpiController.dispose();
    _sitTributariaPisController.dispose();
    _aliquotaPisController.dispose();
    _sitTributariaCofinsController.dispose();
    _aliquotaCofinsController.dispose();
    super.dispose();
  }

  double? _parseDouble(String v) =>
      double.tryParse(v.trim().replaceAll(',', '.'));

  String? _str(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  void _submit() {
    widget.onSave(
      UpdateProductNotaFiscalDto(
        ncm: _str(_ncmController),
        cest: _str(_cestController),
        reducaoPerc: _parseDouble(_reducaoPercController.text),
        origemIcms: _str(_origemIcmsController),
        sitTributariaIcms: _str(_sitTributariaIcmsController),
        cstIbs: _str(_cstIbsController),
        classificacaoTributariaIbs: _str(_classifIbsController),
        cstCbs: _str(_cstCbsController),
        classificacaoTributariaCbs: _str(_classifCbsController),
        classeEnquadramentoIpi: _str(_classeEnquadramentoIpiController),
        codigoEnquadramentoIpi: _str(_codigoEnquadramentoIpiController),
        aliquotaIpi: _parseDouble(_aliquotaIpiController.text),
        sitTributariaIpi: _str(_sitTributariaIpiController),
        sitTributariaPis: _str(_sitTributariaPisController),
        aliquotaPis: _parseDouble(_aliquotaPisController.text),
        sitTributariaCofins: _str(_sitTributariaCofinsController),
        aliquotaCofins: _parseDouble(_aliquotaCofinsController.text),
      ),
    );
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection(
            icon: Icons.receipt_long_outlined,
            title: 'Classificação Fiscal',
            children: [
              _field(_ncmController, 'NCM', width: 160),
              _field(_cestController, 'CEST', width: 160),
              _field(
                _reducaoPercController,
                'Redução (%)',
                width: 140,
                numeric: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            icon: Icons.account_balance_outlined,
            title: 'Informações de ICMS',
            children: [
              _field(_origemIcmsController, 'Origem ICMS', width: 280),
              _field(
                _sitTributariaIcmsController,
                'Situação Tributária',
                width: 320,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            icon: Icons.calculate_outlined,
            title: 'IBS / CBS',
            children: [
              _field(_cstIbsController, 'CST IBS', width: 200),
              _field(
                _classifIbsController,
                'Classificação Tributária IBS',
                width: 220,
              ),
              _field(_cstCbsController, 'CST CBS', width: 200),
              _field(
                _classifCbsController,
                'Classificação Tributária CBS',
                width: 220,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            icon: Icons.inventory_outlined,
            title: 'Informações de IPI',
            children: [
              _field(
                _classeEnquadramentoIpiController,
                'Classe Enquadramento',
                width: 180,
              ),
              _field(
                _codigoEnquadramentoIpiController,
                'Código de Enquadramento',
                width: 200,
              ),
              _field(
                _aliquotaIpiController,
                'Alíquota (%)',
                width: 130,
                numeric: true,
              ),
              _field(
                _sitTributariaIpiController,
                'Situação Tributária',
                width: 320,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            icon: Icons.percent_outlined,
            title: 'Informações de PIS',
            children: [
              _field(
                _sitTributariaPisController,
                'Situação Tributária',
                width: 400,
              ),
              _field(
                _aliquotaPisController,
                'Alíquota (%)',
                width: 130,
                numeric: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSection(
            icon: Icons.percent_outlined,
            title: 'Informações de COFINS',
            children: [
              _field(
                _sitTributariaCofinsController,
                'Situação Tributária',
                width: 400,
              ),
              _field(
                _aliquotaCofinsController,
                'Alíquota (%)',
                width: 130,
                numeric: true,
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
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: widget.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Salvar Nota Fiscal'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    double width = 180,
    bool numeric = false,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        decoration: _dec(label),
        keyboardType: numeric ? TextInputType.number : TextInputType.text,
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray300.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: AppColors.primaryColor),
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Wrap(spacing: 16, runSpacing: 16, children: children),
          ),
        ],
      ),
    );
  }
}
