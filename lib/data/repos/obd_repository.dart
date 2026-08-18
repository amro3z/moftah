
import 'package:moftah/data/datasources/elm327_bluetooth_data_source.dart';
import 'package:moftah/data/models/obd_models.dart';

class ObdConnectionResult {
  final bool connected;
  final String adapterName;

  const ObdConnectionResult({
    required this.connected,
    required this.adapterName,
  });
}

class ObdRepository {
  final Elm327BluetoothDataSource _dataSource;

  ObdRepository({Elm327BluetoothDataSource? dataSource})
      : _dataSource = dataSource ?? Elm327BluetoothDataSource();

  Future<List<ObdDeviceModel>> getPairedDevices() {
    return _dataSource.getPairedDevices();
  }

  Future<bool> connectBluetooth(String address) {
    return _dataSource.connect(address);
  }

  Future<void> initializeAdapter() {
    return _initializeAdapter();
  }

  Future<String> readAdapterName() async {
    final adapterName = await _dataSource.sendCommand('ATI');
    return adapterName.isEmpty ? 'ELM327' : adapterName;
  }

  Future<ObdConnectionResult> connect(String address) async {
    final connected = await connectBluetooth(address);
    if (!connected) {
      return const ObdConnectionResult(
        connected: false,
        adapterName: '',
      );
    }

    await initializeAdapter();
    final adapterName = await readAdapterName();

    return ObdConnectionResult(
      connected: true,
      adapterName: adapterName,
    );
  }

  Future<void> disconnect() {
    return _dataSource.disconnect();
  }

  Future<ObdSnapshotModel> readSnapshot() async {
    final supportResponse = await _dataSource.sendCommand('0100');
    final ecuAvailable = _hasEcuResponse(supportResponse);

    final voltage = _parseVoltage(await _dataSource.sendCommand('ATRV'));

    if (!ecuAvailable) {
      return ObdSnapshotModel(
        ecuAvailable: false,
        adapterVoltage: voltage,
      );
    }

    final rpm = _parseRpm(await _dataSource.sendCommand('010C'));
    final speed = _parseSingleBytePid(
      await _dataSource.sendCommand('010D'),
      pid: 0x0D,
    );
    final coolant = _parseCoolant(await _dataSource.sendCommand('0105'));
    final intakeAirTemperature = _parseTemperature(
      await _dataSource.sendCommand('010F'),
      pid: 0x0F,
    );
    final engineLoad = _parsePercentage(
      await _dataSource.sendCommand('0104'),
      pid: 0x04,
    );
    final throttlePosition = _parsePercentage(
      await _dataSource.sendCommand('0111'),
      pid: 0x11,
    );
    final dtcs = _parseTroubleCodes(await _dataSource.sendCommand('03'));

    return ObdSnapshotModel(
      ecuAvailable: true,
      rpm: rpm,
      speedKmh: speed,
      coolantTemperature: coolant,
      intakeAirTemperature: intakeAirTemperature,
      engineLoadPercent: engineLoad,
      throttlePositionPercent: throttlePosition,
      adapterVoltage: voltage,
      troubleCodes: dtcs,
    );
  }

  Future<void> _initializeAdapter() async {
    await _dataSource.sendCommand('ATZ');
    await _dataSource.sendCommand('ATE0');
    await _dataSource.sendCommand('ATL0');
    await _dataSource.sendCommand('ATS0');
    await _dataSource.sendCommand('ATH0');
    await _dataSource.sendCommand('ATSP0');
  }

  bool _hasEcuResponse(String response) {
    final upper = response.toUpperCase();
    if (upper.isEmpty ||
        upper.contains('NO DATA') ||
        upper.contains('UNABLE TO CONNECT') ||
        upper.contains('ERROR') ||
        upper.contains('STOPPED')) {
      return false;
    }

    return _hexBytes(response).contains(0x41);
  }

  int? _parseRpm(String response) {
    final bytes = _hexBytes(response);
    final index = _findPid(bytes, 0x0C);
    if (index < 0 || index + 3 >= bytes.length) return null;

    final a = bytes[index + 2];
    final b = bytes[index + 3];
    return (((a * 256) + b) / 4).round();
  }

  int? _parseCoolant(String response) {
    final bytes = _hexBytes(response);
    final index = _findPid(bytes, 0x05);
    if (index < 0 || index + 2 >= bytes.length) return null;
    return bytes[index + 2] - 40;
  }


  int? _parseSingleBytePid(String response, {required int pid}) {
    final bytes = _hexBytes(response);
    final index = _findPid(bytes, pid);
    if (index < 0 || index + 2 >= bytes.length) return null;
    return bytes[index + 2];
  }

  int? _parseTemperature(String response, {required int pid}) {
    final value = _parseSingleBytePid(response, pid: pid);
    return value == null ? null : value - 40;
  }

  double? _parsePercentage(String response, {required int pid}) {
    final value = _parseSingleBytePid(response, pid: pid);
    if (value == null) return null;
    return (value * 100) / 255;
  }

  double? _parseVoltage(String response) {
    final match = RegExp(r'([0-9]+(?:\.[0-9]+)?)\s*V', caseSensitive: false)
        .firstMatch(response);
    return double.tryParse(match?.group(1) ?? '');
  }

  List<ObdTroubleCodeModel> _parseTroubleCodes(String response) {
    final upper = response.toUpperCase();
    if (upper.contains('NO DATA') || upper.contains('UNABLE TO CONNECT')) {
      return const [];
    }

    final bytes = _hexBytes(response);
    final markerIndex = bytes.indexOf(0x43);
    if (markerIndex < 0) return const [];

    final result = <ObdTroubleCodeModel>[];
    for (var i = markerIndex + 1; i + 1 < bytes.length; i += 2) {
      final a = bytes[i];
      final b = bytes[i + 1];
      if (a == 0 && b == 0) continue;

      final code = _decodeDtc(a, b);
      result.add(
        ObdTroubleCodeModel(
          code: code,
          system: _systemName(code),
        ),
      );
    }

    final unique = <String, ObdTroubleCodeModel>{};
    for (final item in result) {
      unique[item.code] = item;
    }
    return unique.values.toList();
  }

  int _findPid(List<int> bytes, int pid) {
    for (var i = 0; i + 1 < bytes.length; i++) {
      if (bytes[i] == 0x41 && bytes[i + 1] == pid) return i;
    }
    return -1;
  }

  List<int> _hexBytes(String response) {
    final matches = RegExp(r'\b[0-9A-Fa-f]{2}\b').allMatches(response);
    return matches
        .map((match) => int.parse(match.group(0)!, radix: 16))
        .toList();
  }

  String _decodeDtc(int a, int b) {
    const systems = ['P', 'C', 'B', 'U'];
    final system = systems[(a >> 6) & 0x03];
    final digit1 = (a >> 4) & 0x03;
    final digit2 = a & 0x0F;
    final digit3 = (b >> 4) & 0x0F;
    final digit4 = b & 0x0F;

    return '$system$digit1${digit2.toRadixString(16).toUpperCase()}'
        '${digit3.toRadixString(16).toUpperCase()}'
        '${digit4.toRadixString(16).toUpperCase()}';
  }

  String _systemName(String code) {
    if (code.isEmpty) return 'نظام غير معروف';
    return switch (code[0]) {
      'P' => 'المحرك ونظام نقل الحركة',
      'C' => 'الشاسيه',
      'B' => 'هيكل السيارة',
      'U' => 'شبكة الاتصال بين الوحدات',
      _ => 'نظام غير معروف',
    };
  }
}
