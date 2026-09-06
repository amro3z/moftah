import 'package:flutter/material.dart';

import 'package:moftah/ui/core/themes/colors.dart';

import 'package:moftah/ui/core/themes/sizes.dart';

import 'package:moftah/ui/core/ui/custom_text.dart';

import 'package:moftah/utils/responsive.dart';

enum CustomDatePickerMode { fullDate, yearOnly, monthOnly }

class CustomDatePickerField extends StatelessWidget {
  final String theme;

  final DateTime? value;

  final ValueChanged<DateTime?> onChanged;

  final CustomDatePickerMode mode;

  final DateTime? firstDate;

  final DateTime? lastDate;

  final IconData icon;

  const CustomDatePickerField({
    super.key,

    required this.theme,

    required this.value,

    required this.onChanged,

    this.mode = CustomDatePickerMode.fullDate,

    this.firstDate,

    this.lastDate,

    this.icon = Icons.calendar_month_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPicker(context),

      borderRadius: BorderRadius.circular(AppSizes.radiusMd),

      child: Container(
        height: ResponsiveSize.height(context, 7),

        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 3),
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(AppSizes.radiusMd),

          border: Border.all(color: AppColors.secondary.withValues(alpha: .18)),

          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: .10),

              blurRadius: 16,

              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: ResponsiveSize.width(context, 10),

              height: ResponsiveSize.width(context, 10),

              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .08),

                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),

              child: Icon(
                icon,

                color: AppColors.secondary,

                size: ResponsiveSize.width(context, 5),
              ),
            ),

            SizedBox(width: ResponsiveSize.width(context, 3)),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  customText(
                    text: theme,

                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),

                    color: AppColors.secondary.withValues(alpha: .55),
                  ),

                  SizedBox(height: ResponsiveSize.height(context, .2)),

                  customText(
                    text: _displayValue(),

                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),

                    color: value == null
                        ? AppColors.secondary.withValues(alpha: .55)
                        : AppColors.secondary,

                    isBold: value != null,
                  ),
                ],
              ),
            ),

            Icon(
              Icons.keyboard_arrow_down_rounded,

              color: AppColors.secondary,

              size: ResponsiveSize.width(context, 6),
            ),
          ],
        ),
      ),
    );
  }

  String _displayValue() {
    if (value == null) {
      switch (mode) {
        case CustomDatePickerMode.yearOnly:
          return 'اختر السنة';

        case CustomDatePickerMode.monthOnly:
          return 'اختر الشهر';

        case CustomDatePickerMode.fullDate:
          return 'اختر التاريخ';
      }
    }

    switch (mode) {
      case CustomDatePickerMode.yearOnly:
        return value!.year.toString();

      case CustomDatePickerMode.monthOnly:
        return _monthName(value!.month);

      case CustomDatePickerMode.fullDate:
        return '${value!.day}/${value!.month}/${value!.year}';
    }
  }

  String _monthName(int month) {
    const months = [
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

    return months[month - 1];
  }

  Future<void> _showPicker(BuildContext context) async {
    if (mode == CustomDatePickerMode.yearOnly) {
      final selectedYear = await showModalBottomSheet<int>(
        context: context,

        backgroundColor: Colors.transparent,

        isScrollControlled: true,

        builder: (_) {
          return _YearPickerBottomSheet(
            selectedYear: value?.year,

            firstYear: firstDate?.year ?? 1980,

            lastYear: lastDate?.year ?? DateTime.now().year,

            theme: theme,
          );
        },
      );

      if (selectedYear != null) {
        onChanged(DateTime(selectedYear, value?.month ?? 1, value?.day ?? 1));
      }

      return;
    }

    if (mode == CustomDatePickerMode.monthOnly) {
      final selectedMonth = await showModalBottomSheet<int>(
        context: context,

        backgroundColor: Colors.transparent,

        isScrollControlled: true,

        builder: (_) {
          return _MonthPickerBottomSheet(
            selectedMonth: value?.month,

            theme: theme,
          );
        },
      );

      if (selectedMonth != null) {
        onChanged(
          DateTime(value?.year ?? DateTime.now().year, selectedMonth, 1),
        );
      }

      return;
    }

    final selectedDate = await showDatePicker(
      context: context,
      locale: const Locale('ar'),
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1950),
      lastDate: lastDate ?? DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Cairo',
              bodyColor: AppColors.secondary,
              displayColor: AppColors.secondary,
            ),

            colorScheme: ColorScheme.light(
              primary: AppColors.secondary,

              secondary: AppColors.secondary,

              surface: Colors.white,

              onPrimary: Colors.white,

              onSurface: AppColors.secondary,
            ),

            dialogTheme: DialogThemeData(
              backgroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
            ),
          ),

          child: Directionality(
            textDirection: TextDirection.rtl,

            child: child!,
          ),
        );
      },
    );

    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }
}

class _MonthPickerBottomSheet extends StatelessWidget {
  final int? selectedMonth;

  final String theme;

