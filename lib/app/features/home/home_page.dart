import 'package:flutter/material.dart';

import '../../core/enums/enum.dart';
import '../../core/ui/ui.dart';
import '../features.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeSectionEnum selectedSection = HomeSectionEnum.dashboard;

  Widget _buildContent() {
    switch (selectedSection) {
      case HomeSectionEnum.home:
        return HomeCleanPage();
      case HomeSectionEnum.dashboard:
        return DashboardPage();
      case HomeSectionEnum.partners:
        return PartnersList();
      /*case HomeSectionEnum.products:
        return ProductsPage();
      case HomeSectionEnum.sales:
        return SalesPage();
      case HomeSectionEnum.nfe:
        return NfePage();*/
      case HomeSectionEnum.employees:
        return EmployeePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBarWidget(
            selectedSection: selectedSection,
            onItemSelected: (section) {
              setState(() {
                selectedSection = section;
              });
            },
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F7FA),
              padding: const EdgeInsets.all(24),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}
