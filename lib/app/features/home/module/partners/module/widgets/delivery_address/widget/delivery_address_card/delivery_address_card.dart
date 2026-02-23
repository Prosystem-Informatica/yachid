import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data_field.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/delivery_address/widget/delivery_address_card/cubit/delivery_address_card_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/section_card_header.dart';

class DeliveryAddressCard extends StatelessWidget {
  final Widget? icon;
  final Decoration? iconDecoration;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final int crossAxisCount;
  final double childAspectRatio;
  final int columns;
  final void Function(DeliveryAddress newDeliveryAddress)? onEdit;
  final DeliveryAddress deliveryAddress;

  DeliveryAddressCard({
    required this.deliveryAddress,
    this.onEdit,
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
    cepController.text = deliveryAddress.cep;
    streetController.text = deliveryAddress.street;
    neighborhoodController.text = deliveryAddress.neighborhood;
    cityController.text = deliveryAddress.city;
    ufController.text = deliveryAddress.uf;
    observationsController.text = deliveryAddress.observations ?? "";
    regionController.text = deliveryAddress.region;
  }

  final TextEditingController cepController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController ufController = TextEditingController();
  final TextEditingController observationsController = TextEditingController();
  final TextEditingController regionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      child: BlocProvider(
        create:
            (context) =>
                DeliveryAddressCardCubit(deliveryAddress: deliveryAddress),
        child: BlocBuilder<DeliveryAddressCardCubit, DeliveryAddressCardState>(
          builder: (context, state) {
            if (state is DeliveryAddressCardInitial) {
              return Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SectionHeader(
                      setIsEditing:
                          (isEditing) => context
                              .read<DeliveryAddressCardCubit>()
                              .setIsEditing(isEditing),
                      trailing: trailing,
                      iconDecoration: iconDecoration,
                      icon: icon ?? const SizedBox.shrink(),
                      title: title,
                      description: subtitle ?? '',
                      isEditing: state.isEditing,
                      onEdit: () {
                        onEdit?.call(
                          DeliveryAddress(
                            cep: cepController.text,
                            street: streetController.text,
                            region: regionController.text,
                            neighborhood: neighborhoodController.text,
                            city: cityController.text,
                            uf: ufController.text,
                            bonification: state.bonification,
                            observations: observationsController.text,
                          ),
                        );
                        context.read<DeliveryAddressCardCubit>().setIsEditing(
                          false,
                        );
                        context
                            .read<DeliveryAddressCardCubit>()
                            .setDeliveryAddress(
                              DeliveryAddress(
                                cep: cepController.text,
                                street: streetController.text,
                                region: regionController.text,
                                neighborhood: neighborhoodController.text,
                                city: cityController.text,
                                uf: ufController.text,
                                bonification: state.bonification,
                                observations: observationsController.text,
                              ),
                            );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Column(
                        spacing: 20,
                        children: [
                          DataField(
                            label: 'CEP',
                            value: state.deliveryAddress.cep,
                            enabled: true,
                            isEditing: state.isEditing,
                            controller: cepController,
                          ),
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                flex: 1,
                                child: DataField(
                                  label: 'Logradouro',
                                  value: state.deliveryAddress.street,
                                  controller: streetController,
                                  isEditing: state.isEditing,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: DataField(
                                  label: 'Bairro',
                                  value: state.deliveryAddress.neighborhood,
                                  controller: neighborhoodController,
                                  isEditing: state.isEditing,
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
                                  label: 'Cidade',
                                  isEditing: state.isEditing,
                                  value: state.deliveryAddress.city,
                                  controller: cityController,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: DataField(
                                  label: 'UF',
                                  isEditing: state.isEditing,
                                  value: state.deliveryAddress.uf,
                                  controller: ufController,
                                ),
                              ),
                            ],
                          ),
                          DataField(
                            label: 'Região',
                            isEditing: state.isEditing,
                            value: state.deliveryAddress.region,
                            controller: regionController,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gray300.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.card_giftcard_rounded,
                                  size: 20,
                                  color: AppColors.gray700,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Bonificação',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.gray800,
                                  ),
                                ),
                                const Spacer(),
                                Switch(
                                  value: state.bonification,
                                  onChanged: (value) {
                                    if (state.isEditing) {
                                      context
                                          .read<DeliveryAddressCardCubit>()
                                          .setBonification(value);
                                    }
                                  },
                                  activeTrackColor: AppColors.primaryColor
                                      .withValues(alpha: 0.5),
                                  thumbColor: WidgetStateProperty.resolveWith((
                                    states,
                                  ) {
                                    if (states.contains(WidgetState.selected)) {
                                      return AppColors.primaryColor;
                                    }
                                    return null;
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
