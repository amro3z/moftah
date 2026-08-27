import 'package:flutter/material.dart';
import 'package:moftah/data/models/update/app_update_result.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

Future<bool?> showAppUpdateDialog({
  required BuildContext context,
  required AppUpdateResult update,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return _AppUpdateDialog(update: update);
    },
  );
}

class _AppUpdateDialog extends StatelessWidget {
  final AppUpdateResult update;

  const _AppUpdateDialog({required this.update});

  @override
  Widget build(BuildContext context) {
    final notes = update.releaseNotes?.trim() ?? '';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 6),
        ),
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
          decoration: BoxDecoration(
            color: AppColors.textSecondary,
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .18),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveSize.width(context, 20),
                height: ResponsiveSize.width(context, 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .22),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.system_update_alt_rounded,
                  color: AppColors.textSecondary,
                  size: ResponsiveSize.width(context, 10),
                ),
              ),

              SizedBox(height: ResponsiveSize.height(context, 2)),

              customText(
                text: 'تحديث جديد متاح',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                color: AppColors.primary,
                isBold: true,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: ResponsiveSize.height(context, .6)),

              customText(
                text: 'الإصدار ${update.latestVersion ?? ''} جاهز للتثبيت',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textMuted,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: ResponsiveSize.height(context, 2)),

              _VersionComparison(
                currentVersion: update.currentVersion ?? '-',
                latestVersion: update.latestVersion ?? '-',
              ),

              if (notes.isNotEmpty) ...[
                SizedBox(height: ResponsiveSize.height(context, 2)),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.secondary,
                            size: ResponsiveSize.width(context, 4.5),
                          ),
                          SizedBox(width: ResponsiveSize.width(context, 2)),
                          customText(
                            text: 'ما الجديد؟',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontSm,
                            ),
                            color: AppColors.primary,
                            isBold: true,
                          ),
                        ],
                      ),

                      SizedBox(height: ResponsiveSize.height(context, 1)),

                      customText(
                        text: notes,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: AppColors.textMuted,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: ResponsiveSize.height(context, 2.2)),

              SizedBox(
                width: double.infinity,
                height: ResponsiveSize.height(context, 6.2),
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textSecondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        color: AppColors.textSecondary,
                        size: ResponsiveSize.width(context, 5),
                      ),
                      SizedBox(width: ResponsiveSize.width(context, 2)),
                      customText(
                        text: 'تحديث الآن',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                        color: AppColors.textSecondary,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ResponsiveSize.height(context, .6)),

              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: customText(
                  text: 'لاحقاً',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.textMuted,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionComparison extends StatelessWidget {
  final String currentVersion;
  final String latestVersion;

  const _VersionComparison({
    required this.currentVersion,
    required this.latestVersion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 3.5),
        vertical: ResponsiveSize.height(context, 1.2),
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.secondary.withValues(alpha: .12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _VersionItem(
              label: 'نسختك',
              version: currentVersion,
              color: AppColors.textMuted,
            ),
          ),

          Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.secondary,
            size: ResponsiveSize.width(context, 5),
          ),

          Expanded(
            child: _VersionItem(
              label: 'الجديدة',
              version: latestVersion,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionItem extends StatelessWidget {
  final String label;
  final String version;
  final Color color;

  const _VersionItem({
    required this.label,
    required this.version,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        customText(
          text: label,
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: AppColors.textMuted,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: ResponsiveSize.height(context, .25)),
        customText(
          text: 'v$version',
          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
          color: color,
          isBold: true,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
