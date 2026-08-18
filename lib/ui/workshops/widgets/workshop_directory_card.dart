import 'package:flutter/material.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/helper/nerbay_places_stars.dart';
import 'package:moftah/utils/opening_hours_helper.dart';
import 'package:moftah/utils/responsive.dart';

class WorkshopDirectoryCard extends StatelessWidget {
  final HomeNearbyPlacesModel place;
  final List<HomeNearbyPlacesModel> allPlaces;

  const WorkshopDirectoryCard({
    super.key,
    required this.place,
    required this.allPlaces,
  });

  @override
  Widget build(BuildContext context) {
    final liveStatus =
        OpeningHoursHelper.isOpenNow(place.openingHours) ?? place.isOpen;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/map',
          arguments: MapRouteArguments(
            selectedPlace: place,
            nearbyPlaces: allPlaces.take(10).toList(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: ResponsiveSize.width(context, 13),
                  height: ResponsiveSize.width(context, 13),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(
                    Icons.car_repair_rounded,
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
                        text: place.name,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontLg,
                        ),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 0.35)),
                      customText(
                        text: place.supportedVehicles,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: AppColors.progressBackground,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                _statusChip(context, liveStatus),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.2)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 3),
                vertical: ResponsiveSize.height(context, 0.8),
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: AppColors.textMuted,
                    size: ResponsiveSize.width(context, 4),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 1.5)),
                  Expanded(
                    child: customText(
                      text: OpeningHoursHelper.displayText(place.openingHours),
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.progressBackground,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.2)),
            Row(
              children: [
                if (place.reviewsCount > 0) ...[
                  ratingStars(context: context, numberOfStars: place.rating),
                  SizedBox(width: ResponsiveSize.width(context, 1)),
                  customText(
                    text:
                        '${place.rating.toStringAsFixed(1)} (${place.reviewsCount})',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.primary,
                    isBold: true,
                  ),
                ] else
                  customText(
                    text: 'بدون تقييم',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.textMuted,
                  ),
                const Spacer(),
                Icon(
                  Icons.location_on_rounded,
                  color: AppColors.warning,
                  size: ResponsiveSize.width(context, 4.2),
                ),
                SizedBox(width: ResponsiveSize.width(context, 0.6)),
                customText(
                  text: '${place.distance.toStringAsFixed(1)} كم',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.secondary,
                  isBold: true,
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Container(
                  width: ResponsiveSize.width(context, 8),
                  height: ResponsiveSize.width(context, 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context, bool? isOpen) {
    final text = isOpen == true
        ? 'مفتوح الآن'
        : isOpen == false
        ? 'مغلق الآن'
        : 'غير مؤكد';

    final color = isOpen == true
        ? AppColors.success
        : isOpen == false
        ? AppColors.danger
        : AppColors.textMuted;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, 0.45),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: customText(
        text: text,
        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
        color: color,
        isBold: true,
      ),
    );
  }
}
