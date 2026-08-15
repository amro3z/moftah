class HomeNearbyPlacesModel {
  final String name;
  final String supportedVehicles;
  final double rating;
  final bool isOpen;
  final double distance;
  final String path;
  final double latitude;
  final double longitude;
  const HomeNearbyPlacesModel({
    required this.name,
    required this.supportedVehicles,
    required this.rating,
    required this.isOpen,
    required this.distance,
    required this.path,
    required this.latitude,
    required this.longitude,
  });
}
