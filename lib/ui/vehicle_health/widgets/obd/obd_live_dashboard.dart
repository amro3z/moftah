import 'package:flutter/material.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_connection_info.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_gauge.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_metric_card.dart';
import 'package:moftah/ui/vehicle_health/widgets/obd/obd_trouble_codes.dart';
import 'package:moftah/utils/responsive.dart';

class ObdLiveDashboard extends StatelessWidget {
  final ObdSnapshotModel snapshot;

  const ObdLiveDashboard({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    if (!snapshot.ecuAvailable) {
      return const ObdStatusMessage(
        text:
            'الـ ELM327 متصلة، لكن مفيش ECU بيرد. لو القطعة واخدة باور فقط من غير عربية فده طبيعي.',
      );
    }

    return Column(
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
            const _LiveBadge(),
          ],
        ),
        SizedBox(height: ResponsiveSize.height(context, 1.2)),
        _Gauges(snapshot: snapshot),
        SizedBox(height: ResponsiveSize.height(context, 1.5)),
        _SecondaryMetrics(snapshot: snapshot),
        SizedBox(height: ResponsiveSize.height(context, 1.6)),
        ObdTroubleCodes(snapshot: snapshot),
      ],
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
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
            text: 'مباشر',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.success,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _Gauges extends StatelessWidget {
  final ObdSnapshotModel snapshot;

  const _Gauges({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ObdGauge(
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
          child: ObdGauge(
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
          child: ObdGauge(
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

  Color _temperatureColor(int? temperature) {
    if (temperature == null) return AppColors.info;
    if (temperature >= 110) return AppColors.danger;
    if (temperature >= 100) return AppColors.warning;
    return AppColors.success;
  }
}

class _SecondaryMetrics extends StatelessWidget {
  final ObdSnapshotModel snapshot;

  const _SecondaryMetrics({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final metrics = <Widget>[];

    if (snapshot.adapterVoltage != null) {
      metrics.add(
        ObdMetricCard(
          title: 'فولت البطارية',
          value: '${snapshot.adapterVoltage!.toStringAsFixed(1)} V',
          icon: Icons.battery_charging_full_rounded,
          accent: AppColors.success,
        ),
      );
    }

    if (snapshot.engineLoadPercent != null) {
      metrics.add(
        ObdMetricCard(
          title: 'حمل الموتور (LOAD)',
          value: '${snapshot.engineLoadPercent!.toStringAsFixed(0)}%',
          icon: Icons.settings_suggest_rounded,
          accent: AppColors.warning,
        ),
      );
    }

    if (snapshot.throttlePositionPercent != null) {
      metrics.add(
        ObdMetricCard(
          title: 'دعسة البنزين (TPS)',
          value: '${snapshot.throttlePositionPercent!.toStringAsFixed(0)}%',
          icon: Icons.compress_rounded,
          accent: AppColors.info,
        ),
      );
    }

    if (snapshot.intakeAirTemperature != null) {
      metrics.add(
        ObdMetricCard(
          title: 'حرارة الهوا الداخل (IAT)',
          value: '${snapshot.intakeAirTemperature}°C',
          icon: Icons.air_rounded,
          accent: AppColors.secondary,
        ),
      );
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
}
