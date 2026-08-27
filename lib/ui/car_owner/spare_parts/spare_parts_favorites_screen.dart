import 'package:flutter/material.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:moftah/ui/car_owner/spare_parts/cubit/spare_parts_state.dart';
import 'package:moftah/ui/car_owner/spare_parts/widgets/spare_part_card.dart';
import 'package:moftah/ui/car_owner/spare_parts/widgets/spare_parts_app_bar.dart';

class SparePartsFavoritesScreen extends StatelessWidget {
  const SparePartsFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const SparePartsAppBar(
          title: 'المفضلة',
          showBack: true,
          showActions: false,
        ),
        body: BlocBuilder<SparePartsCubit, SparePartsState>(
          builder: (context, state) {
            final products = state.favoriteProducts;
            if (products.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 7.18)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: ResponsiveSize.width(context, 21.54),
                        height: ResponsiveSize.height(context, 9.95),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withValues(alpha: .08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_border_rounded,
                          size: ResponsiveSize.width(context, 10.26),
                          color: AppColors.danger,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.78)),
                      customText(
                        text: 'مفيش قطع في المفضلة',
                        fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
                        isBold: true,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 0.59)),
                      customText(
                        text: 'اضغط على علامة القلب لحفظ القطعة هنا',
                        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                        color: AppColors.textMuted,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 2.01)),
                      FilledButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.secondary),
                        icon: Icon(Icons.storefront_rounded),
                        label: customText(
                          text: 'تصفح قطع الغيار',
                          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                          isBold: true,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(ResponsiveSize.width(context, 3.08), ResponsiveSize.height(context, 1.66), ResponsiveSize.width(context, 3.08), ResponsiveSize.height(context, 2.84)),
              itemCount: products.length,
              itemBuilder: (_, index) => SparePartCard(part: products[index]),
            );
          },
        ),
      ),
    );
  }
}
