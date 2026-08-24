import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_clear_codes_dialog.dart';
import 'package:moftah/utils/responsive.dart';

class ObdActions extends StatelessWidget {
  final ObdState state;
  final bool busy;

  const ObdActions({
    super.key,
    required this.state,
    required this.busy,
  });

  @override
  Widget build(BuildContext context) {
    if (!state.isConnected) {
      return FilledButton.icon(
        onPressed: busy
            ? null
            : () => context.read<ObdCubit>().loadPairedDevices(),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.secondary,
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveSize.height(context, 1.2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        icon: busy
            ? SizedBox(
                width: ResponsiveSize.width(context, 4),
                height: ResponsiveSize.width(context, 4),
                child: CircularProgressIndicator(
                  strokeWidth: ResponsiveSize.width(context, 0.51),
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.bluetooth_searching_rounded),
        label: customText(
          text: busy ? 'جاري فحص Bluetooth...' : 'عرض الأجهزة المقترنة',
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: Colors.white,
          isBold: true,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: busy
                ? null
                : () => context.read<ObdCubit>().refreshDiagnostics(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveSize.height(context, 1.1),
              ),
            ),
            icon: busy
                ? SizedBox(
                    width: ResponsiveSize.width(context, 4),
                    height: ResponsiveSize.width(context, 4),
                    child: CircularProgressIndicator(
                      strokeWidth: ResponsiveSize.width(context, 0.51),
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh_rounded),
            label: customText(
              text: 'تحديث دلوقتي',
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: Colors.white,
              isBold: true,
            ),
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        OutlinedButton(
          onPressed: busy ? null : () => showObdClearCodesDialog(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.warning,
            side: BorderSide(
              color: AppColors.warning.withValues(alpha: .45),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 3),
              vertical: ResponsiveSize.height(context, 1.1),
            ),
          ),
          child: const Icon(Icons.delete_sweep_rounded),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        OutlinedButton(
          onPressed: busy ? null : () => context.read<ObdCubit>().disconnect(),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withValues(alpha: .22)),
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 3),
              vertical: ResponsiveSize.height(context, 1.1),
            ),
          ),
          child: const Icon(Icons.link_off_rounded),
        ),
      ],
    );
  }
}
