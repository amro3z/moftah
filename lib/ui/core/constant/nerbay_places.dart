import 'package:moftah/data/models/nerbay_places_model.dart';

class HomeNearbyPlacesInfo {
  HomeNearbyPlacesInfo._();

  static final List<HomeNearbyPlacesModel> places = [
    HomeNearbyPlacesModel(
      name: 'Auto Pro Center',
      rating: 4.5,
      distance: 2.5,
      supportedVehicles: 'Hyundai, Toyota, Nissan, Ford',
      isOpen: false,
    ),

    HomeNearbyPlacesModel(
      name: 'Tech Repair Shop',
      rating: 4.0,
      distance: 3.0,
      supportedVehicles: 'BMW, Mercedes, Audi',
      isOpen: true,
    ),

    HomeNearbyPlacesModel(
      name: 'Car Service Hub',
      rating: 4.8,
      distance: 1.5,
      supportedVehicles: 'Kia, Hyundai, Chevrolet, Renault',
      isOpen: true,
    ),

    HomeNearbyPlacesModel(
      name: 'Master Garage',
      rating: 3.5,
      distance: 4.2,
      supportedVehicles: 'Toyota, Nissan, Mitsubishi',
      isOpen: false,
    ),

    HomeNearbyPlacesModel(
      name: 'Speed Auto Service',
      rating: 4.7,
      distance: 5.3,
      supportedVehicles: 'Ford, Jeep, Chevrolet, Peugeot',
      isOpen: true,
    ),
  ];
}
