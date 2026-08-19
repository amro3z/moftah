import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/utils/responsive.dart';

class ObdTracePanel extends StatelessWidget {
  final ObdState state;
  const ObdTracePanel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.trace.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .22),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: Colors.white.withValues(alpha: .07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.car_repair_rounded, color: AppColors.info, size: 19),
              const SizedBox(width: 8),
              Expanded(
                child: customText(
                  text: 'تفاصيل فحص العربية',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          customText(
            text: 'هنا بنعرضلك اللي بيحصل أثناء الفحص خطوة بخطوة. التفاصيل التقنية موجودة علشان نعرف سبب أي مشكلة في الاتصال.',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: Colors.white60,
          ),
          const SizedBox(height: 10),
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .28),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: state.trace.map((line) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: customText(
                    text: _friendlyLine(line),
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                    color: Colors.white70,
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _friendlyLine(String line) {
    if (line.startsWith('TX  ')) {
      return 'بنطلب من جهاز الفحص: ${line.substring(4)}';
    }
    if (line.startsWith('RX  ')) {
      return 'رد جهاز الفحص: ${line.substring(4)}'
          .replaceAll('UNABLE TO CONNECT', 'مش قادر يتواصل مع كمبيوتر العربية')
          .replaceAll('NO DATA', 'مفيش بيانات راجعة')
          .replaceAll('(empty)', 'مفيش رد')
          .replaceAll('SEARCHING', 'بيدور على بروتوكول العربية');
    }

    return line
        .replaceAll('ECU', 'كمبيوتر العربية ECU')
        .replaceAll('Generic OBD-II', 'نظام OBD-II القياسي')
        .replaceAll('Generic OBD', 'نظام OBD القياسي')
        .replaceAll('Bluetooth', 'البلوتوث')
        .replaceAll('SPP/RFCOMM', 'قناة الاتصال بالبلوتوث')
        .replaceAll('PID', 'طلب بيانات PID');
  }
}
