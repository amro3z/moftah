import 'package:flutter/material.dart';
import 'package:moftah/data/models/report/problem_report_model.dart';
import 'package:moftah/data/models/car_owner/technician_model.dart';
import 'package:moftah/data/store/service_request_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ReportTechniciansScreen extends StatefulWidget {
  final ProblemReportModel report;

  const ReportTechniciansScreen({super.key, required this.report});

  @override
  State<ReportTechniciansScreen> createState() => _ReportTechniciansScreenState();
}

class _ReportTechniciansScreenState extends State<ReportTechniciansScreen> {
  final Set<String> _sentTo = {};
  bool _submittingAll = false;

  static const technicians = [
    TechnicianModel(
      id: 'tech-1',
      name: 'محمد أحمد',
      specialty: 'فني محركات وإشعال',
      rating: 4.9,
      distanceKm: 2.1,
      availableNow: true,
      vehicleBrands: ['Hyundai', 'Toyota', 'Kia'],
      inspectionFee: 200,
    ),
    TechnicianModel(
      id: 'tech-2',
      name: 'أحمد سالم',
      specialty: 'فني كهرباء وإشعال',
      rating: 4.7,
      distanceKm: 3.4,
      availableNow: true,
      vehicleBrands: ['Hyundai', 'Kia'],
      inspectionFee: 150,
    ),
    TechnicianModel(
      id: 'tech-3',
      name: 'خالد إبراهيم',
      specialty: 'فني عام',
      rating: 4.6,
      distanceKm: 4.8,
      availableNow: false,
      vehicleBrands: ['جميع الماركات'],
      inspectionFee: 100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                color: AppColors.primary,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      text: 'الفنيين المناسبين',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                      color: AppColors.primary,
                      isBold: true,
                    ),
                    customText(
                      text: 'حسب نوع المشكلة ومكان العربية',
                      fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: ListView.separated(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
          itemCount: technicians.length,
          separatorBuilder: (_, __) => SizedBox(height: ResponsiveSize.height(context, 1.2)),
          itemBuilder: (context, index) => _technicianCard(context, technicians[index], index),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: EdgeInsets.symmetric(vertical: ResponsiveSize.height(context, 1.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
              ),
              onPressed: _submittingAll ? null : _sendAndWait,
              icon: _submittingAll
                  ? SizedBox(width: ResponsiveSize.width(context, 4.62), height: ResponsiveSize.height(context, 2.13), child: CircularProgressIndicator(strokeWidth: ResponsiveSize.width(context, 0.51), color: Colors.white))
                  : Icon(Icons.campaign_rounded),
              label: Text(
                _submittingAll ? 'جاري إرسال الطلب...' : 'إرسال الطلب وانتظار العروض',
                style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _technicianCard(BuildContext context, TechnicianModel technician, int index) {
    final sent = _sentTo.contains(technician.id);
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + index * 90),
      tween: Tween(begin: 0, end: 1),
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, 18 * (1 - value)), child: child),
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .15), blurRadius: 13, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: ResponsiveSize.width(context, 7),
                  backgroundColor: AppColors.secondary.withValues(alpha: .1),
                  child: Icon(Icons.engineering_rounded, color: AppColors.secondary),
                ),
                SizedBox(width: ResponsiveSize.width(context, 3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: technician.name,
                        fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      customText(
                        text: technician.specialty,
                        fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                        color: AppColors.textMuted,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .4)),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: AppColors.warning, size: ResponsiveSize.width(context, 4.36)),
                          customText(
                            text: technician.rating.toStringAsFixed(1),
                            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                            color: AppColors.primary,
                            isBold: true,
                          ),
                          SizedBox(width: ResponsiveSize.width(context, 2)),
                          Icon(Icons.location_on_rounded, color: AppColors.danger, size: ResponsiveSize.width(context, 4.1)),
                          customText(
                            text: '${technician.distanceKm.toStringAsFixed(1)} كم',
                            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(context, 2), vertical: ResponsiveSize.height(context, .35)),
                  decoration: BoxDecoration(
                    color: technician.availableNow ? AppColors.success.withValues(alpha: .09) : AppColors.warning.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                  ),
                  child: customText(
                    text: technician.availableNow ? 'متاح الآن' : 'متاح لاحقًا',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                    color: technician.availableNow ? AppColors.success : AppColors.warning,
                    isBold: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.2)),
            Container(
              padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
              child: Row(
                children: [
                  Expanded(child: _smallInfo(context, 'رسوم الفحص', '${technician.inspectionFee} جنيه')),
                  Container(width: ResponsiveSize.width(context, 0.26), height: ResponsiveSize.height(context, 4.03), color: AppColors.border.withValues(alpha: .3)),
                  Expanded(child: _smallInfo(context, 'خبرة مع', technician.vehicleBrands.join(' • '))),
                ],
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.1)),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: sent ? null : () => setState(() => _sentTo.add(technician.id)),
                icon: Icon(sent ? Icons.check_circle_rounded : Icons.send_rounded),
                label: Text(sent ? 'تم إرسال البلاغ للفني' : 'إرسال البلاغ للفني', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallInfo(BuildContext context, String title, String value) {
    return Column(
      children: [
        customText(text: title, fontSize: ResponsiveSize.width(context, AppSizes.fontXs), color: AppColors.textMuted),
        SizedBox(height: ResponsiveSize.height(context, .2)),
        customText(text: value, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.primary, isBold: true),
      ],
    );
  }

  Future<void> _sendAndWait() async {
    setState(() => _submittingAll = true);
    await ServiceRequestStore.instance.submitRequest(widget.report);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }
}
