import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yachid/app/features/home/module/partners/model/update_partner_dto.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';
import 'package:yachid/app/repository/partners/partners_repository.dart';

part 'partner_data_state.dart';

class PartnerDataCubit extends Cubit<PartnerDataState> {
  final PartnersRepository _repository;
  PartnerDataCubit({required PartnersRepository repository})
    : _repository = repository,
      super(PartnerDataInitial());

  Future<void> loadPartnerData({
    required String token,
    required String partnerId,
  }) async {
    try {
      final response = await _repository.getPartnerDetails(partnerId, token);
      if (response.statusCode == 200) {
        emit(
          PartnerDataLoaded(
            isEditing: false,
            partner: PartnerDetails.fromJson(response.data as Map<String, dynamic>),
          ),
        );
      } else {
        final msg = (response.data is Map
                ? response.data['message']
                : response.data)
            ?.toString() ??
            'Erro ao carregar dados do parceiro';
        emit(PartnerDataError(msg));
      }
    } catch (e) {
      emit(PartnerDataError(e.toString()));
    }
  }

  Future<bool> updatePartnerData({
    required String token,
    required String partnerId,
    required UpdatePartnerDto updatePartnerDto,
  }) async {
    try {
      final response = await _repository.updatePartner(
        partnerId,
        updatePartnerDto,
        token,
      );
      if (response.statusCode == 204) {
        await loadPartnerData(token: token, partnerId: partnerId);
        return true;
      } else {
        final msg = (response.data is Map
                ? response.data['message']
                : response.data)
            ?.toString() ??
            'Erro ao atualizar parceiro';
        emit(PartnerDataError(msg));
        return false;
      }
    } catch (e) {
      emit(PartnerDataError(e.toString()));
      return false;
    }
  }

  void setIsEditing(bool isEditing) {
    emit((state as PartnerDataLoaded).copyWith(isEditing: isEditing));
  }
}
