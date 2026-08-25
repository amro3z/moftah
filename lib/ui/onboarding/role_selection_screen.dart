import 'package:flutter/material.dart';
import 'package:moftah/ui/core/constant/role.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/onboarding/widgets/role_selection_widgets.dart';
import 'package:moftah/utils/responsive.dart';

enum AppUserRole { driver, technician, workshopOwner, towOperator }



class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  AppUserRole? selectedRole;



  void _continue() {
    if (selectedRole == null) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
      arguments: selectedRole,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 5),
                  ResponsiveSize.height(context, 1.5),
                  ResponsiveSize.width(context, 5),
                  ResponsiveSize.height(context, 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: ResponsiveSize.width(context, 11),
                      height: ResponsiveSize.width(context, 11),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .14),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.key_rounded,
                        color: AppColors.textSecondary,
                        size: ResponsiveSize.width(context, 6),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.width(context, 3)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text: 'مفتاح',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontLg,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                        customText(
                          text: 'خطوة أخيرة ونبدأ',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.width(context, 5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveSize.height(context, 2)),
                      customText(
                        text: 'اختار تجربتك\nعلى مفتاح',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXxl,
                        ),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .8)),
                      customText(
                        text:
                            'كل نوع حساب له أدوات وخدمات مختلفة. اختار الأنسب ليك.',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                        color: AppColors.textMuted,
                        maxLines: 2,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 2.5)),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: roles.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: ResponsiveSize.height(context, 1.5),
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          final item = roles[index];
                          final selected = selectedRole == item.role;

                          return RoleCard(
                            item: item,
                            selected: selected,
                            onTap: () {
                              setState(() {
                                selectedRole = item.role;
                              });
                            },
                          );
                        },
                      ),

                      SizedBox(height: ResponsiveSize.height(context, 2)),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: EdgeInsets.all(
                          ResponsiveSize.width(context, 3.5),
                        ),
                        decoration: BoxDecoration(
                          color: selectedRole == null
                              ? AppColors.surfaceLight
                              : AppColors.secondary.withValues(alpha: .08),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                          border: Border.all(
                            color: selectedRole == null
                                ? AppColors.border.withValues(alpha: .08)
                                : AppColors.secondary.withValues(alpha: .15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selectedRole == null
                                  ? Icons.touch_app_outlined
                                  : Icons.check_circle_rounded,
                              color: selectedRole == null
                                  ? AppColors.textMuted
                                  : AppColors.secondary,
                              size: ResponsiveSize.width(context, 5),
                            ),
                            SizedBox(width: ResponsiveSize.width(context, 2.5)),
                            Expanded(
                              child: customText(
                                text: selectedRole == null
                                    ? 'اختار نوع الحساب علشان نكمل'
                                    : "تمام نتمنالك تجربة ممتعة على مفتاح",
                                fontSize: ResponsiveSize.width(
                                  context,
                                  AppSizes.fontSm,
                                ),
                                color: selectedRole == null
                                    ? AppColors.textMuted
                                    : AppColors.primary,
                                isBold: selectedRole != null,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: ResponsiveSize.height(context, 2)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: ResponsiveSize.height(context, 6.5),
                  child: FilledButton(
                    onPressed: selectedRole == null ? null : _continue,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withValues(
                        alpha: .28,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    child: customText(
                      text: selectedRole == null
                          ? 'اختار نوع الحساب'
                          : 'ابدأ استخدام مفتاح',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                      color: AppColors.textSecondary,
                      isBold: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

