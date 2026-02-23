import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yachid/app/app_routes.dart';
import 'package:yachid/app/core/ui/side_bar_item_widget.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_state.dart';

import '../enums/enum.dart';

class SideBarWidget extends StatefulWidget {
  final HomeSectionEnum selectedSection;
  final Function(HomeSectionEnum) onItemSelected;

  const SideBarWidget({
    super.key,
    required this.selectedSection,
    required this.onItemSelected,
  });

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  late SharedPreferences prefs;
  String? selectedCompanyId;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final selectedCompanie =
        context.read<AuthBlocCubit>().state.selectedCompanie;
    selectedCompanyId = selectedCompanie?.id;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBlocCubit, AuthBlocState>(
      listener: (context, state) {
        if (state.selectedCompanie?.id != selectedCompanyId) {
          setState(() {
            selectedCompanyId = state.selectedCompanie?.id;
          });
        }
        state.status.matchAny(success: () {}, any: () {});
      },
      builder: (context, state) {
        final currentSelectedId =
            state.selectedCompanie?.id ?? selectedCompanyId;

        return Container(
          width: 220,
          color: const Color(0xFF1E6F4F),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Yachid ERP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: const Color(0xFF1E6F4F),
                    value: currentSelectedId,
                    hint: const Text(
                      'Selecionar Empresa',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    items:
                        state.enterprisesModels?.map((company) {
                          return DropdownMenuItem<String>(
                            value: company.id,
                            child: Text(company.fantasyName ?? ''),
                          );
                        }).toList() ??
                        [],
                    onChanged: (value) async {
                      if (value == null) return;

                      setState(() {
                        selectedCompanyId = value;
                      });

                      final selectedCompany = state.enterprisesModels
                          ?.firstWhere((company) => company.id == value);

                      if (selectedCompany != null) {
                        context.read<AuthBlocCubit>().selectCompany(
                          selectedCompany,
                        );
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SideBarItemWidget(
                icon: Icons.dashboard,
                label: 'Dashboard',
                isSelected: widget.selectedSection == HomeSectionEnum.dashboard,
                onTap: () => widget.onItemSelected(HomeSectionEnum.dashboard),
              ),
              SideBarItemWidget(
                icon: Icons.people,
                label: 'Clientes / Parceiros',
                isSelected: widget.selectedSection == HomeSectionEnum.partners,
                onTap: () => widget.onItemSelected(HomeSectionEnum.partners),
              ),
              /*SideBarItemWidget(
                icon: Icons.inventory,
                label: 'Produtos',
                isSelected: widget.selectedSection == HomeSectionEnum.partners,
                onTap: () => widget.onItemSelected(HomeSectionEnum.partners),
              ),
              SideBarItemWidget(
                icon: Icons.shopping_cart,
                label: 'Vendas',
                isSelected: widget.selectedSection == HomeSectionEnum.partners,
                onTap: () => widget.onItemSelected(HomeSectionEnum.partners),
              ),
              SideBarItemWidget(
                icon: Icons.receipt,
                label: 'NF-e',
                isSelected: widget.selectedSection == HomeSectionEnum.partners,
                onTap: () => widget.onItemSelected(HomeSectionEnum.partners),
              ),*/
              SideBarItemWidget(
                icon: Icons.person_add,
                label: 'Funcionários',
                isSelected: widget.selectedSection == HomeSectionEnum.employees,
                onTap: () => widget.onItemSelected(HomeSectionEnum.employees),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  prefs.clear();
                  Get.toNamed(Routes.INITIAL);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
