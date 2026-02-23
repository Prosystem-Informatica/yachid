import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/side_bar_widget.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_component_dto.dart';
import 'package:yachid/app/features/home/module/products/model/product_model.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_stock_dto.dart';
import 'package:yachid/app/features/home/module/products/module/cubit/product_detail_cubit.dart';
import 'package:yachid/app/features/home/module/products/module/widgets/product_components_tab.dart';
import 'package:yachid/app/features/home/module/products/module/widgets/product_detail_form.dart';
import 'package:yachid/app/features/home/module/products/module/widgets/product_tab_bar.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? _productId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProduct());
  }

  void _loadProduct() {
    final route = ModalRoute.of(context);
    if (route != null && route.settings.name != null) {
      final uri = Uri.parse(route.settings.name!);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        _productId = segments.last;
        context.read<ProductDetailCubit>().loadProduct(
          _productId!,
          context.read<AuthBlocCubit>().state.authModel.token ?? '',
        );
      }
    }
  }

  void _onSave(UpdateProductDto dto) {
    if (_productId == null) return;
    context.read<ProductDetailCubit>().updateProduct(
      _productId!,
      dto,
      context.read<AuthBlocCubit>().state.authModel.token ?? '',
    );
  }

  void _onCreateStock(CreateProductStockDto dto) {
    if (_productId == null) return;
    context.read<ProductDetailCubit>().createProductStock(
      _productId!,
      dto,
      context.read<AuthBlocCubit>().state.authModel.token ?? '',
    );
  }

  void _onUpdateStock(String stockId, UpdateProductStockDto dto) {
    if (_productId == null) return;
    context.read<ProductDetailCubit>().updateProductStock(
      _productId!,
      stockId,
      dto,
      context.read<AuthBlocCubit>().state.authModel.token ?? '',
    );
  }

  void _onCreateComponent(CreateProductComponentDto dto) {
    if (_productId == null) return;
    context.read<ProductDetailCubit>().createProductComponent(
      _productId!,
      dto,
      context.read<AuthBlocCubit>().state.authModel.token ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBarWidget(),
          Expanded(
            child: BlocConsumer<ProductDetailCubit, ProductDetailState>(
              listenWhen: (previous, current) {
                if (current is ProductDetailError) return true;
                if (current is ProductDetailLoaded &&
                    previous is ProductDetailLoaded) {
                  if (previous.isSaving && !current.isSaving) return true;
                  if (previous.isSavingStock && !current.isSavingStock)
                    return true;
                  if (previous.isSavingComponent &&
                      !current.isSavingComponent) {
                    return true;
                  }
                }
                return false;
              },
              listener: (context, state) {
                if (state is ProductDetailError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
                if (state is ProductDetailLoaded &&
                    !state.isSaving &&
                    !state.isSavingStock &&
                    !state.isSavingComponent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Salvo com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ProductDetailInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ProductDetailError) {
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
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 24),
                        TextButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Voltar'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is ProductDetailLoaded) {
                  return Container(
                    color: AppColors.backgroundColor,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(
                          product: state.product,
                          onBack: () => Get.back(),
                        ),
                        ProductTabBar(
                          selectedIndex: state.selectedIndex,
                          onTabSelected: (index) {
                            context.read<ProductDetailCubit>().setSelectedIndex(
                              index,
                            );
                          },
                        ),
                        Expanded(
                          child:
                              state.selectedIndex == 0
                                  ? SingleChildScrollView(
                                    padding: const EdgeInsets.all(24),
                                    child: ProductDetailForm(
                                      product: state.product,
                                      isSaving: state.isSaving,
                                      isSavingStock: state.isSavingStock,
                                      onSave: _onSave,
                                      onCreateStock: _onCreateStock,
                                      onUpdateStock: _onUpdateStock,
                                    ),
                                  )
                                  : ProductComponentsTab(
                                    product: state.product,
                                    productId: state.product.id,
                                    isSaving: state.isSavingComponent,
                                    onCreate: _onCreateComponent,
                                  ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onBack;

  const _Header({required this.product, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.gray300.withValues(alpha: 0.6)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          _buildIconContainer(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.produto,
                  style:
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray900,
                      ) ??
                      const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray900,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Código: ${product.codigo}',
                  style:
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.gray600,
                      ) ??
                      const TextStyle(fontSize: 14, color: AppColors.gray600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: 34,
              height: 34,
              child: IconButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) =>
                        states.contains(WidgetState.hovered)
                            ? AppColors.primaryColor
                            : Colors.transparent,
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) =>
                        states.contains(WidgetState.hovered)
                            ? AppColors.textOnPrimary
                            : AppColors.gray800,
                  ),
                  side: WidgetStateProperty.all(
                    BorderSide(color: AppColors.gray400),
                  ),
                ),
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, size: 20),
                tooltip: 'Voltar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.inventory_2,
        size: 24,
        color: AppColors.textOnPrimary,
      ),
    );
  }
}
