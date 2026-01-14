import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/enterprise/enterprise_repository.dart';
import 'enterprise_bloc_state.dart';

class EnterpriseListCubit extends Cubit<EnterpriseListState> {
  final EnterpriseRepository enterpriseRepository;

  EnterpriseListCubit({required this.enterpriseRepository})
      : super(EnterpriseListState.initial());

  Future<void> fetchEnterprises() async {
    emit(state.copyWith(status: EnterpriseListStatus.loading));
    try {
      final data = await enterpriseRepository.list();
      emit(state.copyWith(
        status: EnterpriseListStatus.loaded,
        enterprises: data,
        filteredEnterprises: data,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EnterpriseListStatus.error,
        errorMessage: "Erro ao carregar empresas: $e",
      ));
    }
  }

  void filterEnterprises(String search) {
    final lower = search.toLowerCase();
    final filtered = (state.enterprises ?? []).where((enterprise) {
      final name = enterprise["name"]?.toString().toLowerCase() ?? "";
      final email = enterprise["email"]?.toString().toLowerCase() ?? "";
      return name.contains(lower) || email.contains(lower);
    }).toList();

    emit(state.copyWith(
      filteredEnterprises: filtered,
      search: search,
    ));
  }

  Future<void> impersonateEnterprise(String enterpriseId) async {
    try {
      await enterpriseRepository.impersonate(enterpriseId);
      emit(state.copyWith(status: EnterpriseListStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: EnterpriseListStatus.error,
        errorMessage: "Erro ao entrar na empresa: $e",
      ));
    }
  }
}
