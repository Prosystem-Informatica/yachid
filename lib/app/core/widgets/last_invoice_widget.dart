import 'package:flutter/material.dart';

import 'package:yachid/app/core/widgets/widgets.dart';

class LastInvoicesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return cardWidget(
      'Últimas NF-e Emitidas',
      DataTable(
        columns: const [
          DataColumn(label: Text('Número')),
          DataColumn(label: Text('Cliente')),
          DataColumn(label: Text('Data')),
          DataColumn(label: Text('Valor')),
        ],
        rows: const [
          DataRow(
            cells: [
              DataCell(Text('1023')),
              DataCell(Text('ACME LTDA')),
              DataCell(Text('25/11/2025')),
              DataCell(Text('R\$ 1.500,00')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('1022')),
              DataCell(Text('TechCorp')),
              DataCell(Text('24/11/2025')),
              DataCell(Text('R\$ 800,00')),
            ],
          ),
        ],
      ),
    );
  }
}
