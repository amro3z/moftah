import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/ui/core/helper/custom_search_bar.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:moftah/ui/car_owner/spare_parts/cubit/spare_parts_state.dart';
import 'package:moftah/ui/car_owner/spare_parts/widgets/spare_part_card.dart';
import 'package:moftah/ui/car_owner/spare_parts/widgets/spare_parts_app_bar.dart';
import 'package:moftah/ui/car_owner/spare_parts/widgets/spare_parts_vehicle_sheet.dart';
import 'package:moftah/utils/responsive.dart';

class SparePartsScreen extends StatelessWidget {
  const SparePartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const SparePartsAppBar(title: 'قطع الغيار', showBack: true),
        body: BlocBuilder<SparePartsCubit, SparePartsState>(
          builder: (context, state) {
            final products = state.visibleProducts;

            return Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveSize.width(context, 3.59),
                    ResponsiveSize.height(context, 1.42),
                    ResponsiveSize.width(context, 3.59),
                    ResponsiveSize.height(context, 1.42),
                  ),
                  child: Column(
                    children: [
                      CustomSearchBar(
                        hintText: 'ابحث باسم القطعة أو رقم OEM',
                        onChanged: context.read<SparePartsCubit>().search,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.07)),
                      _VehicleBar(state: state),
                      SizedBox(height: ResponsiveSize.height(context, 1.18)),
                      SizedBox(
                        height: ResponsiveSize.height(context, 4.27),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _FilterChip(
                              label: 'الكل',
                              selected:
                                  state.sort == SparePartsSort.recommended &&
                                  !state.compatibleOnly,
                              onTap: () {
                                context.read<SparePartsCubit>().setSort(
                                  SparePartsSort.recommended,
                                );

                                if (state.compatibleOnly) {
                                  context
                                      .read<SparePartsCubit>()
                                      .toggleCompatibleOnly();
                                }
                              },
                            ),
                            SizedBox(
                              width: ResponsiveSize.width(context, 1.79),
                            ),
                            _FilterChip(
                              label: 'متوافق مع سيارتي',
                              selected: state.compatibleOnly,
                              onTap: context
                                  .read<SparePartsCubit>()
                                  .toggleCompatibleOnly,
                              icon: Icons.verified_rounded,
                            ),
                            SizedBox(
                              width: ResponsiveSize.width(context, 1.79),
                            ),
                            _SortChip(
                              label: 'الأقرب',
                              value: SparePartsSort.nearest,
                              state: state,
                            ),
                            SizedBox(
                              width: ResponsiveSize.width(context, 1.79),
                            ),
                            _SortChip(
                              label: 'السعر',
                              value: SparePartsSort.priceLowToHigh,
                              state: state,
                            ),
                            SizedBox(
                              width: ResponsiveSize.width(context, 1.79),
                            ),
                            _SortChip(
                              label: 'التقييم',
                              value: SparePartsSort.ratingHighToLow,
                              state: state,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: products.isEmpty
                      ? const _EmptyResults()
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(
                            ResponsiveSize.width(context, 3.08),
                            ResponsiveSize.height(context, 1.42),
                            ResponsiveSize.width(context, 3.08),
                            ResponsiveSize.height(context, 2.84),
                          ),
                          itemCount: products.length,

                          itemBuilder: (_, index) =>
                              SparePartCard(part: products[index]),
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

class _VehicleBar extends StatelessWidget {
  final SparePartsState state;

  const _VehicleBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final vehicle = state.selectedVehicle;

    return InkWell(
      onTap: () async {
        final selectedId = await showSparePartsVehicleSheet(
          context: context,
          vehicles: state.vehicles,
          selectedVehicleId: state.selectedVehicleId,
        );

        if (selectedId != null && context.mounted) {
          context.read<SparePartsCubit>().setVehicle(selectedId);
        }
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2.82),
          vertical: ResponsiveSize.height(context, 1.07),
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(color: AppColors.border.withValues(alpha: .10)),
        ),
        child: Row(
          children: [
            customText(
              text: 'تغيير',
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              isBold: true,
              color: AppColors.secondary,
            ),
            const Spacer(),
            customText(
              text: vehicle?.displayName ?? 'اختار العربية',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              isBold: true,
              color: AppColors.primary,
            ),
            SizedBox(width: ResponsiveSize.width(context, 1.79)),
            Icon(
              Icons.directions_car_filled_rounded,
              color: AppColors.secondary,
              size: ResponsiveSize.width(context, 4.62),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final SparePartsSort value;
  final SparePartsState state;

  const _SortChip({
    required this.label,
    required this.value,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final selected = state.sort == value;

    return _FilterChip(
      label: label,
      selected: selected,
      onTap: () => context.read<SparePartsCubit>().setSort(
        selected ? SparePartsSort.recommended : value,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 3.08),
          vertical: ResponsiveSize.height(context, .83),
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.secondary : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: selected
                ? AppColors.secondary
                : AppColors.border.withValues(alpha: .18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: ResponsiveSize.width(context, 3.59),
                color: selected ? Colors.white : AppColors.secondary,
              ),
              SizedBox(width: ResponsiveSize.width(context, 1.28)),
            ],
            customText(
              text: label,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              isBold: selected,
              color: selected ? Colors.white : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveSize.width(context, 8.21)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveSize.width(context, 19.49),
              height: ResponsiveSize.height(context, 9),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: ResponsiveSize.width(context, 9.74),
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.42)),
            customText(
              text: 'مفيش قطع مطابقة للفلاتر الحالية',
              fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
              isBold: true,
              color: AppColors.primary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
