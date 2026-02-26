import 'package:flutter/material.dart';
import 'package:yachid/app/core/formatters/input_formatters.dart';

import '../../../../../core/widgets/widgets.dart';

class SectionAddressWidget extends StatelessWidget {
  final TextEditingController cepCtrl;
  final TextEditingController enderecoCtrl;
  final TextEditingController numeroCtrl;
  final TextEditingController complementoCtrl;
  final TextEditingController bairroCtrl;
  final TextEditingController cidadeCtrl;
  final TextEditingController ibgeCtrl;
  final TextEditingController paisCtrl;

  final String uf;
  final Function(String?) onUfChanged;

  final bool Function(String campo) isCampoBloqueado;

  final Map<String, bool> openSections;
  final Function(String) toggle;

  SectionAddressWidget({
    super.key,
    required this.cepCtrl,
    required this.enderecoCtrl,
    required this.numeroCtrl,
    required this.complementoCtrl,
    required this.bairroCtrl,
    required this.cidadeCtrl,
    required this.ibgeCtrl,
    required this.paisCtrl,
    required this.uf,
    required this.onUfChanged,
    required this.isCampoBloqueado,
    required this.openSections,
    required this.toggle,
  });

  Widget _spacing() => const SizedBox(height: 15);

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
    );
  }

  final List<DropdownMenuItem<String>> _ufs = [
    DropdownMenuItem(value: 'AC', child: Text('AC - Acre')),
    DropdownMenuItem(value: 'AL', child: Text('AL - Alagoas')),
    DropdownMenuItem(value: 'AP', child: Text('AP - Amapá')),
    DropdownMenuItem(value: 'AM', child: Text('AM - Amazonas')),
    DropdownMenuItem(value: 'BA', child: Text('BA - Bahia')),
    DropdownMenuItem(value: 'CE', child: Text('CE - Ceará')),
    DropdownMenuItem(value: 'DF', child: Text('DF - Distrito Federal')),
    DropdownMenuItem(value: 'ES', child: Text('ES - Espírito Santo')),
    DropdownMenuItem(value: 'GO', child: Text('GO - Goiás')),
    DropdownMenuItem(value: 'MA', child: Text('MA - Maranhão')),
    DropdownMenuItem(value: 'MT', child: Text('MT - Mato Grosso')),
    DropdownMenuItem(value: 'MS', child: Text('MS - Mato Grosso do Sul')),
    DropdownMenuItem(value: 'MG', child: Text('MG - Minas Gerais')),
    DropdownMenuItem(value: 'PA', child: Text('PA - Pará')),
    DropdownMenuItem(value: 'PB', child: Text('PB - Paraíba')),
    DropdownMenuItem(value: 'PR', child: Text('PR - Paraná')),
    DropdownMenuItem(value: 'PE', child: Text('PE - Pernambuco')),
    DropdownMenuItem(value: 'PI', child: Text('PI - Piauí')),
    DropdownMenuItem(value: 'RJ', child: Text('RJ - Rio de Janeiro')),
    DropdownMenuItem(value: 'RN', child: Text('RN - Rio Grande do Norte')),
    DropdownMenuItem(value: 'RS', child: Text('RS - Rio Grande do Sul')),
    DropdownMenuItem(value: 'RO', child: Text('RO - Rondônia')),
    DropdownMenuItem(value: 'RR', child: Text('RR - Roraima')),
    DropdownMenuItem(value: 'SC', child: Text('SC - Santa Catarina')),
    DropdownMenuItem(value: 'SP', child: Text('SP - São Paulo')),
    DropdownMenuItem(value: 'SE', child: Text('SE - Sergipe')),
    DropdownMenuItem(value: 'TO', child: Text('TO - Tocantins')),
  ];

  @override
  Widget build(BuildContext context) {
    return sectionDropdown(
      keyName: 'endereco',
      title: 'Endereço',
      openSections: openSections,
      toggle: toggle,
      children: [
        row([
          _cepField(),
          _textField(
            enderecoCtrl,
            'Endereço',
            readOnly: isCampoBloqueado('endereco'),
          ),
          _textField(
            numeroCtrl,
            'Número',
            readOnly: isCampoBloqueado('numero'),
          ),
        ]),
        _spacing(),
        row([
          _textField(complementoCtrl, 'Complemento'),
          _textField(
            bairroCtrl,
            'Bairro',
            readOnly: isCampoBloqueado('bairro'),
          ),
        ]),
        _spacing(),
        row([
          _textField(
            cidadeCtrl,
            'Cidade',
            readOnly: isCampoBloqueado('cidade'),
          ),
          _ibgeField(),
          _ufDropdown(),
        ]),
        _spacing(),
        _textField(paisCtrl, 'País'),
      ],
    );
  }

  Widget _cepField() {
    return TextFormField(
      controller: cepCtrl,
      decoration: _dec('CEP'),
      keyboardType: TextInputType.number,
      inputFormatters: [CepInputFormatter()],
      maxLength: 9,
      readOnly: isCampoBloqueado('cep'),
    );
  }

  Widget _ibgeField() {
    return TextFormField(
      controller: ibgeCtrl,
      decoration: _dec('Código IBGE'),
      keyboardType: TextInputType.number,
      inputFormatters: [NumbersOnlyFormatter()],
    );
  }

  Widget _ufDropdown() {
    return DropdownButtonFormField<String>(
      value: uf,
      decoration: _dec('UF - Estado'),
      items: _ufs,
      onChanged: isCampoBloqueado('uf') ? null : onUfChanged,
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _dec(label),
      readOnly: readOnly,
    );
  }
}
