class ObdDeviceModel {
  final String name;
  final String address;

  const ObdDeviceModel({required this.name, required this.address});
}

class ObdTroubleCodeModel {
  final String code;
  final String system;
  final String title;
  final String description;
  final String codeType;

  const ObdTroubleCodeModel({
    required this.code,
    required this.system,
    required this.title,
    required this.description,
    required this.codeType,
  });
}

class ObdSnapshotModel {
  final bool ecuAvailable;
  final int? rpm;
  final int? speedKmh;
  final int? coolantTemperature;
  final int? intakeAirTemperature;
  final double? engineLoadPercent;
  final double? throttlePositionPercent;
  final double? adapterVoltage;
  final List<ObdTroubleCodeModel> troubleCodes;

  const ObdSnapshotModel({
    required this.ecuAvailable,
    this.rpm,
    this.speedKmh,
    this.coolantTemperature,
    this.intakeAirTemperature,
    this.engineLoadPercent,
    this.throttlePositionPercent,
    this.adapterVoltage,
    this.troubleCodes = const [],
  });
}

class ObdConnectionResult {
  final bool connected;
  final String adapterName;

  const ObdConnectionResult({
    required this.connected,
    required this.adapterName,
  });
}


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
