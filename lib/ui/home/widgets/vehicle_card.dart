import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/home/helper/vehicle_status_ui.dart';
import 'package:moftah/utils/vehicle_brand_logo.dart';
import 'package:moftah/ui/home/widgets/vehicle_card_header.dart';
import 'package:moftah/ui/home/widgets/vehicle_card_info.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleCard extends StatelessWidget {
  final VehicleCardModel data;
  final VoidCallback? onTap;

  const VehicleCard({super.key, required this.data, this.onTap});

  String _formatNumber(int number) {
    final value = number.toString();

    return value.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  }

  @override
  Widget build(BuildContext context) {
    final repairUi = VehicleStatusUi.repair(data.repairStatus);

    final formattedMileage = _formatNumber(data.mileage);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Ink(
            width: ResponsiveSize.width(context, 90),
            padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: Colors.white.withValues(alpha: .08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .16),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    VehicleBrandLogo(
                      brand: data.brand,
                      logoUrl: data.brandLogoUrl,
                      sizePercent: 15,
                    ),

                    SizedBox(width: ResponsiveSize.width(context, 3)),

                    Expanded(
                      child: VehicleCardHeader(
                        data: data,
                        formattedMileage: formattedMileage,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveSize.height(context, 1.4)),

                VehicleCardInfo(
                  nextMaintenance: '${_formatNumber(data.nextMaintenance)} كم',
                  lastMaintenance: data.lastMaintenance,
                  repairText: repairUi.text,
                  repairColor: repairUi.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
