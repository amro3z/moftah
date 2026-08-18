import 'package:flutter/material.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/helper/nerbay_places_stars.dart';
import 'package:moftah/utils/opening_hours_helper.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/workshop_phone_button.dart';
import 'package:moftah/utils/responsive.dart';

class HomeNearbyPlacesListItem extends StatelessWidget {
  final HomeNearbyPlacesModel item;
  final List<HomeNearbyPlacesModel> nearbyPlaces;

  const HomeNearbyPlacesListItem({
    super.key,
    required this.item,
    required this.nearbyPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ResponsiveSize.width(context, 2)),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            item.path,
            arguments: MapRouteArguments(
              selectedPlace: item,
              nearbyPlaces: nearbyPlaces,
            ),
          );
        },
        child: Container(
          constraints: BoxConstraints(
            minWidth: ResponsiveSize.width(context, 48),
            maxWidth: ResponsiveSize.width(context, 60),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 4),
            vertical: ResponsiveSize.height(context, 1.5),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 7,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                textDirection: TextDirection.ltr,
                children: [
                  if (item.reviewsCount > 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ratingStars(
                          context: context,
                          numberOfStars: item.rating,
                        ),
                        SizedBox(width: ResponsiveSize.width(context, 1)),
                        customText(
                          text: item.rating.toStringAsFixed(1),
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: AppColors.textPrimary,
                        ),
                      ],
                    )
                  else
                    customText(
                      text: 'بدون تقييم',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: AppColors.progressBackground,
                    ),
                  const Spacer(),
                  customText(
                    text: _openStatusText,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: _openStatusColor,
                    isBold: true,
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              Align(
                alignment: Alignment.centerRight,
                child: customText(
                  text: item.name,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                  color: AppColors.primary,
                  isBold: true,
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 0.5)),
              Align(
                alignment: Alignment.centerRight,
                child: customText(
                  text: item.supportedVehicles,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.progressBackground,
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 0.5)),
              Align(
                alignment: Alignment.centerRight,
                child: customText(
                  text: OpeningHoursHelper.displayText(item.openingHours),
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: AppColors.textMuted,
                ),
              ),
              if (item.phones.isNotEmpty) ...[
                SizedBox(height: ResponsiveSize.height(context, 0.7)),
                WorkshopPhoneButton(phones: item.phones),
              ],
              SizedBox(height: ResponsiveSize.height(context, 0.8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: AppColors.warning,
                    size: ResponsiveSize.width(context, 3.5),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 1)),
                  customText(
                    text: '${item.distance.toStringAsFixed(1)} كم',
                    color: AppColors.secondary,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool? get _liveOpenStatus =>
      OpeningHoursHelper.isOpenNow(item.openingHours) ?? item.isOpen;

  String get _openStatusText {
    if (_liveOpenStatus == true) return 'مفتوح الآن';
    if (_liveOpenStatus == false) return 'مغلق الآن';
    return 'المواعيد غير مؤكدة';
  }

  Color get _openStatusColor {
    if (_liveOpenStatus == true) return AppColors.success;
    if (_liveOpenStatus == false) return AppColors.danger;
    return AppColors.progressBackground;
  }
}
