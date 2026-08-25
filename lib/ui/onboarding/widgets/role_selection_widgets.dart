import 'package:flutter/material.dart';
import 'package:moftah/data/models/rolde_data.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class RoleCard extends StatelessWidget {
  final RoleData item;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({super.key, 
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.border.withValues(alpha: .10),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: selected ? .18 : .07),
            blurRadius: selected ? 20 : 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: ResponsiveSize.width(context, 13),
                      height: ResponsiveSize.width(context, 13),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.textSecondary.withValues(alpha: .12)
                            : AppColors.secondary.withValues(alpha: .09),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: Icon(
                        item.icon,
                        color: selected
                            ? AppColors.textSecondary
                            : AppColors.secondary,
                        size: ResponsiveSize.width(context, 6.5),
                      ),
                    ),

                    SizedBox(height: ResponsiveSize.height(context, 1.2)),

                    customText(
                      text: item.title,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                      color: selected
                          ? AppColors.textSecondary
                          : AppColors.primary,
                      isBold: true,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),

                    SizedBox(height: ResponsiveSize.height(context, .5)),

                    customText(
                      text: item.subtitle,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: selected
                          ? AppColors.textSecondary.withValues(alpha: .70)
                          : AppColors.textMuted,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: ResponsiveSize.width(context, 6),
                    height: ResponsiveSize.width(context, 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.success
                          : AppColors.surfaceLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? AppColors.success
                            : AppColors.border.withValues(alpha: .15),
                      ),
                    ),
                    child: selected
                        ? Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                            size: ResponsiveSize.width(context, 4),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
