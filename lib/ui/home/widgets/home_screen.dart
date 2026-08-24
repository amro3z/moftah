import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/store/vehicle_selection_store.dart';
import 'package:moftah/data/store/service_request_store.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/ui/core/constant/home_options.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/app_loading_indicator.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/core/ui/section_title.dart';
import 'package:moftah/ui/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/home/cubit/nearby_places_state.dart';
import 'package:moftah/ui/home/widgets/current%20repair/current_repair_card.dart';
import 'package:moftah/ui/home/widgets/custom_appbar.dart';
import 'package:moftah/ui/home/widgets/home%20options/home_options_list.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/nearby_places_loading_indicator.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/nerbay_places.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/utils/vehicle_brand_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleStore = VehicleSelectionStore.instance;
    final serviceStore = ServiceRequestStore.instance;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: Listenable.merge([vehicleStore, serviceStore]),
        builder: (context, _) {
          final selectedVehicle = vehicleStore.selectedVehicle;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  customAppBar(
                    context,
                    userName: 'عمرو محمد',
                    data: selectedVehicle.card,
                    onChatTap: () {},
                    notificationCount: serviceStore.shouldShowOffersBanner
                        ? serviceStore.offers.length
                        : 0,
                    onNotificationTap: () => Navigator.pushNamed(
                      context,
                      '/notifications',
                    ),
                    onProfileTap: () => Navigator.pushNamed(
                      context,
                      '/profile',
                    ),
                    onVehicleSwitchTap: () => _showVehicleSwitcher(context),
                    onVehicleTap: () {
                      Navigator.pushNamed(
                        context,
                        '/vehicle-health',
                        arguments: selectedVehicle.health,
                      );
                    },
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 1.2)),
                  HomeOptionsList(options: HomeOptionsInfo.options),
                  SizedBox(height: ResponsiveSize.height(context, 1.5)),
                  const SectionTitle(title: 'الإصلاح الحالي'),
                  SizedBox(height: ResponsiveSize.height(context, 1)),
                  CurrentRepairCard(
                    data: CurrentRepairModel(
                      title: 'تغيير زيت المحرك + فلتر',
                      workshopName: 'Auto Pro Center',
                      location: 'مدينة نصر',
                      currentStage: RepairStage.approval,
                      vehicleName: '${selectedVehicle.card.carName} ${selectedVehicle.card.year}',
                      technicianName: 'محمد أحمد',
                      expectedFinish: '3:00 م',
                      estimatedCost: 1250,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/repair-details',
                        arguments: CurrentRepairModel(
                          title: 'تغيير زيت المحرك + فلتر',
                          workshopName: 'Auto Pro Center',
                          location: 'مدينة نصر',
                          currentStage: RepairStage.approval,
                          vehicleName: '${selectedVehicle.card.carName} ${selectedVehicle.card.year}',
                          technicianName: 'محمد أحمد',
                          expectedFinish: '3:00 م',
                          estimatedCost: 1250,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: ResponsiveSize.height(context, 1.5)),
                  _buildNearbyPlacesSection(context),
                  SizedBox(height: ResponsiveSize.height(context, 10.5)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showVehicleSwitcher(BuildContext context) {
    final store = VehicleSelectionStore.instance;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              ResponsiveSize.width(context, 5),
              ResponsiveSize.height(context, 1.2),
              ResponsiveSize.width(context, 5),
              ResponsiveSize.height(context, 3),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .22),
                  blurRadius: 28,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: ResponsiveSize.width(context, 10.77),
                    height: ResponsiveSize.height(context, 0.47),
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1.8)),
                customText(
                  text: 'اختار العربية',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                  color: AppColors.primary,
                  isBold: true,
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                ...List.generate(store.vehicles.length, (index) {
                  final vehicle = store.vehicles[index];
                  final selected = store.selectedIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, .8)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.secondary.withValues(alpha: .07)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(
                          color: selected
                              ? AppColors.secondary.withValues(alpha: .35)
                              : AppColors.border.withValues(alpha: .10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .16),
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          store.selectIndex(index);
                          Navigator.pop(sheetContext);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        ),
                        leading: VehicleBrandLogo(
                          brand: vehicle.card.brand,
                          logoUrl: vehicle.card.brandLogoUrl,
                          sizePercent: 11,
                        ),
                        title: customText(
                          text: vehicle.card.carName,
                          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                        subtitle: customText(
                          text: '${vehicle.card.year} • ${vehicle.card.mileage} كم',
                          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                          color: AppColors.textMuted,
                        ),
                        trailing: selected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.secondary,
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
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
                  arguments: MapRouteArguments(nearbyPlaces: places),
                );
              },
            ),
            SizedBox(height: ResponsiveSize.height(context, 1)),
            if (state is NearbyPlacesInitial)
              NearbyPlacesLoadingIndicator(
                state: const NearbyPlacesLoading(step: NearbyLoadingStep.checkingPermission),
              )
            else if (state is NearbyPlacesLoading)
              NearbyPlacesLoadingIndicator(state: state)
            else if (state is NearbyPlacesError)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 5),
                  vertical: ResponsiveSize.height(context, 1),
                ),
                child: AppRetryIndicator(
                  message: state.message,
                  onRetry: () async {
                    final cubit = context.read<NearbyPlacesCubit>();
                    await cubit.handleErrorAction(state);
                    await cubit.loadNearestWorkshops();
                  },
                ),
              )
            else if (state is NearbyPlacesSuccess)
              HomeNearbyPlacesList(nearbyPlaces: state.places),
          ],
        );
      },
    );
  }
}
