import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yachid/app/core/widgets/widgets.dart';

class SalesChartWidget extends StatelessWidget {
  const SalesChartWidget();

  @override
  Widget build(BuildContext context) {
    return cardWidget(
      'Vendas por Mês',
      BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          barGroups: List.generate(6, (i) {
            final values = [30.0, 45, 60, 40, 70, 90];
            return BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(toY: values[i].toDouble())],
            );
          }),
        ),
      ),
    );
  }
}
