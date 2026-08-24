import 'package:flutter/material.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/spare_part_model.dart';
import 'package:moftah/ui/core/helper/rating_stars.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:moftah/ui/spare_parts/cubit/spare_parts_state.dart';
import 'package:moftah/ui/spare_parts/widgets/spare_part_image.dart';

class SparePartCard extends StatelessWidget {
  final SparePartModel part;

  const SparePartCard({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SparePartsCubit, SparePartsState>(
      buildWhen: (a, b) =>
          a.favoriteIds.contains(part.id) != b.favoriteIds.contains(part.id) ||
          a.cartQuantities[part.id] != b.cartQuantities[part.id] ||
          a.selectedVehicleId != b.selectedVehicleId,
      builder: (context, state) {
        final favorite = state.favoriteIds.contains(part.id);
        final quantity = state.cartQuantities[part.id] ?? 0;
        final compatible = state.isCompatible(part);

        return Container(
          margin: EdgeInsets.only(bottom: ResponsiveSize.height(context, 1.18)),
          padding: EdgeInsets.all(ResponsiveSize.width(context, 2.82)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.border.withValues(alpha: .10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SparePartImage(imageUrl: part.imageUrl, size: ResponsiveSize.width(context, 21.03)),
                  SizedBox(width: ResponsiveSize.width(context, 2.56)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => context.read<SparePartsCubit>().toggleFavorite(part.id),
                              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                              child: Padding(
                                padding: EdgeInsets.all(ResponsiveSize.width(context, 1.03)),
                                child: Icon(
                                  favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  size: ResponsiveSize.width(context, 5.13),
                                  color: favorite ? AppColors.danger : AppColors.textMuted,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (compatible) const _Tag(label: 'متوافق مع سيارتك', success: true),
                            if (compatible) SizedBox(width: ResponsiveSize.width(context, 1.28)),
                            if (part.isOem) const _Tag(label: 'OEM'),
                            if (part.isOriginal && !part.isOem) const _Tag(label: 'أصلي'),
                          ],
                        ),
                        SizedBox(height: ResponsiveSize.height(context, 0.83)),
                        customText(
                          text: part.name,
                          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                          isBold: true,
                          color: AppColors.primary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: ResponsiveSize.height(context, 0.24)),
                        customText(
                          text: '${part.brand} · ${part.seller}',
                          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                          color: AppColors.textMuted,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: ResponsiveSize.height(context, 0.71)),
                        Row(
                          children: [
                            customText(
                              text: '${part.distanceKm.toStringAsFixed(1)} كم',
                              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                              isBold: true,
                              color: AppColors.secondary,
                            ),
                            SizedBox(width: ResponsiveSize.width(context, 2.05)),
                            customText(
                              text: part.rating.toStringAsFixed(1),
                              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                              isBold: true,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: ResponsiveSize.width(context, 1.03)),
                            ratingStars(context: context, numberOfStars: part.rating),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.18)),
              Divider(height: ResponsiveSize.height(context, 0.12), color: AppColors.border.withValues(alpha: .12)),
              SizedBox(height: ResponsiveSize.height(context, 1.07)),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () => context.read<SparePartsCubit>().addToCart(part.id),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 3.08), vertical: ResponsiveSize.height(context, 1.07)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                    ),
                    icon: Icon(Icons.shopping_cart_outlined, size: ResponsiveSize.width(context, 4.1)),
                    label: customText(
                      text: quantity > 0 ? 'في السلة ($quantity)' : 'إضافة للسلة',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      isBold: true,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 1.79)),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/spare-part-details',
                      arguments: part.id,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.border.withValues(alpha: .20)),
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 3.85), vertical: ResponsiveSize.height(context, 1.07)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
                    ),
                    child: customText(
                      text: 'عرض',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      isBold: true,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      customText(
                        text: part.price.toStringAsFixed(0),
                        fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                        isBold: true,
                        color: AppColors.secondary,
                      ),
                      customText(
                        text: 'جنيه',
                        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final bool success;

  const _Tag({required this.label, this.success = false});

  @override
  Widget build(BuildContext context) {
    final color = success ? AppColors.success : AppColors.secondary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 1.79), vertical: ResponsiveSize.height(context, 0.36)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: customText(
        text: label,
        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
        isBold: true,
        color: color,
      ),
    );
  }
}
