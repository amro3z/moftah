import 'package:flutter/material.dart';
import 'package:moftah/ui/auth/auth_widgets.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/ui/onboarding/role_selection_screen.dart';

class LoginScreen extends StatelessWidget {


  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Positioned(
              top: -ResponsiveSize.height(context, 10),
              right: -ResponsiveSize.width(context, 20),
              child: Container(
                width: ResponsiveSize.width(context, 62),
                height: ResponsiveSize.width(context, 62),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: .055),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const AuthLogo(),
                    SizedBox(height: ResponsiveSize.height(context, 3.5)),
                    Container(
                      padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .22),
                            blurRadius: 28,
                            offset: const Offset(0, -6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          customText(
                            text: 'مرحباً بعودتك',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontXxl,
                            ),
                            color: AppColors.primary,
                            isBold: true,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ResponsiveSize.height(context, .5)),
                          customText(
                            text: 'سجل دخولك وكمل رحلتك مع مفتاح',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontSm,
                            ),
                            color: AppColors.textMuted,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ResponsiveSize.height(context, 3)),
                          const AuthField(
                            hint: 'أدخل البريد أو رقم الهاتف',
                            icon: Icons.person_outline_rounded,
                          ),
                          SizedBox(height: ResponsiveSize.height(context, 1.6)),
                          const AuthField(
                            hint: 'أدخل كلمة المرور',
                            icon: Icons.lock_outline_rounded,
                            obscureText: true,
                          ),
                          SizedBox(height: ResponsiveSize.height(context, 2.4)),
                          AuthPrimaryButton(
                            text: 'تسجيل الدخول',
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/onboarding',
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: customText(
                              text: 'نسيت كلمة المرور؟',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontSm,
                              ),
                              color: AppColors.secondary,
                              isBold: true,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.border.withValues(
                                    alpha: .15,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.width(context, 3),
                                ),
                                child: customText(
                                  text: 'أو',
                                  fontSize: ResponsiveSize.width(
                                    context,
                                    AppSizes.fontSm,
                                  ),
                                  color: AppColors.textMuted,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.border.withValues(
                                    alpha: .15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveSize.height(context, 1.6)),
                          const GoogleAuthButton(
                            text: 'المتابعة باستخدام Google',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText(
                          text: 'ليس لديك حساب؟',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                          color: AppColors.primary,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            '/onboarding',
                          ),
                          child: customText(
                            text: 'إنشاء حساب',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontSm,
                            ),
                            color: AppColors.secondary,
                            isBold: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
