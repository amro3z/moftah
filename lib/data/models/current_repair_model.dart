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
  final String vehicleName;
  final String technicianName;
  final String expectedFinish;
  final double estimatedCost;
  final String discoveredIssueTitle;
  final String discoveredIssueDescription;
  final String problemImageUrl;
  final String offeredPartName;
  final double partCost;
  final double laborCost;

  const CurrentRepairModel({
    required this.title,
    required this.workshopName,
    required this.location,
    required this.currentStage,
    this.vehicleName = 'Toyota Corolla 2020',
    this.technicianName = 'محمد أحمد',
    this.expectedFinish = '3:00 م',
    this.estimatedCost = 1250,
    this.discoveredIssueTitle = 'تم اكتشاف مشكلة إضافية',
    this.discoveredIssueDescription =
        'أثناء الفحص، اكتشف الفني مشكلة تحتاج موافقتك قبل استكمال الإصلاح.',
    this.problemImageUrl =
        'https://aaaindustrialsupply.com/cdn/shop/collections/superlube-8893308.jpg?v=1767906169&width=2000',
    this.offeredPartName = 'طقم تيل الفرامل الأمامي',
    this.partCost = 1900,
    this.laborCost = 450,
  });

  double get offerTotal => partCost + laborCost;
}
