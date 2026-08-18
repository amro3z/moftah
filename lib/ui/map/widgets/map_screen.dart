import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/models/route_path_model.dart';
import 'package:moftah/data/repos/nearby_places_repository.dart';
import 'package:moftah/data/repos/routing_repository.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/app_loading_indicator.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/map/helper/navigation_instruction_helper.dart';
import 'package:moftah/utils/location_service.dart';
import 'package:moftah/utils/opening_hours_helper.dart';
import 'package:moftah/utils/responsive.dart';

class MapScreen extends StatefulWidget {
  final HomeNearbyPlacesModel? selectedPlace;
  final List<HomeNearbyPlacesModel> initialNearbyPlaces;

  const MapScreen({
    super.key,
    this.selectedPlace,
    this.initialNearbyPlaces = const [],
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final MapController _mapController = MapController();
  final NearbyPlacesRepository _nearbyPlacesRepository =
      NearbyPlacesRepository();
  final RoutingRepository _routingRepository = RoutingRepository();

  LatLng? _currentLocation;
  HomeNearbyPlacesModel? _selectedPlace;
  List<HomeNearbyPlacesModel> _nearbyPlaces = const [];
  RoutePathModel? _activeRoute;

  Timer? _navigationTimer;
  Timer? _mapAreaSearchDebounce;
  bool _isNavigationMode = false;
  double _currentHeading = 0;

  bool _isMapReady = false;
  bool _isLoadingLocation = false;
  bool _isSearchingPlaces = false;
  bool _isLoadingRoute = false;
  bool _isRefreshingNavigation = false;
  bool _isInitializingMap = false;
  bool _isSearchingMapArea = false;
  LatLng? _lastMapAreaSearchCenter;
  double? _lastMapAreaSearchZoom;
  String? _mapAreaSearchError;
  LatLng? _pendingMapAreaCenter;
  double? _pendingMapAreaZoom;
  String? _mapError;
  String? _routeError;

  static const LatLng _cairoLocation = LatLng(30.0444, 31.2357);
  static const Duration _navigationRefreshInterval = Duration(seconds: 5);
  static const double _minimumRerouteMovementMeters = 10;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _selectedPlace = widget.selectedPlace;
    _nearbyPlaces = [...widget.initialNearbyPlaces];

    if (_selectedPlace != null &&
        !_nearbyPlaces.any(
          (place) => place.externalId == _selectedPlace!.externalId,
        )) {
      _nearbyPlaces.insert(0, _selectedPlace!);
    }

    _initializeMap();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isNavigationMode && _selectedPlace != null) {
        _startNavigationTimer();
        _refreshNavigation();
      }
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _navigationTimer?.cancel();
      _navigationTimer = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _navigationTimer?.cancel();
    _mapAreaSearchDebounce?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  LatLng get _initialCenter {
    final place = widget.selectedPlace;
    if (place != null) {
      return LatLng(place.latitude, place.longitude);
    }

    if (_nearbyPlaces.isNotEmpty) {
      final first = _nearbyPlaces.first;
      return LatLng(first.latitude, first.longitude);
    }

    return _cairoLocation;
  }

  Future<void> _initializeMap() async {
    if (_isInitializingMap) return;
    _isInitializingMap = true;

    if (mounted) {
      setState(() {
        _isLoadingLocation = true;
        _mapError = null;
      });
    }

    try {
      final position = await LocationService.getCurrentPosition();

      if (position == null) {
        if (!mounted) return;
        setState(() {
          _isLoadingLocation = false;
          _mapError = 'تعذر الوصول إلى موقعك';
        });
        _isInitializingMap = false;
        return;
      }

      final currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      setState(() {
        _currentLocation = currentLocation;
        _currentHeading = _normalizedHeading(position.heading);
        _isLoadingLocation = false;
      });

      _moveToCurrentLocationIfNeeded();

      if (_nearbyPlaces.isEmpty) {
        await _loadNearbyPlaces(
          userLatitude: position.latitude,
          userLongitude: position.longitude,
        );
      }

      if (_selectedPlace != null) {
        await _loadFastestRoute(fitRoute: true);
      }

      _isInitializingMap = false;
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
        _isSearchingPlaces = false;
        _mapError = 'تعذر تحميل الخريطة';
      });
      _isInitializingMap = false;
    }
  }

  Future<void> _loadNearbyPlaces({
    required double userLatitude,
    required double userLongitude,
  }) async {
    if (!mounted) return;

    setState(() {
      _isSearchingPlaces = true;
      _mapError = null;
    });

    try {
      List<HomeNearbyPlacesModel>? places;
      Object? lastError;

      for (var attempt = 0; attempt < 2; attempt++) {
        try {
          places = await _nearbyPlacesRepository.getNearestWorkshops(
            userLatitude: userLatitude,
            userLongitude: userLongitude,
          );
          break;
        } catch (error) {
          lastError = error;
          if (attempt == 0) {
            await Future<void>.delayed(const Duration(milliseconds: 700));
          }
        }
      }

      if (places == null) {
        throw lastError ?? Exception('Nearby workshops request failed');
      }

      if (!mounted) return;
      setState(() {
        _nearbyPlaces = places!;
        _isSearchingPlaces = false;
        _mapError = places.isEmpty
            ? 'لم يتم العثور على ورش حتى نطاق 100 كم'
            : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSearchingPlaces = false;
        _mapError = 'تعذر تحميل الورش القريبة';
      });
    }
  }

  void _moveToCurrentLocationIfNeeded() {
    if (!_isMapReady || _currentLocation == null) return;
    if (_selectedPlace != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isMapReady || _currentLocation == null) return;
      _mapController.move(_currentLocation!, 14);
    });
  }

  Future<void> _selectPlace(HomeNearbyPlacesModel place) async {
    setState(() {
      _selectedPlace = place;
      _activeRoute = null;
      _routeError = null;
    });

    await _loadFastestRoute(fitRoute: true);
  }

  void _clearSelectedPlace() {
    _navigationTimer?.cancel();
    _navigationTimer = null;

    setState(() {
      _isNavigationMode = false;
      _selectedPlace = null;
      _activeRoute = null;
      _routeError = null;
      _isLoadingRoute = false;
    });
  }

  void _startNavigationTimer() {
    _navigationTimer?.cancel();

    if (_selectedPlace == null) return;

    _navigationTimer = Timer.periodic(
      _navigationRefreshInterval,
      (_) => _refreshNavigation(),
    );
  }

  Future<void> _refreshNavigation() async {
    if (_selectedPlace == null || _isRefreshingNavigation) return;

    _isRefreshingNavigation = true;

    try {
      final position = await LocationService.getNavigationPosition();
      if (position == null || !mounted) return;

      final newLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      final previousLocation = _currentLocation;
      final movedMeters = previousLocation == null
          ? double.infinity
          : Geolocator.distanceBetween(
              previousLocation.latitude,
              previousLocation.longitude,
              newLocation.latitude,
              newLocation.longitude,
            );

      final newHeading = _normalizedHeading(position.heading);
      final headingDelta = (_currentHeading - newHeading).abs();
      final shouldRefreshUi =
          movedMeters >= 2 || headingDelta >= 5 || _currentLocation == null;

      if (shouldRefreshUi && mounted) {
        setState(() {
          _currentLocation = newLocation;
          _currentHeading = newHeading;
        });
        _focusNavigationCamera();
      } else {
        _currentLocation = newLocation;
        _currentHeading = newHeading;
      }

      if (movedMeters >= _minimumRerouteMovementMeters ||
          _activeRoute == null) {
        await _loadFastestRoute(fitRoute: false, showLoading: false);
      }
    } finally {
      _isRefreshingNavigation = false;
    }
  }

  Future<void> _loadFastestRoute({
    required bool fitRoute,
    bool showLoading = true,
  }) async {
    final currentLocation = _currentLocation;
    final selectedPlace = _selectedPlace;

    if (currentLocation == null || selectedPlace == null) return;
    if (_isLoadingRoute) return;

    if (mounted && showLoading) {
      setState(() {
        _isLoadingRoute = true;
        _routeError = null;
      });
    } else {
      _isLoadingRoute = true;
      _routeError = null;
    }

    try {
      final route = await _routingRepository.getFastestRoute(
        fromLatitude: currentLocation.latitude,
        fromLongitude: currentLocation.longitude,
        toLatitude: selectedPlace.latitude,
        toLongitude: selectedPlace.longitude,
      );

      if (!mounted) return;

      setState(() {
        _activeRoute = route;
        _isLoadingRoute = false;
        _routeError = null;
      });

      if (_isNavigationMode) {
        _focusNavigationCamera();
      }

      if (fitRoute && _isMapReady && !_isNavigationMode) {
        final routePoints = route.points
            .map(
              (point) => LatLng(
                point.latitude,
                point.longitude,
              ),
            )
            .toList();

        if (routePoints.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || !_isMapReady) return;
            _mapController.fitCamera(
              CameraFit.coordinates(
                coordinates: routePoints,
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 7),
                  ResponsiveSize.height(context, 12),
                  ResponsiveSize.width(context, 7),
                  ResponsiveSize.height(context, 28),
                ),
                maxZoom: 16,
              ),
            );
          });
        }
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingRoute = false;
        _routeError = 'تعذر تحديث الطريق حالياً';
      });
    }
  }

  Future<void> _goToMyLocation() async {
    if (_currentLocation == null) {
      final position = await LocationService.getCurrentPosition();

      if (position != null && mounted) {
        setState(() {
          _currentLocation = LatLng(
            position.latitude,
            position.longitude,
          );
          _currentHeading = _normalizedHeading(position.heading);
        });
      }
    }

    if (_currentLocation == null) return;

    if (_selectedPlace == null) {
      _mapController.move(_currentLocation!, 16);
    } else {
      await _loadFastestRoute(fitRoute: true);
    }
  }

  Future<void> _startNavigation() async {
    if (_selectedPlace == null || _currentLocation == null) return;

    setState(() {
      _isNavigationMode = true;
      _routeError = null;
    });

    await _loadFastestRoute(
      fitRoute: false,
      showLoading: _activeRoute == null,
    );

    _focusNavigationCamera();
    _startNavigationTimer();
  }

  void _stopNavigation() {
    _navigationTimer?.cancel();
    _navigationTimer = null;

    setState(() {
      _isNavigationMode = false;
    });

    if (_activeRoute != null && _isMapReady) {
      final points = _activeRoute!.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      if (points.isNotEmpty) {
        _mapController.fitCamera(
          CameraFit.coordinates(
            coordinates: points,
            padding: EdgeInsets.fromLTRB(
              ResponsiveSize.width(context, 7),
              ResponsiveSize.height(context, 12),
              ResponsiveSize.width(context, 7),
              ResponsiveSize.height(context, 28),
            ),
            maxZoom: 16,
          ),
        );
      }
    }
  }

  void _focusNavigationCamera() {
    if (!_isNavigationMode || !_isMapReady || _currentLocation == null) return;

    final routeBearing = _activeRoute?.initialBearing ?? 0;
    final heading = _currentHeading > 0 ? _currentHeading : routeBearing;
    final mapRotation = (360 - heading) % 360;

    _mapController.moveAndRotate(
      _currentLocation!,
      17.0,
      mapRotation,
    );
  }

  double _normalizedHeading(double heading) {
    if (!heading.isFinite || heading < 0) return 0;
    return heading % 360;
  }

  void _scheduleMapAreaSearch(
    LatLng center,
    double zoom, {
    bool force = false,
  }) {
    if (_isNavigationMode || _currentLocation == null) return;

    if (!force && zoom < 8.5) {
      _mapAreaSearchDebounce?.cancel();
      if (mounted) {
        setState(() {
          _mapAreaSearchError = 'قرّب الخريطة شوية علشان نعرض ورش المنطقة';
        });
      }
      return;
    }

    final radiusMeters = _searchRadiusForZoom(zoom);
    final previousCenter = _lastMapAreaSearchCenter;
    final previousZoom = _lastMapAreaSearchZoom;

    if (!force && previousCenter != null && previousZoom != null) {
      final movedMeters = Geolocator.distanceBetween(
        previousCenter.latitude,
        previousCenter.longitude,
        center.latitude,
        center.longitude,
      );

      final minimumMovement = radiusMeters * 0.30;
      if (movedMeters < minimumMovement &&
          (previousZoom - zoom).abs() < 0.8) {
        return;
      }
    }

    _mapAreaSearchDebounce?.cancel();
    _mapAreaSearchDebounce = Timer(
      const Duration(milliseconds: 850),
      () => _searchMapArea(
        center: center,
        zoom: zoom,
        radiusMeters: radiusMeters,
      ),
    );
  }

  int _searchRadiusForZoom(double zoom) {
    if (zoom >= 15) return 4000;
    if (zoom >= 13) return 9000;
    if (zoom >= 11) return 22000;
    if (zoom >= 9) return 35000;
    return 50000;
  }

  Future<void> _searchMapArea({
    required LatLng center,
    required double zoom,
    required int radiusMeters,
  }) async {
    final currentLocation = _currentLocation;
    if (currentLocation == null || !mounted) return;

    if (_isSearchingMapArea) {
      _pendingMapAreaCenter = center;
      _pendingMapAreaZoom = zoom;
      return;
    }

    setState(() {
      _isSearchingMapArea = true;
      _mapAreaSearchError = null;
    });

    try {
      final places = await _nearbyPlacesRepository.getWorkshopsInMapArea(
        searchLatitude: center.latitude,
        searchLongitude: center.longitude,
        userLatitude: currentLocation.latitude,
        userLongitude: currentLocation.longitude,
        radiusMeters: radiusMeters,
        maxPlaces: 50,
      );

      if (!mounted) return;

      final selectedPlace = _selectedPlace;
      final nextPlaces = [...places];

      if (selectedPlace != null &&
          !nextPlaces.any(
            (place) => place.externalId == selectedPlace.externalId,
          )) {
        nextPlaces.add(selectedPlace);
      }

      setState(() {
        _nearbyPlaces = nextPlaces;
        _lastMapAreaSearchCenter = center;
        _lastMapAreaSearchZoom = zoom;
        _isSearchingMapArea = false;
        _mapAreaSearchError = places.isEmpty
            ? 'مفيش ورش مسجلة في المنطقة دي، حرّك الخريطة لمنطقة تانية'
            : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSearchingMapArea = false;
        _mapAreaSearchError = 'تعذر تحديث ورش المنطقة دي';
      });
    }

    final pendingCenter = _pendingMapAreaCenter;
    final pendingZoom = _pendingMapAreaZoom;
    _pendingMapAreaCenter = null;
    _pendingMapAreaZoom = null;

    if (pendingCenter != null && pendingZoom != null && mounted) {
      _scheduleMapAreaSearch(
        pendingCenter,
        pendingZoom,
        force: true,
      );
    }
  }

  List<Marker> _buildWorkshopMarkers() {
    return _nearbyPlaces
        .where(_hasValidCoordinates)
        .where(
          (place) => _selectedPlace?.externalId != place.externalId,
        )
        .map((place) {
      return Marker(
        point: LatLng(place.latitude, place.longitude),
        width: 44,
        height: 44,
        child: GestureDetector(
          onTap: () => _selectPlace(place),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.car_repair_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Marker> _buildDestinationMarker() {
    final place = _selectedPlace;
    if (place == null || !_hasValidCoordinates(place)) return const [];

    return [
      Marker(
        point: LatLng(place.latitude, place.longitude),
        width: _isNavigationMode ? 62 : 56,
        height: _isNavigationMode ? 62 : 56,
        rotate: true,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.danger,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.danger.withValues(alpha: 0.28),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.flag_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    ];
  }

  List<Marker> _buildUserMarker() {
    final currentLocation = _currentLocation;
    if (currentLocation == null) return [];

    if (_isNavigationMode) {
      return [
        Marker(
          point: currentLocation,
          width: 56,
          height: 56,
          rotate: true,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.directions_car_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ];
    }

    return [
      Marker(
        point: currentLocation,
        width: 30,
        height: 30,
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

  List<Polyline> _buildRoutePolylines() {
    final route = _activeRoute;
    if (route == null || route.points.length < 2) return const [];

    return [
      Polyline(
        points: route.points
            .map(
              (point) => LatLng(
                point.latitude,
                point.longitude,
              ),
            )
            .toList(),
        color: AppColors.secondary,
        strokeWidth: 5,
        borderColor: Colors.white,
        borderStrokeWidth: 2,
      ),
    ];
  }

  bool _hasValidCoordinates(HomeNearbyPlacesModel place) {
    return place.latitude.isFinite &&
        place.longitude.isFinite &&
        place.latitude >= -90 &&
        place.latitude <= 90 &&
        place.longitude >= -180 &&
        place.longitude <= 180;
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
              minZoom: 3,
              maxZoom: 18,
              onMapReady: () {
                _isMapReady = true;
                _moveToCurrentLocationIfNeeded();

                if (widget.selectedPlace == null && _currentLocation != null) {
                  _scheduleMapAreaSearch(
                    _currentLocation!,
                    11,
                    force: true,
                  );
                }
              },
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture && !_isNavigationMode) {
                  _scheduleMapAreaSearch(
                    camera.center,
                    camera.zoom,
                  );
                }
              },
              onTap: (tapPosition, point) {
                if (!_isNavigationMode && _selectedPlace != null) {
                  _clearSelectedPlace();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.moftah',
                maxZoom: 18,
                panBuffer: 0,
              ),
              if (_activeRoute != null)
                PolylineLayer(
                  polylines: _buildRoutePolylines(),
                ),
              MarkerLayer(
                markers: [
                  if (!_isNavigationMode) ..._buildWorkshopMarkers(),
                  ..._buildDestinationMarker(),
                  ..._buildUserMarker(),
                ],
              ),
              RichAttributionWidget(
                attributions: const [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),
          if (!_isNavigationMode) _backButton(context),
          if (_isNavigationMode) _navigationInstructionCard(context),
          if (_isLoadingLocation)
            const Center(
              child: AppLoadingIndicator(
                message: 'بنحدد موقعك...',
              ),
            ),
          if (_isSearchingPlaces)
            const Center(
              child: AppLoadingIndicator(
                message: 'بندور على أقرب الورش ليك...',
              ),
            ),
          if (_isSearchingMapArea && !_isSearchingPlaces)
            _mapAreaSearchBadge(context),
          if (_mapAreaSearchError != null &&
              !_isSearchingMapArea &&
              _mapError == null)
            _mapAreaMessage(context),
          if (_mapError != null) _errorMessage(context),
          if (!_isNavigationMode) _myLocationButton(context),
          if (_selectedPlace != null && !_isNavigationMode)
            _placeCard(context, _selectedPlace!),
          if (_isNavigationMode) _navigationBottomBar(context),
        ],
      ),
    );
  }

  Widget _mapAreaSearchBadge(BuildContext context) {
    return Positioned(
      top: ResponsiveSize.height(context, 7),
      left: ResponsiveSize.width(context, 22),
      right: ResponsiveSize.width(context, 22),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 3),
            vertical: ResponsiveSize.height(context, 0.8),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: ResponsiveSize.width(context, 4),
                height: ResponsiveSize.width(context, 4),
                child: const CircularProgressIndicator(
                  strokeWidth: 2.3,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              Flexible(
                child: customText(
                  text: 'بنحدّث الورش في المنطقة دي...',
                  fontSize: ResponsiveSize.width(
                    context,
                    AppSizes.fontSm,
                  ),
                  color: AppColors.primary,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mapAreaMessage(BuildContext context) {
    return Positioned(
      top: ResponsiveSize.height(context, 7),
      left: ResponsiveSize.width(context, 14),
      right: ResponsiveSize.width(context, 14),
      child: SafeArea(
        child: IgnorePointer(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 3),
              vertical: ResponsiveSize.height(context, 0.8),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            child: customText(
              text: _mapAreaSearchError!,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: Colors.white,
              isBold: true,
            ),
          ),
        ),
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
              onPressed: () => Navigator.pop(context),
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

  Widget _errorMessage(BuildContext context) {
    return Center(
      child: AppRetryIndicator(
        message: _mapError!,
        onRetry: _initializeMap,
      ),
    );
  }

  Widget _myLocationButton(BuildContext context) {
    return Positioned(
      right: ResponsiveSize.width(context, 5),
      bottom: _selectedPlace == null
          ? ResponsiveSize.height(context, 4)
          : ResponsiveSize.height(context, 27),
      child: Material(
        elevation: 4,
        color: AppColors.secondary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _goToMyLocation,
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveSize.width(context, 3.5),
            ),
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

  Widget _placeCard(
    BuildContext context,
    HomeNearbyPlacesModel place,
  ) {
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
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontLg,
                      ),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                  ),
                  _openStatus(
                    context,
                    OpeningHoursHelper.isOpenNow(place.openingHours) ??
                        place.isOpen,
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 0.7)),
              customText(
                text: place.supportedVehicles,
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.progressBackground,
              ),
              SizedBox(height: ResponsiveSize.height(context, 0.4)),
              customText(
                text: OpeningHoursHelper.displayText(place.openingHours),
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                color: AppColors.textMuted,
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
                    text: place.reviewsCount == 0
                        ? 'بدون تقييم'
                        : '${place.rating.toStringAsFixed(1)} (${place.reviewsCount})',
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
                    text: _activeRoute == null
                        ? '${place.distance.toStringAsFixed(1)} كم'
                        : '${(_activeRoute!.distanceMeters / 1000).toStringAsFixed(1)} كم',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.secondary,
                    isBold: true,
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              _routeInfo(context),
              SizedBox(height: ResponsiveSize.height(context, 1.2)),
              _startNavigationButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _routeInfo(BuildContext context) {
    if (_isLoadingRoute) {
      return Row(
        children: [
          SizedBox(
            width: ResponsiveSize.width(context, 4),
            height: ResponsiveSize.width(context, 4),
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.secondary,
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          customText(
            text: 'بنحسب أسرع طريق...',
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.secondary,
            isBold: true,
          ),
        ],
      );
    }

    if (_routeError != null) {
      return GestureDetector(
        onTap: () => _loadFastestRoute(fitRoute: true),
        child: customText(
          text: '$_routeError - اضغط لإعادة المحاولة',
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: AppColors.danger,
          isBold: true,
        ),
      );
    }

    final route = _activeRoute;
    if (route == null) return const SizedBox.shrink();

    final minutes = (route.durationSeconds / 60).ceil();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 3),
        vertical: ResponsiveSize.height(context, 0.8),
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          Icon(
            Icons.alt_route_rounded,
            color: AppColors.secondary,
            size: ResponsiveSize.width(context, 4.5),
          ),
          SizedBox(width: ResponsiveSize.width(context, 1.5)),
          Expanded(
            child: customText(
              text:
                  'أسرع طريق • $minutes دقيقة • تحديث تلقائي كل 5 ثواني',
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: AppColors.primary,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _startNavigationButton(BuildContext context) {
    final canStart = _activeRoute != null &&
        _currentLocation != null &&
        !_isLoadingRoute;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canStart ? _startNavigation : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.35),
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveSize.height(context, 1.25),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        icon: Icon(
          Icons.navigation_rounded,
          size: ResponsiveSize.width(context, 5),
        ),
        label: customText(
          text: 'تروح',
          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
          color: Colors.white,
          isBold: true,
        ),
      ),
    );
  }

  Widget _navigationInstructionCard(BuildContext context) {
    final step = _activeRoute?.nextInstruction;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 4),
          vertical: ResponsiveSize.height(context, 1),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 4),
              vertical: ResponsiveSize.height(context, 1.3),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveSize.width(context, 14),
                  height: ResponsiveSize.width(context, 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(
                    step == null
                        ? Icons.straight_rounded
                        : NavigationInstructionHelper.icon(step),
                    color: Colors.white,
                    size: ResponsiveSize.width(context, 8),
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customText(
                        text: step == null
                            ? 'استمر على الطريق'
                            : NavigationInstructionHelper.distanceText(
                                step.distanceMeters,
                              ),
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                        color: AppColors.info,
                        isBold: true,
                      ),
                      SizedBox(
                        height: ResponsiveSize.height(context, 0.3),
                      ),
                      customText(
                        text: step == null
                            ? 'جاري تحديث تعليمات الطريق...'
                            : NavigationInstructionHelper.instruction(step),
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontLg,
                        ),
                        color: Colors.white,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navigationBottomBar(BuildContext context) {
    final route = _activeRoute;
    final minutes = route == null ? 0 : (route.durationSeconds / 60).ceil();
    final distanceKm = route == null ? 0.0 : route.distanceMeters / 1000;

    return Positioned(
      left: ResponsiveSize.width(context, 4),
      right: ResponsiveSize.width(context, 4),
      bottom: ResponsiveSize.height(context, 2.5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 4),
            vertical: ResponsiveSize.height(context, 1.1),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customText(
                      text: '$minutes دقيقة',
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontLg,
                      ),
                      color: AppColors.secondary,
                      isBold: true,
                    ),
                    customText(
                      text: '${distanceKm.toStringAsFixed(1)} كم • تحديث مباشر',
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontXs,
                      ),
                      color: AppColors.progressBackground,
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: _stopNavigation,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                icon: const Icon(Icons.close_rounded),
                label: customText(
                  text: 'إنهاء',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.danger,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _openStatus(BuildContext context, bool? isOpen) {
    final text = isOpen == true
        ? 'مفتوح الآن'
        : isOpen == false
            ? 'مغلق الآن'
            : 'غير مؤكد';

    final color = isOpen == true
        ? AppColors.success
        : isOpen == false
            ? AppColors.danger
            : AppColors.progressBackground;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, 0.4),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: customText(
        text: text,
        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
        color: color,
        isBold: true,
      ),
    );
  }
}
