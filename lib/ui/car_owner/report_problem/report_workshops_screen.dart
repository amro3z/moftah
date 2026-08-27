import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/car_owner/nerbay_places_model.dart';
import 'package:moftah/data/models/report/problem_report_model.dart';
import 'package:moftah/data/store/service_request_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/car_owner/home/cubit/nearby_places_state.dart';
import 'package:moftah/ui/car_owner/home/widgets/nerbay%20places/nearby_places_loading_indicator.dart';
import 'package:moftah/ui/car_owner/workshops/widgets/workshop_directory_card.dart';
import 'package:moftah/utils/responsive.dart';

class ReportWorkshopsScreen extends StatelessWidget {
  final ProblemReportModel report;
  final double userLatitude;
  final double userLongitude;

  const ReportWorkshopsScreen({
    super.key,
    required this.report,
    required this.userLatitude,
    required this.userLongitude,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                color: AppColors.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: 'الورش المناسبة للبلاغ',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    customText(
                      text: 'نعرض الأقرب فورًا ونكمل تحميل باقي النتائج في الخلفية',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<NearbyPlacesCubit, NearbyPlacesState>(
          builder: (context, state) {
            if (state is NearbyPlacesLoading || state is NearbyPlacesInitial) {
              final loading = state is NearbyPlacesLoading
                  ? state
                  : const NearbyPlacesLoading(step: NearbyLoadingStep.searchingWorkshops, searchRadiusMeters: 15000);
              return SingleChildScrollView(
                child: NearbyPlacesLoadingIndicator(state: loading, directoryMode: true),
              );
            }

            if (state is NearbyPlacesError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off_rounded, size: ResponsiveSize.width(context, 11.79), color: AppColors.textMuted),
                      SizedBox(height: ResponsiveSize.height(context, 1)),
                      customText(
                        text: state.message,
                        fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.5)),
                      FilledButton(
                        onPressed: () => context.read<NearbyPlacesCubit>().loadWorkshopDirectoryFromPosition(
                              userLatitude: userLatitude,
                              userLongitude: userLongitude,
                              maxPlaces: 50,
                            ),
                        child: Text('حاول مرة أخرى', style: TextStyle(fontFamily: 'Cairo')),
                      ),
                    ],
                  ),
                ),
              );
            }

            final success = state as NearbyPlacesSuccess;
            final List<HomeNearbyPlacesModel> places = success.places;

            return Column(
              children: [
                if (success.isLoadingMore)
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      ResponsiveSize.width(context, 5),
                      ResponsiveSize.height(context, 1),
                      ResponsiveSize.width(context, 5),
                      0,
                    ),
                    padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: .12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: ResponsiveSize.width(context, 5),
                          height: ResponsiveSize.width(context, 5),
                          child: CircularProgressIndicator(strokeWidth: ResponsiveSize.width(context, 0.64)),
                        ),
                        SizedBox(width: ResponsiveSize.width(context, 2.5)),
                        Expanded(
                          child: customText(
                            text: 'عرضنا لك أقرب ${places.length} ورش الآن، وبنكمل تحميل باقي الورش حتى 50 بدون طلب موقعك مرة ثانية.',
                            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                            color: AppColors.primary,
                            isBold: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
                    itemCount: places.length,
                    separatorBuilder: (_, __) => SizedBox(height: ResponsiveSize.height(context, 1.2)),
                    itemBuilder: (context, index) {
                      return AnimatedSlide(
                        duration: Duration(milliseconds: 260 + (index.clamp(0, 8) as int) * 40),
                        offset: Offset.zero,
                        child: WorkshopDirectoryCard(
                          place: places[index],
                          allPlaces: places,
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      ResponsiveSize.width(context, 4),
                      0,
                      ResponsiveSize.width(context, 4),
                      ResponsiveSize.height(context, 1.3),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: ResponsiveSize.height(context, 6.2),
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          ),
                        ),
                        onPressed: places.isEmpty
                            ? null
                            : () async {
                                await ServiceRequestStore.instance.submitRequest(report);
                                if (!context.mounted) return;
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home',
                                  (_) => false,
                                );
                              },
                        icon: Icon(Icons.campaign_rounded),
                        label: Text(
                          'إرسال البلاغ وانتظار العروض',
                          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
