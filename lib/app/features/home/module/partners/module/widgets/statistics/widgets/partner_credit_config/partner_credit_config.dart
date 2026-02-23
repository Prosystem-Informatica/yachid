import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/model/partner_account.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/cubit/partner_statistics_cubit.dart';

class PartnerCreditConfigPage extends StatefulWidget {
  const PartnerCreditConfigPage({
    super.key,
    required this.partnerId,
    this.partnerCreditConfig,
    this.isEditing = false,
    this.onEdit,
    this.onCancelEdit,
  });

  final String partnerId;
  final PartnerCreditConfig? partnerCreditConfig;
  final bool isEditing;
  final VoidCallback? onEdit;
  final VoidCallback? onCancelEdit;

  @override
  State<PartnerCreditConfigPage> createState() =>
      _PartnerCreditConfigPageState();
}

class _PartnerCreditConfigPageState extends State<PartnerCreditConfigPage> {
  late TextEditingController _creditController;
  late TextEditingController _dateController;
  late bool _serasaCheck;
  late bool _newOrder;
  late bool _orderRelease;
  late bool _nfeIssuance;
  late bool _creditAnalysis;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initFromConfig(widget.partnerCreditConfig);
  }

  @override
  void didUpdateWidget(PartnerCreditConfigPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.partnerCreditConfig != widget.partnerCreditConfig ||
        oldWidget.isEditing != widget.isEditing) {
      _initFromConfig(widget.partnerCreditConfig);
    }
  }

  void _initFromConfig(PartnerCreditConfig? config) {
    _creditController = TextEditingController(text: config?.creditValue ?? '0');
    _dateController = TextEditingController(
      text: config?.date ?? DateTime.now().toIso8601String().split('T').first,
    );
    _serasaCheck = config?.serasaCheck ?? false;
    _newOrder = config?.newOrder ?? false;
    _orderRelease = config?.orderRelease ?? false;
    _nfeIssuance = config?.nfeIssuance ?? false;
    _creditAnalysis = config?.creditAnalysis ?? false;
  }

  @override
  void dispose() {
    _creditController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  PartnerCreditConfig _buildConfigFromForm() {
    return PartnerCreditConfig(
      creditValue:
          _creditController.text.trim().isEmpty
              ? '0'
              : _creditController.text.trim(),
      serasaCheck: _serasaCheck,
      date: _dateController.text.trim(),
      newOrder: _newOrder,
      orderRelease: _orderRelease,
      nfeIssuance: _nfeIssuance,
      creditAnalysis: _creditAnalysis,
    );
  }

  void _handleSave() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final cubit = context.read<PartnerStatisticsCubit>();
    final token = context.read<AuthBlocCubit>().state.authModel.token ?? '';

    final config = _buildConfigFromForm();

    if (widget.partnerCreditConfig == null) {
      cubit.createPartnerCreditConfig(widget.partnerId, config, token: token);
    } else {
      cubit.updatePartnerCreditConfig(widget.partnerId, config, token: token);
    }

    setState(() => _isSaving = false);
    widget.onCancelEdit?.call();
  }

  InputDecoration _inputDecoration(String label) {
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
    );
  }

  Widget _buildRestrictionSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool>? onChanged,
    IconData icon = Icons.shield_outlined,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.gray300.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.gray700),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray800,
                    ),
                  ),
                  if (!widget.isEditing)
                    Text(
                      value ? 'Liberado' : 'Restrito',
                      style: TextStyle(
                        fontSize: 12,
                        color: value ? AppColors.gray600 : AppColors.error,
                      ),
                    ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primaryColor.withValues(alpha: 0.5),
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryColor;
                }
                return null;
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasConfig = widget.partnerCreditConfig != null;

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
            onEdit: widget.isEditing ? _handleSave : (hasConfig ? () {} : null),
            icon: const Icon(Icons.credit_card),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            title: 'Crédito',
            description: 'Informações de crédito e consulta',
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              children: [
                if (!hasConfig && !widget.isEditing) ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.credit_card_off,
                          size: 48,
                          color: AppColors.gray500,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma configuração de crédito cadastrada',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.gray800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => widget.onEdit?.call(),
                          icon: const Icon(Icons.add),
                          label: const Text('Criar configuração de crédito'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final useWideLayout = width > 720;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (useWideLayout)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child:
                                        widget.isEditing
                                            ? TextFormField(
                                              controller: _creditController,
                                              decoration: _inputDecoration(
                                                'Crédito',
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            )
                                            : DataField(
                                              label: 'Crédito',
                                              value: _creditController.text,
                                            ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child:
                                        widget.isEditing
                                            ? TextFormField(
                                              controller: _dateController,
                                              decoration: _inputDecoration(
                                                'Data',
                                              ),
                                            )
                                            : DataField(
                                              label: 'Data',
                                              value: _dateController.text,
                                            ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.gray300.withValues(
                                          alpha: 0.25,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.card_giftcard_rounded,
                                            size: 20,
                                            color: AppColors.gray700,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Consulta Serasa',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.gray800,
                                            ),
                                          ),
                                          const Spacer(),
                                          Switch(
                                            value: _serasaCheck,
                                            onChanged:
                                                widget.isEditing
                                                    ? (value) => setState(
                                                      () =>
                                                          _serasaCheck = value,
                                                    )
                                                    : null,
                                            activeTrackColor: AppColors
                                                .primaryColor
                                                .withValues(alpha: 0.5),
                                            thumbColor:
                                                WidgetStateProperty.resolveWith(
                                                  (states) {
                                                    if (states.contains(
                                                      WidgetState.selected,
                                                    )) {
                                                      return AppColors
                                                          .primaryColor;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  widget.isEditing
                                      ? TextFormField(
                                        controller: _creditController,
                                        decoration: _inputDecoration('Crédito'),
                                        keyboardType: TextInputType.number,
                                      )
                                      : DataField(
                                        label: 'Crédito',
                                        value: _creditController.text,
                                      ),
                                  const SizedBox(height: 16),
                                  widget.isEditing
                                      ? TextFormField(
                                        controller: _dateController,
                                        decoration: _inputDecoration('Data'),
                                      )
                                      : DataField(
                                        label: 'Data',
                                        value: _dateController.text,
                                      ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.gray300.withValues(
                                        alpha: 0.25,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.card_giftcard_rounded,
                                          size: 20,
                                          color: AppColors.gray700,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Consulta Serasa',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.gray800,
                                          ),
                                        ),
                                        const Spacer(),
                                        Switch(
                                          value: _serasaCheck,
                                          onChanged:
                                              widget.isEditing
                                                  ? (value) => setState(
                                                    () => _serasaCheck = value,
                                                  )
                                                  : null,
                                          activeTrackColor: AppColors
                                              .primaryColor
                                              .withValues(alpha: 0.5),
                                          thumbColor:
                                              WidgetStateProperty.resolveWith((
                                                states,
                                              ) {
                                                if (states.contains(
                                                  WidgetState.selected,
                                                )) {
                                                  return AppColors.primaryColor;
                                                }
                                                return null;
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (widget.isEditing) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Restrições',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final useGrid = width > 600;
                          final restrictions = [
                            (
                              'Pedido Novo',
                              _newOrder,
                              Icons.add_shopping_cart,
                              (v) => setState(() => _newOrder = v),
                            ),
                            (
                              'Baixa Pedido',
                              _orderRelease,
                              Icons.inventory_2_outlined,
                              (v) => setState(() => _orderRelease = v),
                            ),
                            (
                              'Emissão NF-e',
                              _nfeIssuance,
                              Icons.receipt_long_outlined,
                              (v) => setState(() => _nfeIssuance = v),
                            ),
                            (
                              'Análise de Crédito',
                              _creditAnalysis,
                              Icons.verified_user_outlined,
                              (v) => setState(() => _creditAnalysis = v),
                            ),
                          ];
                          if (useGrid) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children:
                                        restrictions
                                            .take(2)
                                            .map(
                                              (r) => _buildRestrictionSwitchRow(
                                                label: r.$1,
                                                value: r.$2,
                                                onChanged:
                                                    widget.isEditing
                                                        ? r.$4
                                                        : null,
                                                icon: r.$3,
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    children:
                                        restrictions
                                            .skip(2)
                                            .map(
                                              (r) => _buildRestrictionSwitchRow(
                                                label: r.$1,
                                                value: r.$2,
                                                onChanged:
                                                    widget.isEditing
                                                        ? r.$4
                                                        : null,
                                                icon: r.$3,
                                              ),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            children:
                                restrictions
                                    .map(
                                      (r) => _buildRestrictionSwitchRow(
                                        label: r.$1,
                                        value: r.$2,
                                        onChanged:
                                            widget.isEditing ? r.$4 : null,
                                        icon: r.$3,
                                      ),
                                    )
                                    .toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed:
                                _isSaving
                                    ? null
                                    : () => widget.onCancelEdit?.call(),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.gray600,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _isSaving ? null : _handleSave,
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
                    ),
                  ] else if (hasConfig) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
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
                              'HISTÓRICO',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.2,
                                fontFamily: 'Frutiger_bold',
                                color: AppColors.gray600,
                              ),
                            ),
                            Text(
                              'Cliente com histórico de pagamento pontual. Limite aprovado em reunião do comitê de crédito em 10/2025.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.2,
                                fontFamily: 'Frutiger',
                                color: AppColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          if (hasConfig && !widget.isEditing) ...[
            SectionHeader(
              trailing: null,
              isEditing: false,
              setIsEditing: null,
              onEdit: null,
              icon: const Icon(Icons.credit_card),
              iconDecoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              title: 'Restrições',
              description: 'Restrições ativas para o parceiro',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final useGrid = width > 600;
                  final restrictions = [
                    ('Pedido Novo', _newOrder, Icons.add_shopping_cart),
                    ('Baixa Pedido', _orderRelease, Icons.inventory_2_outlined),
                    ('Emissão NF-e', _nfeIssuance, Icons.receipt_long_outlined),
                    (
                      'Análise de Crédito',
                      _creditAnalysis,
                      Icons.verified_user_outlined,
                    ),
                  ];
                  if (useGrid) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children:
                                restrictions
                                    .take(2)
                                    .map(
                                      (r) => _buildRestrictionSwitchRow(
                                        label: r.$1,
                                        value: r.$2,
                                        onChanged: null,
                                        icon: r.$3,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children:
                                restrictions
                                    .skip(2)
                                    .map(
                                      (r) => _buildRestrictionSwitchRow(
                                        label: r.$1,
                                        value: r.$2,
                                        onChanged: null,
                                        icon: r.$3,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children:
                        restrictions
                            .map(
                              (r) => _buildRestrictionSwitchRow(
                                label: r.$1,
                                value: r.$2,
                                onChanged: null,
                                icon: r.$3,
                              ),
                            )
                            .toList(),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
