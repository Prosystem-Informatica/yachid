import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';

import 'package:yachid/app/features/home/module/partners/module/widgets/payment_address/cubit/payment_address_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/payment_address/widget/payment_address_card/payment_address_card.dart';

class PaymentAddressTab extends StatelessWidget {
  PaymentAddressTab({super.key, required this.partner});

  final PartnerDetails partner;

  final TextEditingController cepController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  final TextEditingController complementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentAddressCubit, PaymentAddressState>(
      builder: (context, state) {
        if (state is PaymentAddressError) {
          return Center(
            child: Text(state.message, style: TextStyle(color: Colors.red)),
          );
        } else if (state is PaymentAddressInitial) {
          context.read<PaymentAddressCubit>().getPaymentAddress(partner.id);
          return const Center(child: CircularProgressIndicator());
        } else if (state is PaymentAddressLoaded) {
          return ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 160),
                padding: const EdgeInsets.all(16),
                child: PaymentAddressCard(
                  partnerId: partner.id,
                  paymentAddress: state.paymentAddress,
                  title: 'Dados de cobrança',
                  crossAxisCount: 3,
                  childAspectRatio: 3,
                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                  iconDecoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  subtitle: 'Endereço para cobrança',
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
