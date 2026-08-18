import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/home_options_model.dart';
import 'package:moftah/routing/workshops_route_arguments.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/home/cubit/nearby_places_state.dart';
import 'package:moftah/utils/responsive.dart';

class HomeOptionItem extends StatelessWidget {
  final HomeOptionItemModel item;

  const HomeOptionItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.path != '/nearby-workshops') return;

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
      },
      child: Container(
        width: ResponsiveSize.width(context, 21),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2),
          vertical: ResponsiveSize.height(context, 1),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ResponsiveSize.width(context, 9),
              height: ResponsiveSize.width(context, 9),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                size: ResponsiveSize.width(context, 5.5),
                color: AppColors.secondary,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 0.5)),
            customText(
              text: item.title,
              isBold: true,
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
