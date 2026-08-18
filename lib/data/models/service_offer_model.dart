class ServiceOfferModel {
  final String id;
  final String providerName;
  final String providerType;
  final String specialty;
  final double rating;
  final double distanceKm;
  final int inspectionFee;
  final int minEstimatedCost;
  final int maxEstimatedCost;
  final String estimatedDuration;
  final String availability;
  final String note;

  const ServiceOfferModel({
    required this.id,
    required this.providerName,
    required this.providerType,
    required this.specialty,
    required this.rating,
    required this.distanceKm,
    required this.inspectionFee,
    required this.minEstimatedCost,
    required this.maxEstimatedCost,
    required this.estimatedDuration,
    required this.availability,
    required this.note,
  });
}
