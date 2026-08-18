import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ReportProblemStep extends StatelessWidget {
  final Set<String> selectedProblems;
  final TextEditingController descriptionController;
  final ValueChanged<String> onToggleProblem;

  const ReportProblemStep({
    super.key,
    required this.selectedProblems,
    required this.descriptionController,
    required this.onToggleProblem,
  });

  static const _items = <ReportProblemItem>[
    ReportProblemItem('صوت غريب', 'صوت جديد أو طقطقة', Icons.graphic_eq_rounded),
    ReportProblemItem('رعشة', 'اهتزاز أثناء الحركة', Icons.vibration_rounded),
    ReportProblemItem(
      'لمبة المحرك',
      'Check Engine أو تحذير',
      Icons.warning_amber_rounded,
    ),
    ReportProblemItem(
      'حرارة',
      'ارتفاع حرارة المحرك',
      Icons.device_thermostat_rounded,
    ),
    ReportProblemItem('فرامل', 'صوت أو ضعف في الفرامل', Icons.car_crash_rounded),
    ReportProblemItem(
      'كهرباء',
      'بطارية أو كهرباء السيارة',
      Icons.electric_bolt_rounded,
    ),
    ReportProblemItem(
      'مشكلة تشغيل',
      'السيارة لا تعمل طبيعيًا',
      Icons.key_rounded,
    ),
    ReportProblemItem(
      'أخرى',
      'مشكلة غير موجودة بالقائمة',
      Icons.add_circle_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 2),
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            text: 'إيه اللي ملاحظُه في العربية؟',
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            color: AppColors.primary,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, .5)),
          customText(
            text: 'تقدر تختار أكتر من عرض علشان التحليل يكون أدق.',
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.textMuted,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.5)),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return _ProblemCard(
                item: item,
                selected: selectedProblems.contains(item.title),
                onTap: () => onToggleProblem(item.title),
              );
            },
          ),
          SizedBox(height: ResponsiveSize.height(context, 2)),
          customText(
            text: 'وصف إضافي',
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.primary,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, .7)),
          TextField(
            controller: descriptionController,
            maxLines: 5,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Cairo'),
            decoration: InputDecoration(
              hintText: 'مثلاً: الرعشة بتظهر بعد سرعة 60 كم/س...',
              hintStyle: const TextStyle(fontFamily: 'Cairo'),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: .14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProblemCard extends StatelessWidget {
  final ReportProblemItem item;
  final bool selected;
  final VoidCallback onTap;

  const _ProblemCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondary.withValues(alpha: .08)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: selected
                ? AppColors.secondary
                : AppColors.border.withValues(alpha: .14),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: ResponsiveSize.width(context, 10),
              height: ResponsiveSize.width(context, 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.secondary : AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                item.icon,
                color: selected ? Colors.white : AppColors.secondary,
              ),
            ),
            SizedBox(width: ResponsiveSize.width(context, 2.2)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: item.title,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.primary,
                    isBold: true,
                  ),
                  customText(
                    text: item.subtitle,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.secondary,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

class ReportProblemItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const ReportProblemItem(this.title, this.subtitle, this.icon);
}
