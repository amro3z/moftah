class ObdDeviceModel {
  final String name;
  final String address;

  const ObdDeviceModel({
    required this.name,
    required this.address,
  });
}

class ObdTroubleCodeModel {
  final String code;
  final String system;

  const ObdTroubleCodeModel({
    required this.code,
    required this.system,
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
