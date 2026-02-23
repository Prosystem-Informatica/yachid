import 'package:flutter/material.dart';
import 'package:yachid/app/core/ui/app_colors.dart';
import 'package:yachid/app/features/home/module/partners/module/model/partner_details.dart';

class PartnerDetailHeader extends StatelessWidget {
  const PartnerDetailHeader({
    super.key,
    required this.partner,
    this.onBack,
    this.onMoreOptions,
  });

  final PartnerDetails partner;
  final VoidCallback? onBack;
  final VoidCallback? onMoreOptions;

  @override
  Widget build(BuildContext context) {
    final statusLabel = partner.status;
    final isActive = partner.status == 'ACTIVE';

    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumn = constraints.maxWidth < 640;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child:
              useColumn
                  ? _buildColumnLayout(context, statusLabel, isActive)
                  : _buildRowLayout(context, statusLabel, isActive),
        );
      },
    );
  }

  Widget _buildRowLayout(
    BuildContext context,
    String statusLabel,
    bool isActive,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              const SizedBox(width: 16),
              _buildIconContainer(),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTitleAndSubtitle(context, statusLabel, isActive),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildActions(context),
      ],
    );
  }

  Widget _buildColumnLayout(
    BuildContext context,
    String statusLabel,
    bool isActive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(flex: 1, child: _buildIconContainer()),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildTitleAndSubtitle(context, statusLabel, isActive),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActions(context),
      ],
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.business,
        size: 24,
        color: AppColors.textOnPrimary,
      ),
    );
  }

  Widget _buildTitleAndSubtitle(
    BuildContext context,
    String statusLabel,
    bool isActive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                partner.name,
                style:
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ) ??
                    const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildBadge(statusLabel, isActive),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Cod. ${partner.codigo} · ${partner.fantasyName}',
          style:
              Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.gray600) ??
              const TextStyle(fontSize: 14, color: AppColors.gray600),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBadge(String statusLabel, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isActive
                ? AppColors.primaryColor.withOpacity(0.15)
                : AppColors.gray300,
        borderRadius: BorderRadius.circular(6),
        border: isActive ? null : Border.all(color: AppColors.gray400),
      ),
      child: Text(
        statusLabel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? AppColors.primaryColor : AppColors.gray700,
        ),
      ),
    );
  }

  WidgetStateProperty<RoundedRectangleBorder>
  get _returnRoundedRectangleBorder => WidgetStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  );

  WidgetStateProperty<Color> get _returnBackgroundColor =>
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return AppColors.primaryColor;
        }
        return Colors.transparent;
      });

  WidgetStateProperty<Color> get _returnForegroundColor =>
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return AppColors.textOnPrimary;
        }
        return AppColors.gray800;
      });

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          SizedBox(
            width: 34,
            height: 34,
            child: IconButton(
              style: ButtonStyle(
                shape: _returnRoundedRectangleBorder,
                backgroundColor: _returnBackgroundColor,
                foregroundColor: _returnForegroundColor,
                side: WidgetStateProperty.all(
                  BorderSide(color: AppColors.gray400),
                ),
              ),
              onPressed: onMoreOptions,
              icon: const Icon(Icons.more_horiz, size: 20),
              tooltip: 'Mais opções',
            ),
          ),
        ],
      ),
    );
  }
}
