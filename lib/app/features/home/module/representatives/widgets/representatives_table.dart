import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_model_list.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_cell.dart';
import 'package:yachid/app/features/home/module/partners/widgets/table/widgets/table_header.dart';

class RepresentativesTable extends StatelessWidget {
  final List<RepresentativeModelList> representatives;
  final void Function(RepresentativeModelList) onTap;

  const RepresentativesTable({
    super.key,
    required this.representatives,
    required this.onTap,
  });

  static const _columns = [
    'Código',
    'Nome',
    'Telefone',
    'Celular',
    'Comissão',
    'Tipo Comissão',
    'Cidade',
    'Status',
    '',
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
          ...representatives.asMap().entries.map((entry) {
            final index = entry.key;
            final r = entry.value;
            return Container(
              key: ValueKey(r.id),
              decoration: BoxDecoration(
                color: index.isEven
                    ? Colors.white
                    : AppColors.gray300.withValues(alpha: 0.12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(r),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        PartnersTableCell(text: r.codigo, width: width),
                        PartnersTableCell(
                          text: r.nome,
                          width: width,
                          bold: true,
                        ),
                        PartnersTableCell(text: r.telefone ?? '—', width: width),
                        PartnersTableCell(text: r.celular ?? '—', width: width),
                        PartnersTableCell(
                          text: r.comissao.toStringAsFixed(2),
                          width: width,
                        ),
                        PartnersTableCell(
                          text: r.tipoComissao,
                          width: width,
                        ),
                        PartnersTableCell(text: r.city ?? '—', width: width),
                        PartnersTableCell(
                          width: width,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              r.status ? 'Ativo' : 'Inativo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: r.status
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ),
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
