part of 'payment_address_cubit.dart';

@immutable
sealed class PaymentAddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class PaymentAddressInitial extends PaymentAddressState {
  @override
  List<Object?> get props => [];
}

final class PaymentAddressLoaded extends PaymentAddressState {
  final PaymentAddressModel paymentAddress;
  final bool isEditing;
  PaymentAddressLoaded({required this.paymentAddress, this.isEditing = false});

  PaymentAddressLoaded copyWith({
    PaymentAddressModel? paymentAddress,
    bool? isEditing,
  }) {
    return PaymentAddressLoaded(
      paymentAddress: paymentAddress ?? this.paymentAddress,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  List<Object?> get props => [paymentAddress, isEditing];
}

final class PaymentAddressError extends PaymentAddressState {
  final String message;
  PaymentAddressError({required this.message});

  @override
  List<Object?> get props => [message];
}
