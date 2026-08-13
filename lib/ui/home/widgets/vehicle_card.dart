import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleCard extends StatelessWidget {
  final String carName;
  final int year;
  final String mileage;
  final int healthScore;

  final String maintenanceStatus;
  final String documentStatus;

  final String imageUrl;

  final String nextMaintenance;
  final String lastMaintenance;
  final String repairStatus;

  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.carName,
    required this.year,
    required this.mileage,
    required this.healthScore,
    required this.maintenanceStatus,
    required this.documentStatus,
    required this.imageUrl,
    required this.nextMaintenance,
    required this.lastMaintenance,
    required this.repairStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Container(
          width: ResponsiveSize.width(context, 85),
          height: ResponsiveSize.height(context, 32.5),
          padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
          decoration: BoxDecoration(
            color: const Color(0xff1E344B),
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: const Color(0xff3B5269)),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text: carName,
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontXl,
                          ),
                          color: Colors.white,
                          isBold: true,
                        ),

                        SizedBox(height: ResponsiveSize.height(context, 0.4)),

                        customText(
                          text: '$year • $mileage',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: const Color(0xffAAB8C6),
                        ),

                        SizedBox(height: ResponsiveSize.height(context, 1)),

                        Row(
                          children: [
                            _statusChip(
                              context,
                              text: maintenanceStatus,
                              backgroundColor: const Color(0xff0D584D),
                              textColor: const Color(0xff37D49A),
                            ),

                            SizedBox(width: ResponsiveSize.width(context, 2)),

                            _statusChip(
                              context,
                              text: documentStatus,
                              backgroundColor: const Color(0xff07516A),
                              textColor: const Color(0xff2AC4F5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  _healthScore(context),
                ],
              ),

              SizedBox(height: ResponsiveSize.height(context, 1.5)),

              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: ResponsiveSize.height(context, 11),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return SizedBox(
                      height: ResponsiveSize.height(context, 11),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: ResponsiveSize.height(context, 11),
                      decoration: BoxDecoration(
                        color: const Color(0xff263D54),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: const Icon(
                        Icons.directions_car_rounded,
                        color: Colors.white54,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: ResponsiveSize.height(context, 1.3)),

              Container(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.height(context, 1),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff263D54),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _infoItem(
                        context,
                        title: 'الصيانة القادمة',
                        value: nextMaintenance,
                        valueColor: const Color(0xffFF9F43),
                      ),
                    ),

                    _divider(context),

                    Expanded(
                      child: _infoItem(
                        context,
                        title: 'آخر صيانة',
                        value: lastMaintenance,
                        valueColor: Colors.white,
                      ),
                    ),

                    _divider(context),

                    Expanded(
                      child: _infoItem(
                        context,
                        title: 'الإصلاحات',
                        value: repairStatus,
                        valueColor: const Color(0xff38D68A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _healthScore(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: ResponsiveSize.width(context, 14),
          height: ResponsiveSize.width(context, 14),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                constraints: BoxConstraints(
                  minWidth: ResponsiveSize.width(context, 12),
                  minHeight: ResponsiveSize.width(context, 12),
                ),
                value: healthScore / 100,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                backgroundColor: const Color(0xff3A5065),
                valueColor: const AlwaysStoppedAnimation(Color(0xff00C78C)),
              ),

              customText(
                text: '$healthScore',
                fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                color: Colors.white,
                isBold: true,
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveSize.height(context, 0.4)),

        customText(
          text: 'صحة السيارة',
          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
          color: const Color(0xff88A6C3),
        ),
      ],
    );
  }

  Widget _statusChip(
    BuildContext context, {
    required String text,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, 0.35),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: customText(
        text: text,
        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
        color: textColor,
        isBold: true,
      ),
    );
  }

  Widget _infoItem(
    BuildContext context, {
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      children: [
        customText(
          text: title,
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: const Color(0xffA9B5C2),
        ),

        SizedBox(height: ResponsiveSize.height(context, 0.4)),

        customText(
          text: value,
          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
          color: valueColor,
          isBold: true,
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: 1,
      height: ResponsiveSize.height(context, 4),
      color: const Color(0xff496178),
    );
  }
}
