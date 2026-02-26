import 'package:flutter/material.dart';
import 'package:yachid/app/core/formatters/input_formatters.dart';

import '../../../../../core/widgets/widgets.dart';

class SectionContactWidget extends StatelessWidget {
  final TextEditingController telefoneCtrl;
  final TextEditingController faxCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController emailNfeCtrl;
  final TextEditingController emailContadorCtrl;
  final TextEditingController siteCtrl;

  final bool Function(String campo) isCampoBloqueado;

  final Map<String, bool> openSections;
  final Function(String) toggle;

  const SectionContactWidget({
    super.key,
    required this.telefoneCtrl,
    required this.faxCtrl,
    required this.emailCtrl,
    required this.emailNfeCtrl,
    required this.emailContadorCtrl,
    required this.siteCtrl,
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
      keyName: 'contato',
      title: 'Contato',
      openSections: openSections,
      toggle: toggle,
      children: [
        row([
          _phoneField(
            controller: telefoneCtrl,
            label: 'Telefone',
            readOnly: isCampoBloqueado('telefone'),
          ),
          _phoneField(controller: faxCtrl, label: 'FAX'),
        ]),
        _spacing(),
        _textField(
          controller: emailCtrl,
          label: 'Email',
          readOnly: isCampoBloqueado('email'),
        ),
        _spacing(),
        _textField(controller: emailNfeCtrl, label: 'Email p/ NFe'),
        _spacing(),
        _textField(controller: emailContadorCtrl, label: 'Email Contador'),
        _spacing(),
        _textField(controller: siteCtrl, label: 'Site'),
      ],
    );
  }

  Widget _phoneField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _dec(label),
      keyboardType: TextInputType.phone,
      inputFormatters: [PhoneInputFormatter()],
      maxLength: 15,
      readOnly: readOnly,
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _dec(label),
      readOnly: readOnly,
    );
  }
}
