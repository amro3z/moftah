enum VehicleHealthSource { obd, maintenanceHistory, technicianInspection, userInput, estimated }

enum VehicleHealthStatus { excellent, good, attention, critical, unknown }

class VehicleHealthItemModel {
  final String title;
  final int? score;
  final int confidence;
  final VehicleHealthStatus status;
  final VehicleHealthSource source;
  final String reason;
  final String? actionText;

  const VehicleHealthItemModel({
    required this.title,
    required this.score,
    required this.confidence,
    required this.status,
    required this.source,
    required this.reason,
    this.actionText,
  });

  factory VehicleHealthItemModel.fromJson(Map<String, dynamic> json) {
    return VehicleHealthItemModel(
      title: json['title']?.toString() ?? '',
      score: (json['score'] as num?)?.toInt(),
      confidence: (json['confidence'] as num?)?.toInt() ?? 0,
      status: VehicleHealthStatus.values.firstWhere(
        (value) => value.name == json['status']?.toString(),
        orElse: () => VehicleHealthStatus.unknown,
      ),
      source: VehicleHealthSource.values.firstWhere(
        (value) => value.name == json['source']?.toString(),
        orElse: () => VehicleHealthSource.estimated,
      ),
      reason: json['reason']?.toString() ?? '',
      actionText: json['actionText']?.toString(),
    );
  }
}

class VehicleHealthModel {
  final String vehicleName;
  final String brand;
  final String? brandLogoUrl;
  final int year;
  final int mileage;
  final int overallScore;
  final int overallConfidence;
  final List<VehicleHealthItemModel> items;

  const VehicleHealthModel({
    required this.vehicleName,
    required this.brand,
    this.brandLogoUrl,
    required this.year,
    required this.mileage,
    required this.overallScore,
    required this.overallConfidence,
    required this.items,
  });

  factory VehicleHealthModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return VehicleHealthModel(
      vehicleName: json['vehicleName']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      brandLogoUrl: json['brandLogoUrl']?.toString(),
      year: (json['year'] as num?)?.toInt() ?? 0,
      mileage: (json['mileage'] as num?)?.toInt() ?? 0,
      overallScore: (json['overallScore'] as num?)?.toInt() ?? 0,
      overallConfidence: (json['overallConfidence'] as num?)?.toInt() ?? 0,
      items: rawItems
          .whereType<Map>()
          .map((item) => VehicleHealthItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }
}
