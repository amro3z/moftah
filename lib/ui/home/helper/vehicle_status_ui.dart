import 'package:flutter/material.dart';
import 'package:moftah/data/models/vehicle_card.dart';
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

  static StatusUiData document(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.verified:
        return const StatusUiData(
          text: 'موثقة',
          color: AppColors.info,
          backgroundColor: AppColors.infoBackground,
        );

      case DocumentStatus.pending:
        return const StatusUiData(
          text: 'قيد المراجعة',
          color: AppColors.warning,
          backgroundColor: AppColors.warningBackground,
        );

      case DocumentStatus.expired:
        return  StatusUiData(
          text: 'منتهية',
          color: AppColors.danger,
          backgroundColor: AppColors.dangerBackground,
        );
    }
  }

  static StatusUiData repair(RepairStatus status) {
    switch (status) {
      case RepairStatus.good:
        return const StatusUiData(
          text: 'جيدة',
          color: AppColors.success,
          backgroundColor: AppColors.successBackground,
        );

      case RepairStatus.pending:
        return  StatusUiData(
          text: 'معلقة',
          color: AppColors.warning,
          backgroundColor: AppColors.warningBackground,
        );

      case RepairStatus.inProgress:
        return const StatusUiData(
          text: 'جاري الإصلاح',
          color: AppColors.info,
          backgroundColor: AppColors.infoBackground,
        );

      case RepairStatus.completed:
        return const StatusUiData(
          text: 'مكتملة',
          color: AppColors.success,
          backgroundColor: AppColors.successBackground,
        );
    }
  }
}
