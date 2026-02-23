import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yachid/app/features/home/module/banks/model/bank_detail.dart';
import 'package:yachid/app/features/home/module/banks/model/bank_model_list.dart';
import 'package:yachid/app/features/home/module/banks/model/create_bank_dto.dart';
import 'package:yachid/app/features/home/module/banks/model/update_bank_dto.dart';
import 'package:yachid/app/repository/banks/banks_repository.dart';

part 'banks_state.dart';

class BanksCubit extends Cubit<BanksState> {
  final BanksRepository _repository;

  BanksCubit({required BanksRepository repository})
      : _repository = repository,
        super(BanksInitial());

  Future<void> loadBanks({required String token}) async {
    emit(BanksLoading());
    try {
      final list = await _repository.getAll(token: token);
      emit(BanksLoaded(banks: list));
    } catch (e) {
      emit(BanksError(e.toString()));
    }
  }

  void setFilterSearch(String search) {
    final current = state;
    if (current is! BanksLoaded) return;
    emit(BanksLoaded(
      banks: current.banks,
      filterSearch: search,
    ));
  }

  Future<BankDetail?> loadBankDetail({
    required String id,
    required String token,
  }) async {
    try {
      return await _repository.getOne(id: id, token: token);
    } catch (e) {
      emit(BanksError(e.toString()));
      return null;
    }
  }

  Future<bool> createBank({
    required CreateBankDto dto,
    required String token,
  }) async {
    final current = state;
    try {
      final response = await _repository.create(dto: dto, token: token);
      if (response.statusCode == 201 && response.data != null) {
        final created =
            BankModelList.fromJson(response.data as Map<String, dynamic>);
        if (current is BanksLoaded) {
          emit(BanksLoaded(
            banks: [...current.banks, created],
            filterSearch: current.filterSearch,
          ));
        }
        return true;
      }
      final msg = (response.data is Map ? response.data['message'] : response.data)
              ?.toString() ??
          'Erro ao criar banco';
      emit(BanksError(msg));
      return false;
    } catch (e) {
      emit(BanksError(e.toString()));
      return false;
    }
  }

  Future<bool> updateBank({
    required String id,
    required UpdateBankDto dto,
    required String token,
  }) async {
    final current = state;
    try {
      final response = await _repository.update(id: id, dto: dto, token: token);
      if (response.statusCode == 200 && response.data != null) {
        final updated =
            BankModelList.fromJson(response.data as Map<String, dynamic>);
        if (current is BanksLoaded) {
          final idx = current.banks.indexWhere((b) => b.id == id);
          final newList = List<BankModelList>.from(current.banks);
          if (idx >= 0) {
            newList[idx] = updated;
          } else {
            newList.add(updated);
          }
          emit(BanksLoaded(
            banks: newList,
            filterSearch: current.filterSearch,
          ));
        }
        return true;
      }
      final msg = (response.data is Map ? response.data['message'] : response.data)
              ?.toString() ??
          'Erro ao atualizar banco';
      emit(BanksError(msg));
      return false;
    } catch (e) {
      emit(BanksError(e.toString()));
      return false;
    }
  }
}
