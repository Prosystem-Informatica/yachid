import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_widget.dart';
import 'core/rest/http/http_rest_client.dart';
import 'core/rest/rest_client.dart';
import 'features/enterprise/cubit/enterprise_bloc_cubit.dart';
import 'repositories/login/login_repository.dart';
import 'repositories/enterprise/enterprise_repository.dart';
import 'features/login/cubit/login_bloc_cubit.dart';

class BlocInjection extends StatefulWidget {
  const BlocInjection({super.key});

  @override
  State<BlocInjection> createState() => _BlocInjectionState();
}

class _BlocInjectionState extends State<BlocInjection> {
  late final RestClient _apiRestClient;
  late final LoginRepository _loginRepository;
  late final EnterpriseRepository _enterpriseRepository;

  @override
  void initState() {
    super.initState();

    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3333';
    _apiRestClient = HttpRestClient(baseUrl: baseUrl);

    _loginRepository = LoginRepository(_apiRestClient);
    _enterpriseRepository = EnterpriseRepository(_apiRestClient);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBlocCubit(
            loginRepository: _loginRepository,
            enterpriseRepository: _enterpriseRepository,
          ),
        ),
        BlocProvider(
          create: (_) =>
              EnterpriseListCubit(enterpriseRepository: _enterpriseRepository),
        ),
      ],
      child: const AppWidget(),
    );
  }
}
