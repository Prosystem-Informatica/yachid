// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enterprise_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension CreateEnterpriseStatusMatch on CreateEnterpriseStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() success,
      required T Function() error}) {
    final v = this;
    if (v == CreateEnterpriseStatus.initial) {
      return initial();
    }

    if (v == CreateEnterpriseStatus.loading) {
      return loading();
    }

    if (v == CreateEnterpriseStatus.success) {
      return success();
    }

    if (v == CreateEnterpriseStatus.error) {
      return error();
    }

    throw Exception(
        'CreateEnterpriseStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? success,
      T Function()? error}) {
    final v = this;
    if (v == CreateEnterpriseStatus.initial && initial != null) {
      return initial();
    }

    if (v == CreateEnterpriseStatus.loading && loading != null) {
      return loading();
    }

    if (v == CreateEnterpriseStatus.success && success != null) {
      return success();
    }

    if (v == CreateEnterpriseStatus.error && error != null) {
      return error();
    }

    return any();
  }
}
