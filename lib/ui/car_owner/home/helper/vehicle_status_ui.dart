import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card/vehicle_card.dart';
import 'package:moftah/ui/core/themes/colors.dart';

class StatusUiData {
  final String text;
  final Color color;
  final Color backgroundColor;

  const StatusUiData({
    required this.text,
    required this.color,
    required this.backgroundColor,
  });
}

class VehicleStatusUi {
  VehicleStatusUi._();

  static StatusUiData maintenance(MaintenanceStatus status) {
    switch (status) {
      case MaintenanceStatus.excellent:
        return const StatusUiData(
          text: 'ممتازة',
          color: AppColors.success,
          backgroundColor: AppColors.successBackground,
        );

      case MaintenanceStatus.good:
        return const StatusUiData(
          text: 'جيدة',
          color: AppColors.success,
          backgroundColor: AppColors.successBackground,
        );

      case MaintenanceStatus.needsService:
        return const StatusUiData(
          text: 'تحتاج صيانة',
          color: AppColors.warning,
          backgroundColor: AppColors.warningBackground,
        );

      case MaintenanceStatus.critical:
        return const StatusUiData(
          text: 'حرجة',
          color: AppColors.danger,
          backgroundColor: AppColors.dangerBackground,
        );
    }
  }
}
