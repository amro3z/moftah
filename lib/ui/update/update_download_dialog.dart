import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class UpdateDownloadDialog extends StatelessWidget {
  final double progress;

  const UpdateDownloadDialog({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return PopScope(
      canPop: false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 7),
          ),
          child: Container(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
            decoration: BoxDecoration(
              color: AppColors.textSecondary,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: .16),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: ResponsiveSize.width(context, 16),
                  height: ResponsiveSize.width(context, 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.downloading_rounded,
                    color: AppColors.primary,
                    size: ResponsiveSize.width(context, 8),
                  ),
                ),

                SizedBox(height: ResponsiveSize.height(context, 1.7)),

                customText(
                  text: 'جاري تحميل التحديث',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                  color: AppColors.primary,
                  isBold: true,
                ),

                SizedBox(height: ResponsiveSize.height(context, .5)),

                customText(
                  text: 'من فضلك انتظر حتى يكتمل التحميل',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.textMuted,
                ),

                SizedBox(height: ResponsiveSize.height(context, 2)),

                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: ResponsiveSize.height(context, 1),
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.secondary,
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveSize.height(context, 1)),

                customText(
                  text: '$percentage%',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.secondary,
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
