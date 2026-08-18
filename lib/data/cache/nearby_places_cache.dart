import 'package:moftah/data/models/nerbay_places_model.dart';

class NearbyPlacesCache {
  NearbyPlacesCache._();

  static final NearbyPlacesCache instance = NearbyPlacesCache._();

  double? userLatitude;
  double? userLongitude;
  List<HomeNearbyPlacesModel> nearestPlaces = const [];
  List<HomeNearbyPlacesModel> directoryPlaces = const [];
  bool isDirectoryLoading = false;

  bool get hasLocation => userLatitude != null && userLongitude != null;
  bool get hasNearest => nearestPlaces.isNotEmpty;
  bool get hasDirectory => directoryPlaces.isNotEmpty;

  void saveLocation(double latitude, double longitude) {
    userLatitude = latitude;
    userLongitude = longitude;
  }

  void saveNearest(List<HomeNearbyPlacesModel> places) {
    nearestPlaces = List.unmodifiable(places);
  }

  void saveDirectory(List<HomeNearbyPlacesModel> places) {
    directoryPlaces = List.unmodifiable(places);
  }
}
