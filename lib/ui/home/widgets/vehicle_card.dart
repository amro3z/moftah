import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/home/helper/vehicle_status_ui.dart';
import 'package:moftah/ui/home/widgets/vehicle_card_header.dart';
import 'package:moftah/ui/home/widgets/vehicle_card_info.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleCard extends StatelessWidget {
  final VehicleCardModel data;
  final VoidCallback? onTap;

  const VehicleCard({super.key, required this.data, this.onTap});

  String _formattedMillage({required int number}) {
    if (number == 0) return '0';

    int counter = 0;
    String formattedNumber = '';
    String temp = '';

    while (number > 0) {
      counter++;

      temp = (number % 10).toString() + temp;

      number ~/= 10;

      if (counter % 3 == 0 && number > 0) {
        formattedNumber = ',$temp$formattedNumber';
        temp = '';
      }
    }

    return temp + formattedNumber;
  }

  @override
  Widget build(BuildContext context) {
    final repairUi = VehicleStatusUi.repair(data.repairStatus);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Container(
          width: ResponsiveSize.width(context, 85),
          height: ResponsiveSize.height(context, 32),
          padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              VehicleCardHeader(
                data: data,
                formattedMileage: _formattedMillage(number: data.mileage),
              ),

              SizedBox(height: ResponsiveSize.height(context, 1)),

              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: Image.network(
                  data.imageUrl,
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
                      height: ResponsiveSize.height(context, 11),
                      color: AppColors.surfaceMedium,
                      child: const Center(
                        child: Icon(
                          Icons.directions_car_rounded,
                          color: AppColors.textMuted,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: ResponsiveSize.height(context, 1)),

              VehicleCardInfo(
                nextMaintenance:
                    '${_formattedMillage(number: data.nextMaintenance)} كم',
                lastMaintenance: data.lastMaintenance,
                repairText: repairUi.text,
                repairColor: repairUi.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
