import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:3333"));

  Future<void> requestPasswordReset(String identifier) async {
    await _dio.post("/auth/forgot-password", data: {"identifier": identifier});
  }

  Future<void> verifyResetCode(String identifier, String code) async {
    await _dio.post("/auth/verify-reset-code", data: {
      "identifier": identifier,
      "code": code,
    });
  }

  Future<void> resetPassword(
      String identifier,
      String code,
      String newPassword,
      ) async {
    await _dio.post("/auth/reset-password", data: {
      "identifier": identifier,
      "code": code,
      "new_password": newPassword,
    });
  }
}
