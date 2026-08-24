import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/data/models/service_offer_model.dart';
import 'package:moftah/data/store/service_request_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class OfferDetailsScreen extends StatefulWidget {
  final ServiceOfferModel offer;

  const OfferDetailsScreen({super.key, required this.offer});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    final report = ServiceRequestStore.instance.activeReport;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new_rounded),
              ),
              Expanded(
                child: customText(
                  text: 'تفاصيل العرض',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                  color: AppColors.primary,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
          child: Column(
            children: [
              _providerCard(context),
              SizedBox(height: ResponsiveSize.height(context, 1.5)),
              _offerSummary(context),
              if (report != null) ...[
                SizedBox(height: ResponsiveSize.height(context, 1.5)),
                _requestSummary(context, report.problemSummary, report.vehicleName),
              ],
              SizedBox(height: ResponsiveSize.height(context, 2)),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.success, padding: EdgeInsets.symmetric(vertical: ResponsiveSize.height(context, 1.45))),
                      onPressed: _processing ? null : _accept,
                      icon: Icon(Icons.check_circle_outline_rounded),
                      label: Text('قبول', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 2)),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.danger, padding: EdgeInsets.symmetric(vertical: ResponsiveSize.height(context, 1.45))),
                      onPressed: _processing
                          ? null
                          : () {
                              ServiceRequestStore.instance.rejectOffer(widget.offer);
                              Navigator.pop(context);
                            },
                      icon: Icon(Icons.close_rounded),
                      label: Text('رفض', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/repair-chat', arguments: _repairFromOffer()),
                  icon: Icon(Icons.chat_bubble_outline_rounded),
                  label: Text('محادثة الفني', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _providerCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .16), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: ResponsiveSize.width(context, 8),
            backgroundColor: AppColors.secondary.withValues(alpha: .1),
            child: Icon(widget.offer.providerType == 'ورشة' ? Icons.car_repair_rounded : Icons.engineering_rounded, color: AppColors.secondary),
          ),
          SizedBox(width: ResponsiveSize.width(context, 3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(text: widget.offer.providerName, fontSize: ResponsiveSize.width(context, AppSizes.fontXl), color: AppColors.primary, isBold: true),
                customText(text: '${widget.offer.providerType} • ${widget.offer.specialty}', fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.textMuted),
                SizedBox(height: ResponsiveSize.height(context, .4)),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: AppColors.warning, size: ResponsiveSize.width(context, 4.62)),
                    customText(text: widget.offer.rating.toStringAsFixed(1), fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.primary, isBold: true),
                    SizedBox(width: ResponsiveSize.width(context, 2)),
                    Icon(Icons.location_on_rounded, color: AppColors.danger, size: ResponsiveSize.width(context, 4.1)),
                    customText(text: '${widget.offer.distanceKm.toStringAsFixed(1)} كم', fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.textMuted),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _offerSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .16),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(text: 'العرض المقدم', fontSize: ResponsiveSize.width(context, AppSizes.fontLg), color: AppColors.primary, isBold: true),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          _line(context, 'رسوم الفحص', '${widget.offer.inspectionFee} جنيه'),
          _line(context, 'التكلفة المتوقعة', '${widget.offer.minEstimatedCost} – ${widget.offer.maxEstimatedCost} جنيه'),
          _line(context, 'مدة الإصلاح', widget.offer.estimatedDuration),
          _line(context, 'التوفر', widget.offer.availability),
          SizedBox(height: ResponsiveSize.height(context, 1)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
            child: customText(text: widget.offer.note, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _requestSummary(BuildContext context, String problem, String vehicle) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .14),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(text: 'البلاغ المرتبط بالعرض', fontSize: ResponsiveSize.width(context, AppSizes.fontMd), color: AppColors.primary, isBold: true),
          SizedBox(height: ResponsiveSize.height(context, .6)),
          customText(text: vehicle, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.textMuted),
          customText(text: problem, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.primary, isBold: true),
        ],
      ),
    );
  }

  Widget _line(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveSize.height(context, .7)),
      child: Row(
        children: [
          Expanded(child: customText(text: title, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.textMuted)),
          customText(text: value, fontSize: ResponsiveSize.width(context, AppSizes.fontSm), color: AppColors.primary, isBold: true),
        ],
      ),
    );
  }

  CurrentRepairModel _repairFromOffer() {
    final report = ServiceRequestStore.instance.activeReport;
    return CurrentRepairModel(
      title: report?.problemSummary ?? widget.offer.specialty,
      workshopName: widget.offer.providerName,
      location: '${widget.offer.distanceKm.toStringAsFixed(1)} كم',
      currentStage: RepairStage.approval,
      vehicleName: report == null ? '' : '${report.vehicleName} ${report.year}',
      technicianName: widget.offer.providerName,
      expectedFinish: widget.offer.estimatedDuration,
      estimatedCost: widget.offer.maxEstimatedCost.toDouble(),
    );
  }

  Future<void> _accept() async {
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    ServiceRequestStore.instance.acceptOffer(widget.offer);
    Navigator.pushNamedAndRemoveUntil(context, '/repair-details', (route) => route.settings.name == '/home', arguments: _repairFromOffer());
  }
}