  const _MonthPickerBottomSheet({
    required this.selectedMonth,

    required this.theme,
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Container(
        constraints: BoxConstraints(
          maxHeight: ResponsiveSize.height(context, 58),
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLg),
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: .14),

              blurRadius: 30,

              offset: const Offset(0, -5),
            ),
          ],
        ),

        child: Column(
          children: [
            SizedBox(height: ResponsiveSize.height(context, 1.2)),

            Container(
              width: ResponsiveSize.width(context, 11),

              height: ResponsiveSize.height(context, .45),

              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .22),

                borderRadius: BorderRadius.circular(100),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.width(context, 5),

                ResponsiveSize.height(context, 2),

                ResponsiveSize.width(context, 5),

                ResponsiveSize.height(context, 1.5),
              ),

              child: Row(
                children: [
                  Container(
                    width: ResponsiveSize.width(context, 10),

                    height: ResponsiveSize.width(context, 10),

                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: .08),

                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),

                    child: const Icon(
                      Icons.calendar_month_rounded,

                      color: AppColors.secondary,
                    ),
                  ),

                  SizedBox(width: ResponsiveSize.width(context, 3)),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      customText(
                        text: 'اختر $theme',

                        fontSize: ResponsiveSize.width(
                          context,

                          AppSizes.fontXl,
                        ),

                        color: AppColors.secondary,

                        isBold: true,
                      ),

                      customText(
                        text: 'حدد الشهر المناسب',

                        fontSize: ResponsiveSize.width(
                          context,

                          AppSizes.fontSm,
                        ),

                        color: AppColors.secondary.withValues(alpha: .55),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 4),

                  0,

                  ResponsiveSize.width(context, 4),

                  ResponsiveSize.height(context, 2),
                ),

                itemCount: _months.length,

                separatorBuilder: (_, __) =>
                    SizedBox(height: ResponsiveSize.height(context, .7)),

                itemBuilder: (context, index) {
                  final month = index + 1;

                  final selected = selectedMonth == month;

                  return InkWell(
                    onTap: () => Navigator.pop(context, month),

                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),

                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(context, 4),

                        vertical: ResponsiveSize.height(context, 1.4),
                      ),

                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.secondary.withValues(alpha: .07)
                            : Colors.white,

                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),

                        border: Border.all(
                          color: selected
                              ? AppColors.secondary
                              : Colors.transparent,
                        ),
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: customText(
                              text: _months[index],

                              fontSize: ResponsiveSize.width(
                                context,

                                AppSizes.fontMd,
                              ),

                              color: AppColors.secondary,

                              isBold: selected,
                            ),
                          ),

                          if (selected)
                            Icon(
                              Icons.check_circle_rounded,

                              color: AppColors.secondary,

                              size: ResponsiveSize.width(context, 5),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearPickerBottomSheet extends StatefulWidget {
  final int? selectedYear;

  final int firstYear;

  final int lastYear;

  final String theme;

  const _YearPickerBottomSheet({
    required this.selectedYear,

    required this.firstYear,

    required this.lastYear,

    required this.theme,
  });

  @override
  State<_YearPickerBottomSheet> createState() => _YearPickerBottomSheetState();
}

class _YearPickerBottomSheetState extends State<_YearPickerBottomSheet> {
  late final List<int> years;

  @override
  void initState() {
    super.initState();

    years = List.generate(
      widget.lastYear - widget.firstYear + 1,

      (index) => widget.lastYear - index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Container(
        constraints: BoxConstraints(
          maxHeight: ResponsiveSize.height(context, 58),
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLg),
          ),

          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: .14),

              blurRadius: 30,

              offset: const Offset(0, -5),
            ),
          ],
        ),

        child: Column(
          children: [
            SizedBox(height: ResponsiveSize.height(context, 1.2)),

            Container(
              width: ResponsiveSize.width(context, 11),

              height: ResponsiveSize.height(context, .45),

              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .22),

                borderRadius: BorderRadius.circular(100),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.width(context, 5),

                ResponsiveSize.height(context, 2),

                ResponsiveSize.width(context, 5),

                ResponsiveSize.height(context, 1.5),
              ),

              child: Row(
                children: [
                  Container(
                    width: ResponsiveSize.width(context, 10),

                    height: ResponsiveSize.width(context, 10),

                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: .08),

                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),

                    child: Icon(
                      Icons.calendar_month_rounded,

                      color: AppColors.secondary,
                    ),
                  ),

                  SizedBox(width: ResponsiveSize.width(context, 3)),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      customText(
                        text: 'اختر ${widget.theme}',

                        fontSize: ResponsiveSize.width(
                          context,

                          AppSizes.fontXl,
                        ),

                        color: AppColors.secondary,

                        isBold: true,
                      ),

                      customText(
                        text: 'حدد السنة المناسبة',

                        fontSize: ResponsiveSize.width(
                          context,

                          AppSizes.fontSm,
                        ),

                        color: AppColors.secondary.withValues(alpha: .55),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 4),

                  0,

                  ResponsiveSize.width(context, 4),

                  ResponsiveSize.height(context, 2),
                ),

                itemCount: years.length,

                separatorBuilder: (_, __) =>
                    SizedBox(height: ResponsiveSize.height(context, .7)),

                itemBuilder: (context, index) {
                  final year = years[index];

                  final selected = widget.selectedYear == year;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, year);
                    },

                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),

                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(context, 4),

                        vertical: ResponsiveSize.height(context, 1.4),
                      ),

                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.secondary.withValues(alpha: .07)
                            : Colors.white,

                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),

                        border: Border.all(
                          color: selected
                              ? AppColors.secondary
                              : Colors.transparent,
                        ),
                      ),

                      child: Row(
                        children: [
                          Expanded(
                            child: customText(
                              text: year.toString(),

                              fontSize: ResponsiveSize.width(
                                context,

                                AppSizes.fontMd,
                              ),

                              color: AppColors.secondary,

                              isBold: selected,
                            ),
                          ),

                          if (selected)
                            Icon(
                              Icons.check_circle_rounded,

                              color: AppColors.secondary,

                              size: ResponsiveSize.width(context, 5),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
