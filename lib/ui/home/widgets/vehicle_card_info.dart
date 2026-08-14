import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleCardInfo extends StatelessWidget {
  final String nextMaintenance;
  final String lastMaintenance;
  final String repairText;
  final Color repairColor;

  const VehicleCardInfo({
    super.key,
    required this.nextMaintenance,
    required this.lastMaintenance,
    required this.repairText,
    required this.repairColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveSize.height(context, 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceMedium,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: _infoItem(
              context,
              title: 'الصيانة القادمة',
              value: nextMaintenance,
              valueColor: AppColors.warning,
            ),
          ),

          _divider(context),

          Expanded(
            child: _infoItem(
              context,
              title: 'آخر صيانة',
              value: lastMaintenance,
              valueColor: AppColors.textPrimary,
            ),
          ),

          _divider(context),

          Expanded(
            child: _infoItem(
              context,
              title: 'الإصلاحات',
              value: repairText,
              valueColor: repairColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(
    BuildContext context, {
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customText(
          text: title,
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: AppColors.textSecondary,
        ),

        SizedBox(height: ResponsiveSize.height(context, 0.2)),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: customText(
            text: value,
            fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
            color: valueColor,
            isBold: true,
          ),
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: ResponsiveSize.height(context, 3.5),
      color: AppColors.divider,
    );
  }
}
