import 'dart:convert';
import 'dart:io';

import 'package:moftah/data/models/map/route_path_model.dart';
import 'package:moftah/ui/core/helper/map.dart';

class OsrmRoutingDataSource {
  Future<RoutePathModel> getFastestRoute({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) async {
    final uri = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '$fromLongitude,$fromLatitude;$toLongitude,$toLatitude'
      '?overview=simplified&geometries=geojson&steps=true&alternatives=false',
    );

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, 'Moftah/1.0 Flutter');

      final response = await request.close().timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'OSRM request failed with status ${response.statusCode}',
        );
      }

      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body) as Map<String, dynamic>;

      if (decoded['code'] != 'Ok') {
        throw const FormatException('OSRM did not return a valid route');
      }

      final routes = decoded['routes'] as List<dynamic>? ?? const [];
      if (routes.isEmpty || routes.first is! Map<String, dynamic>) {
        throw const FormatException('No route found');
      }

      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>?;
      final coordinates =
          geometry?['coordinates'] as List<dynamic>? ?? const [];

      final points = <RouteCoordinate>[];

      for (final rawCoordinate in coordinates) {
        if (rawCoordinate is! List || rawCoordinate.length < 2) continue;

        final longitude = asDouble(rawCoordinate[0]);
        final latitude = asDouble(rawCoordinate[1]);

        if (latitude == null || longitude == null) continue;
        if (!isValidCoordinate(latitude, longitude)) continue;

        points.add(RouteCoordinate(latitude: latitude, longitude: longitude));
      }

      if (points.length < 2) {
        throw const FormatException('Route geometry is empty');
      }

      return RoutePathModel(
        points: points,
        distanceMeters: asDouble(route['distance']) ?? 0,
        durationSeconds: asDouble(route['duration']) ?? 0,
        initialBearing: _parseInitialBearing(route),
        navigationSteps: _parseNavigationSteps(route),
      );
    } finally {
      client.close(force: true);
    }
  }

  double _parseInitialBearing(Map<String, dynamic> route) {
    final legs = route['legs'] as List<dynamic>? ?? const [];
    if (legs.isEmpty || legs.first is! Map<String, dynamic>) return 0;

    final leg = legs.first as Map<String, dynamic>;
    final steps = leg['steps'] as List<dynamic>? ?? const [];
    if (steps.isEmpty || steps.first is! Map<String, dynamic>) return 0;

    final firstStep = steps.first as Map<String, dynamic>;
    final maneuver = firstStep['maneuver'];
    if (maneuver is! Map<String, dynamic>) return 0;

    return asDouble(maneuver['bearing_after']) ?? 0;
  }

  List<RouteNavigationStep> _parseNavigationSteps(Map<String, dynamic> route) {
    final legs = route['legs'] as List<dynamic>? ?? const [];
    if (legs.isEmpty || legs.first is! Map<String, dynamic>) return const [];

    final leg = legs.first as Map<String, dynamic>;
    final rawSteps = leg['steps'] as List<dynamic>? ?? const [];
    if (rawSteps.isEmpty) return const [];

    final parsedSteps = <RouteNavigationStep>[];

    for (var index = 0; index < rawSteps.length; index++) {
      final rawStep = rawSteps[index];
      if (rawStep is! Map<String, dynamic>) continue;

      final maneuver = rawStep['maneuver'];
      if (maneuver is! Map<String, dynamic>) continue;

      final location = maneuver['location'];
      if (location is! List || location.length < 2) continue;

      final longitude = asDouble(location[0]);
      final latitude = asDouble(location[1]);
      if (latitude == null || longitude == null) continue;
      if (!isValidCoordinate(latitude, longitude)) continue;

      final type = maneuver['type']?.toString() ?? 'continue';
      if (type == 'depart') continue;

      final previousStep =
          index > 0 && rawSteps[index - 1] is Map<String, dynamic>
          ? rawSteps[index - 1] as Map<String, dynamic>
          : null;

      final distanceToManeuver = previousStep == null
          ? asDouble(rawStep['distance']) ?? 0
          : asDouble(previousStep['distance']) ?? 0;

      parsedSteps.add(
        RouteNavigationStep(
          type: type,
          modifier: maneuver['modifier']?.toString(),
          roadName: rawStep['name']?.toString() ?? '',
          distanceMeters: distanceToManeuver,
          bearingAfter: asDouble(maneuver['bearing_after']) ?? 0,
          location: RouteCoordinate(latitude: latitude, longitude: longitude),
        ),
      );
    }

    return parsedSteps;
  }
}
