import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:yachid/app/repository/employee/employee_repository.dart';
import '../model/create_employee_dto.dart';
import '../model/branch_model.dart';
import '../model/employee_model.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository _repository;

  EmployeeCubit({required EmployeeRepository repository})
    : _repository = repository,
      super(const EmployeeState.initial());

  void resetState() {
    // Reseta apenas o status de criação, mantendo a listagem e filtros
    emit(
      state.copyWith(status: EmployeeStateStatus.initial, errorMessage: null),
    );
  }

  void setSelectedBranch(String? branchId) {
    emit(state.copyWith(selectedBranchId: branchId));
  }

  void clearEmployees() {
    emit(state.copyWith(employees: []));
  }

  Future<void> createEmployee(
    CreateEmployeeDto dto,
    String token,
    String branchId,
  ) async {
    emit(state.copyWith(status: EmployeeStateStatus.loading));
    try {
      final response = await _repository.createEmployee(dto, token, branchId);
      if (response.statusCode == 204) {
        emit(state.copyWith(status: EmployeeStateStatus.success));

        await loadEmployees(branchId, token);
      } else {
        emit(
          state.copyWith(
            status: EmployeeStateStatus.error,
            errorMessage:
                response.data['message'] ?? 'Erro ao criar funcionário',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadBranches(String enterpriseId, String token) async {
    emit(state.copyWith(isLoadingBranches: true));
    try {
      final branches = await _repository.getBranches(enterpriseId, token);
      emit(state.copyWith(branches: branches, isLoadingBranches: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingBranches: false,
          errorMessage: 'Erro ao carregar filiais: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> loadEmployees(String branchId, String token) async {
    emit(state.copyWith(isLoadingEmployees: true));
    try {
      final employees = await _repository.getEmployees(branchId, token);
      emit(state.copyWith(employees: employees, isLoadingEmployees: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingEmployees: false,
          errorMessage: 'Erro ao carregar funcionários: ${e.toString()}',
        ),
      );
    }
  }
}
