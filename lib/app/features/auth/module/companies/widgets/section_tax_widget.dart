import 'package:flutter/material.dart';
import 'package:yachid/app/core/formatters/input_formatters.dart';

import '../../../../../core/widgets/widgets.dart';

class SectionTaxWidget extends StatelessWidget {
  final bool isSimplesNacional;
  final bool isExcessoOuNormal;

  final TextEditingController aliquotaCtrl;
  final TextEditingController cofinsCtrl;
  final TextEditingController pisCtrl;
  final TextEditingController icmsCtrl;
  final TextEditingController receitaBrutaCtrl;

  final TextEditingController bcIrpjCtrl;
  final TextEditingController aliqIrpjCtrl;
  final TextEditingController valorExcedenteCtrl;
  final TextEditingController excedentePercCtrl;
  final TextEditingController bcCsllCtrl;
  final TextEditingController aliqCsllCtrl;
  final TextEditingController ibsUfCtrl;
  final TextEditingController ibsMunCtrl;
  final TextEditingController cbsCtrl;

  final TextEditingController localBackupCtrl;
  final TextEditingController localRemessaCtrl;

  final Map<String, bool> openSections;
  final Function(String) toggle;
  const SectionTaxWidget({
    super.key,
    required this.isSimplesNacional,
    required this.isExcessoOuNormal,
    required this.aliquotaCtrl,
    required this.cofinsCtrl,
    required this.pisCtrl,
    required this.icmsCtrl,
    required this.receitaBrutaCtrl,
    required this.bcIrpjCtrl,
    required this.aliqIrpjCtrl,
    required this.valorExcedenteCtrl,
    required this.excedentePercCtrl,
    required this.bcCsllCtrl,
    required this.aliqCsllCtrl,
    required this.ibsUfCtrl,
    required this.ibsMunCtrl,
    required this.cbsCtrl,
    required this.localBackupCtrl,
    required this.localRemessaCtrl,
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
      keyName: 'impostos',
      title: 'Alíquotas e Impostos',
      openSections: openSections,
      toggle: toggle,
      children: [
        if (isSimplesNacional)
          row([
            _percentField(aliquotaCtrl, 'Alíquota'),
            _percentField(cofinsCtrl, 'Cofins'),
            _percentField(pisCtrl, 'PIS'),
            _percentField(icmsCtrl, 'ICMS'),
          ]),

        if (isSimplesNacional) ...[
          _spacing(),
          _valueField(receitaBrutaCtrl, 'Receita Bruta Anual'),
        ],

        if (isExcessoOuNormal) ...[
          row([
            _percentField(bcIrpjCtrl, 'BC IRPJ %'),
            _percentField(aliqIrpjCtrl, 'Alíquota IRPJ %'),
          ]),
          _spacing(),
          row([
            _currencyField(valorExcedenteCtrl, 'Valor Excedente R\$'),
            _percentField(excedentePercCtrl, 'Excedente %'),
          ]),
          _spacing(),
          row([
            _percentField(bcCsllCtrl, 'BC CSLL %'),
            _percentField(aliqCsllCtrl, 'Alíquota CSLL %'),
          ]),
          _spacing(),
          row([
            _percentField(ibsUfCtrl, 'IBS UF %'),
            _percentField(ibsMunCtrl, 'IBS Mun %'),
            _percentField(cbsCtrl, 'CBS %'),
          ]),
        ],

        _spacing(),
        row([
          _textField(localBackupCtrl, 'Local Backup'),
          _textField(localRemessaCtrl, 'Local Remessa'),
        ]),
      ],
    );
  }

  Widget _percentField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: _dec(label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [PercentageInputFormatter()],
    );
  }

  Widget _currencyField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: _dec(label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [CurrencyInputFormatter()],
    );
  }

  Widget _valueField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: _dec(label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [ValueInputFormatter()],
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return TextFormField(controller: controller, decoration: _dec(label));
  }
}
