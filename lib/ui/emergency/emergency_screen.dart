import 'package:flutter/material.dart';
import 'package:moftah/data/models/chat_screen_model.dart';
import 'package:moftah/data/models/emergency_tow_provider_model.dart';
import 'package:moftah/ui/core/constant/emergency_cars.dart';
import 'package:moftah/ui/core/helper/rating_stars.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/phone_launcher.dart';
import 'package:moftah/utils/responsive.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
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
                  text: 'طوارئ - خدمات الونش',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
              Icon(
                Icons.local_shipping_rounded,
                color: Colors.white,
                size: ResponsiveSize.width(context, 6),
              ),
            ],
          ),
        ),
        body: ListView(
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
                color: AppColors.secondary.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Row(
                children: [
                  Container(
                    width: ResponsiveSize.width(context, 11),
                    height: ResponsiveSize.width(context, 11),
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
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.secondary,
                      size: ResponsiveSize.width(context, 5.5),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 3)),
                  Expanded(
                    child: customText(
                      text:
                          'اختار مقدم خدمة الونش المناسب حسب المحافظة والتغطية والسعر، واضغط على الكارد لفتح المحادثة.',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.8)),
            ...providers.map(
              (provider) => Padding(
                padding: EdgeInsets.only(
                  bottom: ResponsiveSize.height(context, 1.2),
                ),
                child: _TowProviderCard(provider: provider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TowProviderCard extends StatelessWidget {
  final EmergencyTowProviderModel provider;

  const _TowProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        onTap: () => Navigator.pushNamed(
          context,
          '/chat',
          arguments: ChatScreenModel.fromEmergencyTow(provider),
        ),
        child: Container(
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
            border: Border.all(color: AppColors.border.withValues(alpha: .10)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: ResponsiveSize.width(context, 13),
                    height: ResponsiveSize.width(context, 13),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      Icons.local_shipping_rounded,
                      color: AppColors.secondary,
                      size: ResponsiveSize.width(context, 6.5),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text: provider.driverName,
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontLg,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                        SizedBox(height: ResponsiveSize.height(context, .35)),
                        Row(
                          children: [
                            ratingStars(
                              context: context,
                              numberOfStars: provider.rating,
                            ),
                            SizedBox(width: ResponsiveSize.width(context, 1)),
                            customText(
                              text: provider.rating.toStringAsFixed(1),
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXs,
                              ),
                              color: AppColors.textMuted,
                              isBold: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(context, 2),
                      vertical: ResponsiveSize.height(context, .45),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    ),
                    child: customText(
                      text: provider.isAvailable ? 'متاح' : 'غير متاح',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: provider.isAvailable
                          ? AppColors.success
                          : AppColors.danger,
                      isBold: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.3)),
              _InfoRow(
                icon: Icons.phone_rounded,
                label: 'رقم الهاتف',
                value: provider.phone,
              ),
              _InfoRow(
                icon: Icons.location_city_rounded,
                label: 'المحافظة',
                value: provider.governorate,
              ),
              _InfoRow(
                icon: Icons.map_outlined,
                label: 'حدود الخدمة',
                value: provider.coverageArea,
              ),
              _InfoRow(
                icon: Icons.payments_outlined,
                label: 'السعر يبدأ من',
                value: '${provider.startingPrice.toStringAsFixed(0)} جنيه',
              ),
              _InfoRow(
                icon: Icons.route_rounded,
                label: 'أقصى مسافة توصيل',
                value: provider.maxDestination,
              ),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/chat',
                        arguments: ChatScreenModel.fromEmergencyTow(provider),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                      ),
                      icon: Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: ResponsiveSize.width(context, 4.5),
                      ),
                      label: customText(
                        text: 'محادثة',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 2)),
                  OutlinedButton(
                    onPressed: () => PhoneLauncher.call(provider.phone),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.success,
                      side: BorderSide(color: AppColors.success),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    child: Icon(
                      Icons.call_rounded,
                      size: ResponsiveSize.width(context, 5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, .75)),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.secondary,
            size: ResponsiveSize.width(context, 4.5),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          customText(
            text: label,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.textMuted,
          ),
          const Spacer(),
          Flexible(
            child: customText(
              text: value,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.primary,
              isBold: true,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
