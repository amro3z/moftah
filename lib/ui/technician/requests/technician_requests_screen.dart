import 'package:flutter/material.dart';
import 'package:moftah/data/store/technician_store.dart';
import 'package:moftah/ui/technician/widgets/requsets/advanced_filter_sheet.dart';
import 'package:moftah/ui/technician/widgets/requsets/requests_filters_section.dart';
import 'package:moftah/ui/technician/widgets/requsets/technician_request_card.dart';
import 'package:moftah/ui/technician/widgets/technician_scaffold.dart';
import 'package:moftah/utils/responsive.dart';

class TechnicianRequestsScreen extends StatefulWidget {
  const TechnicianRequestsScreen({super.key});

  @override
  State<TechnicianRequestsScreen> createState() =>
      _TechnicianRequestsScreenState();
}

class _TechnicianRequestsScreenState extends State<TechnicianRequestsScreen> {
  final TechnicianStore store = TechnicianStore.instance;

  final Map<String, dynamic> filters = {
    'labels': ['الكل', 'الأقرب', 'الأحدث', 'خطورة عالية'],
    'icons': [
      Icons.filter_alt_outlined,
      Icons.location_on_outlined,
      Icons.access_time_rounded,
      Icons.warning_outlined,
    ],
  };

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TechnicianScaffold(
        current: 1,
        title: 'الطلبات',
        body: SafeArea(
          bottom: false,
          top: false,
          child: Column(
            children: [
              RequestsFiltersSection(
                filters: filters,
                selectedIndex: selectedIndex,
                numOfOrders: store.requests.length,
                onFilterSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                onSearchChanged: (value) {},
                onAdvancedFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) {
                      return const AdvancedFilterSheet();
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: AnimatedBuilder(
                  animation: store,
                  builder: (context, _) {
                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                        ResponsiveSize.width(context, 4),
                        ResponsiveSize.height(context, 1),
                        ResponsiveSize.width(context, 4),
                        ResponsiveSize.height(context, 13),
                      ),
                      children: store.requests
                          .map(
                            (request) => TechnicianRequestCard(
                              request: request,
                              onDetails: () {
                                Navigator.pushNamed(
                                  context,
                                  '/technician/request-details',
                                  arguments: request,
                                );
                              },
                              onOffer: () {
                                Navigator.pushNamed(
                                  context,
                                  '/technician/send-offer',
                                  arguments: request,
                                );
                              },
                              onReject: () {
                                store.reject(request.id);
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
}
