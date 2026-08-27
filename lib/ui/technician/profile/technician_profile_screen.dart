import 'package:flutter/material.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/home/technician_home.dart';
import 'package:moftah/ui/technician/widgets/technician_nav_bar.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianProfileScreen extends StatelessWidget {
  const TechnicianProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = TechnicianStore.instance.profile;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.background,
          title: customText(
            text: 'حسابي',
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            color: AppColors.primary,
            isBold: true,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            ResponsiveSize.width(context, 4),
            ResponsiveSize.height(context, 1),
            ResponsiveSize.width(context, 4),
            ResponsiveSize.height(context, 12),
          ),
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .18),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: ResponsiveSize.width(context, 22),
                    height: ResponsiveSize.width(context, 22),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .14),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.engineering_rounded,
                      size: ResponsiveSize.width(context, 11),
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 1.2)),
                  customText(
                    text: profile.name,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                    color: AppColors.textSecondary,
                    isBold: true,
                  ),
                  SizedBox(height: ResponsiveSize.height(context, .35)),
                  customText(
                    text: profile.specialties.join(' • '),
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.textSecondary.withValues(alpha: .72),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 1.5)),
                  Row(
                    children: [
                      Expanded(
                        child: _ProfileStat(
                          value: profile.rating.toString(),
                          label: 'التقييم',
                          icon: Icons.star_rounded,
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.width(context, 2)),
                      Expanded(
                        child: _ProfileStat(
                          value: '${profile.completedJobs}',
                          label: 'عمل مكتمل',
                          icon: Icons.task_alt_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 2)),
            customText(
              text: 'بيانات الحساب',
              fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
              color: AppColors.primary,
              isBold: true,
            ),
            SizedBox(height: ResponsiveSize.height(context, 1)),
            _ProfileTile(
              icon: Icons.location_on_outlined,
              title: 'المحافظة',
              value: profile.governorate,
            ),
            _ProfileTile(
              icon: Icons.build_outlined,
              title: 'التخصص',
              value: profile.specialties.join('، '),
            ),
            _ProfileTile(
              icon: Icons.phone_outlined,
              title: 'رقم الهاتف',
              value: profile.phone,
            ),
            _ProfileTile(
              icon: Icons.email_outlined,
              title: 'البريد الإلكتروني',
              value: profile.email,
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.5)),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: const BorderSide(color: AppColors.danger),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.height(context, 1.6),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: customText(
                text: 'تسجيل الخروج',
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                color: AppColors.danger,
                isBold: true,
              ),
            ),
          ],
        ),
        bottomNavigationBar: const TechnicianBottomNav(current: 4),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _ProfileStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.height(context, 1.2),
      ),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: .10),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.warning,
            size: ResponsiveSize.width(context, 5),
          ),
          customText(
            text: value,
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            color: AppColors.textSecondary,
            isBold: true,
          ),
          customText(
            text: label,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.textSecondary.withValues(alpha: .65),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.height(context, 1)),
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .05),
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
              color: AppColors.secondary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              icon,
              color: AppColors.secondary,
              size: ResponsiveSize.width(context, 5),
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: title,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: AppColors.textMuted,
                ),
                customText(
                  text: value,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.primary,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
