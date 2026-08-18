import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/repos/nearby_places_repository.dart';
import 'package:moftah/ui/home/cubit/nearby_places_state.dart';
import 'package:moftah/utils/internet_service.dart';
import 'package:moftah/utils/location_service.dart';

class NearbyPlacesCubit extends Cubit<NearbyPlacesState> {
  final NearbyPlacesRepository repository;

  NearbyPlacesCubit({
    required this.repository,
  }) : super(const NearbyPlacesInitial());

  Future<void> loadNearestWorkshops() async {
    final position = await _prepareLocationAndInternet();
    if (position == null) return;

    try {
      final places = await _retry(
        () => repository.getNearestWorkshops(
          userLatitude: position.latitude,
          userLongitude: position.longitude,
          onSearchRadius: (radiusMeters) {
            emit(
              NearbyPlacesLoading(
                step: NearbyLoadingStep.searchingWorkshops,
                searchRadiusMeters: radiusMeters,
              ),
            );
          },
        ),
      );

      if (places.isEmpty) {
        emit(
          const NearbyPlacesError(
            'دورنا لحد 100 كم، لكن ملقيناش ورش مسجلة حوالين موقعك.',
          ),
        );
        return;
      }

      emit(
        NearbyPlacesSuccess(
          places,
          userLatitude: position.latitude,
          userLongitude: position.longitude,
        ),
      );
    } catch (_) {
      emit(
        const NearbyPlacesError(
          'حصلت مشكلة وإحنا بندور على الورش. جرّب تاني بعد لحظة.',
        ),
      );
    }
  }

  Future<void> loadWorkshopDirectory({int maxPlaces = 80}) async {
    final position = await _prepareLocationAndInternet();
    if (position == null) return;

    try {
      final places = await _retry(
        () => repository.getWorkshopDirectory(
          userLatitude: position.latitude,
          userLongitude: position.longitude,
          maxPlaces: maxPlaces,
          onSearchRadius: (radiusMeters) {
            emit(
              NearbyPlacesLoading(
                step: NearbyLoadingStep.searchingWorkshops,
                searchRadiusMeters: radiusMeters,
              ),
            );
          },
        ),
      );

      if (places.isEmpty) {
        emit(
          const NearbyPlacesError(
            'دورنا لحد 100 كم، لكن ملقيناش ورش مسجلة حوالين موقعك.',
          ),
        );
        return;
      }

      emit(
        NearbyPlacesSuccess(
          places,
          userLatitude: position.latitude,
          userLongitude: position.longitude,
        ),
      );
    } catch (_) {
      emit(
        const NearbyPlacesError(
          'حصلت مشكلة وإحنا بنجمع الورش. جرّب تاني بعد لحظة.',
        ),
      );
    }
  }

  Future<void> loadWorkshopDirectoryFromPosition({
    required double userLatitude,
    required double userLongitude,
    int maxPlaces = 80,
  }) async {
    emit(
      const NearbyPlacesLoading(
        step: NearbyLoadingStep.checkingInternet,
      ),
    );

    final hasInternet = await InternetService.hasInternetAccess();
    if (!hasInternet) {
      emit(
        const NearbyPlacesError(
          'مفيش اتصال إنترنت فعلي. شغّل Wi-Fi أو بيانات الموبايل وجرّب تاني.',
        ),
      );
      return;
    }

    try {
      final places = await _retry(
        () => repository.getWorkshopDirectory(
          userLatitude: userLatitude,
          userLongitude: userLongitude,
          maxPlaces: maxPlaces,
          onSearchRadius: (radiusMeters) {
            emit(
              NearbyPlacesLoading(
                step: NearbyLoadingStep.searchingWorkshops,
                searchRadiusMeters: radiusMeters,
              ),
            );
          },
        ),
      );

      if (places.isEmpty) {
        emit(
          const NearbyPlacesError(
            'دورنا لحد 100 كم، لكن ملقيناش ورش مسجلة حوالين موقعك.',
          ),
        );
        return;
      }

      emit(
        NearbyPlacesSuccess(
          places,
          userLatitude: userLatitude,
          userLongitude: userLongitude,
        ),
      );
    } catch (_) {
      emit(
        const NearbyPlacesError(
          'حصلت مشكلة وإحنا بنجمع الورش. جرّب تاني بعد لحظة.',
        ),
      );
    }
  }

  Future<Position?> _prepareLocationAndInternet() async {
    emit(
      const NearbyPlacesLoading(
        step: NearbyLoadingStep.checkingPermission,
      ),
    );

    final permissionReadiness =
        await LocationService.ensureLocationPermission();

    if (permissionReadiness == LocationReadiness.permissionDeniedForever) {
      emit(
        const NearbyPlacesError(
          'صلاحية الموقع مقفولة نهائيًا للتطبيق. افتح إعدادات التطبيق وفعّل الموقع.',
          openAppSettings: true,
        ),
      );
      return null;
    }

    if (permissionReadiness == LocationReadiness.permissionDenied) {
      emit(
        const NearbyPlacesError(
          'محتاجين صلاحية الموقع علشان نقدر نجيب أقرب الورش ليك.',
        ),
      );
      return null;
    }

    emit(
      const NearbyPlacesLoading(
        step: NearbyLoadingStep.checkingLocationService,
      ),
    );

    final locationEnabled =
        await LocationService.isLocationServiceEnabled();

    if (!locationEnabled) {
      emit(
        const NearbyPlacesError(
          'الـ GPS مقفول. افتح إعدادات الموقع وشغّله وبعدها جرّب تاني.',
          openLocationSettings: true,
        ),
      );
      return null;
    }

    emit(
      const NearbyPlacesLoading(
        step: NearbyLoadingStep.locatingUser,
      ),
    );

    final position = await LocationService.getCurrentPosition(
      forceRefresh: true,
      skipReadinessCheck: true,
    );

    if (position == null) {
      emit(
        const NearbyPlacesError(
          'الصلاحية والـ GPS تمام، لكن الموبايل لسه مقدرش يثبت موقعك. جرّب تاني في مكان مفتوح أو استنى ثواني.',
        ),
      );
      return null;
    }

    emit(
      const NearbyPlacesLoading(
        step: NearbyLoadingStep.checkingInternet,
      ),
    );

    final hasInternet = await InternetService.hasInternetAccess();

    if (!hasInternet) {
      emit(
        const NearbyPlacesError(
          'مفيش اتصال إنترنت فعلي. شغّل Wi-Fi أو بيانات الموبايل وجرّب تاني.',
        ),
      );
      return null;
    }

    return position;
  }

  Future<void> handleErrorAction(NearbyPlacesError error) async {
    if (error.openAppSettings) {
      await LocationService.openAppSettings();
      return;
    }

    if (error.openLocationSettings) {
      await LocationService.openLocationSettings();
    }
  }

  Future<List<HomeNearbyPlacesModel>> _retry(
    Future<List<HomeNearbyPlacesModel>> Function() action,
  ) async {
    Object? lastError;

    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        return await action();
      } catch (error) {
        lastError = error;

        if (attempt == 0) {
          await Future<void>.delayed(
            const Duration(milliseconds: 700),
          );
        }
      }
    }

    throw lastError ?? Exception('Nearby workshops request failed');
  }
}
