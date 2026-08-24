import 'package:flutter/material.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:moftah/ui/spare_parts/cubit/spare_parts_state.dart';

class SparePartsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final bool showActions;

  const SparePartsAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.showActions = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
      toolbarHeight: ResponsiveSize.height(context, 7.82),
      elevation: 0,
      backgroundColor: AppColors.primary,
      surfaceTintColor: AppColors.primary,
      titleSpacing: 16,
      title: Row(
        children: [
          if (showBack) ...[
            _TopIcon(
              icon: Icons.arrow_back_ios_rounded,
              onTap: () => Navigator.maybePop(context),
            ),
            SizedBox(width: ResponsiveSize.width(context, 2.56)),
          ],
          Expanded(
            child: customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
              isBold: true,
              color: Colors.white,
            ),
          ),
          if (showActions)
            BlocBuilder<SparePartsCubit, SparePartsState>(
              buildWhen: (a, b) =>
                  a.cartCount != b.cartCount ||
                  a.favoriteIds.length != b.favoriteIds.length,
              builder: (context, state) {
                return Row(
                  children: [
                    _TopIcon(
                      icon: Icons.favorite_border_rounded,
                      badge: state.favoriteIds.length,
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/spare-parts-favorites',
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.width(context, 2.05)),
                    _TopIcon(
                      icon: Icons.shopping_bag_outlined,
                      badge: state.cartCount,
                      onTap: () =>
                          Navigator.pushNamed(context, '/spare-parts-cart'),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TopIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int badge;

  const _TopIcon({required this.icon, required this.onTap, this.badge = 0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.white.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: SizedBox(
              width: ResponsiveSize.width(context, 10.26),
              height: ResponsiveSize.height(context, 4.74),
              child: Icon(icon, color: Colors.white, size: ResponsiveSize.width(context, 5.38)),
            ),
          ),
        ),
        if (badge > 0)
          Positioned(
            top: -5,
            left: -4,
            child: Container(
              constraints: BoxConstraints(minWidth: ResponsiveSize.width(context, 4.36), minHeight: ResponsiveSize.height(context, 2.01)),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 1.03)),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              child: customText(
                text: badge > 99 ? '99+' : '$badge',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                isBold: true,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
