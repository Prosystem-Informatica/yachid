import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';

/// TabBar com três abas: Dados, Local de cobrança e Local de entrega.
class PartnersTabBar extends StatelessWidget {
  const PartnersTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  static const List<String> _tabLabels = [
    'Dados',
    'Local de cobrança',
    'Local de entrega',
  ];

  @override
  Widget build(BuildContext context) {
    return _buildCustomTabBar(context);
  }

  Widget _buildCustomTabBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.gray300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(
          _tabLabels.length,
          (index) => Expanded(
            child: InkWell(
              onTap: () => onTabSelected(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selectedIndex == index
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  _tabLabels[index],
                  style: TextStyle(
                    fontWeight:
                        selectedIndex == index ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                    color: selectedIndex == index
                        ? AppColors.primaryColor
                        : AppColors.gray600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
