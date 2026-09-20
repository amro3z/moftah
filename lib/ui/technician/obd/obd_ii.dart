import 'package:flutter/material.dart';

import 'package:moftah/ui/car_owner/vehicle_health/widgets/obd_diagnostics_card.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/widgets/technician_scaffold.dart';
import 'package:moftah/utils/responsive.dart';

class ObdDiagnosticsScreen extends StatelessWidget {
  const ObdDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: TechnicianScaffold(
        current: 4,
        title: 'فحص السيارة',
        body: SafeArea(
          bottom: false,

          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    ResponsiveSize.width(context, 5),
                    ResponsiveSize.height(context, 2),
                    ResponsiveSize.width(context, 5),
                    ResponsiveSize.height(context, 15),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context),

                      SizedBox(height: ResponsiveSize.height(context, 2.5)),

                      const ObdDiagnosticsCard(),

                      SizedBox(height: ResponsiveSize.height(context, 2.5)),

                      _buildTip(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 5)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: .14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveSize.width(context, 14),
            height: ResponsiveSize.width(context, 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: Colors.white.withValues(alpha: .10)),
            ),
            child: Icon(
              Icons.troubleshoot_rounded,
              color: Colors.white,
              size: ResponsiveSize.width(context, 7),
            ),
          ),

          SizedBox(height: ResponsiveSize.height(context, 2)),

          customText(
            text: 'اعرف حالة عربيتك',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
            color: Colors.white,
            isBold: true,
          ),

          SizedBox(height: ResponsiveSize.height(context, .7)),

          customText(
            text:
                'وصّل جهاز OBD بالعربية وابدأ الفحص لقراءة بيانات المحرك واكتشاف أكواد الأعطال.',
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: Colors.white70,
            maxLines: 3,
          ),

          SizedBox(height: ResponsiveSize.height(context, 2)),

          Row(
            children: [
              _feature(context, icon: Icons.speed_rounded, text: 'بيانات حية'),

              SizedBox(width: ResponsiveSize.width(context, 2)),

              _feature(
                context,
                icon: Icons.warning_amber_rounded,
                text: 'أكواد الأعطال',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _feature(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 3),
        vertical: ResponsiveSize.height(context, .8),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: ResponsiveSize.width(context, 4),
          ),

          SizedBox(width: ResponsiveSize.width(context, 1.5)),

          customText(
            text: text,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
            color: Colors.white,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTip(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.secondary.withValues(alpha: .12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveSize.width(context, 10),
            height: ResponsiveSize.width(context, 10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: AppColors.secondary,
              size: ResponsiveSize.width(context, 5),
            ),
          ),

          SizedBox(width: ResponsiveSize.width(context, 3)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: 'قبل ما تبدأ',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: AppColors.primary,
                  isBold: true,
                ),

                SizedBox(height: ResponsiveSize.height(context, .4)),

                customText(
                  text:
                      'تأكد إن جهاز OBD متوصل كويس وإن الكونتاكت مفتوح قبل بدء الفحص.',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
                  color: AppColors.textMuted,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
