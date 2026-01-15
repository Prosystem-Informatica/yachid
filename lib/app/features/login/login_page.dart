import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../app_routes.dart';
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

  final String mainEmail = "prosystem@informatica.com";
  final String mainPassword = "prosys";

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
            Get.offNamed(Routes.ENTERPRISE_LIST);
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
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/yachid_logo.jpeg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
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
                          Text(
                            "Yachid",
                            style: const TextStyle(
                              color: Color(0xFF1E6F4F),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "ERP",
                            style: const TextStyle(
                              color: Color(0xFF5B9BD5),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),

                          TextField(
                            controller: identifierController,
                            decoration: const InputDecoration(
                              labelText: "E-mail ou CPF/CNPJ",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
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
                                final email =
                                identifierController.text.trim();
                                final pass = passwordController.text;

                                if (email == mainEmail &&
                                    pass == mainPassword) {
                                  context
                                      .read<LoginBlocCubit>()
                                      .emit(LoginBlocState(
                                    status: LoginStateStatus.success,
                                    successMessage:
                                    "Login efetuado como main account",
                                  ));
                                  return;
                                }

                                context
                                    .read<LoginBlocCubit>()
                                    .login(email, pass);
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
