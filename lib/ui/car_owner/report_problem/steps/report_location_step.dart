import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:moftah/data/cache/nearby_places_cache.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/location_service.dart';
import 'package:moftah/utils/responsive.dart';

class ReportLocationStep extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final void Function(double latitude, double longitude) onLocationChanged;

  const ReportLocationStep({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.onLocationChanged,
  });

  @override
  State<ReportLocationStep> createState() => _ReportLocationStepState();
}

class _ReportLocationStepState extends State<ReportLocationStep> {
  late final MapController _mapController;
  late final MapOptions _mapOptions;

  bool _mapReady = false;
  bool _locating = false;
  bool _manualMode = false;

  double? _latitude;
  double? _longitude;

  static const LatLng _cairoFallback = LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();

    _latitude = widget.initialLatitude;
    _longitude = widget.initialLongitude;

    _mapController = MapController();

    final initialCenter = _hasLocation
        ? LatLng(_latitude!, _longitude!)
        : _cairoFallback;

    _mapOptions = MapOptions(
      initialCenter: initialCenter,
      initialZoom: _hasLocation ? 16 : 11,
      onMapReady: () {
        _mapReady = true;

        if (_hasLocation) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _moveCamera(_latitude!, _longitude!);
          });
        }
      },
      onTap: (_, point) {
        if (!_manualMode) return;
        _selectManualLocation(point);
      },
    );
  }

  @override
  void didUpdateWidget(covariant ReportLocationStep oldWidget) {
    super.didUpdateWidget(oldWidget);

    final latitudeChanged =
        widget.initialLatitude != oldWidget.initialLatitude;
    final longitudeChanged =
        widget.initialLongitude != oldWidget.initialLongitude;

    if (!latitudeChanged && !longitudeChanged) return;

    _latitude = widget.initialLatitude;
    _longitude = widget.initialLongitude;

    if (_hasLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _moveCamera(_latitude!, _longitude!);
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  bool get _hasLocation => _latitude != null && _longitude != null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 2),
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            text: 'حدد مكان العربية مرة واحدة',
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            color: AppColors.primary,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, .5)),
          customText(
            text: 'استخدم موقعك الحالي أو حدد مكان العربية بنفسك من الخريطة.',
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.textMuted,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          _buildMap(context),
          SizedBox(height: ResponsiveSize.height(context, 1.4)),
          _buildChoiceButtons(context),
          SizedBox(height: ResponsiveSize.height(context, 1)),
          _buildStatusCard(context),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: SizedBox(
        height: ResponsiveSize.height(context, 28),
        child: FlutterMap(
          mapController: _mapController,
          options: _mapOptions,
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.moftah',
            ),
            MarkerLayer(
              markers: _buildMarkers(),
            ),
          ],
        ),
      ),
    );
  }

  List<Marker> _buildMarkers() {
    if (!_hasLocation) return const [];

    return [
      Marker(
        point: LatLng(_latitude!, _longitude!),
        width: ResponsiveSize.width(context, 11.79),
        height: ResponsiveSize.height(context, 5.45),
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: ResponsiveSize.width(context, 0.77),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .22),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.directions_car_rounded,
            color: Colors.white,
            size: ResponsiveSize.width(context, 5.9),
          ),
        ),
      ),
    ];
  }

  Widget _buildChoiceButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _choiceButton(
            context,
            icon: Icons.my_location_rounded,
            title: 'استخدم موقعي',
            selected: !_manualMode && _hasLocation,
            loading: _locating,
            onTap: _locating ? null : _useCurrentLocation,
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        Expanded(
          child: _choiceButton(
            context,
            icon: Icons.add_location_alt_rounded,
            title: 'حدد على الخريطة',
            selected: _manualMode,
            onTap: () {
              setState(() {
                _manualMode = true;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _choiceButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool selected,
    bool loading = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2.5),
          vertical: ResponsiveSize.height(context, 1.25),
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.secondary.withValues(alpha: .09)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: selected
                ? AppColors.secondary
                : AppColors.border.withValues(alpha: .15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            if (loading)
              SizedBox(
                width: ResponsiveSize.width(context, 5),
                height: ResponsiveSize.width(context, 5),
                child: CircularProgressIndicator(strokeWidth: ResponsiveSize.width(context, 0.62)),
              )
            else
              Icon(
                icon,
                color: selected ? AppColors.secondary : AppColors.primary,
              ),
            SizedBox(height: ResponsiveSize.height(context, .55)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: customText(
                text: title,
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: selected ? AppColors.secondary : AppColors.primary,
                isBold: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
      decoration: BoxDecoration(
        color: _hasLocation
            ? AppColors.success.withValues(alpha: .07)
            : AppColors.secondary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: _hasLocation
              ? AppColors.success.withValues(alpha: .18)
              : AppColors.secondary.withValues(alpha: .12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _hasLocation
                ? Icons.check_circle_rounded
                : Icons.touch_app_rounded,
            color: _hasLocation ? AppColors.success : AppColors.secondary,
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: customText(
              text: _hasLocation
                  ? 'تم تحديد مكان العربية'
                  : _manualMode
                      ? 'اضغط على المكان المطلوب داخل الخريطة'
                      : 'اضغط «استخدم موقعي» أو اختر المكان يدويًا',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.primary,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    if (_locating) return;

    setState(() {
      _locating = true;
      _manualMode = false;
    });

    final readiness = await LocationService.ensureLocationPermission();

    if (!mounted) return;

    if (readiness == LocationReadiness.permissionDeniedForever) {
      setState(() => _locating = false);
      _showSettingsMessage(openAppSettings: true);
      return;
    }

    if (readiness != LocationReadiness.ready) {
      setState(() => _locating = false);
      _showSettingsMessage();
      return;
    }

    final enabled = await LocationService.isLocationServiceEnabled();

    if (!mounted) return;

    if (!enabled) {
      setState(() => _locating = false);
      _showSettingsMessage(openLocationSettings: true);
      return;
    }

    final position = await LocationService.getCurrentPosition(
      forceRefresh: true,
    );

    if (!mounted) return;

    setState(() => _locating = false);

    if (position == null) {
      _showMessage(
        'مقدرناش نثبت موقعك. جرّب تاني أو حدده من الخريطة.',
      );
      return;
    }

    _setLocation(
      position.latitude,
      position.longitude,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _moveCamera(
        position.latitude,
        position.longitude,
      );
    });
  }

  void _selectManualLocation(LatLng point) {
    _setLocation(
      point.latitude,
      point.longitude,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _moveCamera(
        point.latitude,
        point.longitude,
        zoom: 16,
      );
    });
  }

  void _setLocation(double latitude, double longitude) {
    setState(() {
      _latitude = latitude;
      _longitude = longitude;
    });

    NearbyPlacesCache.instance.saveLocation(
      latitude,
      longitude,
    );

    widget.onLocationChanged(
      latitude,
      longitude,
    );
  }

  void _moveCamera(
    double latitude,
    double longitude, {
    double zoom = 16,
  }) {
    if (!_mapReady) return;

    try {
      _mapController.move(
        LatLng(latitude, longitude),
        zoom,
      );
    } catch (_) {
      // The map may be detaching during a route transition.
    }
  }

  void _showSettingsMessage({
    bool openAppSettings = false,
    bool openLocationSettings = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'محتاجين صلاحية الموقع وتشغيل GPS لتحديد مكان العربية.',
        ),
        action: SnackBarAction(
          label: 'الإعدادات',
          onPressed: () {
            if (openAppSettings) {
              LocationService.openAppSettings();
            } else if (openLocationSettings) {
              LocationService.openLocationSettings();
            }
          },
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
