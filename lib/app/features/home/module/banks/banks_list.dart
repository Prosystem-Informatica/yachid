import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/side_bar_widget.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/banks/cubit/banks_cubit.dart';
import 'package:yachid/app/features/home/module/banks/model/bank_model_list.dart';
import 'package:yachid/app/features/home/module/banks/widgets/bank_register_card.dart';
import 'package:yachid/app/features/home/module/banks/widgets/banks_table.dart';

class BanksList extends StatefulWidget {
  const BanksList({super.key});

  @override
  State<BanksList> createState() => _BanksListState();
}

class _BanksListState extends State<BanksList> {
  final _searchController = TextEditingController();
  bool _showRegisterCard = false;
  String? _editingBankId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authModel = context.read<AuthBlocCubit>().state.authModel;
      context.read<BanksCubit>().loadBanks(token: authModel.token ?? '');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCadastrarPressed() {
    setState(() {
      _editingBankId = null;
      _showRegisterCard = true;
    });
  }

  void _onEditPressed(BankModelList bank) {
    setState(() {
      _editingBankId = bank.id.toString();
      _showRegisterCard = true;
    });
  }

  void _onFormCancel() {
    setState(() {
      _showRegisterCard = false;
      _editingBankId = null;
    });
  }

  static bool _hasActiveFilters(BanksLoaded state) {
    return state.filterSearch.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return _buildBankList();
  }

  Widget _buildBankList() {
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      body: Row(
        children: [
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
                              'Bancos',
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
                            padding: const EdgeInsets.symmetric(horizontal: 48),
                            alignment: Alignment.centerRight,
                            child: FilledButton.icon(
                              onPressed: _onCadastrarPressed,
                              icon: const Icon(Icons.add_rounded, size: 20),
                              label: const Text('Cadastrar banco'),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_showRegisterCard)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar por código, número ou nome...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (v) {
                          context.read<BanksCubit>().setFilterSearch(v);
                        },
                      ),
                    ),
                  Expanded(
                    child: BlocConsumer<BanksCubit, BanksState>(
                      listener: (context, state) {
                        if (state is BanksError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      },
                      buildWhen:
                          (prev, curr) =>
                              curr is! BanksError || prev is BanksError,
                      builder: (context, state) {
                        if (state is BanksInitial || state is BanksLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is BanksError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    final authModel =
                                        context
                                            .read<AuthBlocCubit>()
                                            .state
                                            .authModel;
                                    context.read<BanksCubit>().loadBanks(
                                      token: authModel.token ?? '',
                                    );
                                  },
                                  child: const Text('Tentar novamente'),
                                ),
                              ],
                            ),
                          );
                        }
                        if (state is BanksLoaded) {
                          if (_showRegisterCard) {
                            return SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                top: 24,
                                bottom: 32,
                              ),
                              child: BankRegisterCard(
                                bankId: _editingBankId,
                                onSaved: (_) {
                                  setState(() => _showRegisterCard = false);
                                },
                                onUpdated: (_, __) {
                                  setState(() {
                                    _showRegisterCard = false;
                                    _editingBankId = null;
                                  });
                                },
                                onCancel: _onFormCancel,
                              ),
                            );
                          }
                          final banks = state.filteredBanks;
                          if (banks.isNotEmpty) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: BanksTable(
                                  banks: banks,
                                  onTap: _onEditPressed,
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.account_balance_outlined,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _hasActiveFilters(state)
                                        ? 'Nenhum resultado para a busca'
                                        : 'Nenhum banco cadastrado',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
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
