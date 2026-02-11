part of 'partners_cubit.dart';

sealed class PartnersState extends Equatable {
  const PartnersState();

  @override
  List<Object?> get props => [];
}

final class PartnersInitial extends PartnersState {}

final class PartnersLoaded extends PartnersState {
  final List<PartnerModelList> partners;
  final List<PartnerModelList> filteredPartners;
  final String filterDocument;
  final String filterCity;
  final String filterPhone;
  final String filterUf;
  final String filterCep;
  final PartnerStatus? filterStatus;
  final bool isLoading;
  final PaymentAddressDto? paymentAddress;

  const PartnersLoaded({
    required this.partners,
    required this.filteredPartners,
    this.filterDocument = '',
    this.filterCity = '',
    this.filterPhone = '',
    this.filterUf = '',
    this.filterCep = '',
    this.filterStatus,
    this.isLoading = false,
    this.paymentAddress,
  });

  @override
  List<Object?> get props => [
    partners,
    filteredPartners,
    filterDocument,
    filterCity,
    filterPhone,
    filterUf,
    filterCep,
    filterStatus,
    isLoading,
    paymentAddress,
  ];
}

final class PartnersError extends PartnersState {
  final String message;

  const PartnersError(this.message);

  @override
  List<Object?> get props => [message];
}
