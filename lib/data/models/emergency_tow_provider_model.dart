class EmergencyTowProviderModel {
  final String id;
  final String driverName;
  final String phone;
  final String governorate;
  final String coverageArea;
  final double startingPrice;
  final String maxDestination;
  final double rating;
  final bool isAvailable;

  const EmergencyTowProviderModel({
    required this.id,
    required this.driverName,
    required this.phone,
    required this.governorate,
    required this.coverageArea,
    required this.startingPrice,
    required this.maxDestination,
    required this.rating,
    this.isAvailable = true,
  });
}
