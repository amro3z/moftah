import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moftah/data/cache/nearby_places_cache.dart';
import 'package:moftah/data/models/car_owner/nerbay_places_model.dart';
import 'package:moftah/data/repos/nearby_places_repository.dart';
import 'package:moftah/ui/car_owner/home/cubit/nearby_places_state.dart';
import 'package:moftah/utils/internet_service.dart';
import 'package:moftah/utils/location_service.dart';

class NearbyPlacesCubit extends Cubit<NearbyPlacesState> {
  final NearbyPlacesRepository repository;
  final NearbyPlacesCache cache;

  NearbyPlacesCubit({
    required this.repository,
    NearbyPlacesCache? cache,
  })  : cache = cache ?? NearbyPlacesCache.instance,
        super(const NearbyPlacesInitial());

  Future<void> loadNearestWorkshops() async {
    // لو سبق وحددنا الموقع والورش في نفس جلسة التطبيق، نعرضهم فورًا
    // بدون طلب GPS جديد. ده مهم عند الرجوع للهوم بعد إرسال بلاغ.
    if (cache.hasLocation && cache.hasNearest) {
      final latitude = cache.userLatitude!;
      final longitude = cache.userLongitude!;

      emit(
        NearbyPlacesSuccess(
          cache.nearestPlaces,
          userLatitude: latitude,
          userLongitude: longitude,
        ),
      );

      unawaited(
        preloadWorkshopDirectoryFromPosition(
          userLatitude: latitude,
          userLongitude: longitude,
          maxPlaces: 50,
        ),
      );

      // لا نطلب GPS كل مرة. نراجع الموقع فقط لو آخر فحص قديم.
      if (cache.shouldRefreshLocation) {
        unawaited(_refreshSharedLocationIfNeeded());
      }

      return;
    }

    if (cache.hasLocation && !cache.shouldRefreshLocation) {
      return _loadNearestFromCoordinates(
        userLatitude: cache.userLatitude!,
        userLongitude: cache.userLongitude!,
      );
    }

    final position = await _prepareLocationAndInternet();
    if (position == null) return;

    return _loadNearestFromCoordinates(
      userLatitude: position.latitude,
      userLongitude: position.longitude,
    );
  }

