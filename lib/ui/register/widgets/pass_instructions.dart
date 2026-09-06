import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class PassInstructions extends StatelessWidget {
  const PassInstructions({
    super.key,
    required this.isGreaterThan8,
    required this.hasUpperCase,
    required this.hasSpecialChar,
    required this.hasNumber,
    required this.hasNoSpace,
  });

  final bool? isGreaterThan8;
  final bool? hasUpperCase;
  final bool? hasSpecialChar;
  final bool? hasNumber;
  final bool? hasNoSpace;

  bool get _isNotStarted {
    return isGreaterThan8 == null &&
        hasUpperCase == null &&
        hasSpecialChar == null &&
        hasNumber == null &&
        hasNoSpace == null;
  }

  bool get _isAllValid {
    return isGreaterThan8 == true &&
        hasUpperCase == true &&
        hasSpecialChar == true &&
        hasNumber == true &&
        hasNoSpace == true;
  }


  @override
  Widget build(BuildContext context) {
    final Color statusColor = _isNotStarted
        ? AppColors.textMuted
        : _isAllValid
        ? AppColors.success
        : AppColors.danger;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 4),
        vertical: ResponsiveSize.height(context, 2),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: statusColor.withValues(alpha: .55)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                _ruleRow(
                  context,
                  text: 'يجب أن تكون 8 حروف على الأقل',
                  isValid: isGreaterThan8,
                ),
                _ruleRow(
                  context,
                  text: 'يجب أن يكون على الأقل حرف كبير واحد',
                  isValid: hasUpperCase,
                ),
                _ruleRow(
                  context,
                  text: 'يجب أن تحتوي على رمز خاص واحد على الأقل مثل !@#\$%^&*',
                  isValid: hasSpecialChar,
                ),
                _ruleRow(
                  context,
                  text: 'يجب أن تحتوي على رقم واحد على الأقل',
                  isValid: hasNumber,
                ),
                _ruleRow(
                  context,
                  text: 'يجب ألا تحتوي على مسافة',
                  isValid: hasNoSpace,
                ),
              ],
            ),
          ),

          Container(
            width: 1,
            height: ResponsiveSize.height(context, 14),
            margin: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 3),
            ),
            color: AppColors.border.withValues(alpha: .35),
          ),

          Expanded(
            flex: 4,
            child: _statusSection(context, statusColor: statusColor),
          ),
        ],
      ),
    );
  }

  Widget _ruleRow(
    BuildContext context, {
    required String text,
    required bool? isValid,
  }) {
    final Color color;

    if (isValid == null) {
      color = AppColors.textMuted;
    } else if (isValid) {
      color = AppColors.success;
    } else {
      color = AppColors.danger;
    }

    final IconData icon;

    if (isValid == null) {
      icon = Icons.radio_button_unchecked_rounded;
    } else if (isValid) {
      icon = Icons.check_circle_rounded;
    } else {
      icon = Icons.cancel_rounded;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.height(context, .35),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: ResponsiveSize.width(context, 4.5)),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: customText(
              text: text,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusSection(BuildContext context, {required Color statusColor}) {
    final IconData icon;
    final String title;
    final String description;

    if (_isNotStarted) {
      icon = Icons.lock_outline_rounded;
      title = 'شروط كلمة المرور';
      description = 'لم يتم إدخال كلمة مرور بعد';
    } else if (_isAllValid) {
      icon = Icons.verified_user_outlined;
      title = 'قوة كلمة المرور: قوية';
      description = 'كلمة المرور تلبي جميع المتطلبات';
    } else {
      icon = Icons.lock_person_outlined;
      title = 'كلمة المرور غير مكتملة';
      description = 'يرجى استكمال جميع الشروط';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: ResponsiveSize.width(context, 14),
          height: ResponsiveSize.width(context, 14),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: statusColor.withValues(alpha: .10),
          ),
          child: Icon(
            icon,
            color: statusColor,
            size: ResponsiveSize.width(context, 7),
          ),
        ),

        SizedBox(height: ResponsiveSize.height(context, 1)),

        customText(
          text: title,
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: statusColor,
          isBold: true,
          textAlign: TextAlign.center,
        ),

        SizedBox(height: ResponsiveSize.height(context, .4)),

        customText(
          text: description,
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: AppColors.textMuted,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
