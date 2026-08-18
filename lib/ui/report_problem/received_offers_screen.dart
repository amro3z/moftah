import 'package:flutter/material.dart';
import 'package:moftah/data/models/service_offer_model.dart';
import 'package:moftah/data/store/service_request_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class ReceivedOffersScreen extends StatelessWidget {
  const ReceivedOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ServiceRequestStore.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final offers = store.offers;
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: AppColors.primary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text: 'العروض الواردة',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontXl,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                        customText(
                          text: store.waitingForOffers
                              ? 'لسه بنستقبل عروض جديدة...'
                              : offers.isEmpty
                                  ? 'مفيش عروض لسه'
                                  : 'وصلك ${offers.length} عروض',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontXs,
                          ),
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: offers.isEmpty
                ? _emptyState(context, store.waitingForOffers)
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            ResponsiveSize.width(context, 5),
                            ResponsiveSize.height(context, 1.5),
                            ResponsiveSize.width(context, 5),
                            ResponsiveSize.height(context, .8),
                          ),
                          child: _summaryCard(context, store),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          ResponsiveSize.width(context, 5),
                          0,
                          ResponsiveSize.width(context, 5),
                          ResponsiveSize.height(context, 4),
                        ),
                        sliver: SliverList.separated(
                          itemCount: offers.length,
                          separatorBuilder: (_, __) => SizedBox(
                            height: ResponsiveSize.height(context, 1.2),
                          ),
                          itemBuilder: (context, index) =>
                              _offerCard(context, offers[index], index),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(BuildContext context, ServiceRequestStore store) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: .88),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: _shadow(),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveSize.width(context, 12),
            height: ResponsiveSize.width(context, 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: Colors.white,
            ),
          ),
          SizedBox(width: ResponsiveSize.width(context, 3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  text: '${store.offers.length} عروض متاحة للمقارنة',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                  color: Colors.white,
                  isBold: true,
                ),
                SizedBox(height: ResponsiveSize.height(context, .3)),
                customText(
                  text: store.waitingForOffers
                      ? 'ممكن توصلك عروض إضافية، اختار الأنسب وقت ما تحب.'
                      : 'قارن رسوم الفحص والتكلفة والمدة قبل القبول.',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, bool waiting) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(ResponsiveSize.width(context, 7)),
        padding: EdgeInsets.all(ResponsiveSize.width(context, 6)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: _shadow(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveSize.width(context, 20),
              height: ResponsiveSize.width(context, 20),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: waiting
                  ? const Padding(
                      padding: EdgeInsets.all(22),
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : const Icon(
                      Icons.inbox_outlined,
                      color: AppColors.secondary,
                      size: 34,
                    ),
            ),
            SizedBox(height: ResponsiveSize.height(context, 2)),
            customText(
              text: waiting
                  ? 'بنستنى رد الفنيين والورش'
                  : 'مفيش عروض مستلمة لحد دلوقتي',
              fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
              color: AppColors.primary,
              isBold: true,
            ),
            SizedBox(height: ResponsiveSize.height(context, .5)),
            customText(
              text: waiting
                  ? 'ارجع للهوم عادي، وهتظهر العروض هناك أول ما توصل.'
                  : 'بعد إرسال بلاغ جديد، كل العروض هتتجمع هنا.',
              fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _offerCard(
    BuildContext context,
    ServiceOfferModel offer,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + index * 80),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - value)),
          child: child,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            '/offer-details',
            arguments: offer,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Ink(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(
                color: AppColors.border.withValues(alpha: .10),
              ),
              boxShadow: _shadow(),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ResponsiveSize.width(context, 13),
                      height: ResponsiveSize.width(context, 13),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: Icon(
                        offer.providerType == 'ورشة'
                            ? Icons.car_repair_rounded
                            : Icons.engineering_rounded,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.width(context, 3)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            text: offer.providerName,
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontLg,
                            ),
                            color: AppColors.primary,
                            isBold: true,
                          ),
                          customText(
                            text: '${offer.providerType} • ${offer.specialty}',
                            fontSize: ResponsiveSize.width(
                              context,
                              AppSizes.fontSm,
                            ),
                            color: AppColors.textMuted,
                          ),
                          SizedBox(height: ResponsiveSize.height(context, .4)),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.warning,
                                size: 17,
                              ),
                              customText(
                                text: offer.rating.toStringAsFixed(1),
                                fontSize: ResponsiveSize.width(
                                  context,
                                  AppSizes.fontSm,
                                ),
                                color: AppColors.primary,
                                isBold: true,
                              ),
                              SizedBox(width: ResponsiveSize.width(context, 2)),
                              const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.danger,
                                size: 16,
                              ),
                              customText(
                                text:
                                    '${offer.distanceKm.toStringAsFixed(1)} كم',
                                fontSize: ResponsiveSize.width(
                                  context,
                                  AppSizes.fontSm,
                                ),
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(context, 2),
                        vertical: ResponsiveSize.height(context, .35),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: .09),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: customText(
                        text: offer.availability,
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
                SizedBox(height: ResponsiveSize.height(context, 1.2)),
                Container(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _metric(
                          context,
                          'رسوم الفحص',
                          '${offer.inspectionFee} جنيه',
                        ),
                      ),
                      _divider(),
                      Expanded(
                        child: _metric(
                          context,
                          'التكلفة المتوقعة',
                          '${offer.minEstimatedCost}–${offer.maxEstimatedCost}',
                        ),
                      ),
                      _divider(),
                      Expanded(
                        child: _metric(
                          context,
                          'المدة',
                          offer.estimatedDuration,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.height(context, 1.1)),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/offer-details',
                          arguments: offer,
                        ),
                        child: const Text(
                          'التفاصيل',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.width(context, 2)),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                        onPressed: () => Navigator.pushNamed(
                          context,
                          '/offer-details',
                          arguments: offer,
                        ),
                        child: const Text(
                          'مراجعة العرض',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _metric(BuildContext context, String title, String value) {
    return Column(
      children: [
        customText(
          text: title,
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: AppColors.textMuted,
        ),
        SizedBox(height: ResponsiveSize.height(context, .2)),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: customText(
            text: value,
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.primary,
            isBold: true,
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 38,
        color: AppColors.border.withValues(alpha: .20),
      );

  List<BoxShadow> _shadow() => [
        BoxShadow(
          color: Colors.black.withValues(alpha: .15),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ];
}
