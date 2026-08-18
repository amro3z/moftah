import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/repos/nearby_places_repository.dart';
import 'package:moftah/domain/usecases/get_nearby_workshops_use_case.dart';
import 'package:moftah/domain/usecases/get_workshop_directory_use_case.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/ui/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/home/widgets/home_screen.dart';
import 'package:moftah/ui/map/widgets/map_screen.dart';
import 'package:moftah/ui/workshops/widgets/workshops_screen.dart';

class AppRoute {
  MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => _createNearbyPlacesCubit()
              ..loadNearestWorkshops(),
            child: const HomeScreen(),
          ),
        );

      case '/nearby-workshops':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => _createNearbyPlacesCubit()
              ..loadWorkshopDirectory(),
            child: const WorkshopsScreen(),
          ),
        );

      case '/map':
        HomeNearbyPlacesModel? selectedPlace;
        List<HomeNearbyPlacesModel> nearbyPlaces = const [];

        final arguments = settings.arguments;

        if (arguments is MapRouteArguments) {
          selectedPlace = arguments.selectedPlace;
          nearbyPlaces = arguments.nearbyPlaces;
        } else if (arguments is HomeNearbyPlacesModel) {
          selectedPlace = arguments;
          nearbyPlaces = [arguments];
        }

        return MaterialPageRoute(
          builder: (_) => MapScreen(
            selectedPlace: selectedPlace,
            initialNearbyPlaces: nearbyPlaces,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  NearbyPlacesCubit _createNearbyPlacesCubit() {
    final repository = NearbyPlacesRepository();

    return NearbyPlacesCubit(
      getNearbyWorkshopsUseCase: GetNearbyWorkshopsUseCase(repository),
      getWorkshopDirectoryUseCase: GetWorkshopDirectoryUseCase(repository),
    );
  }
}
