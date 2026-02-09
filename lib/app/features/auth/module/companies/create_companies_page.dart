import 'package:flutter/material.dart';

import '../widget/row_widget.dart';
import '../widget/section_widget.dart';

class CreateCompaniesPage extends StatefulWidget {
  const CreateCompaniesPage({super.key});

  @override
  State<CreateCompaniesPage> createState() => _CreateCompaniesPageState();
}

class _CreateCompaniesPageState extends State<CreateCompaniesPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, bool> openSections = {
    'dados': true,
    'endereco': false,
    'contato': false,
    'fiscal': false,
    'tributario': false,
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            sectionDropdown(
              keyName: 'dados',
              title: 'Dados Cadastrais',
              children: [
                row([
                  TextFormField(decoration: _dec('Código')),
                  DropdownButtonFormField(
                    decoration: _dec('Situação'),
                    items: const [
                      DropdownMenuItem(value: 'ATIVO', child: Text('ATIVO')),
                      DropdownMenuItem(
                        value: 'INATIVO',
                        child: Text('INATIVO'),
                      ),
                    ],
                    onChanged: (_) {},
                  ),
                ]),
                row([
                  TextFormField(decoration: _dec('CNPJ / CPF')),
                  TextFormField(decoration: _dec('Inscrição Estadual')),
                  TextFormField(decoration: _dec('Inscrição Municipal')),
                ]),
                TextFormField(decoration: _dec('Razão Social')),
                const SizedBox(height: 12),
                TextFormField(decoration: _dec('Nome Fantasia')),
              ],
              openSections: openSections,
              toggle: toggle,
            ),

            sectionDropdown(
              keyName: 'endereco',
              title: 'Endereço',
              children: [
                row([
                  TextFormField(decoration: _dec('CEP')),
                  TextFormField(decoration: _dec('Endereço')),
                  TextFormField(decoration: _dec('Número')),
                ]),
                row([
                  TextFormField(decoration: _dec('Complemento')),
                  TextFormField(decoration: _dec('Bairro')),
                ]),
                row([
                  TextFormField(decoration: _dec('Cidade')),
                  DropdownButtonFormField(
                    decoration: _dec('UF'),
                    items: const [
                      DropdownMenuItem(value: 'SP', child: Text('SP')),
                      DropdownMenuItem(value: 'RJ', child: Text('RJ')),
                    ],
                    onChanged: (_) {},
                  ),
                ]),
              ],
              openSections: openSections,
              toggle: toggle,
            ),

            sectionDropdown(
              keyName: 'contato',
              title: 'Contato',
              children: [
                row([
                  TextFormField(decoration: _dec('Telefone')),
                  TextFormField(decoration: _dec('Email')),
                ]),
                TextFormField(decoration: _dec('Email para NFe')),
                TextFormField(decoration: _dec('Site')),
              ],
              openSections: openSections,
              toggle: toggle,
            ),

            sectionDropdown(
              keyName: 'fiscal',
              title: 'Fiscal / Certificado',
              children: [
                row([
                  TextFormField(decoration: _dec('Usuário API')),
                  TextFormField(decoration: _dec('Senha API')),
                ]),
                TextFormField(decoration: _dec('Path API')),
                DropdownButtonFormField(
                  decoration: _dec('Pede Certificado'),
                  items: const [
                    DropdownMenuItem(value: 'SIM', child: Text('SIM')),
                    DropdownMenuItem(value: 'NAO', child: Text('NÃO')),
                  ],
                  onChanged: (_) {},
                ),
              ],
              openSections: openSections,
              toggle: toggle,
            ),

            sectionDropdown(
              keyName: 'tributario',
              title: 'Regime Tributário',
              children: [
                RadioListTile(
                  value: 'SN',
                  groupValue: 'RN',
                  onChanged: (_) {},
                  title: const Text('Simples Nacional'),
                ),
                RadioListTile(
                  value: 'SER',
                  groupValue: 'RN',
                  onChanged: (_) {},
                  title: const Text('Simples com Excesso de Receita'),
                ),
                RadioListTile(
                  value: 'RN',
                  groupValue: 'RN',
                  onChanged: (_) {},
                  title: const Text('Regime Normal'),
                ),
              ],
              openSections: openSections,
              toggle: toggle,
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
                ElevatedButton(onPressed: () {}, child: const Text('Gravar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
