import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:yachid/app/features/home/module/partners/model/group_model.dart';
import 'package:yachid/app/features/home/module/partners/model/partner_model_list.dart';
import 'package:yachid/app/features/home/module/partners/model/payment_address.dart';
import 'package:yachid/app/repository/partners/partners_repository.dart';

import '../model/partner_model.dart';

part 'partners_state.dart';

class PartnersCubit extends Cubit<PartnersState> {
  final PartnersRepository _repository;
  PartnersCubit({required PartnersRepository repository})
    : _repository = repository,
      super(PartnersInitial());

  Future<void> loadGroups(String token) async {
    try {
      final groups = await _repository.getGroups(token: token);
      final selectedGroupId = groups.isNotEmpty ? groups.first.id : null;
      emit(
        PartnersLoaded(
          partners: const [],
          filteredPartners: const [],
          groups: groups,
          selectedGroupId: selectedGroupId,
        ),
      );
      if (selectedGroupId != null) {
        loadPartners(token: token, groupId: selectedGroupId);
      }
    } catch (e) {
      emit(PartnersError(e.toString()));
    }
  }

  Future<void> loadPartners({
    required String token,
    required String groupId,
  }) async {
    final current = state;
    final groups = current is PartnersLoaded ? current.groups : <GroupModel>[];
    final List<PartnerModelList> partnersList = [];
    try {
      final partners = await _repository.getPartners(
        token: token,
        groupId: groupId,
      );

      if (partners.isNotEmpty) {
        partnersList.addAll(partners);
      }

      emit(
        PartnersLoaded(
          partners: partnersList,
          filteredPartners: partnersList,
          groups: groups,
          selectedGroupId: groupId,
        ),
      );
    } catch (e) {
      emit(PartnersError(e.toString()));
    }
  }

  void selectGroup(String groupId) {
    final current = state;
    if (current is! PartnersLoaded) return;
    emit(
      PartnersLoaded(
        partners: current.partners,
        filteredPartners: current.filteredPartners,
        filterDocument: current.filterDocument,
        filterCity: current.filterCity,
        filterPhone: current.filterPhone,
        filterUf: current.filterUf,
        filterCep: current.filterCep,
        filterStatus: current.filterStatus,
        groups: current.groups,
        selectedGroupId: groupId,
      ),
    );
  }

  void setFilters({
    String? document,
    String? city,
    String? phone,
    String? uf,
    String? cep,
  }) {
    final current = state;
    if (current is! PartnersLoaded) return;

    final newDocument = document ?? current.filterDocument;
    final newCity = city ?? current.filterCity;
    final newPhone = phone ?? current.filterPhone;
    final newUf = uf ?? current.filterUf;
    final newCep = cep ?? current.filterCep;

    final filtered = _applyFilters(
      current.partners,
      document: newDocument,
      city: newCity,
      phone: newPhone,
      uf: newUf,
      cep: newCep,
      status: current.filterStatus,
    );

    emit(
      PartnersLoaded(
        partners: current.partners,
        filteredPartners: filtered,
        filterDocument: newDocument,
        filterCity: newCity,
        filterPhone: newPhone,
        filterUf: newUf,
        filterCep: newCep,
        filterStatus: current.filterStatus,
        groups: current.groups,
        selectedGroupId: current.selectedGroupId,
      ),
    );
  }

  void setFilterStatus(PartnerStatus? status) {
    final current = state;
    if (current is! PartnersLoaded) return;

    final filtered = _applyFilters(
      current.partners,
      document: current.filterDocument,
      city: current.filterCity,
      phone: current.filterPhone,
      uf: current.filterUf,
      cep: current.filterCep,
      status: status,
    );

    emit(
      PartnersLoaded(
        partners: current.partners,
        filteredPartners: filtered,
        filterDocument: current.filterDocument,
        filterCity: current.filterCity,
        filterPhone: current.filterPhone,
        filterUf: current.filterUf,
        filterCep: current.filterCep,
        filterStatus: status,
        groups: current.groups,
        selectedGroupId: current.selectedGroupId,
      ),
    );
  }

  List<PartnerModelList> _applyFilters(
    List<PartnerModelList> list, {
    required String document,
    required String city,
    required String phone,
    required String uf,
    required String cep,
    required PartnerStatus? status,
  }) {
    var result = list;
    final docClean = document.replaceAll(RegExp(r'\D'), '').toLowerCase();
    if (docClean.isNotEmpty) {
      result =
          result.where((p) {
            final pDoc = p.document.replaceAll(RegExp(r'\D'), '');
            return pDoc.contains(docClean) ||
                pDoc.toLowerCase().contains(docClean);
          }).toList();
    }
    final cityLower = city.trim().toLowerCase();
    if (cityLower.isNotEmpty) {
      result =
          result
              .where((p) => p.city?.toLowerCase().contains(cityLower) ?? false)
              .toList();
    }
    final phoneClean = phone.replaceAll(RegExp(r'\D'), '');
    if (phoneClean.isNotEmpty) {
      result =
          result.where((p) {
            final pPhone = (p.phone).replaceAll(RegExp(r'\D'), '');
            return pPhone.contains(phoneClean);
          }).toList();
    }
    final ufUpper = uf.trim().toUpperCase();
    if (ufUpper.isNotEmpty) {
      result =
          result
              .where((p) => p.uf?.toUpperCase().contains(ufUpper) ?? false)
              .toList();
    }
    final cepClean = cep.replaceAll(RegExp(r'\D'), '');
    if (cepClean.isNotEmpty) {
      result =
          result.where((p) {
            final pCep = p.cep?.replaceAll(RegExp(r'\D'), '') ?? '';
            return pCep.contains(cepClean);
          }).toList();
    }
    if (status != null) {
      result = result.where((p) => p.status == status).toList();
    }
    return result;
  }

  Future<void> addPartner(
    PartnerModelDto partner,
    String partnerType,
    String token,
  ) async {
    final current = state;
    if (current is! PartnersLoaded) return;

    try {
      final response = await _repository.createPartner(
        partner,
        partnerType,
        token,
      );
      if (response.statusCode == 201) {
        loadPartners(token: token, groupId: current.selectedGroupId ?? '');
      } else {
        final msg =
            (response.data is Map ? response.data['message'] : response.data)
                ?.toString() ??
            'Erro ao criar parceiro';
        emit(PartnersError(msg));
      }
    } catch (e) {
      emit(PartnersError(e.toString()));
    }
  }

  Future<void> getPartnerDetails(String partnerId, String token) async {
    try {
      final response = await _repository.getPartnerDetails(partnerId, token);
    } catch (e) {
      emit(PartnersError(e.toString()));
    }
  }
}
