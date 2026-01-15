import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/login_bloc_cubit.dart';
import 'cubit/login_bloc_state.dart';
import 'widgets/modal_forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool showForgotPasswordModal = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<LoginBlocCubit, LoginBlocState>(
      listener: (context, state) {
        state.status.matchAny(
          success: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage ?? "Login efetuado"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, "/dashboard");
          },
          error: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "Erro desconhecido"),
                backgroundColor: colors.error,
              ),
            );
          },
          any: () {},
        );
      },
      builder: (context, state) {
        final loading = state.status == LoginStateStatus.loading;

        return Scaffold(
          body: Stack(
            children: [
              // Background
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/yachid_logo.jpeg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Login form
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo / título
                          Text(
                            "Yachid",
                            style: TextStyle(
                              color: const Color(0xFF1E6F4F),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ERP",
                            style: TextStyle(
                              color: const Color(0xFF5B9BD5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo E-mail / CPF/CNPJ
                          TextField(
                            controller: identifierController,
                            decoration: const InputDecoration(
                              labelText: "E-mail ou CPF/CNPJ",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Campo Senha
                          TextField(
                            controller: passwordController,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () => setState(
                                        () => showPassword = !showPassword),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Botão Entrar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () {
                                context.read<LoginBlocCubit>().login(
                                    identifierController.text,
                                    passwordController.text);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B9BD5),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: loading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                "Entrar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Botão Esqueci minha senha
                          TextButton(
                            onPressed: () =>
                                setState(() => showForgotPasswordModal = true),
                            child: const Text(
                              "Esqueci minha senha",
                              style: TextStyle(
                                color: Color(0xFF5B9BD5),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Modal Forgot Password
              if (showForgotPasswordModal)
                ForgotPasswordModal(
                  onClose: () =>
                      setState(() => showForgotPasswordModal = false),
                ),
            ],
          ),
        );
      },
    );
  }
}
