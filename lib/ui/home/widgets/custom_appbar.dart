import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/widgets/vehicle_card.dart';
import 'package:moftah/utils/responsive.dart';

PreferredSizeWidget customAppBar(
  BuildContext context, {
  required VehicleCardModel data,
  required String userName,
  VoidCallback? onChatTap,
  VoidCallback? onVehicleTap,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveSize.height(context, 45)),
    child: AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: AppColors.primary,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.radiusLg),
        ),
      ),

      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 5),
          ),
          child: Column(
            children: [
              SizedBox(height: ResponsiveSize.height(context, 1)),

              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text: 'مرحباً،',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontXxl,
                          ),
                          color: AppColors.textSecondary,
                        ),

                        SizedBox(height: ResponsiveSize.height(context, 0.3)),

                        Row(
                          children: [
                            customText(
                              text: userName,
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXxxl,
                              ),
                              color: AppColors.textSecondary,
                              isBold: true,
                            ),

                            SizedBox(width: ResponsiveSize.width(context, 1)),

                            customText(
                              text: '👋',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXl,
                              ),
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: onChatTap,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      child: Container(
                        width: ResponsiveSize.width(context, 10),
                        height: ResponsiveSize.width(context, 10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: AppColors.textSecondary,
                              size: ResponsiveSize.width(context, 5),
                            ),

                            Positioned(
                              top: ResponsiveSize.width(context, 1.5),
                              right: ResponsiveSize.width(context, 1.8),
                              child: Container(
                                width: ResponsiveSize.width(context, 1.8),
                                height: ResponsiveSize.width(context, 1.8),
                                decoration: const BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveSize.height(context, 2)),

              VehicleCard(
               data: data ,
                onTap: onVehicleTap,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
