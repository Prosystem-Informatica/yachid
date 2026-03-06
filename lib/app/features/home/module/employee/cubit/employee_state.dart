part of 'employee_cubit.dart';

enum EmployeeStateStatus { initial, loading, error, success }

class EmployeeState extends Equatable {
  final EmployeeStateStatus status;
  final String? errorMessage;
  final List<BranchModel> branches;
  final bool isLoadingBranches;
  final List<EmployeeModel> employees;
  final bool isLoadingEmployees;
  final String? selectedBranchId;
  final String? selectedEnterpriseId;

  const EmployeeState({
    required this.status,
    this.errorMessage,
    this.branches = const [],
    this.isLoadingBranches = false,
    this.employees = const [],
    this.isLoadingEmployees = false,
    this.selectedBranchId,
    this.selectedEnterpriseId,
  });

  const EmployeeState.initial()
    : status = EmployeeStateStatus.initial,
      errorMessage = null,
      branches = const [],
      isLoadingBranches = false,
      employees = const [],
      isLoadingEmployees = false,
      selectedBranchId = null,
      selectedEnterpriseId = null;

  EmployeeState copyWith({
    EmployeeStateStatus? status,
    String? errorMessage,
    List<BranchModel>? branches,
    bool? isLoadingBranches,
    List<EmployeeModel>? employees,
    bool? isLoadingEmployees,
    String? selectedBranchId,
    String? selectedEnterpriseId,
  }) {
    return EmployeeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      branches: branches ?? this.branches,
      isLoadingBranches: isLoadingBranches ?? this.isLoadingBranches,
      employees: employees ?? this.employees,
      isLoadingEmployees: isLoadingEmployees ?? this.isLoadingEmployees,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      selectedEnterpriseId: selectedEnterpriseId ?? this.selectedEnterpriseId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    branches,
    isLoadingBranches,
    employees,
    isLoadingEmployees,
    selectedBranchId,
    selectedEnterpriseId,
  ];
}
