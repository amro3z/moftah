import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/core/ui/app_text_field.dart';
import 'package:moftah/utils/responsive.dart';

class AuthField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const AuthField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint,
      icon: icon,
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: ResponsiveSize.width(context, 22),
          height: ResponsiveSize.width(context, 22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .24),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.directions_car_filled_rounded,
                size: ResponsiveSize.width(context, 11),
                color: AppColors.textSecondary,
              ),
              Positioned(
                top: ResponsiveSize.width(context, 2.2),
                right: ResponsiveSize.width(context, 2.2),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 1)),
                  decoration: const BoxDecoration(
                    color: AppColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.key_rounded,
                    size: ResponsiveSize.width(context, 5),
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveSize.height(context, 1.2)),
        customText(
          text: 'مفتاح',
          fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
          color: AppColors.primary,
          isBold: true,
        ),
        customText(
          text: 'كل شيء أصبح أقرب',
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: AppColors.textMuted,
        ),
      ],
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveSize.height(context, 6.6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .24),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: customText(
          text: text,
          fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
          color: AppColors.textSecondary,
          isBold: true,
        ),
      ),
    );
  }
}

class GoogleAuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const GoogleAuthButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveSize.height(context, 6.3),
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border.withValues(alpha: .12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .22),
            blurRadius: AppSizes.radiusSm,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed ?? () {},
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ResponsiveSize.width(context, 8),
                  height: ResponsiveSize.width(context, 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: customText(
                    text: 'G',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                    color: AppColors.secondary,
                    isBold: true,
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 3)),
                customText(
                  text: text,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.primary,
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


