import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:moftah/data/models/number_range.dart';
import 'package:moftah/data/models/question_model.dart';
import 'package:moftah/ui/auth/auth_widgets.dart';
import 'package:moftah/ui/core/helper/custom_date_picker_field.dart';
import 'package:moftah/ui/core/helper/number_range_input_formatter.dart';
import 'package:moftah/ui/core/helper/text_filed_validator.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/register/widgets/register_widgets.dart';
import 'package:moftah/utils/responsive.dart';

class QuestionsCard extends StatefulWidget {
  const QuestionsCard({
    super.key,
    required this.questions,
    this.onCompleted,
    this.isWriteable = false,
    this.datePickerQuestions,
    this.yearPickerQuestions,
    this.optionsQuestions,
    this.numberQuestions,
    this.writeAbleQuestions,
    this.iconForWriteAbleQuestions,
    this.iconForNumberQuestions,
    this.numberRanges,
  });

  final bool isWriteable;

  final List<QuestionModel> questions;

  final ValueChanged<List<dynamic>>? onCompleted;

  final List<int>? datePickerQuestions;

  final List<int>? yearPickerQuestions;

  final List<int>? optionsQuestions;

  final List<int>? numberQuestions;

  final List<int>? writeAbleQuestions;

  final IconData? iconForWriteAbleQuestions;

  final IconData? iconForNumberQuestions;

  final Map<int, NumberRange>? numberRanges;

  @override
  State<QuestionsCard> createState() => _QuestionsCardState();
}

class _QuestionsCardState extends State<QuestionsCard> {
  int currentIndex = 0;

  late List<dynamic> answers;

  late List<String?> questionErrors;

  bool completed = false;

  @override
  void initState() {
    super.initState();

    answers = List<dynamic>.filled(widget.questions.length, null);

    questionErrors = List<String?>.filled(widget.questions.length, null);
  }

  Future<void> _next() async {
    final isNumberQuestion =
        widget.numberQuestions?.contains(currentIndex) ?? false;

    if (isNumberQuestion) {
      final numberRange = widget.numberRanges?[currentIndex];

      if (numberRange != null) {
        final error = TextFiledValidator.numberValidator(
          answers[currentIndex]?.toString(),
          min: numberRange.min,
          max: numberRange.max,
        );

        if (error != null) {
          setState(() {
            questionErrors[currentIndex] = error;
          });

          return;
        }

        setState(() {
          questionErrors[currentIndex] = null;
        });
      }
    }

    if (answers[currentIndex] == null) {
      return;
    }

    final isLast = currentIndex == widget.questions.length - 1;

    if (isLast) {
      await _finishQuestions();
      return;
    }

    setState(() {
      currentIndex++;
    });
  }

