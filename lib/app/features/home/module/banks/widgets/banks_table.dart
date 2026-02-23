import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/banks/model/bank_model_list.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_cell.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_header.dart';

class BanksTable extends StatelessWidget {
  final List<BankModelList> banks;
  final void Function(BankModelList) onTap;

  const BanksTable({
    super.key,
    required this.banks,
    required this.onTap,
  });

  static const _columns = ['Código', 'Número Banco', 'Nome', ''];

  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width / 4) - 40;
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
              children: _columns
                  .map((label) => PartnersTableHeaderCell(
                        label: label,
                        width: width,
                      ))
                  .toList(),
            ),
          ),
          ...banks.asMap().entries.map((entry) {
            final index = entry.key;
            final b = entry.value;
            return Container(
              key: ValueKey(b.id),
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.white
                    : AppColors.gray300.withValues(alpha: 0.12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(b),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        PartnersTableCell(text: b.codigo, width: width),
                        PartnersTableCell(
                          text: b.numeroBanco,
                          width: width,
                        ),
                        PartnersTableCell(
                          text: b.nome,
                          width: width,
                          bold: true,
                        ),
                        SizedBox(
                          width: width,
                          child: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: AppColors.gray600,
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
