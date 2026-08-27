import 'package:geolocator/geolocator.dart';
import 'package:moftah/data/models/car_owner/nerbay_places_model.dart';

class NearbyPlacesCache {
  NearbyPlacesCache._();

  static final NearbyPlacesCache instance = NearbyPlacesCache._();

  static const Duration locationRefreshInterval = Duration(minutes: 10);
  static const double locationChangeThresholdMeters = 200;

  double? userLatitude;
  double? userLongitude;
  DateTime? locationUpdatedAt;

  List<HomeNearbyPlacesModel> nearestPlaces = const [];
  List<HomeNearbyPlacesModel> directoryPlaces = const [];
  bool isDirectoryLoading = false;

  bool get hasLocation => userLatitude != null && userLongitude != null;
  bool get hasNearest => nearestPlaces.isNotEmpty;
  bool get hasDirectory => directoryPlaces.isNotEmpty;

  bool get shouldRefreshLocation {
    final updatedAt = locationUpdatedAt;
    if (!hasLocation || updatedAt == null) return true;
    return DateTime.now().difference(updatedAt) >= locationRefreshInterval;
  }

  void saveLocation(double latitude, double longitude) {
    userLatitude = latitude;
    userLongitude = longitude;
    locationUpdatedAt = DateTime.now();
  }

  bool saveLocationIfChanged(
    double latitude,
    double longitude, {
    double thresholdMeters = locationChangeThresholdMeters,
  }) {
    if (!hasLocation) {
      saveLocation(latitude, longitude);
      return true;
    }

    final distance = Geolocator.distanceBetween(
      userLatitude!,
      userLongitude!,
      latitude,
      longitude,
    );

    // حتى لو نفس المنطقة، نحدّث وقت آخر فحص علشان ما نطلبش GPS كل شوية.
    locationUpdatedAt = DateTime.now();

    if (distance < thresholdMeters) {
      return false;
    }

    userLatitude = latitude;
    userLongitude = longitude;
    clearPlaces();
    return true;
  }

  void saveNearest(List<HomeNearbyPlacesModel> places) {
    nearestPlaces = List.unmodifiable(places);
  }

  void saveDirectory(List<HomeNearbyPlacesModel> places) {
    directoryPlaces = List.unmodifiable(places);
  }

  void clearPlaces() {
    nearestPlaces = const [];
    directoryPlaces = const [];
    isDirectoryLoading = false;
  }
}
