import 'package:moftah/data/models/nerbay_places_model.dart';

class MapRouteArguments {
  final HomeNearbyPlacesModel? selectedPlace;
  final List<HomeNearbyPlacesModel> nearbyPlaces;

  const MapRouteArguments({
    this.selectedPlace,
    this.nearbyPlaces = const [],
  });
}
