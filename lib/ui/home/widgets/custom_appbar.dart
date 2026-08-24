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
  VoidCallback? onVehicleSwitchTap,
  int notificationCount = 0,
  VoidCallback? onNotificationTap,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveSize.height(context, 47)),
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
                      onTap: onNotificationTap ?? onChatTap,
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
                              Icons.notifications_none_rounded,
                              color: AppColors.textSecondary,
                              size: ResponsiveSize.width(context, 5),
                            ),

                            if (notificationCount > 0)
                              Positioned(
                                top: ResponsiveSize.width(context, .7),
                                right: ResponsiveSize.width(context, .7),
                                child: Container(
                                  constraints: BoxConstraints(
                                    minWidth: ResponsiveSize.width(context, 5),
                                    minHeight: ResponsiveSize.width(context, 5),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.width(context, 1.1),
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.danger,
                                    borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                                    border: Border.all(color: AppColors.primary, width: ResponsiveSize.width(context, 0.38)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: .22),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: customText(
                                    text: notificationCount > 99 ? '99+' : '$notificationCount',
                                    fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                                    color: Colors.white,
                                    isBold: true,
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
                data: data,
                onTap: onVehicleTap,
                onSwitchTap: onVehicleSwitchTap,
              ),
              SizedBox(height: ResponsiveSize.height(context, 1)),
            ],
          ),
        ),
      ),
    ),
  );
}
