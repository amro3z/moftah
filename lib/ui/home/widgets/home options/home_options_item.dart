import 'package:flutter/material.dart';
import 'package:moftah/data/models/home_options_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class HomeOptionItem extends StatelessWidget {
  final HomeOptionItemModel item;

  const HomeOptionItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //  Navigator.pushNamed(context, item.path);
        //   ;
      },
      child: Container(
        width: ResponsiveSize.width(context, 21),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2),
          vertical: ResponsiveSize.height(context, 1),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ResponsiveSize.width(context, 9),
              height: ResponsiveSize.width(context, 9),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: ResponsiveSize.width(context, 5.5),
                color: AppColors.secondary,
              ),
            ),

            SizedBox(height: ResponsiveSize.height(context, 0.5)),

            customText(
              text: item.title,
              isBold: true,
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
