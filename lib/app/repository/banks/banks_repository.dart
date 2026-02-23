import 'dart:convert';
import 'dart:developer';

import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';
import 'package:yachid/app/features/home/module/banks/model/bank_detail.dart';
import 'package:yachid/app/features/home/module/banks/model/bank_model_list.dart';
import 'package:yachid/app/features/home/module/banks/model/create_bank_dto.dart';
import 'package:yachid/app/features/home/module/banks/model/update_bank_dto.dart';

class BanksRepository {
  final RestClient _rest;

  BanksRepository({required RestClient rest}) : _rest = rest;

  Future<List<BankModelList>> getAll({
    required String token,
  }) async {
    try {
      final response = await _rest.get(
        '/banks',
        headers: {'Authorization': 'Bearer $token'},
      );

      final list = <BankModelList>[];
      final data = response.data;
      if (data is List) {
        for (final element in data) {
          list.add(
            BankModelList.fromJson(element as Map<String, dynamic>),
          );
        }
      }
      return list;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<BankDetail> getOne({
    required String id,
    required String token,
  }) async {
    try {
      final response = await _rest.get(
        '/banks/$id',
        headers: {'Authorization': 'Bearer $token'},
      );
      return BankDetail.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> create({
    required CreateBankDto dto,
    required String token,
  }) async {
    try {
      final response = await _rest.post(
        '/banks',
        data: jsonEncode(dto.toJson()),
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

  Future<RestClientResponse<dynamic>> update({
    required String id,
    required UpdateBankDto dto,
    required String token,
  }) async {
    try {
      final response = await _rest.patch(
        '/banks/$id',
        data: jsonEncode(dto.toJson()),
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
