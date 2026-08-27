import 'package:flutter/material.dart';
import 'package:moftah/data/models/technician/technician_models.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/home/technician_home.dart';
import 'package:moftah/ui/technician/widgets/technician_nav_bar.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianWorksScreen extends StatelessWidget {
  const TechnicianWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TechnicianStore.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
          automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            elevation: 0,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            title: customText(
              text: 'الأعمال',
              fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
              color: AppColors.primary,
              isBold: true,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                ResponsiveSize.height(context, 6.3),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  ResponsiveSize.width(context, 4),
                  0,
                  ResponsiveSize.width(context, 4),
                  ResponsiveSize.height(context, 1),
                ),
                padding: EdgeInsets.all(ResponsiveSize.width(context, 1)),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: .06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  labelColor: AppColors.textSecondary,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'جاري تنفيذها'),
                    Tab(text: 'أعمال سابقة'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              _WorksList(
                items: store.currentJobs,
                isCurrent: true,
              ),
              _WorksList(
                items: store.previousJobs,
                isCurrent: false,
              ),
            ],
          ),
          bottomNavigationBar: const TechnicianBottomNav(current: 2),
        ),
      ),
    );
  }
}

class _WorksList extends StatelessWidget {
  final List<TechnicianRequestModel> items;
  final bool isCurrent;

  const _WorksList({
    required this.items,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: customText(
          text: isCurrent
              ? 'لا توجد أعمال جارية حالياً'
              : 'لا توجد أعمال سابقة حتى الآن',
          fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
          color: AppColors.textMuted,
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 4),
        ResponsiveSize.height(context, 1.5),
        ResponsiveSize.width(context, 4),
        ResponsiveSize.height(context, 12),
      ),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          SizedBox(height: ResponsiveSize.height(context, 1.2)),
      itemBuilder: (context, index) {
        final request = items[index];
        return _WorkCard(
          request: request,
          isCurrent: isCurrent,
          onTap: () => Navigator.pushNamed(
            context,
            '/technician/request-details',
            arguments: request,
          ),
        );
      },
    );
  }
}

class _WorkCard extends StatelessWidget {
  final TechnicianRequestModel request;
  final bool isCurrent;
  final VoidCallback onTap;

  const _WorkCard({
    required this.request,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Ink(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
          decoration: BoxDecoration(
            color: AppColors.textSecondary,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: AppColors.border.withValues(alpha: .08),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: .06),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: ResponsiveSize.width(context, 12),
                    height: ResponsiveSize.width(context, 12),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.secondary.withValues(alpha: .10)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      isCurrent
                          ? Icons.build_circle_rounded
                          : Icons.history_rounded,
                      color: isCurrent
                          ? AppColors.secondary
                          : AppColors.textMuted,
                      size: ResponsiveSize.width(context, 6),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          text:
                              '${request.vehicleName} ${request.vehicleYear}',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                        SizedBox(
                          height: ResponsiveSize.height(context, .25),
                        ),
                        customText(
                          text: request.issueTitle,
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                          color: AppColors.textMuted,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(context, 2),
                      vertical: ResponsiveSize.height(context, .45),
                    ),
                    decoration: BoxDecoration(
                      color: (isCurrent
                              ? AppColors.success
                              : AppColors.info)
                          .withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: customText(
                      text: isCurrent ? 'جاري التنفيذ' : 'مكتمل',
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontXs,
                      ),
                      color: isCurrent ? AppColors.success : AppColors.info,
                      isBold: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.25)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 3),
                  vertical: ResponsiveSize.height(context, 1),
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _Meta(
                        icon: Icons.person_outline_rounded,
                        label: request.customerName,
                      ),
                    ),
                    Expanded(
                      child: _Meta(
                        icon: Icons.location_on_outlined,
                        label: request.location,
                      ),
                    ),
                    Expanded(
                      child: _Meta(
                        icon: Icons.schedule_rounded,
                        label: request.createdAt,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveSize.height(context, 1.2)),
              Row(
                children: [
                  Expanded(
                    child: customText(
                      text: isCurrent
                          ? 'اضغط لمتابعة تفاصيل الشغل والمحادثة'
                          : 'اضغط لمراجعة تفاصيل الطلب والشات القديم',
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontXs,
                      ),
                      color: AppColors.textMuted,
                    ),
                  ),
                  Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.secondary,
                    size: ResponsiveSize.width(context, 4.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Meta({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.secondary,
          size: ResponsiveSize.width(context, 4),
        ),
        SizedBox(height: ResponsiveSize.height(context, .25)),
        customText(
          text: label,
          fontSize: ResponsiveSize.width(context, AppSizes.fontXs),
          color: AppColors.primary,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
