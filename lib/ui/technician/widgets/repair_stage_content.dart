import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/repair_status.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RepairTimelineTile extends StatelessWidget {
  final RepairStageItem stage;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onAction;

  const RepairTimelineTile({
    super.key,
    required this.stage,
    required this.isFirst,
    required this.isLast,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = stage.status == RepairStageStatus.completed;
    final isCurrent = stage.status == RepairStageStatus.current;

    final indicatorColor = isCompleted
        ? AppColors.success
        : isCurrent
        ? AppColors.secondary
        : Colors.blueGrey.shade300;

    return TimelineTile(
      alignment: TimelineAlign.end,
      isFirst: isFirst,
      isLast: isLast,
      lineXY: 0.91,
      indicatorStyle: IndicatorStyle(
        width: 32,
        height: 32,
        color: indicatorColor,
        indicatorXY: 0.5,
        padding: const EdgeInsets.symmetric(vertical: 4),
        iconStyle: IconStyle(
          iconData: isCompleted
              ? Icons.check_rounded
              : isCurrent
              ? Icons.circle
              : Icons.circle_outlined,
          color: Colors.white,
          fontSize: isCurrent ? 10 : 19,
        ),
      ),
      beforeLineStyle: LineStyle(
        color: isCompleted || isCurrent
            ? AppColors.success
            : Colors.blueGrey.shade300,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: isCompleted
            ? AppColors.success
            : isCurrent
            ? AppColors.secondary
            : Colors.blueGrey.shade300,
        thickness: 2,
      ),
      startChild: Padding(
        padding: EdgeInsets.only(
          left: ResponsiveSize.width(context, 3),
          right: ResponsiveSize.width(context, 3),
          top: ResponsiveSize.height(context, 1),
          bottom: ResponsiveSize.height(context, 1),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            reverseDuration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [...previousChildren, ?currentChild],
              );
            },
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: .98, end: 1).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: StageContent(
              key: ValueKey('${stage.title}-${stage.status.name}'),
              stage: stage,
              onAction: onAction,
            ),
          ),
        ),
      ),
    );
  }
}

class StageContent extends StatelessWidget {
  final RepairStageItem stage;
  final VoidCallback? onAction;
  const StageContent({super.key, required this.stage, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final isCurrent = stage.status == RepairStageStatus.current;

    final isUpcoming = stage.status == RepairStageStatus.upcoming;

    if (isCurrent) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: ResponsiveSize.width(context, 1)),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 4),
          vertical: ResponsiveSize.height(context, 1.4),
        ),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              text: stage.title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
              color: AppColors.primary,
              isBold: true,
            ),
            if (stage.description != null) ...[
              SizedBox(height: ResponsiveSize.height(context, .4)),
              customText(
                text: stage.description!,
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textMuted,
              ),
            ],
            if (stage.time != null) ...[
              SizedBox(height: ResponsiveSize.height(context, .3)),
              customText(
                text: stage.time!,
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textMuted,
              ),
            ],
            if (stage.actionText != null) ...[
              SizedBox(height: ResponsiveSize.height(context, 1.3)),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveSize.height(context, 1.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  child: customText(
                    text: stage.actionText!,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: Colors.white,
                    isBold: true,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.height(context, .7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            text: stage.title,
            fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
            color: isUpcoming ? AppColors.textMuted : AppColors.primary,
            isBold: !isUpcoming,
          ),
          if (stage.description != null) ...[
            SizedBox(height: ResponsiveSize.height(context, .3)),
            customText(
              text: stage.description!,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.textMuted,
            ),
          ],
          if (stage.time != null) ...[
            SizedBox(height: ResponsiveSize.height(context, .3)),
            customText(
              text: stage.time!,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.textMuted,
            ),
          ],
        ],
      ),
    );
  }
}
