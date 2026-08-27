import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String hint;
  final IconData? icon;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final String? suffixText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    required this.hint,
    this.icon,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.suffixText,
    this.onChanged,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          customText(
            text: label!,
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.primary,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, .65)),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          minLines: obscureText ? 1 : minLines,
          onChanged: onChanged,
          onTap: onTap,
          validator: validator,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffixText,
            suffixStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.textMuted,
            ),
            hintStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.textMuted.withValues(alpha: .78),
            ),
            prefixIcon: icon == null
                ? null
                : Padding(
                    padding: EdgeInsets.all(
                      ResponsiveSize.width(context, 2.1),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Icon(
                        icon,
                        color: AppColors.secondary,
                        size: ResponsiveSize.width(context, 4.6),
                      ),
                    ),
                  ),
            filled: true,
            fillColor: AppColors.textSecondary,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 4),
              vertical: ResponsiveSize.height(context, 1.65),
            ),
            enabledBorder: _border(
              AppColors.border.withValues(alpha: .12),
            ),
            focusedBorder: _border(AppColors.secondary, width: 1.4),
            errorBorder: _border(AppColors.danger),
            focusedErrorBorder: _border(AppColors.danger, width: 1.4),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
