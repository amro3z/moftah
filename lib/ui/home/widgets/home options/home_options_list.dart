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
      height: ResponsiveSize.height(context, 16.5),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        itemCount: options.length,
        padding: EdgeInsets.fromLTRB(
          ResponsiveSize.width(context, 5),
          ResponsiveSize.height(context, 1.6),
          ResponsiveSize.width(context, 5),
          ResponsiveSize.height(context, 2.1),
        ),
        separatorBuilder: (_, __) =>
            SizedBox(width: ResponsiveSize.width(context, 2.3)),
        itemBuilder: (context, index) {
          return HomeOptionItem(item: options[index]);
        },
      ),
    );
  }
}
