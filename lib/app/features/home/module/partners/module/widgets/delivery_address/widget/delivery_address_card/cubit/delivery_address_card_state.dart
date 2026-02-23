part of 'delivery_address_card_cubit.dart';

@immutable
sealed class DeliveryAddressCardState extends Equatable {}

final class DeliveryAddressCardInitial extends DeliveryAddressCardState {
  final DeliveryAddress deliveryAddress;
  final bool isEditing;
  final bool bonification;
  DeliveryAddressCardInitial({
    required this.deliveryAddress,
    required this.isEditing,
    required this.bonification,
  });

  DeliveryAddressCardInitial copyWith({
    DeliveryAddress? deliveryAddress,
    bool? isEditing,
    bool? bonification,
  }) {
    return DeliveryAddressCardInitial(
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      isEditing: isEditing ?? this.isEditing,
      bonification: bonification ?? this.bonification,
    );
  }

  @override
  List<Object?> get props => [deliveryAddress, isEditing, bonification];
}
