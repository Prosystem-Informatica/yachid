import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/widgets/header_widget.dart';
import '../auth/cubit/auth_bloc_cubit.dart';
import '../auth/cubit/auth_bloc_state.dart';

class HomeCleanPage extends StatelessWidget {
  const HomeCleanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBlocCubit, AuthBlocState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: Row(
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xFFF5F7FA),
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderWidget(
                          username: state.authModel.user!.name ?? '',
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
