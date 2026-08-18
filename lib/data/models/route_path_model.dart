class RoutePathModel {
  final List<RouteCoordinate> points;
  final double distanceMeters;
  final double durationSeconds;
  final double initialBearing;
  final List<RouteNavigationStep> navigationSteps;

  const RoutePathModel({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
    this.initialBearing = 0,
    this.navigationSteps = const [],
  });

  RouteNavigationStep? get nextInstruction {
    if (navigationSteps.isEmpty) return null;
    return navigationSteps.first;
  }
}

class RouteCoordinate {
  final double latitude;
  final double longitude;

  const RouteCoordinate({
    required this.latitude,
    required this.longitude,
  });
}

class RouteNavigationStep {
  final String type;
  final String? modifier;
  final String roadName;
  final double distanceMeters;
  final double bearingAfter;
  final RouteCoordinate location;

  const RouteNavigationStep({
    required this.type,
    required this.modifier,
    required this.roadName,
    required this.distanceMeters,
    required this.bearingAfter,
    required this.location,
  });
}
