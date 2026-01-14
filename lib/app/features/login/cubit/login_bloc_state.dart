import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

part 'login_bloc_state.g.dart';

@match
enum LoginStateStatus { initial, loading, error, success }

class LoginBlocState extends Equatable {
  final LoginStateStatus status;
  final String? errorMessage;
  final String? successMessage;

  const LoginBlocState({
    required this.status,
    this.errorMessage,
    this.successMessage,
  });

  factory LoginBlocState.initial() => const LoginBlocState(
    status: LoginStateStatus.initial,
  );

  @override
  List<Object?> get props => [status, errorMessage, successMessage];

  LoginBlocState copyWith({
    LoginStateStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return LoginBlocState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
