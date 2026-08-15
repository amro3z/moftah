import 'package:flutter/material.dart';
import 'package:moftah/utils/responsive.dart';

Widget ratingStars({required BuildContext context, required double numberOfStars}) {
  final fullStars = numberOfStars.floor();
  final hasHalfStar = (numberOfStars - fullStars) >= 0.5;
  final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

  return Directionality(
    textDirection: TextDirection.ltr,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          fullStars,
          (index) => Icon(
            Icons.star,
            color: Colors.amberAccent,
            size: ResponsiveSize.width(context, 2.5),
          ),
        ),

        if (hasHalfStar)
          Icon(
            Icons.star_half,
            color: Colors.amberAccent,
            size: ResponsiveSize.width(context, 2.5),
          ),

        ...List.generate(
          emptyStars,
          (index) => Icon(
            Icons.star_border,
            color: Colors.amberAccent,
            size: ResponsiveSize.width(context, 2.5),
          ),
        ),
      ],
    ),
  );
}
