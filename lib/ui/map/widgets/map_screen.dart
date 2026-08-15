import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/ui/core/constant/nerbay_places.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class MapScreen extends StatefulWidget {
  final HomeNearbyPlacesModel? selectedPlace;

  const MapScreen({super.key, this.selectedPlace});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  Position? _currentPosition;
  HomeNearbyPlacesModel? _selectedPlace;

  bool _isLoadingLocation = false;

  static const LatLng _cairoLocation = LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();

    _selectedPlace = widget.selectedPlace;

    _getCurrentLocation();
  }

  LatLng get _initialCenter {
    final place = widget.selectedPlace;

    if (place != null) {
      return LatLng(place.latitude, place.longitude);
    }

    return _cairoLocation;
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _stopLoading();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _stopLoading();
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    if (!mounted) return;

    setState(() {
      _currentPosition = position;
      _isLoadingLocation = false;
    });
  }

  void _stopLoading() {
    if (!mounted) return;

    setState(() {
      _isLoadingLocation = false;
    });
  }

  void _selectPlace(HomeNearbyPlacesModel place) {
    setState(() {
      _selectedPlace = place;
    });

    _mapController.move(LatLng(place.latitude, place.longitude), 16);
  }

  Future<void> _goToMyLocation() async {
    if (_currentPosition == null) {
      await _getCurrentLocation();
    }

    if (_currentPosition == null) {
      return;
    }

    setState(() {
      _selectedPlace = null;
    });

    _mapController.move(
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      16,
    );
  }

  List<Marker> _buildWorkshopMarkers() {
    return HomeNearbyPlacesInfo.places.map((place) {
      final isSelected = _selectedPlace?.name == place.name;

      return Marker(
        point: LatLng(place.latitude, place.longitude),

        width: isSelected ? 55 : 45,
        height: isSelected ? 55 : 45,

        child: GestureDetector(
          onTap: () {
            _selectPlace(place);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.car_repair_rounded, color: Colors.white),
          ),
        ),
      );
    }).toList();
  }

  List<Marker> _buildUserMarker() {
    if (_currentPosition == null) {
      return [];
    }

    return [
      Marker(
        point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        width: 28,
        height: 28,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.25),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,

            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: widget.selectedPlace != null ? 16 : 11,

              onTap: (tapPosition, point) {
                setState(() {
                  _selectedPlace = null;
                });
              },
            ),

            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                userAgentPackageName: 'com.example.moftah',
              ),

              MarkerLayer(
                markers: [..._buildWorkshopMarkers(), ..._buildUserMarker()],
              ),

              RichAttributionWidget(
                attributions: const [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          _backButton(context),

          if (_isLoadingLocation)
            const Center(child: CircularProgressIndicator()),

          _myLocationButton(context),

          if (_selectedPlace != null) _placeCard(context, _selectedPlace!),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
        child: Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.white,
            elevation: 3,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _myLocationButton(BuildContext context) {
    return Positioned(
      right: ResponsiveSize.width(context, 5),
      bottom: _selectedPlace == null
          ? ResponsiveSize.height(context, 4)
          : ResponsiveSize.height(context, 22),
      child: Material(
        elevation: 4,
        color: AppColors.secondary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _goToMyLocation,
          child: Padding(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
            child: Icon(
              Icons.my_location_rounded,
              color: Colors.white,
              size: ResponsiveSize.width(context, 6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeCard(BuildContext context, HomeNearbyPlacesModel place) {
    return Positioned(
      left: ResponsiveSize.width(context, 5),
      right: ResponsiveSize.width(context, 5),
      bottom: ResponsiveSize.height(context, 3),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: customText(
                      text: place.name,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                  ),

                  _openStatus(context, place.isOpen),
                ],
              ),

              SizedBox(height: ResponsiveSize.height(context, 0.7)),

              customText(
                text: place.supportedVehicles,
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textSecondary,
              ),

              SizedBox(height: ResponsiveSize.height(context, 1)),

              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: ResponsiveSize.width(context, 4),
                  ),

                  SizedBox(width: ResponsiveSize.width(context, 1)),

                  customText(
                    text: place.rating.toStringAsFixed(1),
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    isBold: true,
                  ),

                  SizedBox(width: ResponsiveSize.width(context, 4)),

                  Icon(
                    Icons.location_on_rounded,
                    color: AppColors.secondary,
                    size: ResponsiveSize.width(context, 4),
                  ),

                  SizedBox(width: ResponsiveSize.width(context, 0.5)),

                  customText(
                    text: '${place.distance.toStringAsFixed(1)} كم',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.secondary,
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _openStatus(BuildContext context, bool isOpen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, 0.4),
      ),
      decoration: BoxDecoration(
        color: isOpen
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: customText(
        text: isOpen ? 'مفتوح' : 'مغلق',
        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
        color: isOpen ? AppColors.success : AppColors.danger,
        isBold: true,
      ),
    );
  }
}
