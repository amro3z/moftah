import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

Widget errorText({required String text, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
    decoration: BoxDecoration(
      color: AppColors.danger.withValues(alpha: .05),
      border: Border.all(color: AppColors.danger.withValues(alpha: .35)),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      boxShadow: [
        BoxShadow(
          color: AppColors.danger.withValues(alpha: .05),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(
          Icons.cancel_outlined,
          color: AppColors.danger,
          size: ResponsiveSize.width(context, 4),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        customText(
          text: text,
          isBold: true,
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: AppColors.danger,
        ),
      ],
    ),
  );
}

Widget alreadyHaveAnAccount({required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      customText(
        text: 'لديك حساب بالفعل؟',
        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
        color: AppColors.primary,
      ),
      TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: customText(
          text: 'تسجيل الدخول',
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: AppColors.secondary,
          isBold: true,
        ),
      ),
    ],
  );
}

Widget orDivider({required BuildContext context}) {
  return Row(
    children: [
      Expanded(child: Divider(color: AppColors.border.withValues(alpha: .15))),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 3),
        ),
        child: customText(
          text: 'أو',
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: AppColors.textMuted,
        ),
      ),
      Expanded(child: Divider(color: AppColors.border.withValues(alpha: .15))),
    ],
  );
}

Widget header({required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(ResponsiveSize.width(context, 4.5)),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [AppColors.primary, AppColors.surfaceDark],
      ),
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: .22),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: ResponsiveSize.width(context, 16),
          height: ResponsiveSize.width(context, 16),
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Icon(
            Icons.person_add_alt_1_rounded,
            color: AppColors.textSecondary,
            size: ResponsiveSize.width(context, 8),
          ),
        ),

        SizedBox(width: ResponsiveSize.width(context, 4)),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: 'أنشئ حسابك',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
                color: AppColors.textSecondary,
                isBold: true,
              ),
              customText(
                text: 'ابدأ رحلتك مع خدمات مفتاح',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textSecondary.withValues(alpha: .75),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
