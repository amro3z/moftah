import 'package:flutter/material.dart';

import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleBrandLogo extends StatelessWidget {
  final String brand;
  final double sizePercent;
  final bool showContainer;

  const VehicleBrandLogo({
    super.key,
    required this.brand,
    this.sizePercent = 14,
    this.showContainer = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveSize.width(context, sizePercent);

    final logo = _buildLogo(context);

    if (!showContainer) {
      return SizedBox(width: size, height: size, child: logo);
    }

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * .18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: .7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .12),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: logo,
    );
  }

  Widget _buildLogo(BuildContext context) {
    final path = VehicleBrandLogoResolver.assetFor(brand);

    if (path == null) {
      return _fallback(context);
    }

    return Image.asset(
      path,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Car logo not found: $brand -> $path');

        return _fallback(context);
      },
    );
  }

  Widget _fallback(BuildContext context) {
    final trimmedBrand = brand.trim();

    final letter = trimmedBrand.isEmpty ? 'M' : trimmedBrand[0].toUpperCase();

    return Center(
      child: customText(
        text: letter,
        fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
        color: AppColors.primary,
        isBold: true,
      ),
    );
  }
}

class VehicleBrandLogoResolver {
  VehicleBrandLogoResolver._();

  static const String _base = 'assets/cars';

  static const Map<String, String> _aliases = {
    'alfa romeo': 'alfa-romeo',
    'aston martin': 'aston-martin',
    'gardner douglas': 'gardner-douglas',
    'king long': 'king-long',
    'land rover': 'land-rover',
    'rolls royce': 'rolls-royce',
    'vw': 'volkswagen',
  };

  static String? assetFor(String brand) {
    var key = brand.trim().toLowerCase();

    if (key.isEmpty) {
      return null;
    }

    key = _aliases[key] ?? key.replaceAll(RegExp(r'\s+'), '-');

    return '$_base/$key.png';
  }
}
