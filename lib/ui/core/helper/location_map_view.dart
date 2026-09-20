import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapView extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double height;
  final double zoom;

  const LocationMapView({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 250,
    this.zoom = 16,
  });

  @override
  Widget build(BuildContext context) {
    final location = LatLng(latitude, longitude);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(initialCenter: location, initialZoom: zoom),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.moftah',
            ),

            MarkerLayer(
              markers: [
                Marker(
                  point: location,
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Oارجع ')),
          ],
        ),
      ),
    );
  }
}
