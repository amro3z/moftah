import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ObdGauge extends StatelessWidget {
  final String title;
  final double? value;
  final String displayValue;
  final double maxValue;
  final IconData icon;
  final Color accent;
  final String unit;

  const ObdGauge({
    super.key,
    required this.title,
    required this.value,
    required this.displayValue,
    required this.maxValue,
    required this.icon,
    required this.accent,
    this.unit = '',
  });

  @override
  Widget build(BuildContext context) {
    final progress = ((value ?? 0) / maxValue).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 1.5),
        vertical: ResponsiveSize.height(context, 1.1),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: ResponsiveSize.width(context, 18),
            height: ResponsiveSize.width(context, 18),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: animatedValue,
                        strokeWidth: ResponsiveSize.width(context, 1.54),
                        strokeCap: StrokeCap.round,
                        backgroundColor:
                            AppColors.progressBackground.withValues(alpha: .7),
                        valueColor: AlwaysStoppedAnimation(accent),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: accent,
                          size: ResponsiveSize.width(context, 3.7),
                        ),
                        customText(
                          text: displayValue,
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: Colors.white,
                          isBold: true,
                        ),
                        if (unit.isNotEmpty)
                          customText(
                            text: unit,
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontXs,
                            ),
                            color: Colors.white60,
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, .65)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: Colors.white70,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }
}
