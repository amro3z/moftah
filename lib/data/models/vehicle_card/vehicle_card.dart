enum MaintenanceStatus { excellent, good, needsService, critical }

class VehicleCardModel {
  final String carName;
  final int year;
  final int kilo;
  final int healthScore;

  final MaintenanceStatus maintenanceStatus;

  final String brand;
  final int nextMaintenance;
  final String lastMaintenance;

  VehicleCardModel({
    required this.carName,
    required this.year,
    required this.kilo,
    required this.healthScore,
    required this.maintenanceStatus,
    required this.brand,
    required this.nextMaintenance,
    required this.lastMaintenance,
  });
}
