import 'package:flutter/material.dart';
import 'package:yachid/app/core/formatters/input_formatters.dart';

import '../../../../../core/widgets/widgets.dart';

class SectionDataWidget extends StatelessWidget {
  final TextEditingController cnpjCtrl;
  final TextEditingController razaoSocialCtrl;
  final TextEditingController nomeFantasiaCtrl;
  final TextEditingController inscrEstadualCtrl;
  final TextEditingController inscrMunicipalCtrl;
  final TextEditingController inscrEstSubTribCtrl;

  final bool isLoadingCnpj;
  final String? cnpjErrorMessage;

  final bool Function(String campo) isCampoBloqueado;

  final Map<String, bool> openSections;
  final Function(String) toggle;

  const SectionDataWidget({
    super.key,
    required this.cnpjCtrl,
    required this.razaoSocialCtrl,
    required this.nomeFantasiaCtrl,
    required this.inscrEstadualCtrl,
    required this.inscrMunicipalCtrl,
    required this.inscrEstSubTribCtrl,
    required this.isLoadingCnpj,
    required this.cnpjErrorMessage,
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

  @override
  Widget build(BuildContext context) {
    return sectionDropdown(
      keyName: 'dados',
      title: 'Dados Cadastrais',
      openSections: openSections,
      toggle: toggle,
      children: [
        _cnpjField(),
        _spacing(),
        _textField(
          razaoSocialCtrl,
          'Razão Social',
          readOnly: isCampoBloqueado('razaoSocial'),
        ),
        _spacing(),
        _textField(
          nomeFantasiaCtrl,
          'Nome Fantasia',
          readOnly: isCampoBloqueado('nomeFantasia'),
        ),
        _spacing(),
        row([
          _textField(
            inscrEstadualCtrl,
            'Inscrição Estadual',
            readOnly: isCampoBloqueado('inscrEstadual'),
          ),
          _textField(inscrMunicipalCtrl, 'Inscrição Municipal'),
        ]),
        _spacing(),
        _textField(inscrEstSubTribCtrl, 'Inscr. Est. Subs. Tributária'),
      ],
    );
  }

  Widget _cnpjField() {
    return TextFormField(
      controller: cnpjCtrl,
      decoration: _dec('CNPJ').copyWith(
        suffixIcon:
            isLoadingCnpj
                ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                : null,
        hintText: '00.000.000/0000-00',
        helperText: cnpjErrorMessage,
        helperMaxLines: 2,
        errorText: cnpjErrorMessage,
        errorMaxLines: 2,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [CnpjInputFormatter()],
      maxLength: 18,
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
