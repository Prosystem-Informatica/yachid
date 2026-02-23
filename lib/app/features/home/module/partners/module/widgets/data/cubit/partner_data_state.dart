part of 'partner_data_cubit.dart';

@immutable
sealed class PartnerDataState extends Equatable {}

final class PartnerDataInitial extends PartnerDataState {
  @override
  List<Object?> get props => [];
}

final class PartnerDataLoaded extends PartnerDataState {
  final bool isEditing;
  final PartnerDetails partner;

  PartnerDataLoaded({required this.isEditing, required this.partner});

  @override
  List<Object?> get props => [isEditing, partner];

  PartnerDataLoaded copyWith({bool? isEditing, PartnerDetails? partner}) {
    return PartnerDataLoaded(
      isEditing: isEditing ?? this.isEditing,
      partner: partner ?? this.partner,
    );
  }
}

final class PartnerDataError extends PartnerDataState {
  final String message;

  PartnerDataError(this.message);

  @override
  List<Object?> get props => [message];
}
