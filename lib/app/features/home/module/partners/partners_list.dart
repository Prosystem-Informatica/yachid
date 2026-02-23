import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/side_bar_widget.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/widgets/partners_filters.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/partners_table.dart';

import 'cubit/partners_cubit.dart';
import 'widgets/modal/create_partner_modal.dart';

class PartnersList extends StatefulWidget {
  const PartnersList({super.key});

  @override
  State<PartnersList> createState() => _PartnersListState();
}

class _PartnersListState extends State<PartnersList> {
  final _filterDocument = TextEditingController();
  final _filterCity = TextEditingController();
  final _filterPhone = TextEditingController();
  final _filterUf = TextEditingController();
  final _filterCep = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authModel = context.read<AuthBlocCubit>().state.authModel;
      context.read<PartnersCubit>().loadPartners(
        token: authModel.token ?? '',
        enterpriseId:
            authModel.user?.role == 'entrepreneur'
                ? authModel.user?.enterpriseModel?.first.id ?? ''
                : null,
        branchId: authModel.user?.branchId ?? '',
      );
    });
  }

  @override
  void dispose() {
    _filterDocument.dispose();
    _filterCity.dispose();
    _filterPhone.dispose();
    _filterUf.dispose();
    _filterCep.dispose();
    super.dispose();
  }

  static bool _hasActiveFilters(PartnersLoaded state) {
    return state.filterDocument.trim().isNotEmpty ||
        state.filterCity.trim().isNotEmpty ||
        state.filterPhone.trim().isNotEmpty ||
        state.filterUf.trim().isNotEmpty ||
        state.filterCep.trim().isNotEmpty ||
        state.filterStatus != null;
  }

  void _showCreatePartnerModal() {
    showDialog(
      context: context,
      builder: (context) => const CreatePartnerModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      body: Row(
        children: [
          const SideBarWidget(),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.gray300.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),

                            child: Text(
                              'Clientes / Fornecedores',
                              style: TextStyle(
                                fontFamily: 'Frutiger',
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray900,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton.icon(
                                  onPressed: _showCreatePartnerModal,
                                  icon: const Icon(Icons.add_rounded, size: 20),
                                  label: const Text('Novo'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PartnersFilters(),
                  const SizedBox(width: 12),

                  BlocBuilder<PartnersCubit, PartnersState>(
                    builder: (context, state) {
                      if (state is PartnersInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is PartnersError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      if (state is PartnersLoaded) {
                        if (state.filteredPartners.isEmpty) {
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
                                  _hasActiveFilters(state)
                                      ? 'Nenhum resultado para os filtros'
                                      : 'Nenhum cliente/fornecedor cadastrado',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (!_hasActiveFilters(state)) ...[
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: _showCreatePartnerModal,
                                    icon: const Icon(Icons.add),
                                    label: const Text('Cadastrar'),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }
                        return Container(
                          color: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: PartnersTable(
                              partners: state.filteredPartners,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
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
