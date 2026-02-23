import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/yachid_form.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';

class DeliveryAddressRegisterCard extends StatefulWidget {
  const DeliveryAddressRegisterCard({super.key, this.onSaved, this.onCancel});

  final ValueChanged<DeliveryAddress>? onSaved;
  final VoidCallback? onCancel;

  @override
  State<DeliveryAddressRegisterCard> createState() =>
      _DeliveryAddressRegisterCardState();
}

class _DeliveryAddressRegisterCardState
    extends State<DeliveryAddressRegisterCard> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _regionController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _ufController = TextEditingController();
  final _observationsController = TextEditingController();

  bool _bonification = false;

  @override
  void dispose() {
    _cepController.dispose();
    _streetController.dispose();
    _regionController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _ufController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
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
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final address = DeliveryAddress(
      cep: _cepController.text.trim(),
      street: _streetController.text.trim(),
      region: _regionController.text.trim(),
      neighborhood: _neighborhoodController.text.trim(),
      city: _cityController.text.trim(),
      uf: _ufController.text.trim().toUpperCase(),
      observations:
          _observationsController.text.trim().isEmpty
              ? null
              : _observationsController.text.trim(),
      bonification: _bonification,
    );
    widget.onSaved?.call(address);
    _clearForm();
  }

  void _clearForm() {
    _cepController.clear();
    _streetController.clear();
    _regionController.clear();
    _neighborhoodController.clear();
    _cityController.clear();
    _ufController.clear();
    _observationsController.clear();
    setState(() => _bonification = false);
  }

  void _handleCancel() {
    _clearForm();
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 160),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFormGrid(context),
                  const SizedBox(height: 20),
                  _buildBonificationRow(),
                  const SizedBox(height: 28),
                  _buildActions(),
                ],
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
              Icons.add_road_rounded,
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
                  'Novo endereço de entrega',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preencha os campos abaixo para cadastrar um local de entrega.',
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

  Widget _buildFormGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width > 720 ? 3 : (width > 520 ? 2 : 1);
        const spacing = 24.0;
        const runSpacing = 20.0;
        final itemWidth =
            width > 520
                ? (width - 48 - spacing * (crossAxisCount - 1)) / crossAxisCount
                : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: runSpacing,
              children: [
                _field(
                  itemWidth,
                  child: TextFormField(
                    controller: _cepController,
                    decoration: _decoration('CEP'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Informe o CEP'
                                : null,
                  ),
                ),
                _field(
                  itemWidth,
                  child: TextFormField(
                    controller: _streetController,
                    decoration: _decoration('Logradouro'),
                    textInputAction: TextInputAction.next,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Informe o logradouro'
                                : null,
                  ),
                ),
                _field(
                  itemWidth,
                  child: TextFormField(
                    controller: _regionController,
                    decoration: _decoration('Região'),
                    textInputAction: TextInputAction.next,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Informe a região'
                                : null,
                  ),
                ),
                _field(
                  itemWidth,
                  child: TextFormField(
                    controller: _neighborhoodController,
                    decoration: _decoration('Bairro'),
                    textInputAction: TextInputAction.next,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Informe o bairro'
                                : null,
                  ),
                ),
                _field(
                  width > 720 ? (itemWidth! * 2 + spacing) : itemWidth,
                  child: TextFormField(
                    controller: _cityController,
                    decoration: _decoration('Cidade'),
                    textInputAction: TextInputAction.next,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Informe a cidade'
                                : null,
                  ),
                ),
                _field(
                  width > 720 ? 100 : (width > 520 ? 140 : null),
                  child: YachidFormField(
                    controller: _ufController,
                    label: 'UF',
                    hint: '',
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 2,
                    textInputAction: TextInputAction.next,

                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Informe a UF'
                                : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _observationsController,
              decoration: _decoration('Observações', hint: 'Opcional'),
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
          ],
        );
      },
    );
  }

  Widget _field(double? width, {required Widget child}) {
    if (width == null) return child;
    return SizedBox(width: width, child: child);
  }

  Widget _buildBonificationRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.gray300.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.card_giftcard_rounded, size: 20, color: AppColors.gray700),
          const SizedBox(width: 12),
          Text(
            'Bonificação',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.gray800,
            ),
          ),
          const Spacer(),
          Switch(
            value: _bonification,
            onChanged: (value) => setState(() => _bonification = value),
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
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _handleCancel,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.gray600,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Limpar'),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Cadastrar endereço'),
        ),
      ],
    );
  }
}
