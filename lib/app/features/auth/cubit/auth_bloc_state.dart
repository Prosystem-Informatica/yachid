import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:match/match.dart';

import '../../../model/models.dart';

part 'auth_bloc_state.g.dart';

@match
enum AuthStateStatus { initial, loading, error, success, sectorSuccess, selectedSucess }

class AuthController extends GetxController {
  late AuthModel authModel;
}

class AuthBlocState extends Equatable {
  final AuthStateStatus status;
  final String? errorMessage;
  final String? successMessage;
  final AuthModel authModel;
  final List<EnterpriseModel>? enterprisesModels;
  final EnterpriseModel? selectedCompanie;

  const AuthBlocState({
    required this.status,
    this.errorMessage,
    this.successMessage,
    required this.authModel,
    this.enterprisesModels,
    this.selectedCompanie,
  });

  AuthBlocState.initial()
    : status = AuthStateStatus.initial,
      errorMessage = null,
      successMessage = null,
      authModel = AuthModel(),
      enterprisesModels = null,
      selectedCompanie = EnterpriseModel();

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    successMessage,
    authModel,
    enterprisesModels,
    selectedCompanie,
  ];

  AuthBlocState copyWith({
    AuthStateStatus? status,
    String? errorMessage,
    String? successMessage,
    AuthModel? authModel,
    List<EnterpriseModel>? enterprisesModels,
    EnterpriseModel? selectedCompanie,
  }) {
    return AuthBlocState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      authModel: authModel ?? this.authModel,
      enterprisesModels: enterprisesModels ?? this.enterprisesModels,
      selectedCompanie: selectedCompanie ?? this.selectedCompanie,
    );
  }
}
