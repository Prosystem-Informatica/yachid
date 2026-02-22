import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:yachid/app/core/widgets/widgets.dart';

class ProductsPieWidget extends StatelessWidget {
  const ProductsPieWidget();

  @override
  Widget build(BuildContext context) {
    return cardWidget(
      'Produtos mais vendidos',
      PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(value: 35, title: 'A 35%'),
            PieChartSectionData(value: 25, title: 'B 25%'),
            PieChartSectionData(value: 20, title: 'C 20%'),
            PieChartSectionData(value: 15, title: 'D 15%'),
            PieChartSectionData(value: 5, title: 'E 5%'),
          ],
        ),
      ),
    );
  }
}
