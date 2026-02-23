import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/helpers/environments.dart';
import 'package:yachid/app/core/rest/http/http_rest_client.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/side_bar_widget.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/cubit/partner_details_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/payment_address/cubit/payment_address_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/payment_address/payment_address.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/delivery_address/delivery_address.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/data/partner_data.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/partner_detail_header.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/cubit/partner_statistics_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/statistics/partner_statistics.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/partners_tab_bar.dart';
import 'package:yachid/app/repository/accounts/accounts_repository.dart';

import 'package:yachid/app/repository/payment_address/payment_address.dart';

class PartnerDetailsPage extends StatefulWidget {
  const PartnerDetailsPage({super.key});

  @override
  State<PartnerDetailsPage> createState() => _PartnerDetailsPageState();
}

class _PartnerDetailsPageState extends State<PartnerDetailsPage> {
  final GlobalKey _key = GlobalKey();
  final GlobalKey _tabBarKey = GlobalKey();

  double headerHeight = 0;
  double tabBarHeight = 0;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getPartnerDetails();
      setState(() {
        headerHeight =
            (_key.currentContext!.findRenderObject() as RenderBox).size.height;
        tabBarHeight =
            (_tabBarKey.currentContext!.findRenderObject() as RenderBox)
                .size
                .height;
      });
    });
  }

  void _getPartnerDetails() {
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null && modalRoute.settings.name != null) {
      final uri = Uri.parse(modalRoute.settings.name!);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        context.read<PartnerDetailsCubit>().getPartnerDetails(
          segments.last,
          context.read<AuthBlocCubit>().state.authModel.token ?? '',
        );
      }
    }
  }

  @override
  void dispose() {
    context.read<PartnerDetailsCubit>().setStatusInitial();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBarWidget(),
          BlocBuilder<PartnerDetailsCubit, PartnerDetailsState>(
            builder: (context, state) {
              if (state is PartnerDetailsInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PartnerDetailsLoaded) {
                return Expanded(
                  child: Container(
                    color: AppColors.backgroundColor,
                    child: Column(
                      children: [
                        PartnerDetailHeader(
                          key: _key,
                          partner: state.partner,
                          onBack: () {},

                          onMoreOptions: () {},
                        ),
                        PartnersTabBar(
                          key: _tabBarKey,
                          selectedIndex: state.selectedIndex,
                          onTabSelected: (index) {
                            context
                                .read<PartnerDetailsCubit>()
                                .setSelectedIndex(index);
                          },
                        ),
                        Expanded(
                          child: _TabContent(
                            partner: state.partner,
                            selectedIndex: state.selectedIndex,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  _TabContent({required this.partner, required this.selectedIndex});

  final PartnerDetails partner;
  final int selectedIndex;

  final HttpRestClient httpRestClient = HttpRestClient(
    baseUrl: Environments.get('BASE_URL') ?? "",
    env: Environments.get('ENV') ?? "",
    port: Environments.get('PORT') ?? "",
  );

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return DadosTab(partner: partner);
      case 1:
        return BlocProvider(
          create:
              (context) => PaymentAddressCubit(
                repository: PaymentAddressRepository(rest: httpRestClient),
              ),
          child: PaymentAddressTab(partner: partner),
        );
      case 2:
        return DeliveryAddressPage(partnerId: partner.id);
      case 3:
        return BlocProvider(
          create:
              (context) => PartnerStatisticsCubit(
                repository: AccountsRepository(rest: httpRestClient),
              ),
          child: PartnerStatistics(partnerId: partner.id),
        );

      default:
        return DadosTab(partner: partner);
    }
  }
}
