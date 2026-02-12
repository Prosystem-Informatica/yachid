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
  final List<DeliveryAddress> deliveryAddresses;
  const PartnerDetailsLoaded({
    this.partnerId,
    required this.partner,
    required this.selectedIndex,
    required this.deliveryAddresses,
  });

  @override
  List<Object?> get props => [
    partner,
    selectedIndex,
    deliveryAddresses,
    partnerId,
  ];

  PartnerDetailsLoaded copyWith({
    PartnerDetails? partner,
    int? selectedIndex,
    List<DeliveryAddress>? deliveryAddresses,
    String? partnerId,
  }) {
    return PartnerDetailsLoaded(
      partner: partner ?? this.partner,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      deliveryAddresses: deliveryAddresses ?? this.deliveryAddresses,
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
