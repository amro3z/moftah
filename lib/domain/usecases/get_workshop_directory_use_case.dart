import 'package:moftah/data/models/car_owner/nerbay_places_model.dart';
import 'package:moftah/domain/repositories/nearby_places_repository_contract.dart';

class GetWorkshopDirectoryUseCase {
  final NearbyPlacesRepositoryContract repository;

  const GetWorkshopDirectoryUseCase(this.repository);

  Future<List<HomeNearbyPlacesModel>> call({
    required double userLatitude,
    required double userLongitude,
    int maxPlaces = 80,
  }) {
    return repository.getWorkshopDirectory(
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      maxPlaces: maxPlaces,
    );
  }
  
}
