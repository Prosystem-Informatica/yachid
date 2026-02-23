part of 'banks_cubit.dart';

sealed class BanksState extends Equatable {
  const BanksState();

  @override
  List<Object?> get props => [];
}

final class BanksInitial extends BanksState {}

final class BanksLoading extends BanksState {}

final class BanksLoaded extends BanksState {
  final List<BankModelList> banks;
  final String filterSearch;

  const BanksLoaded({
    required this.banks,
    this.filterSearch = '',
  });

  List<BankModelList> get filteredBanks {
    if (filterSearch.trim().isEmpty) return banks;
    final term = filterSearch.trim().toLowerCase();
    return banks.where((b) {
      return b.codigo.toLowerCase().contains(term) ||
          b.nome.toLowerCase().contains(term) ||
          b.numeroBanco.toLowerCase().contains(term);
    }).toList();
  }

  @override
  List<Object?> get props => [banks, filterSearch];
}

final class BanksError extends BanksState {
  final String message;

  const BanksError(this.message);

  @override
  List<Object?> get props => [message];
}
