import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yachid/app/app_routes.dart';
import 'package:yachid/app/core/ui/side_bar_item_widget.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({super.key});

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPrefs();
  }

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    prefs.clear();
  }

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
            route: Routes.HOME,
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
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              prefs.clear();
              Get.toNamed(Routes.INITIAL);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
          ),
        ],
      ),
    );
  }
}
