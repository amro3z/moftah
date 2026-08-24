import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/models/vehicle_health_model.dart';
import 'package:moftah/data/repos/nearby_places_repository.dart';
import 'package:moftah/data/repos/obd_repository.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/routing/workshops_route_arguments.dart';
import 'package:moftah/ui/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/home/widgets/home_screen.dart';
import 'package:moftah/ui/map/widgets/map_screen.dart';
import 'package:moftah/ui/workshops/widgets/workshops_screen.dart';
import 'package:moftah/ui/vehicle_health/widgets/vehicle_health_screen.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/ui/repair/repair_details_screen.dart';
import 'package:moftah/ui/repair/repair_chat_screen.dart';
import 'package:moftah/ui/repair/repair_offer_screen.dart';
import 'package:moftah/data/models/problem_report_model.dart';
import 'package:moftah/routing/report_workshops_route_arguments.dart';
import 'package:moftah/ui/report_problem/report_problem_flow_screen.dart';
import 'package:moftah/ui/report_problem/problem_analysis_screen.dart';
import 'package:moftah/ui/report_problem/report_workshops_screen.dart';
import 'package:moftah/ui/report_problem/received_offers_screen.dart';
import 'package:moftah/ui/report_problem/report_technicians_screen.dart';
import 'package:moftah/ui/report_problem/offer_details_screen.dart';
import 'package:moftah/data/models/service_offer_model.dart';
import 'package:moftah/ui/notifications/notifications_screen.dart';
import 'package:moftah/ui/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:moftah/ui/spare_parts/spare_parts_screen.dart';
import 'package:moftah/ui/spare_parts/spare_part_details_screen.dart';
import 'package:moftah/ui/spare_parts/spare_parts_cart_screen.dart';
import 'package:moftah/ui/spare_parts/spare_parts_favorites_screen.dart';

class AppRoute {
  final SparePartsCubit _sparePartsCubit = SparePartsCubit();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
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


      case '/report-problem':
        return _animatedRoute(const ReportProblemFlowScreen());

      case '/problem-analysis':
        final arguments = settings.arguments;
        if (arguments is! ProblemReportModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Problem report data is required')),
            ),
          );
        }
        return _animatedRoute(ProblemAnalysisScreen(report: arguments));

      case '/report-workshops':
        final arguments = settings.arguments;
        if (arguments is! ReportWorkshopsRouteArguments) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Report workshop data is required')),
            ),
          );
        }
        return _animatedRoute(
          BlocProvider(
            create: (_) => _createNearbyPlacesCubit()
              ..loadWorkshopDirectoryFromPosition(
                userLatitude: arguments.userLatitude,
                userLongitude: arguments.userLongitude,
                maxPlaces: 50,
              ),
            child: ReportWorkshopsScreen(
              report: arguments.report,
              userLatitude: arguments.userLatitude,
              userLongitude: arguments.userLongitude,
            ),
          ),
        );

      case '/report-technicians':
        final arguments = settings.arguments;
        if (arguments is! ProblemReportModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Problem report data is required')),
            ),
          );
        }
        return _animatedRoute(ReportTechniciansScreen(report: arguments));



      case '/spare-parts':
        return _animatedRoute(
          BlocProvider.value(
            value: _sparePartsCubit..syncVehiclesFromAccount(),
            child: const SparePartsScreen(),
          ),
        );

      case '/spare-part-details':
        final arguments = settings.arguments;
        if (arguments is! String) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Spare part id is required')),
            ),
          );
        }
        return _animatedRoute(
          BlocProvider.value(
            value: _sparePartsCubit,
            child: SparePartDetailsScreen(productId: arguments),
          ),
        );

      case '/spare-parts-cart':
        return _animatedRoute(
          BlocProvider.value(
            value: _sparePartsCubit,
            child: const SparePartsCartScreen(),
          ),
        );

      case '/spare-parts-favorites':
        return _animatedRoute(
          BlocProvider.value(
            value: _sparePartsCubit,
            child: const SparePartsFavoritesScreen(),
          ),
        );

      case '/notifications':
        return _animatedRoute(const NotificationsScreen());

      case '/received-offers':
        return _animatedRoute(const ReceivedOffersScreen());

      case '/offer-details':
        final arguments = settings.arguments;
        if (arguments is! ServiceOfferModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Offer data is required')),
            ),
          );
        }
        return _animatedRoute(OfferDetailsScreen(offer: arguments));

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
          builder: (_) => BlocProvider(
            create: (_) => ObdCubit(
              repository: ObdRepository(),
            )..loadPairedDevices(),
            child: VehicleHealthScreen(data: arguments),
          ),
        );


      case '/repair-details':
        final arguments = settings.arguments;
        final repair = arguments is CurrentRepairModel
            ? arguments
            : const CurrentRepairModel(
                title: 'تغيير زيت المحرك + فلتر',
                workshopName: 'Auto Pro Center',
                location: 'مدينة نصر',
                currentStage: RepairStage.approval,
              );
        return MaterialPageRoute(
          builder: (_) => RepairDetailsScreen(data: repair),
        );

      case '/repair-chat':
        final arguments = settings.arguments;
        if (arguments is! CurrentRepairModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Repair data is required')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => RepairChatScreen(data: arguments),
        );

      case '/repair-offer':
        final arguments = settings.arguments;
        if (arguments is! CurrentRepairModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Repair offer data is required')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => RepairOfferScreen(data: arguments),
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


  Route<dynamic> _animatedRoute(Widget child) {
    return PageRouteBuilder<dynamic>(
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, animation, __) => child,
      transitionsBuilder: (_, animation, __, page) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(.045, 0), end: Offset.zero).animate(curved),
            child: page,
          ),
        );
      },
    );
  }

  NearbyPlacesCubit _createNearbyPlacesCubit() {
    return NearbyPlacesCubit(
      repository: NearbyPlacesRepository(),
    );
  }
}
