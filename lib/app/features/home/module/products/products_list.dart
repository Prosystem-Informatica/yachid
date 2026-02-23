import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/side_bar_widget.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/products/cubit/products_cubit.dart';
import 'package:yachid/app/features/home/module/products/widgets/product_register_card.dart';
import 'package:yachid/app/features/home/module/products/widgets/products_filters.dart';
import 'package:yachid/app/features/home/module/products/widgets/table/products_table.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showRegisterCard = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authModel = context.read<AuthBlocCubit>().state.authModel;
      context.read<ProductsCubit>().loadProducts(token: authModel.token ?? '');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCadastrarPressed() {
    setState(() => _showRegisterCard = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  static bool _hasActiveFilters(ProductsLoaded state) {
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
                  BlocBuilder<ProductsCubit, ProductsState>(
                    buildWhen:
                        (prev, curr) =>
                            curr is ProductsLoaded || prev is ProductsLoaded,
                    builder: (context, state) {
                      final hasProducts =
                          state is ProductsLoaded &&
                          state.filteredProducts.isNotEmpty;
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
                                  'Produtos',
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
                                child:
                                    hasProducts
                                        ? FilledButton.icon(
                                          onPressed: _onCadastrarPressed,
                                          icon: const Icon(
                                            Icons.add_rounded,
                                            size: 20,
                                          ),
                                          label: const Text(
                                            'Cadastrar novo Produto',
                                          ),
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        )
                                        : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ProductsFilters(searchController: _searchController),
                  const SizedBox(height: 12),
                  Expanded(
                    child: BlocConsumer<ProductsCubit, ProductsState>(
                      listener: (context, state) {
                        if (state is ProductsError) {
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
                              curr is! ProductsError || prev is ProductsError,
                      builder: (context, state) {
                        if (state is ProductsInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is ProductsError) {
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
                              ],
                            ),
                          );
                        }
                        if (state is ProductsLoaded) {
                          final hasProducts = state.filteredProducts.isNotEmpty;
                          final showCard = !hasProducts || _showRegisterCard;
                          return ListView(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              bottom: 32,
                            ),
                            children: [
                              if (hasProducts) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ProductsTable(
                                        products: state.filteredProducts,
                                      ),
                                    ),
                                  ),
                                ),
                                if (showCard) ...[
                                  const SizedBox(height: 24),
                                  ProductRegisterCard(
                                    onSaved: (dto) {
                                      context.read<ProductsCubit>().addProduct(
                                        dto,
                                        context
                                                .read<AuthBlocCubit>()
                                                .state
                                                .authModel
                                                .token ??
                                            '',
                                      );
                                      setState(() => _showRegisterCard = false);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Produto cadastrado com sucesso!',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ] else ...[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 32,
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 48,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          _hasActiveFilters(state)
                                              ? 'Nenhum resultado para a busca'
                                              : 'Nenhum produto cadastrado',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ProductRegisterCard(
                                  onSaved: (dto) {
                                    context.read<ProductsCubit>().addProduct(
                                      dto,
                                      context
                                              .read<AuthBlocCubit>()
                                              .state
                                              .authModel
                                              .token ??
                                          '',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Produto cadastrado com sucesso!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
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
