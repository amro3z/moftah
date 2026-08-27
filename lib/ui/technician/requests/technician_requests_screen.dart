import 'package:flutter/material.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';

import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/widgets/technician_nav_bar.dart';
import 'package:moftah/ui/technician/widgets/technician_request_card.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianRequestsScreen extends StatelessWidget {
  const TechnicianRequestsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = TechnicianStore.instance;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _bar(context, 'كل الطلبات'),
        body: AnimatedBuilder(
          animation: store,
          builder: (context, _) => ListView(
            padding: EdgeInsets.all(ResponsiveSize.width(context, 4)),
            children: store.requests
                .map(
                  (r) => TechnicianRequestCard(
                    request: r,
                    onDetails: () => Navigator.pushNamed(
                      context,
                      '/technician/request-details',
                      arguments: r,
                    ),
                    onOffer: () => Navigator.pushNamed(
                      context,
                      '/technician/send-offer',
                      arguments: r,
                    ),
                    onReject: () => store.reject(r.id),
                  ),
                )
                .toList(),
          ),
        ),
        bottomNavigationBar: const TechnicianBottomNav(current: 1),
      ),
    );
  }
}

PreferredSizeWidget _bar(BuildContext context, String title) => AppBar(
  scrolledUnderElevation: 0,
  elevation: 0,
  surfaceTintColor: Colors.transparent,
  backgroundColor: AppColors.background,
  automaticallyImplyLeading: false,
  title: customText(
    text: title,
    fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
    color: AppColors.primary,
    isBold: true,
  ),
);
