import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/formatters/input_formatters.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/model/partner_account.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/cubit/partner_statistics_cubit.dart';

class AccountsPayablePage extends StatefulWidget {
  const AccountsPayablePage({
    super.key,
    required this.partnerId,
    this.accountsPayable,
    this.isEditing = false,
    this.onEdit,
    this.onCancelEdit,
  });

  final String partnerId;
  final AccountsPayableModel? accountsPayable;
  final bool isEditing;
  final VoidCallback? onEdit;
  final VoidCallback? onCancelEdit;

  @override
  State<AccountsPayablePage> createState() => _AccountsPayablePageState();
}

class _AccountsPayablePageState extends State<AccountsPayablePage> {
  late TextEditingController _saldoDevedorCtrl;
  late TextEditingController _maiorAtrasoCtrl;
  late TextEditingController _valorMaiorAtrasoCtrl;
  late TextEditingController _valorPrimeiraCompraCtrl;
  late TextEditingController _valorUltimaCompraCtrl;
  late TextEditingController _atrasadasCtrl;
  late TextEditingController _cartorioCtrl;
  late TextEditingController _protestoCtrl;
  late TextEditingController _normalCtrl;
  late TextEditingController _observationCtrl;
  String _maiorFat = '';
  String _primeiraCompra = '';
  String _ultimaCompra = '';
  bool _isSaving = false;

  String _formatCurrency(String v) {
    if (v.isEmpty) return 'R\$ 0,00';
    final c = v.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.');
    if (c.isEmpty) return 'R\$ 0,00';
    final p = c.split('.');
    return 'R\$ ${p[0]},${(p.length > 1 ? p[1].padRight(2, '0').substring(0, 2) : '00')}';
  }

  String _removeCurrency(String t) => t
      .replaceAll('R\$', '')
      .replaceAll(' ', '')
      .replaceAll(RegExp(r'[^\d,.]'), '')
      .replaceAll(',', '.');

