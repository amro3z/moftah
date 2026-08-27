import 'package:flutter/material.dart';
import 'package:moftah/data/store/vehicle_selection_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ReportReviewStep extends StatelessWidget {
  final int vehicleIndex;
  final Set<String> selectedProblems;
  final int attachmentsCount;
  final bool hasLocation;

  const ReportReviewStep({
    super.key,
    required this.vehicleIndex,
    required this.selectedProblems,
    required this.attachmentsCount,
    required this.hasLocation,
  });

  @override
  Widget build(BuildContext context) {
    final vehicle = VehicleSelectionStore.instance.vehicles[vehicleIndex];
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 2),
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            text: 'راجع البيانات قبل التحليل',
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            color: AppColors.primary,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.3)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _row(
                  context,
                  'السيارة',
                  '${vehicle.card.carName} ${vehicle.card.year}',
                ),
                _row(
                  context,
                  'المشكلة',
                  selectedProblems.isEmpty
                      ? 'وصف يدوي'
                      : selectedProblems.join('، '),
                ),
                _row(
                  context,
                  'الموقع',
                  hasLocation ? 'تم تحديد موقع السيارة' : 'لم يتم تحديده',
                ),
                _row(context, 'المرفقات', '$attachmentsCount مرفق'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.height(context, .8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveSize.width(context, 22),
            child: customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.textMuted,
            ),
          ),
          Expanded(
            child: customText(
              text: value,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.primary,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }
}
