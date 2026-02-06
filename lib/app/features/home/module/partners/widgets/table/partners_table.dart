import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/model/partner_model.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_cell.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_header.dart';

class PartnersTable extends StatelessWidget {
  final List<PartnerModel> partners;

  const PartnersTable({super.key, required this.partners});

  static const _columns = [
    'Código',
    'Documento',
    'Cliente (razão social)',
    'Fantasia',
    'Cidade',
    'Telefone',
    'UF',
    'CEP',
    'Status',
  ];

  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width / 9) - 40;
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
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.06),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  _columns
                      .map(
                        (label) =>
                            PartnersTableHeaderCell(label: label, width: width),
                      )
                      .toList(),
            ),
          ),
          // Rows
          ...partners.asMap().entries.map((entry) {
            final index = entry.key;
            final p = entry.value;
            return Container(
              decoration: BoxDecoration(
                color:
                    index.isEven
                        ? Colors.white
                        : AppColors.gray300.withValues(alpha: 0.12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        PartnersTableCell(text: p.codigo, width: width),
                        PartnersTableCell(text: p.document, width: width),
                        PartnersTableCell(
                          text: p.name,
                          width: width,
                          bold: true,
                        ),
                        PartnersTableCell(text: p.fantasyName, width: width),
                        PartnersTableCell(text: p.city, width: width),
                        PartnersTableCell(text: p.displayPhone, width: width),
                        PartnersTableCell(text: p.uf, width: width),
                        PartnersTableCell(text: p.cep, width: width),
                        PartnersTableCell(
                          width: width,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),

                            child: Text(
                              p.status.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color:
                                    p.status == PartnerStatus.ACTIVE
                                        ? AppColors.success
                                        : AppColors.error,
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
