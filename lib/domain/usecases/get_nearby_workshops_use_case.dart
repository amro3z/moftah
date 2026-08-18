import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/domain/repositories/nearby_places_repository_contract.dart';

class GetNearbyWorkshopsUseCase {
  final NearbyPlacesRepositoryContract repository;

  const GetNearbyWorkshopsUseCase(this.repository);

  Future<List<HomeNearbyPlacesModel>> call({
    required double userLatitude,
    required double userLongitude,
  }) {
    return repository.getNearestWorkshops(
      userLatitude: userLatitude,
      userLongitude: userLongitude,
    );
  }
}
