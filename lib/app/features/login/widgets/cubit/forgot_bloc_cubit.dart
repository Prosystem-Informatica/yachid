import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../repositories/auth/auth_repository.dart';
import 'forgot_bloc_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordCubit({required this.authRepository})
      : super(ForgotPasswordState.initial());

  Future<void> requestResetCode(String email) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        message: "Informe um e-mail válido.",
        isError: true,
      ));
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await authRepository.requestPasswordReset(email.trim());
      emit(state.copyWith(
        status: ForgotPasswordStatus.codeSent,
        message: "Um código foi enviado para seu e-mail",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        message: "Erro ao enviar código. Verifique o e-mail e tente novamente.",
        isError: true,
      ));
    }
  }

  Future<void> verifyCode(String email, String code) async {
    if (code.trim().isEmpty) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        message: "Informe o código recebido por e-mail.",
        isError: true,
      ));
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await authRepository.verifyResetCode(email, code);
      emit(state.copyWith(
        status: ForgotPasswordStatus.codeVerified,
        message: "Código verificado com sucesso ",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        message: "Código inválido ou expirado. Tente novamente.",
        isError: true,
      ));
    }
  }

  Future<void> resetPassword(String email, String code, String newPassword) async {
    if (newPassword.trim().length < 6) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        message: "A senha deve ter pelo menos 6 caracteres.",
        isError: true,
      ));
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await authRepository.resetPassword(email, code, newPassword);
      emit(state.copyWith(
        status: ForgotPasswordStatus.success,
        message: "Senha redefinida com sucesso ",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.error,
        message: "Erro ao redefinir senha. Verifique o código e tente novamente.",
        isError: true,
      ));
    }
  }

  void reset() {
    emit(ForgotPasswordState.initial());
  }
}
