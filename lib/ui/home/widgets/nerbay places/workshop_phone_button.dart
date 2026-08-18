import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/phone_launcher.dart';
import 'package:moftah/utils/responsive.dart';

class WorkshopPhoneButton extends StatelessWidget {
  final List<String> phones;
  final bool expanded;

  const WorkshopPhoneButton({
    super.key,
    required this.phones,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (phones.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => _showPhones(context),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Container(
        width: expanded ? double.infinity : null,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 2.5),
          vertical: ResponsiveSize.height(context, 0.7),
        ),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.14)),
        ),
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(
              Icons.phone_rounded,
              color: AppColors.success,
              size: ResponsiveSize.width(context, 3.8),
            ),

            SizedBox(width: ResponsiveSize.width(context, 2)),

            if (expanded) Expanded(child: _label(context)) else _label(context),

            if (phones.length > 1) ...[
              SizedBox(width: ResponsiveSize.width(context, 1)),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 1.4),
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: customText(
                  text: '${phones.length}',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: AppColors.success,
                  isBold: true,
                ),
              ),
            ],

            if (expanded) const Spacer(),

            Spacer(),

            Icon(
              Icons.keyboard_arrow_up_rounded,
              color: AppColors.success,
              size: ResponsiveSize.width(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext context) {
    if (phones.length == 1) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: customText(
          text: phones.first,
          fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
          color: AppColors.success,
          isBold: true,
        ),
      );
    }

    return customText(
      text: 'أرقام التواصل',
      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
      color: AppColors.success,
      isBold: true,
    );
  }

  void _showPhones(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                ResponsiveSize.width(context, 5),
                ResponsiveSize.height(context, 1.2),
                ResponsiveSize.width(context, 5),
                ResponsiveSize.height(context, 3),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  SizedBox(height: ResponsiveSize.height(context, 2)),

                  Align(
                    alignment: Alignment.centerRight,
                    child: customText(
                      text: 'أرقام التواصل',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                  ),

                  SizedBox(height: ResponsiveSize.height(context, 1)),

                  ...phones.map((phone) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: ResponsiveSize.height(context, 0.8),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          PhoneLauncher.call(phone);
                        },
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveSize.width(context, 3),
                            vertical: ResponsiveSize.height(context, 1.2),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusSm,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: ResponsiveSize.width(context, 9),
                                height: ResponsiveSize.width(context, 9),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(
                                    alpha: 0.10,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.call_rounded,
                                  color: AppColors.success,
                                  size: ResponsiveSize.width(context, 4.5),
                                ),
                              ),

                              SizedBox(width: ResponsiveSize.width(context, 3)),

                              Expanded(
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: customText(
                                      text: phone,
                                      fontSize: ResponsiveSize.width(
                                        context,
                                        AppSizes.fontMd,
                                      ),
                                      color: AppColors.primary,
                                      isBold: true,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: ResponsiveSize.width(context, 2)),

                              Icon(
                                Icons.chevron_left_rounded,
                                color: AppColors.textMuted,
                                size: ResponsiveSize.width(context, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
