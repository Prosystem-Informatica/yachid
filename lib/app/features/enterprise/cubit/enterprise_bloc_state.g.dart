// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enterprise_bloc_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension EnterpriseListStatusMatch on EnterpriseListStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() loaded,
      required T Function() error}) {
    final v = this;
    if (v == EnterpriseListStatus.initial) {
      return initial();
    }

    if (v == EnterpriseListStatus.loading) {
      return loading();
    }

    if (v == EnterpriseListStatus.loaded) {
      return loaded();
    }

    if (v == EnterpriseListStatus.error) {
      return error();
    }

    throw Exception(
        'EnterpriseListStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? loaded,
      T Function()? error}) {
    final v = this;
    if (v == EnterpriseListStatus.initial && initial != null) {
      return initial();
    }

    if (v == EnterpriseListStatus.loading && loading != null) {
      return loading();
    }

    if (v == EnterpriseListStatus.loaded && loaded != null) {
      return loaded();
    }

    if (v == EnterpriseListStatus.error && error != null) {
      return error();
    }

    return any();
  }
}
