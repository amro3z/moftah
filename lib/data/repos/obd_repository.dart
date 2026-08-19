
import 'package:moftah/data/datasources/elm327_bluetooth_data_source.dart';
import 'package:moftah/data/models/obd_models.dart';
import 'package:moftah/data/repos/obd_protocol_probe.dart';

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

  Future<void> initializeAdapter({void Function(String)? onTrace}) {
    return _initializeAdapter(onTrace: onTrace);
  }

  Future<String> readAdapterName({void Function(String)? onTrace}) async {
    final adapterName = await _command('ATI', onTrace: onTrace);
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

  Future<ObdSnapshotModel> readSnapshot({
    void Function(String)? onTrace,
  }) async {
    final voltageResponse = await _command('ATRV', onTrace: onTrace);
    final voltage = _parseVoltage(voltageResponse);

    if (voltage != null) {
      onTrace?.call('جهد منفذ OBD: ${voltage.toStringAsFixed(1)}V');
      if (voltage < 11.5) {
        onTrace?.call(
          'تنبيه: الجهد منخفض جدًا. هنكمل الفحص، لكن انخفاض الجهد ممكن '
          'يخلي بعض وحدات ECU لا تبدأ أو لا ترد بشكل ثابت.',
        );
      }
    } else {
      onTrace?.call('لم نتمكن من قراءة جهد منفذ OBD من ATRV.');
    }

    onTrace?.call('بدء البحث التلقائي عن بروتوكول OBD-II...');
    await _command('ATPC', onTrace: onTrace);
    await _command('ATSP0', onTrace: onTrace);

    var probe = await _probeCurrentProtocol(
      onTrace: onTrace,
      label: 'Auto',
    );

    if (!probe.success) {
      onTrace?.call(
        'البحث التلقائي لم يجد استجابة OBD صالحة. '
        'هنجرب البروتوكولات القياسية واحدًا واحدًا.',
      );
      probe = await _findProtocolManually(onTrace: onTrace);
    }

    if (!probe.success) {
      onTrace?.call(
        'لم نصل لرد OBD قياسي من ECU. '
        'لو جهاز فحص احترافي يدخل على العربية في نفس اللحظة، '
        'فقد يكون يستخدم تشخيص الشركة المصنعة وليس Generic OBD-II فقط.',
      );
      return ObdSnapshotModel(
        ecuAvailable: false,
        adapterVoltage: voltage,
      );
    }

    final protocol = await _command('ATDP', onTrace: onTrace);
    final protocolNumber = await _command('ATDPN', onTrace: onTrace);
    onTrace?.call(
      'البروتوكول النشط: '
      '${protocol.isEmpty ? 'غير معروف' : protocol}'
      '${protocolNumber.isEmpty ? '' : ' ($protocolNumber)'}',
    );

    final rpm = _parseRpm(await _command('010C', onTrace: onTrace));
    final speed = _parseSingleBytePid(
      await _command('010D', onTrace: onTrace),
      pid: 0x0D,
    );
    final coolant = _parseCoolant(
      await _command('0105', onTrace: onTrace),
    );
    final intakeAirTemperature = _parseTemperature(
      await _command('010F', onTrace: onTrace),
      pid: 0x0F,
    );
    final engineLoad = _parsePercentage(
      await _command('0104', onTrace: onTrace),
      pid: 0x04,
    );
    final throttlePosition = _parsePercentage(
      await _command('0111', onTrace: onTrace),
      pid: 0x11,
    );
    final dtcs = _parseTroubleCodes(
      await _command('03', onTrace: onTrace),
    );

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

  Future<void> _initializeAdapter({
    void Function(String)? onTrace,
  }) async {
    await _command('ATZ', onTrace: onTrace);
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    // Reset adapter options before configuring a clean diagnostic session.
    await _command('ATD', onTrace: onTrace);
    await _command('ATE0', onTrace: onTrace);
    await _command('ATL0', onTrace: onTrace);
    await _command('ATS1', onTrace: onTrace);
    await _command('ATH0', onTrace: onTrace);
    await _command('ATAL', onTrace: onTrace);
    await _command('ATAT1', onTrace: onTrace);

    // 0x64 * 4ms ~= 400ms ECU response window after protocol is known.
    // K-line initialization itself may take longer; the Bluetooth read timeout
    // in the data source is intentionally much longer.
    await _command('ATST64', onTrace: onTrace);

    // Do not assume this already found the protocol. The first OBD request
    // triggers auto-search.
    await _command('ATSP0', onTrace: onTrace);
  }

  Future<ObdProtocolProbeResult> _findProtocolManually({
    void Function(String)? onTrace,
  }) {
    final scanner = ObdProtocolProbe(
      sendCommand: (command) => _command(
        command,
        onTrace: onTrace,
      ),
      onTrace: onTrace,
    );

    return scanner.scanAllProtocols();
  }

  Future<ObdProtocolProbeResult> _probeCurrentProtocol({
    required String label,
    void Function(String)? onTrace,
  }) {
    final scanner = ObdProtocolProbe(
      sendCommand: (command) => _command(
        command,
        onTrace: onTrace,
      ),
      onTrace: onTrace,
    );

    return scanner.probeCurrentProtocol(label: label);
  }

  Future<String> _command(
    String command, {
    void Function(String)? onTrace,
  }) async {
    final stopwatch = Stopwatch()..start();

    onTrace?.call('TX  $command');
    final response = await _dataSource.sendCommand(command);

    stopwatch.stop();
    final elapsed = stopwatch.elapsedMilliseconds;

    onTrace?.call(
      'RX  ${response.isEmpty ? '(empty)' : response.replaceAll('\n', ' | ')}'
      '  [${elapsed}ms]',
    );

    return response;
  }

  bool _isOk(String response) {
    return response.toUpperCase().contains('OK');
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
