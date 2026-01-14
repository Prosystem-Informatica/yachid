import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

part 'forgot_bloc_state.g.dart';

@match
enum ForgotPasswordStatus {
  initial,
  loading,
  codeSent,
  codeVerified,
  success,
  error
}

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final String? message;
  final bool isError;

  const ForgotPasswordState({
    required this.status,
    this.message,
    this.isError = false,
  });

  factory ForgotPasswordState.initial() =>
      const ForgotPasswordState(status: ForgotPasswordStatus.initial);

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? message,
    bool? isError,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [status, message, isError];
}
