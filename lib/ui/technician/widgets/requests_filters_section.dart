import 'package:flutter/material.dart';
import 'package:moftah/ui/core/helper/custom_search_bar.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class RequestsFiltersSection extends StatelessWidget {
  final Map<String, dynamic> filters;
  final int selectedIndex;
  final int numOfOrders;
  final ValueChanged<int> onFilterSelected;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAdvancedFilterTap;

  const RequestsFiltersSection({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.numOfOrders,
    required this.onFilterSelected,
    required this.onSearchChanged,
    required this.onAdvancedFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        ResponsiveSize.height(context, 1),
        ResponsiveSize.width(context, 4),
        0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchAndFilterBar(
            onSearchChanged: onSearchChanged,
            onFilterTap: onAdvancedFilterTap,
          ),
          const SizedBox(height: 10),
          FiltersList(
            filters: filters,
            selectedIndex: selectedIndex,
            numOfOrders: numOfOrders,
            onFilterSelected: onFilterSelected,
          ),
        ],
      ),
    );
  }
}

class SearchAndFilterBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;

  const SearchAndFilterBar({
    super.key,
    required this.onSearchChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              color: Colors.white,
              hintText: 'ابحث عن مدينة',
              onChanged: onSearchChanged,
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 5)),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              padding: EdgeInsets.all(ResponsiveSize.width(context, 2)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: .10),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.primary,
                    size: ResponsiveSize.width(context, 5.13),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 1)),
                  customText(
                    text: 'تصفية',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: AppColors.primary,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FiltersList extends StatelessWidget {
  final Map<String, dynamic> filters;
  final int selectedIndex;
  final int numOfOrders;
  final ValueChanged<int> onFilterSelected;

  const FiltersList({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.numOfOrders,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        itemCount: filters['labels'].length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          final bool isSelected = selectedIndex == index;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 3),
              vertical: ResponsiveSize.height(context, 1),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isSelected ? .8 : .5),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: isSelected
                    ? AppColors.info
                    : Colors.white.withValues(alpha: .10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: FilterItem(
              icon: filters['icons'][index],
              title: filters['labels'][index],
              numOfOrders: numOfOrders,
              showOrdersCount: index == 0,
              isSelected: isSelected,
              onTap: () {
                onFilterSelected(index);
              },
            ),
          );
        },
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int numOfOrders;
  final bool showOrdersCount;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterItem({
    super.key,
    required this.icon,
    required this.title,
    required this.numOfOrders,
    required this.showOrdersCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? AppColors.info : AppColors.primary,
          ),
          const SizedBox(width: 5),
          customText(
            text: showOrdersCount ? '$title ($numOfOrders)' : title,
            fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
            color: isSelected ? AppColors.info : AppColors.primary,
          ),
        ],
      ),
    );
  }
}
