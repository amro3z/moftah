import 'package:moftah/data/models/car_owner/nerbay_places_model.dart';

class MapRouteArguments {
  final HomeNearbyPlacesModel? selectedPlace;
  final List<HomeNearbyPlacesModel> nearbyPlaces;

  const MapRouteArguments({
    this.selectedPlace,
    this.nearbyPlaces = const [],
  });
}
