import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/data/repos/obd_repository.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';

class ObdCubit extends Cubit<ObdState> {
  final ObdRepository repository;
  ObdCubit({required this.repository}) : super(const ObdState());

  void _trace(String line) {
    if (isClosed) return;
    final next = [...state.trace, line];
    emit(state.copyWith(trace: next.length > 80 ? next.sublist(next.length - 80) : next));
  }

  Future<void> loadPairedDevices() async {
    emit(state.copyWith(
      status: ObdStatus.loadingDevices,
      connectionStage: ObdConnectionStage.checkingPairedDevices,
      trace: const ['فحص صلاحيات Bluetooth...', 'قراءة الأجهزة المقترنة من Android...'],
      clearMessage: true,
    ));
    try {
      final devices = await repository.getPairedDevices();
      _trace('تم العثور على ${devices.length} جهاز/أجهزة مقترنة.');
      emit(state.copyWith(
        status: ObdStatus.ready,
        connectionStage: devices.isEmpty
            ? ObdConnectionStage.idle
            : ObdConnectionStage.waitingForDeviceSelection,
        devices: devices,
        message: devices.isEmpty
            ? 'لا توجد أجهزة مقترنة. اعمل Pair للـ ELM327 من إعدادات Android ثم أعد الفحص.'
            : 'اختار جهاز ELM327 بنفسك. لن نرسل أوامر لأي جهاز تلقائيًا.',
      ));
    } catch (error) {
      _trace('خطأ قراءة الأجهزة: $error');
      emit(state.copyWith(
        status: ObdStatus.error,
        connectionStage: ObdConnectionStage.idle,
        message: 'تعذر قراءة أجهزة البلوتوث المقترنة.',
      ));
    }
  }

  Future<void> connect(ObdDeviceModel device) async {
    emit(state.copyWith(
      status: ObdStatus.connecting,
      connectionStage: ObdConnectionStage.connectingBluetooth,
      trace: ['الجهاز المختار: ${device.name}', 'فتح Bluetooth SPP/RFCOMM...'],
      clearMessage: true,
      clearSnapshot: true,
    ));
    try {
      final connected = await repository.connectBluetooth(device.address);
      if (!connected) {
        _trace('فشل فتح قناة SPP مع الجهاز.');
        emit(state.copyWith(status: ObdStatus.error, connectionStage: ObdConnectionStage.idle,
          message: 'فشل اتصال SPP بـ ${device.name}. جرّب إغلاق أي تطبيق OBD آخر.'));
        return;
      }

      _trace('تم فتح قناة Bluetooth SPP بنجاح.');
      emit(state.copyWith(status: ObdStatus.connecting,
        connectionStage: ObdConnectionStage.initializingAdapter, connectedDevice: device));

      await repository.initializeAdapter(onTrace: _trace);
      final adapterName = await repository.readAdapterName(onTrace: _trace);
      _trace('هوية المحول: $adapterName');

      emit(state.copyWith(status: ObdStatus.connecting,
        connectionStage: ObdConnectionStage.detectingProtocol,
        connectedDevice: device, adapterName: adapterName));
      _trace('ATSP0 = اختيار بروتوكول السيارة تلقائيًا.');

      emit(state.copyWith(status: ObdStatus.reading,
        connectionStage: ObdConnectionStage.readingVehicle));
      await refreshDiagnostics(showConnectionStage: true);
    } catch (error) {
      _trace('EXCEPTION: $error');
      emit(state.copyWith(status: ObdStatus.error, connectionStage: ObdConnectionStage.idle,
        message: 'الاتصال لم يكتمل. راجع سجل الفحص بالأسفل لمعرفة آخر أمر ورد.'));
    }
  }

  Future<void> refreshDiagnostics({bool showConnectionStage = false}) async {
    if (!state.isConnected) return;
    emit(state.copyWith(status: ObdStatus.reading,
      connectionStage: showConnectionStage ? ObdConnectionStage.readingVehicle : state.connectionStage,
      clearMessage: true));
    try {
      _trace('اختبار اتصال ECU باستخدام PID 0100...');
      final snapshot = await repository.readSnapshot(onTrace: _trace);
      if (!snapshot.ecuAvailable) {
        _trace('الـ ELM327 رد، لكن لم يصل رد OBD صالح من ECU (41 00...).');
        final voltage = snapshot.adapterVoltage;
        final lowVoltage = voltage != null && voltage < 11.5;

        emit(state.copyWith(
          status: ObdStatus.connected,
          connectionStage: ObdConnectionStage.ecuNotResponding,
          snapshot: snapshot,
          message: lowVoltage
              ? 'Bluetooth متصل بالقطعة، لكن ECU لم يرد. جهد منفذ OBD منخفض (${voltage.toStringAsFixed(1)}V). افحص البطارية/التغذية وشغّل الكونتاكت ON ثم أعد الاختبار.'
              : 'Bluetooth متصل بالقطعة، لكن ECU لم يرد. شغّل الكونتاكت على ON وتأكد أن القطعة مركبة في OBD-II ولا يوجد تطبيق آخر متصل بها.',
        ));
        return;
      }
      _trace('ECU استجاب. تم بدء قراءة PIDs والأعطال.');
      emit(state.copyWith(status: ObdStatus.connected,
        connectionStage: ObdConnectionStage.done, snapshot: snapshot,
        message: null, clearMessage: true));
    } catch (error) {
      _trace('فشل قراءة ECU: $error');
      emit(state.copyWith(status: ObdStatus.connected,
        connectionStage: ObdConnectionStage.ecuNotResponding,
        message: 'القطعة متصلة Bluetooth لكن قراءة السيارة فشلت. راجع TX/RX في سجل الفحص.'));
    }
  }

  Future<void> disconnect() async {
    try { await repository.disconnect(); } finally {
      emit(state.copyWith(status: ObdStatus.ready,
        connectionStage: ObdConnectionStage.waitingForDeviceSelection,
        clearConnectedDevice: true, clearSnapshot: true, adapterName: '',
        trace: const [], clearMessage: true));
    }
  }

  @override
  Future<void> close() async {
    if (state.isConnected) await repository.disconnect();
    return super.close();
  }
}
