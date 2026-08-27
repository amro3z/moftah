import 'package:flutter/material.dart';
import 'package:moftah/data/models/obd/obd_models.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ObdTroubleCodes extends StatelessWidget {
  final ObdSnapshotModel snapshot;

  const ObdTroubleCodes({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: customText(
                text: 'أكواد الأعطال',
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                color: Colors.white,
                isBold: true,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 2),
                vertical: ResponsiveSize.height(context, .35),
              ),
              decoration: BoxDecoration(
                color: (snapshot.troubleCodes.isEmpty
                        ? AppColors.success
                        : AppColors.danger)
                    .withValues(alpha: .12),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: customText(
                text: '${snapshot.troubleCodes.length}',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                color: snapshot.troubleCodes.isEmpty
                    ? AppColors.success
                    : AppColors.danger,
                isBold: true,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveSize.height(context, .7)),
        if (snapshot.troubleCodes.isEmpty)
          Container(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: .09),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: customText(
                    text: 'لم يتم العثور على أكواد أعطال مخزنة.',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.success,
                    isBold: true,
                  ),
                ),
              ],
            ),
          )
        else
          ...snapshot.troubleCodes.map(
            (code) => _DtcItem(item: code),
          ),
      ],
    );
  }
}

class _DtcItem extends StatelessWidget {
  final ObdTroubleCodeModel item;

  const _DtcItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.height(context, .8)),
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.danger.withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              Expanded(
                child: customText(
                  text: item.title,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: customText(
                  text: item.code,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.danger,
                  isBold: true,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, .6)),
          customText(
            text: item.description,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: Colors.white70,
          ),
          SizedBox(height: ResponsiveSize.height(context, .7)),
          Wrap(
            spacing: ResponsiveSize.width(context, 1.5),
            runSpacing: ResponsiveSize.height(context, .4),
            children: [
              _DtcChip(text: 'النظام: ${item.system}'),
              _DtcChip(text: item.codeType),
            ],
          ),
        ],
      ),
    );
  }
}

class _DtcChip extends StatelessWidget {
  final String text;

  const _DtcChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, .3),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: customText(
        text: text,
        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
        color: Colors.white70,
      ),
    );
  }
}
