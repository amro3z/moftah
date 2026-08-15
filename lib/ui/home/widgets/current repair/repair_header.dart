import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/widgets/current%20repair/repair_status_chip.dart';
import 'package:moftah/utils/responsive.dart';

class RepairHeader extends StatelessWidget {
  final CurrentRepairModel data;

  const RepairHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: ResponsiveSize.width(context, 11),
          height: ResponsiveSize.width(context, 11),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            Icons.build_rounded,
            color: AppColors.secondary,
            size: ResponsiveSize.width(context, 5.5),
          ),
        ),

        SizedBox(width: ResponsiveSize.width(context, 3)),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: customText(
                  text: data.title,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.primary,
                  isBold: true,
                ),
              ),

              SizedBox(height: ResponsiveSize.height(context, 0.4)),

              customText(
                text: '${data.workshopName} • ${data.location}',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.progressBackground,
              ),
            ],
          ),
        ),

        SizedBox(width: ResponsiveSize.width(context, 2)),

        RepairStatusChip(stage: data.currentStage),
      ],
    );
  }
}
