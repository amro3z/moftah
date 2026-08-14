import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class RepairProgress extends StatelessWidget {
  final RepairStage currentStage;

  const RepairProgress({super.key, required this.currentStage});

  static const List<RepairStage> stages = [
    RepairStage.received,
    RepairStage.inspection,
    RepairStage.approval,
    RepairStage.repairing,
    RepairStage.testing,
  ];

  static const List<String> labels = [
    'تم الوصول',
    'الاستلام',
    'الفحص',
    'الإصلاح',
    'التسليم',
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentStageIndex();

    return Row(
      children: List.generate(stages.length, (index) {
        final isCompletedStage = index < currentIndex;

        final isCurrentStage = index == currentIndex;

        final isActive = index <= currentIndex;

        return Expanded(
          child: Column(
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 0.5),
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.secondary
                      : AppColors.border.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              SizedBox(height: ResponsiveSize.height(context, 0.5)),

              FittedBox(
                fit: BoxFit.scaleDown,
                child: customText(
                  text: labels[index],
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: isCurrentStage
                      ? AppColors.secondary
                      : isCompletedStage
                      ? AppColors.secondary.withValues(alpha: 0.65)
                      : AppColors.textMuted,
                  isBold: isCurrentStage,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  int _getCurrentStageIndex() {
    switch (currentStage) {
      case RepairStage.received:
        return 0;

      case RepairStage.inspection:
        return 1;

      case RepairStage.approval:
        return 2;

      case RepairStage.repairing:
        return 3;

      case RepairStage.testing:
      case RepairStage.completed:
        return 4;
    }
  }
}
