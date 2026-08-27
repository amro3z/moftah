import 'package:bluetooth_serial_android/bluetooth_serial_android.dart';
import 'package:moftah/data/models/obd/obd_models.dart';

class Elm327BluetoothDataSource {
  static const String _sppUuid =
      '00001101-0000-1000-8000-00805F9B34FB';
  static const int _readTimeoutMs = 10000;

  Future<bool> ensurePermissions() {
    return FlutterBluetoothSerial.ensurePermissions();
  }

  Future<List<ObdDeviceModel>> getPairedDevices() async {
    await ensurePermissions();
    final devices = await FlutterBluetoothSerial.getPairedDevices();

    return devices
        .map(
          (device) => ObdDeviceModel(
            name: (device['name'] ?? 'Bluetooth device').trim(),
            address: (device['address'] ?? '').trim(),
          ),
        )
        .where((device) => device.address.isNotEmpty)
        .toList();
  }

  Future<bool> connect(String address) async {
    await ensurePermissions();
    return FlutterBluetoothSerial.connect(
      address,
      uuid: _sppUuid,
      timeoutMs: _readTimeoutMs,
    );
  }

  Future<void> disconnect() {
    return FlutterBluetoothSerial.disconnect();
  }

  Future<String> sendCommand(String command) async {
    final normalized = command.trim().toUpperCase();

    await FlutterBluetoothSerial.write('$normalized\r');

    final response = await FlutterBluetoothSerial.readLine('>');

    return _cleanResponse(
      response ?? '',
      command: normalized,
    );
  }

  String _cleanResponse(
    String response, {
    required String command,
  }) {
    return response
        .replaceAll('>', '')
        .replaceAll('\u0000', '')
        .split(RegExp(r'[\r\n]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .where((line) => line.toUpperCase() != command)
        .join('\n')
        .trim();
  }
}
