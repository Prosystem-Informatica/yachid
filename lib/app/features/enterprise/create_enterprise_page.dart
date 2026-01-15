import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:yachid/app/features/enterprise/widget/modal_create_emproyee.dart';
import '../../repositories/enterprise/create_enterprise_repository.dart';
import '../../repositories/employee/create_employee_repository.dart';
import 'createCubit/enterprise_bloc_state.dart';
import 'createCubit/entrerprise_bloc_cubit.dart';

class CreateEnterprisePage extends StatefulWidget {
  const CreateEnterprisePage({super.key});

  @override
  State<CreateEnterprisePage> createState() => _CreateEnterprisePageState();
}

class _CreateEnterprisePageState extends State<CreateEnterprisePage> {
  final _nameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _phoneController = TextEditingController();
  String _tipoRegime = "Simples Nacional";

  final _CEPController = TextEditingController();
  final _xLgrController = TextEditingController();
  final _nroController = TextEditingController();
  final _xBairroController = TextEditingController();
  final _xMunController = TextEditingController();
  final _UFController = TextEditingController();

  final _contabilidadeController = TextEditingController();
  final _contCnpjController = TextEditingController();
  final _contCepController = TextEditingController();
  final _contEnderecoController = TextEditingController();
  final _contBairroController = TextEditingController();
  final _contNumeroController = TextEditingController();
  final _contCidadeController = TextEditingController();

  final _receitaBrutaController = TextEditingController();
  final _aliquotaController = TextEditingController();
  final _pisController = TextEditingController();
  final _cofinsController = TextEditingController();
  final _icmsController = TextEditingController();

  final _codigoCidadeController = TextEditingController();
  final _inscricaoEstadualController = TextEditingController();
  final _inscricaoMunicipalController = TextEditingController();
  final _certFileController = TextEditingController();
  final _certPasswordController = TextEditingController();
  final _cscIdController = TextEditingController();
  final _cscTokenController = TextEditingController();

  File? _selectedLogo;
  String? _base64Logo;

  File? _selectedCertFile;
  String? _base64CertFile;

  Future<void> _buscarEnderecoPorCEP(TextEditingController cepController, bool isContabilidade) async {
    final cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) return;

