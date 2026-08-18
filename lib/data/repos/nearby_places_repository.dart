import 'package:geolocator/geolocator.dart';
import 'package:moftah/data/datasources/overpass_nearby_places_data_source.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/models/overpass_dto.dart';
import 'package:moftah/data/repos/workshop_rating_repository.dart';
import 'package:moftah/ui/core/constant/nerbay_places.dart';

class NearbyPlacesRepository {
  NearbyPlacesRepository({
    OverpassNearbyPlacesDataSource? dataSource,
    WorkshopRatingRepository? ratingRepository,
  })  : _dataSource = dataSource ?? OverpassNearbyPlacesDataSource(),
        _ratingRepository =
            ratingRepository ?? WorkshopRatingRepository.instance;

  final OverpassNearbyPlacesDataSource _dataSource;
  final WorkshopRatingRepository _ratingRepository;

  Future<List<HomeNearbyPlacesModel>> getNearestWorkshops({
    required double userLatitude,
    required double userLongitude,
    void Function(int radiusMeters)? onSearchRadius,
  }) async {
    final placesById = <String, HomeNearbyPlacesModel>{};
    Object? lastError;

    for (final radiusMeters in HomeNearbyPlacesInfo.searchRadiiMeters) {
      onSearchRadius?.call(radiusMeters);

      try {
        final rawPlaces = await _dataSource.getNearbyCarRepairPlaces(
          latitude: userLatitude,
          longitude: userLongitude,
          radiusMeters: radiusMeters,
        );

        _appendPlaces(
          target: placesById,
          rawPlaces: rawPlaces,
          userLatitude: userLatitude,
          userLongitude: userLongitude,
          maxDistanceMeters: radiusMeters,
        );

        final sortedPlaces = _sortedByDistance(placesById.values);

        if (sortedPlaces.length >= HomeNearbyPlacesInfo.maxPlaces) {
          return sortedPlaces.take(HomeNearbyPlacesInfo.maxPlaces).toList();
        }
      } catch (error) {
        lastError = error;
      }
    }

    final sortedPlaces = _sortedByDistance(placesById.values);

    if (sortedPlaces.isNotEmpty) {
      return sortedPlaces.take(HomeNearbyPlacesInfo.maxPlaces).toList();
    }

    if (lastError != null) throw lastError;
    return const [];
  }

  Future<List<HomeNearbyPlacesModel>> getWorkshopDirectory({
    required double userLatitude,
    required double userLongitude,
    int maxPlaces = 80,
    void Function(int radiusMeters)? onSearchRadius,
  }) async {
    final placesById = <String, HomeNearbyPlacesModel>{};
    Object? lastError;

    for (final radiusMeters in HomeNearbyPlacesInfo.searchRadiiMeters) {
      onSearchRadius?.call(radiusMeters);

      try {
        final rawPlaces = await _dataSource.getNearbyCarRepairPlaces(
          latitude: userLatitude,
          longitude: userLongitude,
          radiusMeters: radiusMeters,
        );

        _appendPlaces(
          target: placesById,
          rawPlaces: rawPlaces,
          userLatitude: userLatitude,
          userLongitude: userLongitude,
          maxDistanceMeters: radiusMeters,
        );

        if (placesById.length >= maxPlaces) break;
      } catch (error) {
        lastError = error;
      }
    }

    final sortedPlaces = _sortedByDistance(placesById.values);

    if (sortedPlaces.isNotEmpty) {
      return sortedPlaces.take(maxPlaces).toList();
    }

    if (lastError != null) throw lastError;
    return const [];
  }

  Future<List<HomeNearbyPlacesModel>> getWorkshopsInMapArea({
    required double searchLatitude,
    required double searchLongitude,
    required double userLatitude,
    required double userLongitude,
    required int radiusMeters,
    int maxPlaces = 50,
  }) async {
    final rawPlaces = await _dataSource.getNearbyCarRepairPlaces(
      latitude: searchLatitude,
      longitude: searchLongitude,
      radiusMeters: radiusMeters,
    );

    final placesById = <String, HomeNearbyPlacesModel>{};

    _appendPlaces(
      target: placesById,
      rawPlaces: rawPlaces,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      searchLatitude: searchLatitude,
      searchLongitude: searchLongitude,
      maxDistanceMeters: radiusMeters,
    );

    final places = placesById.values.toList()
      ..sort((a, b) {
        final aFromCenter = Geolocator.distanceBetween(
          searchLatitude,
          searchLongitude,
          a.latitude,
          a.longitude,
        );
        final bFromCenter = Geolocator.distanceBetween(
          searchLatitude,
          searchLongitude,
          b.latitude,
          b.longitude,
        );
        return aFromCenter.compareTo(bFromCenter);
      });

    return places.take(maxPlaces).toList();
  }

  void _appendPlaces({
    required Map<String, HomeNearbyPlacesModel> target,
    required List<OverpassPlaceDto> rawPlaces,
    required double userLatitude,
    required double userLongitude,
    required int maxDistanceMeters,
    double? searchLatitude,
    double? searchLongitude,
  }) {
    for (final place in rawPlaces) {
      final referenceLatitude = searchLatitude ?? userLatitude;
      final referenceLongitude = searchLongitude ?? userLongitude;

      final distanceFromSearchCenter = Geolocator.distanceBetween(
        referenceLatitude,
        referenceLongitude,
        place.latitude,
        place.longitude,
      );

      if (distanceFromSearchCenter > maxDistanceMeters) continue;

      final userDistanceMeters = Geolocator.distanceBetween(
        userLatitude,
        userLongitude,
        place.latitude,
        place.longitude,
      );

      final rating = _ratingRepository.getSummary(place.externalId);

      target[place.externalId] = HomeNearbyPlacesModel(
        externalId: place.externalId,
        name: place.name,
        supportedVehicles: place.supportedVehicles,
        rating: rating.average,
        reviewsCount: rating.reviewsCount,
        isOpen: place.isOpen,
        openingHours: place.openingHours,
        phones: place.phones,
        distance: userDistanceMeters / 1000,
        path: '/map',
        latitude: place.latitude,
        longitude: place.longitude,
      );
    }
  }

  List<HomeNearbyPlacesModel> _sortedByDistance(
    Iterable<HomeNearbyPlacesModel> places,
  ) {
    return places.toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
  }
}
