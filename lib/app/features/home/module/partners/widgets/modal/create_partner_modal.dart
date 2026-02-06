import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/auth/module/widget/row_widget.dart';
import 'package:yachid/app/features/auth/module/widget/section_widget.dart';

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
  final _mainPhoneController = TextEditingController();
  final _secondaryPhoneController = TextEditingController();
  final _cellphoneController = TextEditingController();
  final _ufController = TextEditingController();
  final _cepController = TextEditingController();
  final _ieRgController = TextEditingController();
  final _businessSectorController = TextEditingController();

  final List<String> _transportList = [];

  PartnerStatus? _selectedStatus;
  PartnerType? _selectedPersonType;
  String? _cFop;
  String? _representative;
  String? _selectedAddressType;
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

      final partner = PartnerModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        codigo: _codigoController.text.trim(),
        name: _nameController.text.trim(),
        document: _documentController.text.trim(),
        fantasyName: _fantasyNameController.text.trim(),
        city: _cityController.text.trim(),
        mainPhone: _mainPhoneController.text.trim(),
        secondaryPhone: _secondaryPhoneController.text.trim(),
        cellphone: _cellphoneController.text.trim(),
        uf: _ufController.text.trim(),
        cep: _cepController.text.trim(),
        status: _selectedStatus!,
        personType: _selectedPersonType!,
        ieRg: _ieRgController.text.trim(),
        businessSector: _businessSectorController.text.trim(),
      );

      context.read<PartnersCubit>().addPartner(partner);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Parceiro cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
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
                    TextFormField(
                      controller: _ieRgController,
                      decoration: _dec('IE/RG'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _businessSectorController,
                      decoration: _dec('Ramo de Atividade'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: _dec('Tipo de Endereço'),
                      value: _selectedAddressType,
                      items:
                          ['Residencial', 'Comercial', 'Outro']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged:
                          (v) => setState(() => _selectedAddressType = v),
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
                          child: DropdownButtonFormField<String>(
                            decoration: _dec('UF'),
                            items:
                                [
                                      'AC',
                                      'AL',
                                      'AP',
                                      'AM',
                                      'BA',
                                      'CE',
                                      'DF',
                                      'ES',
                                      'GO',
                                      'MA',
                                      'MT',
                                      'MS',
                                      'MG',
                                      'PA',
                                      'PB',
                                      'PR',
                                      'PE',
                                      'PI',
                                      'RJ',
                                      'RN',
                                      'RS',
                                      'RO',
                                      'RR',
                                      'SC',
                                      'SP',
                                      'SE',
                                      'TO',
                                    ]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (v) => setState(() => _ufController.text = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _complementController,
                      decoration: _dec('Complemento'),
                    ),
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
                      DropdownButtonFormField<String>(
                        decoration: _dec('Cfop *'),
                        value: _cFop,
                        items:
                            [
                                  '1010',
                                  '1020',
                                  '1030',
                                  '1040',
                                  '1050',
                                  '1060',
                                  '1070',
                                  '1080',
                                  '1090',
                                  '1100',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => _cFop = v),
                        hint: const Text('Selecione'),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: _dec('Representante *'),
                        value: _representative,
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
                    ]),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: TextFormField(decoration: _dec('CEP *')),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(decoration: _dec('Endereço')),
                    const SizedBox(height: 12),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(decoration: _dec('Bairro')),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(decoration: _dec('cidade')),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(decoration: _dec('UF')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    row([
                      TextFormField(decoration: _dec('Fone')),
                      TextFormField(decoration: _dec('Email')),
                    ]),
                    TextFormField(decoration: _dec('Observações'), maxLines: 3),
                  ],
                ),
                const SizedBox(height: 24),
                sectionDropdown(
                  keyName: 'transport',
                  title: 'Transportadora(s)',
                  openSections: openSections,
                  toggle: toggle,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: DropdownButtonFormField<PartnerStatus>(
                            decoration: _dec('Transportadora *'),
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
                            onChanged:
                                (v) => setState(() => _selectedStatus = v),
                            hint: const Text('Selecione'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              if (_selectedStatus != null &&
                                  _transportList.length < 3) {
                                setState(() {
                                  _transportList.add(_selectedStatus!.label);
                                  _selectedStatus = null;
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._transportList.map(
                      (e) => Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: e),
                                  decoration: _dec('Transportadora'),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed:
                                      () => setState(
                                        () => _transportList.remove(e),
                                      ),
                                  icon: const Icon(Icons.remove),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
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
