
import 'package:moftah/data/datasources/elm327_bluetooth_data_source.dart';
import 'package:moftah/data/models/obd/obd_models.dart';
import 'package:moftah/data/repos/obd_protocol_probe.dart';
import 'package:moftah/ui/core/helper/obd_dtc_helper.dart';


class ObdRepository {
  final Elm327BluetoothDataSource _dataSource;
  bool _ecuReady = false;
  String? _activeProtocolNumber;

  bool get ecuReady => _ecuReady;
  String? get activeProtocolNumber => _activeProtocolNumber;

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
    _ecuReady = false;
    _activeProtocolNumber = null;
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

    _ecuReady = true;

    final protocol = await _command('ATDP', onTrace: onTrace);
    final protocolNumber = await _command('ATDPN', onTrace: onTrace);
    _activeProtocolNumber = _normalizeProtocolNumber(protocolNumber);
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
    final dtcs = await _parseTroubleCodes(
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

  Future<ObdSnapshotModel> readLiveSnapshot({
    void Function(String)? onTrace,
    List<ObdTroubleCodeModel>? troubleCodes,
  }) async {
    if (!_ecuReady) {
      return readSnapshot(onTrace: onTrace);
    }

    final rpm = _parseRpm(await _command('010C', onTrace: onTrace));
    final speed = _parseSingleBytePid(
      await _command('010D', onTrace: onTrace), pid: 0x0D);
    final throttle = _parsePercentage(
      await _command('0111', onTrace: onTrace), pid: 0x11);
    final load = _parsePercentage(
      await _command('0104', onTrace: onTrace), pid: 0x04);
    final coolant = _parseCoolant(await _command('0105', onTrace: onTrace));
    final intake = _parseTemperature(
      await _command('010F', onTrace: onTrace), pid: 0x0F);
    final voltage = _parseVoltage(await _command('ATRV', onTrace: onTrace));

    return ObdSnapshotModel(
      ecuAvailable: true,
      rpm: rpm,
      speedKmh: speed,
      coolantTemperature: coolant,
      intakeAirTemperature: intake,
      engineLoadPercent: load,
      throttlePositionPercent: throttle,
      adapterVoltage: voltage,
      troubleCodes: troubleCodes ?? const [],
    );
  }

  Future<List<ObdTroubleCodeModel>> readTroubleCodes({
    void Function(String)? onTrace,
  }) async {
    if (!_ecuReady) return const [];
    return _parseTroubleCodes(await _command('03', onTrace: onTrace));
  }

  Future<bool> clearTroubleCodes({void Function(String)? onTrace}) async {
    if (!_ecuReady) return false;

    final beforeResponse = await _command('03', onTrace: onTrace);
    final beforeCodes = await _parseTroubleCodes(beforeResponse);

    if (beforeCodes.isEmpty) {
      onTrace?.call('مفيش أعطال مخزنة محتاجة مسح دلوقتي.');
      return true;
    }

    onTrace?.call(
      'هنطلب من كمبيوتر العربية يمسح الأعطال المخزنة. '
      'الأفضل الكونتاكت ON والموتور مطفي.',
    );

    final response = await _command('04', onTrace: onTrace);
    final directConfirmation = _hexBytes(response).contains(0x44);

    await Future<void>.delayed(const Duration(milliseconds: 1200));

    final afterResponse = await _command('03', onTrace: onTrace);
    final afterCodes = await _parseTroubleCodes(afterResponse);

    final responseUpper = afterResponse.toUpperCase();
    final validEmptyRead = afterCodes.isEmpty &&
        !responseUpper.contains('UNABLE TO CONNECT') &&
        !responseUpper.contains('BUS ERROR') &&
        !responseUpper.contains('CAN ERROR') &&
        !responseUpper.contains('STOPPED');

    final disappeared = beforeCodes.isNotEmpty && validEmptyRead;
    final ok = directConfirmation || disappeared;

    if (directConfirmation) {
      onTrace?.call('كمبيوتر العربية أكد أمر المسح (44).');
    } else if (disappeared) {
      onTrace?.call(
        'القطعة ما رجعتش تأكيد 44، بس لما راجعنا الأعطال بعدها '
        'الأكواد المخزنة اختفت، فالمسح تم.',
      );
    } else {
      onTrace?.call(
        'الأعطال لسه موجودة بعد أمر المسح. جرّب الكونتاكت ON '
        'والموتور مطفي. ولو سبب العطل لسه موجود ممكن الكود يرجع.',
      );
    }

    return ok;
  }

  String? _normalizeProtocolNumber(String raw) {
    final cleaned = raw.toUpperCase().replaceAll(RegExp(r'[^0-9A-F]'), '');
    if (cleaned.isEmpty) return null;
    return cleaned.startsWith('A') && cleaned.length > 1
        ? cleaned.substring(1)
        : cleaned;
  }

  Future<void> _initializeAdapter({
    void Function(String)? onTrace,
  }) async {
    await _command('ATZ', onTrace: onTrace);
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    await _command('ATD', onTrace: onTrace);
    await _command('ATE0', onTrace: onTrace);
    await _command('ATL0', onTrace: onTrace);
    await _command('ATS1', onTrace: onTrace);
    await _command('ATH0', onTrace: onTrace);
    await _command('ATAL', onTrace: onTrace);
    await _command('ATAT1', onTrace: onTrace);

    await _command('ATST64', onTrace: onTrace);

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

  Future<List<ObdTroubleCodeModel>> _parseTroubleCodes(String response) async {
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
      final info = await ObdDtcHelper.infoAsync(code);
      result.add(
        ObdTroubleCodeModel(
          code: code,
          system: info.system,
          title: info.title,
          description: info.description,
          codeType: ObdDtcHelper.codeType(code),
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

}
