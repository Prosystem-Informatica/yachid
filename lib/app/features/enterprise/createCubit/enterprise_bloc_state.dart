import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

part 'enterprise_bloc_state.g.dart';

@match
enum CreateEnterpriseStatus { initial, loading, success, error }

class CreateEnterpriseState extends Equatable {
  final CreateEnterpriseStatus status;
  final String? successMessage;
  final String? errorMessage;
  final Map<String, dynamic>? responseData;

  const CreateEnterpriseState({
    required this.status,
    this.successMessage,
    this.errorMessage,
    this.responseData,
  });

  factory CreateEnterpriseState.initial() =>
      const CreateEnterpriseState(status: CreateEnterpriseStatus.initial);

  CreateEnterpriseState copyWith({
    CreateEnterpriseStatus? status,
    String? successMessage,
    String? errorMessage,
    Map<String, dynamic>? responseData,
  }) {
    return CreateEnterpriseState(
      status: status ?? this.status,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      responseData: responseData ?? this.responseData,
    );
  }

  @override
  List<Object?> get props => [status, successMessage, errorMessage, responseData];
}
