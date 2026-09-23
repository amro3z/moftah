import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class DistanceSlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;

  const DistanceSlider({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<DistanceSlider> createState() => _DistanceSliderState();
}

class _DistanceSliderState extends State<DistanceSlider> {
  late double distance;

  @override
  void initState() {
    super.initState();
    distance = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            customText(
              text: 'أقل من 10 كم',
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              isBold: true,
              color: AppColors.primary,
            ),
            const Spacer(),
            customText(
              text: 'المسافة',
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              isBold: true,
              color: AppColors.primary,
            ),
          ],
        ),
        Slider(
          padding: EdgeInsets.zero,
          value: distance,
          min: 0,
          max: 20,
          divisions: 3,
          inactiveColor: Colors.grey.withValues(alpha: .3),
          activeColor: AppColors.secondary,
          onChanged: (value) {
            setState(() {
              distance = value;
            });

            widget.onChanged(value);
          },
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            customText(
              text: 'أقرب',
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.textMuted,
            ),
            const Spacer(),
            customText(
              text: '5',
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.textMuted,
            ),
            const Spacer(),
            customText(
              text: '10',
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.textMuted,
            ),
            const Spacer(),
            customText(
              text: '+20',
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.textMuted,
            ),
          ],
        ),
      ],
    );
  }
}
