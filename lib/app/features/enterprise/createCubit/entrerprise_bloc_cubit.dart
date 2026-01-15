import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/enterprise/create_enterprise_repository.dart';
import 'enterprise_bloc_state.dart';

class CreateEnterpriseCubit extends Cubit<CreateEnterpriseState> {
  final CreateEnterpriseRepository repository;

  CreateEnterpriseCubit({required this.repository})
      : super(CreateEnterpriseState.initial());

  Future<void> createEnterprise(Map<String, dynamic> data) async {
    emit(state.copyWith(status: CreateEnterpriseStatus.loading));
    try {
      final result = await repository.create(data);

      final enterpriseId = result["enterprise_id"];
      final subEnterpriseId = result["sub_enterprise_id"];

      emit(state.copyWith(
        status: CreateEnterpriseStatus.success,
        successMessage: "Empresa criada com sucesso",
        responseData: result,
      ));

    } catch (e) {
      emit(state.copyWith(
        status: CreateEnterpriseStatus.error,
        errorMessage: "Erro ao criar empresa: $e",
      ));
    }
  }
}
