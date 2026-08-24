import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_actions.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_connection_header.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_connection_info.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_connection_progress.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_connection_tip.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_device_selector.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_live_dashboard.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_trace_panel.dart';
import 'package:moftah/utils/responsive.dart';

class ObdDiagnosticsCard extends StatefulWidget {
  const ObdDiagnosticsCard({super.key});

  @override
  State<ObdDiagnosticsCard> createState() => _ObdDiagnosticsCardState();
}

class _ObdDiagnosticsCardState extends State<ObdDiagnosticsCard> {
  bool _expanded = false;
  Timer? _liveTimer;
  Timer? _dtcTimer;

  @override
  void dispose() {
    _stopLiveUpdates();
    super.dispose();
  }

  void _toggleExpanded(ObdState state) {
    setState(() => _expanded = !_expanded);
    if (state.isConnected) _startLiveUpdates();
  }

  void _startLiveUpdates() {
    if (_liveTimer?.isActive == true) return;

    _liveTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (!mounted) return;
      final cubit = context.read<ObdCubit>();
      if (cubit.state.isConnected &&
          cubit.state.connectionStage == ObdConnectionStage.done) {
        cubit.refreshLiveData();
      }
    });

    _dtcTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      final cubit = context.read<ObdCubit>();
      if (cubit.state.isConnected &&
          cubit.state.connectionStage == ObdConnectionStage.done) {
        cubit.refreshTroubleCodes();
      }
    });
  }

  void _stopLiveUpdates() {
    _liveTimer?.cancel();
    _dtcTimer?.cancel();
    _liveTimer = null;
    _dtcTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ObdCubit, ObdState>(
      listener: (context, state) {
        if (!state.isConnected) {
          _stopLiveUpdates();
        } else if (state.connectionStage == ObdConnectionStage.done) {
          _startLiveUpdates();
        }
      },
      builder: (context, state) {
        final busy = state.status == ObdStatus.loadingDevices ||
            state.status == ObdStatus.connecting ||
            state.status == ObdStatus.reading;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .10),
                blurRadius: _expanded ? 22 : 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: state.isConnected && !state.isConnectionFlowRunning
                    ? () => _toggleExpanded(state)
                    : null,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                child: ObdConnectionHeader(state: state),
              ),
              if (state.isConnectionFlowRunning) ...[
                SizedBox(height: ResponsiveSize.height(context, 1.2)),
                ObdConnectionProgress(state: state),
              ],
              if (state.message != null) ...[
                SizedBox(height: ResponsiveSize.height(context, 1)),
                ObdStatusMessage(text: state.message!),
              ],
              if (state.isConnected && !state.isConnectionFlowRunning) ...[
                SizedBox(height: ResponsiveSize.height(context, 1.1)),
                ObdConnectionInfo(state: state),
                SizedBox(height: ResponsiveSize.height(context, .9)),
                ObdExpandHint(
                  expanded: _expanded,
                  onTap: () => _toggleExpanded(state),
                ),
              ],
              AnimatedSize(
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: _expanded &&
                        state.isConnected &&
                        !state.isConnectionFlowRunning
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: ResponsiveSize.height(context, 1.4),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOut,
                          child: state.snapshot == null
                              ? const ObdWaitingForData()
                              : ObdLiveDashboard(
                                  key: ValueKey(
                                    '${state.snapshot!.rpm}-'
                                    '${state.snapshot!.speedKmh}-'
                                    '${state.snapshot!.coolantTemperature}-'
                                    '${state.snapshot!.adapterVoltage}',
                                  ),
                                  snapshot: state.snapshot!,
                                ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (!state.isConnected) ...[
                SizedBox(height: ResponsiveSize.height(context, 1.2)),
                ObdDeviceSelector(state: state),
              ],
              if (state.trace.isNotEmpty) ...[
                SizedBox(height: ResponsiveSize.height(context, 1.2)),
                ObdTracePanel(state: state),
              ],
              SizedBox(height: ResponsiveSize.height(context, 1.2)),
              const ObdConnectionTip(),
              SizedBox(height: ResponsiveSize.height(context, 1.4)),
              ObdActions(state: state, busy: busy),
            ],
          ),
        );
      },
    );
  }
}
