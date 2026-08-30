import 'package:flutter/material.dart';
import 'package:moftah/data/models/question_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/technician/register/widgets/questions_card.dart';
import 'package:moftah/utils/responsive.dart';

class Questions extends StatefulWidget {
  const Questions({super.key, required this.accepted, required this.onChanged});

  final bool accepted;
  final Function(bool?) onChanged;

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchOutCurve: Curves.easeInBack,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
        );
      },

      child: finished
          ? const SizedBox.shrink()
          : Container(
              key: const ValueKey('questions-visible'),
              padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .05),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: QuestionsCard(
                questions: const [
                  QuestionModel(
                    question: 'هل ممكن تطلع بره الورشة؟',
                    answerYes: 'نعم',
                    answerNo: 'لا',
                  ),
                  QuestionModel(
                    question: 'هل عندك أدوات فحص إلكترونية؟',
                    answerYes: 'متوفر',
                    answerNo: 'غير متوفر',
                  ),
                  QuestionModel(
                    question: 'هل تستقبل حالات طوارئ؟',
                    answerYes: 'نعم',
                    answerNo: 'لا',
                  ),
                ],
                onCompleted: (answers) {
                  debugPrint('Answers: $answers');

                  setState(() {
                    finished = true;
                  });
                },
              ),
            ),
    );
  }
}
