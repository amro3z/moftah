import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/utils/responsive.dart';

class ObdConnectionInfo extends StatelessWidget {
  final ObdState state;

  const ObdConnectionInfo({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 3),
        vertical: ResponsiveSize.height(context, .9),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          const Icon(Icons.memory_rounded, color: AppColors.info),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: customText(
              text: state.adapterName.isNotEmpty
                  ? state.adapterName
                  : state.connectedDevice?.name ?? 'ELM327',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: Colors.white,
              isBold: true,
            ),
          ),
          if (state.status == ObdStatus.reading)
            SizedBox(
              width: ResponsiveSize.width(context, 4),
              height: ResponsiveSize.width(context, 4),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.info,
              ),
            ),
        ],
      ),
    );
  }
}

class ObdWaitingForData extends StatelessWidget {
  const ObdWaitingForData({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('obd-waiting'),
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.info,
          ),
          SizedBox(width: ResponsiveSize.width(context, 3)),
          Expanded(
            child: customText(
              text: 'بنقرأ بيانات العربية والعدادات...',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: Colors.white70,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }
}

class ObdStatusMessage extends StatelessWidget {
  final String text;

  const ObdStatusMessage({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warning),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: customText(
              text: text,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
