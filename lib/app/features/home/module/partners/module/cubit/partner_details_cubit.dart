import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';
import 'package:yachid/app/repository/partners/partners_repository.dart';

part 'partner_details_state.dart';

class PartnerDetailsCubit extends Cubit<PartnerDetailsState> {
  final PartnersRepository _repository;
  PartnerDetailsCubit({required PartnersRepository repository})
    : _repository = repository,
      super(PartnerDetailsInitial());

  setStatusInitial() {
    emit(PartnerDetailsInitial());
  }

  void setSelectedIndex(int index) {
    try {
      if (state is PartnerDetailsLoaded) {
        emit((state as PartnerDetailsLoaded).copyWith(selectedIndex: index));
      }
    } catch (e, s) {
      print('error: $e ${s.toString()}');
    }
  }

  Future<void> addDeliveryAddress(DeliveryAddress address, String token) async {
    if (state is! PartnerDetailsLoaded) return;

    try {
      final response = await _repository.createDeliveryAddress(
        address,
        (state as PartnerDetailsLoaded).partnerId ?? '',
        token,
      );
      if (response.statusCode == 201) {
        final current = state as PartnerDetailsLoaded;
        final updated = [...current.deliveryAddresses, address];
        emit(current.copyWith(deliveryAddresses: updated));
      } else {
        print('error: ${response.data['message']}');
        emit(PartnerDetailsError(message: response.data['message']));
      }
    } catch (e, s) {
      print('error: $e');
      print('stack trace: $s');
      emit(PartnerDetailsError(message: e.toString()));
    }
  }

  Future<void> getPartnerDetails(String partnerId, String token) async {
    try {
      final response = await _repository.getPartnerDetails(partnerId, token);
      if (response.statusCode == 200) {
        List<DeliveryAddress> deliveryAddresses = [];
        if (response.data['deliveryAddresses'] != null) {
          for (final element in response.data['deliveryAddresses']) {
            deliveryAddresses.add(DeliveryAddress.fromJson(element));
          }
        }
        emit(
          PartnerDetailsLoaded(
            partner: PartnerDetails.fromJson(response.data),
            selectedIndex: 0,
            deliveryAddresses: deliveryAddresses,
            partnerId: partnerId,
          ),
        );
      } else {
        emit(
          PartnerDetailsError(
            message:
                response.data['message'] ??
                'Erro ao buscar detalhes do parceiro',
          ),
        );
      }
    } catch (e, s) {
      print('error: $e');
      print('stack trace: $s');
      emit(PartnerDetailsError(message: e.toString()));
    }
  }
}
