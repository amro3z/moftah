import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:moftah/data/models/app_bar.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/widgets/technician_app_bar.dart';
import 'package:moftah/ui/technician/widgets/technician_nav_bar.dart';
import 'package:moftah/ui/technician/widgets/technician_request_card.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianHome extends StatelessWidget {
  const TechnicianHome({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TechnicianStore.instance;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final preview = store.requests.take(3).toList();
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                TechnicianHomeAppBar(
                  data: HomeAppBarModel(technician: store.appBar),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      ResponsiveSize.width(context, 4),
                      ResponsiveSize.height(context, 1.6),
                      ResponsiveSize.width(context, 4),
                      ResponsiveSize.height(context, 10),
                    ),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: customText(
                              text: 'طلبات جديدة',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontLg,
                              ),
                              color: AppColors.primary,
                              isBold: true,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/technician/requests',
                            ),
                            child: customText(
                              text: 'عرض المزيد',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontSm,
                              ),
                              color: AppColors.secondary,
                              isBold: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.height(context, .5)),
                      ...preview.map(
                        (request) => TechnicianRequestCard(
                          request: request,
                          onDetails: () => Navigator.pushNamed(
                            context,
                            '/technician/request-details',
                            arguments: request,
                          ),
                          onOffer: () => Navigator.pushNamed(
                            context,
                            '/technician/send-offer',
                            arguments: request,
                          ),
                          onReject: () => store.reject(request.id),
                        ),
                      ),
                      if (preview.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(
                            ResponsiveSize.width(context, 8),
                          ),
                          child: Center(
                            child: customText(
                              text: 'لا توجد طلبات جديدة حالياً',
                              fontSize: ResponsiveSize.width(
                                context,
                                AppSizes.fontMd,
                              ),
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const TechnicianBottomNav(current: 0),
          );
        },
      ),
    );
  }
}
