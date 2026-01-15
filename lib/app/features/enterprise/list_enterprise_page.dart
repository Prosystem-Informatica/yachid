import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';
import '../../core/rest/http/http_rest_client.dart';
import '../../core/rest/rest_client.dart';
import '../../repositories/enterprise/enterprise_repository.dart';
import 'cubit/enterprise_bloc_cubit.dart';
import 'cubit/enterprise_bloc_state.dart';

class EnterpriseListPage extends StatefulWidget {
  const EnterpriseListPage({super.key});

  @override
  State<EnterpriseListPage> createState() => _EnterpriseListPageState();
}

class _EnterpriseListPageState extends State<EnterpriseListPage> {
  final searchController = TextEditingController();
  late final RestClient _apiRestClient;
  late final EnterpriseRepository _enterpriseRepository;

  @override
  void initState() {
    super.initState();
    _apiRestClient = HttpRestClient(baseUrl: dotenv.env['BASE_URL'] ?? '');
    _enterpriseRepository = EnterpriseRepository(_apiRestClient);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnterpriseListCubit(
        enterpriseRepository: _enterpriseRepository,
      )..fetchEnterprises(),
      child: BlocBuilder<EnterpriseListCubit, EnterpriseListState>(
        builder: (context, state) {
          final cubit = context.read<EnterpriseListCubit>();
          final colors = Theme.of(context).colorScheme;

          if (state.status == EnterpriseListStatus.loading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == EnterpriseListStatus.error) {
            return Scaffold(
              body: Center(
                child: Text(
                  state.errorMessage ?? "Erro ao carregar empresas",
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF6F8FA),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Empresas",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E6F4F),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                              icon: const Icon(Icons.logout, color: Colors.red),
                              label: const Text(
                                "Sair",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        TextField(
                          controller: searchController,
                          onChanged: cubit.filterEnterprises,
                          decoration: InputDecoration(
                            hintText: "Pesquisar empresa...",
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true,
                            radius: const Radius.circular(10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                                  headingTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text("ID")),
                                    DataColumn(label: Text("Nome")),
                                    DataColumn(label: Text("CNPJ/CPF")),
                                    DataColumn(label: Text("Status")),
                                    DataColumn(label: Text("Subempresas")),
                                    DataColumn(label: Text("Ação")),
                                  ],
                                  rows: state.filteredEnterprises.map((enterprise) {
                                    final subEnterprises = enterprise['subEnterprises'] as List? ?? [];
                                    return DataRow(cells: [
                                      DataCell(Text("${enterprise['id']}")),
                                      DataCell(Text(enterprise['name'] ?? "")),
                                      DataCell(Text(enterprise['cnpj_cpf'] ?? "")),
                                      DataCell(Text(
                                        enterprise['status'] == true ? "Ativa" : "Inativa",
                                        style: TextStyle(
                                          color: enterprise['status'] == true
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      )),
                                      DataCell(Text(
                                        subEnterprises.isNotEmpty
                                            ? subEnterprises.map((s) => s['name']).join(", ")
                                            : "—",
                                      )),
                                      DataCell(
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await cubit.impersonateEnterprise(
                                                enterprise['id'].toString(),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Entrou na empresa"),
                                                ),
                                              );
                                              Navigator.pushReplacementNamed(
                                                  context, "/dashboard");
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Erro ao entrar: $e"),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text(
                                            "Entrar",
                                            style: TextStyle(
                                              color: Color(0xFF1E6F4F),
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.toNamed(Routes.CREATE_ENTERPRISE);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Criar Empresa"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5B9BD5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
