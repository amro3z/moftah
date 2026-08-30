import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class CustomListField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final List<String> list;
  final String theme;
  final IconData icon;
  const CustomListField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.list,
    required this.theme,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showList(context),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        height: ResponsiveSize.height(context, 7),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 3),
        ),
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.border.withValues(alpha: .10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveSize.width(context, 10),
              height: ResponsiveSize.width(context, 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: ResponsiveSize.width(context, 5),
              ),
            ),

            SizedBox(width: ResponsiveSize.width(context, 3)),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: theme,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.textMuted,
                  ),

                  SizedBox(height: ResponsiveSize.height(context, .2)),

                  customText(
                    text: value ?? 'اختر ${theme}',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: value == null
                        ? AppColors.textMuted
                        : AppColors.primary,
                    isBold: value != null,
                  ),
                ],
              ),
            ),

            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
              size: ResponsiveSize.width(context, 6),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showList(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,

      backgroundColor: Colors.transparent,

      isScrollControlled: true,

      builder: (context) {
        return _ListBottomSheet(
          currentValue: value,
          list: list,
          theme: theme,
          icon: icon,
        );
      },
    );

    if (selected != null) {
      onChanged(selected);
    }
  }
}

class _ListBottomSheet extends StatefulWidget {
  final String? currentValue;
  final List<String> list;
  final String theme;
  final IconData icon;
  const _ListBottomSheet({
    required this.currentValue,
    required this.list,
    required this.theme,
    required this.icon,
  });

  @override
  State<_ListBottomSheet> createState() => _ListBottomSheetState();
}

class _ListBottomSheetState extends State<_ListBottomSheet> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.list.where((item) {
      return item.contains(search.trim());
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: ResponsiveSize.height(context, 58),
        ),
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLg),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .15),
              blurRadius: 30,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: ResponsiveSize.height(context, 1.2)),

            Container(
              width: ResponsiveSize.width(context, 11),
              height: ResponsiveSize.height(context, .45),
              decoration: BoxDecoration(
                color: AppColors.border.withValues(alpha: .25),
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.width(context, 5),
                ResponsiveSize.height(context, 2),
                ResponsiveSize.width(context, 5),
                ResponsiveSize.height(context, 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: 'اختر ${widget.theme}',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                    color: AppColors.primary,
                    isBold: true,
                  ),

                  SizedBox(height: ResponsiveSize.height(context, .4)),

                  customText(
                    text: 'حدد ${widget.theme} التي تقيم بها',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.textMuted,
                  ),

                  SizedBox(height: ResponsiveSize.height(context, 1.5)),

                  // Search
                  Container(
                    height: ResponsiveSize.height(context, 5.8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.primary,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontMd,
                        ),
                      ),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن ${widget.theme}',

                        hintStyle: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textMuted,
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                        ),

                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textMuted,
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.height(context, 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 4),
                  0,
                  ResponsiveSize.width(context, 4),
                  ResponsiveSize.height(context, 2),
                ),

                itemCount: filteredList.length,

                separatorBuilder: (_, _) =>
                    SizedBox(height: ResponsiveSize.height(context, .7)),

                itemBuilder: (context, index) {
                  final governorate = filteredList[index];

                  final selected = governorate == widget.currentValue;

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, governorate);
                    },
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),

                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(context, 4),
                        vertical: ResponsiveSize.height(context, 1.4),
                      ),

                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: .07)
                            : AppColors.surfaceLight,

                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),

                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(
                            width: ResponsiveSize.width(context, 8),
                            height: ResponsiveSize.width(context, 8),

                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,

                              shape: BoxShape.circle,
                            ),

                            child: Icon(
                              widget.icon,
                              color: selected
                                  ? AppColors.textSecondary
                                  : AppColors.secondary,
                              size: ResponsiveSize.width(context, 4),
                            ),
                          ),

                          SizedBox(width: ResponsiveSize.width(context, 3)),

                          Expanded(
                            child: customText(
                              text: governorate,
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontMd,
                              ),
                              color: AppColors.primary,
                              isBold: selected,
                            ),
                          ),

                          if (selected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                              size: ResponsiveSize.width(context, 5),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
