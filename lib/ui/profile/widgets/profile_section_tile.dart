import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ProfileSectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProfileSectionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.secondary;

    return Material(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .16),
                blurRadius: 14,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: AppColors.border.withValues(alpha: .10)),
          ),
          child: Row(
            children: [
              Container(
                width: ResponsiveSize.width(context, 11),
                height: ResponsiveSize.width(context, 11),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .09),

                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveSize.width(context, 5.5),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: title,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, .25)),
                    customText(
                      text: subtitle,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted,
                size: ResponsiveSize.width(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
