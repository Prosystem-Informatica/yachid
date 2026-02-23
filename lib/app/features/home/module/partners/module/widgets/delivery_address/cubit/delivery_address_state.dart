part of 'delivery_address_cubit.dart';

@immutable
sealed class DeliveryAddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class DeliveryAddressInitial extends DeliveryAddressState {}

final class DeliveryAddressLoaded extends DeliveryAddressState {
  final List<DeliveryAddress> deliveryAddresses;
  DeliveryAddressLoaded({required this.deliveryAddresses});

  DeliveryAddressLoaded copyWith({
    List<DeliveryAddress>? deliveryAddresses,
    DeliveryAddress? newDeliveryAddress,
  }) {
    return DeliveryAddressLoaded(
      deliveryAddresses: deliveryAddresses ?? this.deliveryAddresses,
    );
  }

  @override
  List<Object?> get props => [deliveryAddresses];
}

final class DeliveryAddressError extends DeliveryAddressState {
  final String message;

  DeliveryAddressError({required this.message});
}
