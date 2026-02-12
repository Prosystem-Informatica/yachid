import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/cnpj_response_model.dart';

class CnpjRepository {
  static const String baseUrl = 'open.cnpja.com';
  static const String apiPath = '/office';

  Future<CnpjResponseModel> consultarCnpj({
    required String cnpj,
  }) async {
    try {
      final cnpjLimpo = cnpj.replaceAll(RegExp(r'[^\d]'), '');

      if (cnpjLimpo.length != 14) {
        throw Exception('CNPJ inválido. Deve conter 14 dígitos.');
      }

      final url = Uri.https(
        baseUrl,
        '$apiPath/$cnpjLimpo',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CnpjResponseModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('CNPJ não encontrado.');
      } else {
        throw Exception(
            'Erro ao consultar CNPJ: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Erro ao consultar CNPJ: $e');
    }
  }
}
