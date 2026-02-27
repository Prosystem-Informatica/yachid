import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/side_bar_widget.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/representatives/cubit/representatives_cubit.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_model_list.dart';
import 'package:yachid/app/features/home/module/representatives/widgets/representative_register_card.dart';
import 'package:yachid/app/features/home/module/representatives/widgets/representatives_table.dart';

class RepresentativesList extends StatefulWidget {
  const RepresentativesList({super.key});

  @override
  State<RepresentativesList> createState() => _RepresentativesListState();
}

class _RepresentativesListState extends State<RepresentativesList> {
  final _searchController = TextEditingController();
  bool _showRegisterCard = false;
  String? _editingRepresentativeId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authModel = context.read<AuthBlocCubit>().state.authModel;
      context.read<RepresentativesCubit>().loadRepresentatives(
        token: authModel.token ?? '',
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCadastrarPressed() {
    setState(() {
      _editingRepresentativeId = null;
      _showRegisterCard = true;
    });
  }

  void _onEditPressed(RepresentativeModelList rep) {
    setState(() {
      _editingRepresentativeId = rep.id;
      _showRegisterCard = true;
    });
  }

  void _onFormCancel() {
    setState(() {
      _showRegisterCard = false;
      _editingRepresentativeId = null;
    });
  }

  static bool _hasActiveFilters(RepresentativesLoaded state) {
    return state.filterSearch.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: Column(
                children: [
                  BlocBuilder<RepresentativesCubit, RepresentativesState>(
                    buildWhen:
                        (prev, curr) =>
                            curr is RepresentativesLoaded ||
                            prev is RepresentativesLoaded,
                    builder: (context, state) {
                      return Container(
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
                                  'Representantes',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                ),
                                alignment: Alignment.centerRight,
                                child: FilledButton.icon(
                                  onPressed: _onCadastrarPressed,
                                  icon: const Icon(Icons.add_rounded, size: 20),
                                  label: const Text('Cadastrar representante'),
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
                      );
                    },
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
                          hintText:
                              'Buscar por código, nome, documento ou email...',
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
                          context.read<RepresentativesCubit>().setFilterSearch(
                            v,
                          );
                        },
                      ),
                    ),
                  Expanded(
                    child: BlocConsumer<
                      RepresentativesCubit,
                      RepresentativesState
                    >(
                      listener: (context, state) {
                        if (state is RepresentativesError) {
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
                              curr is! RepresentativesError ||
                              prev is RepresentativesError,
                      builder: (context, state) {
                        if (state is RepresentativesInitial ||
                            state is RepresentativesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is RepresentativesError) {
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
                                    context
                                        .read<RepresentativesCubit>()
                                        .loadRepresentatives(
                                          token: authModel.token ?? '',
                                        );
                                  },
                                  child: const Text('Tentar novamente'),
                                ),
                              ],
                            ),
                          );
                        }
                        if (state is RepresentativesLoaded) {
                          if (_showRegisterCard) {
                            return SingleChildScrollView(
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                top: 24,
                                bottom: 32,
                              ),
                              child: RepresentativeRegisterCard(
                                representativeId: _editingRepresentativeId,
                                onSaved: (_) {
                                  setState(() => _showRegisterCard = false);
                                },
                                onUpdated: (_, __) {
                                  setState(() {
                                    _showRegisterCard = false;
                                    _editingRepresentativeId = null;
                                  });
                                },
                                onCancel: _onFormCancel,
                              ),
                            );
                          }
                          final hasRepresentatives =
                              state.filteredRepresentatives.isNotEmpty;
                          if (hasRepresentatives) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: RepresentativesTable(
                                  representatives:
                                      state.filteredRepresentatives,
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
                                    Icons.person_outline,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _hasActiveFilters(state)
                                        ? 'Nenhum resultado para a busca'
                                        : 'Nenhum representante cadastrado',
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
