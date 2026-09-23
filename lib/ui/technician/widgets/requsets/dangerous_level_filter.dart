import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class DangerousLevelFilter extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  DangerousLevelFilter({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> levels = const ['الكل', 'منخفضة', 'متوسطة', 'عالية'];

  final List<IconData> icons = const [
    Icons.tune_rounded,
    Icons.eco_rounded,
    Icons.warning_amber_rounded,
    Icons.error_outline_rounded,
  ];

  final List<Color> colors = const [
    AppColors.secondary,
    AppColors.success,
    AppColors.warning,
    AppColors.danger,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          text: 'مستوى الخطورة',
          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
          isBold: true,
          color: AppColors.primary,
        ),
        SizedBox(height: ResponsiveSize.height(context, 1)),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: levels.length,
            separatorBuilder: (context, index) {
              return const SizedBox(width: 15);
            },
            itemBuilder: (context, index) {
              return DangerousLevelItem(
                title: levels[index],
                color: colors[index],
                icon: icons[index],
                isSelected: selectedIndex == index,
                onTap: () {
                  onChanged(index);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class DangerousLevelItem extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const DangerousLevelItem({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 3),
          vertical: ResponsiveSize.height(context, 1),
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isSelected ? .12 : .06),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: color.withValues(alpha: isSelected ? .9 : .20),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color.withValues(alpha: isSelected ? .8 : .7),
              size: 20,
            ),
            const SizedBox(width: 5),
            customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              isBold: isSelected,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
