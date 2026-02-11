import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/card_partner.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';

class DadosTab extends StatelessWidget {
  const DadosTab({super.key, required this.partner});

  final PartnerDetails partner;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: CardPartnerContact(
            title: 'Identificação',
            onTap: () {},
            icon: const Icon(Icons.fingerprint, size: 16),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            subtitle: 'Dados de identificação do parceiro',
            dataFields: [
              DataField(label: 'Código', value: partner.codigo),
              DataField(label: 'Documento', value: partner.document),
              DataField(label: 'IR/RG', value: partner.ieRg),
              DataField(label: 'Tipo Pessoa', value: partner.personType),
              DataField(label: 'Suframa', value: partner.suframa),
              DataField(label: 'Tipo', value: partner.type),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: CardPartnerContact(
            title: 'Dados Gerais',
            onTap: () {},
            icon: const Icon(Icons.info_outline, size: 16),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            subtitle: 'Informações gerais do parceiro',
            dataFields: [
              DataField(label: 'Razão Social', value: partner.name),
              DataField(label: 'Nome Fantasia', value: partner.fantasyName),
              DataField(label: 'Tipo Parceiro', value: partner.type),
              DataField(
                label: 'Ramo de Atividade',
                value: partner.businessSector,
              ),
              DataField(label: 'Status', value: partner.status),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: CardPartnerContact(
            title: 'Contato',
            onTap: () {},
            icon: const Icon(Icons.contact_phone_outlined, size: 16),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            subtitle: 'Telefones, e-mails e redes',
            dataFields: [
              DataField(label: 'Telefone Principal', value: partner.mainPhone),
              DataField(
                label: 'Telefone Secundário',
                value: partner.secondaryPhone,
              ),
              DataField(label: 'Celular', value: partner.cellphone),
              DataField(label: 'E-mail', value: partner.email),
              DataField(label: 'E-mail NF-e', value: partner.emailNfe),
              DataField(label: 'Site', value: partner.site),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: CardPartnerContact(
            title: 'Financeiro',
            onTap: () {},
            icon: const Icon(Icons.account_balance_outlined, size: 16),
            iconDecoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            subtitle: 'Dados financeiros do parceiro',
            dataFields: [
              DataField(
                label: 'Conta Contábil',
                value: partner.accountingAccount,
              ),
              DataField(label: 'Despesas Fixas', value: partner.fixedExpenses),
              DataField(label: 'Provisão', value: partner.provision),
            ],
          ),
        ),
      ],
    );
  }
}
