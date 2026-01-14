import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/login/widgets/modal_forgot_password.dart';
import 'cubit/login_bloc_cubit.dart';
import 'cubit/login_bloc_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocConsumer<LoginBlocCubit, LoginBlocState>(
      listener: (context, state) {
        state.status.matchAny(
          success: () async {
            final identifier = identifierController.text.trim().toLowerCase();

            if (identifier == "prosystem@informatica.com") {
              Navigator.pushReplacementNamed(context, "/enterprises_list");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login master: acesso total concedido"),
                  backgroundColor: Colors.green,
                ),
              );
              return;
            }

            try {
              final cubit = context.read<LoginBlocCubit>();
              final accessibleEnterprises = await cubit.getAccessibleEnterprises();

              if (accessibleEnterprises.length == 1) {
                final enterpriseId = accessibleEnterprises.first['id'];
                await cubit.impersonateEnterprise(enterpriseId);
                Navigator.pushReplacementNamed(context, "/dashboard");
              } else {
                Navigator.pushReplacementNamed(context, "/enterprises_list");
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Login efetuado com sucesso!"),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Erro ao carregar empresas: $e"),
                  backgroundColor: colors.error,
                ),
              );
            }
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
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/yachid_logo.jpeg"),
                fit: BoxFit.contain,
              ),
            ),
            child: Center(
              child: Container(
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
                width: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Yachid",
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "ERP",
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: identifierController,
                      decoration: InputDecoration(
                        hintText: "E-mail ou CPF/CNPJ",
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        hintText: "Senha",
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colors.primary),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              setState(() => showPassword = !showPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading
                            ? null
                            : () {
                          context.read<LoginBlocCubit>().login(
                            identifierController.text,
                            passwordController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          loading ? "Entrando..." : "Entrar",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => ForgotPasswordModal(
                            onClose: () => Navigator.pop(context),
                          ),
                        );
                      },
                      child: Text(
                        "Esqueci minha senha",
                        style: TextStyle(
                          color: colors.secondary,
                          decoration: TextDecoration.underline,
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
