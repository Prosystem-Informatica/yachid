import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/helpers/environments.dart';
import 'package:yachid/app/core/rest/http/http_rest_client.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/representatives/cubit/representatives_cubit.dart';
import 'package:yachid/app/features/home/module/representatives/model/create_representative_dto.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_address_dto.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_detail.dart';
import 'package:yachid/app/features/home/module/representatives/model/update_representative_dto.dart';
import 'package:yachid/app/repository/cep/cep_repository.dart';

class RepresentativeRegisterCard extends StatefulWidget {
  const RepresentativeRegisterCard({
    super.key,
    this.representativeId,
    this.onSaved,
    this.onUpdated,
    this.onCancel,
  });

  final String? representativeId;
  final ValueChanged<CreateRepresentativeDto>? onSaved;
  final void Function(String id, UpdateRepresentativeDto dto)? onUpdated;
  final VoidCallback? onCancel;

  @override
  State<RepresentativeRegisterCard> createState() =>
      _RepresentativeRegisterCardState();
}

class _RepresentativeRegisterCardState
    extends State<RepresentativeRegisterCard> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _celularController = TextEditingController();
  final _documentoController = TextEditingController();
  final _ieRgController = TextEditingController();
  final _contatoController = TextEditingController();
  final _emailController = TextEditingController();
  final _comissaoController = TextEditingController(text: '0');
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController(text: 'Brasil');
  final _ufController = TextEditingController();
  final _cepRepository = CepRepository(
    rest: HttpRestClient(
      baseUrl: Environments.get('BASE_URL') ?? "",
      env: Environments.get('ENV') ?? "",
      port: Environments.get('PORT') ?? "",
    ),
  );

  TipoComissao? _tipoComissao = TipoComissao.semComissao;
  bool _status = true;
  bool _prePedido = false;
  bool _aplicativo = false;
  bool _includeAddress = false;
  bool _isLoading = false;
  bool _initialLoading = false;
  bool _isLoadingCep = false;
  String? _cepErrorMessage;
  bool _isStreetReadOnly = false;
  bool _isNeighborhoodReadOnly = false;
  bool _isCityReadOnly = false;
  bool _isUfReadOnly = false;
  bool _isComplementReadOnly = false;

  bool get _isEditMode => widget.representativeId != null;

  @override
  void initState() {
    super.initState();
    _cepController.addListener(() {
      final cepLimpo = _cepController.text.replaceAll(RegExp(r'[^\d]'), '');
      if (_cepErrorMessage != null && cepLimpo.length < 8) {
        setState(() => _cepErrorMessage = null);
      }
      if (cepLimpo.length < 8) {
        _resetApiReadOnly();
      }
      if (cepLimpo.length == 8 && !_isLoadingCep) {
        _buscarCep(cepLimpo);
      }
    });
    if (_isEditMode) {
      _loadDetail();
    }
  }

  void _resetApiReadOnly() {
    setState(() {
      _isStreetReadOnly = false;
      _isNeighborhoodReadOnly = false;
      _isCityReadOnly = false;
      _isUfReadOnly = false;
      _isComplementReadOnly = false;
    });
  }

  void _applyApiValue({
    required TextEditingController controller,
    required String? value,
    required ValueChanged<bool> setReadOnly,
  }) {
    final normalized = value?.trim() ?? '';
    if (normalized.isNotEmpty) {
      controller.text = normalized;
      setReadOnly(true);
    } else {
      setReadOnly(false);
    }
  }

  Future<void> _buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^\d]'), '');
    if (cepLimpo.length != 8) return;

    setState(() {
      _isLoadingCep = true;
      _cepErrorMessage = null;
    });

    try {
      final token = context.read<AuthBlocCubit>().state.authModel.token ?? '';
      final data = await _cepRepository.lookupCep(cep: cepLimpo, token: token);
      setState(() {
        _applyApiValue(
          controller: _streetController,
          value: data.logradouro,
          setReadOnly: (v) => _isStreetReadOnly = v,
        );
        _applyApiValue(
          controller: _neighborhoodController,
          value: data.bairro,
          setReadOnly: (v) => _isNeighborhoodReadOnly = v,
        );
        _applyApiValue(
          controller: _cityController,
          value: data.localidade,
          setReadOnly: (v) => _isCityReadOnly = v,
        );
        _applyApiValue(
          controller: _ufController,
          value: data.uf,
          setReadOnly: (v) => _isUfReadOnly = v,
        );
        _applyApiValue(
          controller: _complementController,
          value: data.complemento,
          setReadOnly: (v) => _isComplementReadOnly = v,
        );
      });
    } catch (_) {
      if (mounted && cepLimpo.length == 8) {
        setState(() {
          _cepErrorMessage = 'CEP inválido ou não encontrado';
          _isStreetReadOnly = false;
          _isNeighborhoodReadOnly = false;
          _isCityReadOnly = false;
          _isUfReadOnly = false;
          _isComplementReadOnly = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingCep = false);
      }
    }
  }

  Future<void> _loadDetail() async {
    setState(() => _initialLoading = true);
    final authModel = context.read<AuthBlocCubit>().state.authModel;
    final detail = await context
        .read<RepresentativesCubit>()
        .loadRepresentativeDetail(
          id: widget.representativeId!,
          token: authModel.token ?? '',
        );
    if (!mounted) return;
    setState(() {
      _initialLoading = false;
      if (detail != null) {
        _fillForm(detail);
      }
    });
  }

  void _fillForm(RepresentativeDetail d) {
    _nomeController.text = d.nome;
    _telefoneController.text = d.telefone ?? '';
    _celularController.text = d.celular ?? '';
    _documentoController.text = d.documento ?? '';
    _ieRgController.text = d.ieRg ?? '';
    _contatoController.text = d.contato ?? '';
    _emailController.text = d.email ?? '';
    _comissaoController.text = d.comissao.toString();
    _tipoComissao = d.tipoComissao;
    _status = d.status;
    _prePedido = d.prePedido;
    _aplicativo = d.aplicativo;
    if (d.address != null) {
      _includeAddress = true;
      _cepController.text = d.address!.cep;
      _streetController.text = d.address!.street;
      _numberController.text = d.address!.number;
      _complementController.text = d.address!.complement ?? '';
      _neighborhoodController.text = d.address!.neighborhood;
      _cityController.text = d.address!.city;
      _countryController.text = d.address!.country;
      _ufController.text = d.address!.uf;
    }
  }

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.gray300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      isDense: true,
    );
  }

  Widget _apiLockedSuffix(bool isReadOnly) {
    if (!isReadOnly) return const SizedBox.shrink();
    return const Tooltip(
      message: 'Preenchido automaticamente pela API de CEP',
      child: Icon(Icons.lock_rounded, size: 18, color: AppColors.gray600),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    RepresentativeAddressDto? address;
    if (_includeAddress &&
        _cepController.text.trim().isNotEmpty &&
        _streetController.text.trim().isNotEmpty &&
        _numberController.text.trim().isNotEmpty &&
        _neighborhoodController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty &&
        _ufController.text.trim().isNotEmpty) {
      address = RepresentativeAddressDto(
        cep: _cepController.text.trim(),
        street: _streetController.text.trim(),
        number: _numberController.text.trim(),
        complement:
            _complementController.text.trim().isEmpty
                ? null
                : _complementController.text.trim(),
        neighborhood: _neighborhoodController.text.trim(),
        city: _cityController.text.trim(),
        country:
            _countryController.text.trim().isEmpty
                ? 'Brasil'
                : _countryController.text.trim(),
        uf: _ufController.text.trim(),
      );
    }

    final authModel = context.read<AuthBlocCubit>().state.authModel;
    final token = authModel.token ?? '';

    if (_isEditMode) {
      final dto = UpdateRepresentativeDto(
        nome: _nomeController.text.trim(),
        telefone:
            _telefoneController.text.trim().isEmpty
                ? null
                : _telefoneController.text.trim(),
        celular:
            _celularController.text.trim().isEmpty
                ? null
                : _celularController.text.trim(),
        comissao: double.tryParse(
          _comissaoController.text.replaceAll(',', '.'),
        ),
        status: _status,
        documento:
            _documentoController.text.trim().isEmpty
                ? null
                : _documentoController.text.trim(),
        ieRg:
            _ieRgController.text.trim().isEmpty
                ? null
                : _ieRgController.text.trim(),
        contato:
            _contatoController.text.trim().isEmpty
                ? null
                : _contatoController.text.trim(),
        email:
            _emailController.text.trim().isEmpty
                ? null
                : _emailController.text.trim(),
        tipoComissao: _tipoComissao,
        prePedido: _prePedido,
        aplicativo: _aplicativo,
      );
      final ok = await context
          .read<RepresentativesCubit>()
          .updateRepresentative(
            id: widget.representativeId!,
            dto: dto,
            token: token,
          );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Representante atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onUpdated?.call(widget.representativeId!, dto);
      }
    } else {
      final dto = CreateRepresentativeDto(
        nome: _nomeController.text.trim(),
        telefone:
            _telefoneController.text.trim().isEmpty
                ? null
                : _telefoneController.text.trim(),
        celular:
            _celularController.text.trim().isEmpty
                ? null
                : _celularController.text.trim(),
        comissao:
            double.tryParse(_comissaoController.text.replaceAll(',', '.')) ?? 0,
        status: _status,
        documento:
            _documentoController.text.trim().isEmpty
                ? null
                : _documentoController.text.trim(),
        ieRg:
            _ieRgController.text.trim().isEmpty
                ? null
                : _ieRgController.text.trim(),
        contato:
            _contatoController.text.trim().isEmpty
                ? null
                : _contatoController.text.trim(),
        email:
            _emailController.text.trim().isEmpty
                ? null
                : _emailController.text.trim(),
        tipoComissao: _tipoComissao,
        prePedido: _prePedido,
        aplicativo: _aplicativo,
        address: address,
      );

      final ok = await context
          .read<RepresentativesCubit>()
          .createRepresentative(dto: dto, token: token);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Representante cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSaved?.call(dto);
        _clearForm();
      }
    }
  }

  void _clearForm() {
    _nomeController.clear();
    _telefoneController.clear();
    _celularController.clear();
    _documentoController.clear();
    _ieRgController.clear();
    _contatoController.clear();
    _emailController.clear();
    _comissaoController.text = '0';
    _cepController.clear();
    _streetController.clear();
    _numberController.clear();
    _complementController.clear();
    _neighborhoodController.clear();
    _cityController.clear();
    _countryController.text = 'Brasil';
    _ufController.clear();
    setState(() {
      _tipoComissao = TipoComissao.semComissao;
      _status = true;
      _prePedido = false;
      _aplicativo = false;
      _includeAddress = false;
      _isStreetReadOnly = false;
      _isNeighborhoodReadOnly = false;
      _isCityReadOnly = false;
      _isUfReadOnly = false;
      _isComplementReadOnly = false;
      _cepErrorMessage = null;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _celularController.dispose();
    _documentoController.dispose();
    _ieRgController.dispose();
    _contatoController.dispose();
    _emailController.dispose();
    _comissaoController.dispose();
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _ufController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray300.withValues(alpha: 0.8)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray300.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _nomeController,
                            decoration: _dec('Nome *'),
                            validator:
                                (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Obrigatório'
                                        : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _documentoController,
                            decoration: _dec('Documento (CPF/CNPJ)'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _ieRgController,
                            decoration: _dec('IE/RG'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _telefoneController,
                            decoration: _dec('Telefone'),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _celularController,
                            decoration: _dec('Celular'),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _contatoController,
                            decoration: _dec('Contato'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: _dec('E-mail'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _comissaoController,
                            decoration: _dec('Comissão (%)'),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<TipoComissao>(
                            decoration: _dec('Tipo Comissão'),
                            value: _tipoComissao,
                            items:
                                TipoComissao.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.label),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) => setState(() => _tipoComissao = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _status,
                              onChanged:
                                  (v) => setState(() => _status = v ?? true),
                            ),
                            const Text('Status Ativo'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _prePedido,
                              onChanged:
                                  (v) =>
                                      setState(() => _prePedido = v ?? false),
                            ),
                            const Text('Pré-pedido'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _aplicativo,
                              onChanged:
                                  (v) =>
                                      setState(() => _aplicativo = v ?? false),
                            ),
                            const Text('Aplicativo'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _includeAddress,
                      onChanged:
                          (v) => setState(() => _includeAddress = v ?? false),
                      title: const Text('Incluir endereço'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_includeAddress) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 120,
                        child: TextFormField(
                          controller: _cepController,
                          decoration: _dec('CEP').copyWith(
                            errorText: _cepErrorMessage,
                            suffixIcon:
                                _isLoadingCep
                                    ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                    : null,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _streetController,
                              decoration: _dec('Rua').copyWith(
                                suffixIcon: _apiLockedSuffix(_isStreetReadOnly),
                              ),
                              readOnly: _isStreetReadOnly,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _numberController,
                              decoration: _dec('Número'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _complementController,
                        decoration: _dec('Complemento').copyWith(
                          suffixIcon: _apiLockedSuffix(_isComplementReadOnly),
                        ),
                        readOnly: _isComplementReadOnly,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _neighborhoodController,
                              decoration: _dec('Bairro').copyWith(
                                suffixIcon: _apiLockedSuffix(
                                  _isNeighborhoodReadOnly,
                                ),
                              ),
                              readOnly: _isNeighborhoodReadOnly,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _cityController,
                              decoration: _dec('Cidade').copyWith(
                                suffixIcon: _apiLockedSuffix(_isCityReadOnly),
                              ),
                              readOnly: _isCityReadOnly,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _ufController,
                              decoration: _dec('UF').copyWith(
                                suffixIcon: _apiLockedSuffix(_isUfReadOnly),
                              ),
                              readOnly: _isUfReadOnly,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _countryController,
                        decoration: _dec('País'),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    _clearForm();
                                    widget.onCancel?.call();
                                  },
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          onPressed: _isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    _isEditMode
                                        ? 'Atualizar representante'
                                        : 'Cadastrar representante',
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isEditMode ? Icons.edit : Icons.add_box_rounded,
              size: 24,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditMode ? 'Editar representante' : 'Novo representante',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isEditMode
                      ? 'Altere os dados e salve para atualizar.'
                      : 'Preencha os campos para cadastrar um novo representante.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
