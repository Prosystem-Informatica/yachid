import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/model/models.dart';
import 'package:yachid/app/repository/auth/auth_repository.dart';

part 'companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  final AuthRepository _repository;

  CompaniesCubit({required AuthRepository repository})
      : _repository = repository,
        super(const CompaniesState());

  Future<void> loadCompanies({
    required String entrepreneurId,
    required String token,
  }) async {
    emit(state.copyWith(status: CompaniesStatus.loading, errorMessage: null));
    try {
      final companies = await _repository.getCompanies(entrepreneurId, token);
      emit(
        state.copyWith(
          status: CompaniesStatus.loaded,
          companies: companies,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CompaniesStatus.error,
          errorMessage: 'Erro ao carregar empresas',
        ),
      );
    }
  }

  void setFilterSearch(String search) {
    emit(state.copyWith(filterSearch: search));
  }

  Future<bool> createCompany({
    required CreateEnterpriseModel companie,
    required String entrepreneurId,
    required String token,
  }) async {
    emit(state.copyWith(status: CompaniesStatus.creating, errorMessage: null));
    try {
      final response = await _repository.createCompanies(companie: companie);
      if (!response.isSuccess) {
        emit(
          state.copyWith(
            status: CompaniesStatus.error,
            errorMessage: 'Erro ao criar empresa',
          ),
        );
        return false;
      }

      final companies = await _repository.getCompanies(entrepreneurId, token);
      emit(
        state.copyWith(
          status: CompaniesStatus.loaded,
          companies: companies,
        ),
      );
      return true;
    } catch (_) {
      emit(
        state.copyWith(
          status: CompaniesStatus.error,
          errorMessage: 'Erro ao criar empresa',
        ),
      );
      return false;
    }
  }
}
