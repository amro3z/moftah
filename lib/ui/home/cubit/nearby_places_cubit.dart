import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/domain/usecases/get_nearby_workshops_use_case.dart';
import 'package:moftah/domain/usecases/get_workshop_directory_use_case.dart';
import 'package:moftah/ui/home/cubit/nearby_places_state.dart';
import 'package:moftah/utils/location_service.dart';

class NearbyPlacesCubit extends Cubit<NearbyPlacesState> {
  final GetNearbyWorkshopsUseCase getNearbyWorkshopsUseCase;
  final GetWorkshopDirectoryUseCase getWorkshopDirectoryUseCase;

  NearbyPlacesCubit({
    required this.getNearbyWorkshopsUseCase,
    required this.getWorkshopDirectoryUseCase,
  }) : super(const NearbyPlacesInitial());

  Future<void> loadNearestWorkshops() async {
    emit(const NearbyPlacesLoading());

    try {
      final position = await LocationService.getCurrentPosition();

      if (position == null) {
        emit(const NearbyPlacesError('فعّل الموقع لعرض أقرب الورش'));
        return;
      }

      final places = await _retry(
        () => getNearbyWorkshopsUseCase(
          userLatitude: position.latitude,
          userLongitude: position.longitude,
        ),
      );

      if (places.isEmpty) {
        emit(const NearbyPlacesError('لم يتم العثور على ورش حتى نطاق 100 كم'));
        return;
      }

      emit(NearbyPlacesSuccess(places));
    } catch (_) {
      emit(const NearbyPlacesError('تعذر تحميل الورش القريبة'));
    }
  }

  Future<void> loadWorkshopDirectory({int maxPlaces = 80}) async {
    emit(const NearbyPlacesLoading());

    try {
      final position = await LocationService.getCurrentPosition();

      if (position == null) {
        emit(
          const NearbyPlacesError(
            'فعّل الموقع علشان نعرضلك الورش الأقرب ليك',
          ),
        );
        return;
      }

      final places = await _retry(
        () => getWorkshopDirectoryUseCase(
          userLatitude: position.latitude,
          userLongitude: position.longitude,
          maxPlaces: maxPlaces,
        ),
      );

      if (places.isEmpty) {
        emit(
          const NearbyPlacesError(
            'ملقيناش ورش مسجلة في نطاق 100 كم من موقعك',
          ),
        );
        return;
      }

      emit(NearbyPlacesSuccess(places));
    } catch (_) {
      emit(const NearbyPlacesError('حصلت مشكلة وإحنا بندور على الورش'));
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
