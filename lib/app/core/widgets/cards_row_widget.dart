import 'package:flutter/material.dart';
import 'package:yachid/app/core/widgets/widgets.dart';

class CardsRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: InfoCardWidget(
            Icons.people,
            'Clientes',
            'Gerencie seus clientes.',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: InfoCardWidget(
            Icons.inventory,
            'Produtos',
            'Gerencie seus produtos.',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: InfoCardWidget(
            Icons.shopping_cart,
            'Vendas',
            'Gerencie suas vendas.',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: InfoCardWidget(Icons.receipt, 'NF-e', 'Gerencie suas NF-e.'),
        ),
      ],
    );
  }
}
