import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/repair/widgets/animated_entrance.dart';
import 'package:moftah/utils/responsive.dart';

class RepairDetailsScreen extends StatelessWidget {
  final CurrentRepairModel data;

  const RepairDetailsScreen({super.key, required this.data});

  static const _stageTitles = [
    'تم قبول الطلب',
    'تم استلام السيارة',
    'جاري الفحص',
    'بانتظار موافقتك',
    'جاري الإصلاح',
    'الاختبار',
    'تم الانتهاء',
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: customText(
            text: 'متابعة الإصلاح',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
            color: AppColors.primary,
            isBold: true,
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.primary,
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveSize.width(context, 5),
                    ResponsiveSize.height(context, 2),
                    ResponsiveSize.width(context, 5),
                    ResponsiveSize.height(context, 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedEntrance(child: _summaryCard(context)),
                      SizedBox(height: ResponsiveSize.height(context, 2.2)),
                      AnimatedEntrance(
                        delay: const Duration(milliseconds: 80),
                        child: customText(
                          text: 'مراحل الإصلاح',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontXl,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 1)),
                      AnimatedEntrance(
                        delay: const Duration(milliseconds: 130),
                        child: _timelineCard(context),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedEntrance(
                beginOffset: const Offset(0, 10),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveSize.width(context, 5),
                    ResponsiveSize.height(context, 1),
                    ResponsiveSize.width(context, 5),
                    ResponsiveSize.height(context, 2),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: ResponsiveSize.height(context, 6.2),
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/repair-chat',
                          arguments: data,
                        );
                      },
                      icon: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Colors.white,
                      ),
                      label: customText(
                        text: 'محادثة الفني',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontLg,
                        ),
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveSize.width(context, 12),
                height: ResponsiveSize.width(context, 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  Icons.car_repair_rounded,
                  color: AppColors.secondary,
                  size: ResponsiveSize.width(context, 6),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: data.vehicleName,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, .3)),
                    customText(
                      text: data.title,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: AppColors.progressBackground,
                    ),
                    customText(
                      text: '${data.workshopName} • ${data.location}',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
              _statusChip(context),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.5)),
          Row(
            children: [
              Expanded(
                child: _infoBox(
                  context,
                  title: 'الفني',
                  value: data.technicianName,
                  icon: Icons.engineering_rounded,
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              Expanded(
                child: _infoBox(
                  context,
                  title: 'الانتهاء المتوقع',
                  value: data.expectedFinish,
                  icon: Icons.schedule_rounded,
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              Expanded(
                child: _infoBox(
                  context,
                  title: 'التكلفة الحالية',
                  value: '${data.estimatedCost.toStringAsFixed(0)} ج',
                  icon: Icons.payments_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timelineCard(BuildContext context) {
    final current = _stageIndex(data.currentStage);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 4),
        vertical: ResponsiveSize.height(context, 1.8),
      ),
      decoration: _cardDecoration(),
      child: Column(
        children: List.generate(_stageTitles.length, (index) {
          final done = index < current;
          final active = index == current;
          final isLast = index == _stageTitles.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ResponsiveSize.width(context, 8),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      width: ResponsiveSize.width(context, 5.2),
                      height: ResponsiveSize.width(context, 5.2),
                      decoration: BoxDecoration(
                        color: done
                            ? AppColors.success
                            : active
                            ? AppColors.secondary
                            : AppColors.border.withValues(alpha: .16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        done ? Icons.check_rounded : Icons.circle,
                        color: done || active
                            ? Colors.white
                            : AppColors.textMuted,
                        size: done
                            ? ResponsiveSize.width(context, 3.2)
                            : ResponsiveSize.width(context, 1.8),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: ResponsiveSize.width(context, 0.51),
                        height: ResponsiveSize.height(context, 5.2),
                        color: done
                            ? AppColors.success
                            : AppColors.border.withValues(alpha: .18),
                      ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: ResponsiveSize.height(context, .15),
                    bottom: ResponsiveSize.height(context, 2.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: _stageTitles[index],
                        fontSize: ResponsiveSize.width(
                          context,
                          active ? AppSizes.fontMd : AppSizes.fontSm,
                        ),
                        color: active
                            ? AppColors.primary
                            : done
                            ? AppColors.primary
                            : AppColors.textMuted,
                        isBold: active,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .25)),
                      customText(
                        text: done
                            ? _completedTime(index)
                            : active
                            ? _activeDescription(index)
                            : '—',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXs,
                        ),
                        color: active
                            ? AppColors.secondary
                            : AppColors.textMuted,
                      ),
                      if (active && index == 3) ...[
                        SizedBox(height: ResponsiveSize.height(context, .8)),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.warning,
                            side: BorderSide(color: AppColors.warning),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusSm,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/repair-offer',
                            arguments: data,
                          ),
                          child: customText(
                            text: 'مطلوب موافقتك ←',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontSm,
                            ),
                            color: AppColors.warning,
                            isBold: true,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _statusChip(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2.2),
        vertical: ResponsiveSize.height(context, .45),
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: customText(
        text: data.currentStage == RepairStage.completed
            ? 'مكتمل'
            : 'قيد التنفيذ',
        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
        color: data.currentStage == RepairStage.completed
            ? AppColors.success
            : AppColors.warning,
        isBold: true,
      ),
    );
  }

  Widget _infoBox(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, 1),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.textMuted,
            size: ResponsiveSize.width(context, 4),
          ),
          SizedBox(height: ResponsiveSize.height(context, .35)),
          customText(
            text: title,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.textMuted,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: customText(
              text: value,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.primary,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
    border: Border.all(color: AppColors.border.withValues(alpha: .12)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: .06),
        blurRadius: 14,
        offset: const Offset(0, 5),
      ),
    ],
  );

  int _stageIndex(RepairStage stage) {
    switch (stage) {
      case RepairStage.received:
        return 1;
      case RepairStage.inspection:
        return 2;
      case RepairStage.approval:
        return 3;
      case RepairStage.repairing:
        return 4;
      case RepairStage.testing:
        return 5;
      case RepairStage.completed:
        return 6;
    }
  }

  String _completedTime(int index) {
    const values = [
      '10:30 ص',
      '11:45 ص',
      '12:00 م',
      '12:30 م',
      '1:30 م',
      '2:20 م',
    ];
    if (index < values.length) return values[index];
    return 'تم';
  }

  String _activeDescription(int index) {
    if (index == 3) return 'اكتشف الفني بندًا إضافيًا يحتاج موافقتك';
    if (index == 4) return 'الفني يعمل حاليًا على الإصلاح';
    if (index == 5) return 'يتم اختبار السيارة قبل التسليم';
    return 'المرحلة الحالية';
  }
}
