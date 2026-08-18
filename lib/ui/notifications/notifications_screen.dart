import 'package:flutter/material.dart';
import 'package:moftah/data/store/service_request_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ServiceRequestStore.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.primary,
          ),
          title: customText(
            text: 'الإشعارات',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
            color: AppColors.primary,
            isBold: true,
          ),
        ),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            final offersCount = store.offers.length;
            final hasOffersNotification =
                offersCount > 0 && store.acceptedOffer == null;

            return ListView(
              padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
              children: [
                if (hasOffersNotification)
                  _NotificationCard(
                    icon: Icons.local_offer_rounded,
                    title: 'عندك $offersCount عروض جديدة',
                    message:
                        'وصلتك عروض على طلب الصيانة. قارن السعر والتقييم والمدة قبل ما تختار.',
                    actionText: 'الذهاب إلى العروض',
                    onAction: () => Navigator.pushNamed(
                      context,
                      '/received-offers',
                    ),
                  ),
                if (!hasOffersNotification)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(context, 5),
                      vertical: ResponsiveSize.height(context, 5),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .10),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: ResponsiveSize.width(context, 14),
                          height: ResponsiveSize.width(context, 14),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: .08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.secondary,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.height(context, 1.2)),
                        customText(
                          text: 'مفيش إشعارات جديدة حاليًا',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                      ],
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

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionText;
  final VoidCallback onAction;

  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.border.withValues(alpha: .12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .13),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: ResponsiveSize.width(context, 11),
                height: ResponsiveSize.width(context, 11),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(icon, color: AppColors.secondary),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: title,
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontMd,
                      ),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, .45)),
                    customText(
                      text: message,
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontSm,
                      ),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.3)),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(
                actionText,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
