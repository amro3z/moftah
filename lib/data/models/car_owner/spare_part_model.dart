class SparePartCompatibility {
  final String vehicleName;
  final List<int> years;
  final String engine;

  const SparePartCompatibility({
    required this.vehicleName,
    required this.years,
    required this.engine,
  });
}

class SparePartModel {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String oemNumber;
  final double price;
  final double rating;
  final double distanceKm;
  final String seller;
  final String location;
  final int warrantyMonths;
  final String imageUrl;
  final bool isOem;
  final bool isOriginal;
  final bool compatibleWithSelectedVehicle;
  final List<SparePartCompatibility> compatibility;

  const SparePartModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.oemNumber,
    required this.price,
    required this.rating,
    required this.distanceKm,
    required this.seller,
    required this.location,
    required this.warrantyMonths,
    required this.imageUrl,
    required this.isOem,
    required this.isOriginal,
    required this.compatibleWithSelectedVehicle,
    required this.compatibility,
  });
}
