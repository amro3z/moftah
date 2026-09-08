import 'package:flutter/material.dart';

import 'package:moftah/data/models/app_user_role_enum.dart';

import 'package:moftah/ui/core/constant/role.dart';

import 'package:moftah/ui/core/themes/colors.dart';

import 'package:moftah/ui/core/themes/sizes.dart';

import 'package:moftah/ui/core/ui/custom_text.dart';

import 'package:moftah/ui/onboarding/widgets/role_selection_widgets.dart';

import 'package:moftah/utils/responsive.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  AppUserRole? selectedRole;

  void _continue() {
    if (selectedRole == null) return;

    String path = '';

    switch (selectedRole) {
      case AppUserRole.driver:
        path = '/register';

        break;

      case AppUserRole.technician:
        path = '/register';

        break;

      case AppUserRole.workshopOwner:
        path = '/register';

        break;

      case AppUserRole.towOperator:
        path = '/register';

        break;

      default:
        break;
    }

    Navigator.pushNamed(context, path, arguments: selectedRole);
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

                    Row(
                        children: [
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 650),

                              switchInCurve: Curves.linear,
                              switchOutCurve: Curves.linear,

                              transitionBuilder: (child, animation) {
                                final slideAnimation =
                                    Tween<Offset>(
                                      begin: const Offset(0, .25),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    );

                                final scaleAnimation =
                                    Tween<double>(begin: .88, end: 1).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutBack,
                                      ),
                                    );

                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: slideAnimation,
                                    child: ScaleTransition(
                                      scale: scaleAnimation,
                                      child: child,
                                    ),
                                  ),
                                );
                              },

                              child: Container(
                                
                             key: ValueKey(selectedRole == null),

                                width: double.infinity,

                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.width(context, 6),
                                  vertical: ResponsiveSize.height(context, 1.6),
                                ),

                                decoration: BoxDecoration(
                                  color: selectedRole == null
                                      ? Colors.white
                                      : AppColors.secondary.withValues(
                                          alpha: .07,
                                        ),

                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusLg,
                                  ),

                                  border: Border.all(
                                    color: selectedRole == null
                                        ? AppColors.border.withValues(
                                            alpha: .12,
                                          )
                                        : AppColors.secondary.withValues(
                                            alpha: .22,
                                          ),
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: .05,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: ResponsiveSize.width(context, 18),
                                      height: ResponsiveSize.width(context, 18),

                                      decoration: BoxDecoration(
                                        color: selectedRole == null
                                            ? AppColors.surfaceLight
                                            : AppColors.secondary.withValues(
                                                alpha: .12,
                                              ),
                                        shape: BoxShape.circle,
                                      ),

                                      child: Icon(
                                        selectedRole == null
                                            ? Icons.touch_app_rounded
                                            : Icons.check_circle_rounded,

                                        color: selectedRole == null
                                            ? AppColors.textMuted
                                            : AppColors.secondary,

                                        size: ResponsiveSize.width(context, 9),
                                      ),
                                    ),

                                    SizedBox(
                                      height: ResponsiveSize.height(context, 2),
                                    ),

                                    customText(
                                      text: selectedRole == null
                                          ? 'اختار نوع حسابك'
                                          : 'اختيار ممتاز',

                                      fontSize: ResponsiveSize.width(
                                        context,
                                        AppSizes.fontXl,
                                      ),

                                      color: AppColors.primary,
                                      isBold: true,
                                      textAlign: TextAlign.center,
                                    ),

                                    SizedBox(
                                      height: ResponsiveSize.height(
                                        context,
                                        .8,
                                      ),
                                    ),

                                    customText(
                                      text: selectedRole == null
                                          ? 'حدد نوع الحساب المناسب ليك من الاختيارات الموجودة فوق علشان نجهز لك التجربة المناسبة.'
                                          : 'تم تحديد نوع الحساب بنجاح.\nكمل التسجيل وابدأ استخدام خدمات مفتاح.',

                                      fontSize: ResponsiveSize.width(
                                        context,
                                        AppSizes.fontSm,
                                      ),

                                      color: AppColors.textMuted,
                                      textAlign: TextAlign.center,
                                      maxLines: 4,
                                    ),

                                    if (selectedRole != null) ...[
                                      SizedBox(
                                        height: ResponsiveSize.height(
                                          context,
                                          2,
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveSize.width(
                                            context,
                                            4,
                                          ),
                                          vertical: ResponsiveSize.height(
                                            context,
                                            1,
                                          ),
                                        ),

                                        decoration: BoxDecoration(
                                          color: AppColors.secondary.withValues(
                                            alpha: .09,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),

                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.verified_rounded,
                                              color: AppColors.secondary,
                                              size: ResponsiveSize.width(
                                                context,
                                                4.5,
                                              ),
                                            ),

                                            SizedBox(
                                              width: ResponsiveSize.width(
                                                context,
                                                1.5,
                                              ),
                                            ),

                                            customText(
                                              text: 'جاهز للمتابعة',
                                              fontSize: ResponsiveSize.width(
                                                context,
                                                AppSizes.fontSm,
                                              ),
                                              color: AppColors.secondary,
                                              isBold: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
