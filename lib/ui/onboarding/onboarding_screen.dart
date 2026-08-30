import 'package:flutter/material.dart';
import 'package:moftah/ui/core/constant/onboarding_pages.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/onboarding/widgets/onboarding_widgets.dart';
import 'package:moftah/utils/responsive.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  

  void _next() {
    if (_index == onboardingPages.length - 1) {
      Navigator.pushReplacementNamed(context, '/role-selection');
      return;
    }

    _controller.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Positioned(
              top: -ResponsiveSize.width(context, 38),
              left: -ResponsiveSize.width(context, 25),
              child: const _GlowCircle(size: 90),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      ResponsiveSize.width(context, 5),
                      ResponsiveSize.height(context, 1),
                      ResponsiveSize.width(context, 5),
                      0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: ResponsiveSize.width(context, 10),
                          height: ResponsiveSize.width(context, 10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: .18),
                                blurRadius: 14,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.key_rounded,
                            color: AppColors.textSecondary,
                            size: ResponsiveSize.width(context, 5.5),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.width(context, 2.5)),
                        customText(
                          text: 'مفتاح',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontLg,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            '/role-selection',
                          ),
                          child: customText(
                            text: 'تخطي',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontSm,
                            ),
                            color: AppColors.textMuted,
                            isBold: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: onboardingPages.length,
                      onPageChanged: (value) {
                        setState(() {
                          _index = value;
                        });
                      },
                      itemBuilder: (_, index) {
                        return OnboardingPage(data: onboardingPages[index]);
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      ResponsiveSize.width(context, 5),
                      ResponsiveSize.height(context, .8),
                      ResponsiveSize.width(context, 5),
                      ResponsiveSize.height(context, 2.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: ResponsiveSize.height(context, 6.2),
                            child: FilledButton(
                              onPressed: _next,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMd,
                                  ),
                                ),
                              ),
                              child: customText(
                                text: _index == onboardingPages.length - 1
                                    ? 'اختيار نوع الحساب'
                                    : 'التالي',
                                fontSize: ResponsiveSize.width(
                                  context,
                                  AppSizes.fontMd,
                                ),
                                color: AppColors.textSecondary,
                                isBold: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.width(context, 4)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            onboardingPages.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.width(context, .55),
                              ),
                              width: ResponsiveSize.width(
                                context,
                                i == _index ? 5.5 : 2,
                              ),
                              height: ResponsiveSize.width(context, 2),
                              decoration: BoxDecoration(
                                color: i == _index
                                    ? AppColors.secondary
                                    : AppColors.border.withValues(alpha: .18),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;

  const _GlowCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSize.width(context, size),
      height: ResponsiveSize.width(context, size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.secondary.withValues(alpha: .045),
      ),
    );
  }
}
