import 'dart:convert';

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
          ),
        );
      }
      if (!authValidation.isSuccess) {
        emit(
          state.copyWith(
            status: AuthStateStatus.error,
            errorMessage: authValidation.message ?? "Erro ao efetuar login",
            authModel: authValidation,
          ),
        );
      }
    } on Exception {
      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: "Erro ao efetuar Login",
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

      if (res.statusCode == 201) {
        var jsonData = EnterpriseModel.fromJson(res.data);

        final companiesString = prefs.getString("companies");
        List<Map<String, dynamic>> companiesList = [];

        if (companiesString != null) {
          companiesList = List<Map<String, dynamic>>.from(
            jsonDecode(companiesString),
          );
        }

        // Adiciona a nova empresa à lista
        companiesList.add(jsonData.toJson());

        // Salva a lista atualizada
        prefs.setString("companies", jsonEncode(companiesList));
      } else {
        emit(
          state.copyWith(
            status: AuthStateStatus.error,
            errorMessage: res.data['message'].toString(),
          ),
        );
      }
    } on Exception catch (e) {
      print(e.toString());
      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
