import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

part 'auth_bloc_state.g.dart';

@match
enum AuthStateStatus { initial, loading, error, success, sectorSuccess }

class AuthBlocState extends Equatable {
  final AuthStateStatus status;
  final String? errorMessage;
  final String? successMessage;

  const AuthBlocState({
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  AuthBlocState.initial()
    : status = AuthStateStatus.initial,
      errorMessage = null,
      successMessage = null;

  @override
  List<Object?> get props => [status, errorMessage, successMessage];

  AuthBlocState copyWith({
    AuthStateStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthBlocState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
