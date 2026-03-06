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
  final List<GroupModel> groups;
  final String? selectedGroupId;
  final bool showRegisterCard;

  const PartnersLoaded({
    this.showRegisterCard = false,
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
    this.groups = const [],
    this.selectedGroupId,
  });

  PartnersLoaded copyWith({
    bool? showRegisterCard,
    List<PartnerModelList>? partners,
    List<PartnerModelList>? filteredPartners,
    String? filterDocument,
    String? filterCity,
    String? filterPhone,
    String? filterUf,
    String? filterCep,
    PartnerStatus? filterStatus,
    bool? isLoading,
    PaymentAddressDto? paymentAddress,
    List<GroupModel>? groups,
    String? selectedGroupId,
  }) {
    return PartnersLoaded(
      showRegisterCard: showRegisterCard ?? this.showRegisterCard,
      partners: partners ?? this.partners,
      filteredPartners: filteredPartners ?? this.filteredPartners,
      filterDocument: filterDocument ?? this.filterDocument,
      filterCity: filterCity ?? this.filterCity,
      filterPhone: filterPhone ?? this.filterPhone,
      filterUf: filterUf ?? this.filterUf,
      filterCep: filterCep ?? this.filterCep,
      filterStatus: filterStatus ?? this.filterStatus,
      isLoading: isLoading ?? this.isLoading,
      paymentAddress: paymentAddress ?? this.paymentAddress,
      groups: groups ?? this.groups,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
    );
  }

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
    groups,
    selectedGroupId,
    showRegisterCard,
  ];
}

final class PartnersError extends PartnersState {
  final String message;

  const PartnersError(this.message);

  @override
  List<Object?> get props => [message];
}
