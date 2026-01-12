import 'package:bloc/bloc.dart';

import 'auth_bloc_state.dart';

class AuthBlocCubit extends Cubit<AuthBlocState> {
  AuthBlocCubit() : super(AuthBlocState.initial());

  Future<void> login() async {}
}
