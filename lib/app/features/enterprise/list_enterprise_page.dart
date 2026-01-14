import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/enterprise_bloc_cubit.dart';
import 'cubit/enterprise_bloc_state.dart';

class EnterpriseListPage extends StatefulWidget {
  const EnterpriseListPage({super.key});

  @override
  State<EnterpriseListPage> createState() => _EnterpriseListPageState();
}

class _EnterpriseListPageState extends State<EnterpriseListPage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final cubit = context.read<EnterpriseListCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.fetchEnterprises();
    });

    return BlocBuilder<EnterpriseListCubit, EnterpriseListState>(
      builder: (context, state) {
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

        if (state.filteredEnterprises.length == 1) {
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, "/dashboard");
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/yachid_logo.jpeg"),
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
            child: Center(
              child: Container(
                width: 900,
                height: 600,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                      offset: Offset(0, 4),
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E6F4F),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, "/login"),
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
                      child: state.filteredEnterprises.isEmpty
                          ? const Center(
                        child: Text(
                          "Nenhuma empresa encontrada.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                          : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor:
                          MaterialStateProperty.all(Colors.grey[200]),
                          columns: const [
                            DataColumn(label: Text("ID")),
                            DataColumn(label: Text("Nome")),
                            DataColumn(label: Text("CNPJ/CPF")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Ação")),
                          ],
                          rows: state.filteredEnterprises.map((enterprise) {
                            return DataRow(cells: [
                              DataCell(Text("${enterprise['id']}")),
                              DataCell(Text(enterprise['name'] ?? "")),
                              DataCell(Text(enterprise['cnpj_cpf'] ?? "")),
                              DataCell(Text(
                                enterprise['status'] == true
                                    ? "Ativa"
                                    : "Inativa",
                              )),
                              DataCell(
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await cubit
                                          .impersonateEnterprise(
                                          enterprise['id'].toString());
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Entrou na empresa"),
                                      ));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                        Text("Erro ao entrar: $e"),
                                        backgroundColor: Colors.red,
                                      ));
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

                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Função Criar Empresa 🚧"),
                            ),
                          );
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
                        ),
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
}
