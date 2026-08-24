import 'package:flutter/material.dart';
import 'package:moftah/data/models/chat_screen_model.dart';
import 'package:moftah/data/models/profile_history_models.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/phone_launcher.dart';
import 'package:moftah/utils/responsive.dart';

class WorkerRequestDetailsScreen extends StatelessWidget {
  final WorkerRequestHistoryModel request;

  const WorkerRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: ResponsiveSize.width(context, 5),
                ),
              ),
              Expanded(
                child: customText(
                  text: 'تفاصيل الطلب',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
          child: Container(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .16),
                  blurRadius: 14,
                  spreadRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: ResponsiveSize.width(context, 9),
                  backgroundColor: AppColors.secondary.withValues(alpha: .10),
                  child: Icon(
                    Icons.engineering_rounded,
                    color: AppColors.secondary,
                    size: ResponsiveSize.width(context, 9),
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                customText(
                  text: request.providerName,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                  color: AppColors.primary,
                  isBold: true,
                ),
                customText(
                  text: request.serviceTitle,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.textMuted,
                ),
                SizedBox(height: ResponsiveSize.height(context, 1.4)),
                _RequestRow(
                  icon: Icons.storefront_outlined,
                  label: 'المركز',
                  value: request.centerName,
                ),
                _RequestRow(
                  icon: Icons.social_distance_rounded,
                  label: 'المسافة',
                  value: '${request.distanceKm.toStringAsFixed(1)} كم',
                ),
                _RequestRow(
                  icon: Icons.schedule_rounded,
                  label: 'الوصول المتوقع',
                  value: '${request.estimatedArrivalMinutes} دقيقة',
                ),
                _RequestRow(
                  icon: Icons.phone_rounded,
                  label: 'رقم الفني',
                  value: request.providerPhone,
                ),
                _RequestRow(
                  icon: Icons.info_outline_rounded,
                  label: 'الحالة',
                  value: request.status,
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () =>
                            PhoneLauncher.call(request.providerPhone),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.success,
                        ),
                        icon: Icon(
                          Icons.call_rounded,
                          size: ResponsiveSize.width(context, 4.5),
                        ),
                        label: customText(
                          text: 'اتصال',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                          color: Colors.white,
                          isBold: true,
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.width(context, 2)),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/chat',
                          arguments: ChatScreenModel(
                            participantId: request.id,
                            participantName: request.providerName,
                            subtitle: request.serviceTitle,
                            phone: request.providerPhone,
                            initialMessages: const [
                              ChatSeedMessageModel(
                                text: 'تمام، أنا في الطريق إليك.',
                                isMine: false,
                                time: 'الآن',
                              ),
                            ],
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                        icon: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: ResponsiveSize.width(context, 4.5),
                        ),
                        label: customText(
                          text: 'محادثة',
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
  }
}

class _RequestRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RequestRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, .9)),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.secondary,
            size: ResponsiveSize.width(context, 4.5),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          customText(
            text: label,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: AppColors.textMuted,
          ),
          const Spacer(),
          Flexible(
            child: customText(
              text: value,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.primary,
              isBold: true,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
