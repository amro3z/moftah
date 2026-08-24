import 'package:flutter/material.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';

Future<bool?> showSparePartsCheckoutDialog({
  required BuildContext context,
  required double total,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: AppColors.primary.withValues(alpha: .62),
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 6.15)),
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 5.13)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .16),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveSize.width(context, 17.44),
                height: ResponsiveSize.height(context, 8.06),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: .10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.secondary,
                  size: ResponsiveSize.width(context, 8.21),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.66)),
              customText(
                text: 'تأكيد الطلب',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
                isBold: true,
                color: AppColors.primary,
              ),
              SizedBox(height: ResponsiveSize.height(context, 0.83)),
              customText(
                text: 'راجع إجمالي الطلب قبل التأكيد. بعد الإرسال هنجهز الطلب للمتابعة.',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textMuted,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.78)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 3.59), vertical: ResponsiveSize.height(context, 1.42)),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.border.withValues(alpha: .10)),
                ),
                child: Row(
                  children: [
                    customText(
                      text: 'إجمالي الطلب',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                    const Spacer(),
                    customText(
                      text: '${total.toStringAsFixed(0)} جنيه',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                      isBold: true,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.9)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: BorderSide(color: AppColors.border.withValues(alpha: .20)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                      ),
                      child: customText(
                        text: 'إلغاء',
                        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                        isBold: true,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 2.31)),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                      ),
                      icon: Icon(Icons.check_rounded, size: ResponsiveSize.width(context, 4.62)),
                      label: customText(
                        text: 'تأكيد الطلب',
                        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                        isBold: true,
                        color: Colors.white,
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
}

Future<void> showSparePartsOrderSuccessDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primary.withValues(alpha: .62),
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 6.15)),
        child: Container(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 5.64)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveSize.width(context, 18.97),
                height: ResponsiveSize.height(context, 8.77),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: ResponsiveSize.width(context, 10.26),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.78)),
              customText(
                text: 'تم إرسال الطلب بنجاح',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
                isBold: true,
                color: AppColors.primary,
              ),
              SizedBox(height: ResponsiveSize.height(context, 0.83)),
              customText(
                text: 'طلبك اتسجل، وهتقدر تتابع حالته بعد ربط الطلبات بالحساب والباك إند.',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: AppColors.textMuted,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveSize.height(context, 2.01)),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  minimumSize: const Size.fromHeight(49),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                ),
                child: customText(
                  text: 'تم',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  isBold: true,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