  Future<void> _loadNearestFromCoordinates({
    required double userLatitude,
    required double userLongitude,
  }) async {
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
        () => repository.getNearestWorkshops(
          userLatitude: userLatitude,
          userLongitude: userLongitude,
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

      cache
        ..saveLocation(userLatitude, userLongitude)
        ..saveNearest(places);

      emit(
        NearbyPlacesSuccess(
          places,
          userLatitude: userLatitude,
          userLongitude: userLongitude,
        ),
      );

      // بعد إظهار أقرب 5 فورًا، نجهز دليل 50 ورشة في الخلفية بدون
      // ما نخفي كروت الهوم أو نطلب الـ GPS مرة ثانية.
      unawaited(
        preloadWorkshopDirectoryFromPosition(
          userLatitude: userLatitude,
          userLongitude: userLongitude,
          maxPlaces: 50,
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

  Future<void> loadWorkshopDirectory({int maxPlaces = 50}) async {
    // لو الهوم سبق وحدد الموقع، لا نطلب GPS مرة ثانية.
    if (cache.hasLocation) {
      return loadWorkshopDirectoryFromPosition(
        userLatitude: cache.userLatitude!,
        userLongitude: cache.userLongitude!,
        maxPlaces: maxPlaces,
      );
    }

    final position = await _prepareLocationAndInternet();
    if (position == null) return;

    return loadWorkshopDirectoryFromPosition(
      userLatitude: position.latitude,
      userLongitude: position.longitude,
      maxPlaces: maxPlaces,
    );
  }

  Future<void> loadWorkshopDirectoryFromPosition({
    required double userLatitude,
    required double userLongitude,
    int maxPlaces = 50,
  }) async {
    cache.saveLocation(userLatitude, userLongitude);

    if (cache.hasDirectory) {
      emit(
        NearbyPlacesSuccess(
          cache.directoryPlaces.take(maxPlaces).toList(),
          userLatitude: userLatitude,
          userLongitude: userLongitude,
        ),
      );
      return;
    }

    // لو الـ50 لسه بيتحملوا، اعرض أقرب 5 فورًا وخلي Loading صغير فقط.
    if (cache.hasNearest) {
      emit(
        NearbyPlacesSuccess(
          cache.nearestPlaces,
          userLatitude: userLatitude,
          userLongitude: userLongitude,
          isLoadingMore: true,
        ),
      );
    } else {
      emit(
        const NearbyPlacesLoading(
          step: NearbyLoadingStep.checkingInternet,
        ),
      );
    }

    // لو الـHome بدأ بالفعل تحميل الـ50 في الخلفية، ما نعملش Request مكرر.
    if (cache.isDirectoryLoading) {
      for (var i = 0; i < 40 && cache.isDirectoryLoading; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      if (cache.hasDirectory) {
        emit(
          NearbyPlacesSuccess(
            cache.directoryPlaces.take(maxPlaces).toList(),
            userLatitude: userLatitude,
            userLongitude: userLongitude,
          ),
        );
        return;
      }
    }

    final hasInternet = await InternetService.hasInternetAccess();
    if (!hasInternet) {
      if (cache.hasNearest) {
        emit(
          NearbyPlacesSuccess(
            cache.nearestPlaces,
            userLatitude: userLatitude,
            userLongitude: userLongitude,
          ),
        );
      } else {
        emit(
          const NearbyPlacesError(
            'مفيش اتصال إنترنت فعلي. شغّل Wi-Fi أو بيانات الموبايل وجرّب تاني.',
          ),
        );
      }
      return;
    }

    try {
      final places = await _retry(
        () => repository.getWorkshopDirectory(
          userLatitude: userLatitude,
          userLongitude: userLongitude,
          maxPlaces: maxPlaces,
          onSearchRadius: (radiusMeters) {
            if (!cache.hasNearest) {
              emit(
                NearbyPlacesLoading(
                  step: NearbyLoadingStep.searchingWorkshops,
                  searchRadiusMeters: radiusMeters,
                ),
              );
            }
          },
        ),
      );

      if (places.isEmpty) {
        if (cache.hasNearest) {
          emit(
            NearbyPlacesSuccess(
              cache.nearestPlaces,
              userLatitude: userLatitude,
              userLongitude: userLongitude,
            ),
          );
        } else {
          emit(
            const NearbyPlacesError(
              'دورنا لحد 100 كم، لكن ملقيناش ورش مسجلة حوالين موقعك.',
            ),
          );
        }
        return;
      }

      cache.saveDirectory(places);
      emit(
        NearbyPlacesSuccess(
          places,
          userLatitude: userLatitude,
          userLongitude: userLongitude,
        ),
      );
    } catch (_) {
      if (cache.hasNearest) {
        emit(
          NearbyPlacesSuccess(
            cache.nearestPlaces,
            userLatitude: userLatitude,
            userLongitude: userLongitude,
          ),
        );
      } else {
        emit(
          const NearbyPlacesError(
            'حصلت مشكلة وإحنا بنجمع الورش. جرّب تاني بعد لحظة.',
          ),
        );
      }
    }
  }

  Future<void> preloadWorkshopDirectoryFromPosition({
    required double userLatitude,
    required double userLongitude,
    int maxPlaces = 50,
  }) async {
    if (cache.hasDirectory || cache.isDirectoryLoading) return;

    cache.isDirectoryLoading = true;
    try {
      final places = await repository.getWorkshopDirectory(
        userLatitude: userLatitude,
        userLongitude: userLongitude,
        maxPlaces: maxPlaces,
      );
      if (places.isNotEmpty) cache.saveDirectory(places);
    } catch (_) {
      // Preload صامت؛ الشاشة ستعمل Retry عند الحاجة.
    } finally {
      cache.isDirectoryLoading = false;
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

    final moved = cache.saveLocationIfChanged(
      position.latitude,
      position.longitude,
    );

    if (moved) {
      // لو المستخدم اتحرك أكتر من الحد المحدد، بيانات الورش القديمة
      // ما ينفعش نعتبرها قريبة من الموقع الجديد.
      cache.clearPlaces();
      cache.saveLocation(position.latitude, position.longitude);
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

  Future<void> _refreshSharedLocationIfNeeded() async {
    if (!cache.shouldRefreshLocation) return;

    final position = await LocationService.getCurrentPosition(
      forceRefresh: true,
    );

    if (position == null || isClosed) return;

    final moved = cache.saveLocationIfChanged(
      position.latitude,
      position.longitude,
    );

    if (!moved) return;

    // اتحركنا فعلًا لمسافة معتبرة، فنحدّث الورش مرة واحدة بالموقع الجديد.
    await _loadNearestFromCoordinates(
      userLatitude: position.latitude,
      userLongitude: position.longitude,
    );
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
          await Future<void>.delayed(const Duration(milliseconds: 700));
        }
      }
    }

    throw lastError ?? Exception('Nearby workshops request failed');
  }
}
