import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachid/app/app_routes.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/table/product_table_cell.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_cell.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_header.dart';

// Mock data for the ProductTable, corresponding to the columns above
class ProductModelList {
  final String id;
  final String produto;
  final String ultFatura;
  final String pedido;
  final String vDias;
  final String vdMedia;
  final String qtdMedia;
  final String prcMin;
  final String prcMax;

  ProductModelList({
    required this.id,
    required this.produto,
    required this.ultFatura,
    required this.pedido,
    required this.vDias,
    required this.vdMedia,
    required this.qtdMedia,
    required this.prcMin,
    required this.prcMax,
  });
}

final List<ProductModelList> mockProductList = [
  ProductModelList(
    id: '1',
    produto: 'Produto A',
    ultFatura: '10/04/2024',
    pedido: '12345',
    vDias: '30',
    vdMedia: 'R\$1200',
    qtdMedia: '20',
    prcMin: 'R\$1100',
    prcMax: 'R\$1300',
  ),
  ProductModelList(
    id: '2',
    produto: 'Produto B',
    ultFatura: '02/03/2024',
    pedido: '12346',
    vDias: '60',
    vdMedia: 'R\$800',
    qtdMedia: '15',
    prcMin: 'R\$750',
    prcMax: 'R\$850',
  ),
  ProductModelList(
    id: '3',
    produto: 'Produto C',
    ultFatura: '15/02/2024',
    pedido: '12347',
    vDias: '90',
    vdMedia: 'R\$350',
    qtdMedia: '10',
    prcMin: 'R\$330',
    prcMax: 'R\$370',
  ),
];

class ProductTable extends StatelessWidget {
  final List<ProductModelList> products;

  const ProductTable({super.key, required this.products});

  static const _mockColumns = [
    'Produto',
    'Ult fatura',
    'Pedido',
    'V.dias',
    'Vd.Média',
    'Qtd. média',
    'prç. min',
    'prç.max',
  ];

  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width / 8) - 100;
    return Container(
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
              children:
                  _mockColumns
                      .map(
                        (label) =>
                            PartnersTableHeaderCell(label: label, width: width),
                      )
                      .toList(),
            ),
          ),
          ...products.asMap().entries.map((entry) {
            final index = entry.key;
            final p = entry.value;
            return Container(
              key: ValueKey(p.id),
              decoration: BoxDecoration(
                color:
                    index.isEven
                        ? Colors.white
                        : AppColors.gray300.withValues(alpha: 0.12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      Routes.PARTNER_DETAILS.replaceFirst(':id', p.id),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductTableCell(text: p.produto, width: width),
                        ProductTableCell(text: p.ultFatura, width: width),
                        ProductTableCell(text: p.pedido, width: width),
                        ProductTableCell(text: p.vDias, width: width),
                        ProductTableCell(text: p.vdMedia, width: width),
                        ProductTableCell(text: p.qtdMedia, width: width),
                        ProductTableCell(text: p.prcMin, width: width),
                        ProductTableCell(text: p.prcMax, width: width),
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
