import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moftah/data/models/report/problem_report_model.dart';
import 'package:moftah/data/store/service_request_store.dart';
import 'package:moftah/routing/report_workshops_route_arguments.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ProblemAnalysisScreen extends StatefulWidget {
  final ProblemReportModel report;

  const ProblemAnalysisScreen({super.key, required this.report});

  @override
  State<ProblemAnalysisScreen> createState() => _ProblemAnalysisScreenState();
}

class _ProblemAnalysisScreenState extends State<ProblemAnalysisScreen> {
  bool _done = false;
  double _progress = .08;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 360), (timer) {
      if (!mounted) return;
      setState(() {
        _progress = (_progress + .12).clamp(0, 1);
        if (_progress >= 1) {
          _done = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_done,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            child: _done ? _result(context) : _loading(context),
          ),
        ),
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return Container(
      key: const ValueKey('loading'),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 10),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff081D35), Color(0xff113B72)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: .85, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            builder: (_, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: ResponsiveSize.width(context, 20),
              height: ResponsiveSize.width(context, 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff2E6BFF), Color(0xff16B9E9)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: .28),
                    blurRadius: 35,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: ResponsiveSize.width(context, 9.23),
              ),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, 4)),
          customText(
            text: 'جاري تحليل المشكلة...',
            fontSize: ResponsiveSize.width(context, AppSizes.fontXxl),
            color: Colors.white,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, .8)),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(
              key: ValueKey(_analysisText),
              child: customText(
                text: _analysisText,
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                color: const Color(0xff4FE1FF),
              ),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, 3)),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: ResponsiveSize.height(context, 0.71),
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(Color(0xff25C7E8)),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(context, 1)),
          customText(
            text: '${(_progress * 100).round()}%',
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: Colors.white60,
          ),
        ],
      ),
    );
  }

  String get _analysisText {
    if (_progress < .25) return 'بنراجع العربية والأعراض المسجلة...';
    if (_progress < .5) return 'بنحلل الوصف والمرفقات...';
    if (_progress < .75) return 'بنقارن الأعراض بأسباب الأعطال المحتملة...';
    return 'بنرتب الاحتمالات ونحدد التخصص المناسب...';
  }

  Widget _result(BuildContext context) {
    final causes = _probableCauses;

    return Container(
      key: const ValueKey('result'),
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: ResponsiveSize.height(context, 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 5),
                  ResponsiveSize.height(context, 1.5),
                  ResponsiveSize.width(context, 5),
                  ResponsiveSize.height(context, 2.2),
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff0D2136), Color(0xff173B61)],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    SizedBox(height: ResponsiveSize.height(context, 1.4)),
                    _mainResultCard(context),
                    SizedBox(height: ResponsiveSize.height(context, 1.5)),
                    _sectionTitle(context, 'البيانات اللي اتراجعت'),
                    SizedBox(height: ResponsiveSize.height(context, .8)),
                    _inputSummaryCard(context),
                    SizedBox(height: ResponsiveSize.height(context, 1.6)),
                    _sectionTitle(context, 'الأسباب المحتملة'),
                    SizedBox(height: ResponsiveSize.height(context, .8)),
                    ...List.generate(
                      causes.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          bottom: ResponsiveSize.height(context, .9),
                        ),
                        child: _causeCard(context, causes[index], index),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, .7)),
                    _sectionTitle(context, 'توصيات قبل التحرك'),
                    SizedBox(height: ResponsiveSize.height(context, .8)),
                    _recommendationsCard(context),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 5),
                  ResponsiveSize.height(context, 1.6),
                  ResponsiveSize.width(context, 5),
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inspectionNote(context),
                    SizedBox(height: ResponsiveSize.height(context, 2)),
                    _sectionTitle(
                      context,
                      'إزاي تحب تكمل؟',
                      onDark: false,
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 1)),
                    _choiceCard(
                      context,
                      icon: Icons.engineering_rounded,
                      title: 'اختيار فني',
                      subtitle:
                          'شوف الفنيين المتاحين على مفتاح وابعت البلاغ للفني المناسب.',
                      badge: 'أنسب لو العربية مش قادرة تتحرك',
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        '/report-technicians',
                        arguments: widget.report,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 1.1)),
                    _choiceCard(
                      context,
                      icon: Icons.car_repair_rounded,
                      title: 'أقرب ورشة ليك',
                      subtitle:
                          'شوف الورش القريبة من موقع العربية من غير ما نطلب الـGPS تاني.',
                      badge: 'مناسب لو تقدر تتحرك بالعربية',
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        '/report-workshops',
                        arguments: ReportWorkshopsRouteArguments(
                          report: widget.report,
                          userLatitude: widget.report.latitude,
                          userLongitude: widget.report.longitude,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.height(context, 1.1)),
                    _sendToAllCard(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Container(
          width: ResponsiveSize.width(context, 11),
          height: ResponsiveSize.width(context, 11),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(
            Icons.psychology_alt_rounded,
            color: AppColors.secondary,
          ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 3)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                text: 'نتيجة التحليل الذكي',
                fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
                color: Colors.white,
                isBold: true,
              ),
              customText(
                text: 'راجع التفاصيل قبل اختيار طريقة الحصول على الخدمة',
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mainResultCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .07),
        border: Border.all(
          color: Colors.white.withValues(alpha: .10),
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: _shadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _pill(
                context,
                text: 'ثقة التحليل $_confidence%',
                color: const Color(0xff42D997),
              ),
              SizedBox(width: ResponsiveSize.width(context, 1.5)),
              _pill(
                context,
                text: _urgency,
                color: AppColors.warning,
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          customText(
            text: _analysisTitle,
            fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
            color: Colors.white,
            isBold: true,
          ),
          SizedBox(height: ResponsiveSize.height(context, .6)),
          customText(
            text: _analysisDescription,
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: Colors.white70,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.1)),
          Row(
            children: [
              Icon(
                Icons.handyman_rounded,
                color: Color(0xff4FD5FF),
                size: ResponsiveSize.width(context, 4.62),
              ),
              SizedBox(width: ResponsiveSize.width(context, 1.5)),
              Expanded(
                child: customText(
                  text: 'التخصص المقترح: $_suggestedSpecialty',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputSummaryCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: _shadow(),
      ),
      child: Column(
        children: [
          _summaryRow(
            context,
            Icons.directions_car_filled_rounded,
            'السيارة',
            '${widget.report.vehicleName} ${widget.report.year}',
          ),
          _summaryRow(
            context,
            Icons.warning_amber_rounded,
            'الأعراض',
            widget.report.problemSummary,
          ),
          if (widget.report.description.trim().isNotEmpty)
            _summaryRow(
              context,
              Icons.notes_rounded,
              'الوصف',
              widget.report.description.trim(),
            ),
          _summaryRow(
            context,
            Icons.attach_file_rounded,
            'المرفقات',
            '${widget.report.attachmentsCount} مرفق',
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _causeCard(
    BuildContext context,
    _AnalysisCause cause,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          boxShadow: _shadow(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: customText(
                    text: cause.title,
                    fontSize: ResponsiveSize.width(
                      context,
                      AppSizes.fontMd,
                    ),
                    color: AppColors.primary,
                    isBold: true,
                  ),
                ),
                customText(
                  text: '${cause.probability}%',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: cause.color,
                  isBold: true,
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(context, .65)),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: LinearProgressIndicator(
                value: cause.probability / 100,
                minHeight: ResponsiveSize.height(context, 0.59),
                backgroundColor: AppColors.border.withValues(alpha: .13),
                valueColor: AlwaysStoppedAnimation(cause.color),
              ),
            ),
            SizedBox(height: ResponsiveSize.height(context, .6)),
            customText(
              text: cause.description,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendationsCard(BuildContext context) {
    const items = [
      'لو لمبة Check Engine بتومض أو العربية بتفصل، يفضّل عدم الاستمرار في القيادة.',
      'ابدأ بفحص كمبيوتر ودوائر الإشعال قبل تغيير أي قطعة.',
      'اطلب من الفني تأكيد السبب والتكلفة قبل بدء الإصلاح.',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: _shadow(),
      ),
      child: Column(
        children: List.generate(
          items.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1
                  ? 0
                  : ResponsiveSize.height(context, .8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: ResponsiveSize.height(context, .25),
                  ),
                  width: ResponsiveSize.width(context, 6),
                  height: ResponsiveSize.width(context, 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: .08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.secondary,
                    size: ResponsiveSize.width(context, 4.1),
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2)),
                Expanded(
                  child: customText(
                    text: items[index],
                    fontSize: ResponsiveSize.width(
                      context,
                      AppSizes.fontSm,
                    ),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inspectionNote(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: .24),
        ),
        boxShadow: _shadow(alpha: .13),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.warning),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          Expanded(
            child: customText(
              text:
                  'التحليل الذكي لا يغني عن الفحص الفني على الطبيعة. رسوم الفحص المعروضة من الفني أو الورشة منفصلة عن رسوم الانتقال/المواصلات إن وُجدت، وكذلك عن تكلفة قطع الغيار والإصلاح النهائي.',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.primary,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _choiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: _shadow(),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveSize.width(context, 13),
              height: ResponsiveSize.width(context, 13),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .09),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Icon(icon, color: AppColors.secondary),
            ),
            SizedBox(width: ResponsiveSize.width(context, 3)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    text: title,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                    color: AppColors.primary,
                    isBold: true,
                  ),
                  SizedBox(height: ResponsiveSize.height(context, .35)),
                  customText(
                    text: subtitle,
                    fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                    color: AppColors.textMuted,
                  ),
                  SizedBox(height: ResponsiveSize.height(context, .65)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(context, 2),
                      vertical: ResponsiveSize.height(context, .3),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    child: customText(
                      text: badge,
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontXs,
                      ),
                      color: AppColors.success,
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.secondary,
              size: ResponsiveSize.width(context, 5.13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sendToAllCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.8)),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: .13),
        ),
        boxShadow: _shadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveSize.width(context, 10),
                height: ResponsiveSize.width(context, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  Icons.campaign_rounded,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(width: ResponsiveSize.width(context, 2.5)),
              Expanded(
                child: customText(
                  text: 'ابعت البلاغ واستنى العروض',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: AppColors.primary,
                  isBold: true,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(context, .7)),
          customText(
            text:
                'مفتاح هيعرض البلاغ على مقدمي الخدمة المناسبين، والعروض اللي توصلك هتظهر في الهوم وفي شاشة العروض الواردة.',
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.textMuted,
          ),
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.height(context, 1.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
              onPressed: _submitAndGoHome,
              icon: Icon(Icons.send_rounded),
              label: Text(
                'إرسال البلاغ وانتظار العروض',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context,
    String text, {
    bool onDark = true,
  }) {
    return customText(
      text: text,
      fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
      color: onDark ? Colors.white : AppColors.primary,
      isBold: true,
    );
  }

  Widget _summaryRow(
    BuildContext context,
    IconData icon,
    String title,
    String value, {
    bool last = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: last ? 0 : ResponsiveSize.height(context, .85),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ResponsiveSize.width(context, 8),
            height: ResponsiveSize.width(context, 8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: .07),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Icon(icon, color: AppColors.secondary, size: ResponsiveSize.width(context, 4.62)),
          ),
          SizedBox(width: ResponsiveSize.width(context, 2)),
          SizedBox(
            width: ResponsiveSize.width(context, 18),
            child: customText(
              text: title,
              fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
              color: AppColors.textMuted,
            ),
          ),
          Expanded(
            child: customText(
              text: value,
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.primary,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(
    BuildContext context, {
    required String text,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 2),
        vertical: ResponsiveSize.height(context, .35),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: customText(
        text: text,
        fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
        color: color,
        isBold: true,
      ),
    );
  }

  List<BoxShadow> _shadow({double alpha = .16}) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: alpha),
        blurRadius: 20,
        spreadRadius: .2,
        offset: const Offset(0, 7),
      ),
    ];
  }


  int get _confidence {
    var value = 68;
    if (widget.report.symptoms.length >= 2) value += 5;
    if (widget.report.description.trim().isNotEmpty) value += 4;
    if (widget.report.attachmentsCount > 0) value += 4;
    return value.clamp(0, 88).toInt();
  }

  String get _urgency {
    final symptoms = widget.report.symptoms;
    if (symptoms.contains('حرارة') || symptoms.contains('فرامل')) {
      return 'أولوية مرتفعة';
    }
    return 'أولوية متوسطة';
  }

  String get _analysisTitle {
    final symptoms = widget.report.symptoms;
    if (symptoms.contains('حرارة')) {
      return 'الاشتباه الأقرب: دورة تبريد المحرك';
    }
    if (symptoms.contains('فرامل')) {
      return 'الاشتباه الأقرب: نظام الفرامل';
    }
    if (symptoms.contains('كهرباء') || symptoms.contains('مشكلة تشغيل')) {
      return 'الاشتباه الأقرب: كهرباء / تشغيل السيارة';
    }
    return 'الاشتباه الأقرب: المحرك / نظام الإشعال';
  }

  String get _analysisDescription {
    final symptoms = widget.report.symptoms;
    if (symptoms.contains('حرارة')) {
      return 'ارتفاع الحرارة غالبًا يرتبط بدورة التبريد أو المروحة أو الثرموستات. لازم يتأكد الفني من مستوى سائل التبريد وعدم وجود تسريب قبل الاستمرار في القيادة.';
    }
    if (symptoms.contains('فرامل')) {
      return 'الأعراض المسجلة تحتاج فحص مباشر لمنظومة الفرامل، لأن الصوت أو ضعف الاستجابة قد يكون مرتبطًا بالتيل أو الطنابير أو دائرة الفرامل.';
    }
    if (symptoms.contains('كهرباء') || symptoms.contains('مشكلة تشغيل')) {
      return 'صعوبة التشغيل أو الأعراض الكهربائية قد تكون مرتبطة بالبطارية أو الشحن أو الإشعال. الفحص الكهربائي وقراءة OBD يساعدان في تضييق الاحتمالات.';
    }
    return 'الأعراض المسجلة تميل إلى مشكلة مرتبطة بالإشعال أو الاحتراق، مع احتمالات أقل في نظام الوقود. النتيجة دي ترتيب احتمالات وليست تشخيصًا نهائيًا.';
  }

  String get _suggestedSpecialty {
    final symptoms = widget.report.symptoms;
    if (symptoms.contains('حرارة')) return 'فني تبريد ومحركات';
    if (symptoms.contains('فرامل')) return 'فني فرامل وعفشة';
    if (symptoms.contains('كهرباء') || symptoms.contains('مشكلة تشغيل')) {
      return 'فني كهرباء وتشغيل';
    }
    return 'فني محركات وإشعال';
  }

  List<_AnalysisCause> get _probableCauses {
    final symptoms = widget.report.symptoms;

    if (symptoms.contains('حرارة')) {
      return const [
        _AnalysisCause(
          'دورة التبريد',
          82,
          'نقص سائل التبريد أو ضعف تدفقه من الأسباب الشائعة لارتفاع الحرارة.',
          AppColors.danger,
        ),
        _AnalysisCause(
          'ثرموستات / مروحة',
          69,
          'خلل الثرموستات أو المروحة قد يمنع تبريد المحرك بالشكل المطلوب.',
          AppColors.warning,
        ),
        _AnalysisCause(
          'حساس حرارة',
          48,
          'قراءة حساس غير دقيقة ممكن تظهر تحذير حرارة أو تؤثر على التشغيل.',
          AppColors.secondary,
        ),
      ];
    }

    if (symptoms.contains('كهرباء') || symptoms.contains('مشكلة تشغيل')) {
      return const [
        _AnalysisCause(
          'البطارية / نظام الشحن',
          79,
          'ضعف البطارية أو الشحن ممكن يسبب صعوبة تشغيل واضطراب في الكهرباء.',
          AppColors.danger,
        ),
        _AnalysisCause(
          'دائرة الإشعال',
          72,
          'الكويلات أو البوجيهات ممكن تسبب تقطيع أو صعوبة تشغيل.',
          AppColors.warning,
        ),
        _AnalysisCause(
          'توصيلات كهربائية',
          51,
          'فيشة أو أرضي ضعيف ممكن يعمل أعراض متقطعة.',
          AppColors.secondary,
        ),
      ];
    }

    return const [
      _AnalysisCause(
        'البوجيهات',
        78,
        'تآكل أو ضعف البوجيهات ممكن يسبب رعشة أو تقطيع وصوت غير طبيعي.',
        AppColors.danger,
      ),
      _AnalysisCause(
        'كويل الإشعال',
        71,
        'ضعف في شرارة الإشعال قد يظهر كرعشة أو فقدان قوة.',
        AppColors.warning,
      ),
      _AnalysisCause(
        'نظام الوقود',
        54,
        'ضغط الوقود أو الرشاشات احتمال أقل ويحتاج فحص للتأكيد.',
        AppColors.secondary,
      ),
    ];
  }

  Future<void> _submitAndGoHome() async {
    await ServiceRequestStore.instance.submitRequest(widget.report);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }
}

class _AnalysisCause {
  final String title;
  final int probability;
  final String description;
  final Color color;

  const _AnalysisCause(
    this.title,
    this.probability,
    this.description,
    this.color,
  );
}