  String _fmtDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final d = DateTime.parse(iso);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (_) {
      return iso;
    }
  }

  Future<void> _pickDate(void Function(String) setDate) async {
    final current =
        _maiorFat.isNotEmpty
            ? DateTime.tryParse(_maiorFat)
            : _primeiraCompra.isNotEmpty
            ? DateTime.tryParse(_primeiraCompra)
            : _ultimaCompra.isNotEmpty
            ? DateTime.tryParse(_ultimaCompra)
            : null;
    final p = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (p != null) {
      setState(() => setDate(p.toIso8601String().split('T').first));
    }
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
  );

  @override
  void initState() {
    super.initState();
    _initFrom(widget.accountsPayable);
  }

  @override
  void didUpdateWidget(AccountsPayablePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.accountsPayable != widget.accountsPayable ||
        oldWidget.isEditing != widget.isEditing) {
      _initFrom(widget.accountsPayable);
    }
  }

  void _initFrom(AccountsPayableModel? d) {
    _saldoDevedorCtrl = TextEditingController(
      text: _formatCurrency(d?.saldoDevedor ?? '0'),
    );
    _maiorAtrasoCtrl = TextEditingController(text: d?.maiorAtraso ?? '');
    _valorMaiorAtrasoCtrl = TextEditingController(
      text: _formatCurrency(d?.valorMaiorAtraso ?? '0'),
    );
    _valorPrimeiraCompraCtrl = TextEditingController(
      text: _formatCurrency(d?.valorPrimeiraCompra ?? '0'),
    );
    _valorUltimaCompraCtrl = TextEditingController(
      text: _formatCurrency(d?.valorUltimaCompra ?? '0'),
    );
    _atrasadasCtrl = TextEditingController(text: d?.atrasadas ?? '');
    _cartorioCtrl = TextEditingController(text: d?.cartorio ?? '');
    _protestoCtrl = TextEditingController(text: d?.protesto ?? '');
    _normalCtrl = TextEditingController(text: d?.normal ?? '');
    _observationCtrl = TextEditingController(text: d?.observation ?? '');
    _maiorFat = d?.maiorFat ?? '';
    _primeiraCompra = d?.primeiraCompra ?? '';
    _ultimaCompra = d?.ultimaCompra ?? '';
    if (_maiorFat.isEmpty && _primeiraCompra.isEmpty && _ultimaCompra.isEmpty) {
      final today = DateTime.now().toIso8601String().split('T').first;
      _maiorFat = today;
      _primeiraCompra = today;
      _ultimaCompra = today;
    }
  }

  @override
  void dispose() {
    _saldoDevedorCtrl.dispose();
    _maiorAtrasoCtrl.dispose();
    _valorMaiorAtrasoCtrl.dispose();
    _valorPrimeiraCompraCtrl.dispose();
    _valorUltimaCompraCtrl.dispose();
    _atrasadasCtrl.dispose();
    _cartorioCtrl.dispose();
    _protestoCtrl.dispose();
    _normalCtrl.dispose();
    _observationCtrl.dispose();
    super.dispose();
  }

  AccountsPayableModel _buildModel() => AccountsPayableModel(
    saldoDevedor:
        _removeCurrency(_saldoDevedorCtrl.text).isEmpty
            ? '0'
            : _removeCurrency(_saldoDevedorCtrl.text),
    maiorAtraso: _maiorAtrasoCtrl.text.trim(),
    maiorFat: _maiorFat,
    valorMaiorAtraso:
        _removeCurrency(_valorMaiorAtrasoCtrl.text).isEmpty
            ? '0'
            : _removeCurrency(_valorMaiorAtrasoCtrl.text),
    primeiraCompra: _primeiraCompra,
    valorPrimeiraCompra:
        _removeCurrency(_valorPrimeiraCompraCtrl.text).isEmpty
            ? '0'
            : _removeCurrency(_valorPrimeiraCompraCtrl.text),
    ultimaCompra: _ultimaCompra,
    valorUltimaCompra:
        _removeCurrency(_valorUltimaCompraCtrl.text).isEmpty
            ? '0'
            : _removeCurrency(_valorUltimaCompraCtrl.text),
    atrasadas: _atrasadasCtrl.text.trim(),
    cartorio: _cartorioCtrl.text.trim(),
    protesto: _protestoCtrl.text.trim(),
    normal: _normalCtrl.text.trim(),
    observation: _observationCtrl.text.trim(),
  );

  void _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    final cubit = context.read<PartnerStatisticsCubit>();
    final token = context.read<AuthBlocCubit>().state.authModel.token ?? '';
    if (widget.accountsPayable == null) {
      cubit.createAccountsPayable(
        widget.partnerId,
        _buildModel(),
        token: token,
      );
    } else {
      cubit.updateAccountsPayable(
        widget.partnerId,
        _buildModel(),
        token: token,
      );
    }
    setState(() => _isSaving = false);
    widget.onCancelEdit?.call();
  }

  Widget _dateField(String label, String value, void Function(String) onSet) {
    return InkWell(
      onTap: () => _pickDate(onSet),
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: _dec(label),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _fmtDate(value),
              style: TextStyle(
                fontSize: 16,
                color: value.isEmpty ? AppColors.gray500 : AppColors.gray800,
              ),
            ),
            Icon(Icons.calendar_today, size: 20, color: AppColors.gray600),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasData = widget.accountsPayable != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 160, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SectionHeader(
            trailing: null,
            isEditing: widget.isEditing,
            setIsEditing: (v) {
              if (v) {
                widget.onEdit?.call();
              } else {
                widget.onCancelEdit?.call();
              }
            },
            onEdit: hasData ? (widget.isEditing ? _save : () {}) : null,
            icon: const Icon(Icons.payment),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            title: 'Contas a Pagar',
            description: 'Resumo de contas a pagar com o fornecedor',
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child:
                hasData && !widget.isEditing
                    ? _buildViewMode()
                    : !hasData && !widget.isEditing
                    ? _buildEmptyState()
                    : _buildEditForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.payment, size: 48, color: AppColors.gray500),
          const SizedBox(height: 16),
          Text(
            'Nenhum dado de contas a pagar cadastrado',
            style: TextStyle(fontSize: 16, color: AppColors.gray800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => widget.onEdit?.call(),
            icon: const Icon(Icons.add),
            label: const Text('Cadastrar contas a pagar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _row([
          _field('Saldo Devedor', _saldoDevedorCtrl.text),
          _field('Maior Atraso', _maiorAtrasoCtrl.text),
          _field('Maior Faturamento', _fmtDate(_maiorFat)),
        ]),
        const SizedBox(height: 16),
        _row([
          _field('Valor do Maior Atraso', _valorMaiorAtrasoCtrl.text),
          _field('Primeira Compra', _fmtDate(_primeiraCompra)),
          _field('Valor da Primeira Compra', _valorPrimeiraCompraCtrl.text),
        ]),
        const SizedBox(height: 16),
        _row([
          _field('Última Compra', _fmtDate(_ultimaCompra)),
          _field('Valor da Última Compra', _valorUltimaCompraCtrl.text),
          _field('Atrasadas', _atrasadasCtrl.text),
        ]),
        const SizedBox(height: 16),
        _row([
          _field('Cartório', _cartorioCtrl.text),
          _field('Protesto', _protestoCtrl.text),
          _field('Normal', _normalCtrl.text),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.gray300),
            color: AppColors.gray300.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OBSERVAÇÃO',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  fontFamily: 'Frutiger_bold',
                  color: AppColors.gray600,
                ),
              ),
              Text(
                _observationCtrl.text.isEmpty ? '-' : _observationCtrl.text,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Frutiger',
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _field(String label, String value) =>
      DataField(label: label, value: value);
  Widget _row(List<Widget> children) => Row(
    children:
        children.asMap().entries.map((e) {
          final isLast = e.key == children.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 12),
              child: e.value,
            ),
          );
        }).toList(),
  );

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (ctx, c) {
            final w = c.maxWidth;
            final wide = w > 720;
            if (wide) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _saldoDevedorCtrl,
                          decoration: _dec('Saldo Devedor'),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [CurrencyInputFormatter()],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _maiorAtrasoCtrl,
                          decoration: _dec('Maior Atraso'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dateField(
                          'Maior Faturamento',
                          _maiorFat,
                          (v) => setState(() => _maiorFat = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _valorMaiorAtrasoCtrl,
                          decoration: _dec('Valor do Maior Atraso'),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [CurrencyInputFormatter()],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dateField(
                          'Primeira Compra',
                          _primeiraCompra,
                          (v) => setState(() => _primeiraCompra = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _valorPrimeiraCompraCtrl,
                          decoration: _dec('Valor da Primeira Compra'),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [CurrencyInputFormatter()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _dateField(
                          'Última Compra',
                          _ultimaCompra,
                          (v) => setState(() => _ultimaCompra = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _valorUltimaCompraCtrl,
                          decoration: _dec('Valor da Última Compra'),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [CurrencyInputFormatter()],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _atrasadasCtrl,
                          decoration: _dec('Atrasadas'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cartorioCtrl,
                          decoration: _dec('Cartório'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _protestoCtrl,
                          decoration: _dec('Protesto'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _normalCtrl,
                          decoration: _dec('Normal'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _observationCtrl,
                    decoration: _dec('Observação'),
                    maxLines: 3,
                  ),
                ],
              );
            }
            return Column(
              children: [
                TextFormField(
                  controller: _saldoDevedorCtrl,
                  decoration: _dec('Saldo Devedor'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [CurrencyInputFormatter()],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _maiorAtrasoCtrl,
                  decoration: _dec('Maior Atraso'),
                ),
                const SizedBox(height: 12),
                _dateField(
                  'Maior Faturamento',
                  _maiorFat,
                  (v) => setState(() => _maiorFat = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _valorMaiorAtrasoCtrl,
                  decoration: _dec('Valor do Maior Atraso'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [CurrencyInputFormatter()],
                ),
                const SizedBox(height: 12),
                _dateField(
                  'Primeira Compra',
                  _primeiraCompra,
                  (v) => setState(() => _primeiraCompra = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _valorPrimeiraCompraCtrl,
                  decoration: _dec('Valor da Primeira Compra'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [CurrencyInputFormatter()],
                ),
                const SizedBox(height: 12),
                _dateField(
                  'Última Compra',
                  _ultimaCompra,
                  (v) => setState(() => _ultimaCompra = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _valorUltimaCompraCtrl,
                  decoration: _dec('Valor da Última Compra'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [CurrencyInputFormatter()],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _atrasadasCtrl,
                  decoration: _dec('Atrasadas'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cartorioCtrl,
                  decoration: _dec('Cartório'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _protestoCtrl,
                  decoration: _dec('Protesto'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _normalCtrl,
                  decoration: _dec('Normal'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _observationCtrl,
                  decoration: _dec('Observação'),
                  maxLines: 3,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _isSaving ? null : () => widget.onCancelEdit?.call(),
              child: const Text('Cancelar'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _isSaving ? null : _save,
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
                  _isSaving
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Text('Salvar'),
            ),
          ],
        ),
      ],
    );
  }
}
