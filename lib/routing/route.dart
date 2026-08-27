import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/car_owner/nerbay_places_model.dart';
import 'package:moftah/data/models/vehicle_card/vehicle_health_model.dart';
import 'package:moftah/data/repos/nearby_places_repository.dart';
import 'package:moftah/data/repos/obd_repository.dart';
import 'package:moftah/ui/register/register_screen.dart';
import 'package:moftah/ui/auth/login_screen.dart';
import 'package:moftah/ui/onboarding/onboarding_screen.dart';
import 'package:moftah/ui/onboarding/role_selection_screen.dart';
import 'package:moftah/ui/car_owner/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/routing/workshops_route_arguments.dart';
import 'package:moftah/ui/car_owner/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/car_owner/home/widgets/customer_home.dart';
import 'package:moftah/ui/car_owner/map/widgets/map_screen.dart';
import 'package:moftah/ui/car_owner/workshops/widgets/workshops_screen.dart';
import 'package:moftah/ui/car_owner/vehicle_health/widgets/vehicle_health_screen.dart';
import 'package:moftah/data/models/car_owner/current_repair_model.dart';
import 'package:moftah/ui/car_owner/repair/repair_details_screen.dart';
import 'package:moftah/ui/car_owner/repair/repair_chat_screen.dart';
import 'package:moftah/ui/car_owner/repair/repair_offer_screen.dart';
import 'package:moftah/data/models/report/problem_report_model.dart';
import 'package:moftah/routing/report_workshops_route_arguments.dart';
import 'package:moftah/ui/car_owner/report_problem/report_problem_flow_screen.dart';
import 'package:moftah/ui/car_owner/report_problem/problem_analysis_screen.dart';
import 'package:moftah/ui/car_owner/report_problem/report_workshops_screen.dart';
import 'package:moftah/ui/car_owner/report_problem/received_offers_screen.dart';
import 'package:moftah/ui/car_owner/report_problem/report_technicians_screen.dart';
import 'package:moftah/ui/car_owner/report_problem/offer_details_screen.dart';
import 'package:moftah/data/models/car_owner/service_offer_model.dart';
import 'package:moftah/ui/notifications/notifications_screen.dart';
import 'package:moftah/ui/car_owner/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:moftah/ui/car_owner/spare_parts/spare_parts_screen.dart';
import 'package:moftah/ui/car_owner/spare_parts/spare_part_details_screen.dart';
import 'package:moftah/ui/car_owner/spare_parts/spare_parts_cart_screen.dart';
import 'package:moftah/ui/car_owner/spare_parts/spare_parts_favorites_screen.dart';
import 'package:moftah/data/models/chat_screen_model.dart';
import 'package:moftah/ui/car_owner/emergency/emergency_screen.dart';
import 'package:moftah/data/models/car_owner/profile_history_models.dart';
import 'package:moftah/ui/car_owner/profile/profile_screen.dart';
import 'package:moftah/ui/car_owner/profile/spare_part_orders_screen.dart';
import 'package:moftah/ui/car_owner/profile/spare_part_order_details_screen.dart';
import 'package:moftah/ui/car_owner/profile/worker_requests_screen.dart';
import 'package:moftah/ui/car_owner/profile/worker_request_details_screen.dart';
import 'package:moftah/ui/car_owner/profile/chat_history_screen.dart';
import 'package:moftah/ui/technician/home/technician_home.dart';
import 'package:moftah/data/models/technician/technician_models.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/technician/requests/technician_requests_screen.dart';
import 'package:moftah/ui/technician/requests/technician_request_details_screen.dart';
import 'package:moftah/ui/technician/requests/send_offer_screen.dart';
import 'package:moftah/ui/technician/works/technician_works_screen.dart';
import 'package:moftah/ui/technician/chats/technician_chats_screen.dart';
import 'package:moftah/ui/technician/profile/technician_profile_screen.dart';

class AppRoute {
  final SparePartsCubit _sparePartsCubit = SparePartsCubit();

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/customer_home':
        return _animatedRoute(BlocProvider(
            create: (_) => _createNearbyPlacesCubit()..loadNearestWorkshops(),
            child: const CustomerHomeScreen(),
          ));

      case '/nearby-workshops':
        final arguments = settings.arguments;
        final workshopArguments =
            arguments is WorkshopsRouteArguments ? arguments : null;

