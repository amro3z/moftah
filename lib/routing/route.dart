import 'package:flutter/material.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/ui/home/widgets/home_screen.dart';
import 'package:moftah/ui/map/widgets/map_screen.dart';

class AppRoute {
  MaterialPageRoute<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
       case '/map':
        final place = settings.arguments as HomeNearbyPlacesModel?;

        return MaterialPageRoute(
          builder: (_) => MapScreen(selectedPlace: place),
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
}
