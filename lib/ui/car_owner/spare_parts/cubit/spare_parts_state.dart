import 'package:moftah/data/models/car_owner/spare_part_model.dart';
import 'package:moftah/data/models/vehicle_card/user_vehicle_model.dart';

enum SparePartsSort { recommended, nearest, priceLowToHigh, ratingHighToLow }

class SparePartsState {
  final List<SparePartModel> products;
  final List<UserVehicleModel> vehicles;
  final Set<String> favoriteIds;
  final Map<String, int> cartQuantities;
  final String searchQuery;
  final bool compatibleOnly;
  final SparePartsSort sort;
  final String selectedVehicleId;

  const SparePartsState({
    this.products = const [],
    this.vehicles = const [],
    this.favoriteIds = const {},
    this.cartQuantities = const {},
    this.searchQuery = '',
    this.compatibleOnly = false,
    this.sort = SparePartsSort.recommended,
    this.selectedVehicleId = '',
  });

  UserVehicleModel? get selectedVehicle {
    for (final vehicle in vehicles) {
      if (vehicle.id == selectedVehicleId) return vehicle;
    }
    return vehicles.isEmpty ? null : vehicles.first;
  }

  int get cartCount => cartQuantities.values.fold(0, (sum, qty) => sum + qty);

  List<SparePartModel> get visibleProducts {
    Iterable<SparePartModel> result = products;
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query) ||
            p.oemNumber.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
      });
    }

    if (compatibleOnly) result = result.where(isCompatible);

    final list = result.toList();
    switch (sort) {
      case SparePartsSort.nearest:
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case SparePartsSort.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SparePartsSort.ratingHighToLow:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SparePartsSort.recommended:
        break;
    }
    return list;
  }

  bool isCompatible(SparePartModel product) {
    final vehicle = selectedVehicle;
    if (vehicle == null) return product.compatibleWithSelectedVehicle;
    final name = '${vehicle.brand} ${vehicle.model}'.trim().toLowerCase();
    return product.compatibility.any(
      (item) => item.vehicleName.trim().toLowerCase() == name && item.years.contains(vehicle.year),
    );
  }

  double get cartSubtotal {
    var total = 0.0;
    for (final entry in cartQuantities.entries) {
      SparePartModel? product;
      for (final item in products) {
        if (item.id == entry.key) {
          product = item;
          break;
        }
      }
      if (product != null) total += product.price * entry.value;
    }
    return total;
  }

  List<SparePartModel> get favoriteProducts =>
      products.where((p) => favoriteIds.contains(p.id)).toList();

  List<SparePartModel> get cartProducts =>
      products.where((p) => cartQuantities.containsKey(p.id)).toList();

  SparePartsState copyWith({
    List<SparePartModel>? products,
    List<UserVehicleModel>? vehicles,
    Set<String>? favoriteIds,
    Map<String, int>? cartQuantities,
    String? searchQuery,
    bool? compatibleOnly,
    SparePartsSort? sort,
    String? selectedVehicleId,
  }) {
    return SparePartsState(
      products: products ?? this.products,
      vehicles: vehicles ?? this.vehicles,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      cartQuantities: cartQuantities ?? this.cartQuantities,
      searchQuery: searchQuery ?? this.searchQuery,
      compatibleOnly: compatibleOnly ?? this.compatibleOnly,
      sort: sort ?? this.sort,
      selectedVehicleId: selectedVehicleId ?? this.selectedVehicleId,
    );
  }
}
