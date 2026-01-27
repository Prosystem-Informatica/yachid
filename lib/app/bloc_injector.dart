import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/repository/auth/auth_repository.dart';

import 'app_widget.dart';
import 'core/helpers/environments.dart';
import 'core/rest/http/http_rest_client.dart';
import 'core/rest/rest_client.dart';

class BlocInjection extends StatefulWidget {
  const BlocInjection({super.key});

  @override
  State<BlocInjection> createState() => _BlocInjectionState();
}

class _BlocInjectionState extends State<BlocInjection> {
  final RestClient _apiRestClient = HttpRestClient(
    baseUrl: Environments.get('BASE_URL') ?? "",
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBlocCubit(
                authRepository: AuthRepository(rest: _apiRestClient),
              ),
        ),
      ],
      child: const AppWidget(),
    );
  }
}
