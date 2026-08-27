import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/vehicle_health/cubit/obd_state.dart';
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
              Icon(Icons.car_repair_rounded, color: AppColors.info, size: ResponsiveSize.width(context, 4.87)),
              SizedBox(width: ResponsiveSize.width(context, 2.05)),
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
          SizedBox(height: ResponsiveSize.height(context, 0.71)),
          customText(
            text: 'هنا بنعرضلك اللي بيحصل أثناء الفحص خطوة بخطوة. التفاصيل التقنية موجودة علشان نعرف سبب أي مشكلة في الاتصال.',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: Colors.white60,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.18)),
          Container(
            constraints: BoxConstraints(maxHeight: ResponsiveSize.height(context, 26.07)),
            padding: EdgeInsets.all(ResponsiveSize.width(context, 2.56)),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .28),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: state.trace.map((line) => Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, 0.59)),
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
