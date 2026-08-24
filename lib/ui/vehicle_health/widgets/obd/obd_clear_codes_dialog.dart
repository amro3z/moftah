import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/utils/responsive.dart';

Future<void> showObdClearCodesDialog(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: .55),
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 6),
        ),
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveSize.width(context, 15),
                height: ResponsiveSize.width(context, 15),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: .10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_sweep_rounded,
                  color: AppColors.warning,
                  size: ResponsiveSize.width(context, 7),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.4)),
              customText(
                text: 'مسح أعطال العربية',
                fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                color: AppColors.primary,
                isBold: true,
              ),
              SizedBox(height: ResponsiveSize.height(context, .8)),
              Center(
                child: customText(
                  text:
                      'هنمسح أكواد الأعطال المخزنة وبيانات الفحص المرتبطة بيها. '
                      'لو سبب المشكلة لسه موجود، العطل ممكن يظهر تاني.',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.textMuted,
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.2)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: .07),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: customText(
                  text:
                      'الأفضل تعمل المسح والكونتاكت ON والموتور مطفي. '
                      'الأكواد الدائمة ممكن ما تتمسحش يدويًا.',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.6)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.height(context, 1.1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        ),
                      ),
                      child: customText(
                        text: 'رجوع',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: AppColors.textMuted,
                        isBold: true,
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 2)),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.warning,
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveSize.height(context, 1.1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        ),
                      ),
                      child: customText(
                        text: 'امسح الأعطال',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  if (confirmed != true || !context.mounted) return;

  final ok = await context.read<ObdCubit>().clearTroubleCodes();
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: customText(
        text: ok
            ? 'راجعنا العربية بعد المسح وحدّثنا الأعطال.'
            : 'العطل لسه ظاهر. جرّب والكونتاكت ON والموتور مطفي.',
        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
        color: Colors.white,
      ),
    ),
  );
}
