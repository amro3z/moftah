import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/ui/core/constant/obd_stage_text.dart';
import 'package:moftah/utils/responsive.dart';

class ObdConnectionProgress extends StatelessWidget {
  final ObdState state;

  const ObdConnectionProgress({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    const stages = <ObdConnectionStage>[
      ObdConnectionStage.checkingPairedDevices,
      ObdConnectionStage.connectingBluetooth,
      ObdConnectionStage.initializingAdapter,
      ObdConnectionStage.detectingProtocol,
      ObdConnectionStage.readingVehicle,
    ];

    final currentIndex = stages.indexOf(state.connectionStage);

    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.2)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, .15),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Row(
              key: ValueKey(state.connectionStage),
              children: [
                SizedBox(
                  width: ResponsiveSize.width(context, 5),
                  height: ResponsiveSize.width(context, 5),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColors.info,
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2.5)),
                Expanded(
                  child: customText(
                    text: obdStageText(state.connectionStage),
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: Colors.white,
                    isBold: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          Row(
            children: List.generate(stages.length, (index) {
              final completed = currentIndex > index;
              final current = currentIndex == index;

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.width(context, .35),
                  ),
                  decoration: BoxDecoration(
                    color: completed
                        ? AppColors.success
                        : current
                            ? AppColors.info
                            : Colors.white.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          OutlinedButton.icon(
            onPressed: () => context.read<ObdCubit>().cancelConnectionAttempt(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: .22)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
            ),
            icon: const Icon(Icons.close_rounded),
            label: customText(
              text: 'إلغاء محاولة الاتصال',
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: Colors.white,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }
}
