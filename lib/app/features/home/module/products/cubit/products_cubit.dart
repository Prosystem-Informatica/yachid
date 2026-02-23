import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/home/module/products/model/product_model_list.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_dto.dart';
import 'package:yachid/app/repository/products/products_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _repository;

  ProductsCubit({required ProductsRepository repository})
      : _repository = repository,
        super(ProductsInitial());

  Future<void> loadProducts({
    required String token,
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _repository.getProducts(
        token: token,
        search: search,
        limit: limit,
        offset: offset,
      );

      emit(
        ProductsLoaded(
          products: response.products,
          filteredProducts: response.products,
          total: response.total,
        ),
      );
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  void setFilterSearch(String search) {
    final current = state;
    if (current is! ProductsLoaded) return;

    final searchLower = search.trim().toLowerCase();
    final filtered = searchLower.isEmpty
        ? current.products
        : current.products.where((p) {
            return (p.codigo.toLowerCase().contains(searchLower)) ||
                (p.produto.toLowerCase().contains(searchLower)) ||
                (p.codBarras?.toLowerCase().contains(searchLower) ?? false);
          }).toList();

    emit(
      ProductsLoaded(
        products: current.products,
        filteredProducts: filtered,
        filterSearch: search,
        total: current.total,
      ),
    );
  }

  Future<void> addProduct(CreateProductDto product, String token) async {
    final current = state;
    if (current is! ProductsLoaded) return;

    try {
      final response = await _repository.createProduct(product, token);
      if (response.statusCode == 201 || response.statusCode == 200) {
        await loadProducts(token: token);
      } else {
        final msg = (response.data is Map
                ? (response.data as Map)['message']
                : response.data)
            ?.toString() ??
            'Erro ao criar produto';
        emit(ProductsError(msg));
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> refreshProducts({required String token}) async {
    if (state is ProductsLoaded) {
      final current = state as ProductsLoaded;
      await loadProducts(
        token: token,
        search: current.filterSearch.isNotEmpty ? current.filterSearch : null,
      );
    }
  }
}
