import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleBrandLogo extends StatelessWidget {
  final String brand;
  final String? logoUrl;
  final double sizePercent;
  final bool showContainer;

  const VehicleBrandLogo({
    super.key,
    required this.brand,
    this.logoUrl,
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
    final url = logoUrl?.trim().isNotEmpty == true
        ? logoUrl!.trim()
        : VehicleBrandLogoResolver.urlFor(brand);

    if (url == null) return _fallback(context);

    if (url.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        url,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => const Center(
          child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _fallback(context),
    );
  }

  Widget _fallback(BuildContext context) {
    final letter = brand.trim().isEmpty ? 'M' : brand.trim()[0].toUpperCase();
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

  static const String _base =
      'https://cdn.jsdelivr.net/gh/vehiclespecs/brand-logos@v1.0.0';

  static const Map<String, String> _aliases = {
    'mercedes': 'mercedes-benz',
    'mercedes benz': 'mercedes-benz',
    'vw': 'volkswagen',
    'land rover': 'land-rover',
    'alfa romeo': 'alfa-romeo',
    'aston martin': 'aston-martin',
    'rolls royce': 'rolls-royce',
  };

  static const Set<String> _pngBrands = {
    'chevrolet', 'ford', 'honda', 'lexus', 'mg', 'gmc', 'chery', 'jac',
    'dodge', 'haval', 'lamborghini', 'maserati', 'subaru', 'tata', 'xpeng',
  };

  static String? urlFor(String brand) {
    var key = brand.trim().toLowerCase();
    if (key.isEmpty) return null;
    key = _aliases[key] ?? key.replaceAll(RegExp(r'\s+'), '-');
    final extension = _pngBrands.contains(key) ? 'png' : 'svg';
    return '$_base/$key-logo.$extension';
  }
}
