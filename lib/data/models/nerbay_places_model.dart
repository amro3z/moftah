class HomeNearbyPlacesModel {
  final String name;
  final String supportedVehicles;
  final double rating;
  final bool isOpen;
  final double distance;

  HomeNearbyPlacesModel({
    required this.name,
    required this.supportedVehicles,
    required this.rating,
    required this.isOpen,
    required this.distance,
  });
}
