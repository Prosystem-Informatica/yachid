import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';

part 'delivery_address_card_state.dart';

class DeliveryAddressCardCubit extends Cubit<DeliveryAddressCardState> {
  DeliveryAddressCardCubit({required DeliveryAddress deliveryAddress})
    : super(
        DeliveryAddressCardInitial(
          deliveryAddress: deliveryAddress,
          isEditing: false,
          bonification: deliveryAddress.bonification,
        ),
      );

  void setIsEditing(bool isEditing) {
    emit((state as DeliveryAddressCardInitial).copyWith(isEditing: isEditing));
  }

  void setBonification(bool bonification) {
    emit(
      (state as DeliveryAddressCardInitial).copyWith(
        bonification: bonification,
      ),
    );
  }

  void setDeliveryAddress(DeliveryAddress deliveryAddress) {
    emit(
      (state as DeliveryAddressCardInitial).copyWith(
        deliveryAddress: deliveryAddress,
      ),
    );
  }
}
