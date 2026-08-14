import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/helper/vehicle_status_ui.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleCardHeader extends StatelessWidget {
  final VehicleCardModel data;
  final String formattedMileage;

  const VehicleCardHeader({
    super.key,
    required this.data,
    required this.formattedMileage,
  });

  @override
  Widget build(BuildContext context) {
    final maintenanceUi = VehicleStatusUi.maintenance(data.maintenanceStatus);

    final documentUi = VehicleStatusUi.document(data.documentStatus);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: data.carName,
                fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                color: AppColors.textSecondary,
                isBold: true,
              ),

              SizedBox(height: ResponsiveSize.height(context, 0.3)),

              customText(
                text: '${data.year} • $formattedMileage كم',
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                color: AppColors.textSecondary,
              ),

              SizedBox(height: ResponsiveSize.height(context, 0.7)),

              Wrap(
                spacing: ResponsiveSize.width(context, 2),
                runSpacing: ResponsiveSize.height(context, 0.5),
                children: [
                  _statusChip(context, data: maintenanceUi),
                  _statusChip(context, data: documentUi),
                ],
              ),
            ],
          ),
        ),

        SizedBox(width: ResponsiveSize.width(context, 2)),

        _healthScore(context),
      ],
    );
  }

  Widget _healthScore(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: ResponsiveSize.width(context, 14),
          height: ResponsiveSize.width(context, 14),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                constraints: BoxConstraints(
                  minWidth: ResponsiveSize.width(context, 11),
                  minHeight: ResponsiveSize.width(context, 11),
                ),
                value: data.healthScore / 100,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                backgroundColor: AppColors.progressBackground,
                valueColor: const AlwaysStoppedAnimation(AppColors.success),
              ),

              customText(
                text: '${data.healthScore}',
                fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                color: AppColors.textSecondary,
                isBold: true,
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveSize.height(context, 0.3)),

        customText(
          text: 'صحة السيارة',
          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
          color: AppColors.textMuted,
        ),
      ],
    );
  }

  Widget _statusChip(BuildContext context, {required StatusUiData data}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, 0.3),
      ),
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: customText(
        text: data.text,
        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
        color: data.color,
        isBold: true,
      ),
    );
  }
}
