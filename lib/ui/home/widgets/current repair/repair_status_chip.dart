import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class RepairStatusChip extends StatelessWidget {
  final RepairStage stage;

  const RepairStatusChip({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final isCompleted = stage == RepairStage.completed;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, 0.45),
      ),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: customText(
        text: isCompleted ? 'مكتمل' : 'جاري التنفيذ',
        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
        color: isCompleted ? AppColors.success : AppColors.secondary,
        isBold: true,
      ),
    );
  }
}
