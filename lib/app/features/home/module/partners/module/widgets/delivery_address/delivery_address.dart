import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/delivery_address/cubit/delivery_address_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/delivery_address/widget/delivery_address_card/delivery_address_card.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/delivery_address/widget/delivery_address_register_card.dart';

class DeliveryAddressPage extends StatelessWidget {
  final String partnerId;

  const DeliveryAddressPage({super.key, required this.partnerId});

  @override
  Widget build(BuildContext context) {
    final registerCard = Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: DeliveryAddressRegisterCard(
        onSaved: (deliveryAddress) {
          context.read<DeliveryAddressCubit>().addNewDeliveryAddress(
            deliveryAddress: deliveryAddress,
            token: context.read<AuthBlocCubit>().state.authModel.token ?? '',
            partnerId: partnerId,
          );
        },
      ),
    );

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        BlocBuilder<DeliveryAddressCubit, DeliveryAddressState>(
          builder: (context, state) {
            if (state is DeliveryAddressError) {
              return Column(
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<DeliveryAddressCubit>()
                          .loadDeliveryAddresses(
                            token:
                                context
                                    .read<AuthBlocCubit>()
                                    .state
                                    .authModel
                                    .token ??
                                '',
                            partnerId: partnerId,
                          );
                    },
                    child: Text('Tentar novamente'),
                  ),
                ],
              );
            }
            if (state is DeliveryAddressInitial) {
              context.read<DeliveryAddressCubit>().loadDeliveryAddresses(
                token:
                    context.read<AuthBlocCubit>().state.authModel.token ?? '',
                partnerId: partnerId,
              );
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DeliveryAddressLoaded) {
              if (state.deliveryAddresses.isEmpty) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: registerCard,
                );
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 170),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: List.generate(
                    state.deliveryAddresses.length,
                    (index) => Container(
                      key: Key(state.deliveryAddresses[index].id ?? ''),
                      margin: EdgeInsets.only(
                        bottom:
                            state.deliveryAddresses.length - 1 == index
                                ? 0
                                : 20,
                      ),
                      child: DeliveryAddressCard(
                        deliveryAddress: state.deliveryAddresses[index],
                        title: 'Local de entrega',
                        onEdit: (newDeliveryAddress) async {
                          final bool success = await context
                              .read<DeliveryAddressCubit>()
                              .updateDeliveryAddress(
                                deliveryAddress: newDeliveryAddress,
                                token:
                                    context
                                        .read<AuthBlocCubit>()
                                        .state
                                        .authModel
                                        .token ??
                                    '',
                                deliveryAddressId:
                                    state.deliveryAddresses[index].id ?? '',
                              );
                          if (success == true && context.mounted) {
                            context
                                .read<DeliveryAddressCubit>()
                                .loadDeliveryAddresses(
                                  token:
                                      context
                                          .read<AuthBlocCubit>()
                                          .state
                                          .authModel
                                          .token ??
                                      '',
                                  partnerId: partnerId,
                                );
                          } else {
                            if (context.mounted) {}
                          }
                        },
                        crossAxisCount: 3,
                        childAspectRatio: 3,
                        icon: const Icon(
                          Icons.local_shipping_outlined,
                          size: 16,
                        ),
                        iconDecoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        subtitle: 'Endereço para entrega',
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        registerCard,
      ],
    );
  }
}
