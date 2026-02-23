import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/payment_address/cubit/payment_address_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/payment_address/model/payment_address_model.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';

class PaymentAddressCard extends StatelessWidget {
  final Widget? icon;
  final Decoration? iconDecoration;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final int crossAxisCount;
  final double childAspectRatio;
  final int columns;
  final String partnerId;

  final PaymentAddressModel paymentAddress;

  PaymentAddressCard({
    required this.paymentAddress,
    required this.partnerId,
    super.key,
    this.icon,
    this.iconDecoration,
    required this.title,
    this.subtitle,
    this.trailing,
    this.crossAxisCount = 2,
    this.childAspectRatio = 6,
    this.columns = 2,
  }) {
    cepController.text = paymentAddress.cep;
    streetController.text = paymentAddress.street;
    neighborhoodController.text = paymentAddress.neighborhood;
    cityController.text = paymentAddress.city;
    ufController.text = paymentAddress.uf;
    observationsController.text = paymentAddress.observations ?? '';
    phoneController.text = paymentAddress.phone;
    emailController.text = paymentAddress.email;
    representativeController.text = paymentAddress.representative ?? "";
    numberController.text = paymentAddress.number;
  }

  final TextEditingController cepController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  final TextEditingController observationsController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController representativeController =
      TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isEditing =
        context.watch<PaymentAddressCubit>().state is PaymentAddressLoaded
            ? (context.watch<PaymentAddressCubit>().state
                    as PaymentAddressLoaded)
                .isEditing
            : false;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SectionHeader(
              setIsEditing:
                  (isEditing) => context
                      .read<PaymentAddressCubit>()
                      .setIsEditing(isEditing),
              trailing: trailing,
              iconDecoration: iconDecoration,
              icon: icon ?? const SizedBox.shrink(),
              title: title,
              description: subtitle ?? '',
              isEditing: isEditing,
              onEdit: () {
                context.read<PaymentAddressCubit>().updatePaymentAddress(
                  partnerId,
                  PaymentAddressModel(
                    id: paymentAddress.id,
                    cep: cepController.text,
                    street: streetController.text,
                    neighborhood: neighborhoodController.text,
                    city: cityController.text,
                    uf: ufController.text,
                    number: numberController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                    observations: observationsController.text,
                    representative: representativeController.text,
                    hasCredit: paymentAddress.hasCredit,
                  ),
                  context.read<AuthBlocCubit>().state.authModel.token ?? '',
                );
                context.read<PaymentAddressCubit>().setIsEditing(false);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                spacing: 20,
                children: [
                  DataField(
                    label: 'CEP',
                    isEditing: isEditing,
                    value: paymentAddress.cep,
                    controller: cepController,
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DataField(
                          isEditing: isEditing,
                          label: 'Logradouro',
                          value: paymentAddress.street,
                          controller: streetController,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DataField(
                          isEditing: isEditing,
                          label: 'Número',
                          value: paymentAddress.number,
                          controller: numberController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DataField(
                          isEditing: isEditing,
                          label: 'Bairro',
                          value: paymentAddress.neighborhood,
                          controller: neighborhoodController,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DataField(
                          isEditing: isEditing,
                          label: 'Cidade',
                          value: paymentAddress.city,
                          controller: cityController,
                        ),
                      ),
                    ],
                  ),
                  DataField(
                    isEditing: isEditing,
                    label: 'UF',
                    value: paymentAddress.uf,
                    controller: ufController,
                  ),
                  Divider(color: AppColors.gray300),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        flex: 1,
                        child: DataField(
                          isEditing: isEditing,
                          label: 'Telefone',
                          value: paymentAddress.phone,
                          controller: phoneController,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: DataField(
                          isEditing: isEditing,
                          label: 'Email',
                          value: paymentAddress.email,
                          controller: emailController,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray300.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Complemento',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            fontFamily: 'Frutiger_bold',
                            color: AppColors.gray600,
                          ),
                        ),
                        Text(
                          paymentAddress.observations,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1.2,
                            fontFamily: 'Frutiger',
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
