import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/side_bar_item_widget.dart';

class SideBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF1E6F4F),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Yachid ERP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          SideBarItemWidget(Icons.dashboard, 'Dashboard'),
          SideBarItemWidget(Icons.people, 'Clientes'),
          SideBarItemWidget(Icons.inventory, 'Produtos'),
          SideBarItemWidget(Icons.shopping_cart, 'Vendas'),
          SideBarItemWidget(Icons.receipt, 'NF-e'),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
          ),
        ],
      ),
    );
  }
}
