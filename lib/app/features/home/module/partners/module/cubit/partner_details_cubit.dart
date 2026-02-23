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

  Future<void> getPartnerDetails(String partnerId, String token) async {
    try {
      final response = await _repository.getPartnerDetails(partnerId, token);
      if (response.statusCode == 200) {
        emit(
          PartnerDetailsLoaded(
            partner: PartnerDetails.fromJson(response.data as Map<String, dynamic>),
            selectedIndex: 0,
            partnerId: partnerId,
          ),
        );
      } else {
        final msg = (response.data is Map
                ? response.data['message']
                : response.data)
            ?.toString() ??
            'Erro ao buscar detalhes do parceiro';
        emit(PartnerDetailsError(message: msg));
      }
    } catch (e) {
      emit(PartnerDetailsError(message: e.toString()));
    }
  }
}
