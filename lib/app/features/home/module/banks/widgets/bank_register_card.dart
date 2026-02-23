import 'package:flutter/material.dart';
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
  final _codigoController = TextEditingController();
  final _numeroBancoController = TextEditingController();
  final _nomeController = TextEditingController();

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
    _codigoController.text = d.codigo;
    _numeroBancoController.text = d.numeroBanco;
    _nomeController.text = d.nome;
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

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authModel = context.read<AuthBlocCubit>().state.authModel;
    final token = authModel.token ?? '';

    if (_isEditMode) {
      final dto = UpdateBankDto(
        codigo: _codigoController.text.trim(),
        numeroBanco: _numeroBancoController.text.trim(),
        nome: _nomeController.text.trim(),
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
        codigo: _codigoController.text.trim(),
        numeroBanco: _numeroBancoController.text.trim(),
        nome: _nomeController.text.trim(),
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
    _codigoController.clear();
    _numeroBancoController.clear();
    _nomeController.clear();
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _numeroBancoController.dispose();
    _nomeController.dispose();
    super.dispose();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codigoController,
                          decoration: _dec('Código *'),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Obrigatório'
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _numeroBancoController,
                          decoration: _dec('Número Banco *'),
                          validator: (v) =>
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
                          decoration: _dec('Nome *'),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Obrigatório'
                                  : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isLoading
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
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(_isEditMode
                                ? 'Atualizar banco'
                                : 'Cadastrar banco'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
