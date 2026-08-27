import 'package:flutter/material.dart';
import 'package:moftah/data/models/update/app_vehicle_model.dart';
import 'package:moftah/data/models/vehicle_card/vehicle_card.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/home/widgets/vehicle_card.dart';
import 'package:moftah/utils/responsive.dart';

PreferredSizeWidget customAppBar(
  BuildContext context, {
  required VehicleCardModel data,
  required String userName,
  VoidCallback? onChatTap,
  VoidCallback? onVehicleTap,
  VoidCallback? onVehicleSwitchTap,
  required AppVehicleModel selectedVehicle,
  int notificationCount = 0,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveSize.height(context, 47)),

    child: AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
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

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _HeaderActionButton(
                          icon: Icons.person_outline_rounded,
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                        ),
                        SizedBox(width: ResponsiveSize.width(context, 2)),
                        _HeaderActionButton(
                          icon: Icons.notifications_none_rounded,
                          onTap: () =>
                              Navigator.pushNamed(context, '/notifications'),
                          badgeCount: notificationCount,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveSize.height(context, 2)),

              VehicleCard(
                data: data,
                onTap: (){
                   Navigator.pushNamed(
                      context,
                      '/vehicle-health',
                      arguments: selectedVehicle.health,
                    );
                },
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

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final int badgeCount;

  const _HeaderActionButton({
    required this.icon,
    this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Container(
        width: ResponsiveSize.width(context, 10),
        height: ResponsiveSize.width(context, 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: ResponsiveSize.width(context, 5),
            ),
            if (badgeCount > 0)
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
                    border: Border.all(
                      color: AppColors.primary,
                      width: ResponsiveSize.width(context, .38),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: customText(
                    text: badgeCount > 99 ? '99+' : '$badgeCount',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                    color: Colors.white,
                    isBold: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
