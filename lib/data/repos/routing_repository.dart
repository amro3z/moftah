import 'package:moftah/data/datasources/osrm_routing_data_source.dart';
import 'package:moftah/data/models/map/route_path_model.dart';

class RoutingRepository {
  RoutingRepository({
    OsrmRoutingDataSource? dataSource,
  }) : _dataSource = dataSource ?? OsrmRoutingDataSource();

  final OsrmRoutingDataSource _dataSource;

  Future<RoutePathModel> getFastestRoute({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) {
    return _dataSource.getFastestRoute(
      fromLatitude: fromLatitude,
      fromLongitude: fromLongitude,
      toLatitude: toLatitude,
      toLongitude: toLongitude,
    );
  }
}
