import 'package:moftah/data/models/obd/obd_models.dart';

enum ObdStatus { initial, loadingDevices, ready, connecting, connected, reading, error }

enum ObdConnectionStage {
  idle,
  checkingPairedDevices,
  waitingForDeviceSelection,
  connectingBluetooth,
  initializingAdapter,
  detectingProtocol,
  readingVehicle,
  ecuNotResponding,
  done,
}

class ObdState {
  final ObdStatus status;
  final ObdConnectionStage connectionStage;
  final List<ObdDeviceModel> devices;
  final ObdDeviceModel? connectedDevice;
  final String adapterName;
  final ObdSnapshotModel? snapshot;
  final List<String> trace;
  final String? message;

  const ObdState({
    this.status = ObdStatus.initial,
    this.connectionStage = ObdConnectionStage.idle,
    this.devices = const [],
    this.connectedDevice,
    this.adapterName = '',
    this.snapshot,
    this.trace = const [],
    this.message,
  });

  bool get isConnected => connectedDevice != null;
  bool get isConnectionFlowRunning =>
      connectionStage != ObdConnectionStage.idle &&
      connectionStage != ObdConnectionStage.done &&
      connectionStage != ObdConnectionStage.ecuNotResponding &&
      connectionStage != ObdConnectionStage.waitingForDeviceSelection;

  ObdState copyWith({
    ObdStatus? status,
    ObdConnectionStage? connectionStage,
    List<ObdDeviceModel>? devices,
    ObdDeviceModel? connectedDevice,
    bool clearConnectedDevice = false,
    String? adapterName,
    ObdSnapshotModel? snapshot,
    bool clearSnapshot = false,
    List<String>? trace,
    String? message,
    bool clearMessage = false,
  }) {
    return ObdState(
      status: status ?? this.status,
      connectionStage: connectionStage ?? this.connectionStage,
      devices: devices ?? this.devices,
      connectedDevice: clearConnectedDevice ? null : connectedDevice ?? this.connectedDevice,
      adapterName: adapterName ?? this.adapterName,
      snapshot: clearSnapshot ? null : snapshot ?? this.snapshot,
      trace: trace ?? this.trace,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
