part of 'partner_statistics_cubit.dart';

@immutable
sealed class PartnerStatisticsState extends Equatable {}

final class PartnerStatisticsInitial extends PartnerStatisticsState {
  @override
  List<Object?> get props => [];
}

final class PartnerStatisticsLoaded extends PartnerStatisticsState {
  final bool isEditingConfigData;
  final bool isEditingAccountPayable;
  final bool isEditingAccountReceivable;
  final PartnerCreditConfig? partnerCreditConfig;
  final AccountsPayableModel? accountsPayable;
  final AccountsReceivableModel? accountsReceivable;

  PartnerStatisticsLoaded({
    required this.isEditingConfigData,
    required this.isEditingAccountPayable,
    required this.isEditingAccountReceivable,
    this.partnerCreditConfig,
    this.accountsPayable,
    this.accountsReceivable,
  });

  PartnerStatisticsLoaded copyWith({
    PartnerCreditConfig? partnerCreditConfig,
    AccountsPayableModel? accountsPayable,
    AccountsReceivableModel? accountsReceivable,
    bool? isEditingConfigData,
    bool? isEditingAccountPayable,
    bool? isEditingAccountReceivable,
  }) {
    return PartnerStatisticsLoaded(
      isEditingConfigData: isEditingConfigData ?? this.isEditingConfigData,
      isEditingAccountPayable:
          isEditingAccountPayable ?? this.isEditingAccountPayable,
      isEditingAccountReceivable:
          isEditingAccountReceivable ?? this.isEditingAccountReceivable,
      partnerCreditConfig: partnerCreditConfig ?? this.partnerCreditConfig,
      accountsPayable: accountsPayable ?? this.accountsPayable,
      accountsReceivable: accountsReceivable ?? this.accountsReceivable,
    );
  }

  @override
  List<Object?> get props => [
    isEditingConfigData,
    isEditingAccountPayable,
    isEditingAccountReceivable,
    partnerCreditConfig,
    accountsPayable,
    accountsReceivable,
  ];
}

final class PartnerStatisticsError extends PartnerStatisticsState {
  final String message;

  PartnerStatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}
