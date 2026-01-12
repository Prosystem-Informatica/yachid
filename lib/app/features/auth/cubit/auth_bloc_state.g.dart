// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension AuthStateStatusMatch on AuthStateStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() success,
      required T Function() sectorSuccess}) {
    final v = this;
    if (v == AuthStateStatus.initial) {
      return initial();
    }

    if (v == AuthStateStatus.loading) {
      return loading();
    }

    if (v == AuthStateStatus.error) {
      return error();
    }

    if (v == AuthStateStatus.success) {
      return success();
    }

    if (v == AuthStateStatus.sectorSuccess) {
      return sectorSuccess();
    }

    throw Exception('AuthStateStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? success,
      T Function()? sectorSuccess}) {
    final v = this;
    if (v == AuthStateStatus.initial && initial != null) {
      return initial();
    }

    if (v == AuthStateStatus.loading && loading != null) {
      return loading();
    }

    if (v == AuthStateStatus.error && error != null) {
      return error();
    }

    if (v == AuthStateStatus.success && success != null) {
      return success();
    }

    if (v == AuthStateStatus.sectorSuccess && sectorSuccess != null) {
      return sectorSuccess();
    }

    return any();
  }
}
