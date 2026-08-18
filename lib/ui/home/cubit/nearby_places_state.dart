import 'package:moftah/data/models/nerbay_places_model.dart';

sealed class NearbyPlacesState {
  const NearbyPlacesState();
}

class NearbyPlacesInitial extends NearbyPlacesState {
  const NearbyPlacesInitial();
}

class NearbyPlacesLoading extends NearbyPlacesState {
  const NearbyPlacesLoading();
}

class NearbyPlacesSuccess extends NearbyPlacesState {
  final List<HomeNearbyPlacesModel> places;

  const NearbyPlacesSuccess(this.places);
}

class NearbyPlacesError extends NearbyPlacesState {
  final String message;

  const NearbyPlacesError(this.message);
}
