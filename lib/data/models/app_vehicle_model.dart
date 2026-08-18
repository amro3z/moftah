import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/data/models/vehicle_health_model.dart';

class AppVehicleModel {
  final String id;
  final VehicleCardModel card;
  final VehicleHealthModel health;

  const AppVehicleModel({
    required this.id,
    required this.card,
    required this.health,
  });
}
