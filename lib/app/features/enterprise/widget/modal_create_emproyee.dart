import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _roleController = TextEditingController(text: "Administrador");

  bool _isLoading = false;

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _emailController,
      _passwordController,
      _phoneController,
      _cnpjCpfController,
      _roleController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _createEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "phone": _phoneController.text.trim(),
      "cnpj_cpf": _cnpjCpfController.text.trim(),
      "enterpriseId": widget.enterpriseId,
      "subEnterpriseIds": widget.subEnterpriseId != null ? [widget.subEnterpriseId] : [],
      "role": _roleController.text.trim(),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao criar funcionário: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _input(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
        bool obscure = false,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        inputFormatters: inputFormatters,
        validator: validator ??
                (v) => (v == null || v.isEmpty) ? "Campo obrigatório" : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Criar Funcionário"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _input("Nome", _nameController),
              _input("E-mail", _emailController, keyboardType: TextInputType.emailAddress),
              _input("Senha", _passwordController, obscure: true),
              _input("Telefone", _phoneController, keyboardType: TextInputType.phone),
              _input(
                "CNPJ/CPF",
                _cnpjCpfController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _input("Cargo", _roleController),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createEmployee,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E6F4F),
          ),
          child: _isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
              : const Text("Salvar", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
