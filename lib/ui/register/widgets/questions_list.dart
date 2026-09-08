import 'package:flutter/material.dart';
import 'package:moftah/data/models/app_user_role_enum.dart';
import 'package:moftah/data/models/number_range.dart';
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

  List<int>? yearPickerQuestionsForRole(AppUserRole role) {
    if (role == AppUserRole.driver) {
      return const [1];
    }

    return null;
  }

  List<int>? datePickerQuestionsForRole(AppUserRole role) {
    if (role == AppUserRole.driver) {
      return const [3, 5];
    }

    return null;
  }

  List<int>? numberQuestionsForRole(AppUserRole role) {
    if (role == AppUserRole.driver) {
      return const [2];
    }

    if (role == AppUserRole.towOperator) {
      return const [1, 4];
    }

    if (role == AppUserRole.workshopOwner) {
      return const [
        1, 
        2,
        5, 
      ];
    }

    return null;
  }

  Map<int, NumberRange>? numberRangesForRole(AppUserRole role) {
    if (role == AppUserRole.driver) {
      return const {2: NumberRange(min: 0, max: 1000000)};
    }

    if (role == AppUserRole.towOperator) {
      return const {

        1: NumberRange(min: 500, max: 10000),


        4: NumberRange(min: 20, max: 200),
      };
    }

    if (role == AppUserRole.workshopOwner) {
      return const {
        1: NumberRange(min: 1, max: 100),

        2: NumberRange(min: 1, max: 200),

        5: NumberRange(min: 0, max: 10000),
      };
    }

    return null;
  }

  List<int>? optionsQuestionsForRole(AppUserRole role) {
    if (role == AppUserRole.driver) {
      return const [4];
    }

    if (role == AppUserRole.towOperator) {
      return const [0];
    }

    if (role == AppUserRole.workshopOwner) {
      return const [
        0, 
      ];
    }

    return null;
  }


  List<int>? writeAbleQuestionsForRole(AppUserRole role) {
    if (role == AppUserRole.driver) {
      return const [
        0, 
      ];
    }

    return null;
  }


  List<QuestionModel> questionsForRole(AppUserRole role) {
    if (role == AppUserRole.driver) {
      return RegistrationQuestions.driverQuestions;
    }

    if (role == AppUserRole.technician) {
      return RegistrationQuestions.technicianQuestions;
    }

    if (role == AppUserRole.towOperator) {
      return RegistrationQuestions.towTruckQuestions;
    }

    if (role == AppUserRole.workshopOwner) {
      return RegistrationQuestions.serviceCenterQuestions;
    }

    return const [];
  }

  // =========================
  // Number Icon
  // =========================

  IconData numberIconForRole(AppUserRole role) {
    if (role == AppUserRole.driver) {
      return Icons.speed_rounded;
    }

    if (role == AppUserRole.towOperator) {
      return Icons.local_shipping_rounded;
    }

    if (role == AppUserRole.workshopOwner) {
      return Icons.build_circle_rounded;
    }

    return Icons.numbers_rounded;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Questions build called with role: ${widget.role}');

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
          : Column(
              children: [
                Container(
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
                    questions: questionsForRole(widget.role),

                    yearPickerQuestions: yearPickerQuestionsForRole(
                      widget.role,
                    ),

                    datePickerQuestions: datePickerQuestionsForRole(
                      widget.role,
                    ),

                    optionsQuestions: optionsQuestionsForRole(widget.role),

                    writeAbleQuestions: writeAbleQuestionsForRole(widget.role),

                    numberQuestions: numberQuestionsForRole(widget.role),

                    numberRanges: numberRangesForRole(widget.role),

                    iconForNumberQuestions: numberIconForRole(widget.role),

                    isWriteable:
                        writeAbleQuestionsForRole(widget.role)?.isNotEmpty ??
                        false,

                    onCompleted: (answers) {
                      debugPrint('answers: $answers');

                      setState(() {
                        finished = true;
                      });
                    },
                  ),
                ),

                SizedBox(height: ResponsiveSize.height(context, 2)),
              ],
            ),
    );
  }
}
