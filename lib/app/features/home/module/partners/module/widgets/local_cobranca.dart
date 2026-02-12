import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/card_partner.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';

class LocalCobrancaTab extends StatelessWidget {
  const LocalCobrancaTab({super.key, required this.partner});

  final PartnerDetails partner;

  @override
  Widget build(BuildContext context) {
    final address = partner.address;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: CardPartnerContact(
            title: 'Dados de cobrança',
            crossAxisCount: 3,
            childAspectRatio: 3,
            onTap: () {},
            icon: const Icon(Icons.receipt_long_outlined, size: 16),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            subtitle: 'Endereço para cobrança',
            dataFields: [
              DataField(label: 'CEP', value: address.cep),
              DataField(label: 'Logradouro', value: address.street),
              DataField(label: 'Número', value: address.number),
              DataField(label: 'Bairro', value: address.neighborhood),
              DataField(label: 'Cidade', value: address.city),
              DataField(label: 'UF', value: address.uf),
              DataField(label: 'Complemento', value: address.complement),
            ],
          ),
        ),
      ],
    );
  }
}
