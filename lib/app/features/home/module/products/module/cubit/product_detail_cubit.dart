import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/home/module/products/model/product_model.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_stock_dto.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_component_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_component_dto.dart';
import 'package:yachid/app/repository/products/products_repository.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductsRepository _repository;

  ProductDetailCubit({required ProductsRepository repository})
      : _repository = repository,
        super(ProductDetailInitial());

  Future<void> loadProduct(String productId, String token) async {
    try {
      final response = await _repository.getProductDetails(productId, token);
      final data = response.data as Map<String, dynamic>?;
      if (data != null) {
        final current = state;
        final idx = current is ProductDetailLoaded ? current.selectedIndex : 0;
        emit(ProductDetailLoaded(
          product: ProductModel.fromJson(data),
          selectedIndex: idx,
        ));
      } else {
        emit(const ProductDetailError('Produto não encontrado'));
      }
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> updateProduct(
    String productId,
    UpdateProductDto updateDto,
    String token,
  ) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    emit(ProductDetailLoaded(
        product: current.product,
        isSaving: true,
        isSavingStock: current.isSavingStock,
        isSavingComponent: current.isSavingComponent,
        selectedIndex: current.selectedIndex,
      ));

    try {
      final response = await _repository.updateProduct(
        productId,
        updateDto,
        token,
      );
      if (response.statusCode == 204 || response.statusCode == 200) {
        await loadProduct(productId, token);
      } else {
        emit(ProductDetailLoaded(
          product: current.product,
          isSaving: false,
          isSavingStock: current.isSavingStock,
          isSavingComponent: current.isSavingComponent,
          selectedIndex: current.selectedIndex,
        ));
        final msg = (response.data is Map
                ? (response.data as Map)['message']
                : response.data)
            ?.toString() ??
            'Erro ao atualizar produto';
        emit(ProductDetailError(msg));
      }
    } catch (e) {
      emit(ProductDetailLoaded(
          product: current.product,
          isSaving: false,
          isSavingStock: current.isSavingStock,
          isSavingComponent: current.isSavingComponent,
          selectedIndex: current.selectedIndex,
        ));
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> createProductStock(
    String productId,
    CreateProductStockDto stockDto,
    String token,
  ) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    emit(ProductDetailLoaded(
      product: current.product,
      isSaving: current.isSaving,
      isSavingStock: true,
      isSavingComponent: current.isSavingComponent,
      selectedIndex: current.selectedIndex,
    ));

    try {
      final response = await _repository.createProductStock(
        productId,
        stockDto,
        token,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        await loadProduct(productId, token);
      } else {
        emit(ProductDetailLoaded(
          product: current.product,
          isSaving: current.isSaving,
          isSavingStock: false,
        ));
        final msg = (response.data is Map
                ? (response.data as Map)['message']
                : response.data)
            ?.toString() ??
            'Erro ao cadastrar estoque';
        emit(ProductDetailError(msg));
      }
    } catch (e) {
      emit(ProductDetailLoaded(
        product: current.product,
        isSaving: current.isSaving,
        isSavingStock: false,
        isSavingComponent: current.isSavingComponent,
        selectedIndex: current.selectedIndex,
      ));
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> updateProductStock(
    String productId,
    String stockId,
    UpdateProductStockDto updateDto,
    String token,
  ) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    emit(ProductDetailLoaded(
      product: current.product,
      isSaving: current.isSaving,
      isSavingStock: true,
      isSavingComponent: current.isSavingComponent,
      selectedIndex: current.selectedIndex,
    ));

    try {
      final response = await _repository.updateProductStock(
        productId,
        stockId,
        updateDto,
        token,
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        await loadProduct(productId, token);
      } else {
        emit(ProductDetailLoaded(
          product: current.product,
          isSaving: current.isSaving,
          isSavingStock: false,
        ));
        final msg = (response.data is Map
                ? (response.data as Map)['message']
                : response.data)
            ?.toString() ??
            'Erro ao atualizar estoque';
        emit(ProductDetailError(msg));
      }
    } catch (e) {
      emit(ProductDetailLoaded(
        product: current.product,
        isSaving: current.isSaving,
        isSavingStock: false,
        isSavingComponent: current.isSavingComponent,
        selectedIndex: current.selectedIndex,
      ));
      emit(ProductDetailError(e.toString()));
    }
  }

  void setSelectedIndex(int index) {
    final current = state;
    if (current is ProductDetailLoaded) {
      emit(ProductDetailLoaded(
        product: current.product,
        isSaving: current.isSaving,
        isSavingStock: current.isSavingStock,
        isSavingComponent: current.isSavingComponent,
        selectedIndex: index,
      ));
    }
  }

  Future<void> createProductComponent(
    String productId,
    CreateProductComponentDto dto,
    String token,
  ) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    emit(ProductDetailLoaded(
      product: current.product,
      isSaving: current.isSaving,
      isSavingStock: current.isSavingStock,
      isSavingComponent: true,
      selectedIndex: current.selectedIndex,
    ));

    try {
      final response = await _repository.createProductComponent(
        productId,
        dto,
        token,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        await loadProduct(productId, token);
      } else {
        emit(ProductDetailLoaded(
          product: current.product,
          isSaving: current.isSaving,
          isSavingStock: current.isSavingStock,
          isSavingComponent: false,
          selectedIndex: current.selectedIndex,
        ));
        final msg = (response.data is Map
                ? (response.data as Map)['message']
                : response.data)
            ?.toString() ??
            'Erro ao cadastrar componente';
        emit(ProductDetailError(msg));
      }
    } catch (e) {
      emit(ProductDetailLoaded(
        product: current.product,
        isSaving: current.isSaving,
        isSavingStock: current.isSavingStock,
        isSavingComponent: false,
        selectedIndex: current.selectedIndex,
      ));
      emit(ProductDetailError(e.toString()));
    }
  }

  Future<void> updateProductComponent(
    String productId,
    String componentId,
    UpdateProductComponentDto dto,
    String token,
  ) async {
    final current = state;
    if (current is! ProductDetailLoaded) return;

    emit(ProductDetailLoaded(
      product: current.product,
      isSaving: current.isSaving,
      isSavingStock: current.isSavingStock,
      isSavingComponent: true,
      selectedIndex: current.selectedIndex,
    ));

    try {
      final response = await _repository.updateProductComponent(
        productId,
        componentId,
        dto,
        token,
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        await loadProduct(productId, token);
      } else {
        emit(ProductDetailLoaded(
          product: current.product,
          isSaving: current.isSaving,
          isSavingStock: current.isSavingStock,
          isSavingComponent: false,
          selectedIndex: current.selectedIndex,
        ));
        final msg = (response.data is Map
                ? (response.data as Map)['message']
                : response.data)
            ?.toString() ??
            'Erro ao atualizar componente';
        emit(ProductDetailError(msg));
      }
    } catch (e) {
      emit(ProductDetailLoaded(
        product: current.product,
        isSaving: current.isSaving,
        isSavingStock: current.isSavingStock,
        isSavingComponent: false,
        selectedIndex: current.selectedIndex,
      ));
      emit(ProductDetailError(e.toString()));
    }
  }
}
