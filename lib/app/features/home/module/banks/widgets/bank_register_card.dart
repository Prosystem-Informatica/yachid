import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/banks/cubit/banks_cubit.dart';
import 'package:yachid/app/features/home/module/banks/model/bank_detail.dart';
import 'package:yachid/app/features/home/module/banks/model/create_bank_dto.dart';
import 'package:yachid/app/features/home/module/banks/model/update_bank_dto.dart';

class BankRegisterCard extends StatefulWidget {
  const BankRegisterCard({
    super.key,
    this.bankId,
    this.onSaved,
    this.onUpdated,
    this.onCancel,
  });

  final String? bankId;
  final ValueChanged<CreateBankDto>? onSaved;
  final void Function(String id, UpdateBankDto dto)? onUpdated;
  final VoidCallback? onCancel;

  @override
  State<BankRegisterCard> createState() => _BankRegisterCardState();
}

class _BankRegisterCardState extends State<BankRegisterCard> {
  final _formKey = GlobalKey<FormState>();
  final _numeroBancoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _agenciaNumeroController = TextEditingController();
  final _agenciaDvController = TextEditingController();
  final _contaNumeroController = TextEditingController();
  final _contaDvController = TextEditingController();
  final _codigoCedenteController = TextEditingController();
  final _codigoConvenioController = TextEditingController();
  final _codigoEmpresaController = TextEditingController();
  final _ultimoBoletoController = TextEditingController();
  final _codigoTransmissaoController = TextEditingController();
  final _moraDiariaController = TextEditingController();
  final _carteiraController = TextEditingController();
  final _variacaoCarteiraController = TextEditingController();
  final _multaController = TextEditingController();
  final _diasProtestoController = TextEditingController();
  final _instrucoesBoletoController = TextEditingController();

  LayoutRemessa? _layoutRemessa = LayoutRemessa.cnab240;

  bool _isLoading = false;
  bool _initialLoading = false;

