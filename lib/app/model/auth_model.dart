import 'models.dart';

class AuthModel {
  final String? token;
  final User? user;
  final String? message;

  AuthModel({this.token, this.user, this.message});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'] as String?,
      user:
          json['user'] != null
              ? User.fromJson(json['user'] as Map<String, dynamic>)
              : null,
      message: json['message'] as String?,
    );
  }

  bool get isSuccess => token != null && user != null;

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user?.toJson(), 'message': message ?? ''};
  }

  @override
  String toString() {
    return 'AuthModel{token: $token, user: $user, message: $message}';
  }
}
