import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/cubit/partners_cubit.dart';
import 'package:yachid/app/features/home/module/partners/model/partner_model.dart';
import 'package:yachid/app/features/home/module/partners/widgets/filters_fields.dart';

class PartnersFilters extends StatelessWidget {
  final TextEditingController filterDocument = TextEditingController();
  final TextEditingController filterCity = TextEditingController();
  final TextEditingController filterPhone = TextEditingController();
  final TextEditingController filterUf = TextEditingController();
  final TextEditingController filterCep = TextEditingController();

  PartnersFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 18),
      decoration: BoxDecoration(color: AppColors.textOnPrimary),
      child: BlocBuilder<PartnersCubit, PartnersState>(
        builder: (context, state) {
          if (state is PartnersLoaded) {
            if (filterDocument.text != state.filterDocument) {
              filterDocument.text = state.filterDocument;
            }
            if (filterCity.text != state.filterCity) {
              filterCity.text = state.filterCity;
            }
            if (filterPhone.text != state.filterPhone) {
              filterPhone.text = state.filterPhone;
            }
            if (filterUf.text != state.filterUf) {
              filterUf.text = state.filterUf;
            }
            if (filterCep.text != state.filterCep) {
              filterCep.text = state.filterCep;
            }
          }
          final cubit = context.read<PartnersCubit>();
          final loaded = state is PartnersLoaded ? state : null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.start,
                children: [
                  FilterField(
                    controller: filterDocument,
                    label: 'Documento',
                    hint: 'CPF/CNPJ',
                    width: 140,
                    decoration: _inputDec('Documento'),
                    onChanged: (v) => cubit.setFilters(document: v),
                  ),
                  FilterField(
                    controller: filterCity,
                    label: 'Cidade',
                    hint: 'Cidade',
                    width: 140,
                    decoration: _inputDec('Cidade'),
                    onChanged: (v) => cubit.setFilters(city: v),
                  ),
                  FilterField(
                    controller: filterPhone,
                    label: 'Telefone',
                    hint: 'Telefone',
                    width: 130,
                    decoration: _inputDec('Telefone'),
                    onChanged: (v) => cubit.setFilters(phone: v),
                  ),
                  FilterField(
                    controller: filterUf,
                    label: 'UF',
                    hint: 'UF',
                    width: 56,
                    maxLength: 2,
                    decoration: _inputDec('UF'),
                    onChanged: (v) => cubit.setFilters(uf: v),
                  ),
                  FilterField(
                    controller: filterCep,
                    label: 'CEP',
                    hint: 'CEP',
                    width: 120,
                    decoration: _inputDec('CEP'),
                    onChanged: (v) => cubit.setFilters(cep: v),
                  ),
                  SizedBox(
                    width: 140,
                    child: DropdownButtonFormField<PartnerStatus?>(
                      value: loaded?.filterStatus,
                      decoration: _inputDec('Status'),
                      isExpanded: true,
                      hint: const Text('Status'),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Todos')),
                        DropdownMenuItem(
                          value: PartnerStatus.ACTIVE,
                          child: Text('Ativo'),
                        ),
                        DropdownMenuItem(
                          value: PartnerStatus.INACTIVE,
                          child: Text('Inativo'),
                        ),
                      ],
                      onChanged: (value) {
                        cubit.setFilterStatus(value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static InputDecoration _inputDec(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
    );
  }
}
