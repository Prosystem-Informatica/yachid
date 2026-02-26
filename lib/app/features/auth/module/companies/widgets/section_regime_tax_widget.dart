import 'package:flutter/material.dart';

import '../../../../../core/widgets/widgets.dart';

class SectionRegimeTaxWidget extends StatelessWidget {
  final String regimeTributario;
  final bool Function(String campo) isCampoBloqueado;
  final Function(String) onChanged;

  final TextEditingController regimeIssqnCtrl;
  final TextEditingController indRetIssqnCtrl;

  final Map<String, bool> openSections;
  final Function(String) toggle;

  const SectionRegimeTaxWidget({
    super.key,
    required this.regimeTributario,
    required this.isCampoBloqueado,
    required this.onChanged,
    required this.regimeIssqnCtrl,
    required this.indRetIssqnCtrl,
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
      keyName: 'tributario',
      title: 'Regime Tributário',
      openSections: openSections,
      toggle: toggle,
      children: [
        _radioTile(value: 'SIMPLES_NACIONAL', title: 'Simples Nacional'),
        _spacing(),
        _radioTile(
          value: 'SIMPLES_EXCESSO_RECEITA',
          title: 'Simples com Excesso de Receita',
        ),
        _spacing(),
        _radioTile(value: 'NORMAL', title: 'Regime Normal'),
        _spacing(),
        row([
          _textField(regimeIssqnCtrl, 'Regime Trib. ISSQN'),
          _textField(indRetIssqnCtrl, 'Ind. Ret. ISSQN'),
        ]),
      ],
    );
  }

  Widget _radioTile({required String value, required String title}) {
    return RadioListTile<String>(
      value: value,
      groupValue: regimeTributario,
      onChanged:
          isCampoBloqueado('regimeTributario') ? null : (v) => onChanged(v!),
      title: Text(title),
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return TextFormField(controller: controller, decoration: _dec(label));
  }
}
