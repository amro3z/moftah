import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/repair_status.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class CustomerApprovalCard extends StatelessWidget {
  final CustomerApprovalStatus status;
  final double? estimatedCost;
  final VoidCallback onViewDetails;

  const CustomerApprovalCard({
    super.key,
    required this.status,
    required this.onViewDetails,
    this.estimatedCost,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: config.color.withValues(alpha: .20)),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Column(
          key: ValueKey(status),
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(config.icon, color: config.color, size: 24),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: config.title,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                        color: config.titleColor,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .2)),
                      customText(
                        text: config.description,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXs,
                        ),
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (status != CustomerApprovalStatus.none) ...[
              SizedBox(height: ResponsiveSize.height(context, 1.3)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onViewDetails,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: config.color,
                        side: BorderSide(color: config.color),
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.height(context, 1.1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.description_outlined, size: 18),
                      label: customText(
                        text: 'عرض تفاصيل الفحص',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: config.color,
                        isBold: true,
                      ),
                    ),
                  ),
                  if (estimatedCost != null) ...[
                    SizedBox(width: ResponsiveSize.width(context, 4)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        customText(
                          text: 'التكلفة المقترحة',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontXs,
                          ),
                          color: AppColors.textMuted,
                        ),
                        SizedBox(height: ResponsiveSize.height(context, .2)),
                        customText(
                          text: '${estimatedCost!.toStringAsFixed(0)} ج.م',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  _ApprovalConfig _getConfig() {
    switch (status) {
      case CustomerApprovalStatus.waiting:
        return _ApprovalConfig(
          title: 'بانتظار موافقة العميل',
          description: 'تم إرسال نتيجة الفحص للعميل وننتظر موافقته',
          icon: Icons.hourglass_top_rounded,
          color: AppColors.warning,
          backgroundColor: AppColors.warning.withValues(alpha: .08),
          titleColor: AppColors.primary,
        );

      case CustomerApprovalStatus.approved:
        return _ApprovalConfig(
          title: 'وافق العميل',
          description: 'وافق العميل على العرض ويمكن متابعة الإصلاح',
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
          backgroundColor: AppColors.success.withValues(alpha: .08),
          titleColor: AppColors.success,
        );

      case CustomerApprovalStatus.rejected:
        return _ApprovalConfig(
          title: 'رفض العميل',
          description: 'رفض العميل العرض المقدم',
          icon: Icons.cancel_rounded,
          color: AppColors.danger,
          backgroundColor: AppColors.danger.withValues(alpha: .07),
          titleColor: AppColors.danger,
        );

      case CustomerApprovalStatus.none:
        return _ApprovalConfig(
          title: 'لم يتم إرسال عرض',
          description: 'لم يتم إرسال نتيجة الفحص للعميل بعد',
          icon: Icons.remove_circle_outline_rounded,
          color: Colors.blueGrey,
          backgroundColor: Colors.blueGrey.withValues(alpha: .07),
          titleColor: AppColors.primary,
        );
    }
  }
}

class _ApprovalConfig {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color titleColor;

  const _ApprovalConfig({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.titleColor,
  });
}
