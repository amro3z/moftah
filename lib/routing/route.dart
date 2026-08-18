import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/models/vehicle_health_model.dart';
import 'package:moftah/data/repos/nearby_places_repository.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/routing/workshops_route_arguments.dart';
import 'package:moftah/ui/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/home/widgets/home_screen.dart';
import 'package:moftah/ui/map/widgets/map_screen.dart';
import 'package:moftah/ui/workshops/widgets/workshops_screen.dart';
import 'package:moftah/ui/vehicle_health/widgets/vehicle_health_screen.dart';

class AppRoute {
  MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => _createNearbyPlacesCubit()..loadNearestWorkshops(),
            child: const HomeScreen(),
          ),
        );

      case '/nearby-workshops':
        final arguments = settings.arguments;
        final workshopArguments =
            arguments is WorkshopsRouteArguments ? arguments : null;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) {
              final cubit = _createNearbyPlacesCubit();

              if (workshopArguments != null) {
                cubit.loadWorkshopDirectoryFromPosition(
                  userLatitude: workshopArguments.userLatitude,
                  userLongitude: workshopArguments.userLongitude,
                );
              } else {
                cubit.loadWorkshopDirectory();
              }

              return cubit;
            },
            child: WorkshopsScreen(
              userLatitude: workshopArguments?.userLatitude,
              userLongitude: workshopArguments?.userLongitude,
            ),
          ),
        );

      case '/vehicle-health':
        final arguments = settings.arguments;
        if (arguments is! VehicleHealthModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Vehicle health data is required')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => VehicleHealthScreen(data: arguments),
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
    return NearbyPlacesCubit(
      repository: NearbyPlacesRepository(),
    );
  }
}
