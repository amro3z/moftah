import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  static Future<Position?> getCurrentPosition() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    Position? lastKnownPosition;

    try {
      lastKnownPosition = await Geolocator.getLastKnownPosition();
    } catch (_) {
      lastKnownPosition = null;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return lastKnownPosition;
    }

    if (lastKnownPosition != null) {
      final age = DateTime.now().difference(lastKnownPosition.timestamp);
      if (age <= const Duration(minutes: 2)) {
        return lastKnownPosition;
      }
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (_) {
      try {
        await Future<void>.delayed(const Duration(milliseconds: 350));
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 8),
          ),
        );
      } on TimeoutException {
        return lastKnownPosition;
      } catch (_) {
        return lastKnownPosition;
      }
    }
  }

  static Future<Position?> getNavigationPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: 4),
        ),
      );
    } catch (_) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }
}
