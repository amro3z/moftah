import 'package:flutter/material.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/data/models/user_vehicle_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/vehicle_brand_logo.dart';

Future<String?> showSparePartsVehicleSheet({
  required BuildContext context,
  required List<UserVehicleModel> vehicles,
  required String selectedVehicleId,
}) {
  String tempSelectedId = selectedVehicleId;
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.primary.withValues(alpha: .65),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.width(context, 4.62),
                ResponsiveSize.height(context, 1.18),
                ResponsiveSize.width(context, 4.62),
                ResponsiveSize.height(context, 3.08) +
                    MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: ResponsiveSize.width(context, 10.77),
                    height: ResponsiveSize.height(context, 0.47),
                    decoration: BoxDecoration(
                      color: AppColors.textMuted.withValues(alpha: .45),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 2.37)),
                  Row(
                    children: [
                      Icon(
                        Icons.directions_car_filled_rounded,
                        color: AppColors.secondary,
                      ),
                      SizedBox(width: ResponsiveSize.width(context, 2.31)),
                      customText(
                        text: 'اختار العربية',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXxl,
                        ),
                        isBold: true,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 0.71)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: customText(
                      text: 'العربيات المسجلة على حسابك',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 1.9)),
                  ...vehicles.map((vehicle) {
                    final selected = tempSelectedId == vehicle.id;
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: ResponsiveSize.height(context, 1.18),
                      ),
                      child: InkWell(
                        onTap: () =>
                            setSheetState(() => tempSelectedId = vehicle.id),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: EdgeInsets.all(
                            ResponsiveSize.width(context, 3.08),
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.secondary.withValues(alpha: .08)
                                : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                            border: Border.all(
                              color: selected
                                  ? AppColors.secondary
                                  : AppColors.border.withValues(alpha: .14),
                            ),
                          ),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                width: ResponsiveSize.width(context, 5.64),
                                height: ResponsiveSize.height(context, 2.61),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selected
                                      ? AppColors.secondary
                                      : Colors.white,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.secondary
                                        : AppColors.textMuted.withValues(
                                            alpha: .4,
                                          ),
                                  ),
                                ),
                                child: selected
                                    ? Icon(
                                        Icons.check_rounded,
                                        size: ResponsiveSize.width(
                                          context,
                                          3.85,
                                        ),
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              SizedBox(
                                width: ResponsiveSize.width(context, 3.08),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      text: vehicle.displayName,
                                      fontSize: ResponsiveSize.width(
                                        context,
                                        AppSizes.fontMd,
                                      ),
                                      isBold: true,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(
                                      height: ResponsiveSize.height(
                                        context,
                                        0.24,
                                      ),
                                    ),
                                    customText(
                                      text:
                                          '${vehicle.brand} • موديل ${vehicle.year}',
                                      fontSize: ResponsiveSize.width(
                                        context,
                                        AppSizes.fontXs,
                                      ),
                                      color: AppColors.textMuted,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveSize.width(context, 2.56),
                              ),
                              VehicleBrandLogo(
                                brand: vehicle.brand,
                                logoUrl: vehicle.imageUrl,
                                sizePercent: 12,
                                showContainer: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: ResponsiveSize.height(context, 0.95)),
                  FilledButton(
                    onPressed: vehicles.isEmpty
                        ? null
                        : () => Navigator.pop(sheetContext, tempSelectedId),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                    ),
                    child: customText(
                      text: 'تأكيد الاختيار',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                      isBold: true,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
