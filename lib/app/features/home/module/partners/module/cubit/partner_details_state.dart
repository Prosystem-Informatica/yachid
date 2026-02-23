part of 'partner_details_cubit.dart';

@immutable
sealed class PartnerDetailsState extends Equatable {
  const PartnerDetailsState();

  @override
  List<Object?> get props => [];
}

final class PartnerDetailsInitial extends PartnerDetailsState {}

final class PartnerDetailsLoaded extends PartnerDetailsState {
  final String? partnerId;
  final PartnerDetails partner;
  final int selectedIndex;
  const PartnerDetailsLoaded({
    this.partnerId,
    required this.partner,
    required this.selectedIndex,
  });

  @override
  List<Object?> get props => [partner, selectedIndex, partnerId];

  PartnerDetailsLoaded copyWith({
    PartnerDetails? partner,
    int? selectedIndex,
    List<DeliveryAddress>? deliveryAddresses,
    String? partnerId,
  }) {
    return PartnerDetailsLoaded(
      partner: partner ?? this.partner,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      partnerId: partnerId ?? this.partnerId,
    );
  }
}

final class PartnerDetailsError extends PartnerDetailsState {
  final String message;

  const PartnerDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
