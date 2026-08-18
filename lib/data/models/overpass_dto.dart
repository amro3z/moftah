class OverpassPlaceDto {
  final String externalId;
  final String name;
  final String supportedVehicles;
  final bool? isOpen;
  final String? openingHours;
  final double latitude;
  final double longitude;

  const OverpassPlaceDto({
    required this.externalId,
    required this.name,
    required this.supportedVehicles,
    required this.isOpen,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
  });
}
