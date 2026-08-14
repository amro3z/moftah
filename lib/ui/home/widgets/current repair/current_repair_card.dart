import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/home/widgets/current%20repair/repair_header.dart';
import 'package:moftah/ui/home/widgets/current%20repair/repair_progress.dart';
import 'package:moftah/utils/responsive.dart';

class CurrentRepairCard extends StatelessWidget {
  final CurrentRepairModel data;
  final VoidCallback? onTap;

  const CurrentRepairCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 5),
          ),
          padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              RepairHeader(data: data),

              SizedBox(height: ResponsiveSize.height(context, 1.5)),

              RepairProgress(currentStage: data.currentStage),
            ],
          ),
        ),
      ),
    );
  }
}
