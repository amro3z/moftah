import 'package:flutter/material.dart';
import 'package:moftah/ui/core/helper/date/custom_date_picker.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

enum DatePickerMode { date, year }

class DatePickerField extends StatelessWidget {
  final String title;
  final String? subtitle;
  final DateTime? value;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onChanged;
  final DatePickerMode mode;
  final String? disabledText;

  const DatePickerField({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.mode = DatePickerMode.date,
    this.disabledText,
  });

  static const List<String> _months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  Future<void> _pickDate(BuildContext context) async {
    if (!enabled) return;

    DateTime? result;

    if (mode == DatePickerMode.year) {
      result = await _showYearPicker(context);
    } else {
      result = await showCustomDatePicker(
        context: context,
        initialDate: value,
        firstDate: firstDate,
        lastDate: lastDate,
        title: title,
      );
    }

    if (result != null) {
      onChanged(result);
    }
  }

  Future<DateTime?> _showYearPicker(BuildContext context) async {
    final now = DateTime.now();

    final minYear = firstDate?.year ?? 1980;
    final maxYear = lastDate?.year ?? now.year;

    int selectedYear = value?.year ?? maxYear;

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final years = List.generate(
              maxYear - minYear + 1,
              (index) => maxYear - index,
            );

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 5),
                  ResponsiveSize.height(context, 1),
                  ResponsiveSize.width(context, 5),
                  ResponsiveSize.height(context, 3),
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.secondary,
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.width(context, 3)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                text: title,
                                fontSize: ResponsiveSize.width(
                                  context,
                                  AppSizes.fontLg,
                                ),
                                color: AppColors.primary,
                                isBold: true,
                              ),
                              customText(
                                text: 'حدد السنة المناسبة',
                                fontSize: ResponsiveSize.width(
                                  context,
                                  AppSizes.fontSm,
                                ),
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Container(
                      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: SizedBox(
                        height: ResponsiveSize.height(context, 32),
                        child: GridView.builder(
                          itemCount: years.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.8,
                              ),
                          itemBuilder: (context, index) {
                            final year = years[index];

                            final isSelected = year == selectedYear;

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setModalState(() {
                                    selectedYear = year;
                                  });
                                },
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMd,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.secondary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusMd,
                                    ),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.secondary
                                          : AppColors.secondary.withValues(
                                              alpha: .12,
                                            ),
                                    ),
                                  ),
                                  child: Center(
                                    child: customText(
                                      text: '$year',
                                      fontSize: ResponsiveSize.width(
                                        context,
                                        AppSizes.fontMd,
                                      ),
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.primary,
                                      isBold: isSelected,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(context, 4),
                        vertical: ResponsiveSize.height(context, 1.2),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_available_rounded,
                            color: AppColors.secondary,
                          ),
                          SizedBox(width: ResponsiveSize.width(context, 2)),
                          customText(
                            text: '$selectedYear',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontMd,
                            ),
                            color: AppColors.primary,
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context, DateTime(selectedYear));
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveSize.height(context, 1.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        label: customText(
                          text: 'تأكيد السنة',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: Colors.white,
                          isBold: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatValue(DateTime date) {
    if (mode == DatePickerMode.year) {
      return '${date.year}';
    }

    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  String _getSubtitle() {
    if (!enabled) {
      return disabledText ?? 'يتاح تحديد الموعد بعد انتهاء الفحص';
    }

    if (value != null) {
      return _formatValue(value!);
    }

    if (subtitle != null) {
      return subtitle!;
    }

    return mode == DatePickerMode.year
        ? 'اضغط لاختيار السنة'
        : 'اضغط لاختيار التاريخ';
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = enabled ? AppColors.secondary : Colors.blueGrey.shade300;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: enabled ? 1 : .65,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? () => _pickDate(context) : null,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Ink(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: .07),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: mainColor.withValues(alpha: .16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    !enabled
                        ? Icons.lock_clock_rounded
                        : mode == DatePickerMode.year
                        ? Icons.calendar_view_month_rounded
                        : Icons.event_available_rounded,
                    color: mainColor,
                    size: 25,
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: title,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .3)),
                      customText(
                        text: _getSubtitle(),
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: value != null && enabled
                            ? AppColors.secondary
                            : AppColors.textMuted,
                        isBold: value != null && enabled,
                      ),
                    ],
                  ),
                ),
                Icon(
                  enabled
                      ? Icons.ads_click_outlined
                      : Icons.lock_outline_rounded,
                  color: mainColor,
                  size: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
