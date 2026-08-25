import 'package:flutter/material.dart';
import 'package:moftah/data/models/onboarding_page_data.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 5),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ResponsiveSize.height(context, 1.3)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 3),
                vertical: ResponsiveSize.height(context, .7),
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(100),
              ),
              child: customText(
                text: data.badge,
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.secondary,
                isBold: true,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 1)),
            customText(
              text: data.title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
              color: AppColors.primary,
              isBold: true,
            ),
            SizedBox(height: ResponsiveSize.height(context, .4)),
            customText(
              text: data.subtitle,
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.textMuted,
              maxLines: 3,
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.4)),
            SizedBox(
              height: ResponsiveSize.height(context, 65),
              child: Container(
                width: double.infinity,

                padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [AppColors.primary, AppColors.surfaceDark],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .18),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _TopFeatureBadge(
                          icon: data.smallIcon1,
                          text: data.benefit1Title,
                        ),
                        const Spacer(),
                        _TopFeatureBadge(
                          icon: data.smallIcon2,
                          text: data.benefit2Title,
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveSize.height(context, .9)),

                    Expanded(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: ResponsiveSize.width(context, 39),
                              height: ResponsiveSize.width(context, 39),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.textSecondary.withValues(
                                  alpha: .07,
                                ),
                                border: Border.all(
                                  color: AppColors.secondary.withValues(
                                    alpha: .35,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: ResponsiveSize.width(context, 27),
                              height: ResponsiveSize.width(context, 27),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusXl,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .16),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                data.heroIcon,
                                color: AppColors.secondary,
                                size: ResponsiveSize.width(context, 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, .8)),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .10),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: ResponsiveSize.width(context, 9),
                                height: ResponsiveSize.width(context, 9),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(
                                    alpha: .10,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radiusMd,
                                  ),
                                ),
                                child: Icon(
                                  data.benefit1Icon,
                                  color: AppColors.secondary,
                                  size: ResponsiveSize.width(context, 4.5),
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveSize.width(context, 2.2),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      text: data.highlightTitle,
                                      fontSize: ResponsiveSize.width(
                                        context,
                                        AppSizes.fontMd,
                                      ),
                                      color: AppColors.primary,
                                      isBold: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: ResponsiveSize.height(
                                        context,
                                        .15,
                                      ),
                                    ),
                                    customText(
                                      text: data.highlightSubtitle,
                                      fontSize: ResponsiveSize.width(
                                        context,
                                        AppSizes.fontXs,
                                      ),
                                      color: AppColors.textMuted,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveSize.width(
                                    context,
                                    1.8,
                                  ),
                                  vertical: ResponsiveSize.height(context, .4),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(
                                    alpha: .10,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: customText(
                                  text: 'مناسب لك',
                                  fontSize: ResponsiveSize.width(
                                    context,
                                    AppSizes.fontXs,
                                  ),
                                  color: AppColors.success,
                                  isBold: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveSize.height(context, 1)),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveSize.height(context, .9),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _BenefitItem(
                                    icon: data.benefit1Icon,
                                    title: data.benefit1Title,
                                    subtitle: data.benefit1Subtitle,
                                  ),
                                ),
                                const _VerticalDivider(),
                                Expanded(
                                  child: _BenefitItem(
                                    icon: data.benefit2Icon,
                                    title: data.benefit2Title,
                                    subtitle: data.benefit2Subtitle,
                                  ),
                                ),
                                const _VerticalDivider(),
                                Expanded(
                                  child: _BenefitItem(
                                    icon: data.benefit3Icon,
                                    title: data.benefit3Title,
                                    subtitle: data.benefit3Subtitle,
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
            ),
            SizedBox(height: ResponsiveSize.height(context, 1)),
          ],
        ),
      ),
    );
  }
}

class _TopFeatureBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TopFeatureBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2.5),
        vertical: ResponsiveSize.height(context, .7),
      ),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: .10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: ResponsiveSize.width(context, 4),
          ),
          SizedBox(width: ResponsiveSize.width(context, 1.3)),
          customText(
            text: text,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.textSecondary,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 1),
      ),
      child: Column(
        children: [
          Container(
            width: ResponsiveSize.width(context, 7.5),
            height: ResponsiveSize.width(context, 7.5),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              icon,
              color: AppColors.secondary,
              size: ResponsiveSize.width(context, 3.8),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, .4)),
          customText(
            text: title,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.primary,
            isBold: true,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          customText(
            text: subtitle,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.textMuted,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSize.width(context, .25),
      height: ResponsiveSize.height(context, 5),
      color: AppColors.border.withValues(alpha: .10),
    );
  }
}
