import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/data/repos/obd_repository.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';

class ObdCubit extends Cubit<ObdState> {
  final ObdRepository repository;

  ObdCubit({required this.repository}) : super(const ObdState());

  Future<void> loadPairedDevices() async {
    emit(
      state.copyWith(
        status: ObdStatus.loadingDevices,
        connectionStage: ObdConnectionStage.checkingPairedDevices,
        clearMessage: true,
      ),
    );

    try {
      final devices = await repository.getPairedDevices();
      emit(
        state.copyWith(
          status: ObdStatus.ready,
          connectionStage: ObdConnectionStage.idle,
          devices: devices,
          message: devices.isEmpty
              ? 'اعمل Pair مع ELM327 من إعدادات البلوتوث أولاً.'
              : null,
          clearMessage: devices.isNotEmpty,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ObdStatus.error,
          connectionStage: ObdConnectionStage.idle,
          message: 'تعذر قراءة أجهزة البلوتوث المقترنة.',
        ),
      );
    }
  }

  Future<void> connectPreferredDevice() async {
    emit(
      state.copyWith(
        status: ObdStatus.loadingDevices,
        connectionStage: ObdConnectionStage.checkingPairedDevices,
        clearMessage: true,
      ),
    );

    try {
      var devices = state.devices;
      if (devices.isEmpty) {
        devices = await repository.getPairedDevices();
        emit(state.copyWith(devices: devices));
      }

      if (devices.isEmpty) {
        emit(
          state.copyWith(
            status: ObdStatus.ready,
            connectionStage: ObdConnectionStage.idle,
            message: 'مش لاقيين جهاز مقترن. اعمل Pair مع ELM327 من إعدادات البلوتوث.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ObdStatus.loadingDevices,
          connectionStage: ObdConnectionStage.findingAdapter,
        ),
      );

      // Small visual pause so the user can actually see this connection step.
      await Future<void>.delayed(const Duration(milliseconds: 250));

      final device = _preferredDevice(devices);
      await connect(device);
    } catch (_) {
      emit(
        state.copyWith(
          status: ObdStatus.error,
          connectionStage: ObdConnectionStage.idle,
          message: 'حصلت مشكلة أثناء البحث عن ELM327.',
        ),
      );
    }
  }

  Future<void> connect(ObdDeviceModel device) async {
    emit(
      state.copyWith(
        status: ObdStatus.connecting,
        connectionStage: ObdConnectionStage.connectingBluetooth,
        clearMessage: true,
      ),
    );

    try {
      final connected = await repository.connectBluetooth(device.address);
      if (!connected) {
        emit(
          state.copyWith(
            status: ObdStatus.error,
            connectionStage: ObdConnectionStage.idle,
            message: 'فشل الاتصال بـ ${device.name}.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: ObdStatus.connecting,
          connectionStage: ObdConnectionStage.initializingAdapter,
          connectedDevice: device,
          clearSnapshot: true,
        ),
      );

      await repository.initializeAdapter();
      final adapterName = await repository.readAdapterName();

      emit(
        state.copyWith(
          status: ObdStatus.reading,
          connectionStage: ObdConnectionStage.readingVehicle,
          connectedDevice: device,
          adapterName: adapterName,
          clearSnapshot: true,
        ),
      );

      await refreshDiagnostics(showConnectionStage: true);
    } catch (_) {
      emit(
        state.copyWith(
          status: ObdStatus.error,
          connectionStage: ObdConnectionStage.idle,
          message: 'تعذر الاتصال بالـ ELM327. تأكد إنه شغال ومقترن بالموبايل.',
        ),
      );
    }
  }

  Future<void> refreshDiagnostics({bool showConnectionStage = false}) async {
    if (!state.isConnected) return;

    emit(
      state.copyWith(
        status: ObdStatus.reading,
        connectionStage: showConnectionStage
            ? ObdConnectionStage.readingVehicle
            : state.connectionStage,
        clearMessage: true,
      ),
    );

    try {
      final snapshot = await repository.readSnapshot();
      emit(
        state.copyWith(
          status: ObdStatus.connected,
          connectionStage: ObdConnectionStage.done,
          snapshot: snapshot,
          message: snapshot.ecuAvailable
              ? null
              : 'القطعة متصلة، لكن مفيش استجابة من ECU. ده طبيعي لو الـ ELM327 واخدة باور فقط ومش متوصلة بالعربية.',
          clearMessage: snapshot.ecuAvailable,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ObdStatus.connected,
          connectionStage: ObdConnectionStage.done,
          message: 'اتصلنا بالقطعة لكن فشلنا في قراءة بيانات العربية.',
        ),
      );
    }
  }

  Future<void> disconnect() async {
    try {
      await repository.disconnect();
    } finally {
      emit(
        state.copyWith(
          status: ObdStatus.ready,
          connectionStage: ObdConnectionStage.idle,
          clearConnectedDevice: true,
          clearSnapshot: true,
          adapterName: '',
          clearMessage: true,
        ),
      );
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
