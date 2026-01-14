// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension ForgotPasswordStatusMatch on ForgotPasswordStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() codeSent,
      required T Function() codeVerified,
      required T Function() success,
      required T Function() error}) {
    final v = this;
    if (v == ForgotPasswordStatus.initial) {
      return initial();
    }

    if (v == ForgotPasswordStatus.loading) {
      return loading();
    }

    if (v == ForgotPasswordStatus.codeSent) {
      return codeSent();
    }

    if (v == ForgotPasswordStatus.codeVerified) {
      return codeVerified();
    }

    if (v == ForgotPasswordStatus.success) {
      return success();
    }

    if (v == ForgotPasswordStatus.error) {
      return error();
    }

    throw Exception(
        'ForgotPasswordStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? codeSent,
      T Function()? codeVerified,
      T Function()? success,
      T Function()? error}) {
    final v = this;
    if (v == ForgotPasswordStatus.initial && initial != null) {
      return initial();
    }

    if (v == ForgotPasswordStatus.loading && loading != null) {
      return loading();
    }

    if (v == ForgotPasswordStatus.codeSent && codeSent != null) {
      return codeSent();
    }

    if (v == ForgotPasswordStatus.codeVerified && codeVerified != null) {
      return codeVerified();
    }

    if (v == ForgotPasswordStatus.success && success != null) {
      return success();
    }

    if (v == ForgotPasswordStatus.error && error != null) {
      return error();
    }

    return any();
  }
}
