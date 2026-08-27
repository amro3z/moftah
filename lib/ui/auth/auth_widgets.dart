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

class EgyptGovernorateField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const EgyptGovernorateField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<String> governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الدقهلية',
    'البحر الأحمر',
    'البحيرة',
    'الفيوم',
    'الغربية',
    'الإسماعيلية',
    'المنوفية',
    'المنيا',
    'القليوبية',
    'الوادي الجديد',
    'السويس',
    'أسوان',
    'أسيوط',
    'بني سويف',
    'بورسعيد',
    'دمياط',
    'الشرقية',
    'جنوب سيناء',
    'كفر الشيخ',
    'مطروح',
    'الأقصر',
    'قنا',
    'شمال سيناء',
    'سوهاج',
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showGovernorates(context),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        height: ResponsiveSize.height(context, 7),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 3),
        ),
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.border.withValues(alpha: .10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveSize.width(context, 10),
              height: ResponsiveSize.width(context, 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: ResponsiveSize.width(context, 5),
              ),
            ),

            SizedBox(width: ResponsiveSize.width(context, 3)),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: 'المحافظة',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.textMuted,
                  ),

                  SizedBox(height: ResponsiveSize.height(context, .2)),

                  customText(
                    text: value ?? 'اختر محافظتك',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: value == null
                        ? AppColors.textMuted
                        : AppColors.primary,
                    isBold: value != null,
                  ),
                ],
              ),
            ),

            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
              size: ResponsiveSize.width(context, 6),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showGovernorates(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,

      backgroundColor: Colors.transparent,

      isScrollControlled: true,

      builder: (context) {
        return _GovernoratesBottomSheet(currentValue: value);
      },
    );

    if (selected != null) {
      onChanged(selected);
    }
  }
}

class _GovernoratesBottomSheet extends StatefulWidget {
  final String? currentValue;

  const _GovernoratesBottomSheet({required this.currentValue});

  @override
  State<_GovernoratesBottomSheet> createState() =>
      _GovernoratesBottomSheetState();
}

class _GovernoratesBottomSheetState extends State<_GovernoratesBottomSheet> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filteredGovernorates = EgyptGovernorateField.governorates.where((
      governorate,
    ) {
      return governorate.contains(search.trim());
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .58,
        ),
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLg),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .15),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: ResponsiveSize.height(context, 1.2)),

            // الخط الصغير فوق
            Container(
              width: ResponsiveSize.width(context, 11),
              height: ResponsiveSize.height(context, .45),
              decoration: BoxDecoration(
                color: AppColors.border.withValues(alpha: .25),
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.width(context, 5),
                ResponsiveSize.height(context, 2),
                ResponsiveSize.width(context, 5),
                ResponsiveSize.height(context, 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: 'اختر المحافظة',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                    color: AppColors.primary,
                    isBold: true,
                  ),

                  SizedBox(height: ResponsiveSize.height(context, .4)),

                  customText(
                    text: 'حدد المحافظة التي تقيم بها',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.textMuted,
                  ),

                  SizedBox(height: ResponsiveSize.height(context, 1.5)),

                  // Search
                  Container(
                    height: ResponsiveSize.height(context, 5.8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primary,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                      ),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن المحافظة',

                        hintStyle: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textMuted,
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                        ),

                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textMuted,
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.height(context, 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 4),
                  0,
                  ResponsiveSize.width(context, 4),
                  ResponsiveSize.height(context, 2),
                ),

                itemCount: filteredGovernorates.length,

                separatorBuilder: (_, __) =>
                    SizedBox(height: ResponsiveSize.height(context, .7)),

                itemBuilder: (context, index) {
                  final governorate = filteredGovernorates[index];

                  final selected = governorate == widget.currentValue;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, governorate);
                    },
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),

                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(context, 4),
                        vertical: ResponsiveSize.height(context, 1.4),
                      ),

                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: .07)
                            : AppColors.surfaceLight,

                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),

                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(
                            width: ResponsiveSize.width(context, 8),
                            height: ResponsiveSize.width(context, 8),

                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,

                              shape: BoxShape.circle,
                            ),

                            child: Icon(
                              Icons.location_on_rounded,
                              color: selected
                                  ? AppColors.textSecondary
                                  : AppColors.secondary,
                              size: ResponsiveSize.width(context, 4),
                            ),
                          ),

                          SizedBox(width: ResponsiveSize.width(context, 3)),

                          Expanded(
                            child: customText(
                              text: governorate,
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontMd,
                              ),
                              color: AppColors.primary,
                              isBold: selected,
                            ),
                          ),

                          if (selected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                              size: ResponsiveSize.width(context, 5),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
