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
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                child: Row(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      flex: 3,
                      child: FilterField(
                        controller: filterDocument,
                        label: "Documento",
                        hint: "CPF/CNPJ",
                        width: 140,
                        maxLength: 18,
                        onChanged: (v) => {},
                        decoration: _inputDec(""),
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: FilterField(
                        controller: filterCity,
                        label: "Cidade",
                        hint: "Ex: São Paulo",
                        width: 144,
                        onChanged: (v) => {},
                        decoration: _inputDec(""),
                      ),
                    ),

                    // Telefone
                    Expanded(
                      flex: 3,
                      child: FilterField(
                        controller: filterPhone,
                        label: "Telefone",
                        hint: "(99) 999999999",
                        width: 138,
                        maxLength: 14,
                        onChanged: (v) => {},
                        decoration: _inputDec(""),
                      ),
                    ),

                    // UF
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        isDense: true,
                        decoration: _inputDec("UF"),
                        items:
                            [
                                  "",
                                  'AC',
                                  'AL',
                                  'AP',
                                  'AM',
                                  'BA',
                                  'CE',
                                  'DF',
                                  'ES',
                                  'GO',
                                  'MA',
                                  'MT',
                                  'MS',
                                  'MG',
                                  'PA',
                                  'PB',
                                  'PR',
                                  'PE',
                                  'PI',
                                  'RJ',
                                  'RN',
                                  'RS',
                                  'RO',
                                  'RR',
                                  'SC',
                                  'SP',
                                  'SE',
                                  'TO',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.isEmpty ? '-' : e),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) {
                          filterUf.text = v ?? '';
                        },
                      ),
                    ),

                    Expanded(
                      flex: 3,
                      child: FilterField(
                        controller: filterCep,
                        label: "CEP",
                        hint: "00000-000",
                        width: 112,
                        maxLength: 9,
                        onChanged: (v) => {},
                        decoration: _inputDec(""),
                      ),
                    ),

                    // Status (dropdown, se disponível no modelo)
                    // if (loaded?.allStatuses != null &&
                    //     loaded!.allStatuses.isNotEmpty)
                    if (true)
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<PartnerStatus?>(
                          isDense: true,

                          decoration: _inputDec("Status"),
                          items: [
                            const DropdownMenuItem<PartnerStatus?>(
                              value: null,
                              child: Text('- Todos Status -'),
                            ),
                            ...[
                              PartnerStatus.ACTIVE,
                              PartnerStatus.INACTIVE,
                            ].map(
                              (status) => DropdownMenuItem<PartnerStatus?>(
                                value: status,
                                child: Text(status.label ?? ''),
                              ),
                            ),
                          ],
                          onChanged: (v) => cubit.setFilterStatus(v),
                        ),
                      ),

                    Expanded(
                      flex: 1,
                      child: Tooltip(
                        message: "Limpar todos filtros",
                        child: IconButton(
                          splashRadius: 18,
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            filterDocument.clear();
                            filterCity.clear();
                            filterPhone.clear();
                            filterUf.clear();
                            filterCep.clear();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
