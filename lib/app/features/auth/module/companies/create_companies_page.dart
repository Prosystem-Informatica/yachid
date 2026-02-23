import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/formatters/input_formatters.dart';
import '../../../../core/ui/ui.dart';
import '../../../../model/models.dart';
import '../../../../repository/cnpj/cnpj_repository.dart';
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

  final estadoCtrl = TextEditingController();
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

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
    );
  }

  String? _validatorObrigatorio(String? value, [String label = 'Campo']) {
    if (value == null || value.trim().isEmpty) {
      return '$label é obrigatório';
    }
    return null;
  }

  String? _validatorCnpj(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CNPJ é obrigatório';
    }
    final cnpjLimpo = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cnpjLimpo.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }
    return null;
  }

  String? _validatorEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Informe um email válido';
    }
    return null;
  }

  String? _validatorEmailOpcional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Informe um email válido';
    }
    return null;
  }

  String? _validatorCep(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CEP é obrigatório';
    }
    final cepLimpo = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cepLimpo.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }
    return null;
  }

  String? _validatorUrlOpcional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    if (!urlRegex.hasMatch(value.trim())) {
      return 'Informe uma URL válida';
    }
    return null;
  }

  String? _validatorNumeroOpcional(String? value, [String label = 'Campo']) {
    if (value == null || value.trim().isEmpty) return null;
    final valorLimpo = value
        .replaceAll(',', '.')
        .replaceAll(RegExp(r'[^\d.]'), '');
    if (valorLimpo.isEmpty) return null;
    final numero = double.tryParse(valorLimpo);
    if (numero == null || numero < 0) {
      return '$label deve ser um número válido';
    }
    return null;
  }

  Widget _spacing() => const SizedBox(height: 15);

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

      razaoSocialCtrl.text = cnpjData.name;
      if (cnpjData.alias != null && cnpjData.alias!.isNotEmpty) {
        nomeFantasiaCtrl.text = cnpjData.alias!;
      }

      if (cnpjData.status != null) {
        final statusUpper = cnpjData.status!.toUpperCase();
        if (statusUpper.contains('ATIVA')) {
          setState(() {
            situacao = 'ACTIVE';
          });
        } else if (statusUpper.contains('INATIVA')) {
          setState(() {
            situacao = 'INACTIVE';
          });
        }
      }

      if (cnpjData.simplesOptant) {
        setState(() {
          regimeTributario = 'SIMPLES_NACIONAL';
        });
      }

      if (cnpjData.address != null) {
        final address = cnpjData.address!;
        if (address.zip != null) {
          cepCtrl.text = address.zip!;
        }
        if (address.street != null) {
          enderecoCtrl.text = address.street!;
        }
        if (address.number != null) {
          numeroCtrl.text = address.number!;
        }
        if (address.district != null) {
          bairroCtrl.text = address.district!;
        }
        if (address.city != null) {
          cidadeCtrl.text = address.city!;
        }
        if (address.state != null) {
          setState(() {
            uf = address.state!;
          });
        }
      }

      if (cnpjData.phones != null && cnpjData.phones!.isNotEmpty) {
        telefoneCtrl.text = cnpjData.phones!.first.formatted;
      }

      if (cnpjData.emails != null && cnpjData.emails!.isNotEmpty) {
        emailCtrl.text = cnpjData.emails!.first.address ?? '';
      }

      if (cnpjData.registrations != null) {
        final enabledRegistration = cnpjData.registrations!.firstWhere(
          (r) => r.enabled == true,
          orElse: () => cnpjData.registrations!.first,
        );
        if (enabledRegistration.number != null) {
          inscrEstadualCtrl.text = enabledRegistration.number!;
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

      if (cnpjLimpo.length == 14 && !_isLoadingCnpj) {
        _buscarCnpj(cnpj);
      }
    });
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
    estadoCtrl.dispose();
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
          showError(state.errorMessage ?? 'Erro ao criar empresa');
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
                            validator: (v) => null,
                          ),
                          DropdownButtonFormField(
                            decoration: _dec('Situação'),
                            items: const [
                              DropdownMenuItem(
                                value: 'ACTIVE',
                                child: Text('ATIVO'),
                              ),
                              DropdownMenuItem(
                                value: 'INACTIVE',
                                child: Text('INATIVO'),
                              ),
                            ],
                            onChanged: (v) => setState(() => situacao = v!),
                          ),
                        ]),
                        _spacing(),
                        TextFormField(
                          controller: cnpjCtrl,
                          validator: _validatorCnpj,
                          decoration: _dec('CNPJ').copyWith(
                            suffixIcon:
                                _isLoadingCnpj
                                    ? const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                    : null,
                            hintText: '00.000.000/0000-00',
                            helperText: _cnpjErrorMessage,
                            helperMaxLines: 2,
                            errorText:
                                _cnpjErrorMessage != null
                                    ? _cnpjErrorMessage
                                    : null,
                            errorMaxLines: 2,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [CnpjInputFormatter()],
                          maxLength: 18,
                        ),
                        _spacing(),
                        TextFormField(
                          controller: razaoSocialCtrl,
                          decoration: _dec('Razão Social'),
                          validator:
                              (v) => _validatorObrigatorio(v, 'Razão Social'),
                        ),
                        _spacing(),
                        TextFormField(
                          controller: nomeFantasiaCtrl,
                          decoration: _dec('Nome Fantasia'),
                          validator:
                              (v) => _validatorObrigatorio(v, 'Nome Fantasia'),
                        ),
                        _spacing(),
                        row([
                          TextFormField(
                            controller: inscrEstadualCtrl,
                            decoration: _dec('Inscrição Estadual'),
                            validator: (v) => null,
                          ),
                          TextFormField(
                            controller: inscrMunicipalCtrl,
                            decoration: _dec('Inscrição Municipal'),
                            validator: (v) => null,
                          ),
                        ]),
                        _spacing(),
                        TextFormField(
                          controller: inscrEstSubTribCtrl,
                          decoration: _dec('Inscr. Est. Subs. Tributária'),
                          validator: (v) => null,
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
                            validator: _validatorCep,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CepInputFormatter()],
                            maxLength: 9,
                          ),
                          TextFormField(
                            controller: enderecoCtrl,
                            decoration: _dec('Endereço'),
                            validator:
                                (v) => _validatorObrigatorio(v, 'Endereço'),
                          ),
                          TextFormField(
                            controller: numeroCtrl,
                            decoration: _dec('Número'),
                            validator:
                                (v) => _validatorObrigatorio(v, 'Número'),
                          ),
                        ]),
                        _spacing(),
                        row([
                          TextFormField(
                            controller: complementoCtrl,
                            decoration: _dec('Complemento'),
                            validator: (v) => null,
                          ),
                          TextFormField(
                            controller: bairroCtrl,
                            decoration: _dec('Bairro'),
                            validator:
                                (v) => _validatorObrigatorio(v, 'Bairro'),
                          ),
                        ]),
                        _spacing(),
                        row([
                          TextFormField(
                            controller: cidadeCtrl,
                            decoration: _dec('Cidade'),
                            validator:
                                (v) => _validatorObrigatorio(v, 'Cidade'),
                          ),
                          TextFormField(
                            controller: ibgeCtrl,
                            decoration: _dec('Código IBGE'),
                            keyboardType: TextInputType.number,
                            inputFormatters: [NumbersOnlyFormatter()],
                            validator: (v) => null,
                          ),
                          DropdownButtonFormField(
                            decoration: _dec('UF'),
                            items: const [
                              DropdownMenuItem(value: 'SP', child: Text('SP')),
                              DropdownMenuItem(value: 'RJ', child: Text('RJ')),
                            ],
                            onChanged: (v) => setState(() => uf = v!),
                          ),
                        ]),
                        _spacing(),
                        TextFormField(
                          controller: estadoCtrl,
                          decoration: _dec('Estado'),
                          validator: (v) => null,
                        ),
                        _spacing(),
                        TextFormField(
                          controller: paisCtrl,
                          decoration: _dec('País'),
                          validator: (v) => _validatorObrigatorio(v, 'País'),
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
                            validator:
                                (v) => _validatorObrigatorio(v, 'Telefone'),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [PhoneInputFormatter()],
                            maxLength: 15,
                          ),
                          TextFormField(
                            controller: faxCtrl,
                            decoration: _dec('FAX'),
                            validator: (v) => null,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [PhoneInputFormatter()],
                            maxLength: 15,
                          ),
                        ]),
                        _spacing(),
                        TextFormField(
                          controller: emailCtrl,
                          decoration: _dec('Email'),
                          validator: _validatorEmail,
                        ),
                        _spacing(),
                        TextFormField(
                          controller: emailNfeCtrl,
                          decoration: _dec('Email p/ NFe'),
                          validator: _validatorEmailOpcional,
                        ),
                        _spacing(),
                        TextFormField(
                          controller: emailContadorCtrl,
                          decoration: _dec('Email Contador'),
                          validator: _validatorEmailOpcional,
                        ),
                        _spacing(),
                        TextFormField(
                          controller: siteCtrl,
                          decoration: _dec('Site'),
                          validator: _validatorUrlOpcional,
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
                            validator: (v) => null,
                          ),
                          TextFormField(
                            controller: senhaApiCtrl,
                            decoration: _dec('Senha API'),
                            validator: (v) => null,
                          ),
                        ]),
                        _spacing(),
                        TextFormField(
                          controller: pathApiCtrl,
                          decoration: _dec('Path API'),
                          validator: (v) => null,
                        ),
                        _spacing(),
                        TextFormField(
                          controller: atualizadorCtrl,
                          decoration: _dec('Atualizador'),
                          validator: (v) => null,
                        ),
                        _spacing(),
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
                        _spacing(),
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
                        _spacing(),
                        TextFormField(
                          controller: certificadoCtrl,
                          decoration: _dec('Certificado'),
                          validator: (v) => null,
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
                          value: 'SIMPLES_NACIONAL',
                          groupValue: regimeTributario,
                          onChanged:
                              (v) => setState(() => regimeTributario = v!),
                          title: const Text('Simples Nacional'),
                        ),
                        _spacing(),
                        RadioListTile(
                          value: 'SIMPLES_EXCESSO_RECEITA',
                          groupValue: regimeTributario,
                          onChanged:
                              (v) => setState(() => regimeTributario = v!),
                          title: const Text('Simples com Excesso de Receita'),
                        ),
                        _spacing(),
                        RadioListTile(
                          value: 'NORMAL',
                          groupValue: regimeTributario,
                          onChanged:
                              (v) => setState(() => regimeTributario = v!),
                          title: const Text('Regime Normal'),
                        ),
                        _spacing(),
                        row([
                          TextFormField(
                            controller: regimeIssqnCtrl,
                            decoration: _dec('Regime Trib. ISSQN'),
                            validator: (v) => null,
                          ),
                          TextFormField(
                            controller: indRetIssqnCtrl,
                            decoration: _dec('Ind. Ret. ISSQN'),
                            validator: (v) => null,
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
                              controller: aliquotaCtrl,
                              decoration: _dec('Alíquota'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(
                                      limpo,
                                      'Alíquota',
                                    );
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                            TextFormField(
                              controller: cofinsCtrl,
                              decoration: _dec('Cofins'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(limpo, 'Cofins');
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                            TextFormField(
                              controller: pisCtrl,
                              decoration: _dec('PIS'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(limpo, 'PIS');
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                            TextFormField(
                              controller: icmsCtrl,
                              decoration: _dec('ICMS'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(limpo, 'ICMS');
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                          ]),
                        if (isSimplesNacional) ...[
                          _spacing(),
                          TextFormField(
                            controller: receitaBrutaCtrl,
                            decoration: _dec('Receita Bruta Anual'),
                            validator: (v) {
                              final limpo =
                                  ValueInputFormatter.getValueAsString(v ?? '');
                              return limpo.isEmpty || limpo == '0'
                                  ? null
                                  : _validatorNumeroOpcional(
                                    limpo,
                                    'Receita Bruta Anual',
                                  );
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [ValueInputFormatter()],
                          ),
                        ],
                        if (isExcessoOuNormal) ...[
                          row([
                            TextFormField(
                              controller: bcIrpjCtrl,
                              decoration: _dec('BC IRPJ %'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(
                                      limpo,
                                      'BC IRPJ',
                                    );
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                            TextFormField(
                              controller: aliqIrpjCtrl,
                              decoration: _dec('Alíquota IRPJ %'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(
                                      limpo,
                                      'Alíquota IRPJ',
                                    );
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                          ]),
                          _spacing(),
                          row([
                            TextFormField(
                              controller: valorExcedenteCtrl,
                              decoration: _dec('Valor Excedente R\$'),
                              validator: (v) {
                                final limpo = _removeCurrency(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(
                                      limpo,
                                      'Valor Excedente',
                                    );
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [CurrencyInputFormatter()],
                            ),
                            TextFormField(
                              controller: excedentePercCtrl,
                              decoration: _dec('Excedente %'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(
                                      limpo,
                                      'Excedente',
                                    );
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                          ]),
                          _spacing(),
                          row([
                            TextFormField(
                              controller: bcCsllCtrl,
                              decoration: _dec('BC CSLL %'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(
                                      limpo,
                                      'BC CSLL',
                                    );
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                            TextFormField(
                              controller: aliqCsllCtrl,
                              decoration: _dec('Alíquota CSLL %'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(
                                      limpo,
                                      'Alíquota CSLL',
                                    );
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                          ]),
                          _spacing(),
                          row([
                            TextFormField(
                              controller: ibsUfCtrl,
                              decoration: _dec('IBS UF %'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(limpo, 'IBS UF');
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                            TextFormField(
                              controller: ibsMunCtrl,
                              decoration: _dec('IBS Mun %'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(
                                      limpo,
                                      'IBS Mun',
                                    );
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                            TextFormField(
                              controller: cbsCtrl,
                              decoration: _dec('CBS %'),
                              validator: (v) {
                                final limpo = _removePercentage(v ?? '');
                                return limpo.isEmpty
                                    ? null
                                    : _validatorNumeroOpcional(limpo, 'CBS');
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [PercentageInputFormatter()],
                            ),
                          ]),
                        ],
                        _spacing(),
                        row([
                          TextFormField(
                            controller: localBackupCtrl,
                            decoration: _dec('Local Backup'),
                            validator: (v) => null,
                          ),
                          TextFormField(
                            controller: localRemessaCtrl,
                            decoration: _dec('Local Remessa'),
                            validator: (v) => null,
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
                            if (_formKey.currentState?.validate() ?? false) {
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
                                  state: estadoCtrl.text,
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
