import 'package:moftah/data/models/obd_models.dart';

enum ObdStatus {
  initial,
  loadingDevices,
  ready,
  connecting,
  connected,
  reading,
  error,
}

class ObdState {
  final ObdStatus status;
  final List<ObdDeviceModel> devices;
  final ObdDeviceModel? connectedDevice;
  final String adapterName;
  final ObdSnapshotModel? snapshot;
  final String? message;

  const ObdState({
    this.status = ObdStatus.initial,
    this.devices = const [],
    this.connectedDevice,
    this.adapterName = '',
    this.snapshot,
    this.message,
  });

  bool get isConnected => connectedDevice != null;

  ObdState copyWith({
    ObdStatus? status,
    List<ObdDeviceModel>? devices,
    ObdDeviceModel? connectedDevice,
    bool clearConnectedDevice = false,
    String? adapterName,
    ObdSnapshotModel? snapshot,
    bool clearSnapshot = false,
    String? message,
    bool clearMessage = false,
  }) {
    return ObdState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      connectedDevice:
          clearConnectedDevice ? null : connectedDevice ?? this.connectedDevice,
      adapterName: adapterName ?? this.adapterName,
      snapshot: clearSnapshot ? null : snapshot ?? this.snapshot,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
