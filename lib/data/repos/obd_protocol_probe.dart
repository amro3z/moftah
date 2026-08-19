class ObdProtocolProbeResult {
  final bool success;
  final bool busInitialized;
  final String response;

  const ObdProtocolProbeResult({
    this.success = false,
    this.busInitialized = false,
    this.response = '',
  });
}

class ObdProtocolProbe {
  final Future<String> Function(String command) sendCommand;
  final void Function(String message)? onTrace;

  const ObdProtocolProbe({
    required this.sendCommand,
    this.onTrace,
  });

  static const Map<String, String> protocols = {
    '6': 'ISO 15765-4 CAN 11-bit 500k',
    '7': 'ISO 15765-4 CAN 29-bit 500k',
    '8': 'ISO 15765-4 CAN 11-bit 250k',
    '9': 'ISO 15765-4 CAN 29-bit 250k',
    '5': 'ISO 14230-4 KWP fast init',
    '4': 'ISO 14230-4 KWP 5-baud init',
    '3': 'ISO 9141-2',
    '2': 'SAE J1850 VPW',
    '1': 'SAE J1850 PWM',
  };

  Future<ObdProtocolProbeResult> scanAllProtocols() async {
    for (final entry in protocols.entries) {
      onTrace?.call('تجربة ${entry.value}');

      await sendCommand('ATPC');
      await Future<void>.delayed(const Duration(milliseconds: 120));

      final setResponse = await sendCommand('ATSP${entry.key}');
      if (!_isOk(setResponse)) {
        onTrace?.call('المحول لم يقبل البروتوكول ${entry.key}.');
        continue;
      }

      await Future<void>.delayed(const Duration(milliseconds: 180));

      final result = await probeCurrentProtocol(label: entry.value);

      if (result.busInitialized && !result.success) {
        onTrace?.call(
          'تهيئة الباص نجحت على ${entry.value} لكن Generic OBD لم يرجع بيانات.',
        );
      }

      if (result.success) {
        onTrace?.call('تم التواصل مع ECU باستخدام ${entry.value}.');
        return result;
      }
    }

    onTrace?.call(
      'انتهى فحص كل بروتوكولات Generic OBD-II بدون استجابة ECU صالحة.',
    );
    return const ObdProtocolProbeResult();
  }

  Future<ObdProtocolProbeResult> probeCurrentProtocol({
    required String label,
  }) async {
    final supportedPids = await sendCommand('0100');

    if (_hasMode01Response(supportedPids)) {
      return ObdProtocolProbeResult(
        success: true,
        response: supportedPids,
        busInitialized: _busInitialized(supportedPids),
      );
    }

    final initialized = _busInitialized(supportedPids);

    final rpm = await sendCommand('010C');
    if (_hasMode01Response(rpm)) {
      onTrace?.call(
        '$label رد على PID 010C رغم عدم وجود رد صالح على 0100.',
      );
      return ObdProtocolProbeResult(
        success: true,
        response: rpm,
        busInitialized: initialized || _busInitialized(rpm),
      );
    }

    final monitorStatus = await sendCommand('0101');
    if (_hasMode01Response(monitorStatus)) {
      onTrace?.call('$label رد على PID 0101.');
      return ObdProtocolProbeResult(
        success: true,
        response: monitorStatus,
        busInitialized: initialized || _busInitialized(monitorStatus),
      );
    }

    return ObdProtocolProbeResult(
      success: false,
      response: supportedPids,
      busInitialized: initialized ||
          _busInitialized(rpm) ||
          _busInitialized(monitorStatus),
    );
  }

  bool _isOk(String response) {
    return response.toUpperCase().contains('OK');
  }

  bool _busInitialized(String response) {
    final upper = response.toUpperCase();

    return upper.contains('BUS INIT: OK') ||
        upper.contains('BUS INIT:OK') ||
        upper.contains('SEARCHING');
  }

  bool _hasMode01Response(String response) {
    final upper = response.toUpperCase();

    if (upper.isEmpty ||
        upper.contains('NO DATA') ||
        upper.contains('UNABLE TO CONNECT') ||
        upper.contains('ERROR') ||
        upper.contains('STOPPED')) {
      return false;
    }

    final matches = RegExp(r'\b[0-9A-Fa-f]{2}\b').allMatches(response);
    final bytes = matches
        .map((match) => int.parse(match.group(0)!, radix: 16))
        .toList();

    return bytes.contains(0x41);
  }
}
