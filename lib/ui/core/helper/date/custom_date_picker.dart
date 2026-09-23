import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  String title = 'اختيار التاريخ',
}) {
  final now = DateTime.now();

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return _CustomDatePickerSheet(
        initialDate: initialDate ?? now,
        firstDate: firstDate ?? now,
        lastDate: lastDate ?? DateTime(now.year + 2),
        title: title,
      );
    },
  );
}

class _CustomDatePickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title;

  const _CustomDatePickerSheet({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.title,
  });

  @override
  State<_CustomDatePickerSheet> createState() => _CustomDatePickerSheetState();
}

class _CustomDatePickerSheetState extends State<_CustomDatePickerSheet> {
  late DateTime selectedDate;
  late DateTime displayedMonth;

  static const List<String> months = [
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

  static const List<String> weekDays = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );

    displayedMonth = DateTime(selectedDate.year, selectedDate.month);
  }

  bool _sameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  bool _isAllowed(DateTime date) {
    final current = DateTime(date.year, date.month, date.day);

    final first = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      widget.firstDate.day,
    );

    final last = DateTime(
      widget.lastDate.year,
      widget.lastDate.month,
      widget.lastDate.day,
    );

    return !current.isBefore(first) && !current.isAfter(last);
  }

  void _previousMonth() {
    final month = DateTime(displayedMonth.year, displayedMonth.month - 1);

    if (month.isBefore(
      DateTime(widget.firstDate.year, widget.firstDate.month),
    )) {
      return;
    }

    setState(() {
      displayedMonth = month;
    });
  }

  void _nextMonth() {
    final month = DateTime(displayedMonth.year, displayedMonth.month + 1);

    if (month.isAfter(DateTime(widget.lastDate.year, widget.lastDate.month))) {
      return;
    }

    setState(() {
      displayedMonth = month;
    });
  }

  void _selectQuickDate(int days) {
    final now = DateTime.now();

    final date = DateTime(now.year, now.month, now.day + days);

    if (!_isAllowed(date)) return;

    setState(() {
      selectedDate = date;
      displayedMonth = DateTime(date.year, date.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(displayedMonth.year, displayedMonth.month, 1);

    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;

    final leadingDays = (firstDay.weekday + 1) % 7;

    final itemCount = leadingDays + daysInMonth;

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
                        text: widget.title,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontLg,
                        ),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      customText(
                        text: 'حدد اليوم المناسب',
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
            Row(
              children: [
                Expanded(
                  child: _QuickDateButton(
                    title: 'اليوم',
                    onTap: () => _selectQuickDate(0),
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: _QuickDateButton(
                    title: 'غدًا',
                    onTap: () => _selectQuickDate(1),
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: _QuickDateButton(
                    title: 'بعد غد',
                    onTap: () => _selectQuickDate(2),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _previousMonth,
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      Expanded(
                        child: Center(
                          child: customText(
                            text:
                                '${months[displayedMonth.month - 1]} ${displayedMonth.year}',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontMd,
                            ),
                            color: AppColors.primary,
                            isBold: true,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _nextMonth,
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 1)),
                  Row(
                    children: weekDays
                        .map(
                          (day) => Expanded(
                            child: Center(
                              child: customText(
                                text: day,
                                fontSize: ResponsiveSize.width(
                                  context,
                                  AppSizes.fontXs,
                                ),
                                color: AppColors.textMuted,
                                isBold: true,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 1)),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 1,
                        ),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index < leadingDays) {
                        return const SizedBox();
                      }

                      final day = index - leadingDays + 1;

                      final date = DateTime(
                        displayedMonth.year,
                        displayedMonth.month,
                        day,
                      );

                      final selected = _sameDay(date, selectedDate);

                      final today = _sameDay(date, DateTime.now());

                      final enabled = _isAllowed(date);

                      return GestureDetector(
                        onTap: enabled
                            ? () {
                                setState(() {
                                  selectedDate = date;
                                });
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.secondary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: today && !selected
                                ? Border.all(color: AppColors.secondary)
                                : null,
                          ),
                          child: Center(
                            child: customText(
                              text: '$day',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontSm,
                              ),
                              color: !enabled
                                  ? Colors.grey.shade300
                                  : selected
                                  ? Colors.white
                                  : AppColors.primary,
                              isBold: selected || today,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
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
                    text:
                        '${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
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
                  Navigator.pop(context, selectedDate);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveSize.height(context, 1.4),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: customText(
                  text: 'تأكيد التاريخ',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickDateButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _QuickDateButton({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondary.withValues(alpha: .07),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveSize.height(context, 1),
          ),
          child: Center(
            child: customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.secondary,
              isBold: true,
            ),
          ),
        ),
      ),
    );
  }
}
