import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/model/payment_address.dart';
import 'package:yachid/app/model/address_model.dart';
import 'package:yachid/app/core/helpers/environments.dart';
import 'package:yachid/app/core/rest/http/http_rest_client.dart';
import 'package:yachid/app/repository/cep/cep_repository.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../cubit/partners_cubit.dart';
import '../../model/partner_model.dart';

class PartnerRegisterCard extends StatefulWidget {
  const PartnerRegisterCard({super.key, this.onSaved, this.onCancel});

  final ValueChanged<PartnerModelDto>? onSaved;
  final VoidCallback? onCancel;

  @override
  State<PartnerRegisterCard> createState() => _PartnerRegisterCardState();
}

class _PartnerRegisterCardState extends State<PartnerRegisterCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _documentController = TextEditingController();
  final _fantasyNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _numberController = TextEditingController();
  final _streetController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _complementController = TextEditingController();
  final _suframaController = TextEditingController();

  final _mainPhoneController = TextEditingController();
  final _secondaryPhoneController = TextEditingController();
  final _cellphoneController = TextEditingController();
  final _ufController = TextEditingController();
  final _cepController = TextEditingController();
  final _ieRgController = TextEditingController();
  final _businessSectorController = TextEditingController();

  final _emailNfeController = TextEditingController();
  final _emailController = TextEditingController();
  final _siteController = TextEditingController();

  final _cepPaymentAddressController = TextEditingController();
  final _streetPaymentAddressController = TextEditingController();
  final _numberPaymentAddressController = TextEditingController();
  final _cityPaymentAddressController = TextEditingController();
  final _neighborhoodPaymentAddressController = TextEditingController();
  final _ufPaymentAddressController = TextEditingController();
  final _phonePaymentAddressController = TextEditingController();
  final _emailPaymentAddressController = TextEditingController();
  final _observationsPaymentAddressController = TextEditingController();
  final _countryController = TextEditingController();
  final _cepRepository = CepRepository(
    rest: HttpRestClient(
      baseUrl: Environments.get('BASE_URL') ?? "",
      env: Environments.get('ENV') ?? "",
      port: Environments.get('PORT') ?? "",
    ),
  );

  bool _isLoadingMainCep = false;
  bool _isLoadingPaymentCep = false;
  String? _mainCepErrorMessage;
  String? _paymentCepErrorMessage;
  bool _isMainStreetReadOnly = false;
  bool _isMainNeighborhoodReadOnly = false;
  bool _isMainCityReadOnly = false;
  bool _isMainUfReadOnly = false;
  bool _isMainComplementReadOnly = false;
  bool _isPaymentStreetReadOnly = false;
  bool _isPaymentNeighborhoodReadOnly = false;
  bool _isPaymentCityReadOnly = false;
  bool _isPaymentUfReadOnly = false;

  PartnerStatus? _selectedStatus;
  PartnerType? _selectedPersonType;
  String? _representative;
  bool? _hasCredit;
  String? _selectedType;

  String? _accountingAccount;
  String? _fixedExpense;
  String? _provision;

  final List<String> _yesNoList = ['SIM', 'NÃO'];
  final Map<String, bool> openSections = {
    'dados': false,
    'local_de_cobranca': false,
    'transport': false,
  };

  void toggle(String key) {
    setState(() {
      openSections[key] = !openSections[key]!;
    });
  }

  void _applyApiValue({
    required TextEditingController controller,
    required String? value,
    required ValueChanged<bool> setReadOnly,
  }) {
    final normalized = value?.trim() ?? '';
    if (normalized.isNotEmpty) {
      controller.text = normalized;
      setReadOnly(true);
    } else {
      setReadOnly(false);
    }
  }

  Future<void> _buscarCepPrincipal(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^\d]'), '');
    if (cepLimpo.length != 8) return;

    setState(() {
      _isLoadingMainCep = true;
      _mainCepErrorMessage = null;
    });

    try {
      final token = context.read<AuthBlocCubit>().state.authModel.token ?? '';
      final data = await _cepRepository.lookupCep(cep: cepLimpo, token: token);
      setState(() {
        _applyApiValue(
          controller: _streetController,
          value: data.logradouro,
          setReadOnly: (v) => _isMainStreetReadOnly = v,
        );
        _applyApiValue(
          controller: _neighborhoodController,
          value: data.bairro,
          setReadOnly: (v) => _isMainNeighborhoodReadOnly = v,
        );
        _applyApiValue(
          controller: _cityController,
          value: data.localidade,
          setReadOnly: (v) => _isMainCityReadOnly = v,
        );
        _applyApiValue(
          controller: _ufController,
          value: data.uf,
          setReadOnly: (v) => _isMainUfReadOnly = v,
        );
        _applyApiValue(
          controller: _complementController,
          value: data.complemento,
          setReadOnly: (v) => _isMainComplementReadOnly = v,
        );
      });
    } catch (_) {
      if (mounted && cepLimpo.length == 8) {
        setState(() {
          _mainCepErrorMessage = 'CEP inválido ou não encontrado';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMainCep = false;
        });
      }
    }
  }

  Future<void> _buscarCepCobranca(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^\d]'), '');
    if (cepLimpo.length != 8) return;

    setState(() {
      _isLoadingPaymentCep = true;
      _paymentCepErrorMessage = null;
    });

    try {
      final token = context.read<AuthBlocCubit>().state.authModel.token ?? '';
      final data = await _cepRepository.lookupCep(cep: cepLimpo, token: token);
      setState(() {
        _applyApiValue(
          controller: _streetPaymentAddressController,
          value: data.logradouro,
          setReadOnly: (v) => _isPaymentStreetReadOnly = v,
        );
        _applyApiValue(
          controller: _neighborhoodPaymentAddressController,
          value: data.bairro,
          setReadOnly: (v) => _isPaymentNeighborhoodReadOnly = v,
        );
        _applyApiValue(
          controller: _cityPaymentAddressController,
          value: data.localidade,
          setReadOnly: (v) => _isPaymentCityReadOnly = v,
        );
        _applyApiValue(
          controller: _ufPaymentAddressController,
          value: data.uf,
          setReadOnly: (v) => _isPaymentUfReadOnly = v,
        );
      });
    } catch (_) {
      if (mounted && cepLimpo.length == 8) {
        setState(() {
          _paymentCepErrorMessage = 'CEP inválido ou não encontrado';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingPaymentCep = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _cepController.addListener(() {
      final cepLimpo = _cepController.text.replaceAll(RegExp(r'[^\d]'), '');
      if (_mainCepErrorMessage != null && cepLimpo.length < 8) {
        setState(() => _mainCepErrorMessage = null);
      }
      if (cepLimpo.length == 8 && !_isLoadingMainCep) {
        _buscarCepPrincipal(cepLimpo);
      }
    });

    _cepPaymentAddressController.addListener(() {
      final cepLimpo = _cepPaymentAddressController.text.replaceAll(
        RegExp(r'[^\d]'),
        '',
      );
      if (_paymentCepErrorMessage != null && cepLimpo.length < 8) {
        setState(() => _paymentCepErrorMessage = null);
      }
      if (cepLimpo.length == 8 && !_isLoadingPaymentCep) {
        _buscarCepCobranca(cepLimpo);
      }
    });
  }

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
    );
  }

  Widget _apiLockedSuffix(bool isReadOnly) {
    if (!isReadOnly) return const SizedBox.shrink();
    return const Tooltip(
      message: 'Preenchido automaticamente pela API de CEP',
      child: Icon(Icons.lock_rounded, size: 18, color: AppColors.gray600),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedStatus == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Selecione o status')));
        return;
      }
      if (_selectedPersonType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione o tipo de pessoa')),
        );
        return;
      }
      final cubit = context.read<PartnersCubit>();
      final current = cubit.state;
      final groupId =
          current is PartnersLoaded ? current.selectedGroupId : null;
      if (groupId == null || groupId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione um grupo para cadastrar o parceiro'),
          ),
        );
        return;
      }

      PartnerModelDto? partner;
      try {
        partner = PartnerModelDto(
          groupId: groupId,
          suframa: _suframaController.text.trim(),
          type: _selectedType!,
          accountingAccount: _accountingAccount,
          fixedExpenses: _fixedExpense,
          provision: _provision,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text.trim(),
          document: _documentController.text.trim(),
          fantasyName: _fantasyNameController.text.trim(),
          emailNfe: _emailNfeController.text.trim(),
          email: _emailController.text.trim(),
          site: _siteController.text.trim(),
          paymentAddress: PaymentAddressDto(
            hasCredit: _hasCredit,
            representative: _representative,
            number: _numberPaymentAddressController.text.trim(),
            cep: _cepPaymentAddressController.text.trim(),
            street: _streetPaymentAddressController.text.trim(),
            neighborhood: _neighborhoodPaymentAddressController.text.trim(),
            city: _cityPaymentAddressController.text.trim(),
            uf: _ufPaymentAddressController.text.trim(),
            phone: _phonePaymentAddressController.text.trim(),
            email: _emailPaymentAddressController.text.trim(),
            observations: _observationsPaymentAddressController.text.trim(),
          ),
          mainPhone: _mainPhoneController.text.trim(),
          secondaryPhone: _secondaryPhoneController.text.trim(),
          cellphone: _cellphoneController.text.trim(),
          status: _selectedStatus!,
          personType: _selectedPersonType!,
          ieRg: _ieRgController.text.trim(),
          businessSector: _businessSectorController.text.trim(),
          address: Address(
            cep: _cepController.text.trim(),
            street: _streetController.text.trim(),
            number: _numberController.text.trim(),
            city: _cityController.text.trim(),
            neighborhood: _neighborhoodController.text.trim(),
            uf: _ufController.text.trim(),
            complement: _complementController.text.trim(),
            country: _countryController.text.trim(),
          ),
        );
      } catch (e) {
        return;
      }

      await context.read<PartnersCubit>().addPartner(
        partner,
        'Fornecedor',
        context.read<AuthBlocCubit>().state.authModel.token ?? '',
      );
      widget.onSaved?.call(partner);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _documentController.dispose();
    _fantasyNameController.dispose();
    _cityController.dispose();
    _mainPhoneController.dispose();
    _secondaryPhoneController.dispose();
    _cellphoneController.dispose();
    _ufController.dispose();
    _cepController.dispose();
    _cepPaymentAddressController.dispose();
    _streetPaymentAddressController.dispose();
    _numberPaymentAddressController.dispose();
    _cityPaymentAddressController.dispose();
    _neighborhoodPaymentAddressController.dispose();
    _ufPaymentAddressController.dispose();
    _phonePaymentAddressController.dispose();
    _emailPaymentAddressController.dispose();
    _observationsPaymentAddressController.dispose();
    _countryController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _complementController.dispose();
    _ieRgController.dispose();
    _businessSectorController.dispose();
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    sectionDropdown(
                      keyName: 'dados',
                      title: 'Dados do Parceiro',
                      openSections: openSections,
                      toggle: toggle,
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 1,
                              child: DropdownButtonFormField<PartnerType>(
                                decoration: _dec('Tipo de Pessoa *'),
                                items:
                                    PartnerType.values
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.label),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (v) =>
                                        setState(() => _selectedPersonType = v),
                                hint: const Text('Selecione'),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: DropdownButtonFormField<String>(
                                decoration: _dec('Tipo'),

                                items:
                                    ['Residencial', 'Comercial', 'Outro']
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (v) => setState(() => _selectedType = v),
                                hint: const Text('Selecione'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _documentController,
                          decoration: _dec(
                            _selectedPersonType != null
                                ? _selectedPersonType == PartnerType.PF
                                    ? 'Documento (CPF) *'
                                    : 'Documento (CNPJ) *'
                                : 'Documento (CPF/CNPJ) *',
                          ),
                          validator:
                              (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Obrigatório'
                                      : null,
                        ),
                        const SizedBox(height: 12),
                        row([
                          TextFormField(
                            controller: _nameController,
                            decoration: _dec('Nome/Razão Social *'),
                            validator:
                                (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Obrigatório'
                                        : null,
                          ),
                          TextFormField(
                            controller: _fantasyNameController,
                            decoration: _dec('Nome Fantasia'),
                          ),
                        ]),

                        row([
                          TextFormField(
                            controller: _mainPhoneController,
                            decoration: _dec('Telefone Principal'),
                            keyboardType: TextInputType.phone,
                          ),
                          TextFormField(
                            controller: _secondaryPhoneController,
                            decoration: _dec('Telefone Secundário'),
                            keyboardType: TextInputType.phone,
                          ),
                        ]),

                        const SizedBox(height: 12),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _ieRgController,
                                decoration: _dec('IE/RG'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _suframaController,
                                decoration: _dec('suframa'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _cellphoneController,
                                decoration: _dec('Celular'),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _businessSectorController,
                          decoration: _dec('Ramo de Atividade'),
                        ),
                        const SizedBox(height: 12),
                        Text('Endereço'),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: TextFormField(
                              controller: _cepController,
                              decoration: _dec('CEP *').copyWith(
                                errorText: _mainCepErrorMessage,
                                suffixIcon:
                                    _isLoadingMainCep
                                        ? const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                        : null,
                              ),
                              keyboardType: TextInputType.number,
                              validator:
                                  (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'Obrigatório'
                                          : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 5,
                              child: TextFormField(
                                controller: _streetController,
                                decoration: _dec('Rua').copyWith(
                                  suffixIcon: _apiLockedSuffix(
                                    _isMainStreetReadOnly,
                                  ),
                                ),
                                readOnly: _isMainStreetReadOnly,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _numberController,
                                decoration: _dec('Número'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _cityController,
                                decoration: _dec('Cidade').copyWith(
                                  suffixIcon: _apiLockedSuffix(
                                    _isMainCityReadOnly,
                                  ),
                                ),
                                readOnly: _isMainCityReadOnly,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _neighborhoodController,
                                decoration: _dec('Bairro').copyWith(
                                  suffixIcon: _apiLockedSuffix(
                                    _isMainNeighborhoodReadOnly,
                                  ),
                                ),
                                readOnly: _isMainNeighborhoodReadOnly,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: _dec('País'),
                                controller: _countryController,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _ufController,
                                decoration: _dec('UF').copyWith(
                                  suffixIcon: _apiLockedSuffix(
                                    _isMainUfReadOnly,
                                  ),
                                ),
                                readOnly: _isMainUfReadOnly,
                                validator:
                                    (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Obrigatório'
                                            : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _complementController,
                          decoration: _dec('Complemento').copyWith(
                            suffixIcon: _apiLockedSuffix(
                              _isMainComplementReadOnly,
                            ),
                          ),
                          readOnly: _isMainComplementReadOnly,
                        ),
                        const SizedBox(height: 12),
                        Text('Outros'),
                        const SizedBox(height: 12),

                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _emailNfeController,
                                decoration: _dec('Email NF-e'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _emailController,
                                decoration: _dec('Email'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _siteController,
                          decoration: _dec('Site'),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.gray300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Status *',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      _selectedStatus?.label ?? '',
                                      style: TextStyle(
                                        color:
                                            (_selectedStatus?.label == 'Ativo')
                                                ? AppColors.success
                                                : AppColors.gray600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Switch(
                                      value:
                                          _selectedStatus ==
                                          PartnerStatus.ACTIVE,
                                      onChanged: (value) {
                                        setState(
                                          () =>
                                              _selectedStatus =
                                                  value
                                                      ? PartnerStatus.ACTIVE
                                                      : PartnerStatus.INACTIVE,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.gray300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Tem crédito?',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      (_hasCredit ?? false) ? 'SIM' : 'NÃO',
                                      style: TextStyle(
                                        color:
                                            (_hasCredit ?? false)
                                                ? AppColors.success
                                                : AppColors.gray600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Switch(
                                      value: _hasCredit ?? false,
                                      onChanged: (value) {
                                        setState(() => _hasCredit = value);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Visibility(
                          // TODO: if partner type is Fornecedor, show this field
                          visible: false,
                          child: Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<String>(
                                  decoration: _dec('CTA Contábil'),
                                  items:
                                      [
                                            'CTA empresa 1',
                                            'CTA empresa 2',
                                            'CTA empresa 3',
                                          ]
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (v) => setState(
                                        () => _accountingAccount = v,
                                      ),
                                  hint: const Text('Selecione'),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: DropdownButtonFormField<String>(
                                  decoration: _dec('Despesa Fixa'),
                                  items:
                                      _yesNoList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (v) => setState(() => _fixedExpense = v),
                                  hint: const Text('Selecione'),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: DropdownButtonFormField<String>(
                                  decoration: _dec('Provisão'),
                                  items:
                                      _yesNoList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (v) => setState(() => _provision = v),
                                  hint: const Text('Selecione'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    const SizedBox(height: 24),
                    sectionDropdown(
                      keyName: 'local_de_cobranca',
                      title: 'Local de cobrança',
                      openSections: openSections,
                      toggle: toggle,
                      children: [
                        const SizedBox(height: 12),
                        row([
                          Visibility(
                            visible: false,
                            child: DropdownButtonFormField<String>(
                              validator: (v) {
                                return null;
                              },
                              decoration: _dec('Representante *'),
                              items:
                                  ['ML', 'MP', 'PayPall']
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (v) => setState(() => _representative = v),
                              hint: const Text('Selecione'),
                            ),
                          ),
                        ]),

                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: TextFormField(
                              decoration: _dec('CEP *').copyWith(
                                errorText: _paymentCepErrorMessage,
                                suffixIcon:
                                    _isLoadingPaymentCep
                                        ? const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                        : null,
                              ),
                              controller: _cepPaymentAddressController,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                decoration: _dec('Endereço').copyWith(
                                  suffixIcon: _apiLockedSuffix(
                                    _isPaymentStreetReadOnly,
                                  ),
                                ),
                                controller: _streetPaymentAddressController,
                                readOnly: _isPaymentStreetReadOnly,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: _dec('Número'),
                                controller: _numberPaymentAddressController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          spacing: 12,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                decoration: _dec('Bairro').copyWith(
                                  suffixIcon: _apiLockedSuffix(
                                    _isPaymentNeighborhoodReadOnly,
                                  ),
                                ),
                                controller:
                                    _neighborhoodPaymentAddressController,
                                readOnly: _isPaymentNeighborhoodReadOnly,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                decoration: _dec('cidade').copyWith(
                                  suffixIcon: _apiLockedSuffix(
                                    _isPaymentCityReadOnly,
                                  ),
                                ),
                                controller: _cityPaymentAddressController,
                                readOnly: _isPaymentCityReadOnly,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: _dec('UF').copyWith(
                                  suffixIcon: _apiLockedSuffix(
                                    _isPaymentUfReadOnly,
                                  ),
                                ),
                                controller: _ufPaymentAddressController,
                                readOnly: _isPaymentUfReadOnly,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        row([
                          TextFormField(
                            decoration: _dec('Fone'),
                            controller: _phonePaymentAddressController,
                          ),
                          TextFormField(
                            decoration: _dec('Email'),
                            controller: _emailPaymentAddressController,
                          ),
                        ]),
                        TextFormField(
                          decoration: _dec('Observações'),
                          maxLines: 3,
                          controller: _observationsPaymentAddressController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => widget.onCancel?.call(),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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
              Icons.person_add_alt_1_rounded,
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
                  'Novo cliente/fornecedor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preencha os campos abaixo para cadastrar um novo parceiro.',
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
