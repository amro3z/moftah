import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/technician_models.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/app_text_field.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class SendOfferScreen extends StatefulWidget {
  final TechnicianRequestModel request;

  const SendOfferScreen({
    super.key,
    required this.request,
  });

  @override
  State<SendOfferScreen> createState() => _SendOfferScreenState();
}

class _SendOfferScreenState extends State<SendOfferScreen> {
  final inspection = TextEditingController(text: '200');
  final min = TextEditingController(text: '900');
  final max = TextEditingController(text: '1400');
  final duration = TextEditingController(text: '1-2 ساعة');
  final notes = TextEditingController();

  String warranty = 'شهر واحد';

  @override
  void dispose() {
    inspection.dispose();
    min.dispose();
    max.dispose();
    duration.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          title: customText(
            text: 'إرسال عرض',
            fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
            color: AppColors.primary,
            isBold: true,
          ),
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              ResponsiveSize.width(context, 4),
              ResponsiveSize.height(context, 1),
              ResponsiveSize.width(context, 4),
              ResponsiveSize.height(context, 3),
            ),
            children: [
              _requestSummary(context),
              SizedBox(height: ResponsiveSize.height(context, 2)),
              _sectionTitle(context, 'التسعير'),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: inspection,
                      label: 'رسوم الفحص',
                      hint: '0',
                      suffixText: 'جنيه',
                      icon: Icons.search_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 2.5)),
                  Expanded(
                    child: AppTextField(
                      controller: duration,
                      label: 'مدة الإصلاح',
                      hint: 'مثال: ساعتان',
                      icon: Icons.schedule_rounded,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.5)),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: min,
                      label: 'أقل تكلفة متوقعة',
                      hint: '0',
                      suffixText: 'جنيه',
                      icon: Icons.trending_down_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 2.5)),
                  Expanded(
                    child: AppTextField(
                      controller: max,
                      label: 'أعلى تكلفة متوقعة',
                      hint: '0',
                      suffixText: 'جنيه',
                      icon: Icons.trending_up_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 2)),
              _sectionTitle(context, 'الضمان'),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              _warrantySelector(context),
              SizedBox(height: ResponsiveSize.height(context, 2)),
              _sectionTitle(context, 'ملاحظات للفحص والإصلاح'),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              AppTextField(
                controller: notes,
                hint: 'اكتب أي تفاصيل مهمة للعميل قبل إرسال العرض...',
                icon: Icons.edit_note_rounded,
                maxLines: 4,
                minLines: 4,
              ),
              SizedBox(height: ResponsiveSize.height(context, 2.5)),
              _offerPreview(context),
              SizedBox(height: ResponsiveSize.height(context, 2)),
              SizedBox(
                height: ResponsiveSize.height(context, 6.5),
                child: FilledButton.icon(
                  onPressed: _sendOffer,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textSecondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                  ),
                  icon: Icon(
                    Icons.send_rounded,
                    size: ResponsiveSize.width(context, 5),
                  ),
                  label: customText(
                    text: 'إرسال العرض للعميل',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: AppColors.textSecondary,
                    isBold: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _requestSummary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .16),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveSize.width(context, 13),
            height: ResponsiveSize.width(context, 13),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(
              Icons.directions_car_filled_rounded,
              color: AppColors.textSecondary,
              size: ResponsiveSize.width(context, 7),
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text:
                      '${widget.request.vehicleName} ${widget.request.vehicleYear}',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.textSecondary,
                  isBold: true,
                ),
                SizedBox(height: ResponsiveSize.height(context, .25)),
                customText(
                  text: widget.request.issueTitle,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.textSecondary.withValues(alpha: .72),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(context, 2.2),
              vertical: ResponsiveSize.height(context, .55),
            ),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(100),
            ),
            child: customText(
              text: widget.request.riskLabel,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: AppColors.warning,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return customText(
      text: text,
      fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
      color: AppColors.primary,
      isBold: true,
    );
  }

  Widget _warrantySelector(BuildContext context) {
    const options = ['شهر واحد', '3 أشهر', '6 أشهر'];
    return Row(
      children: options.map((item) {
        final selected = item == warranty;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: item == options.last
                  ? 0
                  : ResponsiveSize.width(context, 1.5),
            ),
            child: InkWell(
              onTap: () => setState(() => warranty = item),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.height(context, 1.35),
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.secondary.withValues(alpha: .10)
                      : AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: selected
                        ? AppColors.secondary
                        : AppColors.border.withValues(alpha: .12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selected) ...[
                      Icon(
                        Icons.check_circle_rounded,
                        size: ResponsiveSize.width(context, 4),
                        color: AppColors.secondary,
                      ),
                      SizedBox(width: ResponsiveSize.width(context, 1)),
                    ],
                    customText(
                      text: item,
                      fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                      color: selected ? AppColors.secondary : AppColors.primary,
                      isBold: selected,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _offerPreview(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: .12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveSize.width(context, 10),
            height: ResponsiveSize.width(context, 10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.secondary,
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2.5)),
          Expanded(
            child: customText(
              text:
                  'العرض تقديري ويمكن تعديل التكلفة النهائية بعد فحص السيارة والتأكد من سبب العطل.',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.primary,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  void _sendOffer() {
    TechnicianStore.instance.sendOffer(
      widget.request.id,
      inspectionFee: double.tryParse(inspection.text) ?? 0,
      minCost: double.tryParse(min.text) ?? 0,
      maxCost: double.tryParse(max.text) ?? 0,
      duration: duration.text,
      warranty: warranty,
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );

    Navigator.popUntil(
      context,
      (route) =>
          route.settings.name == '/technician/requests' ||
          route.settings.name == '/technician_home' ||
          route.isFirst,
    );
  }
}
