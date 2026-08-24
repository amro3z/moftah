class TowingPlaceDto {
  final String externalId;
  final String name;
  final double latitude;
  final double longitude;
  final List<String> phones;
  final String? openingHours;
  final bool? isOpen;
  final bool roadsideAssistance;
  final bool vehicleRecovery;

  const TowingPlaceDto({
    required this.externalId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.phones = const [],
    this.openingHours,
    this.isOpen,
    this.roadsideAssistance = true,
    this.vehicleRecovery = true,
  });
}
