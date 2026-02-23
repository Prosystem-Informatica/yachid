part of 'products_cubit.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<ProductModelList> products;
  final List<ProductModelList> filteredProducts;
  final String filterSearch;
  final int total;
  final bool isLoading;

  const ProductsLoaded({
    required this.products,
    required this.filteredProducts,
    this.filterSearch = '',
    this.total = 0,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [products, filteredProducts, filterSearch, total, isLoading];
}

final class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
