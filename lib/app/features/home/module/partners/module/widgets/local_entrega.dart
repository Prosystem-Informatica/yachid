import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/card_partner.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/delivery_address_register_card.dart';

class LocalEntregaTab extends StatelessWidget {
  final List<DeliveryAddress> deliveryAddresses;
  final ValueChanged<DeliveryAddress>? onDeliveryAddressSaved;

  const LocalEntregaTab({
    super.key,
    required this.deliveryAddresses,
    this.onDeliveryAddressSaved,
  });

  @override
  Widget build(BuildContext context) {
    final registerCard = Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: DeliveryAddressRegisterCard(onSaved: onDeliveryAddressSaved),
    );

    if (deliveryAddresses.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: registerCard,
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        ...List.generate(
          deliveryAddresses.length,
          (index) => Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: _deliveryAddressCard(deliveryAddresses[index]),
          ),
        ),
        registerCard,
      ],
    );
  }
}

Widget _deliveryAddressCard(DeliveryAddress address) {
  return CardPartnerContact(
    title: 'Local de entrega',
    onTap: () {},
    crossAxisCount: 3,
    childAspectRatio: 3,
    icon: const Icon(Icons.local_shipping_outlined, size: 16),
    iconDecoration: BoxDecoration(
      color: AppColors.primaryColor.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12),
    ),
    subtitle: 'Endereço para entrega',
    dataFields: [
      DataField(label: 'CEP', value: address.cep),
      DataField(label: 'Logradouro', value: address.street),
      DataField(label: 'Bairro', value: address.neighborhood),
      DataField(label: 'Cidade', value: address.city),
      DataField(label: 'UF', value: address.uf),
      DataField(label: 'Observações', value: address.observations),
    ],
  );
}
