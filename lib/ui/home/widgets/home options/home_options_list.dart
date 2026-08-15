import 'package:flutter/material.dart';
import 'package:moftah/data/models/home_options_model.dart';
import 'package:moftah/ui/home/widgets/home%20options/home_options_item.dart';
import 'package:moftah/utils/responsive.dart';

class HomeOptionsList extends StatelessWidget {
  final List<HomeOptionItemModel> options;

  const HomeOptionsList({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveSize.height(context, 12),
      child: ListView.separated(
        reverse: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: options.length,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 5),
          vertical: ResponsiveSize.height(context, 0.8),
        ),
        separatorBuilder: (context, index) {
          return SizedBox(width: ResponsiveSize.width(context, 2));
        },
        itemBuilder: (context, index) {
          final item = options[index];

          return HomeOptionItem(item: item);
        },
      ),
    );
  }
}

