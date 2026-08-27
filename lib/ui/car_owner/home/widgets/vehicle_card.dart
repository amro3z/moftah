import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card/vehicle_card.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/car_owner/home/helper/vehicle_status_ui.dart';
import 'package:moftah/utils/vehicle_brand_logo.dart';
import 'package:moftah/ui/car_owner/home/widgets/vehicle_card_header.dart';
import 'package:moftah/ui/car_owner/home/widgets/vehicle_card_info.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleCard extends StatelessWidget {
  final VehicleCardModel data;
  final VoidCallback? onTap;
  final VoidCallback? onSwitchTap;

  const VehicleCard({
    super.key,
    required this.data,
    this.onTap,
    this.onSwitchTap,
  });

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

                if (onSwitchTap != null) ...[
                  SizedBox(height: ResponsiveSize.height(context, .8)),
                  InkWell(
                    onTap: onSwitchTap,
                    borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(context, 2.2),
                        vertical: ResponsiveSize.height(context, .45),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .06),
                        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted, size: ResponsiveSize.width(context, 5.13)),
                          SizedBox(width: ResponsiveSize.width(context, .6)),
                          Text(
                            'تغيير السيارة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                SizedBox(height: ResponsiveSize.height(context, 1.1)),

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
