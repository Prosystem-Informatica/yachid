import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yachid/app/features/home/module/representatives/model/create_representative_dto.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_detail.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_model_list.dart';
import 'package:yachid/app/features/home/module/representatives/model/update_representative_dto.dart';
import 'package:yachid/app/repository/representatives/representatives_repository.dart';

part 'representatives_state.dart';

class RepresentativesCubit extends Cubit<RepresentativesState> {
  final RepresentativesRepository _repository;

  RepresentativesCubit({required RepresentativesRepository repository})
      : _repository = repository,
        super(RepresentativesInitial());

  RepresentativeDetail? _detailCache;

  Future<void> loadRepresentatives({
    required String token,
  }) async {
    emit(RepresentativesLoading());
    try {
      final list = await _repository.getAll(
        token: token,
      );
      emit(RepresentativesLoaded(representatives: list));
    } catch (e) {
      emit(RepresentativesError(e.toString()));
    }
  }

  void setFilterSearch(String search) {
    final current = state;
    if (current is! RepresentativesLoaded) return;
    emit(RepresentativesLoaded(
      representatives: current.representatives,
      filterSearch: search,
    ));
  }

  Future<RepresentativeDetail?> loadRepresentativeDetail({
    required String id,
    required String token,
  }) async {
    try {
      final detail = await _repository.getOne(id: id, token: token);
      _detailCache = detail;
      return detail;
    } catch (e) {
      emit(RepresentativesError(e.toString()));
      return null;
    }
  }

  Future<bool> createRepresentative({
    required CreateRepresentativeDto dto,
    required String token,
  }) async {
    final current = state;
    try {
      final response = await _repository.create(
        dto: dto,
        token: token,
      );
      if (response.statusCode == 201 && response.data != null) {
        final created =
            RepresentativeModelList.fromJson(response.data as Map<String, dynamic>);
        if (current is RepresentativesLoaded) {
          emit(RepresentativesLoaded(
            representatives: [...current.representatives, created],
            filterSearch: current.filterSearch,
          ));
        }
        return true;
      }
      final msg = (response.data is Map
              ? response.data['message']
              : response.data)
          ?.toString() ??
          'Erro ao criar representante';
      emit(RepresentativesError(msg));
      return false;
    } catch (e) {
      emit(RepresentativesError(e.toString()));
      return false;
    }
  }

  Future<bool> updateRepresentative({
    required String id,
    required UpdateRepresentativeDto dto,
    required String token,
  }) async {
    final current = state;
    try {
      final response = await _repository.update(
        id: id,
        dto: dto,
        token: token,
      );
      if (response.statusCode == 200 && response.data != null) {
        final updated =
            RepresentativeModelList.fromJson(response.data as Map<String, dynamic>);
        if (current is RepresentativesLoaded) {
          final idx = current.representatives.indexWhere((r) => r.id == id);
          final newList = List<RepresentativeModelList>.from(current.representatives);
          if (idx >= 0) {
            newList[idx] = updated;
          } else {
            newList.add(updated);
          }
          emit(RepresentativesLoaded(
            representatives: newList,
            filterSearch: current.filterSearch,
          ));
        }
        return true;
      }
      final msg = (response.data is Map
              ? response.data['message']
              : response.data)
          ?.toString() ??
          'Erro ao atualizar representante';
      emit(RepresentativesError(msg));
      return false;
    } catch (e) {
      emit(RepresentativesError(e.toString()));
      return false;
    }
  }
}
