import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/widgets/dangerous_level_filter.dart';
import 'package:moftah/ui/technician/widgets/distance_slider.dart';
import 'package:moftah/utils/responsive.dart';

class AdvancedFilterSheet extends StatefulWidget {
  const AdvancedFilterSheet({super.key});

  @override
  State<AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<AdvancedFilterSheet> {
  double distance = 0;
  int selectedDangerousLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, 1)),
          customText(
            text: 'تصفية الطلبات',
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            isBold: true,
            color: AppColors.primary,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.5)),
          DistanceSlider(
            initialValue: distance,
            onChanged: (value) {
              setState(() {
                distance = value;
              });
            },
          ),
          SizedBox(height: ResponsiveSize.height(context, 2)),
          DangerousLevelFilter(
            selectedIndex: selectedDangerousLevel,
            onChanged: (index) {
              setState(() {
                selectedDangerousLevel = index;
              });
            },
          ),
          SizedBox(height: ResponsiveSize.height(context, 1)),
        ],
      ),
    );
  }
}
