part of 'companies_cubit.dart';

enum CompaniesStatus { initial, loading, loaded, creating, error }

class CompaniesState extends Equatable {
  final CompaniesStatus status;
  final List<EnterpriseModel> companies;
  final String filterSearch;
  final String? errorMessage;

  const CompaniesState({
    this.status = CompaniesStatus.initial,
    this.companies = const [],
    this.filterSearch = '',
    this.errorMessage,
  });

  List<EnterpriseModel> get filteredCompanies {
    if (filterSearch.trim().isEmpty) return companies;
    final term = filterSearch.trim().toLowerCase();
    return companies.where((c) {
      return (c.fantasyName ?? '').toLowerCase().contains(term) ||
          (c.email ?? '').toLowerCase().contains(term) ||
          (c.document ?? '').toLowerCase().contains(term);
    }).toList();
  }

  CompaniesState copyWith({
    CompaniesStatus? status,
    List<EnterpriseModel>? companies,
    String? filterSearch,
    String? errorMessage,
  }) {
    return CompaniesState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
      filterSearch: filterSearch ?? this.filterSearch,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, companies, filterSearch, errorMessage];
}
