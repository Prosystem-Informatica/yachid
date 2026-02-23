import 'dart:convert';
import 'dart:developer';

import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/model/partner_account.dart';

Future<RestClientResponse<dynamic>> _handleGet(
  RestClient rest,
  String path, {
  String? token,
}) async {
  try {
    final response = await rest.get(
      path,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );
    if (response.statusCode == 200) return response;
    if (response.statusCode == 404) return RestClientResponse(data: null, statusCode: 404);
    return RestClientResponse(
      data: response.data is Map ? response.data['message'] : response.data,
      statusCode: response.statusCode,
    );
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

class AccountsRepository {
  final RestClient _rest;

  AccountsRepository({required RestClient rest}) : _rest = rest;

  Future<RestClientResponse<dynamic>> getPartnerCreditConfig(
    String partnerId, {
    String? token,
  }) async {
    try {
      final response = await _rest.get(
        '/partner-credit-config/$partnerId',
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 404) {
        return RestClientResponse(data: null, statusCode: 404);
      } else {
        return RestClientResponse(
          data: response.data is Map
              ? response.data['message']
              : response.data,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> createPartnerCreditConfig(
    String partnerId,
    PartnerCreditConfig config, {
    required String token,
  }) async {
    try {
      final response = await _rest.post(
        '/partner-credit-config/$partnerId',
        data: jsonEncode(config.toJson()),
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

  Future<RestClientResponse<dynamic>> updatePartnerCreditConfig(
    String partnerId,
    PartnerCreditConfig config, {
    required String token,
  }) async {
    try {
      final response = await _rest.patch(
        '/partner-credit-config/$partnerId',
        data: jsonEncode(config.toJson()),
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

  Future<RestClientResponse<dynamic>> getAccountsPayable(
    String partnerId, {
    String? token,
  }) async =>
      _handleGet(_rest, '/accounts-payable/$partnerId', token: token);

  Future<RestClientResponse<dynamic>> createAccountsPayable(
    String partnerId,
    AccountsPayableModel data, {
    required String token,
  }) async {
    try {
      return await _rest.post(
        '/accounts-payable/$partnerId',
        data: jsonEncode(data.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> updateAccountsPayable(
    String partnerId,
    AccountsPayableModel data, {
    required String token,
  }) async {
    try {
      return await _rest.patch(
        '/accounts-payable/$partnerId',
        data: jsonEncode(data.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> getAccountsReceivable(
    String partnerId, {
    String? token,
  }) async =>
      _handleGet(_rest, '/accounts-receivable/$partnerId', token: token);

  Future<RestClientResponse<dynamic>> createAccountsReceivable(
    String partnerId,
    AccountsReceivableModel data, {
    required String token,
  }) async {
    try {
      return await _rest.post(
        '/accounts-receivable/$partnerId',
        data: jsonEncode(data.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> updateAccountsReceivable(
    String partnerId,
    AccountsReceivableModel data, {
    required String token,
  }) async {
    try {
      return await _rest.patch(
        '/accounts-receivable/$partnerId',
        data: jsonEncode(data.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
