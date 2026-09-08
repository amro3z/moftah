import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

Widget errorText({required String text, required BuildContext context}) {
  return Container(
    width: double.infinity,
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
          Icons.error_outline_rounded,
          color: AppColors.danger,
          size: ResponsiveSize.width(context, 4.5),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        Expanded(
          child: customText(
            text: text,
            isBold: true,
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.danger,
          ),
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

PreferredSizeWidget registerAppBar({required BuildContext context}) {
  return AppBar(
    automaticallyImplyLeading: false,

    forceMaterialTransparency: true,

    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,

    elevation: 0,
    scrolledUnderElevation: 0,

    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),

    toolbarHeight: ResponsiveSize.height(context, 12.5),

    titleSpacing: 0,

    title: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 4.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: ResponsiveSize.height(context, 9.8),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 3.5),
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
                    color: AppColors.primary.withValues(alpha: .18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: ResponsiveSize.width(context, 15),
                    top: -ResponsiveSize.height(context, 4),
                    child: Transform.rotate(
                      angle: -.25,
                      child: Container(
                        width: ResponsiveSize.width(context, 22),
                        height: ResponsiveSize.height(context, 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .025),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLg,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        width: ResponsiveSize.width(context, 12),
                        height: ResponsiveSize.width(context, 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .05),
                          ),
                        ),
                        child: Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.white,
                          size: ResponsiveSize.width(context, 6),
                        ),
                      ),

                      SizedBox(width: ResponsiveSize.width(context, 3)),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              text: 'أنشئ حسابك',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXxl,
                              ),
                              color: Colors.white,
                              isBold: true,
                            ),

                            SizedBox(
                              height: ResponsiveSize.height(context, .1),
                            ),

                            customText(
                              text: 'ابدأ رحلتك مع خدمات مفتاح',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXs,
                              ),
                              color: Colors.white.withValues(alpha: .68),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: ResponsiveSize.width(context, 2.5)),

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.maybePop(context);
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: ResponsiveSize.width(context, 11),
                height: ResponsiveSize.width(context, 11),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .055),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: .08),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primary,
                    size: ResponsiveSize.width(context, 5.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
