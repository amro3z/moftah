import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/app_loading_indicator.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/home/cubit/nearby_places_state.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/nearby_places_loading_indicator.dart';
import 'package:moftah/ui/workshops/widgets/workshop_directory_card.dart';
import 'package:moftah/utils/responsive.dart';

class WorkshopsScreen extends StatelessWidget {
  final double? userLatitude;
  final double? userLongitude;

  const WorkshopsScreen({
    super.key,
    this.userLatitude,
    this.userLongitude,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<NearbyPlacesCubit, NearbyPlacesState>(
            builder: (context, state) {
              final places = state is NearbyPlacesSuccess
                  ? state.places
                  : const [];

              final loadingMore = state is NearbyPlacesSuccess && state.isLoadingMore;

              return Column(
                children: [
                  _header(context, places.length),
                  if (loadingMore)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(context, 5),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.width(context, 3),
                          vertical: ResponsiveSize.height(context, .8),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: .07),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2.2),
                            ),
                            SizedBox(width: ResponsiveSize.width(context, 2)),
                            Expanded(
                              child: customText(
                                text: 'عرضنا أقرب ${places.length} ورش وبنكمل تحميل باقي النتائج حتى 50...',
                                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                                color: AppColors.primary,
                                isBold: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: _body(context, state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, int placesCount) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 1.2),
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 1.2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: 'الورش ومراكز الصيانة',
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontXl,
                      ),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    customText(
                      text: 'مرتبة حسب الأقرب لموقعك',
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontSm,
                      ),
                      color: AppColors.progressBackground,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: placesCount == 0
                    ? null
                    : () {
                        Navigator.pushNamed(
                          context,
                          '/map',
                          arguments: const MapRouteArguments(),
                        );
                      },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.width(context, 3),
                    vertical: ResponsiveSize.height(context, 0.9),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.map_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: ResponsiveSize.width(context, 1)),
                      customText(
                        text: 'الخريطة',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: Colors.white,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (placesCount > 0) ...[
            SizedBox(height: ResponsiveSize.height(context, 1.2)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 3),
                vertical: ResponsiveSize.height(context, 0.8),
              ),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: customText(
                text:
                    'لقينالك $placesCount ورشة ومركز صيانة • اضغط على أي مكان علشان تشوفه على الخريطة',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                color: AppColors.primary,
                isBold: true,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _body(BuildContext context, NearbyPlacesState state) {
    if (state is NearbyPlacesInitial) {
      return const SingleChildScrollView(
        child: NearbyPlacesLoadingIndicator(
          state: NearbyPlacesLoading(
            step: NearbyLoadingStep.checkingPermission,
          ),
          directoryMode: true,
        ),
      );
    }

    if (state is NearbyPlacesLoading) {
      return SingleChildScrollView(
        child: NearbyPlacesLoadingIndicator(
          state: state,
          directoryMode: true,
        ),
      );
    }

    if (state is NearbyPlacesError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 5),
          ),
          child: AppRetryIndicator(
            message: state.message,
            onRetry: () async {
              final cubit = context.read<NearbyPlacesCubit>();
              await cubit.handleErrorAction(state);

              if (userLatitude != null && userLongitude != null) {
                await cubit.loadWorkshopDirectoryFromPosition(
                  userLatitude: userLatitude!,
                  userLongitude: userLongitude!,
                );
              } else {
                await cubit.loadWorkshopDirectory();
              }
            },
          ),
        ),
      );
    }

    final places = (state as NearbyPlacesSuccess).places;

    return RefreshIndicator(
      color: AppColors.secondary,
      onRefresh: () {
        final cubit = context.read<NearbyPlacesCubit>();

        if (userLatitude != null && userLongitude != null) {
          return cubit.loadWorkshopDirectoryFromPosition(
            userLatitude: userLatitude!,
            userLongitude: userLongitude!,
          );
        }

        return cubit.loadWorkshopDirectory();
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(
          ResponsiveSize.width(context, 5),
          ResponsiveSize.height(context, 0.8),
          ResponsiveSize.width(context, 5),
          ResponsiveSize.height(context, 4),
        ),
        itemCount: places.length,
        separatorBuilder: (_, __) => SizedBox(
          height: ResponsiveSize.height(context, 1.4),
        ),
        itemBuilder: (context, index) {
          return WorkshopDirectoryCard(
            place: places[index],
            allPlaces: places,
          );
        },
      ),
    );
  }
}
