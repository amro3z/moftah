import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/data/repos/obd_repository.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';

class ObdCubit extends Cubit<ObdState> {
  final ObdRepository repository;

  ObdCubit({required this.repository}) : super(const ObdState());

  Future<void> loadPairedDevices() async {
    emit(state.copyWith(
      status: ObdStatus.loadingDevices,
      clearMessage: true,
    ));

    try {
      final devices = await repository.getPairedDevices();
      emit(state.copyWith(
        status: ObdStatus.ready,
        devices: devices,
        message: devices.isEmpty
            ? 'اعمل Pair مع ELM327 من إعدادات البلوتوث أولاً.'
            : null,
        clearMessage: devices.isNotEmpty,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ObdStatus.error,
        message: 'تعذر قراءة أجهزة البلوتوث المقترنة.',
      ));
    }
  }

  Future<void> connectPreferredDevice() async {
    if (state.devices.isEmpty) {
      await loadPairedDevices();
      if (state.devices.isEmpty) return;
    }

    final device = _preferredDevice(state.devices);
    await connect(device);
  }

  Future<void> connect(ObdDeviceModel device) async {
    emit(state.copyWith(
      status: ObdStatus.connecting,
      clearMessage: true,
    ));

    try {
      final result = await repository.connect(device.address);
      if (!result.connected) {
        emit(state.copyWith(
          status: ObdStatus.error,
          message: 'فشل الاتصال بـ ${device.name}.',
        ));
        return;
      }

      emit(state.copyWith(
        status: ObdStatus.connected,
        connectedDevice: device,
        adapterName: result.adapterName,
        clearSnapshot: true,
      ));

      await refreshDiagnostics();
    } catch (_) {
      emit(state.copyWith(
        status: ObdStatus.error,
        message: 'تعذر الاتصال بالـ ELM327. تأكد إنه شغال ومقترن بالموبايل.',
      ));
    }
  }

  Future<void> refreshDiagnostics() async {
    if (!state.isConnected) return;

    emit(state.copyWith(
      status: ObdStatus.reading,
      clearMessage: true,
    ));

    try {
      final snapshot = await repository.readSnapshot();
      emit(state.copyWith(
        status: ObdStatus.connected,
        snapshot: snapshot,
        message: snapshot.ecuAvailable
            ? null
            : 'القطعة متصلة، لكن مفيش استجابة من ECU. ده طبيعي لو الـ ELM327 واخدة باور فقط ومش متوصلة بالعربية.',
        clearMessage: snapshot.ecuAvailable,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ObdStatus.connected,
        message: 'اتصلنا بالقطعة لكن فشلنا في قراءة بيانات العربية.',
      ));
    }
  }

  Future<void> disconnect() async {
    try {
      await repository.disconnect();
    } finally {
      emit(state.copyWith(
        status: ObdStatus.ready,
        clearConnectedDevice: true,
        clearSnapshot: true,
        adapterName: '',
        clearMessage: true,
      ));
    }
  }

  ObdDeviceModel _preferredDevice(List<ObdDeviceModel> devices) {
    for (final device in devices) {
      final name = device.name.toLowerCase();
      if (name.contains('elm327') ||
          name.contains('elm 327') ||
          name.contains('obdii') ||
          name.contains('obd ii') ||
          name.contains('obd2')) {
        return device;
      }
    }
    return devices.first;
  }

  @override
  Future<void> close() async {
    if (state.isConnected) {
      await repository.disconnect();
    }
    return super.close();
  }
}
