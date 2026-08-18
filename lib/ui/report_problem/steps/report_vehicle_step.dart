import 'package:flutter/material.dart';
import 'package:moftah/data/store/vehicle_selection_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/utils/vehicle_brand_logo.dart';

class ReportVehicleStep extends StatelessWidget {
  final int selectedVehicleIndex;
  final ValueChanged<int> onSelected;

  const ReportVehicleStep({
    super.key,
    required this.selectedVehicleIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final vehicles = VehicleSelectionStore.instance.vehicles;
    return _body(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            text: 'اختر السيارة المتأثرة',
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            color: AppColors.primary,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.5)),
          ...List.generate(vehicles.length, (index) {
            final vehicle = vehicles[index];
            final selected = selectedVehicleIndex == index;
            return Padding(
              padding: EdgeInsets.only(
                bottom: ResponsiveSize.height(context, 1.2),
              ),
              child: InkWell(
                onTap: () => onSelected(index),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                      color: selected
                          ? AppColors.secondary
                          : AppColors.border.withValues(alpha: .14),
                      width: selected ? 1.7 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      VehicleBrandLogo(
                        brand: vehicle.card.brand,
                        logoUrl: vehicle.card.brandLogoUrl,
                        sizePercent: 13,
                      ),
                      SizedBox(width: ResponsiveSize.width(context, 3)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              text: vehicle.card.carName,
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontMd,
                              ),
                              color: AppColors.primary,
                              isBold: true,
                            ),
                            customText(
                              text: '${vehicle.card.year}',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontSm,
                              ),
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                      _selectionCircle(context, selected),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _selectionCircle(BuildContext context, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: ResponsiveSize.width(context, 7),
      height: ResponsiveSize.width(context, 7),
      decoration: BoxDecoration(
        color: selected ? AppColors.secondary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? AppColors.secondary
              : AppColors.border.withValues(alpha: .35),
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
          : null,
    );
  }

  Widget _body(BuildContext context, Widget child) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 2),
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 4),
      ),
      child: child,
    );
  }
}
