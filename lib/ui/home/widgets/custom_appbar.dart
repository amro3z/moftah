import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/widgets/vehicle_card.dart';
import 'package:moftah/utils/responsive.dart';

PreferredSizeWidget customAppBar(
  BuildContext context, {
  required String userName,
  required String carName,
  required int year,
  required String mileage,
  required int healthScore,
  required String maintenanceStatus,
  required String documentStatus,
  required String imageUrl,
  required String nextMaintenance,
  required String lastMaintenance,
  required String repairStatus,
  VoidCallback? onChatTap,
  VoidCallback? onVehicleTap,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(ResponsiveSize.height(context, 45)),
    child: AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSizes.radiusLg),
        ),
      ),

      backgroundColor: const Color(0xff0D2136),

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
                          color: const Color(0xffB8C7D9),
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
                              color: Colors.white,
                              isBold: true,
                            ),

                            SizedBox(width: ResponsiveSize.width(context, 1)),

                            customText(
                              text: '👋',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXl,
                              ),
                              color: Colors.white,
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
                          color: const Color(0xff1B3046),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                          border: Border.all(color: const Color(0xff617486)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Colors.white,
                              size: ResponsiveSize.width(context, 5),
                            ),

                            Positioned(
                              top: ResponsiveSize.width(context, 1.5),
                              right: ResponsiveSize.width(context, 1.8),
                              child: Container(
                                width: ResponsiveSize.width(context, 1.8),
                                height: ResponsiveSize.width(context, 1.8),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
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
                carName: carName,
                year: year,
                mileage: mileage,
                healthScore: healthScore,
                maintenanceStatus: maintenanceStatus,
                documentStatus: documentStatus,
                imageUrl: imageUrl,
                nextMaintenance: nextMaintenance,
                lastMaintenance: lastMaintenance,
                repairStatus: repairStatus,
                onTap: onVehicleTap,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
