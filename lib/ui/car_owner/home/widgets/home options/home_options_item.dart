import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/car_owner/home_options_model.dart';
import 'package:moftah/routing/workshops_route_arguments.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/car_owner/home/cubit/nearby_places_state.dart';
import 'package:moftah/utils/responsive.dart';

class HomeOptionItem extends StatelessWidget {
  final HomeOptionItemModel item;

  const HomeOptionItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusLg);

    return Container(
      width: ResponsiveSize.width(context, 21),
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .16),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _handleTap(context),
          borderRadius: radius,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 2),
              vertical: ResponsiveSize.height(context, 1.15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ResponsiveSize.width(context, 9.5),
                  height: ResponsiveSize.width(context, 9.5),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: .09),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    size: ResponsiveSize.width(context, 5.3),
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, .75)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: customText(
                    text: item.title,
                    isBold: true,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

void _handleTap(BuildContext context) {
    if (item.path == '/report-problem') {
      Navigator.pushNamed(context, item.path);
      return;
    }

    if (item.path == '/received-offers') {
      Navigator.pushNamed(context, item.path);
      return;
    }

    if (item.path == '/spare-parts') {
      Navigator.pushNamed(context, item.path);
      return;
    }

    if (item.path == '/emergency') {
      Navigator.pushNamed(context, item.path);
      return;
    }

    if (item.path == '/nearby-workshops') {
      final state = context.read<NearbyPlacesCubit>().state;

      if (state is! NearbyPlacesSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('استنى لحظة لحد ما نحدد موقعك ونجيب أقرب الورش'),
          ),
        );
        return;
      }

      Navigator.pushNamed(
        context,
        item.path,
        arguments: WorkshopsRouteArguments(
          userLatitude: state.userLatitude,
          userLongitude: state.userLongitude,
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.title} سيتم ربطها بالباك إند لاحقًا')),
    );
  }
}
