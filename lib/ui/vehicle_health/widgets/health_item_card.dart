import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_health_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class HealthItemCard extends StatelessWidget {
  final VehicleHealthItemModel item;
  const HealthItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(item.status);
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border.withValues(alpha: .12)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .055), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveSize.width(context, 10),
                height: ResponsiveSize.width(context, 10),
                decoration: BoxDecoration(color: color.withValues(alpha: .11), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                child: Icon(_icon(item.title), color: color, size: ResponsiveSize.width(context, 5)),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(child: customText(text: item.title, fontSize: ResponsiveSize.width(context, AppSizes.fontLg), color: AppColors.primary, isBold: true)),
              _score(context, color),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          customText(text: item.reason, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: const Color(0xff60758A)),
          SizedBox(height: ResponsiveSize.height(context, 1.1)),
          Row(
            children: [
              _pill(context, 'المصدر: ${_sourceText(item.source)}', AppColors.secondary),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              _pill(context, 'الثقة ${item.confidence}%', _confidenceColor(item.confidence)),
            ],
          ),
          if (item.actionText != null) ...[
            SizedBox(height: ResponsiveSize.height(context, 1)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 3), vertical: ResponsiveSize.height(context, .8)),
              decoration: BoxDecoration(color: color.withValues(alpha: .07), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
              child: Row(children: [Icon(Icons.info_outline_rounded, color: color, size: ResponsiveSize.width(context, 4)), SizedBox(width: ResponsiveSize.width(context, 2)), Expanded(child: customText(text: item.actionText!, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: color, isBold: true))]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _score(BuildContext context, Color color) => Container(
    padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 2.5), vertical: ResponsiveSize.height(context, .55)),
    decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(30)),
    child: customText(text: item.score == null ? 'غير مؤكد' : '${item.score}/100', fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: color, isBold: true),
  );

  Widget _pill(BuildContext context, String text, Color color) => Container(
    padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 2), vertical: ResponsiveSize.height(context, .45)),
    decoration: BoxDecoration(color: color.withValues(alpha: .08), borderRadius: BorderRadius.circular(30)),
    child: customText(text: text, fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: color, isBold: true),
  );

  Color _statusColor(VehicleHealthStatus status) => switch (status) {
    VehicleHealthStatus.excellent => AppColors.success,
    VehicleHealthStatus.good => AppColors.secondary,
    VehicleHealthStatus.attention => AppColors.warning,
    VehicleHealthStatus.critical => AppColors.danger,
    VehicleHealthStatus.unknown => AppColors.textMuted,
  };
  Color _confidenceColor(int value) => value >= 80 ? AppColors.success : value >= 55 ? AppColors.warning : AppColors.danger;
  String _sourceText(VehicleHealthSource source) => switch (source) {
    VehicleHealthSource.obd => 'OBD',
    VehicleHealthSource.maintenanceHistory => 'سجل الصيانة',
    VehicleHealthSource.technicianInspection => 'فحص فني',
    VehicleHealthSource.userInput => 'بياناتك',
    VehicleHealthSource.estimated => 'تقديري',
  };
  IconData _icon(String title) {
    if (title.contains('محرك')) return Icons.settings_rounded;
    if (title.contains('زيت')) return Icons.oil_barrel_rounded;
    if (title.contains('كهرب')) return Icons.battery_charging_full_rounded;
    if (title.contains('إطار')) return Icons.tire_repair_rounded;
    return Icons.speed_rounded;
  }
}
