import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/ui/core/constant/home_options.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/app_loading_indicator.dart';
import 'package:moftah/ui/core/ui/section_title.dart';
import 'package:moftah/ui/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/home/cubit/nearby_places_state.dart';
import 'package:moftah/ui/home/widgets/current%20repair/current_repair_card.dart';
import 'package:moftah/ui/home/widgets/custom_appbar.dart';
import 'package:moftah/ui/home/widgets/home%20options/home_options_list.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/nerbay_places.dart';
import 'package:moftah/utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              customAppBar(
                context,
                userName: 'عمرو محمد',
                data: VehicleCardModel(
                  carName: 'Toyota Corolla',
                  year: 2020,
                  mileage: 100008,
                  healthScore: 85,
                  maintenanceStatus: MaintenanceStatus.good,
                  documentStatus: DocumentStatus.verified,
                  imageUrl:
                      'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=1200',
                  nextMaintenance: 1500,
                  lastMaintenance: '15 مارس',
                  repairStatus: RepairStatus.good,
                ),
                onChatTap: () {},
                onVehicleTap: () {},
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.5)),
              HomeOptionsList(options: HomeOptionsInfo.options),
              SizedBox(height: ResponsiveSize.height(context, 1.5)),
              const SectionTitle(title: 'الإصلاح الحالي'),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              CurrentRepairCard(
                data: const CurrentRepairModel(
                  title: 'تغيير زيت المحرك + فلتر',
                  workshopName: 'Auto Pro Center',
                  location: 'مدينة نصر',
                  currentStage: RepairStage.repairing,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/repair-details');
                },
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.5)),
              _buildNearbyPlacesSection(context),
              SizedBox(height: ResponsiveSize.height(context, 10.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyPlacesSection(BuildContext context) {
    return BlocBuilder<NearbyPlacesCubit, NearbyPlacesState>(
      builder: (context, state) {
       final List<HomeNearbyPlacesModel> places = state is NearbyPlacesSuccess
            ? state.places
            : const <HomeNearbyPlacesModel>[];

        return Column(
          children: [
            SectionTitle(
              title: 'ورش قريبة منك',
              actionText: 'عرض الخريطة',
              onActionTap: () {
                Navigator.pushNamed(
                  context,
                  '/map',
                  arguments: MapRouteArguments(
                    nearbyPlaces: places,
                  ),
                );
              },
            ),
            SizedBox(height: ResponsiveSize.height(context, 1)),
            if (state is NearbyPlacesInitial || state is NearbyPlacesLoading)
              SizedBox(
                height: ResponsiveSize.height(context, 13),
                child: const Center(
                  child: AppLoadingIndicator(
                    message: 'بندور على أقرب الورش ليك...',
                  ),
                ),
              )
            else if (state is NearbyPlacesError)
              SizedBox(
                height: ResponsiveSize.height(context, 17),
                child: Center(
                  child: AppRetryIndicator(
                    message: state.message,
                    onRetry: context.read<NearbyPlacesCubit>().loadNearestWorkshops,
                  ),
                ),
              )
            else if (state is NearbyPlacesSuccess)
              HomeNearbyPlacesList(
                nearbyPlaces: state.places,
              ),
          ],
        );
      },
    );
  }
}
