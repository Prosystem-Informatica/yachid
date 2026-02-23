import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/payment_address/model/payment_address_model.dart';
import 'package:yachid/app/repository/payment_address/payment_address.dart';

part 'payment_address_state.dart';

class PaymentAddressCubit extends Cubit<PaymentAddressState> {
  final PaymentAddressRepository _repository;
  PaymentAddressCubit({required PaymentAddressRepository repository})
    : _repository = repository,
      super(PaymentAddressInitial());

  void getPaymentAddress(String partnerId) async {
    try {
      final paymentAddress = await _repository.getMyPaymentAddress(partnerId);
      if (paymentAddress.statusCode == 200) {
        emit(
          PaymentAddressLoaded(
            paymentAddress: PaymentAddressModel.fromJson(
              paymentAddress.data as Map<String, dynamic>,
            ),
          ),
        );
      } else if (paymentAddress.statusCode == 404) {
        emit(
          PaymentAddressLoaded(
            paymentAddress: PaymentAddressModel(
              id: null,
              street: '',
              neighborhood: '',
              city: '',
              uf: '',
              cep: '',
              number: '',
              phone: '',
              email: '',
              observations: '',
            ),
          ),
        );
      } else {
        final msg =
            (paymentAddress.data is Map
                    ? paymentAddress.data['message']
                    : paymentAddress.data)
                ?.toString() ??
            'Erro ao carregar endereço de pagamento';
        emit(PaymentAddressError(message: msg));
      }
    } catch (e) {
      emit(PaymentAddressError(message: e.toString()));
    }
  }

  Future<bool> updatePaymentAddress(
    String partnerId,
    PaymentAddressModel paymentAddress,
    String token,
  ) async {
    try {
      final response = await _repository.updatePaymentAddress(
        paymentAddress,
        token,
      );
      if (response.statusCode == 204) {
        getPaymentAddress(partnerId);
        return true;
      } else {
        final msg =
            (response.data is Map ? response.data['message'] : response.data)
                ?.toString() ??
            'Erro ao atualizar endereço de pagamento';
        emit(PaymentAddressError(message: msg));
        return false;
      }
    } catch (e) {
      emit(PaymentAddressError(message: e.toString()));
      return false;
    }
  }

  void setIsEditing(bool isEditing) {
    emit((state as PaymentAddressLoaded).copyWith(isEditing: isEditing));
  }
}
