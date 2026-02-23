import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/model/partner_account.dart';
import 'package:yachid/app/repository/accounts/accounts_repository.dart';

part 'partner_statistics_state.dart';

class PartnerStatisticsCubit extends Cubit<PartnerStatisticsState> {
  final AccountsRepository _repository;
  PartnerStatisticsCubit({required AccountsRepository repository})
    : _repository = repository,
      super(PartnerStatisticsInitial());

  void loadPartnerStatistics(String partnerId, {String? token}) async {
    try {
      final results = await Future.wait([
        _repository.getPartnerCreditConfig(partnerId, token: token),
        _repository.getAccountsPayable(partnerId, token: token),
        _repository.getAccountsReceivable(partnerId, token: token),
      ]);

      PartnerCreditConfig? creditConfig;
      AccountsPayableModel? payable;
      AccountsReceivableModel? receivable;

      if (results[0].statusCode == 200) {
        creditConfig = PartnerCreditConfig.fromJson(
          results[0].data as Map<String, dynamic>,
        );
      } else if (results[0].statusCode != 404) {
        final msg = results[0].data?.toString() ?? 'Erro ao carregar crédito';
        emit(PartnerStatisticsError(msg));
        return;
      }

      if (results[1].statusCode == 200) {
        payable = AccountsPayableModel.fromJson(
          results[1].data as Map<String, dynamic>,
        );
      } else if (results[1].statusCode != 404) {
        final msg = results[1].data?.toString() ?? 'Erro ao carregar contas a pagar';
        emit(PartnerStatisticsError(msg));
        return;
      }

      if (results[2].statusCode == 200) {
        receivable = AccountsReceivableModel.fromJson(
          results[2].data as Map<String, dynamic>,
        );
      } else if (results[2].statusCode != 404) {
        final msg = results[2].data?.toString() ?? 'Erro ao carregar contas a receber';
        emit(PartnerStatisticsError(msg));
        return;
      }

      if (!isClosed &&
          (state is PartnerStatisticsLoaded || state is PartnerStatisticsInitial)) {
        emit(
          PartnerStatisticsLoaded(
            isEditingConfigData: false,
            isEditingAccountPayable: false,
            isEditingAccountReceivable: false,
            partnerCreditConfig: creditConfig,
            accountsPayable: payable,
            accountsReceivable: receivable,
          ),
        );
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(PartnerStatisticsError(e.toString()));
    }
  }

  void getPartnerCreditConfig(String partnerId, {String? token}) async {
    loadPartnerStatistics(partnerId, token: token);
  }

  void createPartnerCreditConfig(
    String partnerId,
    PartnerCreditConfig config, {
    required String token,
  }) async {
    if (state is! PartnerStatisticsLoaded) return;
    try {
      final response = await _repository.createPartnerCreditConfig(
        partnerId,
        config,
        token: token,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = PartnerCreditConfig.fromJson(
          response.data as Map<String, dynamic>,
        );
        emit(
          (state as PartnerStatisticsLoaded).copyWith(
            partnerCreditConfig: data,
            isEditingConfigData: false,
          ),
        );
      } else {
        emit(PartnerStatisticsError(
          (response.data is Map
                  ? response.data['message']
                  : response.data)
              ?.toString() ??
              'Erro ao criar configuração',
        ));
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(PartnerStatisticsError(e.toString()));
    }
  }

  void updatePartnerCreditConfig(
    String partnerId,
    PartnerCreditConfig config, {
    required String token,
  }) async {
    if (state is! PartnerStatisticsLoaded) return;
    try {
      final response = await _repository.updatePartnerCreditConfig(
        partnerId,
        config,
        token: token,
      );
      if (response.statusCode == 200) {
        final data = PartnerCreditConfig.fromJson(
          response.data as Map<String, dynamic>,
        );
        emit(
          (state as PartnerStatisticsLoaded).copyWith(
            partnerCreditConfig: data,
            isEditingConfigData: false,
          ),
        );
      } else {
        emit(PartnerStatisticsError(
          (response.data is Map
                  ? response.data['message']
                  : response.data)
              ?.toString() ??
              'Erro ao atualizar configuração',
        ));
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(PartnerStatisticsError(e.toString()));
    }
  }

  void setEditingConfigData(bool isEditing) {
    if (state is PartnerStatisticsLoaded) {
      emit(
        (state as PartnerStatisticsLoaded).copyWith(
          isEditingConfigData: isEditing,
        ),
      );
    }
  }

  void setPartnerCreditConfigForEditing(PartnerCreditConfig config) {
    if (state is PartnerStatisticsLoaded) {
      emit(
        (state as PartnerStatisticsLoaded).copyWith(
          partnerCreditConfig: config,
        ),
      );
    }
  }

  void setEditingAccountPayable(bool isEditing) {
    if (state is PartnerStatisticsLoaded) {
      emit(
        (state as PartnerStatisticsLoaded).copyWith(
          isEditingAccountPayable: isEditing,
        ),
      );
    }
  }

  void setEditingAccountReceivable(bool isEditing) {
    if (state is PartnerStatisticsLoaded) {
      emit(
        (state as PartnerStatisticsLoaded).copyWith(
          isEditingAccountReceivable: isEditing,
        ),
      );
    }
  }

  void createAccountsPayable(
    String partnerId,
    AccountsPayableModel data, {
    required String token,
  }) async {
    if (state is! PartnerStatisticsLoaded) return;
    try {
      final response = await _repository.createAccountsPayable(
        partnerId,
        data,
        token: token,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = AccountsPayableModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        emit(
          (state as PartnerStatisticsLoaded).copyWith(
            accountsPayable: model,
            isEditingAccountPayable: false,
          ),
        );
      } else {
        emit(PartnerStatisticsError(
          (response.data is Map ? response.data['message'] : response.data)
              ?.toString() ??
              'Erro ao criar contas a pagar',
        ));
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(PartnerStatisticsError(e.toString()));
    }
  }

  void updateAccountsPayable(
    String partnerId,
    AccountsPayableModel data, {
    required String token,
  }) async {
    if (state is! PartnerStatisticsLoaded) return;
    try {
      final response = await _repository.updateAccountsPayable(
        partnerId,
        data,
        token: token,
      );
      if (response.statusCode == 200) {
        final model = AccountsPayableModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        emit(
          (state as PartnerStatisticsLoaded).copyWith(
            accountsPayable: model,
            isEditingAccountPayable: false,
          ),
        );
      } else {
        emit(PartnerStatisticsError(
          (response.data is Map ? response.data['message'] : response.data)
              ?.toString() ??
              'Erro ao atualizar contas a pagar',
        ));
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(PartnerStatisticsError(e.toString()));
    }
  }

  void createAccountsReceivable(
    String partnerId,
    AccountsReceivableModel data, {
    required String token,
  }) async {
    if (state is! PartnerStatisticsLoaded) return;
    try {
      final response = await _repository.createAccountsReceivable(
        partnerId,
        data,
        token: token,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final model = AccountsReceivableModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        emit(
          (state as PartnerStatisticsLoaded).copyWith(
            accountsReceivable: model,
            isEditingAccountReceivable: false,
          ),
        );
      } else {
        emit(PartnerStatisticsError(
          (response.data is Map ? response.data['message'] : response.data)
              ?.toString() ??
              'Erro ao criar contas a receber',
        ));
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(PartnerStatisticsError(e.toString()));
    }
  }

  void updateAccountsReceivable(
    String partnerId,
    AccountsReceivableModel data, {
    required String token,
  }) async {
    if (state is! PartnerStatisticsLoaded) return;
    try {
      final response = await _repository.updateAccountsReceivable(
        partnerId,
        data,
        token: token,
      );
      if (response.statusCode == 200) {
        final model = AccountsReceivableModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        emit(
          (state as PartnerStatisticsLoaded).copyWith(
            accountsReceivable: model,
            isEditingAccountReceivable: false,
          ),
        );
      } else {
        emit(PartnerStatisticsError(
          (response.data is Map ? response.data['message'] : response.data)
              ?.toString() ??
              'Erro ao atualizar contas a receber',
        ));
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      emit(PartnerStatisticsError(e.toString()));
    }
  }

  void setStatePartnerStatistics(PartnerStatisticsState state) {
    emit(state);
  }
}
