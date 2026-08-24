import 'package:flutter/material.dart';
import 'package:moftah/data/store/profile_history_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/profile/widgets/profile_section_tile.dart';
import 'package:moftah/utils/responsive.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ProfileHistoryStore.instance;
    final profile = store.profile;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: ResponsiveSize.width(context, 5),
                ),
              ),
              Expanded(
                child: customText(
                  text: 'الملف الشخصي',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            return ListView(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.width(context, 4),
                ResponsiveSize.height(context, 2),
                ResponsiveSize.width(context, 4),
                ResponsiveSize.height(context, 3),
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .16),
                        blurRadius: 14,
                        spreadRadius: 0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: .10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: ResponsiveSize.width(context, 20),
                        height: ResponsiveSize.width(context, 20),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: .10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.secondary,
                          size: ResponsiveSize.width(context, 10),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1)),
                      customText(
                        text: profile.name,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXxl,
                        ),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      customText(
                        text: profile.phone,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: AppColors.textMuted,
                      ),
                      customText(
                        text: profile.email,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: AppColors.textMuted,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ProfileChip(
                            icon: Icons.location_on_outlined,
                            text: profile.city,
                          ),
                          SizedBox(width: ResponsiveSize.width(context, 2)),
                          _ProfileChip(
                            icon: Icons.calendar_month_outlined,
                            text: profile.memberSince,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1.5)),
                ProfileSectionTile(
                  icon: Icons.inventory_2_outlined,
                  title: 'سجل طلبات قطع الغيار',
                  subtitle: '${store.sparePartOrders.length} طلب',
                  onTap: () =>
                      Navigator.pushNamed(context, '/profile/spare-orders'),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                ProfileSectionTile(
                  icon: Icons.engineering_outlined,
                  title: 'طلبات الفنيين والعمال',
                  subtitle: '${store.workerRequests.length} طلب',
                  onTap: () =>
                      Navigator.pushNamed(context, '/profile/worker-requests'),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                ProfileSectionTile(
                  icon: Icons.forum_outlined,
                  title: 'سجل المحادثات',
                  subtitle: '${store.conversations.length} محادثة',
                  onTap: () => Navigator.pushNamed(context, '/profile/chats'),
                ),
                SizedBox(height: ResponsiveSize.height(context, 2)),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: BorderSide(color: AppColors.danger),
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveSize.height(context, 1.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  icon: Icon(
                    Icons.logout_rounded,
                    size: ResponsiveSize.width(context, 5),
                  ),
                  label: customText(
                    text: 'تسجيل الخروج',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: AppColors.danger,
                    isBold: true,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2.4),
        vertical: ResponsiveSize.height(context, .6),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.secondary,
            size: ResponsiveSize.width(context, 4),
          ),
          SizedBox(width: ResponsiveSize.width(context, 1)),
          customText(
            text: text,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.primary,
            isBold: true,
          ),
        ],
      ),
    );
  }
}
