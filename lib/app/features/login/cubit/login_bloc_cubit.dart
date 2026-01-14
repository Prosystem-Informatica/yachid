import 'package:bloc/bloc.dart';
import '../../../repositories/login/login_repository.dart';
import '../../../repositories/enterprise/enterprise_repository.dart';
import 'login_bloc_state.dart';

class LoginBlocCubit extends Cubit<LoginBlocState> {
  final LoginRepository loginRepository;
  final EnterpriseRepository enterpriseRepository;

  LoginBlocCubit({
    required this.loginRepository,
    required this.enterpriseRepository,
  }) : super(LoginBlocState.initial());

  Future<void> login(String identifier, String password) async {
    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      emit(
        state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: "E-mail/CPF/CNPJ e senha são obrigatórios",
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStateStatus.loading));

    try {
      await loginRepository.login(identifier, password);

      emit(
        state.copyWith(
          status: LoginStateStatus.success,
          successMessage: "Login efetuado com sucesso",
        ),
      );
    } catch (e) {
      final message = e.toString().replaceAll("Exception: ", "").trim();

      emit(
        state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: message.isEmpty
              ? "Erro inesperado ao efetuar login"
              : message,
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAccessibleEnterprises() async {
    try {
      final identifier = loginRepository.getLoggedIdentifier();
      if (identifier.toLowerCase() == "prosystem@informatica.com") {
        return await enterpriseRepository.list();
      }

      final allEnterprises = await enterpriseRepository.list();
      return allEnterprises;
    } catch (e) {
      throw Exception("Erro ao buscar empresas: $e");
    }
  }

  Future<void> impersonateEnterprise(String enterpriseId) async {
    try {
      await enterpriseRepository.impersonate(enterpriseId);
    } catch (e) {
      throw Exception("Erro ao entrar na empresa: $e");
    }
  }
}
