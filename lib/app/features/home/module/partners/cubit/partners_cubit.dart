import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/partner_model.dart';

part 'partners_state.dart';

class PartnersCubit extends Cubit<PartnersState> {
  PartnersCubit() : super(PartnersInitial());

  void loadPartners() {
    final list = _mockPartners();
    emit(
      PartnersLoaded(
        partners: list,
        filteredPartners: list,
        filterDocument: '',
        filterCity: '',
        filterPhone: '',
        filterUf: '',
        filterCep: '',
        filterStatus: null,
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
      ),
    );
  }

  List<PartnerModel> _applyFilters(
    List<PartnerModel> list, {
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
      result = result.where((p) {
        final pDoc = p.document.replaceAll(RegExp(r'\D'), '');
        return pDoc.contains(docClean) || pDoc.toLowerCase().contains(docClean);
      }).toList();
    }
    final cityLower = city.trim().toLowerCase();
    if (cityLower.isNotEmpty) {
      result = result.where((p) => p.city.toLowerCase().contains(cityLower)).toList();
    }
    final phoneClean = phone.replaceAll(RegExp(r'\D'), '');
    if (phoneClean.isNotEmpty) {
      result = result.where((p) {
        final pPhone = (p.mainPhone + p.cellphone + p.secondaryPhone).replaceAll(RegExp(r'\D'), '');
        return pPhone.contains(phoneClean);
      }).toList();
    }
    final ufUpper = uf.trim().toUpperCase();
    if (ufUpper.isNotEmpty) {
      result = result.where((p) => p.uf.toUpperCase().contains(ufUpper)).toList();
    }
    final cepClean = cep.replaceAll(RegExp(r'\D'), '');
    if (cepClean.isNotEmpty) {
      result = result.where((p) {
        final pCep = p.cep.replaceAll(RegExp(r'\D'), '');
        return pCep.contains(cepClean);
      }).toList();
    }
    if (status != null) {
      result = result.where((p) => p.status == status).toList();
    }
    return result;
  }

  void addPartner(PartnerModel partner) {
    final current = state;
    if (current is! PartnersLoaded) return;

    final newList = [...current.partners, partner];
    final filtered = _applyFilters(
      newList,
      document: current.filterDocument,
      city: current.filterCity,
      phone: current.filterPhone,
      uf: current.filterUf,
      cep: current.filterCep,
      status: current.filterStatus,
    );

    emit(
      PartnersLoaded(
        partners: newList,
        filteredPartners: filtered,
        filterDocument: current.filterDocument,
        filterCity: current.filterCity,
        filterPhone: current.filterPhone,
        filterUf: current.filterUf,
        filterCep: current.filterCep,
        filterStatus: current.filterStatus,
      ),
    );
  }

  List<PartnerModel> _mockPartners() {
    return [
      PartnerModel(
        id: '1',
        codigo: '001',
        name: 'ACME LTDA',
        document: '12.345.678/0001-90',
        fantasyName: 'ACME',
        city: 'São Paulo',
        mainPhone: '(11) 3333-4444',
        secondaryPhone: '',
        cellphone: '(11) 99999-1111',
        uf: 'SP',
        cep: '01310-100',
        status: PartnerStatus.ACTIVE,
        personType: PartnerType.PJ,
        ieRg: '123.456.789.012',
        businessSector: 'Tecnologia',
      ),
      PartnerModel(
        id: '2',
        codigo: '002',
        name: 'João da Silva',
        document: '123.456.789-00',
        fantasyName: 'João',
        city: 'Campinas',
        mainPhone: '(11) 2222-3333',
        secondaryPhone: '',
        cellphone: '(11) 98888-7777',
        uf: 'SP',
        cep: '13050-001',
        status: PartnerStatus.ACTIVE,
        personType: PartnerType.PF,
        ieRg: '12.345.678-9',
        businessSector: 'Serviços',
      ),
    ];
  }
}
