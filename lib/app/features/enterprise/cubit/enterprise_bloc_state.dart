import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

part 'enterprise_bloc_state.g.dart';

@match
enum EnterpriseListStatus { initial, loading, loaded, error , success }

class EnterpriseListState extends Equatable {
  final EnterpriseListStatus status;
  final List<Map<String, dynamic>> enterprises;
  final List<Map<String, dynamic>> filteredEnterprises;
  final String search;
  final String? errorMessage;

  const EnterpriseListState({
    required this.status,
    required this.enterprises,
    required this.filteredEnterprises,
    required this.search,
    this.errorMessage,
  });

  factory EnterpriseListState.initial() => const EnterpriseListState(
    status: EnterpriseListStatus.initial,
    enterprises: [],
    filteredEnterprises: [],
    search: "",
  );

  EnterpriseListState copyWith({
    EnterpriseListStatus? status,
    List<Map<String, dynamic>>? enterprises,
    List<Map<String, dynamic>>? filteredEnterprises,
    String? search,
    String? errorMessage,
  }) {
    return EnterpriseListState(
      status: status ?? this.status,
      enterprises: enterprises ?? this.enterprises,
      filteredEnterprises: filteredEnterprises ?? this.filteredEnterprises,
      search: search ?? this.search,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, enterprises, filteredEnterprises, search, errorMessage];
}
