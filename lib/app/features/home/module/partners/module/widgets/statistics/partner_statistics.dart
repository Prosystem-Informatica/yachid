import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/widgets/accounts_payable/accounts_payable.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/widgets/accounts_receivable/accounts_receivable.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/widgets/partner_credit_config/partner_credit_config.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/widgets/card_partner.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/cubit/partner_statistics_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/table/product_table.dart';

class PartnerStatistics extends StatelessWidget {
  PartnerStatistics({super.key, required this.partnerId});
  final String partnerId;

  final TextEditingController creditController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController serasaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerStatisticsCubit, PartnerStatisticsState>(
      builder: (context, state) {
        print(state.toString());
        if (state is PartnerStatisticsError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(state.message),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<PartnerStatisticsCubit>()
                      .setStatePartnerStatistics(PartnerStatisticsInitial());
                },
                child: Text('Tentar novamente'),
              ),
            ],
          );
        } else if (state is PartnerStatisticsInitial) {
          context.read<PartnerStatisticsCubit>().getPartnerCreditConfig(
            partnerId,
            token: context.read<AuthBlocCubit>().state.authModel.token,
          );
          return const SizedBox.shrink();
        } else if (state is PartnerStatisticsLoaded) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: ListView(
                shrinkWrap: true,
                children: [
                  PartnerCreditConfigPage(
                    partnerId: partnerId,
                    partnerCreditConfig: state.partnerCreditConfig,
                    isEditing: state.isEditingConfigData,
                    onEdit: () => context
                        .read<PartnerStatisticsCubit>()
                        .setEditingConfigData(true),
                    onCancelEdit: () => context
                        .read<PartnerStatisticsCubit>()
                        .setEditingConfigData(false),
                  ),
                  const SizedBox(height: 16),
                  AccountsPayablePage(
                    partnerId: partnerId,
                    accountsPayable: state.accountsPayable,
                    isEditing: state.isEditingAccountPayable,
                    onEdit: () => context
                        .read<PartnerStatisticsCubit>()
                        .setEditingAccountPayable(true),
                    onCancelEdit: () => context
                        .read<PartnerStatisticsCubit>()
                        .setEditingAccountPayable(false),
                  ),
                  const SizedBox(height: 16),
                  AccountsReceivablePage(
                    partnerId: partnerId,
                    accountsReceivable: state.accountsReceivable,
                    isEditing: state.isEditingAccountReceivable,
                    onEdit: () => context
                        .read<PartnerStatisticsCubit>()
                        .setEditingAccountReceivable(true),
                    onCancelEdit: () => context
                        .read<PartnerStatisticsCubit>()
                        .setEditingAccountReceivable(false),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 160,
                      vertical: 16,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CardPartnerContact(
                      isEditing: false,
                      setIsEditing: (isEditing) {},
                      onEdit: () {},
                      icon: Icon(Icons.credit_card),
                      iconDecoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: 'Produtos',
                      subtitle: 'Produtos vinculados ao parceiro',
                      widgets: [ProductTable(products: mockProductList)],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
