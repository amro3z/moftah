import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/vehicle_card/vehicle_health_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/ui/car_owner/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/ui/car_owner/vehicle_health/widgets/health_item_card.dart';
import 'package:moftah/ui/car_owner/vehicle_health/widgets/health_score_ring.dart';
import 'package:moftah/ui/car_owner/vehicle_health/widgets/obd_diagnostics_card.dart';
import 'package:moftah/ui/car_owner/vehicle_health/widgets/vehicle_health_info_note.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/utils/vehicle_brand_logo.dart';

class VehicleHealthScreen extends StatelessWidget {
  final VehicleHealthModel data;

  const VehicleHealthScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            _header(context),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.width(context, 5),
                ResponsiveSize.height(context, 2),
                ResponsiveSize.width(context, 5),
                ResponsiveSize.height(context, 5),
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    children: [
                      Expanded(
                        child: customText(
                          text: 'تفاصيل حالة السيارة',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontXl,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                      ),
                      _confidenceBadge(context, data.overallConfidence),
                    ],
                  ),
                  SizedBox(height: ResponsiveSize.height(context, .8)),
                  const VehicleHealthInfoNote(),
                  SizedBox(height: ResponsiveSize.height(context, 1.5)),
                  const ObdDiagnosticsCard(),
                  SizedBox(height: ResponsiveSize.height(context, 1.5)),
                  BlocBuilder<ObdCubit, ObdState>(
                    buildWhen: (previous, current) =>
                        previous.snapshot != current.snapshot ||
                        previous.status != current.status,
                    builder: (context, obdState) {
                      return Column(
                        children: [
                          for (final item in data.items) ...[
                            HealthItemCard(
                              item: item,
                              obdSnapshot: obdState.snapshot,
                            ),
                            SizedBox(
                              height: ResponsiveSize.height(context, 1.2),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  SizedBox(height: ResponsiveSize.height(context, .5)),
                  SizedBox(
                    height: ResponsiveSize.height(context, 6.5),
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/report-problem'),
                      icon: const Icon(Icons.report_problem_outlined),
                      label: customText(
                        text: 'بلّغ عن مشكلة في السيارة',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 5),
        MediaQuery.paddingOf(context).top + ResponsiveSize.height(context, 1),
        ResponsiveSize.width(context, 5),
        ResponsiveSize.height(context, 2.5),
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: Colors.white.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: customText(
                    text: 'حالة السيارة',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                    color: Colors.white,
                    isBold: true,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 11)),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, 2)),
          Row(
            children: [
              VehicleBrandLogo(
                brand: data.brand,
                logoUrl: data.brandLogoUrl,
                sizePercent: 18,
              ),
              SizedBox(width: ResponsiveSize.width(context, 4)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: data.vehicleName,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                      color: Colors.white,
                      isBold: true,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, .35)),
                    customText(
                      text: '${data.year}  •  ${_formatNumber(data.mileage)} كم',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: Colors.white70,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, .7)),
                    customText(
                      text: 'آخر تقييم متاح لحالة سيارتك',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
              HealthScoreRing(score: data.overallScore),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
  }

  Widget _confidenceBadge(BuildContext context, int value) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2.5),
          vertical: ResponsiveSize.height(context, .6),
        ),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: .09),
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        child: customText(
          text: 'دقة التقييم $value%',
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: AppColors.secondary,
          isBold: true,
        ),
      );
}
