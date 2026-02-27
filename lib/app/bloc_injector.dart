import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/employee/cubit/employee_cubit.dart';
import 'package:yachid/app/features/home/module/partners/cubit/partners_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/cubit/partner_details_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/delivery_address/cubit/delivery_address_cubit.dart';
import 'package:yachid/app/features/home/module/products/cubit/products_cubit.dart';
import 'package:yachid/app/features/home/module/products/module/cubit/product_detail_cubit.dart';
import 'package:yachid/app/features/home/module/representatives/cubit/representatives_cubit.dart';
import 'package:yachid/app/features/home/module/banks/cubit/banks_cubit.dart';
import 'package:yachid/app/repository/auth/auth_repository.dart';
import 'package:yachid/app/repository/delivery_address/delivery_address.dart';
import 'package:yachid/app/repository/employee/employee_repository.dart';
import 'package:yachid/app/repository/partners/partners_repository.dart';
import 'package:yachid/app/repository/products/products_repository.dart';
import 'package:yachid/app/repository/representatives/representatives_repository.dart';
import 'package:yachid/app/repository/banks/banks_repository.dart';

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
    env: Environments.get('ENV') ?? "",
    port: Environments.get('PORT') ?? "",
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
        BlocProvider(
          create:
              (_) => EmployeeCubit(
                repository: EmployeeRepository(rest: _apiRestClient),
              ),
        ),
        BlocProvider(
          create:
              (_) => PartnersCubit(
                repository: PartnersRepository(rest: _apiRestClient),
              ),
        ),
        BlocProvider(
          create:
              (_) => PartnerDetailsCubit(
                repository: PartnersRepository(rest: _apiRestClient),
              ),
        ),
        BlocProvider(
          create:
              (_) => DeliveryAddressCubit(
                repository: DeliveryAddressRepository(rest: _apiRestClient),
              ),
        ),
        BlocProvider(
          create:
              (_) => ProductsCubit(
                repository: ProductsRepository(rest: _apiRestClient),
              ),
        ),
        BlocProvider(
          create:
              (_) => ProductDetailCubit(
                repository: ProductsRepository(rest: _apiRestClient),
              ),
        ),
        BlocProvider(
          create:
              (_) => RepresentativesCubit(
                repository: RepresentativesRepository(rest: _apiRestClient),
              ),
        ),
        BlocProvider(
          create:
              (_) =>
                  BanksCubit(repository: BanksRepository(rest: _apiRestClient)),
        ),
      ],
      child: const AppWidget(),
    );
  }
}
