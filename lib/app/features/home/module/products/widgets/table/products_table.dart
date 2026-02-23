import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachid/app/app_routes.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_cell.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_header.dart';
import 'package:yachid/app/features/home/module/products/model/product_model_list.dart';

class ProductsTable extends StatelessWidget {
  final List<ProductModelList> products;

  const ProductsTable({super.key, required this.products});

  static const _columns = [
    'Código',
    'Produto',
    'Tipo',
    'Unidade',
    'Cód. Barras',
    'Preço Tabela',
    'Saldo',
    'Status',
  ];

  static String _formatPrice(double? v) {
    if (v == null) return '—';
    return 'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    const colWidth = 140.0;
    return Container(
      constraints: const BoxConstraints(minWidth: 1000),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.06),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _columns
                  .map((label) => PartnersTableHeaderCell(
                        label: label,
                        width: colWidth,
                      ))
                  .toList(),
            ),
          ),
          ...products.asMap().entries.map((entry) {
            final index = entry.key;
            final p = entry.value;
            return Container(
              key: ValueKey(p.id),
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.white
                    : AppColors.gray300.withValues(alpha: 0.12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.PRODUCT_DETAILS.replaceFirst(':id', p.id));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        PartnersTableCell(text: p.codigo, width: colWidth),
                        PartnersTableCell(
                          text: p.produto,
                          width: colWidth,
                          bold: true,
                        ),
                        PartnersTableCell(text: p.tipo ?? '—', width: colWidth),
                        PartnersTableCell(
                          text: p.unidade ?? '—',
                          width: colWidth,
                        ),
                        PartnersTableCell(
                          text: p.codBarras ?? '—',
                          width: colWidth,
                        ),
                        PartnersTableCell(
                          text: _formatPrice(p.precoTabela),
                          width: colWidth,
                        ),
                        PartnersTableCell(
                          text: p.saldoDisponivel?.toStringAsFixed(2) ?? '—',
                          width: colWidth,
                        ),
                        PartnersTableCell(
                          width: colWidth,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: p.status
                                  ? AppColors.success.withValues(alpha: 0.15)
                                  : AppColors.error.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p.status ? 'Ativo' : 'Inativo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: p.status ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
