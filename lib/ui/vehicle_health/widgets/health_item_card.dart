import 'package:flutter/material.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/data/models/vehicle_health_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class HealthItemCard extends StatelessWidget {
  final VehicleHealthItemModel item;
  final ObdSnapshotModel? obdSnapshot;

  const HealthItemCard({
    super.key,
    required this.item,
    this.obdSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveItem = _effectiveItem;
    final color = _statusColor(effectiveItem.status);
    final isEngine = effectiveItem.title.contains('محرك');
    final isElectrical = effectiveItem.title.contains('كهرب');
    final hasLiveObd =
        (isEngine || isElectrical) && obdSnapshot?.ecuAvailable == true;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: hasLiveObd
              ? AppColors.info.withValues(alpha: .20)
              : AppColors.border.withValues(alpha: .12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .055),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveSize.width(context, 10),
                height: ResponsiveSize.width(context, 10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .11),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  _icon(effectiveItem.title),
                  color: color,
                  size: ResponsiveSize.width(context, 5),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: effectiveItem.title,
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontLg,
                      ),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    if (hasLiveObd) ...[
                      SizedBox(
                        height: ResponsiveSize.height(context, .25),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: ResponsiveSize.width(context, 1.79),
                            height: ResponsiveSize.height(context, 0.83),
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.width(context, 1)),
                          customText(
                            text: 'OBD مباشر',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontXs,
                            ),
                            color: AppColors.success,
                            isBold: true,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              _score(context, effectiveItem, color),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          customText(
            text: effectiveItem.reason,
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: const Color(0xff60758A),
          ),
          if (hasLiveObd) ...[
            SizedBox(height: ResponsiveSize.height(context, 1.1)),
            if (isEngine)
              _engineLiveData(context, obdSnapshot!)
            else if (isElectrical)
              _electricalLiveData(context, obdSnapshot!),
          ],
          SizedBox(height: ResponsiveSize.height(context, 1.1)),
          Wrap(
            spacing: ResponsiveSize.width(context, 2),
            runSpacing: ResponsiveSize.height(context, .5),
            children: [
              _pill(
                context,
                'المصدر: ${_sourceText(effectiveItem.source)}',
                AppColors.secondary,
              ),
              _pill(
                context,
                'الثقة ${effectiveItem.confidence}%',
                _confidenceColor(effectiveItem.confidence),
              ),
            ],
          ),
          if (effectiveItem.actionText != null) ...[
            SizedBox(height: ResponsiveSize.height(context, 1)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveSize.width(context, 3),
                vertical: ResponsiveSize.height(context, .8),
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: color,
                    size: ResponsiveSize.width(context, 4),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 2)),
                  Expanded(
                    child: customText(
                      text: effectiveItem.actionText!,
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontSm,
                      ),
                      color: color,
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  VehicleHealthItemModel get _effectiveItem {
    final snapshot = obdSnapshot;
    if (snapshot?.ecuAvailable != true) return item;

    if (item.title.contains('محرك')) {
      return _engineItemFromObd(snapshot!);
    }

    if (item.title.contains('كهرب')) {
      return _electricalItemFromObd(snapshot!);
    }

    return item;
  }

  VehicleHealthItemModel _engineItemFromObd(ObdSnapshotModel snapshot) {
    final engineCodes = snapshot.troubleCodes
        .where((code) => code.code.startsWith('P'))
        .toList();
    final hasOverheat = (snapshot.coolantTemperature ?? 0) >= 110;
    final hasWarnings = engineCodes.isNotEmpty || hasOverheat;

    return item.copyWith(
      confidence: item.confidence < 95 ? 95 : item.confidence,
      source: VehicleHealthSource.obd,
      status: hasWarnings ? VehicleHealthStatus.attention : item.status,
      reason: hasWarnings
          ? 'قراءة OBD الحالية فيها ${engineCodes.length} كود أعطال للمحرك${hasOverheat ? ' وحرارة مرتفعة' : ''}.'
          : 'OBD متصل مباشرة بالسيارة، ولا توجد مؤشرات أعطال للمحرك في القراءة الحالية.',
      actionText: hasWarnings ? 'راجع أكواد الأعطال وبيانات المحرك بالأسفل' : null,
      clearActionText: !hasWarnings,
    );
  }

  VehicleHealthItemModel _electricalItemFromObd(ObdSnapshotModel snapshot) {
    final voltage = snapshot.adapterVoltage;
    final engineRunning = (snapshot.rpm ?? 0) > 0;
    final electricalCodes = snapshot.troubleCodes.where((code) {
      final value = code.code.toUpperCase();
      return value.startsWith('U') ||
          value == 'P0560' || value == 'P0561' ||
          value == 'P0562' || value == 'P0563';
    }).toList();

    bool voltageWarning = false;
    if (voltage != null) {
      voltageWarning = engineRunning
          ? voltage < 13.2 || voltage > 15.0
          : voltage < 11.8 || voltage > 13.0;
    }

    final hasWarning = voltageWarning || electricalCodes.isNotEmpty;
    final reason = voltage == null
        ? 'OBD متصل، لكن قراءة الجهد غير متاحة من القطعة حالياً.'
        : hasWarning
            ? 'قراءة الجهد الحالية ${voltage.toStringAsFixed(1)}V${electricalCodes.isNotEmpty ? ' مع وجود ${electricalCodes.length} كود كهرباء/اتصال' : ''} وتحتاج مراجعة.'
            : 'قراءة الجهد الحالية ${voltage.toStringAsFixed(1)}V ضمن النطاق المتوقع ${engineRunning ? 'أثناء تشغيل المحرك' : 'في الحالة الحالية'}. ';

    return item.copyWith(
      confidence: voltage == null ? 70 : 92,
      source: VehicleHealthSource.obd,
      status: hasWarning ? VehicleHealthStatus.attention : VehicleHealthStatus.good,
      reason: reason,
      actionText: hasWarning ? 'راجع الجهد وأكواد الكهرباء قبل الاعتماد على التقييم' : null,
      clearActionText: !hasWarning,
    );
  }

  Widget _engineLiveData(BuildContext context, ObdSnapshotModel snapshot) {
    final values = <Widget>[
      _liveMetric(
        context,
        icon: Icons.speed_rounded,
        label: 'RPM',
        value: snapshot.rpm == null ? '--' : '${snapshot.rpm}',
      ),
      _liveMetric(
        context,
        icon: Icons.device_thermostat_rounded,
        label: 'الحرارة',
        value: snapshot.coolantTemperature == null
            ? '--'
            : '${snapshot.coolantTemperature}°C',
      ),
      _liveMetric(
        context,
        icon: Icons.settings_suggest_rounded,
        label: 'الحمل',
        value: snapshot.engineLoadPercent == null
            ? '--'
            : '${snapshot.engineLoadPercent!.toStringAsFixed(0)}%',
      ),
    ];

    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 2.5)),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          for (var index = 0; index < values.length; index++) ...[
            Expanded(child: values[index]),
            if (index != values.length - 1)
              Container(
                width: ResponsiveSize.width(context, 0.26),
                height: ResponsiveSize.height(context, 4),
                color: AppColors.border.withValues(alpha: .20),
              ),
          ],
        ],
      ),
    );
  }

  Widget _electricalLiveData(
    BuildContext context,
    ObdSnapshotModel snapshot,
  ) {
    final voltage = snapshot.adapterVoltage;
    final running = (snapshot.rpm ?? 0) > 0;
    final electricalCodes = snapshot.troubleCodes.where((code) {
      final value = code.code.toUpperCase();
      return value.startsWith('U') ||
          value == 'P0560' || value == 'P0561' ||
          value == 'P0562' || value == 'P0563';
    }).length;

    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 2.5)),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          Expanded(
            child: _liveMetric(
              context,
              icon: Icons.bolt_rounded,
              label: 'الجهد',
              value: voltage == null ? '--' : '${voltage.toStringAsFixed(1)} V',
            ),
          ),
          Container(
            width: ResponsiveSize.width(context, 0.26),
            height: ResponsiveSize.height(context, 4),
            color: AppColors.border.withValues(alpha: .20),
          ),
          Expanded(
            child: _liveMetric(
              context,
              icon: Icons.power_settings_new_rounded,
              label: 'المحرك',
              value: running ? 'يعمل' : 'متوقف',
            ),
          ),
          Container(
            width: ResponsiveSize.width(context, 0.26),
            height: ResponsiveSize.height(context, 4),
            color: AppColors.border.withValues(alpha: .20),
          ),
          Expanded(
            child: _liveMetric(
              context,
              icon: Icons.warning_amber_rounded,
              label: 'أكواد كهرباء',
              value: '$electricalCodes',
            ),
          ),
        ],
      ),
    );
  }

  Widget _liveMetric(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ResponsiveSize.width(context, 4),
          color: AppColors.info,
        ),
        SizedBox(height: ResponsiveSize.height(context, .25)),
        Directionality(
          textDirection: TextDirection.ltr,
          child: customText(
            text: value,
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.primary,
            isBold: true,
          ),
        ),
        customText(
          text: label,
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: AppColors.textMuted,
        ),
      ],
    );
  }

  Widget _score(
    BuildContext context,
    VehicleHealthItemModel effectiveItem,
    Color color,
  ) =>
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2.5),
          vertical: ResponsiveSize.height(context, .55),
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        child: customText(
          text: effectiveItem.score == null
              ? 'غير مؤكد'
              : '${effectiveItem.score}/100',
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: color,
          isBold: true,
        ),
      );

  Widget _pill(
    BuildContext context,
    String text,
    Color color,
  ) =>
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2),
          vertical: ResponsiveSize.height(context, .45),
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        child: customText(
          text: text,
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: color,
          isBold: true,
        ),
      );

  Color _statusColor(VehicleHealthStatus status) => switch (status) {
        VehicleHealthStatus.excellent => AppColors.success,
        VehicleHealthStatus.good => AppColors.secondary,
        VehicleHealthStatus.attention => AppColors.warning,
        VehicleHealthStatus.critical => AppColors.danger,
        VehicleHealthStatus.unknown => AppColors.textMuted,
      };

  Color _confidenceColor(int value) => value >= 80
      ? AppColors.success
      : value >= 55
          ? AppColors.warning
          : AppColors.danger;

  String _sourceText(VehicleHealthSource source) => switch (source) {
        VehicleHealthSource.obd => 'OBD',
        VehicleHealthSource.maintenanceHistory => 'سجل الصيانة',
        VehicleHealthSource.technicianInspection => 'فحص فني',
        VehicleHealthSource.userInput => 'بياناتك',
        VehicleHealthSource.estimated => 'تقديري',
      };

  IconData _icon(String title) {
    if (title.contains('محرك')) return Icons.settings_rounded;
    if (title.contains('زيت')) return Icons.oil_barrel_rounded;
    if (title.contains('كهرب')) return Icons.battery_charging_full_rounded;
    if (title.contains('إطار')) return Icons.tire_repair_rounded;
    return Icons.speed_rounded;
  }
}
