import 'package:flutter/material.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/helper/nerbay_places_stars.dart';
import 'package:moftah/utils/responsive.dart';

class HomeNearbyPlacesListItem extends StatelessWidget {
  final HomeNearbyPlacesModel item;
  const HomeNearbyPlacesListItem({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ResponsiveSize.width(context, 2)),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, item.path , arguments: item);
        },
        child: Container(
          constraints: BoxConstraints(
            minWidth: ResponsiveSize.width(context, 45),
            maxWidth: ResponsiveSize.width(context, 60),
            maxHeight: ResponsiveSize.height(context, 45),
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
              /// Rating on left - Status on right
              Row(
                textDirection: TextDirection.ltr,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: ResponsiveSize.width(context, 1)),
        
                      ratingStars(context: context, numberOfStars: item.rating),
                      SizedBox(width: ResponsiveSize.width(context, 1)),
                      customText(
                        text: item.rating.toString(),
                        fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
        
                  const Spacer(),
        
                  customText(
                    text: item.isOpen ? 'مفتوح' : 'مغلق',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: item.isOpen ? AppColors.success : AppColors.danger,
                    isBold: true,
                  ),
                ],
              ),
        
              SizedBox(height: ResponsiveSize.height(context, 1)),
        
              /// Center name
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
        
              /// Supported vehicles
              Align(
                alignment: Alignment.centerRight,
                child: customText(
                  text: item.supportedVehicles,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.progressBackground,
                ),
              ),
        
              SizedBox(height: ResponsiveSize.height(context, 0.8)),
        
              /// Distance
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
                    text: '${item.distance.toString()} كم',
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
}
