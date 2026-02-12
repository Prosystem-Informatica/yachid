import 'dart:convert';
import 'dart:developer';

import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';
import 'package:yachid/app/features/home/module/partners/model/partner_model.dart';
import 'package:yachid/app/features/home/module/partners/model/partner_model_list.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';

class PartnersRepository {
  final RestClient _rest;

  PartnersRepository({required RestClient rest}) : _rest = rest;

  Future<List<PartnerModelList>> getPartners({
    String? branchId,
    String? enterpriseId,
    required String token,
  }) async {
    try {
      final response = await _rest.get(
        '/partners',
        headers: {'Authorization': 'Bearer $token'},
        queryParameters: {'branchId': branchId, 'enterpriseId': enterpriseId},
      );

      final List<PartnerModelList> list = [];
      for (final element in response.data['partners'] as List<dynamic>) {
        list.add(PartnerModelList.fromJson(element as Map<String, dynamic>));
      }

      return list;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> createPartner(
    PartnerModelDto partner,
    String partnerType,
    String token,
  ) async {
    try {
      final response = await _rest.post(
        '/partners/$partnerType/create',
        data: jsonEncode(partner.toJson()),
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

  Future<RestClientResponse<dynamic>> getPartnerDetails(
    String partnerId,
    String token,
  ) async {
    try {
      final response = await _rest.get(
        '/partners/$partnerId',
        headers: {'Authorization': 'Bearer $token'},
      );
      print('response: ${response.data}');
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> createDeliveryAddress(
    DeliveryAddress deliveryAddress,
    String partnerId,
    String token,
  ) async {
    try {
      final response = await _rest.post(
        '/delivery-address/$partnerId/create',
        data: jsonEncode(deliveryAddress.toJson()),
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
