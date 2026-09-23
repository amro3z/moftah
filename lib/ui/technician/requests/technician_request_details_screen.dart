import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/technician_models.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/helper/location_map_view.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/widgets/technician_scaffold.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianRequestDetailsScreen extends StatelessWidget {
  final TechnicianRequestModel request;
  const TechnicianRequestDetailsScreen({super.key, required this.request});

  Color get riskColor {
    final v = request.riskLabel;
    if (v.contains('منخفض') || v.contains('بسيط')) return AppColors.success;
    if (v.contains('عالي') || v.contains('مرتفع') || v.contains('خطير')) {
      return AppColors.danger;
    }
    return AppColors.warning;
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: TechnicianScaffold(
      withBackArrow: true,
      title: 'تفاصيل الطلب',
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          ResponsiveSize.width(context, 4),
          ResponsiveSize.height(context, 1),
          ResponsiveSize.width(context, 4),
          ResponsiveSize.height(context, 4),
        ),
        children: [
          _hero(context),
          SizedBox(height: ResponsiveSize.height(context, 1.4)),
          Row(
            children: [
              Expanded(
                child: _mini(
                  context,
                  Icons.location_on_outlined,
                  'المسافة',
                  '${request.distanceKm} كم',
                  AppColors.secondary,
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              Expanded(
                child: _mini(
                  context,
                  Icons.schedule_rounded,
                  'وقت الطلب',
                  request.createdAt,
                  AppColors.info,
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              Expanded(
                child: _mini(
                  context,
                  Icons.warning_amber_rounded,
                  'الخطورة',
                  request.riskLabel,
                  riskColor,
                ),
              ),
            ],
          ),
          _title(context, 'وصف المشكلة'),
          _card(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: request.issueDescription,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.primary,
                  maxLines: 6,
                ),
                if (request.tags.isNotEmpty) ...[
                  SizedBox(height: ResponsiveSize.height(context, 1)),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: request.tags
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: .08),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
          _title(context, 'موقع السيارة'),
          _card(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationMapView(
                  latitude: request.latitude,
                  longitude: request.longitude,
                  height: ResponsiveSize.height(context, 25),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1)),
                customText(
                  isBold: true,
                  text: request.location,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.primary,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          if (request.aiAnalysis != null) ...[
            _title(context, 'تحليل مبدئي'),
            _card(
              context,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.smart_toy_rounded,
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: customText(
                      text: request.aiAnalysis!,
                      isBold: true,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: AppColors.primary,
                      maxLines: 7,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (request.imageUrls.isNotEmpty) ...[
            _title(context, 'المرفقات'),
            SizedBox(
              height: ResponsiveSize.height(context, 10),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: request.imageUrls.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => Container(
                  width: ResponsiveSize.width(context, 28),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMedium,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
          if (request.inspectionFee != null) ...[
            _title(context, 'العرض المرسل'),
            _card(
              context,
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _offerValue(
                          context,
                          'رسوم الفحص',
                          '${request.inspectionFee!.toStringAsFixed(0)} ج',
                        ),
                      ),
                      Expanded(
                        child: _offerValue(
                          context,
                          'التكلفة',
                          '${request.minCost?.toStringAsFixed(0) ?? '-'} - ${request.maxCost?.toStringAsFixed(0) ?? '-'} ج',
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _offerValue(
                          context,
                          'مدة الإصلاح',
                          request.estimatedDuration ?? '-',
                        ),
                      ),
                      Expanded(
                        child: _offerValue(
                          context,
                          'الضمان',
                          request.warranty ?? '-',
                        ),
                      ),
                    ],
                  ),
                  if (request.offerNotes?.trim().isNotEmpty == true) ...[
                    const Divider(height: 22),
                    Align(
                      alignment: Alignment.centerRight,
                      child: customText(
                        text: 'ملاحظات: ${request.offerNotes}',
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: AppColors.textMuted,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          SizedBox(height: ResponsiveSize.height(context, 2)),
          if (request.status == TechnicianRequestStatus.newRequest)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/technician/send-offer',
                      arguments: request,
                    ),
                    icon: const Icon(Icons.local_offer_outlined),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveSize.height(context, 1.4),
                      ),
                    ),
                    label: customText(
                      text: 'إرسال عرض',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                      color: Colors.white,
                      isBold: true,
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      TechnicianStore.instance.reject(request.id);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.danger),
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveSize.height(context, 1.4),
                      ),
                    ),
                    child: customText(
                      text: 'رفض',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                      color: AppColors.danger,
                      isBold: true,
                    ),
                  ),
                ),
              ],
            ),
          if (request.status != TechnicianRequestStatus.newRequest) ...[
            Row(
              children: [
                TechnicianActionCard(
                  title: 'فتح المحادثة القديمة',
                  subtitle: 'متابعة المحادثات السابقة',
                  icon: Icons.chat_bubble_outline_rounded,
                  primary: true,
                  onTap: () => _openChat(context),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                TechnicianActionCard(
                  title: 'مراحل الإصلاح',
                  subtitle: 'متابعة جميع المراحل',
                  icon: Icons.car_repair_rounded,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/technician/repair-steps',
                      arguments: request,
                    );
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );

  Widget _hero(BuildContext c) => Container(
    padding: EdgeInsets.all(ResponsiveSize.width(c, 4)),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.surfaceDark],
      ),
      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: .16),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: ResponsiveSize.width(c, 13),
              height: ResponsiveSize.width(c, 13),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                color: AppColors.info,
              ),
            ),
            SizedBox(width: ResponsiveSize.width(c, 3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: '${request.vehicleName} ${request.vehicleYear}',
                    fontSize: ResponsiveSize.width(c, AppSizes.fontLg),
                    color: Colors.white,
                    isBold: true,
                  ),
                  customText(
                    text: request.issueTitle,
                    fontSize: ResponsiveSize.width(c, AppSizes.fontSm),
                    color: AppColors.textMuted,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveSize.height(c, 1.3)),
        Row(
          children: [
            const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
            const SizedBox(width: 6),
            customText(
              text: request.customerName,
              fontSize: ResponsiveSize.width(c, AppSizes.fontSm),
              color: Colors.white,
              isBold: true,
            ),
            const Spacer(),
            const Icon(
              Icons.place_outlined,
              color: AppColors.textMuted,
              size: 18,
            ),
            const SizedBox(width: 5),
            customText(
              text: request.location,
              fontSize: ResponsiveSize.width(c, AppSizes.fontSm),
              color: AppColors.textMuted,
            ),
          ],
        ),
      ],
    ),
  );
  Widget _mini(BuildContext c, IconData i, String l, String v, Color color) =>
      Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveSize.height(c, 1.1),
          horizontal: ResponsiveSize.width(c, 1.5),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: .05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(i, color: color, size: 20),
            const SizedBox(height: 5),
            customText(
              text: l,
              fontSize: ResponsiveSize.width(c, AppSizes.fontXs),
              color: AppColors.textMuted,
            ),
            customText(
              text: v,
              fontSize: ResponsiveSize.width(c, AppSizes.fontXs),
              color: color,
              isBold: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
  Widget _offerValue(BuildContext c, String l, String v) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customText(
        text: l,
        fontSize: ResponsiveSize.width(c, AppSizes.fontXs),
        color: AppColors.textMuted,
      ),
      customText(
        text: v,
        fontSize: ResponsiveSize.width(c, AppSizes.fontSm),
        color: AppColors.primary,
        isBold: true,
      ),
    ],
  );
  Widget _title(BuildContext c, String t) => Padding(
    padding: EdgeInsets.only(
      top: ResponsiveSize.height(c, 1.6),
      bottom: ResponsiveSize.height(c, .7),
    ),
    child: customText(
      text: t,
      fontSize: ResponsiveSize.width(c, AppSizes.fontLg),
      color: AppColors.primary,
      isBold: true,
    ),
  );
  Widget _card(BuildContext c, Widget child) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(ResponsiveSize.width(c, 4)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      border: Border.all(color: AppColors.border.withValues(alpha: .08)),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: .06),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
  void _openChat(BuildContext c) {
    final x = TechnicianStore.instance.conversations.where(
      (e) => e.requestId == request.id,
    );
    if (x.isNotEmpty) {
      Navigator.pushNamed(c, '/chat', arguments: x.first.toChat(request));
    }
  }
}

class TechnicianActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  const TechnicianActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = primary ? Colors.white : AppColors.secondary;

    return Expanded(
      child: Material(
        color: primary ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 3),
              vertical: ResponsiveSize.height(context, 1.4),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: primary
                  ? null
                  : Border.all(color: AppColors.secondary, width: 1.2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: foregroundColor,
                ),

                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      customText(
                        text: title,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontSm,
                        ),
                        color: primary ? Colors.white : AppColors.primary,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .3)),
                      customText(
                        text: subtitle,
                        fontSize: ResponsiveSize.width(
                          context,
                          AppSizes.fontXs,
                        ),
                        color: primary
                            ? Colors.white.withValues(alpha: .65)
                            : AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Icon(
                  icon,
                  color: foregroundColor,
                  size: ResponsiveSize.width(context, 6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
