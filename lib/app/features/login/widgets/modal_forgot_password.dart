import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/auth/auth_repository.dart';
import 'cubit/forgot_bloc_cubit.dart';
import 'cubit/forgot_bloc_state.dart';


class ForgotPasswordModal extends StatefulWidget {
  final VoidCallback onClose;

  const ForgotPasswordModal({super.key, required this.onClose});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  String currentStep = "email";

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => ForgotPasswordCubit(authRepository: AuthRepository()),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) async {
          switch (state.status) {
            case ForgotPasswordStatus.codeSent:
              setState(() => currentStep = "code");
              break;
            case ForgotPasswordStatus.codeVerified:
              setState(() => currentStep = "reset");
              break;
            case ForgotPasswordStatus.error:
              break;
            case ForgotPasswordStatus.success:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Senha redefinida com sucesso 🎉"),
                  backgroundColor: Colors.green,
                ),
              );
              await Future.delayed(const Duration(seconds: 1));
              widget.onClose();
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgotPasswordCubit>();
          final loading = state.status == ForgotPasswordStatus.loading;

          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: 380,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Recuperar senha",
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (currentStep == "email")
                            _buildEmailStep(context, cubit, loading, colors),
                          if (currentStep == "code")
                            _buildCodeStep(context, cubit, loading, colors),
                          if (currentStep == "reset")
                            _buildResetStep(context, cubit, loading, colors),

                          const SizedBox(height: 10),

                          if (state.message != null && state.message!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                state.message!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: state.isError
                                      ? Colors.red
                                      : colors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: widget.onClose,
                            child: const Text(
                              "Fechar",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmailStep(BuildContext context, ForgotPasswordCubit cubit,
      bool loading, ColorScheme colors) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: "Digite seu e-mail",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        _buildButton(
          label: loading ? "Enviando..." : "Enviar código",
          color: colors.secondary,
          loading: loading,
          onPressed: () => cubit.requestResetCode(emailController.text),
        ),
      ],
    );
  }

  Widget _buildCodeStep(BuildContext context, ForgotPasswordCubit cubit,
      bool loading, ColorScheme colors) {
    return Column(
      children: [
        TextField(
          controller: codeController,
          decoration: const InputDecoration(
            hintText: "Código de 6 dígitos",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        _buildButton(
          label: loading ? "Verificando..." : "Verificar código",
          color: colors.secondary,
          loading: loading,
          onPressed: () =>
              cubit.verifyCode(emailController.text, codeController.text),
        ),
      ],
    );
  }

  Widget _buildResetStep(BuildContext context, ForgotPasswordCubit cubit,
      bool loading, ColorScheme colors) {
    return Column(
      children: [
        TextField(
          controller: newPasswordController,
          obscureText: !showPassword,
          decoration: InputDecoration(
            hintText: "Nova senha",
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon:
              Icon(showPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => showPassword = !showPassword),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: confirmPasswordController,
          obscureText: !showPassword,
          decoration: const InputDecoration(
            hintText: "Confirmar nova senha",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        _buildButton(
          label: loading ? "Salvando..." : "Redefinir senha",
          color: colors.secondary,
          loading: loading,
          onPressed: () {
            if (newPasswordController.text !=
                confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("As senhas não coincidem."),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            cubit.resetPassword(
              emailController.text,
              codeController.text,
              newPasswordController.text,
            );
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required bool loading,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
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
            : Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
