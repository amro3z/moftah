import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ObdMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  const ObdMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSize.width(context, 38),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2.5),
        vertical: ResponsiveSize.height(context, 1),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveSize.width(context, 8),
            height: ResponsiveSize.width(context, 8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: accent,
              size: ResponsiveSize.width(context, 4),
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: value,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: Colors.white,
                  isBold: true,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: customText(
                    text: title,
                    fontSize: ResponsiveSize.width(
                      context,
                      AppSizes.fontXs,
                    ),
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
