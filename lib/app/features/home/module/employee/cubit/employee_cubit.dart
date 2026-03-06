import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:yachid/app/repository/employee/employee_repository.dart';
import '../model/create_employee_dto.dart';
import '../model/branch_model.dart';
import '../model/employee_detail.dart';
import '../model/employee_model.dart';
import '../model/update_employee_dto.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository _repository;

  static String _parseErrorMessage(dynamic data) {
    if (data == null || data is! Map) return 'Erro ao criar funcionário';
    final msg = data['message'];
    if (msg == null) return 'Erro ao criar funcionário';
    if (msg is List) {
      return msg.map((e) => e?.toString() ?? '').join(', ').trim();
    }
    return msg.toString();
  }

  EmployeeCubit({required EmployeeRepository repository})
    : _repository = repository,
      super(const EmployeeState.initial());

  void resetState() {
    emit(
      state.copyWith(status: EmployeeStateStatus.initial, errorMessage: null),
    );
  }

  void setSelectedBranch(String? branchId, {String? enterpriseId}) {
    emit(state.copyWith(
      selectedBranchId: branchId,
      selectedEnterpriseId: enterpriseId ?? state.selectedEnterpriseId,
    ));
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

        await loadEmployees(branchId: branchId, token: token);
      } else {
        final msg = _parseErrorMessage(response.data);
        emit(
          state.copyWith(status: EmployeeStateStatus.error, errorMessage: msg),
        );
      }
    } catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          status: EmployeeStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadBranches(String enterpriseId, String token) async {
    emit(state.copyWith(isLoadingBranches: true, selectedEnterpriseId: enterpriseId));
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

  Future<void> loadEmployees({
    String? branchId,
    String? enterpriseId,
    required String token,
  }) async {
    emit(state.copyWith(isLoadingEmployees: true));
    try {
      final employees = await _repository.getEmployees(
        branchId: branchId,
        enterpriseId: enterpriseId,
        token: token,
      );
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

  Future<EmployeeDetail?> loadEmployeeDetail({
    required String id,
    required String token,
  }) async {
    try {
      return await _repository.getEmployee(id: id, token: token);
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStateStatus.error,
          errorMessage: 'Erro ao carregar funcionário: ${e.toString()}',
        ),
      );
      return null;
    }
  }

  Future<bool> updateEmployee({
    required String id,
    required UpdateEmployeeDto dto,
    required String token,
  }) async {
    emit(state.copyWith(status: EmployeeStateStatus.loading));
    try {
      final response = await _repository.updateEmployee(
        id: id,
        dto: dto,
        token: token,
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(status: EmployeeStateStatus.success));
        await loadEmployees(
          branchId: state.selectedBranchId,
          enterpriseId: state.selectedEnterpriseId,
          token: token,
        );
        return true;
      }
      final msg = _parseErrorMessage(response.data);
      emit(state.copyWith(status: EmployeeStateStatus.error, errorMessage: msg));
      return false;
    } catch (e) {
      emit(
        state.copyWith(
          status: EmployeeStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
      return false;
    }
  }
}
