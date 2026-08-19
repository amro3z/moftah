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
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: .22), borderRadius: BorderRadius.circular(AppSizes.radiusMd), border: Border.all(color: Colors.white.withValues(alpha: .07))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Icon(Icons.terminal_rounded, color: AppColors.info, size: 19),
          const SizedBox(width: 8),
          Expanded(child: customText(text: 'سجل الفحص الفعلي TX / RX', fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: Colors.white, isBold: true)),
        ]),
        const SizedBox(height: 8),
        customText(text: 'TX = الأمر المرسل للـ ELM327، و RX = الرد الحقيقي. لو Bluetooth اتصل لكن 0100 رجع NO DATA أو UNABLE TO CONNECT فالمشكلة بين القطعة و ECU وليست الاقتران.', fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: Colors.white60),
        const SizedBox(height: 10),
        Container(
          constraints: const BoxConstraints(maxHeight: 190),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: .28), borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(reverse: true, child: Directionality(textDirection: TextDirection.ltr, child: SelectableText(state.trace.join('\n'), style: const TextStyle(fontFamily: 'monospace', fontSize: 11, height: 1.45, color: Colors.white70)))),
        ),
      ]),
    );
  }
}
