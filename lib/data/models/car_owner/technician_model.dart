class TechnicianModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final double distanceKm;
  final bool availableNow;
  final List<String> vehicleBrands;
  final int inspectionFee;

  const TechnicianModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.distanceKm,
    required this.availableNow,
    required this.vehicleBrands,
    required this.inspectionFee,
  });
}
