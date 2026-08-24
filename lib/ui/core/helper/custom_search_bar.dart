import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/utils/responsive.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String hintText;
  final IconData icon;
  final bool readOnly;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.hintText = 'ابحث...',
    this.icon = Icons.search_rounded,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
        color: AppColors.primary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: AppColors.textMuted,
        ),
        suffixIcon: Icon(
          icon,
          color: AppColors.textMuted,
          size: ResponsiveSize.width(context, 5.13),
        ),
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 3.59),
          vertical: ResponsiveSize.height(context, 1.42),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide(
            color: AppColors.border.withValues(alpha: .10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: const BorderSide(color: AppColors.secondary),
        ),
      ),
    );
  }
}
