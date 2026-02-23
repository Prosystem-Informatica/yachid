import 'dart:convert';
import 'dart:developer';

import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';

import 'package:yachid/app/features/home/module/partners/module/widgets/payment_address/model/payment_address_model.dart';

class PaymentAddressRepository {
  final RestClient _rest;

  PaymentAddressRepository({required RestClient rest}) : _rest = rest;

  Future<RestClientResponse<dynamic>> getMyPaymentAddress(
    String partnerId,
  ) async {
    try {
      final response = await _rest.get('/payment-address/$partnerId');
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> updatePaymentAddress(
    PaymentAddressModel paymentAddress,
    String token,
  ) async {
    try {
      final response = await _rest.patch(
        '/payment-address/${paymentAddress.id}',
        data: jsonEncode(paymentAddress.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
