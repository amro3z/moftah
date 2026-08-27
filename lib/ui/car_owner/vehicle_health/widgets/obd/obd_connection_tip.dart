import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ObdConnectionTip extends StatelessWidget {
  const ObdConnectionTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: .07)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.tips_and_updates_outlined,
            color: AppColors.warning,
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: customText(
              text:
                  'لو القطعة مش راضية تتصل: شيلها من كهربا العربية، اعمل عدم اقتران من البلوتوث، وبعدها وصلها واعمل اقتران من جديد.',
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
