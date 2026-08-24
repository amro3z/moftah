import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class VehicleHealthInfoNote extends StatelessWidget {
  const VehicleHealthInfoNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.secondary.withValues(alpha: .12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _item(
            context,
            icon: Icons.verified_user_outlined,
            title: 'يعني إيه دقة التقييم؟',
            body:
                'هي نسبة ثقتنا في نتيجة الحالة. كل ما يكون عندنا بيانات أحدث من OBD أو سجل صيانة أو فحص فني، النسبة بتزيد.',
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          Container(height: ResponsiveSize.height(context, 0.12), color: AppColors.border.withValues(alpha: .14)),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          _item(
            context,
            icon: Icons.cable_rounded,
            title: 'تشغيل OBD-II',
            body:
                'ركّب ELM327 في فيشة OBD-II بالعربية — غالباً تحت الدركسيون أو أسفل التابلوه — شغّل الكونتاكت، اعمل Pair بالبلوتوث، وبعدها اضغط "اتصل بـ ELM327".',
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: ResponsiveSize.width(context, 9),
          height: ResponsiveSize.width(context, 9),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            icon,
            color: AppColors.secondary,
            size: ResponsiveSize.width(context, 4.5),
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2.5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: title,
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.primary,
                isBold: true,
              ),
              SizedBox(height: ResponsiveSize.height(context, .3)),
              customText(
                text: body,
                fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                color: AppColors.textPrimary.withValues(alpha: .7),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
