import 'package:flutter/material.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/home/cubit/nearby_places_state.dart';
import 'package:moftah/utils/responsive.dart';

class NearbyPlacesLoadingIndicator extends StatelessWidget {
  final NearbyPlacesLoading state;
  final bool directoryMode;

  const NearbyPlacesLoadingIndicator({
    super.key,
    required this.state,
    this.directoryMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(context, 5),
        vertical: ResponsiveSize.height(context, 0.6),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(context, 4),
          vertical: ResponsiveSize.height(context, 1.7),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: ResponsiveSize.width(context, 11),
                  height: ResponsiveSize.width(context, 11),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(ResponsiveSize.width(context, 2.7)),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.8,
                      strokeCap: StrokeCap.round,
                      color: AppColors.secondary,
                      backgroundColor: Color(0xFFE8F0FA),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        text: directoryMode
                            ? 'بنجهزلك دليل الورش'
                            : 'بنجيبلك أقرب الورش',
                        fontSize: ResponsiveSize.width(context, AppSizes.fontLg),
                        color: AppColors.primary,
                        isBold: true,
                      ),
                      SizedBox(height: ResponsiveSize.height(context, 0.2)),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, .35),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: KeyedSubtree(
                          key: ValueKey(_currentMessage),
                          child: customText(
                            text: _currentMessage,
                            fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                            color: AppColors.progressBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(context, 1.5)),
            _VisibleProgress(state: state),
          ],
        ),
      ),
    );
  }

  String get _currentMessage {
    switch (state.step) {
      case NearbyLoadingStep.checkingPermission:
      case NearbyLoadingStep.checkingLocationService:
        return 'بنجهز خدمة الموقع...';
      case NearbyLoadingStep.locatingUser:
        return 'بنحدد موقعك الحالي بدقة';
      case NearbyLoadingStep.checkingInternet:
        return 'موقعك جاهز.. بنجهز البحث عن الورش';
      case NearbyLoadingStep.searchingWorkshops:
        final km = (state.searchRadiusMeters ?? 15000) ~/ 1000;
        return 'بندور على أقرب الورش في نطاق $km كم';
    }
  }
}

class _VisibleProgress extends StatelessWidget {
  final NearbyPlacesLoading state;

  const _VisibleProgress({required this.state});

  @override
  Widget build(BuildContext context) {
    final locating = state.step.index <= NearbyLoadingStep.locatingUser.index;
    final searching = state.step == NearbyLoadingStep.checkingInternet ||
        state.step == NearbyLoadingStep.searchingWorkshops;

    return Column(
      children: [
        _ProgressRow(
          icon: Icons.gps_fixed_rounded,
          title: locating ? 'تشغيل الـ GPS وتحديد موقعك' : 'تم تحديد موقعك',
          done: !locating,
          active: locating,
        ),
        Container(
          margin: EdgeInsets.only(right: ResponsiveSize.width(context, 3.2)),
          alignment: Alignment.centerRight,
          width: double.infinity,
          height: ResponsiveSize.height(context, 1.6),
          child: Container(
            width: 1.5,
            height: double.infinity,
            color: !locating
                ? AppColors.success.withValues(alpha: .35)
                : AppColors.border.withValues(alpha: .25),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: child,
            ),
          ),
          child: _ProgressRow(
            key: ValueKey(state.searchRadiusMeters ?? state.step),
            icon: Icons.travel_explore_rounded,
            title: searching ? _searchTitle : 'تجهيز البحث عن الورش',
            done: false,
            active: !locating,
          ),
        ),
      ],
    );
  }

  String get _searchTitle {
    final km = (state.searchRadiusMeters ?? 15000) ~/ 1000;
    return 'البحث في نطاق $km كم';
  }
}

class _ProgressRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool done;
  final bool active;

  const _ProgressRow({
    super.key,
    required this.icon,
    required this.title,
    required this.done,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          width: ResponsiveSize.width(context, 6.5),
          height: ResponsiveSize.width(context, 6.5),
          decoration: BoxDecoration(
            color: done
                ? AppColors.success.withValues(alpha: .12)
                : AppColors.secondary.withValues(alpha: .10),
            shape: BoxShape.circle,
            border: Border.all(
              color: done ? AppColors.success : AppColors.secondary,
            ),
          ),
          child: done
              ? Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: ResponsiveSize.width(context, 3.8),
                )
              : active
                  ? Padding(
                      padding: EdgeInsets.all(ResponsiveSize.width(context, 1.5)),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.secondary,
                      ),
                    )
                  : Icon(
                      icon,
                      color: AppColors.secondary,
                      size: ResponsiveSize.width(context, 3.5),
                    ),
        ),
        SizedBox(width: ResponsiveSize.width(context, 2)),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, .3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Align(
              key: ValueKey(title),
              alignment: Alignment.centerRight,
              child: customText(
                text: title,
                fontSize: ResponsiveSize.width(context, AppSizes.fontSm),
                color: done ? AppColors.progressBackground : AppColors.primary,
                isBold: active,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
