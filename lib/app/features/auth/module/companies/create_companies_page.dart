import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/auth/module/companies/widgets/section_address_widget.dart';
import 'package:yachid/app/features/auth/module/companies/widgets/section_contact_widget.dart';
import 'package:yachid/app/features/auth/module/companies/widgets/section_data_widget.dart';
import 'package:yachid/app/features/auth/module/companies/widgets/section_regime_tax_widget.dart';
import 'package:yachid/app/features/auth/module/companies/widgets/section_tax_widget.dart';

import '../../../../core/formatters/input_formatters.dart';
import '../../../../core/ui/ui.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../model/models.dart';
import '../../../../repository/cnpj/cnpj_repository.dart';
import '../../cubit/auth_bloc_cubit.dart';
import '../../cubit/auth_bloc_state.dart';

class CreateCompaniesPage extends StatefulWidget {
  const CreateCompaniesPage({super.key});

  @override
  State<CreateCompaniesPage> createState() => _CreateCompaniesPageState();
}

class _CreateCompaniesPageState extends State<CreateCompaniesPage>
    with Messages<CreateCompaniesPage> {
  final _formKey = GlobalKey<FormState>();

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

  final aliquotaCtrl = TextEditingController();
  final cofinsCtrl = TextEditingController();
  final pisCtrl = TextEditingController();
  final icmsCtrl = TextEditingController();
  final receitaBrutaCtrl = TextEditingController();

  final ibgeCtrl = TextEditingController();

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

  final _cnpjRepository = CnpjRepository();
  bool _isLoadingCnpj = false;
  String? _cnpjErrorMessage;

  // Rastreia quais campos foram preenchidos pela busca do CNPJ
  final Set<String> _camposPreenchidosCnpj = {};

  String situacao = 'ACTIVE';
  String uf = 'SP';
  String pedeCertificado = 'NAO';
  String regimeTributario = 'SIMPLES_NACIONAL';
  String ambiente = 'HOMOLOGACAO';

  bool get isSimplesNacional => regimeTributario == 'SIMPLES_NACIONAL';
  bool get isExcessoOuNormal =>
      regimeTributario == 'SIMPLES_EXCESSO_RECEITA' ||
      regimeTributario == 'NORMAL';

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

  bool _isCampoBloqueado(String campo) {
    return _camposPreenchidosCnpj.contains(campo);
  }

  String _getNomeEstado(String uf) {
    const estados = {
      'AC': 'Acre',
      'AL': 'Alagoas',
      'AP': 'Amapá',
      'AM': 'Amazonas',
      'BA': 'Bahia',
      'CE': 'Ceará',
      'DF': 'Distrito Federal',
      'ES': 'Espírito Santo',
      'GO': 'Goiás',
      'MA': 'Maranhão',
      'MT': 'Mato Grosso',
      'MS': 'Mato Grosso do Sul',
      'MG': 'Minas Gerais',
      'PA': 'Pará',
      'PB': 'Paraíba',
      'PR': 'Paraná',
      'PE': 'Pernambuco',
      'PI': 'Piauí',
      'RJ': 'Rio de Janeiro',
      'RN': 'Rio Grande do Norte',
      'RS': 'Rio Grande do Sul',
      'RO': 'Rondônia',
      'RR': 'Roraima',
      'SC': 'Santa Catarina',
      'SP': 'São Paulo',
      'SE': 'Sergipe',
      'TO': 'Tocantins',
    };
    return estados[uf] ?? '';
  }

  String _removePercentage(String text) {
    return text
        .replaceAll('%', '')
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll(',', '.');
  }

  String _removeCurrency(String text) {
    return text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll(',', '.');
  }

  String _validarRegimeTributario() {
    if (regimeTributario == 'SIMPLES_NACIONAL') {
      return 'SIMPLES_NACIONAL';
    }

    if (regimeTributario == 'SIMPLES_EXCESSO_RECEITA') {
      return 'SIMPLES_EXCESSO_RECEITA';
    }

    if (regimeTributario == 'NORMAL') {
      return 'NORMAL';
    }

    return 'NORMAL';
  }

  Future<void> _buscarCnpj(String cnpj) async {
    final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^\d]'), '');

    if (cnpjLimpo.length != 14) {
      setState(() {
        _cnpjErrorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoadingCnpj = true;
      _cnpjErrorMessage = null;
    });

    try {
      final cnpjData = await _cnpjRepository.consultarCnpj(cnpj: cnpjLimpo);

      // Limpa os campos preenchidos anteriormente
      _camposPreenchidosCnpj.clear();

      if (cnpjData.name.isNotEmpty) {
        razaoSocialCtrl.text = cnpjData.name;
        _camposPreenchidosCnpj.add('razaoSocial');
      }
      if (cnpjData.alias != null && cnpjData.alias!.isNotEmpty) {
        nomeFantasiaCtrl.text = cnpjData.alias!;
        _camposPreenchidosCnpj.add('nomeFantasia');
      }

      if (cnpjData.status != null) {
        final statusUpper = cnpjData.status!.toUpperCase();
        if (statusUpper.contains('ATIVA')) {
          setState(() {
            situacao = 'ACTIVE';
            _camposPreenchidosCnpj.add('situacao');
          });
        } else if (statusUpper.contains('INATIVA')) {
          setState(() {
            situacao = 'INACTIVE';
            _camposPreenchidosCnpj.add('situacao');
          });
        }
      }

      if (cnpjData.simplesOptant) {
        setState(() {
          regimeTributario = 'SIMPLES_NACIONAL';
          _camposPreenchidosCnpj.add('regimeTributario');
        });
      }

      if (cnpjData.address != null) {
        final address = cnpjData.address!;
        if (address.zip != null && address.zip!.isNotEmpty) {
          cepCtrl.text = address.zip!;
          _camposPreenchidosCnpj.add('cep');
        }
        if (address.street != null && address.street!.isNotEmpty) {
          enderecoCtrl.text = address.street!;
          _camposPreenchidosCnpj.add('endereco');
        }
        if (address.number != null && address.number!.isNotEmpty) {
          numeroCtrl.text = address.number!;
          _camposPreenchidosCnpj.add('numero');
        }
        if (address.district != null && address.district!.isNotEmpty) {
          bairroCtrl.text = address.district!;
          _camposPreenchidosCnpj.add('bairro');
        }
        if (address.city != null && address.city!.isNotEmpty) {
          cidadeCtrl.text = address.city!;
          _camposPreenchidosCnpj.add('cidade');
        }
        if (address.state != null && address.state!.isNotEmpty) {
          setState(() {
            uf = address.state!;
            _camposPreenchidosCnpj.add('uf');
          });
        }
      }

      if (cnpjData.phones != null && cnpjData.phones!.isNotEmpty) {
        telefoneCtrl.text = cnpjData.phones!.first.formatted;
        _camposPreenchidosCnpj.add('telefone');
      }

      if (cnpjData.emails != null && cnpjData.emails!.isNotEmpty) {
        emailCtrl.text = cnpjData.emails!.first.address ?? '';
        _camposPreenchidosCnpj.add('email');
      }

      if (cnpjData.registrations != null) {
        final enabledRegistration = cnpjData.registrations!.firstWhere(
          (r) => r.enabled == true,
          orElse: () => cnpjData.registrations!.first,
        );
        if (enabledRegistration.number != null &&
            enabledRegistration.number!.isNotEmpty) {
          inscrEstadualCtrl.text = enabledRegistration.number!;
          _camposPreenchidosCnpj.add('inscrEstadual');
        }
      }

      if (mounted) {
        setState(() {
          _cnpjErrorMessage = null;
        });
      }
    } catch (e) {
      if (mounted && cnpjLimpo.length == 14) {
        setState(() {
          _cnpjErrorMessage = 'CPNJ inválido';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCnpj = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    cnpjCtrl.addListener(() {
      final cnpj = cnpjCtrl.text;
      final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^\d]'), '');

      if (_cnpjErrorMessage != null) {
        setState(() {
          _cnpjErrorMessage = null;
        });
      }

      // Se o CNPJ foi limpo ou alterado, desbloqueia todos os campos
      if (cnpjLimpo.length < 14) {
        setState(() {
          _camposPreenchidosCnpj.clear();
        });
      }

      if (cnpjLimpo.length == 14 && !_isLoadingCnpj) {
        _buscarCnpj(cnpj);
      }
    });
  }

  @override
  void dispose() {
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
    aliquotaCtrl.dispose();
    cofinsCtrl.dispose();
    pisCtrl.dispose();
    icmsCtrl.dispose();
    receitaBrutaCtrl.dispose();
    ibgeCtrl.dispose();
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
          showSuccess('Empresa criada com sucesso');
          Navigator.pop(context);
        }
        if (state.status == AuthStateStatus.error) {
          showError('Erro ao criar empresa');
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
                    SectionDataWidget(
                      cnpjCtrl: cnpjCtrl,
                      razaoSocialCtrl: razaoSocialCtrl,
                      nomeFantasiaCtrl: nomeFantasiaCtrl,
                      inscrEstadualCtrl: inscrEstadualCtrl,
                      inscrMunicipalCtrl: inscrMunicipalCtrl,
                      inscrEstSubTribCtrl: inscrEstSubTribCtrl,
                      isLoadingCnpj: _isLoadingCnpj,
                      cnpjErrorMessage: _cnpjErrorMessage,
                      isCampoBloqueado: _isCampoBloqueado,
                      openSections: openSections,
                      toggle: toggle,
                    ),
                    SectionAddressWidget(
                      cepCtrl: cepCtrl,
                      enderecoCtrl: enderecoCtrl,
                      numeroCtrl: numeroCtrl,
                      complementoCtrl: complementoCtrl,
                      bairroCtrl: bairroCtrl,
                      cidadeCtrl: cidadeCtrl,
                      ibgeCtrl: ibgeCtrl,
                      paisCtrl: paisCtrl,
                      uf: uf,
                      onUfChanged: (value) {
                        setState(() {
                          uf = value ?? 'SP';
                        });
                      },
                      isCampoBloqueado: _isCampoBloqueado,
                      openSections: openSections,
                      toggle: toggle,
                    ),
                    SectionContactWidget(
                      telefoneCtrl: telefoneCtrl,
                      faxCtrl: faxCtrl,
                      emailCtrl: emailCtrl,
                      emailNfeCtrl: emailNfeCtrl,
                      emailContadorCtrl: emailContadorCtrl,
                      siteCtrl: siteCtrl,
                      isCampoBloqueado: _isCampoBloqueado,
                      openSections: openSections,
                      toggle: toggle,
                    ),
                    SectionRegimeTaxWidget(
                      regimeTributario: regimeTributario,
                      isCampoBloqueado: _isCampoBloqueado,
                      onChanged: (value) {
                        setState(() {
                          regimeTributario = value;
                        });
                      },
                      regimeIssqnCtrl: regimeIssqnCtrl,
                      indRetIssqnCtrl: indRetIssqnCtrl,
                      openSections: openSections,
                      toggle: toggle,
                    ),
                    SectionTaxWidget(
                      isSimplesNacional: isSimplesNacional,
                      isExcessoOuNormal: isExcessoOuNormal,
                      aliquotaCtrl: aliquotaCtrl,
                      cofinsCtrl: cofinsCtrl,
                      pisCtrl: pisCtrl,
                      icmsCtrl: icmsCtrl,
                      receitaBrutaCtrl: receitaBrutaCtrl,
                      bcIrpjCtrl: bcIrpjCtrl,
                      aliqIrpjCtrl: aliqIrpjCtrl,
                      valorExcedenteCtrl: valorExcedenteCtrl,
                      excedentePercCtrl: excedentePercCtrl,
                      bcCsllCtrl: bcCsllCtrl,
                      aliqCsllCtrl: aliqCsllCtrl,
                      ibsUfCtrl: ibsUfCtrl,
                      ibsMunCtrl: ibsMunCtrl,
                      cbsCtrl: cbsCtrl,
                      localBackupCtrl: localBackupCtrl,
                      localRemessaCtrl: localRemessaCtrl,
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
                                  regimeTributario == 'SIMPLES_NACIONAL'
                                      ? RevenueTaxDetailsModel(
                                        aliquota: _removePercentage(
                                          aliquotaCtrl.text,
                                        ),
                                        cofins: _removePercentage(
                                          cofinsCtrl.text,
                                        ),
                                        pis: _removePercentage(pisCtrl.text),
                                        icms: _removePercentage(icmsCtrl.text),
                                        receitaBrutaAnual:
                                            ValueInputFormatter.getValueAsString(
                                              receitaBrutaCtrl.text,
                                            ),
                                      )
                                      : RevenueTaxDetailsModel(
                                        bcIrpj: _removePercentage(
                                          bcIrpjCtrl.text,
                                        ),
                                        bcCsll: _removePercentage(
                                          bcCsllCtrl.text,
                                        ),
                                        aliquotaIrpj: _removePercentage(
                                          aliqIrpjCtrl.text,
                                        ),
                                        aliquotaCsll: _removePercentage(
                                          aliqCsllCtrl.text,
                                        ),
                                        ibsUf: _removePercentage(
                                          ibsUfCtrl.text,
                                        ),
                                        ibsMun: _removePercentage(
                                          ibsMunCtrl.text,
                                        ),
                                        cbs: _removePercentage(cbsCtrl.text),
                                        over: _removePercentage(
                                          excedentePercCtrl.text,
                                        ),
                                        valueOver: _removeCurrency(
                                          valorExcedenteCtrl.text,
                                        ),
                                      );
                              var companie = CreateEnterpriseModel(
                                document: cnpjCtrl.text.replaceAll(
                                  RegExp(r'[^\d]'),
                                  '',
                                ),
                                socialReason: razaoSocialCtrl.text,
                                fantasyName: nomeFantasiaCtrl.text,
                                status: situacao,
                                phone: telefoneCtrl.text.replaceAll(
                                  RegExp(r'[^\d]'),
                                  '',
                                ),
                                email: emailCtrl.text,
                                website: siteCtrl.text,
                                address: Address(
                                  cep: cepCtrl.text.replaceAll(
                                    RegExp(r'[^\d]'),
                                    '',
                                  ),
                                  street: enderecoCtrl.text,
                                  number: numeroCtrl.text,
                                  neighborhood: bairroCtrl.text,
                                  city: cidadeCtrl.text,
                                  country: 'Brasil',
                                  state: _getNomeEstado(uf),
                                  uf: uf,
                                  cityIbgeCode: ibgeCtrl.text.replaceAll(
                                    RegExp(r'[^\d]'),
                                    '',
                                  ),
                                ),
                                taxRegime: TaxRegimeModel(
                                  taxRegime: _validarRegimeTributario(),
                                  regimeTributarioIssqn: regimeIssqnCtrl.text,
                                  indRatIssqn: indRetIssqnCtrl.text,
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
