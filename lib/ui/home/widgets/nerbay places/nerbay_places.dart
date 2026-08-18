import 'package:flutter/material.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/nerbay_places_list_item.dart';
import 'package:moftah/utils/responsive.dart';

class HomeNearbyPlacesList extends StatelessWidget {
  final List<HomeNearbyPlacesModel> nearbyPlaces;

  const HomeNearbyPlacesList({
    super.key,
    required this.nearbyPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.height(context, 1.6),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 5),
          vertical: ResponsiveSize.height(context, 0.6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nearbyPlaces
              .map(
                (item) => HomeNearbyPlacesListItem(
                  item: item,
                  nearbyPlaces: nearbyPlaces,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
