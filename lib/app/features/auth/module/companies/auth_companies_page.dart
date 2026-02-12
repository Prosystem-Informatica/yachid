import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_state.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../model/models.dart';
import 'create_companies_page.dart';

class AuthCompaniesPage extends StatefulWidget {
  const AuthCompaniesPage({super.key});

  @override
  State<AuthCompaniesPage> createState() => _AuthCompaniesPageState();
}

class _AuthCompaniesPageState extends State<AuthCompaniesPage> {
  List<EnterpriseModel> companies = [];
  late SharedPreferences prefs;
  bool isLoadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<AuthBlocCubit, AuthBlocState>(
      listener: (context, state) {
        state.status.matchAny(initial: () {}, any: () {});
      },
      builder: (context, state) {
        if (state.status == AuthStateStatus.loading || isLoadingPrefs) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          body: YachidBackgroundWidget(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Empresas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E6F4F),
                              ),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            'Sair',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Pesquisar empresa...',
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(40),
                        4: FixedColumnWidth(80),
                        5: FixedColumnWidth(70),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      children: [
                        _row([
                          'ID',
                          'Nome',
                          'Email',
                          'CNPJ/CPF',
                          'Status',
                          'Ação',
                        ], header: true),
                        ...companies.map(
                          (e) => _row([
                            companies.isEmpty
                                ? '-'
                                : companies.length.toString(),
                            e.fantasyName ?? '-',
                            e.email ?? '-',
                            e.document ?? '-',
                            e.status ?? '-',
                            'Entrar',
                          ]),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        openCreateCompanyModal(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      icon: Icon(Icons.add, color: colors.onPrimary),
                      label: Text(
                        'Criar Empresa',
                        style: TextStyle(color: colors.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void openCreateCompanyModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 750),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const CreateCompaniesPage(),
            ),
          ),
        );
      },
    );
  }

  static TableRow _row(List<String> cells, {bool header = false}) {
    return TableRow(
      children:
          cells.map((c) {
            final isAction = c == 'Entrar' && !header;

            return Padding(
              padding: const EdgeInsets.all(8),
              child:
                  isAction
                      ? InkWell(
                        onTap: () {
                          Get.toNamed('/home');
                        },
                        child: Text(
                          c,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF1E6F4F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : Text(
                        c,
                        style: TextStyle(
                          fontWeight:
                              header ? FontWeight.bold : FontWeight.normal,
                          color: header ? Colors.black87 : Colors.black54,
                        ),
                      ),
            );
          }).toList(),
    );
  }

  Future<void> _loadState() async {
    prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("companies");

    print("String do json ${jsonString}");

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);

      final List<EnterpriseModel> companiesList =
          decoded
              .map(
                (e) => EnterpriseModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();

      setState(() {
        companies = companiesList;
        isLoadingPrefs = false;
      });
    } else {
      setState(() {
        isLoadingPrefs = false;
      });
    }
  }
}
