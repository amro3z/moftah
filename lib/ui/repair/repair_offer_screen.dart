import 'package:flutter/material.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/repair/widgets/animated_entrance.dart';
import 'package:moftah/utils/responsive.dart';

class RepairOfferScreen extends StatefulWidget {
  final CurrentRepairModel data;

  const RepairOfferScreen({super.key, required this.data});

  @override
  State<RepairOfferScreen> createState() => _RepairOfferScreenState();
}

class _RepairOfferScreenState extends State<RepairOfferScreen> {
  String? _decision;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: customText(
            text: 'طلب موافقة جديد',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
            color: AppColors.primary,
            isBold: true,
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.primary,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedEntrance(child: _warningCard(context)),
              SizedBox(height: ResponsiveSize.height(context, 1.6)),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 70),
                child: _problemImage(context),
              ),
              SizedBox(height: ResponsiveSize.height(context, 2)),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 120),
                child: customText(
                  text: 'تفاصيل التكلفة',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                  color: AppColors.primary,
                  isBold: true,
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1)),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 170),
                child: _costCard(context),
              ),
              SizedBox(height: ResponsiveSize.height(context, 2)),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _decision == null
                    ? _actionButtons(context)
                    : _decisionBanner(context),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.2)),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(
                    ResponsiveSize.height(context, 6),
                  ),
                  side: const BorderSide(color: AppColors.secondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/repair-chat',
                  arguments: data,
                ),
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: customText(
                  text: 'محادثة الفني',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.secondary,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _warningCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.warning.withValues(alpha: .42)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 2)),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: widget.data.discoveredIssueTitle,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.primary,
                  isBold: true,
                ),
                SizedBox(height: ResponsiveSize.height(context, .5)),
                customText(
                  text: widget.data.discoveredIssueDescription,
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.progressBackground,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _problemImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              widget.data.problemImageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.surfaceLight,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceLight,
                alignment: Alignment.center,
                child: Icon(
                  Icons.car_repair_rounded,
                  color: AppColors.textMuted,
                  size: ResponsiveSize.width(context, 12),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
            child: Row(
              children: [
                const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.textMuted,
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: customText(
                    text: 'صورة من الفني توضح الجزء الذي يحتاج الاستبدال',
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.progressBackground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _costCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border.withValues(alpha: .12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _costRow(context, widget.data.offeredPartName, widget.data.partCost),
          Divider(color: AppColors.border.withValues(alpha: .14)),
          _costRow(context, 'المصنعية', widget.data.laborCost),
          Divider(color: AppColors.border.withValues(alpha: .14)),
          Row(
            children: [
              customText(
                text: 'الإجمالي',
                fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                color: AppColors.primary,
                isBold: true,
              ),
              const Spacer(),
              customText(
                text: '${widget.data.offerTotal.toStringAsFixed(0)} جنيه',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                color: AppColors.secondary,
                isBold: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _costRow(BuildContext context, String title, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveSize.height(context, .7),
      ),
      child: Row(
        children: [
          Expanded(
            child: customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.progressBackground,
            ),
          ),
          customText(
            text: '${amount.toStringAsFixed(0)} جنيه',
            fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
            color: AppColors.primary,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      key: const ValueKey('actions'),
      children: [
        Expanded(
          child: SizedBox(
            height: ResponsiveSize.height(context, 6.2),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
              onPressed: () => setState(() => _decision = 'approved'),
              icon: const Icon(Icons.check_box_rounded, color: Colors.white),
              label: customText(
                text: 'موافقة',
                fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                color: Colors.white,
                isBold: true,
              ),
            ),
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 3)),
        Expanded(
          child: SizedBox(
            height: ResponsiveSize.height(context, 6.2),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xffEF403B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
              onPressed: () => setState(() => _decision = 'rejected'),
              icon: const Icon(Icons.close_rounded, color: Colors.white),
              label: customText(
                text: 'رفض',
                fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                color: Colors.white,
                isBold: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _decisionBanner(BuildContext context) {
    final approved = _decision == 'approved';
    return Container(
      key: ValueKey(_decision),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 4),
        vertical: ResponsiveSize.height(context, 1.4),
      ),
      decoration: BoxDecoration(
        color: (approved ? AppColors.success : AppColors.danger).withValues(
          alpha: .1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            approved ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: approved ? AppColors.success : AppColors.danger,
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          customText(
            text: approved ? 'تمت الموافقة على العرض' : 'تم رفض العرض',
            fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
            color: approved ? AppColors.success : AppColors.danger,
            isBold: true,
          ),
        ],
      ),
    );
  }
}
