import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMapView extends StatefulWidget {
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
  State<LocationMapView> createState() => _LocationMapViewState();
}

class _LocationMapViewState extends State<LocationMapView> {
  final MapController _mapController = MapController();

  late LatLng _location;

  @override
  void initState() {
    super.initState();

    _location = LatLng(widget.latitude, widget.longitude);
  }

  void _goToLocation() {
    _mapController.move(_location, widget.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _location,
                initialZoom: widget.zoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.moftah',
                ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: _location,
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
              ],
            ),

            Positioned(
              bottom: 12,
              right: 12,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 4,
                child: InkWell(
                  onTap: _goToLocation,
                  borderRadius: BorderRadius.circular(12),
                  child: const SizedBox(
                    width: 46,
                    height: 46,
                    child: Icon(Icons.my_location_rounded, color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
