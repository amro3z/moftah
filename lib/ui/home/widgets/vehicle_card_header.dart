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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: data.carName,
                fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                color: Colors.white,
                isBold: true,
              ),

              SizedBox(height: ResponsiveSize.height(context, .35)),

              customText(
                text: '${data.year}  •  $formattedMileage كم',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textMuted,
              ),

              SizedBox(height: ResponsiveSize.height(context, .8)),

              Wrap(
                spacing: ResponsiveSize.width(context, 1.5),
                runSpacing: ResponsiveSize.height(context, .4),
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
    return SizedBox(
      width: ResponsiveSize.width(context, 21),
      height: ResponsiveSize.width(context, 21),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: ResponsiveSize.width(context, 21),
            height: ResponsiveSize.width(context, 21),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .05),
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(
            width: ResponsiveSize.width(context, 18),
            height: ResponsiveSize.width(context, 18),
            child: CircularProgressIndicator(
              value: data.healthScore / 100,
              strokeWidth: ResponsiveSize.width(context, 1.54),
              strokeCap: StrokeCap.round,
              backgroundColor: AppColors.progressBackground,
              valueColor: const AlwaysStoppedAnimation(AppColors.success),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customText(
                text: '${data.healthScore}',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                color: Colors.white,
                isBold: true,
              ),

              customText(
                text: 'الصحة',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                color: AppColors.textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, {required StatusUiData data}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 1.8),
        vertical: ResponsiveSize.height(context, .25),
      ),
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: customText(
        text: data.text,
        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
        color: data.color,
        isBold: true,
      ),
    );
  }
}