    try {
      final res = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (!data.containsKey("erro")) {
          if (isContabilidade) {
            _contEnderecoController.text = data["logradouro"] ?? "";
            _contBairroController.text = data["bairro"] ?? "";
            _contCidadeController.text = data["localidade"] ?? "";
          } else {
            _xLgrController.text = data["logradouro"] ?? "";
            _xBairroController.text = data["bairro"] ?? "";
            _xMunController.text = data["localidade"] ?? "";
            _UFController.text = data["uf"] ?? "";
          }
        }
      }
    } catch (e) {
      debugPrint("Erro ao buscar CEP: $e");
    }
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedLogo = File(pickedFile.path);
        _base64Logo = base64Encode(bytes);
      });
    }
  }

  Future<void> _pickCertificateFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pfx'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      setState(() {
        _selectedCertFile = file;
        _base64CertFile = base64Encode(bytes);
        _certFileController.text = file.path.split('/').last;
      });
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _cnpjController,
      _phoneController,
      _CEPController,
      _xLgrController,
      _nroController,
      _xBairroController,
      _xMunController,
      _UFController,
      _contabilidadeController,
      _contCnpjController,
      _contCepController,
      _contEnderecoController,
      _contBairroController,
      _contNumeroController,
      _contCidadeController,
      _receitaBrutaController,
      _aliquotaController,
      _pisController,
      _cofinsController,
      _icmsController,
      _codigoCidadeController,
      _inscricaoEstadualController,
      _inscricaoMunicipalController,
      _certFileController,
      _certPasswordController,
      _cscIdController,
      _cscTokenController
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E6F4F),
      ),
    ),
  );

  Widget inputField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          onChanged: (_) => onChanged?.call(),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateEnterpriseCubit>();

    return BlocConsumer<CreateEnterpriseCubit, CreateEnterpriseState>(
      listener: (context, state) async {
        state.status.matchAny(
          success: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Empresa criada com sucesso!")),
            );

            final enterpriseId = state.responseData?["enterprise_id"];
            final subEnterpriseId = state.responseData?["sub_enterprise_id"];

            print("enterpriseId: $enterpriseId, subEnterpriseId: $subEnterpriseId");

            if (enterpriseId != null) {
              final result = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: CreateEmployeeModal(
                    enterpriseId: enterpriseId,
                    subEnterpriseId: subEnterpriseId,
                    repository: CreateEmployeeRepository(cubit.repository.api),
                  ),
                ),
              );

              if (result == true && context.mounted) {
                Navigator.pop(context);
              }
            }
          },
          error: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "Erro ao criar empresa"),
                backgroundColor: Colors.red,
              ),
            );
          },
          any: () {},
        );
      },

      builder: (context, state) {
        final loading = state.status == CreateEnterpriseStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Criar Empresa"),
            backgroundColor: const Color(0xFF1E6F4F),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Logo da Empresa"),
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickLogo,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF5B9BD5).withOpacity(0.3),
                          backgroundImage:
                          _selectedLogo != null ? FileImage(_selectedLogo!) : null,
                          child: _selectedLogo == null
                              ? const Icon(Icons.add_a_photo, size: 40, color: Color(0xFF1E6F4F))
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Clique para selecionar o logo",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                sectionTitle("Informações Gerais"),
                inputField(controller: _nameController, label: "Nome"),
                inputField(
                  controller: _cnpjController,
                  label: "CNPJ/CPF",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                inputField(controller: _phoneController, label: "Telefone", keyboardType: TextInputType.phone),
                DropdownButtonFormField<String>(
                  value: _tipoRegime,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Tipo de Regime"),
                  items: const [
                    DropdownMenuItem(value: "Simples Nacional", child: Text("Simples Nacional")),
                    DropdownMenuItem(value: "Normal", child: Text("Normal")),
                  ],
                  onChanged: (val) => setState(() => _tipoRegime = val!),
                ),
                inputField(controller: _codigoCidadeController, label: "Código da Cidade"),
                inputField(controller: _inscricaoEstadualController, label: "Inscrição Estadual"),
                inputField(controller: _inscricaoMunicipalController, label: "Inscrição Municipal"),

                sectionTitle("Endereço"),
                inputField(
                  controller: _CEPController,
                  label: "CEP",
                  keyboardType: TextInputType.number,
                  onChanged: () => _buscarEnderecoPorCEP(_CEPController, false),
                ),
                inputField(controller: _xLgrController, label: "Logradouro"),
                inputField(controller: _nroController, label: "Número"),
                inputField(controller: _xBairroController, label: "Bairro"),
                inputField(controller: _xMunController, label: "Cidade"),
                inputField(controller: _UFController, label: "UF"),

                sectionTitle("Contabilidade"),
                inputField(controller: _contabilidadeController, label: "Nome"),
                inputField(controller: _contCnpjController, label: "CNPJ", keyboardType: TextInputType.number),
                inputField(
                  controller: _contCepController,
                  label: "CEP",
                  keyboardType: TextInputType.number,
                  onChanged: () => _buscarEnderecoPorCEP(_contCepController, true),
                ),
                inputField(controller: _contEnderecoController, label: "Endereço"),
                inputField(controller: _contBairroController, label: "Bairro"),
                inputField(controller: _contNumeroController, label: "Número"),
                inputField(controller: _contCidadeController, label: "Cidade"),

                sectionTitle("Certificado Digital (.pfx)"),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _certFileController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Arquivo .pfx",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _pickCertificateFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Selecionar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9BD5),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                inputField(controller: _certPasswordController, label: "Senha do Certificado", keyboardType: TextInputType.visiblePassword),

                sectionTitle("CSC"),
                inputField(controller: _cscIdController, label: "CSC ID"),
                inputField(controller: _cscTokenController, label: "CSC Token"),

                sectionTitle("Receita"),
                inputField(controller: _receitaBrutaController, label: "Receita Bruta 12m", keyboardType: TextInputType.number),
                inputField(controller: _aliquotaController, label: "Alíquota (%)", keyboardType: TextInputType.number),
                inputField(controller: _pisController, label: "PIS", keyboardType: TextInputType.number),
                inputField(controller: _cofinsController, label: "COFINS", keyboardType: TextInputType.number),
                inputField(controller: _icmsController, label: "ICMS", keyboardType: TextInputType.number),

                const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 220,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                        final data = {
                          "name": _nameController.text.trim(),
                          "cnpj_cpf": _cnpjController.text.trim(),
                          "phone": _phoneController.text.trim(),
                          "logo": _base64Logo,
                          "tipo_regime": _tipoRegime,
                          "codigo_cidade": _codigoCidadeController.text.trim(),
                          "inscricao_estadual": _inscricaoEstadualController.text.trim(),
                          "inscricao_municipal": _inscricaoMunicipalController.text.trim(),
                          "cert_filename": _certFileController.text.trim(),
                          "cert_file_base64": _base64CertFile,
                          "cert_password": _certPasswordController.text.trim(),
                          "csc_id": _cscIdController.text.trim(),
                          "csc_token": _cscTokenController.text.trim(),
                          "address": {
                            "CEP": _CEPController.text.trim(),
                            "xLgr": _xLgrController.text.trim(),
                            "nro": _nroController.text.trim(),
                            "xBairro": _xBairroController.text.trim(),
                            "xMun": _xMunController.text.trim(),
                            "UF": _UFController.text.trim(),
                            "cPais": "BR",
                          },
                          "contabilidade": {
                            "contabilidade": _contabilidadeController.text.trim(),
                            "cnpj": _contCnpjController.text.trim(),
                            "cep": _contCepController.text.trim(),
                            "endereco": _contEnderecoController.text.trim(),
                            "bairro": _contBairroController.text.trim(),
                            "numero": _contNumeroController.text.trim(),
                            "cidade": _contCidadeController.text.trim(),
                          },
                          "receita": {
                            "receita_bruta_12m": double.tryParse(_receitaBrutaController.text) ?? 0,
                            "aliquota": double.tryParse(_aliquotaController.text) ?? 0,
                            "pis": double.tryParse(_pisController.text) ?? 0,
                            "cofins": double.tryParse(_cofinsController.text) ?? 0,
                            "icms": double.tryParse(_icmsController.text) ?? 0,
                          },
                        };
                        cubit.createEnterprise(data);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9BD5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Criar Empresa",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
