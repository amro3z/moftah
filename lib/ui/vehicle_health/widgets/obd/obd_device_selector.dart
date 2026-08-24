import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/ui/core/themes/colors.dart';
import 'package:moftah/ui/core/themes/sizes.dart';
import 'package:moftah/ui/core/ui/custom_text.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_cubit.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';
import 'package:moftah/utils/responsive.dart';

class ObdDeviceSelector extends StatelessWidget {
  final ObdState state;

  const ObdDeviceSelector({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isConnected) return const SizedBox.shrink();

    final ranked = [...state.devices]
      ..sort((a, b) => _score(b).compareTo(_score(a)));

    final suggested = ranked.take(5).toList();

    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(context, 3)),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .055),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: Colors.white.withValues(alpha: .08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.bluetooth_searching_rounded,
                color: AppColors.info,
              ),
              SizedBox(width: ResponsiveSize.width(context, 2)),
              Expanded(
                child: customText(
                  text: 'أجهزة OBD المحتملة',
                  fontSize: ResponsiveSize.width(
                    context,
                    AppSizes.fontSm,
                  ),
                  color: Colors.white,
                  isBold: true,
                ),
              ),
              IconButton(
                onPressed: state.status == ObdStatus.loadingDevices
                    ? null
                    : context.read<ObdCubit>().loadPairedDevices,
                icon: Icon(Icons.refresh_rounded),
                color: Colors.white70,
              ),
            ],
          ),
          customText(
            text:
                'بنظهر أول 5 أجهزة إحنا شايفين إن احتمال تكون OBD أعلى. '
                'لو قطعتك مش موجودة افتح كل الأجهزة.',
            fontSize: ResponsiveSize.width(
              context,
              AppSizes.fontXs,
            ),
            color: Colors.white70,
          ),
          if (suggested.isNotEmpty) ...[
            SizedBox(height: ResponsiveSize.height(context, 1)),
            ...suggested.map(
              (device) => _deviceTile(
                context,
                device,
                likelyObd: _score(device) > 0,
              ),
            ),
          ],
          if (ranked.length > 5) ...[
            SizedBox(height: ResponsiveSize.height(context, .5)),
            OutlinedButton(
              onPressed: () => _showAllDevices(context, ranked),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.white.withValues(alpha: .16),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.expand_more_rounded,
                    color: Colors.white70,
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 1.5)),
                  customText(
                    text: 'عرض المزيد',
                    fontSize: ResponsiveSize.width(
                      context,
                      AppSizes.fontSm,
                    ),
                    color: Colors.white,
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAllDevices(
    BuildContext context,
    List<ObdDeviceModel> devices,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * .78,
            ),
            padding: EdgeInsets.fromLTRB(
              ResponsiveSize.width(sheetContext, 4),
              ResponsiveSize.height(sheetContext, 1.2),
              ResponsiveSize.width(sheetContext, 4),
              ResponsiveSize.height(sheetContext, 2),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF102747),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: ResponsiveSize.width(context, 10.77),
                  height: ResponsiveSize.height(context, 0.47),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                ),
                SizedBox(
                  height: ResponsiveSize.height(sheetContext, 1.5),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.devices_rounded,
                      color: AppColors.info,
                    ),
                    SizedBox(
                      width: ResponsiveSize.width(sheetContext, 2),
                    ),
                    Expanded(
                      child: customText(
                        text: 'كل الأجهزة المقترنة',
                        fontSize: ResponsiveSize.width(
                          sheetContext,
                          AppSizes.fontLg,
                        ),
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                    customText(
                      text: '${devices.length}',
                      fontSize: ResponsiveSize.width(
                        sheetContext,
                        AppSizes.fontSm,
                      ),
                      color: Colors.white54,
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveSize.height(sheetContext, 1),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (_, index) {
                      final device = devices[index];
                      return _deviceTile(
                        context,
                        device,
                        likelyObd: _score(device) > 0,
                        onSelected: () {
                          Navigator.pop(sheetContext);
                          context.read<ObdCubit>().connect(device);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _deviceTile(
    BuildContext context,
    ObdDeviceModel device, {
    required bool likelyObd,
    VoidCallback? onSelected,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveSize.height(context, .7),
      ),
      child: Material(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: InkWell(
          onTap: onSelected ??
              () {
                context.read<ObdCubit>().connect(device);
              },
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          child: Padding(
            padding: EdgeInsets.all(
              ResponsiveSize.width(context, 2.6),
            ),
            child: Row(
              children: [
                Container(
                  width: ResponsiveSize.width(context, 9.74),
                  height: ResponsiveSize.height(context, 4.5),
                  decoration: BoxDecoration(
                    color: (likelyObd
                            ? AppColors.success
                            : AppColors.info)
                        .withValues(alpha: .14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bluetooth_rounded,
                    color: likelyObd
                        ? AppColors.success
                        : AppColors.info,
                  ),
                ),
                SizedBox(width: ResponsiveSize.width(context, 2.5)),
                Expanded(
                  child: customText(
                    text: device.name.isEmpty
                        ? 'Bluetooth device'
                        : device.name,
                    fontSize: ResponsiveSize.width(
                      context,
                      AppSizes.fontSm,
                    ),
                    color: Colors.white,
                    isBold: true,
                  ),
                ),
                if (likelyObd) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(context, 1.6),
                      vertical: ResponsiveSize.height(context, .35),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    child: customText(
                      text: 'OBD محتمل',
                      fontSize: ResponsiveSize.width(
                        context,
                        AppSizes.fontXs,
                      ),
                      color: AppColors.success,
                      isBold: true,
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.width(context, 1)),
                ],
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _score(ObdDeviceModel device) {
    final name = device.name.toLowerCase();
    var score = 0;

    if (name.contains('elm327')) score += 100;
    if (name.contains('obdii') || name.contains('obd ii')) score += 95;
    if (name.contains('obd')) score += 90;
    if (name.contains('elm')) score += 85;
    if (name.contains('vgate')) score += 80;
    if (name.contains('v-link') || name.contains('vlink')) score += 75;
    if (name.contains('icar')) score += 70;
    if (name.contains('konnwei')) score += 65;
    if (name.contains('car scanner')) score += 55;

    if (name.contains('buds') ||
        name.contains('headphone') ||
        name.contains('speaker') ||
        name.contains('watch')) {
      score -= 50;
    }

    return score;
  }
}
