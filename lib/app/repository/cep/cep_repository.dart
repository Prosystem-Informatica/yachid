import 'dart:developer';

import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/model/models.dart';

class CepRepository {
  final RestClient _rest;

  CepRepository({required RestClient rest}) : _rest = rest;

  Future<CepResponseModel> lookupCep({
    required String cep,
    required String token,
  }) async {
    try {
      final cepLimpo = cep.replaceAll(RegExp(r'[^\d]'), '');
      if (cepLimpo.length != 8) {
        throw Exception('CEP inválido. Deve conter 8 dígitos.');
      }

      final response = await _rest.get(
        '/cep/$cepLimpo',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw Exception('Resposta inválida ao consultar CEP.');
      }

      return CepResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
