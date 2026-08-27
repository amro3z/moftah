import 'package:flutter/material.dart';
import 'package:moftah/data/cache/nearby_places_cache.dart';
import 'package:moftah/data/models/report/problem_attachment_model.dart';
import 'package:moftah/data/models/report/problem_report_model.dart';
import 'package:moftah/data/store/vehicle_selection_store.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/car_owner/report_problem/steps/report_location_step.dart';
import 'package:moftah/ui/car_owner/report_problem/steps/report_media_step.dart';
import 'package:moftah/ui/car_owner/report_problem/steps/report_problem_step.dart';
import 'package:moftah/ui/car_owner/report_problem/steps/report_review_step.dart';
import 'package:moftah/ui/car_owner/report_problem/steps/report_vehicle_step.dart';
import 'package:moftah/utils/responsive.dart';

class ReportProblemFlowScreen extends StatefulWidget {
  const ReportProblemFlowScreen({super.key});

  @override
  State<ReportProblemFlowScreen> createState() =>
      _ReportProblemFlowScreenState();
}

class _ReportProblemFlowScreenState extends State<ReportProblemFlowScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  int _page = 0;
  int _selectedVehicle = VehicleSelectionStore.instance.selectedIndex;
  final Set<String> _selectedProblems = {'صوت غريب'};
  List<ProblemAttachmentModel> _attachments = const [];
  double? _latitude;
  double? _longitude;

  static const _titles = <String>[
    'اختر السيارة',
    'ما المشكلة؟',
    'أضف صورًا أو فيديو',
    'حدد موقعك',
    'مراجعة البلاغ',
  ];

  @override
  void initState() {
    super.initState();
    final cache = NearbyPlacesCache.instance;
    if (cache.hasLocation) {
      _latitude = cache.userLatitude;
      _longitude = cache.userLongitude;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: IndexedStack(
          index: _page,
          children: [
            ReportVehicleStep(
              selectedVehicleIndex: _selectedVehicle,
              onSelected: (index) {
                setState(() => _selectedVehicle = index);
              },
            ),
            ReportProblemStep(
              selectedProblems: _selectedProblems,
              descriptionController: _descriptionController,
              onToggleProblem: _toggleProblem,
            ),
            ReportMediaStep(
              attachments: _attachments,
              onChanged: (attachments) {
                setState(() => _attachments = attachments);
              },
            ),
            ReportLocationStep(
              initialLatitude: _latitude,
              initialLongitude: _longitude,
              onLocationChanged: (latitude, longitude) {
                setState(() {
                  _latitude = latitude;
                  _longitude = longitude;
                });
              },
            ),
            ReportReviewStep(
              vehicleIndex: _selectedVehicle,
              selectedProblems: _selectedProblems,
              attachmentsCount: _attachments.length,
              hasLocation: _latitude != null && _longitude != null,
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomButton(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            onPressed: _back,
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.primary,
          ),
          Expanded(
            child: customText(
              text: _titles[_page],
              fontSize: ResponsiveSize.width(context, AppSizes.fontXl),
              color: AppColors.primary,
              isBold: true,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveSize.width(context, 5),
          ),
          child: Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  height: ResponsiveSize.height(context, 0.47),
                  margin: EdgeInsets.only(
                    left: index == 4 ? 0 : ResponsiveSize.width(context, 1),
                  ),
                  decoration: BoxDecoration(
                    color: index <= _page
                        ? AppColors.secondary
                        : AppColors.border.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final isLast = _page == 4;
    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(
        ResponsiveSize.width(context, 4), 0,
        ResponsiveSize.width(context, 4),
        ResponsiveSize.height(context, 2),
      ),
      child: SizedBox(
        height: ResponsiveSize.height(context, 6.2),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
          onPressed: _next,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(child: customText(
                text: isLast ? 'تحليل المشكلة بالذكاء الاصطناعي' : 'التالي',
                fontSize: ResponsiveSize.width(context, AppSizes.fontMd),
                color: Colors.white, isBold: true,
              )),
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  isLast ? Icons.smart_toy_rounded : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: ResponsiveSize.width(context, 5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleProblem(String problem) {
    setState(() {
      if (_selectedProblems.contains(problem)) {
        _selectedProblems.remove(problem);
      } else {
        _selectedProblems.add(problem);
      }
    });
  }

  Future<void> _next() async {
    if (_page == 1 &&
        _selectedProblems.isEmpty &&
        _descriptionController.text.trim().isEmpty) {
      _showMessage('اختار عرض واحد على الأقل أو اكتب وصف للمشكلة.');
      return;
    }

    if (_page == 3 && (_latitude == null || _longitude == null)) {
      _showMessage('حدد مكان العربية من زر «استخدم موقعي» أو من الخريطة.');
      return;
    }

    if (_page < 4) {
      setState(() => _page += 1);
      return;
    }

    final vehicle = VehicleSelectionStore.instance.vehicles[_selectedVehicle];
    VehicleSelectionStore.instance.selectIndex(_selectedVehicle);

    final report = ProblemReportModel(
      vehicleId: vehicle.id,
      vehicleName: vehicle.card.carName,
      brand: vehicle.card.brand,
      year: vehicle.card.year,
      symptoms: _selectedProblems.toList(),
      description: _descriptionController.text.trim(),
      attachments: List.unmodifiable(_attachments),
      latitude: _latitude!,
      longitude: _longitude!,
      locationLabel: 'موقع السيارة المحدد',
    );

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      '/problem-analysis',
      arguments: report,
    );
  }

  void _back() {
    if (_page == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() => _page -= 1);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
