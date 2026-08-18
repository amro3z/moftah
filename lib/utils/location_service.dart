import 'dart:async';

import 'package:geolocator/geolocator.dart';

enum LocationReadiness {
  ready,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
}

class LocationService {
  LocationService._();

  static Position? _cachedPosition;
  static DateTime? _cachedAt;

  static const Duration _freshCacheAge = Duration(minutes: 2);
  static const Duration _fallbackCacheAge = Duration(minutes: 30);

  static Future<LocationReadiness> ensureLocationPermission() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationReadiness.permissionDeniedForever;
    }

    if (permission == LocationPermission.denied) {
      return LocationReadiness.permissionDenied;
    }

    return LocationReadiness.ready;
  }

  static Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  static Future<LocationReadiness> ensureLocationReady() async {
    final permissionReadiness = await ensureLocationPermission();
    if (permissionReadiness != LocationReadiness.ready) {
      return permissionReadiness;
    }

    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationReadiness.serviceDisabled;
    }

    return LocationReadiness.ready;
  }

  static Future<Position?> getCurrentPosition({
    bool forceRefresh = false,
    bool skipReadinessCheck = false,
  }) async {
    if (!forceRefresh) {
      final cached = _getCachedPosition(maxAge: _freshCacheAge);
      if (cached != null) return cached;
    }

    if (!skipReadinessCheck) {
      final readiness = await ensureLocationReady();
      if (readiness != LocationReadiness.ready) {
        return _getBestFallbackPosition();
      }
    }

    final lastKnown = await _safeLastKnownPosition();

    if (!forceRefresh &&
        lastKnown != null &&
        _isPositionFresh(lastKnown, _freshCacheAge)) {
      _cache(lastKnown);
      return lastKnown;
    }

    final highAccuracy = await _tryCurrentPosition(
      accuracy: LocationAccuracy.high,
      timeout: const Duration(seconds: 18),
    );

    if (highAccuracy != null) {
      _cache(highAccuracy);
      return highAccuracy;
    }

    final streamPosition = await _tryFirstStreamPosition(
      accuracy: LocationAccuracy.medium,
      timeout: const Duration(seconds: 15),
    );

    if (streamPosition != null) {
      _cache(streamPosition);
      return streamPosition;
    }

    final lowAccuracy = await _tryCurrentPosition(
      accuracy: LocationAccuracy.low,
      timeout: const Duration(seconds: 10),
    );

    if (lowAccuracy != null) {
      _cache(lowAccuracy);
      return lowAccuracy;
    }

    if (lastKnown != null) {
      _cache(lastKnown);
      return lastKnown;
    }

    return _getCachedPosition(maxAge: _fallbackCacheAge);
  }

  static Future<Position?> getNavigationPosition() async {
    final readiness = await ensureLocationReady();
    if (readiness != LocationReadiness.ready) {
      return _getBestFallbackPosition();
    }

    final navigationPosition = await _tryCurrentPosition(
      accuracy: LocationAccuracy.bestForNavigation,
      timeout: const Duration(seconds: 10),
    );

    if (navigationPosition != null) {
      _cache(navigationPosition);
      return navigationPosition;
    }

    final highAccuracy = await _tryCurrentPosition(
      accuracy: LocationAccuracy.high,
      timeout: const Duration(seconds: 10),
    );

    if (highAccuracy != null) {
      _cache(highAccuracy);
      return highAccuracy;
    }

    final streamPosition = await _tryFirstStreamPosition(
      accuracy: LocationAccuracy.high,
      timeout: const Duration(seconds: 10),
    );

    if (streamPosition != null) {
      _cache(streamPosition);
      return streamPosition;
    }

    return _getBestFallbackPosition();
  }

  static Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (_) {}
  }

  static Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (_) {}
  }

  static Future<Position?> _tryCurrentPosition({
    required LocationAccuracy accuracy,
    required Duration timeout,
  }) async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeout,
        ),
      );
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<Position?> _tryFirstStreamPosition({
    required LocationAccuracy accuracy,
    required Duration timeout,
  }) async {
    try {
      return await Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          distanceFilter: 0,
        ),
      ).first.timeout(timeout);
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<Position?> _safeLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  static Future<Position?> _getBestFallbackPosition() async {
    final cached = _getCachedPosition(maxAge: _fallbackCacheAge);
    if (cached != null) return cached;

    final lastKnown = await _safeLastKnownPosition();
    if (lastKnown != null) {
      _cache(lastKnown);
    }

    return lastKnown;
  }

  static Position? _getCachedPosition({required Duration maxAge}) {
    final position = _cachedPosition;
    final cachedAt = _cachedAt;

    if (position == null || cachedAt == null) return null;

    final age = DateTime.now().difference(cachedAt);
    if (age > maxAge) return null;

    return position;
  }

  static bool _isPositionFresh(Position position, Duration maxAge) {
    return DateTime.now().difference(position.timestamp) <= maxAge;
  }

  static void _cache(Position position) {
    _cachedPosition = position;
    _cachedAt = DateTime.now();
  }
}
