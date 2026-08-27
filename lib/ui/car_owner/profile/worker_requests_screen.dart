import 'package:flutter/material.dart';
import 'package:moftah/data/store/profile_history_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/utils/responsive.dart';

class WorkerRequestsScreen extends StatelessWidget {
  const WorkerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = ProfileHistoryStore.instance.workerRequests;

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
                  text: 'طلبات الفنيين والعمال',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
        body: ListView.separated(
          padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
          itemCount: requests.length,
          separatorBuilder: (_, __) =>
              SizedBox(height: ResponsiveSize.height(context, 1)),
          itemBuilder: (context, index) {
            final request = requests[index];

            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/profile/worker-request-details',
                  arguments: request,
                ),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveSize.width(context, 3.5)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .16),
                        blurRadius: 14,
                        spreadRadius: 0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: .10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: ResponsiveSize.width(context, 12),
                        height: ResponsiveSize.width(context, 12),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: .09),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusSm,
                          ),
                        ),
                        child: Icon(
                          Icons.engineering_rounded,
                          color: AppColors.secondary,
                          size: ResponsiveSize.width(context, 6),
                        ),
                      ),
                      SizedBox(width: ResponsiveSize.width(context, 3)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              text: request.serviceTitle,
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontMd,
                              ),
                              color: AppColors.primary,
                              isBold: true,
                            ),
                            customText(
                              text: request.providerName,
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXs,
                              ),
                              color: AppColors.textMuted,
                            ),
                            customText(
                              text:
                                  '${request.distanceKm.toStringAsFixed(1)} كم • ${request.estimatedArrivalMinutes} دقيقة',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontXs,
                              ),
                              color: AppColors.secondary,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.textMuted,
                        size: ResponsiveSize.width(context, 4),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
