import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/current_repair_model.dart';
import 'package:moftah/data/models/nerbay_places_model.dart';
import 'package:moftah/data/store/service_request_store.dart';
import 'package:moftah/data/store/vehicle_selection_store.dart';
import 'package:moftah/data/update/app_update_download_service.dart';
import 'package:moftah/data/update/app_update_repository.dart';
import 'package:moftah/routing/map_route_arguments.dart';
import 'package:moftah/ui/core/constant/home_options.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/app_loading_indicator.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/core/ui/section_title.dart';
import 'package:moftah/ui/home/cubit/nearby_places_cubit.dart';
import 'package:moftah/ui/home/cubit/nearby_places_state.dart';
import 'package:moftah/ui/home/widgets/current%20repair/current_repair_card.dart';
import 'package:moftah/ui/home/widgets/custom_appbar.dart';
import 'package:moftah/ui/home/widgets/home%20options/home_options_list.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/nearby_places_loading_indicator.dart';
import 'package:moftah/ui/home/widgets/nerbay%20places/nerbay_places.dart';
import 'package:moftah/ui/update/app_update_dialog.dart';
import 'package:moftah/ui/update/update_download_dialog.dart';
import 'package:moftah/utils/responsive.dart';
import 'package:moftah/utils/vehicle_brand_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppUpdateRepository _updateRepository = AppUpdateRepository();

  final AppUpdateDownloadService _downloadService = AppUpdateDownloadService();

  Timer? _updateCheckTimer;

  bool _checkingForUpdate = false;
  bool _downloadingUpdate = false;

  /// آخر Version ظهر للمستخدم في الـSession الحالي.
  ///
  /// الهدف إننا نفضل نعمل Check كل فترة،
  /// لكن منفتحش نفس Dialog كل 10 دقائق.
  String? _lastPromptedVersion;

  /// مدة الـCheck الدوري.
  static const Duration _updateCheckInterval = Duration(minutes: 10);

  @override
  void initState() {
    super.initState();

    // Check أول ما الـHome تظهر.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
    });

    // Check دوري طول ما الـHome موجودة.
    _updateCheckTimer = Timer.periodic(_updateCheckInterval, (_) {
      _checkForUpdate();
    });
  }

  @override
  void dispose() {
    _updateCheckTimer?.cancel();
    super.dispose();
  }

  // =========================================================
  // UPDATE CHECK
  // =========================================================

  Future<void> _checkForUpdate() async {
    // منع أكثر من Check في نفس الوقت.
    //
    // وكمان مفيش داعي نعمل Check أثناء تحميل Update.
    if (_checkingForUpdate || _downloadingUpdate) {
      return;
    }

    _checkingForUpdate = true;

    try {
      debugPrint('Checking for app update...');

      final result = await _updateRepository.checkForUpdate();

      if (!mounted) return;

      debugPrint('Current Version: ${result.currentVersion}');

      debugPrint('Latest Version: ${result.latestVersion}');

      debugPrint('Update Available: ${result.updateAvailable}');

      debugPrint('APK URL: ${result.apkUrl}');

      debugPrint('Update Error: ${result.error}');

      // لو حصل Error أثناء الاتصال بـGitHub.
      if (result.error != null) {
        debugPrint('Update check failed: ${result.error}');

        return;
      }

      // مفيش Update.
      if (!result.updateAvailable) {
        _lastPromptedVersion = null;

        debugPrint('Application is already up to date.');

        return;
      }

      final latestVersion = result.latestVersion;

      // نفس الـVersion اتعرض للمستخدم بالفعل.
      //
      // هنفضل نعمل Check في الخلفية،
      // لكن مش هنزعجه بنفس الـDialog.
      if (latestVersion != null && latestVersion == _lastPromptedVersion) {
        debugPrint(
          'Update $latestVersion was already '
          'shown in this session.',
        );

        return;
      }

      final apkUrl = result.apkUrl;

      // Update موجود لكن مفيش APK.
      if (apkUrl == null || apkUrl.trim().isEmpty) {
        debugPrint('Update exists but APK URL is missing.');

        return;
      }

      // نسجل الـVersion قبل عرض الـDialog.
      _lastPromptedVersion = latestVersion;

      final updateNow = await showAppUpdateDialog(
        context: context,
        update: result,
      );

      if (!mounted) return;

      // المستخدم اختار لاحقًا.
      if (updateNow != true) {
        debugPrint(
          'User postponed update '
          '${latestVersion ?? ''}.',
        );

        return;
      }

      // المستخدم اختار تحديث الآن.
      await _downloadAndInstallUpdate(
        url: apkUrl,
        version: latestVersion ?? 'latest',
      );
    } catch (error, stackTrace) {
      debugPrint('Unexpected update check error: $error');

      debugPrint('Update check stack trace: $stackTrace');
    } finally {
      _checkingForUpdate = false;
    }
  }

  // =========================================================
  // DOWNLOAD + INSTALL UPDATE
  // =========================================================

  Future<void> _downloadAndInstallUpdate({
    required String url,
    required String version,
  }) async {
    if (_downloadingUpdate) {
      return;
    }

    _downloadingUpdate = true;

    final progressNotifier = ValueNotifier<double>(0);

    var dialogIsOpen = false;

    try {
      if (!mounted) return;

      dialogIsOpen = true;

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return ValueListenableBuilder<double>(
            valueListenable: progressNotifier,
            builder: (_, progress, __) {
              return UpdateDownloadDialog(progress: progress);
            },
          );
        },
      );

      final apk = await _downloadService.downloadApk(
        url: url,
        version: version,
        onProgress: (progress) {
          if (!progressNotifier.hasListeners) {
            return;
          }

          progressNotifier.value = progress.clamp(0.0, 1.0);
        },
      );

      if (!mounted) return;

      progressNotifier.value = 1;

      // إغلاق Progress Dialog بعد اكتمال التحميل.
      if (dialogIsOpen) {
        Navigator.of(context, rootNavigator: true).pop();

        dialogIsOpen = false;
      }

      // فتح Android Installer.
      final installResult = await _downloadService.installApk(apk);

      debugPrint(
        'APK installer result: '
        '${installResult.type} - '
        '${installResult.message}',
      );
    } catch (error, stackTrace) {
      debugPrint('Update download/install error: $error');

      debugPrint('Update stack trace: $stackTrace');

      if (!mounted) return;

      if (dialogIsOpen) {
        Navigator.of(context, rootNavigator: true).pop();

        dialogIsOpen = false;
      }

      _showUpdateError();
    } finally {
      _downloadingUpdate = false;

      progressNotifier.dispose();
    }
  }

  // =========================================================
  // UPDATE ERROR
  // =========================================================

  void _showUpdateError() {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          content: customText(
            text: 'تعذر تحميل أو فتح التحديث. حاول مرة أخرى.',
            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
            color: AppColors.textSecondary,
            isBold: true,
          ),
        ),
      );
  }

  // =========================================================
  // HOME UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final vehicleStore = VehicleSelectionStore.instance;

    final serviceStore = ServiceRequestStore.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: Listenable.merge([vehicleStore, serviceStore]),
        builder: (context, _) {
          final selectedVehicle = vehicleStore.selectedVehicle;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                customAppBar(
                  context,
                  userName: 'عمرو محمد',
                  selectedVehicle: selectedVehicle,
                  data: selectedVehicle.card,
                  onChatTap: () {},
                  notificationCount: serviceStore.shouldShowOffersBanner
                      ? serviceStore.offers.length
                      : 0,
                  onVehicleSwitchTap: () => _showVehicleSwitcher(context),
                  onVehicleTap: () {
                    Navigator.pushNamed(
                      context,
                      '/vehicle-health',
                      arguments: selectedVehicle.health,
                    );
                  },
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: ResponsiveSize.height(context, 1.2)),

                        HomeOptionsList(options: HomeOptionsInfo.options),

                        SizedBox(height: ResponsiveSize.height(context, 1.5)),

                        const SectionTitle(title: 'الإصلاح الحالي'),

                        SizedBox(height: ResponsiveSize.height(context, 1)),

                        CurrentRepairCard(
                          data: CurrentRepairModel(
                            title: 'تغيير زيت المحرك + فلتر',
                            workshopName: 'Auto Pro Center',
                            location: 'مدينة نصر',
                            currentStage: RepairStage.approval,
                            vehicleName:
                                '${selectedVehicle.card.carName} '
                                '${selectedVehicle.card.year}',
                            technicianName: 'محمد أحمد',
                            expectedFinish: '3:00 م',
                            estimatedCost: 1250,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/repair-details',
                              arguments: CurrentRepairModel(
                                title: 'تغيير زيت المحرك + فلتر',
                                workshopName: 'Auto Pro Center',
                                location: 'مدينة نصر',
                                currentStage: RepairStage.approval,
                                vehicleName:
                                    '${selectedVehicle.card.carName} '
                                    '${selectedVehicle.card.year}',
                                technicianName: 'محمد أحمد',
                                expectedFinish: '3:00 م',
                                estimatedCost: 1250,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: ResponsiveSize.height(context, 1.5)),

                        _buildNearbyPlacesSection(context),

                        SizedBox(height: ResponsiveSize.height(context, 10.5)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // =========================================================
  // VEHICLE SWITCHER
  // =========================================================

  void _showVehicleSwitcher(BuildContext context) {
    final store = VehicleSelectionStore.instance;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              ResponsiveSize.width(context, 5),
              ResponsiveSize.height(context, 1.2),
              ResponsiveSize.width(context, 5),
              ResponsiveSize.height(context, 3),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .22),
                  blurRadius: 28,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: ResponsiveSize.width(context, 10.77),
                    height: ResponsiveSize.height(context, .47),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveSize.height(context, 1.8)),

                customText(
                  text: 'اختار العربية',
                  fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                  color: AppColors.primary,
                  isBold: true,
                ),

                SizedBox(height: ResponsiveSize.height(context, 1)),

                ...List.generate(store.vehicles.length, (index) {
                  final vehicle = store.vehicles[index];

                  final selected = store.selectedIndex == index;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveSize.height(context, .8),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.secondary.withValues(alpha: .07)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        border: Border.all(
                          color: selected
                              ? AppColors.secondary.withValues(alpha: .35)
                              : AppColors.border.withValues(alpha: .10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .16),
                            blurRadius: 18,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          store.selectIndex(index);

                          Navigator.pop(sheetContext);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                        leading: VehicleBrandLogo(
                          brand: vehicle.card.brand,
                          logoUrl: vehicle.card.brandLogoUrl,
                          sizePercent: 11,
                        ),
                        title: customText(
                          text: vehicle.card.carName,
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontMd,
                          ),
                          color: AppColors.primary,
                          isBold: true,
                        ),
                        subtitle: customText(
                          text:
                              '${vehicle.card.year} • '
                              '${vehicle.card.mileage} كم',
                          fontSize: ResponsiveSize.width(
                            context,
                            AppSizes.fontSm,
                          ),
                          color: AppColors.textMuted,
                        ),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.secondary,
                              )
                            : null,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // NEARBY PLACES
  // =========================================================

  Widget _buildNearbyPlacesSection(BuildContext context) {
    return BlocBuilder<NearbyPlacesCubit, NearbyPlacesState>(
      builder: (context, state) {
        final List<HomeNearbyPlacesModel> places = state is NearbyPlacesSuccess
            ? state.places
            : const <HomeNearbyPlacesModel>[];

        return Column(
          children: [
            SectionTitle(
              title: 'ورش قريبة منك',
              actionText: 'عرض الخريطة',
              onActionTap: () {
                Navigator.pushNamed(
                  context,
                  '/map',
                  arguments: MapRouteArguments(nearbyPlaces: places),
                );
              },
            ),

            SizedBox(height: ResponsiveSize.height(context, 1)),

            if (state is NearbyPlacesInitial)
              NearbyPlacesLoadingIndicator(
                state: const NearbyPlacesLoading(
                  step: NearbyLoadingStep.checkingPermission,
                ),
              )
            else if (state is NearbyPlacesLoading)
              NearbyPlacesLoadingIndicator(state: state)
            else if (state is NearbyPlacesError)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(context, 5),
                  vertical: ResponsiveSize.height(context, 1),
                ),
                child: AppRetryIndicator(
                  message: state.message,
                  onRetry: () async {
                    final cubit = context.read<NearbyPlacesCubit>();

                    await cubit.handleErrorAction(state);

                    await cubit.loadNearestWorkshops();
                  },
                ),
              )
            else if (state is NearbyPlacesSuccess)
              HomeNearbyPlacesList(nearbyPlaces: state.places),
          ],
        );
      },
    );
  }
}
