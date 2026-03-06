import 'dart:convert';
// ignore: deprecated_member_use
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/employee/cubit/employee_cubit.dart';
import 'package:yachid/app/features/home/module/employee/model/create_employee_dto.dart';
import 'package:yachid/app/features/home/module/employee/model/employee_detail.dart';
import 'package:yachid/app/features/home/module/employee/model/employee_enums.dart';
import 'package:yachid/app/features/home/module/employee/model/branch_model.dart';
import 'package:yachid/app/features/home/module/employee/model/update_employee_dto.dart';

class EmployeeRegisterCard extends StatefulWidget {
  const EmployeeRegisterCard({
    super.key,
    this.employeeId,
    this.onSaved,
    this.onUpdated,
    this.onCancel,
  });

  final String? employeeId;
  final ValueChanged<CreateEmployeeDto>? onSaved;
  final void Function(String id, UpdateEmployeeDto dto)? onUpdated;
  final VoidCallback? onCancel;

  @override
  State<EmployeeRegisterCard> createState() => _EmployeeRegisterCardState();
}

class _EmployeeRegisterCardState extends State<EmployeeRegisterCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _documentController = TextEditingController();

  EmployeeStatus _selectedStatus = EmployeeStatus.ATIVO;
  EmployeeRole? _selectedRole;
  BranchModel? _selectedBranch;
  String? _base64Image;
  String? _imageFileName;

  bool _isLoading = false;
  bool _initialLoading = false;

  bool get _isEditMode => widget.employeeId != null;

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

  Future<void> _pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          if (mounted) {
            setState(() {
              _base64Image = reader.result as String;
              _imageFileName = file.name;
            });
          }
        });

        reader.readAsDataUrl(file);
      }
    });
  }

  @override
  void didUpdateWidget(EmployeeRegisterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.employeeId != null && widget.employeeId == null) {
      _clearForm();
    } else if (oldWidget.employeeId != widget.employeeId &&
        widget.employeeId != null) {
      _loadDetail();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeCubit>().loadBranches(
        context
                .read<AuthBlocCubit>()
                .state
                .authModel
                .user
                ?.enterpriseModel
                ?.first
                .id ??
            '',
        context.read<AuthBlocCubit>().state.authModel.token ?? '',
      );
      if (_isEditMode) {
        _loadDetail();
      }
    });
  }

  Future<void> _loadDetail() async {
    setState(() => _initialLoading = true);
    final authModel = context.read<AuthBlocCubit>().state.authModel;
    final detail = await context.read<EmployeeCubit>().loadEmployeeDetail(
      id: widget.employeeId!,
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

  void _fillForm(EmployeeDetail d) {
    _nameController.text = d.name;
    _emailController.text = d.email ?? '';
    _phoneController.text = d.phone;
    _documentController.text = d.document;
    _selectedStatus = d.status;
    _selectedRole = d.role;
    _selectedBranch = d.branch;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione o cargo do funcionário')),
      );
      return;
    }

    if (!_isEditMode && _selectedBranch == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecione uma filial')));
      return;
    }

    setState(() => _isLoading = true);

    final authModel = context.read<AuthBlocCubit>().state.authModel;
    final token = authModel.token ?? '';

    if (_isEditMode) {
      final dto = UpdateEmployeeDto(
        name: _nameController.text.trim(),
        email:
            _emailController.text.trim().isEmpty
                ? null
                : _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        document: _documentController.text.trim(),
        status: _selectedStatus,
        role: _selectedRole,
        base64: _base64Image,
      );
      final ok = await context.read<EmployeeCubit>().updateEmployee(
        id: widget.employeeId!,
        dto: dto,
        token: token,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Funcionário atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onUpdated?.call(widget.employeeId!, dto);
      }
    } else {
      final dto = CreateEmployeeDto(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        document: _documentController.text.trim(),
        status: _selectedStatus,
        role: _selectedRole!,
        base64: _base64Image,
        branch: _selectedBranch!.id,
      );

      context.read<EmployeeCubit>().createEmployee(
        dto,
        token,
        _selectedBranch!.id,
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _documentController.clear();
    setState(() {
      _selectedStatus = EmployeeStatus.ATIVO;
      _selectedRole = null;
      _selectedBranch = null;
      _base64Image = null;
      _imageFileName = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (!_isEditMode && state.status == EmployeeStateStatus.success) {
          setState(() => _isLoading = false);
          context.read<EmployeeCubit>().resetState();
          widget.onSaved?.call(
            CreateEmployeeDto(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              document: _documentController.text.trim(),
              status: _selectedStatus,
              role: _selectedRole!,
              base64: _base64Image,
              branch: _selectedBranch!.id,
            ),
          );
          _clearForm();
        } else if (state.status == EmployeeStateStatus.error) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro ao salvar funcionário'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
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
                    TextFormField(
                      controller: _nameController,
                      decoration: _dec('Nome *'),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Obrigatório'
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: _dec('Email *'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return 'Obrigatório';
                              if (!v.contains('@')) return 'Email inválido';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: _dec('Telefone *'),
                            keyboardType: TextInputType.phone,
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
                    BlocBuilder<EmployeeCubit, EmployeeState>(
                      builder: (context, state) {
                        return DropdownButtonFormField<BranchModel>(
                          decoration: _dec('Filial *'),

                          items:
                              state.branches
                                  .map(
                                    (b) => DropdownMenuItem(
                                      value: b,
                                      child: Text(b.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              _isEditMode
                                  ? null
                                  : (v) => setState(() => _selectedBranch = v),
                          validator:
                              (v) =>
                                  (!_isEditMode && v == null)
                                      ? 'Obrigatória'
                                      : null,
                          isExpanded: true,
                          hint:
                              state.isLoadingBranches
                                  ? const Text('Carregando filiais...')
                                  : Text(
                                    _isEditMode ? '—' : 'Selecione uma filial',
                                  ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _documentController,
                            decoration: _dec('CPF/CNPJ *'),
                            validator:
                                (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Obrigatório'
                                        : null,
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: DropdownButtonFormField<EmployeeRole>(
                            decoration: _dec('Cargo *'),
                            value: _selectedRole,
                            items:
                                EmployeeRole.values
                                    .map(
                                      (r) => DropdownMenuItem(
                                        value: r,
                                        child: Text(r.value),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) => setState(() => _selectedRole = v),
                            validator: (v) => v == null ? 'Obrigatório' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.gray300),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Status',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            _selectedStatus == EmployeeStatus.ATIVO
                                ? 'Ativo'
                                : 'Inativo',
                            style: TextStyle(
                              color:
                                  _selectedStatus == EmployeeStatus.ATIVO
                                      ? AppColors.success
                                      : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _selectedStatus == EmployeeStatus.ATIVO,
                            activeTrackColor: AppColors.primaryColor.withValues(
                              alpha: 0.5,
                            ),
                            thumbColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primaryColor;
                              }
                              return null;
                            }),
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus =
                                    value
                                        ? EmployeeStatus.ATIVO
                                        : EmployeeStatus.INATIVO;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    if (_base64Image != null && _base64Image!.isNotEmpty) ...[
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(_base64Image!.split(',')[1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: Text(
                        _base64Image != null
                            ? 'Alterar foto'
                            : 'Selecionar foto',
                      ),
                    ),
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
                                    _isEditMode ? 'Atualizar' : 'Cadastrar',
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
              _isEditMode ? Icons.edit : Icons.person_add,
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
                  _isEditMode ? 'Editar funcionário' : 'Novo funcionário',
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
                      : 'Preencha os campos para cadastrar um novo funcionário.',
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
