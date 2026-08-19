import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/data/repos/obd_repository.dart';
import 'package:moftah/ui/vehicle_health/cubit/obd_state.dart';

class ObdCubit extends Cubit<ObdState> {
  final ObdRepository repository;
  bool _liveReadRunning = false;
  bool _dtcReadRunning = false;
  int _connectionAttempt = 0;

  ObdCubit({required this.repository}) : super(const ObdState());

  void _trace(String line) {
    if (isClosed) return;
    final next = [...state.trace, line];
    emit(state.copyWith(
      trace: next.length > 100 ? next.sublist(next.length - 100) : next,
    ));
  }

  Future<void> loadPairedDevices() async {
    emit(state.copyWith(
      status: ObdStatus.loadingDevices,
      connectionStage: ObdConnectionStage.checkingPairedDevices,
      trace: const [
        'بنتأكد إن البلوتوث جاهز...',
        'بندور على الأجهزة اللي معمولها اقتران...',
      ],
      clearMessage: true,
    ));
    try {
      final devices = await repository.getPairedDevices();
      _trace('لقينا ${devices.length} جهاز معمول له اقتران.');
      emit(state.copyWith(
        status: ObdStatus.ready,
        connectionStage: devices.isEmpty
            ? ObdConnectionStage.idle
            : ObdConnectionStage.waitingForDeviceSelection,
        devices: devices,
        message: devices.isEmpty
            ? 'مفيش أجهزة مقترنة. اعمل اقتران للـ ELM327 من إعدادات الموبايل وجرب تاني.'
            : 'اختار قطعة الفحص بتاعتك علشان نبدأ.',
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ObdStatus.error,
        connectionStage: ObdConnectionStage.idle,
        message: 'مقدرناش نقرأ أجهزة البلوتوث المقترنة.',
      ));
    }
  }

  Future<void> connect(ObdDeviceModel device) async {
    final attempt = ++_connectionAttempt;
    emit(state.copyWith(
      status: ObdStatus.connecting,
      connectionStage: ObdConnectionStage.connectingBluetooth,
      trace: ['اخترت: ${device.name}', 'بنفتح اتصال مباشر مع قطعة الفحص...'],
      clearMessage: true,
      clearSnapshot: true,
    ));
    try {
      final connected = await repository.connectBluetooth(device.address);
      if (attempt != _connectionAttempt || isClosed) return;
      if (!connected) {
        emit(state.copyWith(
          status: ObdStatus.error,
          connectionStage: ObdConnectionStage.idle,
          message: 'الاتصال بالقطعة فشل. اقفل أي تطبيق OBD تاني وجرب.',
        ));
        return;
      }

      _trace('اتصلنا بقطعة الفحص بنجاح.');
      emit(state.copyWith(
        status: ObdStatus.connecting,
        connectionStage: ObdConnectionStage.initializingAdapter,
        connectedDevice: device,
      ));

      await repository.initializeAdapter(onTrace: _trace);
      if (attempt != _connectionAttempt || isClosed) return;
      final adapterName = await repository.readAdapterName(onTrace: _trace);
      if (attempt != _connectionAttempt || isClosed) return;
      _trace('قطعة الفحص: $adapterName');

      emit(state.copyWith(
        status: ObdStatus.reading,
        connectionStage: ObdConnectionStage.detectingProtocol,
        connectedDevice: device,
        adapterName: adapterName,
      ));

      if (attempt != _connectionAttempt || isClosed) return;
      await _firstVehicleScan();
    } catch (error) {
      if (attempt != _connectionAttempt || isClosed) return;
      _trace('حصل خطأ أثناء الاتصال: $error');
      emit(state.copyWith(
        status: ObdStatus.error,
        connectionStage: ObdConnectionStage.idle,
        message: 'الاتصال مكملش. شوف سجل الفحص تحت لمعرفة آخر خطوة.',
      ));
    }
  }

  Future<void> _firstVehicleScan() async {
    _trace('أول مرة بس: بندور على بروتوكول العربية المناسب...');
    final snapshot = await repository.readSnapshot(onTrace: _trace);
    if (!snapshot.ecuAvailable) {
      emit(state.copyWith(
        status: ObdStatus.connected,
        connectionStage: ObdConnectionStage.ecuNotResponding,
        snapshot: snapshot,
        message: 'القطعة متصلة، بس كمبيوتر العربية مردش. خلي الكونتاكت ON وجرب تاني.',
      ));
      return;
    }

    _trace('تمام، لقينا بروتوكول العربية. هنفضل على نفس السيشن ونحدث القراءات مباشرة.');
    emit(state.copyWith(
      status: ObdStatus.connected,
      connectionStage: ObdConnectionStage.done,
      snapshot: snapshot,
      clearMessage: true,
    ));
  }

