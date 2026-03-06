import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';

import '../../../../../core/widgets/widgets.dart';
import '../cubit/employee_cubit.dart';
import '../model/create_employee_dto.dart';
import '../model/employee_enums.dart';
import '../model/branch_model.dart';

class CreateEmployeeModal extends StatefulWidget {
  const CreateEmployeeModal({super.key});

  @override
  State<CreateEmployeeModal> createState() => _CreateEmployeeModalState();
}

class _CreateEmployeeModalState extends State<CreateEmployeeModal> {
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

  final Map<String, bool> openSections = {'dados': true, 'imagem': false};

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

  Future<void> _pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            _base64Image = reader.result as String;
            _imageFileName = file.name;
          });
        });

        reader.readAsDataUrl(file);
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione o cargo do funcionário')),
        );
        return;
      }

      if (_selectedBranch == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Selecione uma filial')));
        return;
      }

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
        context.read<AuthBlocCubit>().state.authModel.token ?? "",
        _selectedBranch!.id,
      );
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
            "",
        context.read<AuthBlocCubit>().state.authModel.token ?? "",
      );
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
        if (state.status == EmployeeStateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Funcionário criado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<EmployeeCubit>().resetState();
          Navigator.pop(context);
        } else if (state.status == EmployeeStateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro ao criar funcionário'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        child: Container(
          width: 800,
          constraints: const BoxConstraints(maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Criar Funcionário',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  sectionDropdown(
                    keyName: 'dados',
                    title: 'Dados do Funcionário',
                    children: [
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        decoration: _dec('Nome *'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      row([
                        TextFormField(
                          controller: _emailController,
                          decoration: _dec('Email *'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email é obrigatório';
                            }
                            if (!value.contains('@')) {
                              return 'Email inválido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(width: 12),
                        TextFormField(
                          controller: _phoneController,
                          decoration: _dec('Telefone *'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Telefone é obrigatório';
                            }
                            return null;
                          },
                        ),
                      ]),
                      const SizedBox(height: 12),
                      BlocBuilder<EmployeeCubit, EmployeeState>(
                        builder: (context, state) {
                          return DropdownButtonFormField<BranchModel>(
                            decoration: _dec('Filial *'),
                            value: _selectedBranch,
                            items:
                                state.branches
                                    .map(
                                      (branch) => DropdownMenuItem(
                                        value: branch,
                                        child: Text(branch.name),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBranch = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Filial é obrigatória';
                              }
                              return null;
                            },
                            isExpanded: true,
                            hint:
                                state.isLoadingBranches
                                    ? const Text('Carregando filiais...')
                                    : const Text('Selecione uma filial'),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: _documentController,
                              decoration: _dec('CPF/CNPJ *'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Documento é obrigatório';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Container(
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
                                          _selectedStatus ==
                                                  EmployeeStatus.ATIVO
                                              ? AppColors.success
                                              : AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value:
                                        _selectedStatus == EmployeeStatus.ATIVO,
                                    activeTrackColor: AppColors.primaryColor
                                        .withValues(alpha: 0.5),
                                    thumbColor: WidgetStateProperty.resolveWith(
                                      (states) {
                                        if (states.contains(
                                          WidgetState.selected,
                                        )) {
                                          return AppColors.primaryColor;
                                        }
                                        return null;
                                      },
                                    ),
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
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<EmployeeRole>(
                              decoration: _dec('Cargo *'),
                              value: _selectedRole,
                              items:
                                  EmployeeRole.values
                                      .map(
                                        (role) => DropdownMenuItem(
                                          value: role,
                                          child: Text(role.value),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Cargo é obrigatório';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    openSections: openSections,
                    toggle: toggle,
                  ),
                  sectionDropdown(
                    keyName: 'imagem',
                    title: 'Foto do Funcionário',
                    children: [
                      const SizedBox(height: 24),
                      if (_base64Image != null && _base64Image!.isNotEmpty) ...[
                        Container(
                          width: 200,
                          height: 200,
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
                        const SizedBox(height: 12),
                        Text(
                          _imageFileName ?? 'Imagem selecionada',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          _base64Image != null
                              ? 'Alterar Imagem'
                              : 'Selecionar Imagem',
                        ),
                      ),
                      const SizedBox(height: 24),
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
                      BlocBuilder<EmployeeCubit, EmployeeState>(
                        builder: (context, state) {
                          final isLoading =
                              state.status == EmployeeStateStatus.loading;
                          return ElevatedButton(
                            onPressed: isLoading ? null : _submitForm,
                            child:
                                isLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text('Salvar'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
