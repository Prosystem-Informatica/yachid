import 'dart:convert';
import 'dart:developer';

import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';
import 'package:yachid/app/features/home/module/representatives/model/create_representative_dto.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_detail.dart';
import 'package:yachid/app/features/home/module/representatives/model/representative_model_list.dart';
import 'package:yachid/app/features/home/module/representatives/model/update_representative_dto.dart';

class RepresentativesRepository {
  final RestClient _rest;

  RepresentativesRepository({required RestClient rest}) : _rest = rest;

  Future<List<RepresentativeModelList>> getAll({
    required String token,
  }) async {
    try {
      final response = await _rest.get(
        '/representatives',
        headers: {'Authorization': 'Bearer $token'},
      );

      final list = <RepresentativeModelList>[];
      final data = response.data;
      if (data is List) {
        for (final element in data) {
          list.add(
            RepresentativeModelList.fromJson(element as Map<String, dynamic>),
          );
        }
      }
      return list;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RepresentativeDetail> getOne({
    required String id,
    required String token,
  }) async {
    try {
      final response = await _rest.get(
        '/representatives/$id',
        headers: {'Authorization': 'Bearer $token'},
      );
      return RepresentativeDetail.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> create({
    required CreateRepresentativeDto dto,
    required String token,
  }) async {
    try {
      final response = await _rest.post(
        '/representatives',
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
    required UpdateRepresentativeDto dto,
    required String token,
  }) async {
    try {
      final response = await _rest.patch(
        '/representatives/$id',
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
