import 'package:moftah/data/models/car_owner/nerbay_places_model.dart';

enum NearbyLoadingStep {
  checkingPermission,
  checkingLocationService,
  locatingUser,
  checkingInternet,
  searchingWorkshops,
}

sealed class NearbyPlacesState {
  const NearbyPlacesState();
}

class NearbyPlacesInitial extends NearbyPlacesState {
  const NearbyPlacesInitial();
}

class NearbyPlacesLoading extends NearbyPlacesState {
  final NearbyLoadingStep step;
  final int? searchRadiusMeters;

  const NearbyPlacesLoading({
    required this.step,
    this.searchRadiusMeters,
  });
}

class NearbyPlacesSuccess extends NearbyPlacesState {
  final List<HomeNearbyPlacesModel> places;
  final double userLatitude;
  final double userLongitude;
  final bool isLoadingMore;

  const NearbyPlacesSuccess(
    this.places, {
    required this.userLatitude,
    required this.userLongitude,
    this.isLoadingMore = false,
  });
}

class NearbyPlacesError extends NearbyPlacesState {
  final String message;
  final bool openLocationSettings;
  final bool openAppSettings;

  const NearbyPlacesError(
    this.message, {
    this.openLocationSettings = false,
    this.openAppSettings = false,
  });
}
