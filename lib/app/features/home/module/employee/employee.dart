import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/employee/widgets/menu_card.dart';
import 'package:yachid/app/features/home/module/employee/widgets/status_chip.dart';

import 'cubit/employee_cubit.dart';
import 'model/employee_model.dart';
import 'widgets/employee_register_card.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  bool _showRegisterCard = false;
  String? _editingEmployeeId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authCubit = context.read<AuthBlocCubit>();
      final token = authCubit.state.authModel.token ?? "";
      final enterpriseId =
          authCubit.state.authModel.user?.enterpriseModel?.first.id ?? "";
      context.read<EmployeeCubit>().loadBranches(enterpriseId, token);
      _loadEmployees(null, token);
    });
  }

  void _loadEmployees(String? branchId, String token) {
    final cubit = context.read<EmployeeCubit>();
    if (branchId != null && branchId.isNotEmpty) {
      cubit.loadEmployees(branchId: branchId, token: token);
    } else {
      final enterpriseId = context
          .read<AuthBlocCubit>()
          .state
          .authModel
          .user
          ?.enterpriseModel
          ?.first
          .id;
      if (enterpriseId != null && enterpriseId.isNotEmpty) {
        cubit.loadEmployees(enterpriseId: enterpriseId, token: token);
      } else {
        cubit.clearEmployees();
      }
    }
  }

  void _onCadastrarPressed() {
    setState(() {
      _editingEmployeeId = null;
      _showRegisterCard = true;
    });
  }

  void _onEditPressed(EmployeeModel employee) {
    setState(() {
      _editingEmployeeId = employee.id;
      _showRegisterCard = true;
    });
  }

  void _onFormCancel() {
    setState(() {
      _showRegisterCard = false;
      _editingEmployeeId = null;
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
    final authCubit = context.read<AuthBlocCubit>();
    final token = authCubit.state.authModel.token ?? "";

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: BlocListener<EmployeeCubit, EmployeeState>(
              listener: (context, state) {},
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: BlocBuilder<EmployeeCubit, EmployeeState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            const Text(
                              'Filtrar por Filial:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String?>(
                                decoration: _dec('Selecione uma filial'),
                                value: state.selectedBranchId,
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Todas as filiais'),
                                  ),
                                  ...state.branches.map(
                                    (branch) => DropdownMenuItem<String?>(
                                      value: branch.id,
                                      child: Text(branch.name),
                                    ),
                                  ),
                                ],
                                onChanged: (branchId) {
                                  context
                                      .read<EmployeeCubit>()
                                      .setSelectedBranch(branchId);
                                  _loadEmployees(branchId, token);
                                },
                                isExpanded: true,
                                hint:
                                    state.isLoadingBranches
                                        ? const Text('Carregando filiais...')
                                        : const Text('Selecione uma filial'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: 'Incluir Funcionário',
                              onPressed: _onCadastrarPressed,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<EmployeeCubit, EmployeeState>(
                      builder: (context, state) {
                        if (state.isLoadingEmployees) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (_showRegisterCard) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              top: 24,
                              bottom: 32,
                            ),
                            child: EmployeeRegisterCard(
                              employeeId: _editingEmployeeId,
                              onSaved: (_) {
                                setState(() => _showRegisterCard = false);
                                _loadEmployees(state.selectedBranchId, token);
                              },
                              onUpdated: (_, __) {
                                setState(() {
                                  _showRegisterCard = false;
                                  _editingEmployeeId = null;
                                });
                                _loadEmployees(state.selectedBranchId, token);
                              },
                              onCancel: _onFormCancel,
                            ),
                          );
                        }

                        if (state.employees.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Nenhum funcionário encontrado',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                FilledButton.icon(
                                  onPressed: _onCadastrarPressed,
                                  icon: const Icon(Icons.add, size: 20),
                                  label: const Text('Cadastrar funcionário'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.employees.length,
                          itemBuilder: (context, index) {
                            final employee = state.employees[index];
                            return MenuCard(
                              onTap: () => _onEditPressed(employee),
                              iconDecoration: BoxDecoration(
                                color: AppColors.textOnPrimaryLight.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              icon: Icon(Icons.person, color: Colors.grey[600]),
                              title: employee.name,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StatusChip(
                                    status:
                                        employee.status == 'ACTIVE'
                                            ? 'Ativo'
                                            : 'Inativo',
                                    color:
                                        employee.status == 'ACTIVE'
                                            ? AppColors.success
                                            : AppColors.error,
                                  ),
                                  const SizedBox(width: 8),
                                  PopupMenuButton<String>(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20),
                                            SizedBox(width: 8),
                                            Text('Editar'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Excluir',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _onEditPressed(employee);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
