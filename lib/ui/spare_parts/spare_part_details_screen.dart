import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/part_info_item.dart';
import 'package:moftah/data/models/spare_part_model.dart';
import 'package:moftah/ui/core/helper/rating_stars.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:moftah/ui/spare_parts/cubit/spare_parts_state.dart';
import 'package:moftah/ui/spare_parts/widgets/spare_parts_app_bar.dart';
import 'package:moftah/utils/responsive.dart';

class SparePartDetailsScreen extends StatelessWidget {
  final String productId;

  const SparePartDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SparePartsCubit, SparePartsState>(
      builder: (context, state) {
        final part = context.read<SparePartsCubit>().productById(productId);

        if (part == null) {
          return Scaffold(
            body: Center(
              child: customText(
                text: 'القطعة غير موجودة',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                isBold: true,
                color: AppColors.primary,
              ),
            ),
          );
        }

        final isFavorite = state.favoriteIds.contains(productId);
        final quantity = state.cartQuantities[productId] ?? 0;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: const SparePartsAppBar(
              title: 'تفاصيل القطعة',
              showBack: true,
            ),
            body: ListView(
              padding: EdgeInsets.only(
                bottom: ResponsiveSize.height(context, 13.27),
              ),
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                    ResponsiveSize.width(context, 4.1),
                    ResponsiveSize.height(context, 1.9),
                    ResponsiveSize.width(context, 4.1),
                    0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  height: ResponsiveSize.height(context, 29.62),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: part.imageUrl.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.settings_rounded,
                            size: ResponsiveSize.width(context, 23.59),
                            color: AppColors.secondary,
                          ),
                        )
                      : Image.network(
                          part.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Icon(
                              Icons.settings_rounded,
                              size: ResponsiveSize.width(context, 23.59),
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 4.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Material(
                            color: isFavorite
                                ? AppColors.danger.withValues(alpha: .10)
                                : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
                              onTap: () => context
                                  .read<SparePartsCubit>()
                                  .toggleFavorite(part.id),
                              child: SizedBox(
                                width: ResponsiveSize.width(context, 11.79),
                                height: ResponsiveSize.height(context, 5.45),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isFavorite
                                      ? AppColors.danger
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (part.isOem) const _Badge('OEM'),
                          if (part.isOem)
                            SizedBox(
                              width: ResponsiveSize.width(context, 1.54),
                            ),
                          if (state.isCompatible(part))
                            const _Badge('متوافق مع سيارتك ✓', green: true),
                          if (state.isCompatible(part))
                            SizedBox(
                              width: ResponsiveSize.width(context, 1.54),
                            ),
                          if (part.isOriginal)
                            const _Badge('متاح', green: true),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.42)),
                      customText(
                        text: part.name,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXxxl,
                        ),
                        isBold: true,
                        color: AppColors.primary,
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .95)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          customText(
                            text: part.rating.toStringAsFixed(1),
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontSm,
                            ),
                            isBold: true,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(width: ResponsiveSize.width(context, 1.28)),
                          ratingStars(
                            context: context,
                            numberOfStars: part.rating,
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .95)),
                      customText(
                        text: '${part.price.toStringAsFixed(0)} جنيه',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXxxl,
                        ),
                        isBold: true,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.9)),
                      _InfoCard(part: part),
                      SizedBox(height: ResponsiveSize.height(context, 2.13)),
                      customText(
                        text: 'متوافق مع',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXxl,
                        ),
                        isBold: true,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1.18)),
                      for (final compatibility in part.compatibility)
                        _CompatibilityCard(data: compatibility),
                    ],
                  ),
                ),
              ],
            ),
            bottomSheet: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 4.1),
                  ResponsiveSize.height(context, 1.3),
                  ResponsiveSize.width(context, 4.1),
                  ResponsiveSize.height(context, 2.5),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .07),
                      blurRadius: ResponsiveSize.width(context, 3.6),
                      offset: Offset(0, -ResponsiveSize.height(context, .47)),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (quantity > 0) ...[
                      _QuantityControl(
                        icon: Icons.remove_rounded,
                        onTap: () => context
                            .read<SparePartsCubit>()
                            .decreaseCart(part.id),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSize.width(context, 2.56),
                        ),
                        child: customText(
                          text: '$quantity',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontXl,
                          ),
                          isBold: true,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () =>
                            context.read<SparePartsCubit>().addToCart(part.id),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          minimumSize: Size.fromHeight(
                            ResponsiveSize.height(context, 6.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMd,
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.shopping_cart_checkout_rounded,
                          size: ResponsiveSize.width(context, 5),
                        ),
                        label: customText(
                          text: quantity == 0
                              ? 'إضافة إلى السلة'
                              : 'إضافة واحدة أخرى',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          isBold: true,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final SparePartModel part;

  const _InfoCard({required this.part});

  @override
  Widget build(BuildContext context) {
    final items = <PartInfoItem>[
      PartInfoItem(
        title: 'الماركة',
        value: part.brand,
        icon: Icons.workspace_premium_rounded,
      ),
      PartInfoItem(
        title: 'رقم OEM',
        value: part.oemNumber,
        icon: Icons.qr_code_2_rounded,
      ),
      PartInfoItem(
        title: 'الضمان',
        value: '${part.warrantyMonths} شهر',
        icon: Icons.verified_user_rounded,
      ),
      PartInfoItem(
        title: 'البائع',
        value: part.seller,
        icon: Icons.storefront_rounded,
      ),
      PartInfoItem(
        title: 'الموقع',
        value: part.location,
        icon: Icons.location_on_rounded,
      ),
      PartInfoItem(
        title: 'الحالة',
        value: part.isOriginal ? 'قطعة أصلية' : 'قطعة بديلة',
        icon: Icons.inventory_2_rounded,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: ResponsiveSize.width(context, 2.5),
        mainAxisSpacing: ResponsiveSize.height(context, 1.2),
        childAspectRatio: 1.9,
      ),
      itemBuilder: (context, index) {
        return _InfoItemCard(item: items[index]);
      },
    );
  }
}

class _InfoItemCard extends StatelessWidget {
  final PartInfoItem item;

  const _InfoItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 3),
        vertical: ResponsiveSize.height(context, 1.1),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border.withValues(alpha: .10)),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveSize.width(context, 10),
            height: ResponsiveSize.width(context, 10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(
              item.icon,
              color: AppColors.secondary,
              size: ResponsiveSize.width(context, 5),
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2.5)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: item.title,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: AppColors.textMuted,
                ),
                SizedBox(height: ResponsiveSize.height(context, .35)),
                customText(
                  text: item.value,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  isBold: true,
                  color: AppColors.primary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompatibilityCard extends StatelessWidget {
  final SparePartCompatibility data;

  const _CompatibilityCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.height(context, 1.18)),
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.85)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: .10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              customText(
                text: data.vehicleName,
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                isBold: true,
                color: AppColors.primary,
              ),
              SizedBox(width: ResponsiveSize.width(context, 2.05)),
              Icon(
                Icons.directions_car_rounded,
                color: AppColors.secondary,
                size: ResponsiveSize.width(context, 5.13),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.18)),
          Wrap(
            spacing: ResponsiveSize.width(context, 1.54),
            runSpacing: ResponsiveSize.height(context, .71),
            children: data.years
                .map(
                  (year) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(context, 2.56),
                      vertical: ResponsiveSize.height(context, .71),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(AppSizes.radiusXs),
                    ),
                    child: customText(
                      text: '$year',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      isBold: true,
                      color: AppColors.secondary,
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.07)),
          customText(
            text: data.engine,
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.textMuted,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final bool green;

  const _Badge(this.text, {this.green = false});

  @override
  Widget build(BuildContext context) {
    final color = green ? AppColors.success : AppColors.secondary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2.05),
        vertical: ResponsiveSize.height(context, .59),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: green ? .10 : .08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: customText(
        text: text,
        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
        isBold: true,
        color: color,
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityControl({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Container(
        width: ResponsiveSize.width(context, 10.77),
        height: ResponsiveSize.height(context, 4.98),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        child: Icon(
          icon,
          color: AppColors.secondary,
          size: ResponsiveSize.width(context, 5),
        ),
      ),
    );
  }
}
