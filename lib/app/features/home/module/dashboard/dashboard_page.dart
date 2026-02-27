import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_state.dart';
import '../../../../core/ui/ui.dart';
import 'package:yachid/app/core/widgets/widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
                        CardsRowWidget(),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(child: SalesChartWidget()),
                            SizedBox(width: 24),
                            Expanded(child: ProductsPieWidget()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        LastInvoicesWidget(),
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
