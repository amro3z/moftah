import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/technician_models.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianRequestCard extends StatelessWidget {
  final TechnicianRequestModel request;
  final VoidCallback? onDetails, onOffer, onReject;
  const TechnicianRequestCard({super.key, required this.request, this.onDetails, this.onOffer, this.onReject});

  @override
  Widget build(BuildContext context) {
    final risk = _riskStyle(request.riskLabel);
    return GestureDetector(
      onTap: onDetails,
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveSize.height(context, 1.35)),
        padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: risk.color.withValues(alpha: .16)),
          boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .08), blurRadius: 22, offset: const Offset(0, 8))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: ResponsiveSize.width(context, 12), height: ResponsiveSize.width(context, 12), decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: .09), borderRadius: BorderRadius.circular(AppSizes.radiusMd)), child: const Icon(Icons.directions_car_filled_rounded, color: AppColors.secondary)),
            SizedBox(width: ResponsiveSize.width(context, 2.5)),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              customText(text: '${request.vehicleName} ${request.vehicleYear}', fontSize: ResponsiveSize.width(context, AppSizes.fontMd), color: AppColors.primary, isBold: true),
              SizedBox(height: ResponsiveSize.height(context, .25)),
              customText(text: request.issueTitle, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.textMuted, maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
            _Risk(text: request.riskLabel, color: risk.color, icon: risk.icon),
          ]),
          SizedBox(height: ResponsiveSize.height(context, 1.1)),
          Container(padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 2.5), vertical: ResponsiveSize.height(context, .75)), decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(AppSizes.radiusSm)), child: Row(children: [
            const Icon(Icons.person_outline_rounded, color: AppColors.textMuted, size: 17), SizedBox(width: ResponsiveSize.width(context, 1)), Expanded(child: customText(text: request.customerName, fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: AppColors.primary, isBold: true)),
            const Icon(Icons.location_on_outlined, color: AppColors.secondary, size: 17), customText(text: '${request.distanceKm} كم', fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: AppColors.secondary, isBold: true),
            SizedBox(width: ResponsiveSize.width(context, 2)), const Icon(Icons.schedule_rounded, color: AppColors.textMuted, size: 16), customText(text: request.createdAt, fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: AppColors.textMuted),
          ])),
          if (onOffer != null || onReject != null) ...[
            SizedBox(height: ResponsiveSize.height(context, 1.15)),
            Row(children: [
              if (onOffer != null) Expanded(flex: 2, child: FilledButton.icon(onPressed: onOffer, icon: const Icon(Icons.local_offer_outlined, size: 18), style: FilledButton.styleFrom(backgroundColor: AppColors.secondary, padding: EdgeInsets.symmetric(vertical: ResponsiveSize.height(context, 1.15)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm))), label: customText(text: 'إرسال عرض', fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: Colors.white, isBold: true))),
              if (onOffer != null && onReject != null) SizedBox(width: ResponsiveSize.width(context, 2)),
              if (onReject != null) Expanded(child: OutlinedButton(onPressed: onReject, style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: ResponsiveSize.height(context, 1.15)), side: BorderSide(color: AppColors.danger.withValues(alpha: .55)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm))), child: customText(text: 'رفض', fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.danger, isBold: true))),
            ])
          ]
        ]),
      ),
    );
  }

  _RiskStyle _riskStyle(String value) {
    final v = value.trim();
    if (v.contains('منخفض') || v.contains('بسيط')) return const _RiskStyle(AppColors.success, Icons.check_circle_outline_rounded);
    if (v.contains('عالي') || v.contains('مرتفع') || v.contains('خطير')) return const _RiskStyle(AppColors.danger, Icons.error_outline_rounded);
    return const _RiskStyle(AppColors.warning, Icons.warning_amber_rounded);
  }
}

class _RiskStyle { final Color color; final IconData icon; const _RiskStyle(this.color, this.icon); }
class _Risk extends StatelessWidget {
  final String text; final Color color; final IconData icon;
  const _Risk({required this.text, required this.color, required this.icon});
  @override Widget build(BuildContext context) => Container(padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 2), vertical: ResponsiveSize.height(context, .45)), decoration: BoxDecoration(color: color.withValues(alpha: .11), borderRadius: BorderRadius.circular(100), border: Border.all(color: color.withValues(alpha: .2))), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: color), const SizedBox(width: 4), customText(text: text, fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: color, isBold: true)]));
}
