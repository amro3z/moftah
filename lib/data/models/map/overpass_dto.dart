class OverpassPlaceDto {
  final String externalId;
  final String name;
  final String supportedVehicles;
  final bool? isOpen;
  final String? openingHours;
  final List<String> phones;
  final double latitude;
  final double longitude;

  const OverpassPlaceDto({
    required this.externalId,
    required this.name,
    required this.supportedVehicles,
    required this.isOpen,
    required this.openingHours,
    required this.phones,
    required this.latitude,
    required this.longitude,
  });
}
