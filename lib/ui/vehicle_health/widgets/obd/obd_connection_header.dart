import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/ui/core/constant/obd_stage_text.dart';
import 'package:moftah/utils/responsive.dart';

class ObdConnectionHeader extends StatelessWidget {
  final ObdState state;

  const ObdConnectionHeader({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final connected = state.isConnected;
    final connecting = state.isConnectionFlowRunning;

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: ResponsiveSize.width(context, 11),
          height: ResponsiveSize.width(context, 11),
          decoration: BoxDecoration(
            color: (connected ? AppColors.success : AppColors.secondary)
                .withValues(alpha: .14),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            connected
                ? Icons.bluetooth_connected_rounded
                : Icons.bluetooth_searching_rounded,
            color: connected ? AppColors.success : AppColors.info,
            size: ResponsiveSize.width(context, 6),
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: 'فحص OBD-II',
                fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                color: Colors.white,
                isBold: true,
              ),
              SizedBox(height: ResponsiveSize.height(context, .25)),
              customText(
                text: connecting
                    ? obdStageText(state.connectionStage)
                    : connected
                        ? 'بيانات حية من السيارة عبر ELM327'
                        : 'وصّل ELM327 علشان تقرأ الأعطال والبيانات الحية',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                color: Colors.white70,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 2),
            vertical: ResponsiveSize.height(context, .45),
          ),
          decoration: BoxDecoration(
            color: (connected ? AppColors.success : AppColors.textMuted)
                .withValues(alpha: .12),
            borderRadius: BorderRadius.circular(30),
          ),
          child: customText(
            text: connecting ? 'جاري الاتصال' : connected ? 'متصل' : 'غير متصل',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: connecting
                ? AppColors.info
                : connected
                    ? AppColors.success
                    : Colors.white70,
            isBold: true,
          ),
        ),
      ],
    );
  }
}

class ObdExpandHint extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const ObdExpandHint({
    super.key,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 3),
          vertical: ResponsiveSize.height(context, .8),
        ),
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: .18),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.monitor_heart_rounded,
              color: AppColors.info,
              size: ResponsiveSize.width(context, 4.5),
            ),
            SizedBox(width: ResponsiveSize.width(context, 2)),
            Expanded(
              child: customText(
                text: expanded
                    ? 'إخفاء العدادات والبيانات الحية'
                    : 'عرض العدادات والبيانات الحية',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: Colors.white,
                isBold: true,
              ),
            ),
            AnimatedRotation(
              turns: expanded ? .5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
