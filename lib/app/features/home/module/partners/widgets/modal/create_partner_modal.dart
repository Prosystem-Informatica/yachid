import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/auth/module/widget/row_widget.dart';
import 'package:yachid/app/features/auth/module/widget/section_widget.dart';
import 'package:yachid/app/features/home/module/partners/model/payment_address.dart';
import 'package:yachid/app/model/address_model.dart';

import '../../cubit/partners_cubit.dart';
import '../../model/partner_model.dart';

class CreatePartnerModal extends StatefulWidget {
  const CreatePartnerModal({super.key});

  @override
  State<CreatePartnerModal> createState() => _CreatePartnerModalState();
}

class _CreatePartnerModalState extends State<CreatePartnerModal> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
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

  final List<String> _transportList = [];

  PartnerStatus? _selectedStatus;
  PartnerType? _selectedPersonType;
  String? _cFop;
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

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
    );
  }

  void _submitForm() {
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
      PartnerModelDto? partner;
      try {
        partner = PartnerModelDto(
          suframa: _suframaController.text.trim(),
          type: _selectedType!,
          accountingAccount: _accountingAccount,
          fixedExpenses: _fixedExpense,
          provision: _provision,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          codigo: _codigoController.text.trim(),
          name: _nameController.text.trim(),
          document: _documentController.text.trim(),
          fantasyName: _fantasyNameController.text.trim(),
          emailNfe: _emailNfeController.text.trim(),
          email: _emailController.text.trim(),
          site: _siteController.text.trim(),
          paymentAddress: PaymentAddressDto(
            hasCredit: _hasCredit,
            representative: _representative,
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
      } catch (e, s) {
        return;
      }

      context.read<PartnersCubit>().addPartner(
        partner,
        'Fornecedor',
        context.read<AuthBlocCubit>().state.authModel?.token ?? '',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parceiro cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nameController.dispose();
    _documentController.dispose();
    _fantasyNameController.dispose();
    _cityController.dispose();
    _mainPhoneController.dispose();
    _secondaryPhoneController.dispose();
    _cellphoneController.dispose();
    _ufController.dispose();
    _cepController.dispose();
    _ieRgController.dispose();
    _businessSectorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cadastrar Cliente/Fornecedor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
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
                          child: TextFormField(
                            controller: _codigoController,
                            decoration: _dec('Código *'),
                            validator:
                                (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Obrigatório'
                                        : null,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<PartnerType>(
                            decoration: _dec('Tipo de Pessoa *'),
                            value: _selectedPersonType,
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
                                (v) => setState(() => _selectedPersonType = v),
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
                    const SizedBox(height: 12),
                    row([
                      DropdownButtonFormField<PartnerStatus>(
                        decoration: _dec('Status *'),
                        value: _selectedStatus,
                        items:
                            PartnerStatus.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.label),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _selectedStatus = v),
                        hint: const Text('Selecione'),
                      ),
                    ]),
                    const SizedBox(height: 12),
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

                    TextFormField(
                      controller: _cellphoneController,
                      decoration: _dec('Celular'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _ieRgController,
                            decoration: _dec('IE/RG'),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _suframaController,
                            decoration: _dec('suframa'),
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
                    DropdownButtonFormField<String>(
                      decoration: _dec('Tipo'),

                      items:
                          ['Residencial', 'Comercial', 'Outro']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _selectedType = v),
                      hint: const Text('Selecione'),
                    ),
                    const SizedBox(height: 12),
                    Text('Endereço'),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: TextFormField(
                          controller: _cepController,
                          decoration: _dec('CEP *'),
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
                            decoration: _dec('Rua'),
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
                            decoration: _dec('Cidade'),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _neighborhoodController,
                            decoration: _dec('Bairro'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _ufController,
                            decoration: _dec('UF'),

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
                      decoration: _dec('Complemento'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _dec('País'),
                      controller: _countryController,
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
                                  (v) => setState(() => _accountingAccount = v),
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
                              onChanged: (v) => setState(() => _provision = v),
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
                            // TODO: if partner type is Client, show this field
                            if (true) {
                              (v == null || v.trim().isEmpty)
                                  ? 'Obrigatório'
                                  : null;
                            } else {
                              return null;
                            }
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
                          onChanged: (v) => setState(() => _representative = v),
                          hint: const Text('Selecione'),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: _dec('Tem crédito?'),
                      items:
                          _yesNoList
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged:
                          (v) => setState(
                            () => _hasCredit = v == 'SIM' ? true : false,
                          ),
                      hint: const Text('Selecione'),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: TextFormField(
                          decoration: _dec('CEP *'),
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
                            decoration: _dec('Endereço'),
                            controller: _streetPaymentAddressController,
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
                            decoration: _dec('Bairro'),
                            controller: _neighborhoodPaymentAddressController,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            decoration: _dec('cidade'),
                            controller: _cityPaymentAddressController,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: _dec('UF'),
                            controller: _ufPaymentAddressController,
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
                      onPressed: () => Navigator.pop(context),
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
    );
  }
}
