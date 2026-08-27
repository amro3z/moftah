import 'package:moftah/data/models/car_owner/nerbay_places_model.dart';

abstract class NearbyPlacesRepositoryContract {
  Future<List<HomeNearbyPlacesModel>> getNearestWorkshops({
    required double userLatitude,
    required double userLongitude,
  });

  Future<List<HomeNearbyPlacesModel>> getWorkshopDirectory({
    required double userLatitude,
    required double userLongitude,
    int maxPlaces = 80,
  });

  Future<List<HomeNearbyPlacesModel>> getWorkshopsInMapArea({
    required double searchLatitude,
    required double searchLongitude,
    required double userLatitude,
    required double userLongitude,
    required int radiusMeters,
    int maxPlaces = 50,
  });
}
