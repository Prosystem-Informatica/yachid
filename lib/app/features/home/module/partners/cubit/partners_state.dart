part of 'partners_cubit.dart';

sealed class PartnersState extends Equatable {
  const PartnersState();

  @override
  List<Object?> get props => [];
}

final class PartnersInitial extends PartnersState {}

final class PartnersLoaded extends PartnersState {
  final List<PartnerModel> partners;
  final List<PartnerModel> filteredPartners;
  final String filterDocument;
  final String filterCity;
  final String filterPhone;
  final String filterUf;
  final String filterCep;
  final PartnerStatus? filterStatus;
  final bool isLoading;

  PartnersLoaded({
    required this.partners,
    required this.filteredPartners,
    this.filterDocument = '',
    this.filterCity = '',
    this.filterPhone = '',
    this.filterUf = '',
    this.filterCep = '',
    this.filterStatus,
    this.isLoading = false,
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
      ];
}

final class PartnersError extends PartnersState {
  final String message;

  PartnersError(this.message);

  @override
  List<Object?> get props => [message];
}
