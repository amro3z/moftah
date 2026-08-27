import 'package:flutter/material.dart';
import 'package:moftah/data/models/app_bar.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianHomeAppBar extends StatelessWidget {
  final HomeAppBarModel data;
  const TechnicianHomeAppBar({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // المطلوب: لو مودل صاحب العربية null نستخدم مودل الفني.
    final tech = data.carOwner == null ? data.technician : null;
    if (tech == null) return const SizedBox.shrink();
    final p = tech.technician;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(ResponsiveSize.width(context, 5), ResponsiveSize.height(context, 1.6), ResponsiveSize.width(context, 5), ResponsiveSize.height(context, 2.2)),
      decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.vertical(bottom: Radius.circular(28))),
      child: SafeArea(bottom: false, child: Column(children: [
        Row(children: [
          GestureDetector(onTap: () => Navigator.pushNamed(context, '/technician/profile'), child: CircleAvatar(radius: ResponsiveSize.width(context, 6), backgroundColor: AppColors.surfaceMedium, child: Icon(Icons.engineering_rounded, color: AppColors.textSecondary, size: ResponsiveSize.width(context, 6)))),
          SizedBox(width: ResponsiveSize.width(context, 3)),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            customText(text: 'مرحباً،', fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: AppColors.textMuted),
            customText(text: p.name, fontSize: ResponsiveSize.width(context, AppSizes.fontXl), color: AppColors.textSecondary, isBold: true),
            customText(text: '${p.specialties.take(2).join(' • ')}', fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.info),
          ])),
          Column(children: [customText(text: p.rating.toStringAsFixed(1), fontSize: ResponsiveSize.width(context, AppSizes.fontLg), color: AppColors.info, isBold: true), customText(text: 'التقييم ★', fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: AppColors.textMuted)]),
        ]),
        SizedBox(height: ResponsiveSize.height(context, 2)),
        Row(children: [
          Expanded(child: _Stat(icon: Icons.notifications_active_rounded, label: 'طلبات جديدة', value: '${tech.newRequests}', color: AppColors.secondary)),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(child: _Stat(icon: Icons.handyman_rounded, label: 'قيد التنفيذ', value: '${tech.todayJobs}', color: AppColors.warning)),
        ]),
        SizedBox(height: ResponsiveSize.height(context, 1)),
        Row(children: [
          Expanded(child: _Stat(icon: Icons.receipt_long_rounded, label: 'أعمال اليوم', value: '${tech.todayJobs}', color: AppColors.success)),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(child: _Stat(icon: Icons.payments_rounded, label: 'الإيرادات', value: '${tech.todayEarnings.toStringAsFixed(0)} ج', color: AppColors.info)),
        ]),
      ])),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon; final String label; final String value; final Color color;
  const _Stat({required this.icon, required this.label, required this.value, required this.color});
  @override Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
    decoration: BoxDecoration(color: AppColors.surfaceDark, borderRadius: BorderRadius.circular(AppSizes.radiusMd), border: Border.all(color: AppColors.border.withValues(alpha: .7))),
    child: Row(children: [Container(width: ResponsiveSize.width(context, 9), height: ResponsiveSize.width(context, 9), decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)), child: Icon(icon, color: color, size: ResponsiveSize.width(context, 4.7))), SizedBox(width: ResponsiveSize.width(context, 2)), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [customText(text: label, fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: AppColors.textMuted), customText(text: value, fontSize: ResponsiveSize.width(context, AppSizes.fontLg), color: color, isBold: true)]))]),
  );
}
