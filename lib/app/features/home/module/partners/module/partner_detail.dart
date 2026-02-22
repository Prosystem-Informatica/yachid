import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/core/ui/side_bar_widget.dart';
import 'package:yachid/app/features/auth/cubit/auth_bloc_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/cubit/partner_details_cubit.dart';
import 'package:yachid/app/features/home/module/partners/module/model/delivery_address.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/local_cobranca.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/local_entrega.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/partner_data.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/partner_detail_header.dart';
import 'package:yachid/app/features/home/module/partners/module/widgets/partners_tab_bar.dart';

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
                          onEdit: () {},
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
                            deliveryAddresses: state.deliveryAddresses,
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

void _onDeliveryAddressSaved(BuildContext context, DeliveryAddress address) {
  context.read<PartnerDetailsCubit>().addDeliveryAddress(
    address,
    context.read<AuthBlocCubit>().state.authModel.token ?? '',
  );
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.partner,
    required this.deliveryAddresses,
    required this.selectedIndex,
  });

  final PartnerDetails partner;
  final List<DeliveryAddress> deliveryAddresses;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return DadosTab(partner: partner);
      case 1:
        return LocalCobrancaTab(partner: partner);
      case 2:
        return LocalEntregaTab(
          deliveryAddresses: deliveryAddresses,
          onDeliveryAddressSaved:
              (address) => _onDeliveryAddressSaved(context, address),
        );
      default:
        return DadosTab(partner: partner);
    }
  }
}
