import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/ui.dart';
import '../../../../model/models.dart';
import '../../cubit/auth_bloc_cubit.dart';
import '../../cubit/auth_bloc_state.dart';
import '../widget/row_widget.dart';
import '../widget/section_widget.dart';

class CreateCompaniesPage extends StatefulWidget {
  const CreateCompaniesPage({super.key});

  @override
  State<CreateCompaniesPage> createState() => _CreateCompaniesPageState();
}

class _CreateCompaniesPageState extends State<CreateCompaniesPage>
    with Messages<CreateCompaniesPage> {
  final _formKey = GlobalKey<FormState>();

  final codigoCtrl = TextEditingController();
  final cnpjCtrl = TextEditingController();
  final razaoSocialCtrl = TextEditingController();
  final nomeFantasiaCtrl = TextEditingController();

  final inscrEstadualCtrl = TextEditingController();
  final inscrMunicipalCtrl = TextEditingController();
  final inscrEstSubTribCtrl = TextEditingController();

  final cepCtrl = TextEditingController();
  final enderecoCtrl = TextEditingController();
  final numeroCtrl = TextEditingController();
  final complementoCtrl = TextEditingController();
  final bairroCtrl = TextEditingController();
  final cidadeCtrl = TextEditingController();
  final codCidadeCtrl = TextEditingController();
  final paisCtrl = TextEditingController(text: 'Brasil');

  final telefoneCtrl = TextEditingController();
  final faxCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final emailNfeCtrl = TextEditingController();
  final emailContadorCtrl = TextEditingController();
  final siteCtrl = TextEditingController();

  final usuarioApiCtrl = TextEditingController();
  final senhaApiCtrl = TextEditingController();
  final pathApiCtrl = TextEditingController();
  final atualizadorCtrl = TextEditingController();
  final certificadoCtrl = TextEditingController();

  final regimeIssqnCtrl = TextEditingController();
  final indRetIssqnCtrl = TextEditingController();

  final bcIrpjCtrl = TextEditingController();
  final aliqIrpjCtrl = TextEditingController();
  final valorExcedenteCtrl = TextEditingController();
  final excedentePercCtrl = TextEditingController();
  final bcCsllCtrl = TextEditingController();
  final aliqCsllCtrl = TextEditingController();
  final ibsUfCtrl = TextEditingController();
  final ibsMunCtrl = TextEditingController();
  final cbsCtrl = TextEditingController();

  final localBackupCtrl = TextEditingController();
  final localRemessaCtrl = TextEditingController();

  String situacao = 'ATIVO';
  String uf = 'SP';
  String pedeCertificado = 'NAO';
  String regimeTributario = 'RN';
  String ambiente = 'HOMOLOGACAO';

  bool get isSimplesNacional => regimeTributario == 'SN';
  bool get isExcessoOuNormal =>
      regimeTributario == 'SER' || regimeTributario == 'RN';

  final Map<String, bool> openSections = {
    'dados': true,
    'endereco': false,
    'contato': false,
    'fiscal': false,
    'tributario': false,
    'impostos': false,
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
  void dispose() {
    codigoCtrl.dispose();
    cnpjCtrl.dispose();
    razaoSocialCtrl.dispose();
    nomeFantasiaCtrl.dispose();
    inscrEstadualCtrl.dispose();
    inscrMunicipalCtrl.dispose();
    inscrEstSubTribCtrl.dispose();
    cepCtrl.dispose();
    enderecoCtrl.dispose();
    numeroCtrl.dispose();
    complementoCtrl.dispose();
    bairroCtrl.dispose();
    cidadeCtrl.dispose();
    codCidadeCtrl.dispose();
    paisCtrl.dispose();
    telefoneCtrl.dispose();
    faxCtrl.dispose();
    emailCtrl.dispose();
    emailNfeCtrl.dispose();
    emailContadorCtrl.dispose();
    siteCtrl.dispose();
    usuarioApiCtrl.dispose();
    senhaApiCtrl.dispose();
    pathApiCtrl.dispose();
    atualizadorCtrl.dispose();
    certificadoCtrl.dispose();
    regimeIssqnCtrl.dispose();
    indRetIssqnCtrl.dispose();
    bcIrpjCtrl.dispose();
    aliqIrpjCtrl.dispose();
    valorExcedenteCtrl.dispose();
    excedentePercCtrl.dispose();
    bcCsllCtrl.dispose();
    aliqCsllCtrl.dispose();
    ibsUfCtrl.dispose();
    ibsMunCtrl.dispose();
    cbsCtrl.dispose();
    localBackupCtrl.dispose();
    localRemessaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBlocCubit, AuthBlocState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Empresa criada com sucesso')),
          );
          Navigator.pop(context);
        }
        if (state.status == AuthStateStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Erro')));
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Form(
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
                          TextFormField(
                            controller: codigoCtrl,
                            decoration: _dec('Código'),
                          ),
                          DropdownButtonFormField(
                            value: situacao,
                            decoration: _dec('Situação'),
                            items: const [
                              DropdownMenuItem(
                                value: 'ATIVO',
                                child: Text('ATIVO'),
                              ),
                              DropdownMenuItem(
                                value: 'INATIVO',
                                child: Text('INATIVO'),
                              ),
                            ],
                            onChanged: (v) => setState(() => situacao = v!),
                          ),
                        ]),
                        TextFormField(
                          controller: cnpjCtrl,
                          decoration: _dec('CNPJ / CPF'),
                        ),
                        TextFormField(
                          controller: razaoSocialCtrl,
                          decoration: _dec('Razão Social'),
                        ),
                        TextFormField(
                          controller: nomeFantasiaCtrl,
                          decoration: _dec('Nome Fantasia'),
                        ),
                        row([
                          TextFormField(
                            controller: inscrEstadualCtrl,
                            decoration: _dec('Inscrição Estadual'),
                          ),
                          TextFormField(
                            controller: inscrMunicipalCtrl,
                            decoration: _dec('Inscrição Municipal'),
                          ),
                        ]),
                        TextFormField(
                          controller: inscrEstSubTribCtrl,
                          decoration: _dec('Inscr. Est. Subs. Tributária'),
                        ),
                      ],
                      openSections: openSections,
                      toggle: toggle,
                    ),
                    sectionDropdown(
                      keyName: 'endereco',
                      title: 'Endereço',
                      children: [
                        row([
                          TextFormField(
                            controller: cepCtrl,
                            decoration: _dec('CEP'),
                          ),
                          TextFormField(
                            controller: enderecoCtrl,
                            decoration: _dec('Endereço'),
                          ),
                          TextFormField(
                            controller: numeroCtrl,
                            decoration: _dec('Número'),
                          ),
                        ]),
                        row([
                          TextFormField(
                            controller: complementoCtrl,
                            decoration: _dec('Complemento'),
                          ),
                          TextFormField(
                            controller: bairroCtrl,
                            decoration: _dec('Bairro'),
                          ),
                        ]),
                        row([
                          TextFormField(
                            controller: cidadeCtrl,
                            decoration: _dec('Cidade'),
                          ),
                          TextFormField(
                            controller: codCidadeCtrl,
                            decoration: _dec('Código IBGE'),
                          ),
                          DropdownButtonFormField(
                            value: uf,
                            decoration: _dec('UF'),
                            items: const [
                              DropdownMenuItem(value: 'SP', child: Text('SP')),
                              DropdownMenuItem(value: 'RJ', child: Text('RJ')),
                            ],
                            onChanged: (v) => setState(() => uf = v!),
                          ),
                        ]),
                        TextFormField(
                          controller: paisCtrl,
                          decoration: _dec('País'),
                        ),
                      ],
                      openSections: openSections,
                      toggle: toggle,
                    ),
                    sectionDropdown(
                      keyName: 'contato',
                      title: 'Contato',
                      children: [
                        row([
                          TextFormField(
                            controller: telefoneCtrl,
                            decoration: _dec('Telefone'),
                          ),
                          TextFormField(
                            controller: faxCtrl,
                            decoration: _dec('FAX'),
                          ),
                        ]),
                        TextFormField(
                          controller: emailCtrl,
                          decoration: _dec('Email'),
                        ),
                        TextFormField(
                          controller: emailNfeCtrl,
                          decoration: _dec('Email p/ NFe'),
                        ),
                        TextFormField(
                          controller: emailContadorCtrl,
                          decoration: _dec('Email Contador'),
                        ),
                        TextFormField(
                          controller: siteCtrl,
                          decoration: _dec('Site'),
                        ),
                      ],
                      openSections: openSections,
                      toggle: toggle,
                    ),
                    sectionDropdown(
                      keyName: 'fiscal',
                      title: 'Fiscal / Sistema',
                      children: [
                        row([
                          TextFormField(
                            controller: usuarioApiCtrl,
                            decoration: _dec('Usuário API'),
                          ),
                          TextFormField(
                            controller: senhaApiCtrl,
                            decoration: _dec('Senha API'),
                          ),
                        ]),
                        TextFormField(
                          controller: pathApiCtrl,
                          decoration: _dec('Path API'),
                        ),
                        TextFormField(
                          controller: atualizadorCtrl,
                          decoration: _dec('Atualizador'),
                        ),
                        DropdownButtonFormField(
                          value: ambiente,
                          decoration: _dec('Ambiente'),
                          items: const [
                            DropdownMenuItem(
                              value: 'HOMOLOGACAO',
                              child: Text('Homologação'),
                            ),
                            DropdownMenuItem(
                              value: 'PRODUCAO',
                              child: Text('Produção'),
                            ),
                            DropdownMenuItem(
                              value: 'TESTE',
                              child: Text('Teste'),
                            ),
                          ],
                          onChanged: (v) => setState(() => ambiente = v!),
                        ),
                        DropdownButtonFormField(
                          value: pedeCertificado,
                          decoration: _dec('Pede Certificado'),
                          items: const [
                            DropdownMenuItem(value: 'SIM', child: Text('SIM')),
                            DropdownMenuItem(value: 'NAO', child: Text('NÃO')),
                          ],
                          onChanged:
                              (v) => setState(() => pedeCertificado = v!),
                        ),
                        TextFormField(
                          controller: certificadoCtrl,
                          decoration: _dec('Certificado'),
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
                          groupValue: regimeTributario,
                          onChanged:
                              (v) => setState(() => regimeTributario = v!),
                          title: const Text('Simples Nacional'),
                        ),
                        RadioListTile(
                          value: 'SER',
                          groupValue: regimeTributario,
                          onChanged:
                              (v) => setState(() => regimeTributario = v!),
                          title: const Text('Simples com Excesso de Receita'),
                        ),
                        RadioListTile(
                          value: 'RN',
                          groupValue: regimeTributario,
                          onChanged:
                              (v) => setState(() => regimeTributario = v!),
                          title: const Text('Regime Normal'),
                        ),
                        row([
                          TextFormField(
                            controller: regimeIssqnCtrl,
                            decoration: _dec('Regime Trib. ISSQN'),
                          ),
                          TextFormField(
                            controller: indRetIssqnCtrl,
                            decoration: _dec('Ind. Ret. ISSQN'),
                          ),
                        ]),
                      ],
                      openSections: openSections,
                      toggle: toggle,
                    ),
                    sectionDropdown(
                      keyName: 'impostos',
                      title: 'Alíquotas e Impostos',
                      children: [
                        if (isSimplesNacional)
                          row([
                            TextFormField(
                              controller: bcIrpjCtrl,
                              decoration: _dec('Alíquota'),
                            ),
                            TextFormField(
                              controller: cbsCtrl,
                              decoration: _dec('Cofins'),
                            ),
                            TextFormField(
                              controller: aliqIrpjCtrl,
                              decoration: _dec('PIS'),
                            ),
                            TextFormField(
                              controller: ibsUfCtrl,
                              decoration: _dec('ICMS'),
                            ),
                          ]),
                        if (isExcessoOuNormal) ...[
                          row([
                            TextFormField(
                              controller: bcIrpjCtrl,
                              decoration: _dec('BC IRPJ %'),
                            ),
                            TextFormField(
                              controller: aliqIrpjCtrl,
                              decoration: _dec('Alíquota IRPJ %'),
                            ),
                          ]),
                          row([
                            TextFormField(
                              controller: valorExcedenteCtrl,
                              decoration: _dec('Valor Excedente R\$'),
                            ),
                            TextFormField(
                              controller: excedentePercCtrl,
                              decoration: _dec('Excedente %'),
                            ),
                          ]),
                          row([
                            TextFormField(
                              controller: bcCsllCtrl,
                              decoration: _dec('BC CSLL %'),
                            ),
                            TextFormField(
                              controller: aliqCsllCtrl,
                              decoration: _dec('Alíquota CSLL %'),
                            ),
                          ]),
                          row([
                            TextFormField(
                              controller: ibsUfCtrl,
                              decoration: _dec('IBS UF %'),
                            ),
                            TextFormField(
                              controller: ibsMunCtrl,
                              decoration: _dec('IBS Mun %'),
                            ),
                            TextFormField(
                              controller: cbsCtrl,
                              decoration: _dec('CBS %'),
                            ),
                          ]),
                        ],
                        row([
                          TextFormField(
                            controller: localBackupCtrl,
                            decoration: _dec('Local Backup'),
                          ),
                          TextFormField(
                            controller: localRemessaCtrl,
                            decoration: _dec('Local Remessa'),
                          ),
                        ]),
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
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final revenueTaxDetails =
                                  regimeTributario == 'SN'
                                      ? RevenueTaxDetailsModel(
                                        aliquota: aliquotaCtrl.text,
                                        cofins: cofinsCtrl.text,
                                        pis: pisCtrl.text,
                                        icms: icmsCtrl.text,
                                        receitaBrutaAnual:
                                            receitaBrutaCtrl.text,
                                      )
                                      : RevenueTaxDetailsModel(
                                        bcIrpj: bcIrpjCtrl.text,
                                        bcCsll: bcCsllCtrl.text,
                                        aliquotaIrpj: aliqIrpjCtrl.text,
                                        aliquotaCsll: aliqCsllCtrl.text,
                                        ibsUf: ibsUfCtrl.text,
                                        ibsMun: ibsMunCtrl.text,
                                        cbs: cbsCtrl.text,
                                        over: excedentePercCtrl.text,
                                        valueOver: valorExcedenteCtrl.text,
                                      );
                              var companie = CreateEnterpriseModel(
                                document: cnpjCtrl.text,
                                socialReason: razaoSocialCtrl.text,
                                fantasyName: nomeFantasiaCtrl.text,
                                status: situacao,
                                phone: telefoneCtrl.text,
                                email: emailCtrl.text,
                                website: siteCtrl.text,
                                address: Address(
                                  cep: cepCtrl.text,
                                  street: enderecoCtrl.text,
                                  number: numeroCtrl.text,
                                  neighborhood: bairroCtrl.text,
                                  city: cidadeCtrl.text,
                                  country: 'Brasil',
                                  state: estadoCtrl.text,
                                  uf: uf,
                                  cityIbgeCode: ibgeCtrl.text,
                                ),
                                taxRegime: TaxRegimeModel(
                                  taxRegime:
                                      regimeTributario == 'SN'
                                          ? 'SIMPLE'
                                          : 'NORMAL',
                                  regimeTributarioIssqn: regimeIssqn,
                                  indRatIssqn: indRatIssqn,
                                ),
                                revenueTaxDetails: revenueTaxDetails,
                              );
                              context.read<AuthBlocCubit>().createCompanies(
                                companie: companie,
                              );
                            }
                          },
                          child: const Text('Gravar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (state.status == AuthStateStatus.loading)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
