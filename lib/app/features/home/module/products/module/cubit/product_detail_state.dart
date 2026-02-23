part of 'product_detail_cubit.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailInitial extends ProductDetailState {}

final class ProductDetailLoaded extends ProductDetailState {
  final ProductModel product;
  final bool isSaving;
  final bool isSavingStock;
  final bool isSavingComponent;
  final int selectedIndex;

  const ProductDetailLoaded({
    required this.product,
    this.isSaving = false,
    this.isSavingStock = false,
    this.isSavingComponent = false,
    this.selectedIndex = 0,
  });

  @override
  List<Object?> get props => [
        product,
        isSaving,
        isSavingStock,
        isSavingComponent,
        selectedIndex,
      ];
}

final class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
