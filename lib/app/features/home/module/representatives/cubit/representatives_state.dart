part of 'representatives_cubit.dart';

sealed class RepresentativesState extends Equatable {
  const RepresentativesState();

  @override
  List<Object?> get props => [];
}

final class RepresentativesInitial extends RepresentativesState {}

final class RepresentativesLoading extends RepresentativesState {}

final class RepresentativesLoaded extends RepresentativesState {
  final List<RepresentativeModelList> representatives;
  final String filterSearch;

  const RepresentativesLoaded({
    required this.representatives,
    this.filterSearch = '',
  });

  List<RepresentativeModelList> get filteredRepresentatives {
    if (filterSearch.trim().isEmpty) return representatives;
    final term = filterSearch.trim().toLowerCase();
    return representatives.where((r) {
      return r.codigo.toLowerCase().contains(term) ||
          r.nome.toLowerCase().contains(term) ||
          (r.documento?.toLowerCase().contains(term) ?? false) ||
          (r.email?.toLowerCase().contains(term) ?? false);
    }).toList();
  }

  @override
  List<Object?> get props => [representatives, filterSearch];
}

final class RepresentativesError extends RepresentativesState {
  final String message;

  const RepresentativesError(this.message);

  @override
  List<Object?> get props => [message];
}
