class HomeNearbyPlacesModel {
  final String externalId;
  final String name;
  final String supportedVehicles;
  final double rating;
  final int reviewsCount;
  final bool? isOpen;
  final String? openingHours;
  final List<String> phones;
  final double distance;
  final String path;
  final double latitude;
  final double longitude;

  const HomeNearbyPlacesModel({
    required this.externalId,
    required this.name,
    required this.supportedVehicles,
    required this.rating,
    required this.reviewsCount,
    required this.isOpen,
    required this.openingHours,
    required this.phones,
    required this.distance,
    required this.path,
    required this.latitude,
    required this.longitude,
  });
}
