import 'package:flutter/material.dart';
import 'package:moftah/data/models/app_user_role_enum.dart';
import 'package:moftah/data/models/question_model.dart';
import 'package:moftah/data/store/registration_questions.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/register/widgets/questions_card.dart';
import 'package:moftah/utils/responsive.dart';

class Questions extends StatefulWidget {
  const Questions({super.key, required this.role});
  final AppUserRole role;

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
                yearPickerQuestions: widget.role == AppUserRole.driver
                    ? const [1]
                    : null,
                datePickerQuestions: widget.role == AppUserRole.driver
                    ? const [3, 5]
                    : null,
                optionsQuestions: widget.role == AppUserRole.driver
                    ? const [4]
                    : null,
                numberQuestions: widget.role == AppUserRole.driver
                    ? const [2]
                    : null,
                isWriteable: widget.role == AppUserRole.driver,
                questions: widget.role == AppUserRole.driver
                    ? RegistrationQuestions.driverQuestions
                    : RegistrationQuestions.technicianQuestions,
                onCompleted: (answers) {
                  debugPrint('answers: $answers');
                  setState(() {
                    finished = true;
                  });
                },
              ),
            ),
    );
  }
}
