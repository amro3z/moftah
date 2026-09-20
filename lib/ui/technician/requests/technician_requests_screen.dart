import 'package:flutter/material.dart';

import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/technician/widgets/technician_request_card.dart';
import 'package:moftah/ui/technician/widgets/technician_scaffold.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianRequestsScreen extends StatelessWidget {
  const TechnicianRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TechnicianStore.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TechnicianScaffold(
        current: 1,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context, 'كل الطلبات'),

              Expanded(
                child: AnimatedBuilder(
                  animation: store,
                  builder: (context, _) {
                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        ResponsiveSize.width(context, 4),
                        ResponsiveSize.height(context, 1),
                        ResponsiveSize.width(context, 4),

                        // علشان آخر Card تقدر تطلع
                        // من تحت الـ Bottom Nav.
                        ResponsiveSize.height(context, 13),
                      ),
                      children: store.requests
                          .map(
                            (r) => TechnicianRequestCard(
                              request: r,
                              onDetails: () {
                                Navigator.pushNamed(
                                  context,
                                  '/technician/request-details',
                                  arguments: r,
                                );
                              },
                              onOffer: () {
                                Navigator.pushNamed(
                                  context,
                                  '/technician/send-offer',
                                  arguments: r,
                                );
                              },
                              onReject: () {
                                store.reject(r.id);
                              },
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 4),
        vertical: ResponsiveSize.height(context, 1.5),
      ),
      color: AppColors.background,
      child: customText(
        text: title,
        fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
        color: AppColors.primary,
        isBold: true,
      ),
    );
  }
}
