import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:yachid/app/app_routes.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/companies/cubit/companies_cubit.dart';
import 'package:yachid/app/features/auth/module/companies/create_companies_page.dart';
import 'package:yachid/app/model/enterprise_model.dart';

class CompaniesPage extends StatefulWidget {
  const CompaniesPage({super.key});

  @override
  State<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  final _searchController = TextEditingController();

  String get _entrepreneurId {
    return Get.parameters['id'] ??
        context.read<AuthBlocCubit>().state.authModel.user?.id ??
        '';
  }

  String get _token => context.read<AuthBlocCubit>().state.authModel.token ?? '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompaniesCubit>().loadCompanies(
            entrepreneurId: _entrepreneurId,
            token: _token,
          );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openCreateCompanyModal() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<AuthBlocCubit>(),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(dialogContext).size.width * 0.8,
                constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 750),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const CreateCompaniesPage(),
              ),
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    context.read<CompaniesCubit>().loadCompanies(
          entrepreneurId: _entrepreneurId,
          token: _token,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.gray300.withValues(alpha: 0.6)),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Empresas',
                    style: TextStyle(
                      fontFamily: 'Frutiger',
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: _openCreateCompanyModal,
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Criar empresa'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nome, e-mail ou documento...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: context.read<CompaniesCubit>().setFilterSearch,
            ),
          ),
          Expanded(
            child: BlocConsumer<CompaniesCubit, CompaniesState>(
              listener: (context, state) {
                if (state.status == CompaniesStatus.error &&
                    state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == CompaniesStatus.initial ||
                    state.status == CompaniesStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final companies = state.filteredCompanies;
                if (companies.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhuma empresa encontrada',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: SingleChildScrollView(
                    child: Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.grey.shade300),
                      ),
                      children: [
                        _row(
                          ['ID', 'Nome', 'Email', 'CNPJ/CPF', 'Status', 'Ação'],
                          header: true,
                        ),
                        ...companies.asMap().entries.map(
                          (entry) => _row(
                            [
                              (entry.key + 1).toString(),
                              entry.value.fantasyName ?? '-',
                              entry.value.email ?? '-',
                              entry.value.document ?? '-',
                              entry.value.status ?? '-',
                              'Entrar',
                            ],
                            onTap: () => _selectCompany(entry.value),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectCompany(EnterpriseModel company) {
    context.read<AuthBlocCubit>().selectCompany(company);
    Get.offNamed(Routes.HOME);
  }

  static TableRow _row(
    List<String> cells, {
    bool header = false,
    VoidCallback? onTap,
  }) {
    return TableRow(
      children: cells.map((c) {
        final isAction = c == 'Entrar' && !header;
        return Padding(
          padding: const EdgeInsets.all(8),
          child: isAction
              ? InkWell(
                  onTap: onTap,
                  child: const Text(
                    'Entrar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1E6F4F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Text(
                  c,
                  style: TextStyle(
                    fontWeight: header ? FontWeight.bold : FontWeight.normal,
                    color: header ? Colors.black87 : Colors.black54,
                  ),
                ),
        );
      }).toList(),
    );
  }
}