  Future<void> _finishQuestions() async {
    setState(() {
      completed = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 850));

    if (!mounted) {
      return;
    }

    widget.onCompleted?.call(answers);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: completed ? _completedState(context) : _questionsState(context),
    );
  }

  Widget _questionsState(BuildContext context) {
    final progress = (currentIndex + 1) / widget.questions.length;

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: ResponsiveSize.width(context, 10),
              height: ResponsiveSize.width(context, 10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(
                Icons.quiz_rounded,
                color: AppColors.secondary,
                size: ResponsiveSize.width(context, 5.5),
              ),
            ),

            SizedBox(width: ResponsiveSize.width(context, 3)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: 'أسئلة سريعة',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: AppColors.primary,
                    isBold: true,
                  ),
                  customText(
                    text:
                        'سؤال ${currentIndex + 1} من ${widget.questions.length}',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: ResponsiveSize.height(context, 1.2)),

        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: progress,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            minHeight: ResponsiveSize.height(context, .65),
            backgroundColor: AppColors.surfaceLight,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.secondary,
            ),
          ),
        ),

        SizedBox(height: ResponsiveSize.height(context, 1.8)),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final slideAnimation = Tween<Offset>(
                begin: const Offset(.08, 0),
                end: Offset.zero,
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slideAnimation, child: child),
              );
            },
            child: _questionContent(context, currentIndex),
          ),
        ),

        SizedBox(height: ResponsiveSize.height(context, 1)),

        SizedBox(
          width: double.infinity,
          height: ResponsiveSize.height(context, 5.7),
          child: ElevatedButton(
            onPressed: answers[currentIndex] == null ? null : _next,
            style: ElevatedButton.styleFrom(
              elevation: answers[currentIndex] == null ? 0 : 5,
              backgroundColor: AppColors.secondary,
              disabledBackgroundColor: AppColors.textMuted.withValues(
                alpha: .18,
              ),
              shadowColor: AppColors.secondary.withValues(alpha: .22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            child: customText(
              text: currentIndex == widget.questions.length - 1
                  ? 'إنهاء'
                  : 'التالي',
              color: Colors.white,
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              isBold: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionContent(BuildContext context, int index) {
    final question = widget.questions[index];

    final isNumberQuestion = widget.numberQuestions?.contains(index) ?? false;

    final isWriteAbleQuestion =
        widget.writeAbleQuestions?.contains(index) ?? false;

    final numberRange = widget.numberRanges?[index];

    final currentError = questionErrors[index];

    return Column(
      key: ValueKey(index),
      mainAxisSize: MainAxisSize.min,
      children: [
        customText(
          text: question.question,
          fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
          color: AppColors.primary,
          isBold: true,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),

        SizedBox(height: ResponsiveSize.height(context, 1.2)),

        if (widget.yearPickerQuestions?.contains(index) ?? false)
          CustomDatePickerField(
            theme: 'سنة التصنيع',
            value: answers[index] as DateTime?,
            mode: CustomDatePickerMode.yearOnly,
            firstDate: DateTime(1980),
            lastDate: DateTime.now(),
            onChanged: (value) {
              setState(() {
                answers[index] = value;
              });
            },
          )
        else if (widget.datePickerQuestions?.contains(index) ?? false)
          CustomDatePickerField(
            theme: 'التاريخ',
            value: answers[index] as DateTime?,
            mode: CustomDatePickerMode.fullDate,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            onChanged: (value) {
              setState(() {
                answers[index] = value;
              });
            },
          )
        else if (widget.optionsQuestions?.contains(index) ?? false)
          _optionsAnswer(
            context,
            index: index,
            options: question.options ?? const [],
          )
        else if (isWriteAbleQuestion || isNumberQuestion)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AuthField(
                icon: isNumberQuestion
                    ? widget.iconForNumberQuestions ?? Icons.edit_rounded
                    : widget.iconForWriteAbleQuestions ?? Icons.edit_rounded,

                hint: isNumberQuestion ? 'اكتب الرقم هنا' : 'اكتب إجابتك هنا',

                keyboardType: isNumberQuestion
                    ? TextInputType.number
                    : TextInputType.text,

                inputFormatters: isNumberQuestion
                    ? [
                        FilteringTextInputFormatter.digitsOnly,

                        if (numberRange != null)
                          NumberRangeInputFormatter(max: numberRange.max),
                      ]
                    : null,

                onChanged: (value) {
                  setState(() {
                    answers[index] = value.trim().isEmpty ? null : value;

                    if (isNumberQuestion &&
                        numberRange != null &&
                        questionErrors[index] != null) {
                      questionErrors[index] =
                          TextFiledValidator.numberValidator(
                            value,
                            min: numberRange.min,
                            max: numberRange.max,
                          );
                    }
                  });
                },
              ),

              if (currentError != null) ...[
                SizedBox(height: ResponsiveSize.height(context, 1)),

                errorText(text: currentError, context: context),
              ],
            ],
          )
        else
          RadioGroup<bool>(
            groupValue: answers[index] as bool?,
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                answers[index] = value;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _boolAnswerCard(
                  context,
                  title: question.answerYes!,
                  value: true,
                  selected: answers[index] == true,
                  color: AppColors.secondary,
                  icon: Icons.check_circle_rounded,
                ),

                SizedBox(width: ResponsiveSize.width(context, 4)),

                _boolAnswerCard(
                  context,
                  title: question.answerNo!,
                  value: false,
                  selected: answers[index] == false,
                  color: AppColors.danger,
                  icon: Icons.cancel_rounded,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _optionsAnswer(
    BuildContext context, {
    required int index,
    required List<String> options,
  }) {
    if (options.isEmpty) {
      return customText(
        text: 'لا توجد اختيارات متاحة',
        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
        color: AppColors.textMuted,
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: ResponsiveSize.width(context, 2),
      runSpacing: ResponsiveSize.height(context, .8),
      children: options.map((option) {
        final selected = answers[index] == option;

        return GestureDetector(
          onTap: () {
            setState(() {
              answers[index] = option;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 4),
              vertical: ResponsiveSize.height(context, 1.15),
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.secondary.withValues(alpha: .10)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: selected
                    ? AppColors.secondary
                    : AppColors.border.withValues(alpha: .12),
                width: selected ? 1.3 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.secondary,
                    size: ResponsiveSize.width(context, 4.5),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 1.5)),
                ],
                customText(
                  text: option,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: selected ? AppColors.secondary : AppColors.primary,
                  isBold: selected,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _boolAnswerCard(
    BuildContext context, {
    required String title,
    required bool value,
    required bool selected,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          answers[currentIndex] = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: ResponsiveSize.width(context, 27),
        height: ResponsiveSize.height(context, 12),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2),
          vertical: ResponsiveSize.height(context, .8),
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: .06)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: selected ? color : AppColors.border.withValues(alpha: .10),
            width: selected ? 1.3 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: .15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveSize.width(context, 5.2),
              color: selected ? color : AppColors.textMuted,
            ),

            SizedBox(height: ResponsiveSize.height(context, .25)),

            customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: selected ? color : AppColors.textMuted,
              isBold: true,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: ResponsiveSize.height(context, .1)),

            SizedBox(
              width: ResponsiveSize.width(context, 6),
              height: ResponsiveSize.width(context, 6),
              child: Radio<bool>(value: value, activeColor: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _completedState(BuildContext context) {
    return SizedBox(
      key: const ValueKey('completed'),
      height: ResponsiveSize.height(context, 15),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 450),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                width: ResponsiveSize.width(context, 14),
                height: ResponsiveSize.width(context, 14),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.done_rounded,
                  color: AppColors.success,
                  size: ResponsiveSize.width(context, 7),
                ),
              ),
            ),

            SizedBox(height: ResponsiveSize.height(context, .7)),

            customText(
              text: 'تم حفظ الإجابات',
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.primary,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}
