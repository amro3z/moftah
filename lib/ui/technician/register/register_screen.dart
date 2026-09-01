import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moftah/data/store/custom_list.dart';
import 'package:moftah/ui/auth/auth_widgets.dart';
import 'package:moftah/ui/core/helper/custom_list.dart';
import 'package:moftah/ui/core/helper/text_filed_validator.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/register/widgets/pass_instructions.dart';
import 'package:moftah/ui/technician/register/widgets/questions_list.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianRegisterScreen extends StatefulWidget {
  const TechnicianRegisterScreen({super.key});

  @override
  State<TechnicianRegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<TechnicianRegisterScreen> {
  String? selectedGovernorate;
  String? selectedCategory;

  final FocusNode passwordFocusNode = FocusNode();

  String password = '';
  String confirmPassword = '';

  bool showPassInstructions = false;

  bool? isGreaterThan8;
  bool? hasUpperCase;
  bool? hasSpecialChar;
  bool? hasNoSpace;
  bool? hasNumber;

  List<String> passErrors = [];

  bool get isPasswordValid {
    return password.isNotEmpty && passErrors.isEmpty;
  }

  bool get isConfirmPasswordValid {
    return confirmPassword.isNotEmpty && confirmPassword == password;
  }

  @override
  void initState() {
    super.initState();

    passwordFocusNode.addListener(() {
      if (!mounted) return;

      setState(() {
        showPassInstructions = passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    setState(() {
      password = value;

      isGreaterThan8 = value.length >= 8;

      hasNumber = RegExp(r'[0-9]').hasMatch(value);

      hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);

      hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

      hasNoSpace = !RegExp(r'\s').hasMatch(value);

      passErrors = TextFiledValidator.passwordErrors(value);

      if (confirmPassword.isNotEmpty) {
        confirmPassword = '';
      }
    });

    log('Password: $password');
  }

  void _onRegisterPressed() {
    FocusScope.of(context).unfocus();

    if (!isPasswordValid) {
      return;
    }

    if (!isConfirmPasswordValid) {
      return;
    }

    log('Register');
    log('Password valid: $password');

    // Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/role-selection');
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primary,
              ),
            ),
          ],
          leading: const SizedBox(),
        ),
        body: Stack(
          children: [
            Positioned(
              top: -ResponsiveSize.height(context, 7),
              left: -ResponsiveSize.width(context, 22),
              child: Container(
                width: ResponsiveSize.width(context, 60),
                height: ResponsiveSize.width(context, 60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: .05),
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 6),
                  0,
                  ResponsiveSize.width(context, 6),
                  ResponsiveSize.height(context, 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveSize.width(context, 4.5),
                      ),
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
                              color: AppColors.textSecondary.withValues(
                                alpha: .12,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
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
                                  fontSize: ResponsiveSize.width(
                                    context,
                                    AppSizes.fontXxl,
                                  ),
                                  color: AppColors.textSecondary,
                                  isBold: true,
                                ),
                                customText(
                                  text: 'ابدأ رحلتك مع خدمات مفتاح',
                                  fontSize: ResponsiveSize.width(
                                    context,
                                    AppSizes.fontSm,
                                  ),
                                  color: AppColors.textSecondary.withValues(
                                    alpha: .75,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: ResponsiveSize.height(context, 2.5)),

                    const AuthField(
                      hint: 'أدخل اسمك الكامل',
                      icon: Icons.person_outline_rounded,
                    ),

                    _gap(context),

                    const AuthField(
                      hint: 'أدخل رقم الهاتف',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    _gap(context),

                    const AuthField(
                      hint: 'أدخل البريد الإلكتروني',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    _gap(context),

                    CustomListField(
                      icon: Icons.location_on_rounded,
                      theme: 'المحافظة',
                      list: CustomListStore.governorates,
                      value: selectedGovernorate,
                      onChanged: (value) {
                        setState(() {
                          selectedGovernorate = value;
                        });
                      },
                    ),

                    _gap(context),

                    CustomListField(
                      icon: Icons.build_rounded,
                      theme: 'التخصص',
                      list: CustomListStore.technicianCategories,
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    _gap(context),

                    const Questions(),

                    _gap(context),

                    AuthField(
                      hint: 'أدخل كلمة مرور قوية',
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                      focusNode: passwordFocusNode,
                      validator: TextFiledValidator.passwordValidator,
                      onChanged: _onPasswordChanged,
                    ),

                    _gap(context),

                    if (showPassInstructions) ...[
                      PassInstructions(
                        hasNumber: hasNumber,
                        isGreaterThan8: isGreaterThan8,
                        hasUpperCase: hasUpperCase,
                        hasSpecialChar: hasSpecialChar,
                        hasNoSpace: hasNoSpace,
                      ),
                      _gap(context),
                    ],

                    IgnorePointer(
                      ignoring: !isPasswordValid,
                      child: Opacity(
                        opacity: isPasswordValid ? 1 : .45,
                        child: AuthField(
                          hint: 'أعد إدخال كلمة المرور',
                          icon: Icons.verified_user_outlined,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              confirmPassword = value;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: ResponsiveSize.height(context, 1.2)),

                    if (confirmPassword.isNotEmpty &&
                        confirmPassword != password) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.width(context, 2),
                        ),
                        child: customText(
                          text: 'كلمتا المرور غير متطابقتين',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                          color: AppColors.danger,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1)),
                    ],

                    SizedBox(height: ResponsiveSize.height(context, 2)),

                    AuthPrimaryButton(
                      text: 'إنشاء الحساب',
                      onPressed: _onRegisterPressed,
                    ),

                    SizedBox(height: ResponsiveSize.height(context, 2)),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.border.withValues(alpha: .15),
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
                            color: AppColors.border.withValues(alpha: .15),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ResponsiveSize.height(context, 1.5)),

                    const GoogleAuthButton(text: 'إنشاء حساب باستخدام Google'),

                    SizedBox(height: ResponsiveSize.height(context, 1.5)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customText(
                          text: 'لديك حساب بالفعل؟',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                          color: AppColors.primary,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: customText(
                            text: 'تسجيل الدخول',
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

  Widget _gap(BuildContext context) {
    return SizedBox(height: ResponsiveSize.height(context, 1.4));
  }
}
