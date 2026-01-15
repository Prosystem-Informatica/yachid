import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/login/login_repository.dart';
import 'login_bloc_state.dart';

class LoginBlocCubit extends Cubit<LoginBlocState> {
  final LoginRepository loginRepository;

  LoginBlocCubit({required this.loginRepository})
      : super(LoginBlocState.initial());

  Future<void> login(String identifier, String password) async {
    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      emit(state.copyWith(
        status: LoginStateStatus.error,
        errorMessage: "E-mail/CPF/CNPJ e senha são obrigatórios",
      ));
      return;
    }

    emit(state.copyWith(status: LoginStateStatus.loading));

    try {
      await loginRepository.login(identifier, password);

      emit(state.copyWith(
        status: LoginStateStatus.success,
        successMessage: "Login efetuado com sucesso",
      ));
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "").trim();
      emit(state.copyWith(
        status: LoginStateStatus.error,
        errorMessage:
        message.isEmpty ? "Erro inesperado ao efetuar login" : message,
      ));
    }
  }
}
