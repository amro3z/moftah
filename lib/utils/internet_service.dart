import 'dart:async';
import 'dart:io';

class InternetService {
  InternetService._();

  static const List<String> _hosts = [
    'openstreetmap.org',
    'overpass-api.de',
  ];

  static Future<bool> hasInternetAccess() async {
    for (final host in _hosts) {
      try {
        final result = await InternetAddress.lookup(host).timeout(
          const Duration(seconds: 4),
        );

        if (result.isNotEmpty && result.first.rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException {
        continue;
      } on TimeoutException {
        continue;
      } catch (_) {
        continue;
      }
    }

    return false;
  }
}
