import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/products/cubit/products_cubit.dart';

class ProductsFilters extends StatelessWidget {
  final TextEditingController searchController;

  const ProductsFilters({
    super.key,
    required this.searchController,
  });

  static InputDecoration _inputDec(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
      decoration: const BoxDecoration(color: AppColors.textOnPrimary),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoaded &&
              searchController.text != state.filterSearch) {
            searchController.text = state.filterSearch;
          }
          return Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: searchController,
                  decoration: _inputDec(
                    'Buscar',
                    'Código, produto ou código de barras',
                  ),
                  onChanged: (v) {
                    context.read<ProductsCubit>().setFilterSearch(v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  searchController.clear();
                  context.read<ProductsCubit>().setFilterSearch('');
                },
                icon: const Icon(Icons.clear_rounded, color: Colors.black54),
                tooltip: 'Limpar busca',
              ),
            ],
          );
        },
      ),
    );
  }
}
