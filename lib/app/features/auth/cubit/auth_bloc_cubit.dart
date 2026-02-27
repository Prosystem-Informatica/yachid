import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/models.dart';
import '../../../repository/repositories.dart';
import 'auth_bloc_state.dart';

class AuthBlocCubit extends Cubit<AuthBlocState> {
  final AuthRepository authRepository;
  late SharedPreferences prefs;

  AuthBlocCubit({required this.authRepository})
    : super(AuthBlocState.initial());

  void resetState() {
    emit(AuthBlocState.initial());
  }

  Future<void> login({required email, required password}) async {
    try {
      prefs = await SharedPreferences.getInstance();

      emit(state.copyWith(status: AuthStateStatus.loading));
      final authValidation = await authRepository.auth(
        email: email,
        password: password,
      );
      if (authValidation.isSuccess) {
        emit(
          state.copyWith(
            status: AuthStateStatus.success,
            authModel: authValidation,
            enterprisesModels: authValidation.user?.enterpriseModel ?? [],
          ),
        );
      }
      if (!authValidation.isSuccess) {
        emit(
          state.copyWith(
            status: AuthStateStatus.error,
            errorMessage: authValidation.message ?? "Erro ao efetuar login",
            enterprisesModels: [],
          ),
        );
      }
    } on Exception {
      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: "Erro ao efetuar Login",
          enterprisesModels: [],
        ),
      );
    }
  }

  Future<void> getCompanies({required entrepreneurId, required token}) async {
    try {
      prefs = await SharedPreferences.getInstance();

      emit(state.copyWith(status: AuthStateStatus.loading));
      final res = await authRepository.getCompanies(entrepreneurId, token);
      emit(
        state.copyWith(status: AuthStateStatus.success, enterprisesModels: res),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: "Erro ao efetuar a busca",
        ),
      );
    }
  }

  Future<void> createCompanies({
    required CreateEnterpriseModel companie,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();

      emit(state.copyWith(status: AuthStateStatus.loading));
      final res = await authRepository.createCompanies(companie: companie);

      if (res.isSuccess) {
        final entrepreneurId = prefs.getString("entrepreneurId") ?? '';
        final token = state.authModel.token ?? '';
        await getCompanies(entrepreneurId: entrepreneurId, token: token);
      }
    } on Exception {
      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: "Erro ao criar empresa",
        ),
      );
    }
  }

  Future<void> forgotPassword({required String email}) async {
    await authRepository.forgotPassword(email: email);
  }

  void selectCompany(EnterpriseModel companie) {
    emit(
      state.copyWith(
        selectedCompanie: companie,
        status: AuthStateStatus.selectedSucess,
      ),
    );
  }
}
