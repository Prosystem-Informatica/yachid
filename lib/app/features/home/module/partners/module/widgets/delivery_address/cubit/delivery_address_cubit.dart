import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';
import 'package:yachid/app/repository/delivery_address/delivery_address.dart';

part 'delivery_address_state.dart';

class DeliveryAddressCubit extends Cubit<DeliveryAddressState> {
  final DeliveryAddressRepository _repository;
  DeliveryAddressCubit({required DeliveryAddressRepository repository})
    : _repository = repository,
      super(DeliveryAddressInitial());

  void setInitialData(DeliveryAddress deliveryAddress) {
    emit(DeliveryAddressLoaded(deliveryAddresses: [deliveryAddress]));
  }

  void addNewDeliveryAddress({
    required DeliveryAddress deliveryAddress,
    required String token,
    required String partnerId,
  }) async {
    try {
      final response = await _repository.createDeliveryAddress(
        token: token,
        createDeliveryAddressDto: deliveryAddress,
        partnerId: partnerId,
      );
      if (response.statusCode == 204 || response.statusCode == 201) {
        loadDeliveryAddresses(token: token, partnerId: partnerId);
      } else {
        final msg = (response.data is Map
                ? response.data['message']
                : response.data)
            ?.toString() ??
            'Erro ao criar endereço de entrega';
        emit(DeliveryAddressError(message: msg));
      }
    } catch (e) {
      emit(DeliveryAddressError(message: e.toString()));
    }
  }

  Future<void> loadDeliveryAddresses({
    required String token,
    required String partnerId,
  }) async {
    try {
      final deliveryAddresses = await _repository.getDeliveryAddresses(
        token: token,
        partnerId: partnerId,
      );
      if (deliveryAddresses.statusCode == 200) {
        final List<DeliveryAddress> deliveryAddressesList = [];
        for (final element in deliveryAddresses.data as List) {
          deliveryAddressesList.add(
            DeliveryAddress.fromJson(element as Map<String, dynamic>),
          );
        }
        emit(
          DeliveryAddressLoaded(deliveryAddresses: [...deliveryAddressesList]),
        );
      } else if (deliveryAddresses.statusCode == 404) {
        emit(DeliveryAddressLoaded(deliveryAddresses: []));
      } else {
        final msg = (deliveryAddresses.data is Map
                ? deliveryAddresses.data['message']
                : deliveryAddresses.data)
            ?.toString() ??
            'Erro ao carregar endereços de entrega';
        emit(DeliveryAddressError(message: msg));
      }
    } catch (e) {
      emit(DeliveryAddressError(message: e.toString()));
    }
  }

  Future<bool> updateDeliveryAddress({
    required DeliveryAddress deliveryAddress,
    required String token,
    required String deliveryAddressId,
  }) async {
    try {
      final response = await _repository.updateDeliveryAddress(
        token: token,
        deliveryAddressId: deliveryAddressId,
        updateDeliveryAddressDto: deliveryAddress,
      );
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else {
        final msg = (response.data is Map
                ? response.data['message']
                : response.data)
            ?.toString() ??
            'Erro ao atualizar endereço de entrega';
        emit(DeliveryAddressError(message: msg));
        return false;
      }
    } catch (e) {
      emit(DeliveryAddressError(message: e.toString()));
      return false;
    }
  }

  void setIsEditing(bool isEditing) {
    emit(
      DeliveryAddressLoaded(
        deliveryAddresses: (state as DeliveryAddressLoaded).deliveryAddresses,
      ),
    );
  }
}
