import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:moftah/data/models/overpass_dto.dart';
import 'package:moftah/ui/core/helper/map.dart';
import 'package:moftah/utils/opening_hours_helper.dart';



class OverpassNearbyPlacesDataSource {
  static final List<Uri> _endpoints = [
    Uri.parse('https://overpass-api.de/api/interpreter'),
    Uri.parse('https://overpass.kumi.systems/api/interpreter'),
    Uri.parse('https://overpass.nchc.org.tw/api/interpreter'),
  ];

  Future<List<OverpassPlaceDto>> getNearbyCarRepairPlaces({
    required double latitude,
    required double longitude,
    required int radiusMeters,
  }) async {
    final query = '''
[out:json][timeout:30];
(
  nwr(around:$radiusMeters,$latitude,$longitude)["shop"="car_repair"];
  nwr(around:$radiusMeters,$latitude,$longitude)["car:repair"="yes"];
);
out center tags;
''';

    Object? lastError;

    for (final endpoint in _endpoints) {
      try {
        return await _requestEndpoint(
          endpoint: endpoint,
          query: query,
        );
      } catch (error) {
        lastError = error;
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
    }

    if (lastError != null) throw lastError;
    return const [];
  }

  Future<List<OverpassPlaceDto>> _requestEndpoint({
    required Uri endpoint,
    required String query,
  }) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8)
      ..idleTimeout = const Duration(seconds: 15);

    try {
      final request = await client.postUrl(endpoint);
      request.headers.contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
        charset: 'utf-8',
      );
      request.headers.set(
        HttpHeaders.userAgentHeader,
        'Moftah/1.0 Flutter',
      );
      request.write('data=${Uri.encodeQueryComponent(query)}');

      final response = await request.close().timeout(
        const Duration(seconds: 35),
      );

      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Overpass request failed with status ${response.statusCode}',
        );
      }

      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final elements = decoded['elements'] as List<dynamic>? ?? const [];

      final placesById = <String, OverpassPlaceDto>{};

      for (final rawElement in elements) {
        if (rawElement is! Map<String, dynamic>) continue;

        final type = rawElement['type']?.toString();
        final id = rawElement['id']?.toString();
        if (type == null || id == null) continue;

        final coordinates = _extractCoordinates(rawElement);
        if (coordinates == null) continue;

        final lat = coordinates.$1;
        final lon = coordinates.$2;
        if (!isValidCoordinate(lat, lon)) continue;

        final tags = (rawElement['tags'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{};

        final name = _firstNonEmpty([
              tags['name'],
              tags['name:ar'],
              tags['operator'],
              tags['brand'],
            ]) ??
            'ورشة سيارات';

        final details = _firstNonEmpty([
              tags['description'],
              tags['service'],
              tags['brand'],
            ]) ??
            'صيانة وإصلاح سيارات';

        final openingHours = tags['opening_hours']?.toString().trim();
        final bool? isOpen = OpeningHoursHelper.isOpenNow(openingHours);

        final externalId = '${type}_$id';
        placesById[externalId] = OverpassPlaceDto(
          externalId: externalId,
          name: name,
          supportedVehicles: details,
          isOpen: isOpen,
          openingHours: openingHours,
          latitude: lat,
          longitude: lon,
        );
      }

      return placesById.values.toList();
    } on TimeoutException {
      rethrow;
    } finally {
      client.close(force: true);
    }
  }

  (double, double)? _extractCoordinates(Map<String, dynamic> element) {
    final lat = asDouble(element['lat']);
    final lon = asDouble(element['lon']);

    if (lat != null && lon != null) return (lat, lon);

    final center = element['center'];
    if (center is Map) {
      final centerLat = asDouble(center['lat']);
      final centerLon = asDouble(center['lon']);
      if (centerLat != null && centerLon != null) {
        return (centerLat, centerLon);
      }
    }

    return null;
  }

  String? _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }
}
