import 'dart:convert';
import 'dart:developer';

import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';
import 'package:yachid/app/features/home/module/partners/model/group_model.dart';
import 'package:yachid/app/features/home/module/partners/model/partner_model.dart';
import 'package:yachid/app/features/home/module/partners/model/partner_model_list.dart';
import 'package:yachid/app/features/home/module/partners/model/update_partner_dto.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';

class PartnersRepository {
  final RestClient _rest;

  PartnersRepository({required RestClient rest}) : _rest = rest;

  Future<List<GroupModel>> getGroups({required String token}) async {
    try {
      final response = await _rest.get(
        '/groups',
        headers: {'Authorization': 'Bearer $token'},
      );
      final list = <GroupModel>[];
      if (response.data is List) {
        for (final element in response.data as List) {
          list.add(GroupModel.fromJson(element as Map<String, dynamic>));
        }
      }
      return list;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<PartnerModelList>> getPartners({
    required String groupId,
    required String token,
  }) async {
    try {
      final response = await _rest.get(
        '/partners',
        headers: {'Authorization': 'Bearer $token'},
        queryParameters: {'groupId': groupId},
      );

      final List<PartnerModelList> list = [];
      final partners = response.data['partners'];
      if (partners is List) {
        for (final element in partners) {
          list.add(PartnerModelList.fromJson(element as Map<String, dynamic>));
        }
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

  Future<RestClientResponse<dynamic>> updatePartner(
    String partnerId,
    UpdatePartnerDto updatePartnerDto,
    String token,
  ) async {
    try {
      final response = await _rest.patch(
        '/partners/$partnerId',
        data: jsonEncode(updatePartnerDto.toJson()),
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
