enum RepairStage {
  received,
  inspection,
  approval,
  repairing,
  testing,
  completed,
}

class CurrentRepairModel {
  final String title;
  final String workshopName;
  final String location;
  final RepairStage currentStage;

  const CurrentRepairModel({
    required this.title,
    required this.workshopName,
    required this.location,
    required this.currentStage,
  });
}
