import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_device_selector.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_trace_panel.dart';
import 'package:moftah/utils/responsive.dart';

class ObdDiagnosticsCard extends StatefulWidget {
  const ObdDiagnosticsCard({super.key});

  @override
  State<ObdDiagnosticsCard> createState() => _ObdDiagnosticsCardState();
}

class _ObdDiagnosticsCardState extends State<ObdDiagnosticsCard>
    with TickerProviderStateMixin {
  bool _expanded = false;
  Timer? _liveTimer;

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  void _toggleExpanded(ObdState state) {
    setState(() => _expanded = !_expanded);

    if (_expanded && state.isConnected) {
      _startLiveUpdates();
    } else {
      _liveTimer?.cancel();
    }
  }

  void _startLiveUpdates() {
    _liveTimer?.cancel();
    _liveTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final cubit = context.read<ObdCubit>();
      final state = cubit.state;
      if (_expanded &&
          state.isConnected &&
          state.status != ObdStatus.reading &&
          state.status != ObdStatus.connecting) {
        cubit.refreshDiagnostics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ObdCubit, ObdState>(
      listener: (context, state) {
        if (!state.isConnected) {
          _liveTimer?.cancel();
        } else if (_expanded && _liveTimer?.isActive != true) {
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
                child: _header(context, state),
              ),
              if (state.isConnectionFlowRunning) ...[
                SizedBox(height: ResponsiveSize.height(context, 1.2)),
                _connectionProgress(context, state),
              ],
              if (state.message != null) ...[
                SizedBox(height: ResponsiveSize.height(context, 1)),
                _message(context, state.message!),
              ],
              if (state.isConnected && !state.isConnectionFlowRunning) ...[
                SizedBox(height: ResponsiveSize.height(context, 1.1)),
                _connectionInfo(context, state),
                SizedBox(height: ResponsiveSize.height(context, .9)),
                _expandHint(context, state),
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
                              ? _waitingForData(context)
                              : _expandedSnapshot(
                                  context,
                                  state.snapshot!,
                                  key: ValueKey(
                                    '${state.snapshot!.rpm}-'
                                    '${state.snapshot!.speedKmh}-'
                                    '${state.snapshot!.coolantTemperature}-'
                                    '${state.snapshot!.adapterVoltage}',
                                  ),
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
              SizedBox(height: ResponsiveSize.height(context, 1.4)),
              _actions(context, state, busy),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context, ObdState state) {
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
                    ? _stageText(state.connectionStage)
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

  Widget _connectionProgress(BuildContext context, ObdState state) {
    final stages = <ObdConnectionStage>[
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
                    text: _stageText(state.connectionStage),
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
        ],
      ),
    );
  }

  String _stageText(ObdConnectionStage stage) => switch (stage) {
        ObdConnectionStage.checkingPairedDevices =>
          'بنفحص أجهزة البلوتوث المقترنة...',
        ObdConnectionStage.waitingForDeviceSelection => 'اختار جهاز Bluetooth المقترن...',
        ObdConnectionStage.connectingBluetooth =>
          'بنعمل اتصال Bluetooth مع القطعة...',
        ObdConnectionStage.initializingAdapter =>
          'بنجهز ELM327 بأوامر AT...',
        ObdConnectionStage.detectingProtocol =>
          'بنطلب من ELM327 اكتشاف بروتوكول العربية...',
        ObdConnectionStage.readingVehicle =>
          'بنتواصل مع ECU ونقرأ بيانات العربية...',
        ObdConnectionStage.ecuNotResponding =>
          'Bluetooth متصل، لكن ECU لم يرد',
        ObdConnectionStage.done => 'تم الاتصال وECU أرسل البيانات',
        ObdConnectionStage.idle => 'جاهز للاتصال',
      };

  Widget _connectionInfo(BuildContext context, ObdState state) {
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

  Widget _expandHint(BuildContext context, ObdState state) {
    return InkWell(
      onTap: () => _toggleExpanded(state),
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
                text: _expanded
                    ? 'إخفاء العدادات والبيانات الحية'
                    : 'عرض العدادات والبيانات الحية',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: Colors.white,
                isBold: true,
              ),
            ),
            AnimatedRotation(
              turns: _expanded ? .5 : 0,
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

  Widget _waitingForData(BuildContext context) {
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

  Widget _expandedSnapshot(
    BuildContext context,
    ObdSnapshotModel snapshot, {
    Key? key,
  }) {
    if (!snapshot.ecuAvailable) {
      return Container(
        key: key,
        child: _message(
          context,
          'الـ ELM327 متصلة، لكن مفيش ECU بيرد. لو القطعة واخدة باور فقط من غير عربية فده طبيعي.',
        ),
      );
    }

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: customText(
                text: 'العدادات الحية',
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                color: Colors.white,
                isBold: true,
              ),
            ),
            _liveBadge(context),
          ],
        ),
        SizedBox(height: ResponsiveSize.height(context, 1.2)),
        _gauges(context, snapshot),
        SizedBox(height: ResponsiveSize.height(context, 1.5)),
        _secondaryMetrics(context, snapshot),
        SizedBox(height: ResponsiveSize.height(context, 1.6)),
        _troubleCodes(context, snapshot),
      ],
    );
  }

  Widget _liveBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, .4),
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 1)),
          customText(
            text: 'LIVE',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.success,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _gauges(BuildContext context, ObdSnapshotModel snapshot) {
    return Row(
      children: [
        Expanded(
          child: _gauge(
            context,
            title: 'RPM',
            value: snapshot.rpm?.toDouble(),
            displayValue: snapshot.rpm == null ? '--' : '${snapshot.rpm}',
            maxValue: 8000,
            icon: Icons.speed_rounded,
            accent: AppColors.info,
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        Expanded(
          child: _gauge(
            context,
            title: 'السرعة',
            value: snapshot.speedKmh?.toDouble(),
            displayValue:
                snapshot.speedKmh == null ? '--' : '${snapshot.speedKmh}',
            unit: 'كم/س',
            maxValue: 240,
            icon: Icons.directions_car_filled_rounded,
            accent: AppColors.secondary,
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        Expanded(
          child: _gauge(
            context,
            title: 'حرارة المحرك',
            value: snapshot.coolantTemperature?.toDouble(),
            displayValue: snapshot.coolantTemperature == null
                ? '--'
                : '${snapshot.coolantTemperature}',
            unit: '°C',
            maxValue: 130,
            icon: Icons.device_thermostat_rounded,
            accent: _temperatureColor(snapshot.coolantTemperature),
          ),
        ),
      ],
    );
  }

  Widget _gauge(
    BuildContext context, {
    required String title,
    required double? value,
    required String displayValue,
    required double maxValue,
    required IconData icon,
    required Color accent,
    String unit = '',
  }) {
    final progress = ((value ?? 0) / maxValue).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 1.5),
        vertical: ResponsiveSize.height(context, 1.1),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: ResponsiveSize.width(context, 18),
            height: ResponsiveSize.width(context, 18),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: animatedValue,
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                        backgroundColor:
                            AppColors.progressBackground.withValues(alpha: .7),
                        valueColor: AlwaysStoppedAnimation(accent),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: accent,
                          size: ResponsiveSize.width(context, 3.7),
                        ),
                        customText(
                          text: displayValue,
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: Colors.white,
                          isBold: true,
                        ),
                        if (unit.isNotEmpty)
                          customText(
                            text: unit,
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontXs,
                            ),
                            color: Colors.white60,
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, .65)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: Colors.white70,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _secondaryMetrics(BuildContext context, ObdSnapshotModel snapshot) {
    final metrics = <Widget>[];

    if (snapshot.adapterVoltage != null) {
      metrics.add(_metric(
        context,
        'الجهد',
        '${snapshot.adapterVoltage!.toStringAsFixed(1)} V',
        Icons.battery_charging_full_rounded,
        AppColors.success,
      ));
    }
    if (snapshot.engineLoadPercent != null) {
      metrics.add(_metric(
        context,
        'حمل المحرك',
        '${snapshot.engineLoadPercent!.toStringAsFixed(0)}%',
        Icons.settings_suggest_rounded,
        AppColors.warning,
      ));
    }
    if (snapshot.throttlePositionPercent != null) {
      metrics.add(_metric(
        context,
        'دعسة البنزين',
        '${snapshot.throttlePositionPercent!.toStringAsFixed(0)}%',
        Icons.compress_rounded,
        AppColors.info,
      ));
    }
    if (snapshot.intakeAirTemperature != null) {
      metrics.add(_metric(
        context,
        'حرارة هواء السحب',
        '${snapshot.intakeAirTemperature}°C',
        Icons.air_rounded,
        AppColors.secondary,
      ));
    }

    if (metrics.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        customText(
          text: 'بيانات إضافية',
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: Colors.white,
          isBold: true,
        ),
        SizedBox(height: ResponsiveSize.height(context, .8)),
        Wrap(
          spacing: ResponsiveSize.width(context, 2),
          runSpacing: ResponsiveSize.height(context, .8),
          children: metrics,
        ),
      ],
    );
  }

  Widget _metric(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color accent,
  ) {
    return Container(
      width: ResponsiveSize.width(context, 38),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2.5),
        vertical: ResponsiveSize.height(context, 1),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveSize.width(context, 8),
            height: ResponsiveSize.width(context, 8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: accent,
              size: ResponsiveSize.width(context, 4),
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: value,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: Colors.white,
                  isBold: true,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: customText(
                    text: title,
                    fontSize: ResponsiveSize.width(
                      context,
                      AppSizes.fontXs,
                    ),
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _troubleCodes(BuildContext context, ObdSnapshotModel snapshot) {
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
                borderRadius: BorderRadius.circular(20),
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
          ...snapshot.troubleCodes.map((code) => _dtcItem(context, code)),
      ],
    );
  }

  Widget _dtcItem(BuildContext context, ObdTroubleCodeModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveSize.height(context, .7)),
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.danger.withValues(alpha: .16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: customText(
                      text: item.code,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                      color: Colors.white,
                      isBold: true,
                    ),
                  ),
                ),
                customText(
                  text: item.system,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _temperatureColor(int? temperature) {
    if (temperature == null) return AppColors.info;
    if (temperature >= 110) return AppColors.danger;
    if (temperature >= 100) return AppColors.warning;
    return AppColors.success;
  }

  Widget _message(BuildContext context, String text) {
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

  Widget _actions(BuildContext context, ObdState state, bool busy) {
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
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
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
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh_rounded),
            label: customText(
              text: 'تحديث الفحص',
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: Colors.white,
              isBold: true,
            ),
          ),
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
