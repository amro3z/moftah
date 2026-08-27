import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/themes/colors.dart';

class SparePartImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const SparePartImage({super.key, required this.imageUrl, this.size = 82});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border.withValues(alpha: .10)),
      ),
      child: imageUrl.trim().isEmpty
          ? Icon(
              Icons.settings_rounded,
              size: size * .42,
              color: AppColors.secondary.withValues(alpha: .34),
            )
          : Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.settings_rounded,
                size: size * .42,
                color: AppColors.secondary.withValues(alpha: .34),
              ),
            ),
    );
  }
}
