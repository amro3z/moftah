import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/technician_models.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianHomeAppBar extends StatelessWidget {
  final TechnicianAppBarModel p;
final ValueChanged<bool>? onOnlineStatusChanged;
  final bool isOnline;
  const TechnicianHomeAppBar({super.key, required this.p , this.onOnlineStatusChanged , this.isOnline = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 1.6),
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 2.2),
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, '/technician/profile'),
                  child: CircleAvatar(
                    radius: ResponsiveSize.width(context, 6),
                    backgroundColor: AppColors.surfaceMedium,
                    child: Icon(
                      Icons.engineering_rounded,
                      color: AppColors.textSecondary,
                      size: ResponsiveSize.width(context, 6),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: 'مرحباً،',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXs,
                        ),
                        color: AppColors.textMuted,
                      ),
                      customText(
                        text: p.technician.name,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXl,
                        ),
                        color: AppColors.textSecondary,
                        isBold: true,
                      ),
                      customText(
                        text: p.technician.specialties.take(2).join(' • '),
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    customText(
                      text: p.technician.rating.toStringAsFixed(1),
                      fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                      color: AppColors.info,
                      isBold: true,
                    ),
                    customText(
                      text: 'التقييم ★',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(context, 2)),
            OnlineStatus(isOnline: isOnline    , onChanged: onOnlineStatusChanged ),
            SizedBox(height: ResponsiveSize.height(context, 2)),
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    icon: Icons.notifications_active_rounded,
                    label: 'طلبات جديدة',
                    value: '${p.newRequests}',
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: _Stat(
                    icon: Icons.handyman_rounded,
                    label: 'قيد التنفيذ',
                    value: '${p.todayJobs}',
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(context, 1)),
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    icon: Icons.receipt_long_rounded,
                    label: 'أعمال اليوم',
                    value: '${p.todayJobs}',
                    color: AppColors.success,
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: _Stat(
                    icon: Icons.payments_rounded,
                    label: 'الإيرادات',
                    value: '${p.todayEarnings.toStringAsFixed(0)} ج',
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
    decoration: BoxDecoration(
      color: AppColors.surfaceDark,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      border: Border.all(color: AppColors.border.withValues(alpha: .7)),
    ),
    child: Row(
      children: [
        Container(
          width: ResponsiveSize.width(context, 9),
          height: ResponsiveSize.width(context, 9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            icon,
            color: color,
            size: ResponsiveSize.width(context, 4.7),
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: label,
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                color: AppColors.textMuted,
              ),
              customText(
                text: value,
                fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                color: color,
                isBold: true,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class OnlineStatus extends StatelessWidget {
  final bool isOnline;
  final ValueChanged<bool>? onChanged;
  const OnlineStatus({super.key, required this.isOnline , this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border.withValues(alpha: .7)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline
                        ? AppColors.success.withValues(alpha: .25)
                        : AppColors.danger.withValues(alpha: .25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.border.withValues(alpha: .7),
                        blurRadius: 1,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      isOnline
                          ? Icons.online_prediction_rounded
                          : Icons.offline_bolt_rounded,
                      color: isOnline
                          ? AppColors.success
                          : AppColors.danger,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 2.5,
                bottom: 25,
                child: Container(
                  width: ResponsiveSize.width(context, 2.5),
                  height: ResponsiveSize.width(context, 2.5),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppColors.success
                        : AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfaceDark, width: 1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: isOnline
                    ? 'متاح لاستقبال الطلبات'
                    : 'غير متاح لاستقبال الطلبات',
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                isBold: true,
                color: AppColors.textMuted,
              ),
              customText(
                text: isOnline
                    ? 'ستظهر لك الطلبات الجديدة فور وصولها'
                    : 'لن تظهر لك الطلبات الجديدة من العملاء',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textMuted,
              ),
            ],
          ),

          Spacer(),
          Switch(
            activeThumbColor: AppColors.success,
            inactiveThumbColor: AppColors.surfaceMedium,
            activeTrackColor: AppColors.success.withValues(alpha: .25),
            inactiveTrackColor: AppColors.danger.withValues(alpha: .25),
            value: isOnline,
            onChanged:onChanged,
          ),
        ],
      ),
    );
  }
}
