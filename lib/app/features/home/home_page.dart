import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:yachid/app/app_routes.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';

import '../../core/ui/ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          const SideBarWidget(),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F7FA),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(),
                    const SizedBox(height: 24),
                    _CardsRow(),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(child: _SalesChart()),
                        SizedBox(width: 24),
                        Expanded(child: _ProductsPie()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _LastInvoices(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Text(
          'Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Text('Olá, Usuário'),
      ],
    );
  }
}

class _CardsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _InfoCard(Icons.people, 'Clientes', 'Gerencie seus clientes.'),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _InfoCard(
            Icons.inventory,
            'Produtos',
            'Gerencie seus produtos.',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _InfoCard(
            Icons.shopping_cart,
            'Vendas',
            'Gerencie suas vendas.',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _InfoCard(Icons.receipt, 'NF-e', 'Gerencie suas NF-e.'),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E6F4F)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SalesChart extends StatelessWidget {
  const _SalesChart();

  @override
  Widget build(BuildContext context) {
    return _card(
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

class _ProductsPie extends StatelessWidget {
  const _ProductsPie();

  @override
  Widget build(BuildContext context) {
    return _card(
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

class _LastInvoices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _card(
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

Widget _card(String title, Widget child) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(height: 250, child: child),
      ],
    ),
  );
}