  /// تحديث العدادات فقط - بدون Reset وبدون Protocol Search.
  Future<void> refreshLiveData() async {
    if (!state.isConnected || !repository.ecuReady || _liveReadRunning || _dtcReadRunning) return;
    _liveReadRunning = true;
    try {
      final oldCodes = state.snapshot?.troubleCodes ?? const <ObdTroubleCodeModel>[];
      final snapshot = await repository.readLiveSnapshot(
        troubleCodes: oldCodes,
      );
      if (!isClosed) {
        emit(state.copyWith(
          status: ObdStatus.connected,
          connectionStage: ObdConnectionStage.done,
          snapshot: snapshot,
          clearMessage: true,
        ));
      }
    } catch (error) {
      _trace('قراءة Live اتقطعت: $error');
    } finally {
      _liveReadRunning = false;
    }
  }

  /// تحديث الأعطال أثناء نفس السيشن ومقارنة اللي ظهر واللي اختفى.
  Future<void> refreshTroubleCodes() async {
    if (!state.isConnected || !repository.ecuReady || _dtcReadRunning || _liveReadRunning) return;
    _dtcReadRunning = true;
    try {
      final before = state.snapshot?.troubleCodes ?? const <ObdTroubleCodeModel>[];
      final after = await repository.readTroubleCodes();
      final beforeCodes = before.map((e) => e.code).toSet();
      final afterCodes = after.map((e) => e.code).toSet();

      for (final code in afterCodes.difference(beforeCodes)) {
        _trace('عطل جديد ظهر أثناء السيشن: $code');
      }
      for (final code in beforeCodes.difference(afterCodes)) {
        _trace('العطل $code مبقاش ظاهر في القراءة الحالية.');
      }

      final current = state.snapshot;
      if (current != null && !isClosed) {
        emit(state.copyWith(snapshot: ObdSnapshotModel(
          ecuAvailable: current.ecuAvailable,
          rpm: current.rpm,
          speedKmh: current.speedKmh,
          coolantTemperature: current.coolantTemperature,
          intakeAirTemperature: current.intakeAirTemperature,
          engineLoadPercent: current.engineLoadPercent,
          throttlePositionPercent: current.throttlePositionPercent,
          adapterVoltage: current.adapterVoltage,
          troubleCodes: after,
        )));
      }
    } finally {
      _dtcReadRunning = false;
    }
  }

  /// الزر اليدوي بقى تحديث سريع داخل نفس السيشن، مش فحص من البداية.
  Future<void> refreshDiagnostics({bool showConnectionStage = false}) async {
    if (!state.isConnected) return;
    if (repository.ecuReady) {
      _trace('تحديث يدوي: بنقرأ الداتا الجديدة من العربية على نفس السيشن والبروتوكول...');
      await refreshLiveData();
      await refreshTroubleCodes();
      _trace('التحديث خلص من غير إعادة بحث عن البروتوكول.');
      return;
    }
    await _firstVehicleScan();
  }

  Future<bool> clearTroubleCodes() async {
    if (!state.isConnected || !repository.ecuReady) return false;
    final ok = await repository.clearTroubleCodes(onTrace: _trace);

    // نفس السيشن ونفس البروتوكول: مجرد إعادة قراءة، من غير ATZ
    // ومن غير Protocol Search.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await refreshTroubleCodes();
    await refreshLiveData();

    return ok;
  }

  Future<void> cancelConnectionAttempt() async {
    if (!state.isConnectionFlowRunning) return;
    ++_connectionAttempt;
    _trace('لغيت محاولة الاتصال.');
    try {
      await repository.disconnect();
    } finally {
      if (!isClosed) {
        emit(state.copyWith(
          status: ObdStatus.ready,
          connectionStage: ObdConnectionStage.waitingForDeviceSelection,
          clearConnectedDevice: true,
          clearSnapshot: true,
          adapterName: '',
          message: 'اختار قطعة فحص تانية وجرب.',
        ));
      }
    }
  }

  Future<void> disconnect() async {
    try {
      await repository.disconnect();
    } finally {
      emit(state.copyWith(
        status: ObdStatus.ready,
        connectionStage: ObdConnectionStage.waitingForDeviceSelection,
        clearConnectedDevice: true,
        clearSnapshot: true,
        adapterName: '',
        trace: const [],
        clearMessage: true,
      ));
    }
  }

  @override
  Future<void> close() async {
    if (state.isConnected) await repository.disconnect();
    return super.close();
  }
}
