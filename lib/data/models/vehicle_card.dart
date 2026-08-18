enum MaintenanceStatus { excellent, good, needsService, critical }

enum DocumentStatus { verified, pending, expired }

enum RepairStatus { good, pending, inProgress, completed }

class VehicleCardModel {
  final String carName;
  final int year;
  final int mileage;
  final int healthScore;

  final MaintenanceStatus maintenanceStatus;
  final DocumentStatus documentStatus;

  final String brand;
  final String? brandLogoUrl;

  final int nextMaintenance;
  final String lastMaintenance;

  final RepairStatus repairStatus;

  VehicleCardModel({
    required this.carName,
    required this.year,
    required this.mileage,
    required this.healthScore,
    required this.maintenanceStatus,
    required this.documentStatus,
    required this.brand,
    this.brandLogoUrl,
    required this.nextMaintenance,
    required this.lastMaintenance,
    required this.repairStatus,
  });
}
