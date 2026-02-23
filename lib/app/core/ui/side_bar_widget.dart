import 'package:flutter/material.dart';
import 'package:yachid/app/app_routes.dart';
import 'package:yachid/app/core/ui/side_bar_item_widget.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({super.key});

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
          SideBarItemWidget(
            icon: Icons.dashboard,
            label: 'Dashboard',
            route: Routes.HOME,
          ),
          SideBarItemWidget(
            icon: Icons.people,
            label: 'Parceiros',
            route: Routes.PARTNERS,
          ),
          SideBarItemWidget(
            icon: Icons.inventory,
            label: 'Produtos',
            route: Routes.PRODUCTS,
          ),
          SideBarItemWidget(
            icon: Icons.shopping_cart,
            label: 'Vendas',
            route: Routes.HOME,
          ),
          SideBarItemWidget(
            icon: Icons.receipt,
            label: 'NF-e',
            route: Routes.HOME,
          ),
          SideBarItemWidget(
            icon: Icons.person_add,
            label: 'Funcionários',
            route: Routes.EMPLOYEE,
          ),
          SideBarItemWidget(
            icon: Icons.badge_outlined,
            label: 'Representantes',
            route: Routes.REPRESENTATIVES,
          ),
          SideBarItemWidget(
            icon: Icons.account_balance,
            label: 'Bancos',
            route: Routes.BANKS,
          ),
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