        return _animatedRoute(BlocProvider(
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
          ));
      case '/technician_home':
        return _animatedRoute(const TechnicianHome());
      case '/technician/requests':
        return _animatedRoute(const TechnicianRequestsScreen());
      case '/technician/request-details':
        final arg = settings.arguments;
        TechnicianRequestModel? request;
        if (arg is TechnicianRequestModel) request = arg;
        if (arg is String) {
          try { request = TechnicianStore.instance.byId(arg); } catch (_) {}
        }
        if (request == null) return _animatedRoute(const Scaffold(body: Center(child: Text('Request data is required'))));
        return _animatedRoute(TechnicianRequestDetailsScreen(request: request));
      case '/technician/send-offer':
        final arg = settings.arguments;
        if (arg is! TechnicianRequestModel) return _animatedRoute(const Scaffold(body: Center(child: Text('Request data is required'))));
        return _animatedRoute(SendOfferScreen(request: arg));
      case '/technician/works':
        return _animatedRoute(const TechnicianWorksScreen());
      case '/technician/chats':
        return _animatedRoute(const TechnicianChatsScreen());
      case '/technician/profile':
        return _animatedRoute(const TechnicianProfileScreen());
      case '/emergency':
        return _animatedRoute(const EmergencyScreen());
      
      case '/onboarding':
        return _animatedRoute(const OnboardingScreen());

      case '/role-selection':
        return _animatedRoute(const RoleSelectionScreen());

      case '/login':
        final role = settings.arguments is AppUserRole
            ? settings.arguments as AppUserRole
            : null;
        return _animatedRoute(LoginScreen(selectedRole: role));

      case '/register':
        return _animatedRoute(const RegisterScreen());

      case '/chat':
        final arguments = settings.arguments;
        if (arguments is! ChatScreenModel) {
          return _animatedRoute(const Scaffold(
              body: Center(
                child: Text('Chat data is required'),
              ),
            ));
        }
        return _animatedRoute(
          RepairChatScreen(data: arguments),
        );

      case '/profile':
        return _animatedRoute(const ProfileScreen());

      case '/profile/spare-orders':
        return _animatedRoute(const SparePartOrdersScreen());

      case '/profile/spare-order-details':
        final arguments = settings.arguments;
        if (arguments is! SparePartOrderModel) {
          return _animatedRoute(const Scaffold(
              body: Center(
                child: Text('Spare part order data is required'),
              ),
            ));
        }
        return _animatedRoute(
          SparePartOrderDetailsScreen(order: arguments),
        );

      case '/profile/worker-requests':
        return _animatedRoute(const WorkerRequestsScreen());

      case '/profile/worker-request-details':
        final arguments = settings.arguments;
        if (arguments is! WorkerRequestHistoryModel) {
          return _animatedRoute(const Scaffold(
              body: Center(
                child: Text('Worker request data is required'),
              ),
            ));
        }
        return _animatedRoute(
          WorkerRequestDetailsScreen(request: arguments),
        );

      case '/profile/chats':
        return _animatedRoute(const ChatHistoryScreen());

      case '/report-problem':
        return _animatedRoute(const ReportProblemFlowScreen());

      case '/problem-analysis':
        final arguments = settings.arguments;
        if (arguments is! ProblemReportModel) {
          return _animatedRoute(const Scaffold(
              body: Center(child: Text('Problem report data is required')),
            ));
        }
        return _animatedRoute(ProblemAnalysisScreen(report: arguments));

      case '/report-workshops':
        final arguments = settings.arguments;
        if (arguments is! ReportWorkshopsRouteArguments) {
          return _animatedRoute(const Scaffold(
              body: Center(child: Text('Report workshop data is required')),
            ));
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
          return _animatedRoute(const Scaffold(
              body: Center(child: Text('Problem report data is required')),
            ));
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
          return _animatedRoute(const Scaffold(
              body: Center(child: Text('Spare part id is required')),
            ));
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
          return _animatedRoute(const Scaffold(
              body: Center(child: Text('Offer data is required')),
            ));
        }
        return _animatedRoute(OfferDetailsScreen(offer: arguments));

      case '/vehicle-health':
        final arguments = settings.arguments;
        if (arguments is! VehicleHealthModel) {
          return _animatedRoute(const Scaffold(
              body: Center(child: Text('Vehicle health data is required')),
            ));
        }
        return _animatedRoute(BlocProvider(
            create: (_) => ObdCubit(
              repository: ObdRepository(),
            )..loadPairedDevices(),
            child: VehicleHealthScreen(data: arguments),
          ));


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
        return _animatedRoute(RepairDetailsScreen(data: repair));

      case '/repair-chat':
        final arguments = settings.arguments;
        if (arguments is! CurrentRepairModel) {
          return _animatedRoute(const Scaffold(
              body: Center(child: Text('Repair data is required')),
            ));
        }
        return _animatedRoute(RepairChatScreen(
            data: ChatScreenModel.fromRepair(arguments),
          ));

      case '/repair-offer':
        final arguments = settings.arguments;
        if (arguments is! CurrentRepairModel) {
          return _animatedRoute(const Scaffold(
              body: Center(child: Text('Repair offer data is required')),
            ));
        }
        return _animatedRoute(RepairOfferScreen(data: arguments));

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

        return _animatedRoute(MapScreen(
            selectedPlace: selectedPlace,
            initialNearbyPlaces: nearbyPlaces,
          ));

      default:
        return _animatedRoute(Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ));
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
