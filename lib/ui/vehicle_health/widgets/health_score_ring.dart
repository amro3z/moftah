import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class HealthScoreRing extends StatelessWidget {
  final int score;
  const HealthScoreRing({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveSize.width(context, 21),
      height: ResponsiveSize.width(context, 21),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 8,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: .12),
              valueColor: const AlwaysStoppedAnimation(AppColors.success),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customText(
                text: '$score',
                fontSize: ResponsiveSize.width(context, 5),
                color: Colors.white,
                isBold: true,
              ),
              customText(
                text: 'من 100',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
