import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../repositories/employee/create_employee_repository.dart';

class CreateEmployeeModal extends StatefulWidget {
  final int enterpriseId;
  final int? subEnterpriseId;
  final CreateEmployeeRepository repository;

  const CreateEmployeeModal({
    super.key,
    required this.enterpriseId,
    this.subEnterpriseId,
    required this.repository,
  });

  @override
  State<CreateEmployeeModal> createState() => _CreateEmployeeModalState();
}

class _CreateEmployeeModalState extends State<CreateEmployeeModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnpjCpfController = TextEditingController();

  String _selectedRole = "Administrador";
  bool _isLoading = false;

  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cpfCnpjMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _cnpjCpfController.dispose();
    super.dispose();
  }

  Future<void> _createEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "phone": _phoneMask.getUnmaskedText(),
      "cnpj_cpf": _cpfCnpjMask.getUnmaskedText(),
      "enterpriseId": widget.enterpriseId,
      "subEnterpriseIds":
      widget.subEnterpriseId != null ? [widget.subEnterpriseId] : [],
      "role": _selectedRole,
      "status": true,
    };

    setState(() => _isLoading = true);
    try {
      await widget.repository.createEmployee(data);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Funcionário criado com sucesso!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao criar funcionário: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        inputFormatters: inputFormatters,
        validator: validator ??
                (v) => (v == null || v.trim().isEmpty)
                ? "Campo obrigatório"
                : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // impede fechar com "voltar"
      onWillPop: () async => false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.only(top: 16, left: 20, right: 20),
        contentPadding: const EdgeInsets.all(20),
        title: const Text(
          "Novo Funcionário",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E6F4F),
            fontSize: 20,
          ),
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _input(label: "Nome", controller: _nameController),
                _input(
                  label: "E-mail",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Campo obrigatório";
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(v)) return "E-mail inválido";
                    return null;
                  },
                ),
                _input(
                  label: "Senha",
                  controller: _passwordController,
                  obscure: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Campo obrigatório";
                    if (v.length < 6) return "Mínimo de 6 caracteres";
                    return null;
                  },
                ),
                _input(
                  label: "Telefone",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneMask],
                ),
                _input(
                  label: "CPF/CNPJ",
                  controller: _cnpjCpfController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_cpfCnpjMask],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: const [
                      DropdownMenuItem(
                          value: "Administrador", child: Text("Administrador")),
                      DropdownMenuItem(
                          value: "Representante", child: Text("Representante")),
                      DropdownMenuItem(
                          value: "Funcionário", child: Text("Funcionário")),
                      DropdownMenuItem(value: "Gerente", child: Text("Gerente")),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedRole = value);
                    },
                    decoration: InputDecoration(
                      labelText: "Cargo",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _createEmployee,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6F4F),
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: _isLoading
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
                : const Icon(Icons.save),
            label: Text(
              _isLoading ? "Salvando..." : "Salvar Funcionário",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