  bool get _isEditMode => widget.bankId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadDetail();
    }
  }

  Future<void> _loadDetail() async {
    setState(() => _initialLoading = true);
    final authModel = context.read<AuthBlocCubit>().state.authModel;
    final detail = await context.read<BanksCubit>().loadBankDetail(
      id: widget.bankId!,
      token: authModel.token ?? '',
    );
    if (!mounted) return;
    setState(() {
      _initialLoading = false;
      if (detail != null) {
        _fillForm(detail);
      }
    });
  }

  void _fillForm(BankDetail d) {
    _numeroBancoController.text = d.numeroBanco;
    _nomeController.text = d.nome;
    _agenciaNumeroController.text = d.agenciaNumero ?? '';
    _agenciaDvController.text = d.agenciaDv ?? '';
    _contaNumeroController.text = d.contaNumero ?? '';
    _contaDvController.text = d.contaDv ?? '';
    _codigoCedenteController.text = d.codigoCedente ?? '';
    _codigoConvenioController.text = d.codigoConvenio ?? '';
    _codigoEmpresaController.text = d.codigoEmpresa ?? '';
    _ultimoBoletoController.text = d.ultimoBoletoEmitido?.toString() ?? '';
    _codigoTransmissaoController.text = d.codigoTransmissao ?? '';
    _moraDiariaController.text = d.moraDiariaPercent?.toString() ?? '';
    _carteiraController.text = d.carteira ?? '';
    _variacaoCarteiraController.text = d.variacaoCarteira ?? '';
    _multaController.text = d.multaPercent?.toString() ?? '';
    _diasProtestoController.text = d.diasProtesto?.toString() ?? '';
    _instrucoesBoletoController.text = d.instrucoesBoleto ?? '';
    _layoutRemessa = d.layoutRemessa ?? LayoutRemessa.cnab240;
  }

  InputDecoration _dec(String label) {
    return InputDecoration(
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
  }

  double? _parseDouble(String v) {
    final t = v.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  int? _parseInt(String v) {
    final t = v.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authModel = context.read<AuthBlocCubit>().state.authModel;
    final token = authModel.token ?? '';

    if (_isEditMode) {
      final dto = UpdateBankDto(
        numeroBanco: _numeroBancoController.text.trim(),
        nome: _nomeController.text.trim(),
        agenciaNumero:
            _agenciaNumeroController.text.trim().isEmpty
                ? null
                : _agenciaNumeroController.text.trim(),
        agenciaDv:
            _agenciaDvController.text.trim().isEmpty
                ? null
                : _agenciaDvController.text.trim(),
        contaNumero:
            _contaNumeroController.text.trim().isEmpty
                ? null
                : _contaNumeroController.text.trim(),
        contaDv:
            _contaDvController.text.trim().isEmpty
                ? null
                : _contaDvController.text.trim(),
        codigoCedente:
            _codigoCedenteController.text.trim().isEmpty
                ? null
                : _codigoCedenteController.text.trim(),
        codigoConvenio:
            _codigoConvenioController.text.trim().isEmpty
                ? null
                : _codigoConvenioController.text.trim(),
        codigoEmpresa:
            _codigoEmpresaController.text.trim().isEmpty
                ? null
                : _codigoEmpresaController.text.trim(),
        ultimoBoletoEmitido: _parseInt(_ultimoBoletoController.text),
        codigoTransmissao:
            _codigoTransmissaoController.text.trim().isEmpty
                ? null
                : _codigoTransmissaoController.text.trim(),
        moraDiariaPercent: _parseDouble(_moraDiariaController.text),
        carteira:
            _carteiraController.text.trim().isEmpty
                ? null
                : _carteiraController.text.trim(),
        variacaoCarteira:
            _variacaoCarteiraController.text.trim().isEmpty
                ? null
                : _variacaoCarteiraController.text.trim(),
        multaPercent: _parseDouble(_multaController.text),
        diasProtesto: _parseInt(_diasProtestoController.text),
        layoutRemessa: _layoutRemessa,
        instrucoesBoleto:
            _instrucoesBoletoController.text.trim().isEmpty
                ? null
                : _instrucoesBoletoController.text.trim(),
      );
      final ok = await context.read<BanksCubit>().updateBank(
        id: widget.bankId!,
        dto: dto,
        token: token,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Banco atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onUpdated?.call(widget.bankId!, dto);
      }
    } else {
      final dto = CreateBankDto(
        numeroBanco: _numeroBancoController.text.trim(),
        nome: _nomeController.text.trim(),
        agenciaNumero:
            _agenciaNumeroController.text.trim().isEmpty
                ? null
                : _agenciaNumeroController.text.trim(),
        agenciaDv:
            _agenciaDvController.text.trim().isEmpty
                ? null
                : _agenciaDvController.text.trim(),
        contaNumero:
            _contaNumeroController.text.trim().isEmpty
                ? null
                : _contaNumeroController.text.trim(),
        contaDv:
            _contaDvController.text.trim().isEmpty
                ? null
                : _contaDvController.text.trim(),
        codigoCedente:
            _codigoCedenteController.text.trim().isEmpty
                ? null
                : _codigoCedenteController.text.trim(),
        codigoConvenio:
            _codigoConvenioController.text.trim().isEmpty
                ? null
                : _codigoConvenioController.text.trim(),
        codigoEmpresa:
            _codigoEmpresaController.text.trim().isEmpty
                ? null
                : _codigoEmpresaController.text.trim(),
        ultimoBoletoEmitido: _parseInt(_ultimoBoletoController.text),
        codigoTransmissao:
            _codigoTransmissaoController.text.trim().isEmpty
                ? null
                : _codigoTransmissaoController.text.trim(),
        moraDiariaPercent: _parseDouble(_moraDiariaController.text),
        carteira:
            _carteiraController.text.trim().isEmpty
                ? null
                : _carteiraController.text.trim(),
        variacaoCarteira:
            _variacaoCarteiraController.text.trim().isEmpty
                ? null
                : _variacaoCarteiraController.text.trim(),
        multaPercent: _parseDouble(_multaController.text),
        diasProtesto: _parseInt(_diasProtestoController.text),
        layoutRemessa: _layoutRemessa,
        instrucoesBoleto:
            _instrucoesBoletoController.text.trim().isEmpty
                ? null
                : _instrucoesBoletoController.text.trim(),
      );

      final ok = await context.read<BanksCubit>().createBank(
        dto: dto,
        token: token,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Banco cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSaved?.call(dto);
        _clearForm();
      }
    }
  }

  void _clearForm() {
    _numeroBancoController.clear();
    _nomeController.clear();
    _agenciaNumeroController.clear();
    _agenciaDvController.clear();
    _contaNumeroController.clear();
    _contaDvController.clear();
    _codigoCedenteController.clear();
    _codigoConvenioController.clear();
    _codigoEmpresaController.clear();
    _ultimoBoletoController.clear();
    _codigoTransmissaoController.clear();
    _moraDiariaController.clear();
    _carteiraController.clear();
    _variacaoCarteiraController.clear();
    _multaController.clear();
    _diasProtestoController.clear();
    _instrucoesBoletoController.clear();
    setState(() => _layoutRemessa = LayoutRemessa.cnab240);
  }

  @override
  void dispose() {
    _numeroBancoController.dispose();
    _nomeController.dispose();
    _agenciaNumeroController.dispose();
    _agenciaDvController.dispose();
    _contaNumeroController.dispose();
    _contaDvController.dispose();
    _codigoCedenteController.dispose();
    _codigoConvenioController.dispose();
    _codigoEmpresaController.dispose();
    _ultimoBoletoController.dispose();
    _codigoTransmissaoController.dispose();
    _moraDiariaController.dispose();
    _carteiraController.dispose();
    _variacaoCarteiraController.dispose();
    _multaController.dispose();
    _diasProtestoController.dispose();
    _instrucoesBoletoController.dispose();
    super.dispose();
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.gray700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray300.withValues(alpha: 0.8)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

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
          Padding(
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
                    _isEditMode ? Icons.edit : Icons.account_balance,
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
                        _isEditMode ? 'Editar banco' : 'Novo banco',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isEditMode
                            ? 'Altere os dados e salve para atualizar.'
                            : 'Preencha os campos para cadastrar um novo banco.',
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
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _numeroBancoController,
                            decoration: _dec('Nº Banco *'),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator:
                                (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Obrigatório'
                                        : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _nomeController,
                            decoration: _dec('Banco (Nome) *'),
                            validator:
                                (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Obrigatório'
                                        : null,
                          ),
                        ),
                      ],
                    ),
                    _sectionTitle('Conta e Agência'),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _agenciaNumeroController,
                            decoration: _dec('Agência (número)'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _agenciaDvController,
                            decoration: _dec('Digito'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _contaNumeroController,
                            decoration: _dec('Conta (número)'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _contaDvController,
                            decoration: _dec('Digito'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                    _sectionTitle('Códigos de Convênio'),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _codigoCedenteController,
                            decoration: _dec('Código Cedente'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _codigoConvenioController,
                            decoration: _dec('Código Convênio'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _codigoEmpresaController,
                            decoration: _dec('Código Empresa'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ultimoBoletoController,
                            decoration: _dec('Últ. Boleto Emitido'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _codigoTransmissaoController,
                            decoration: _dec('Código Transmissão'),
                          ),
                        ),
                      ],
                    ),
                    _sectionTitle('Configurações de Boleto'),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _moraDiariaController,
                            decoration: _dec('Mora Diária %'),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d,.]'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _multaController,
                            decoration: _dec('Multa %'),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d,.]'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _diasProtestoController,
                            decoration: _dec('Dias Protesto'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _carteiraController,
                            decoration: _dec('Carteira'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _variacaoCarteiraController,
                            decoration: _dec('Variação Carteira / Complemento'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<LayoutRemessa>(
                      value: _layoutRemessa ?? LayoutRemessa.cnab240,
                      decoration: _dec('Layout Remessa'),
                      items: const [
                        DropdownMenuItem(
                          value: LayoutRemessa.cnab240,
                          child: Text('CNAB 240'),
                        ),
                        DropdownMenuItem(
                          value: LayoutRemessa.cnab400,
                          child: Text('CNAB 400'),
                        ),
                      ],
                      onChanged:
                          (v) => setState(
                            () => _layoutRemessa = v ?? LayoutRemessa.cnab240,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _instrucoesBoletoController,
                      decoration: _dec('Instruções Boleto'),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    _clearForm();
                                    widget.onCancel?.call();
                                  },
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: _isLoading ? null : _submit,
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
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    _isEditMode
                                        ? 'Atualizar banco'
                                        : 'Cadastrar banco',
                                  ),
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
}
