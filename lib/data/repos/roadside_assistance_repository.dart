import 'package:geolocator/geolocator.dart';
import 'package:moftah/data/datasources/overpass_towing_data_source.dart';
import 'package:moftah/data/models/roadside_assistance_model.dart';

class RoadsideAssistanceRepository {
  RoadsideAssistanceRepository({
    OverpassTowingDataSource? dataSource,
  }) : _dataSource = dataSource ?? OverpassTowingDataSource();

  final OverpassTowingDataSource _dataSource;

  static const List<int> _searchRadii = [
    5000,
    10000,
    25000,
    50000,
    100000,
  ];

  Future<List<TowServiceModel>> getNearestTowServices({
    required double userLatitude,
    required double userLongitude,
    int maxPlaces = 12,
    void Function(int radiusMeters)? onSearchRadius,
  }) async {
    final byId = <String, TowServiceModel>{};
    Object? lastError;

    for (final radius in _searchRadii) {
      onSearchRadius?.call(radius);

      try {
        final raw = await _dataSource.getNearbyTowingServices(
          latitude: userLatitude,
          longitude: userLongitude,
          radiusMeters: radius,
        );

        for (final item in raw) {
          final distanceMeters = Geolocator.distanceBetween(
            userLatitude,
            userLongitude,
            item.latitude,
            item.longitude,
          );

          if (distanceMeters > radius) continue;

          byId[item.externalId] = TowServiceModel(
            id: item.externalId,
            name: item.name,
            latitude: item.latitude,
            longitude: item.longitude,
            distanceKm: distanceMeters / 1000,
            phones: item.phones,
            openingHours: item.openingHours,
            isOpen: item.isOpen,
            roadsideAssistance: item.roadsideAssistance,
            vehicleRecovery: item.vehicleRecovery,
          );
        }

        if (byId.length >= maxPlaces) break;
      } catch (error) {
        lastError = error;
      }
    }

    final places = byId.values.toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    if (places.isNotEmpty) return places.take(maxPlaces).toList();
    if (lastError != null) throw lastError;

    return const [];
  }
}
