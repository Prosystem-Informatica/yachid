import 'dart:convert';
import 'dart:developer';
import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';

class DeliveryAddressRepository {
  final RestClient _rest;

  DeliveryAddressRepository({required RestClient rest}) : _rest = rest;

  Future<RestClientResponse<dynamic>> getDeliveryAddresses({
    required String token,
    required String partnerId,
  }) async {
    try {
      final response = await _rest.get(
        '/delivery-address/$partnerId',
        headers: {'Authorization': 'Bearer $token'},
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> updateDeliveryAddress({
    required String token,
    required String deliveryAddressId,
    required DeliveryAddress updateDeliveryAddressDto,
  }) async {
    try {
      final response = await _rest.patch(
        '/delivery-address/$deliveryAddressId/update',
        data: jsonEncode(updateDeliveryAddressDto.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> createDeliveryAddress({
    required String token,
    required DeliveryAddress createDeliveryAddressDto,
    required String partnerId,
  }) async {
    try {
      final response = await _rest.post(
        '/delivery-address/$partnerId/create',
        data: jsonEncode(createDeliveryAddressDto.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
