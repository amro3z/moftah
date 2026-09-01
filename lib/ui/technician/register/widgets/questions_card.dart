import 'package:flutter/material.dart';
import 'package:moftah/data/models/question_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class QuestionsCard extends StatefulWidget {
  const QuestionsCard({super.key, required this.questions, this.onCompleted});

  final List<QuestionModel> questions;
  final ValueChanged<List<bool?>>? onCompleted;

  @override
  State<QuestionsCard> createState() => _QuestionsCardState();
}

class _QuestionsCardState extends State<QuestionsCard> {
  final PageController _pageController = PageController();

  int currentIndex = 0;

  late List<bool?> answers;

  bool completed = false;

  @override
  void initState() {
    super.initState();

    answers = List<bool?>.filled(widget.questions.length, null);
  }

  Future<void> _next() async {
    if (answers[currentIndex] == null) return;

    final isLast = currentIndex == widget.questions.length - 1;

    if (isLast) {
      await _finishQuestions();
      return;
    }

    setState(() {
      currentIndex++;
    });

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finishQuestions() async {
    setState(() {
      completed = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 850));

    if (!mounted) return;

    widget.onCompleted?.call(answers);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      key: const ValueKey('questions'),
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

        SizedBox(
          height: ResponsiveSize.height(context, 18),
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.questions.length,
            itemBuilder: (context, index) {
              final question = widget.questions[index];

              return Column(
                children: [
                  customText(
                    text: question.question,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                    color: AppColors.primary,
                    isBold: true,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),

                  SizedBox(height: ResponsiveSize.height(context, 1.5)),

                  RadioGroup<bool>(
                    groupValue: answers[index],
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        answers[index] = value;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _answerCard(
                          context,
                          title: question.answerYes,
                          value: true,
                          selected: answers[index] == true,
                          color: AppColors.secondary,
                          icon: Icons.check_circle_rounded,
                        ),

                        SizedBox(width: ResponsiveSize.width(context, 4)),

                        _answerCard(
                          context,
                          title: question.answerNo,
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
            },
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

  Widget _answerCard(
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
