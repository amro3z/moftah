import 'package:flutter/material.dart';
import 'package:moftah/data/models/chat_screen_model.dart';
import 'package:moftah/data/models/profile_history_models.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/phone_launcher.dart';
import 'package:moftah/utils/responsive.dart';

class SparePartOrderDetailsScreen extends StatelessWidget {
  final SparePartOrderModel order;

  const SparePartOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
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
                  text: 'تفاصيل الطلب #${order.id}',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
          children: [
            _CourierCard(order: order),
            SizedBox(height: ResponsiveSize.height(context, 1.5)),
            customText(
              text: 'المنتجات',
              fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
              color: AppColors.primary,
              isBold: true,
            ),
            SizedBox(height: ResponsiveSize.height(context, .8)),
            ...order.items.map(
              (item) => Container(
                margin: EdgeInsets.only(
                  bottom: ResponsiveSize.height(context, .8),
                ),
                padding: EdgeInsets.all(ResponsiveSize.width(context, 3.2)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: .10),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: customText(
                        text: item.name,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                    ),
                    customText(
                      text:
                          '${item.quantity} × ${item.unitPrice.toStringAsFixed(0)}',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourierCard extends StatelessWidget {
  final SparePartOrderModel order;

  const _CourierCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: .10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveSize.width(context, 14),
                height: ResponsiveSize.width(context, 14),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: .10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delivery_dining_rounded,
                  color: AppColors.secondary,
                  size: ResponsiveSize.width(context, 7),
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: order.courierName,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    customText(
                      text: 'مندوب التوصيل',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          _DetailRow(
            icon: Icons.storefront_rounded,
            label: 'المركز',
            value: order.centerName,
          ),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'عنوان المركز',
            value: order.centerAddress,
          ),
          _DetailRow(
            icon: Icons.social_distance_rounded,
            label: 'المسافة بينك وبين المركز',
            value: '${order.centerDistanceKm.toStringAsFixed(1)} كم',
          ),
          _DetailRow(
            icon: Icons.schedule_rounded,
            label: 'الوصول المتوقع',
            value: order.estimatedArrivalMinutes == 0
                ? 'تم التوصيل'
                : '${order.estimatedArrivalMinutes} دقيقة',
          ),
          _DetailRow(
            icon: Icons.phone_rounded,
            label: 'رقم المندوب',
            value: order.courierPhone.isEmpty
                ? 'لم يتم تعيينه بعد'
                : order.courierPhone,
          ),
          if (order.courierPhone.isNotEmpty) ...[
            SizedBox(height: ResponsiveSize.height(context, 1)),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => PhoneLauncher.call(order.courierPhone),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    icon: Icon(
                      Icons.call_rounded,
                      size: ResponsiveSize.width(context, 4.5),
                    ),
                    label: customText(
                      text: 'اتصال',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
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
                        participantId: 'courier-${order.id}',
                        participantName: order.courierName,
                        subtitle: 'مندوب توصيل طلب #${order.id}',
                        phone: order.courierPhone,
                        initialMessages: const [
                          ChatSeedMessageModel(
                            text: 'الطلب خرج من المركز وأنا في الطريق إليك.',
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
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: Colors.white,
                      isBold: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveSize.height(context, .8)),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
