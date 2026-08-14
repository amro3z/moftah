import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 5),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
              color: AppColors.primary,
              isBold: true,
            ),

            if (actionText != null)
              GestureDetector(
                onTap: onActionTap,
                child: customText(
                  text: actionText!,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.secondary,
                  isBold: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
