import 'package:moftah/data/models/vehicle_health_model.dart';

class VehicleHealthCalculator {
  const VehicleHealthCalculator();

  VehicleHealthModel calculateDemo({
    required String vehicleName,
    required String brand,
    required int year,
    required int mileage,
  }) {
    const items = <VehicleHealthItemModel>[
      VehicleHealthItemModel(
        title: 'المحرك', score: 92, confidence: 95,
        status: VehicleHealthStatus.excellent,
        source: VehicleHealthSource.obd,
        reason: 'لا توجد أعطال نشطة وقراءات المحرك مستقرة',
      ),
      VehicleHealthItemModel(
        title: 'الزيت والصيانة', score: 76, confidence: 90,
        status: VehicleHealthStatus.attention,
        source: VehicleHealthSource.maintenanceHistory,
        reason: 'موعد تغيير الزيت يقترب — متبقي تقريباً 1,200 كم',
        actionText: 'راجع موعد الصيانة',
      ),
      VehicleHealthItemModel(
        title: 'الكهرباء والبطارية', score: 88, confidence: 82,
        status: VehicleHealthStatus.good,
        source: VehicleHealthSource.obd,
        reason: 'آخر قراءات الجهد ضمن النطاق الطبيعي',
      ),
      VehicleHealthItemModel(
        title: 'الإطارات', score: 84, confidence: 64,
        status: VehicleHealthStatus.good,
        source: VehicleHealthSource.estimated,
        reason: 'التقييم مبني على العمر والكيلومترات منذ آخر تغيير',
        actionText: 'يفضل فحص ضغط وتآكل الإطارات',
      ),
      VehicleHealthItemModel(
        title: 'الفرامل', score: null, confidence: 25,
        status: VehicleHealthStatus.unknown,
        source: VehicleHealthSource.technicianInspection,
        reason: 'لا توجد بيانات حديثة كافية لتقييم الفرامل بأمان',
        actionText: 'يحتاج فحص فني',
      ),
    ];

    final known = items.where((item) => item.score != null).toList();
    final weighted = known.fold<double>(0, (sum, item) => sum + item.score! * item.confidence);
    final confidenceWeight = known.fold<int>(0, (sum, item) => sum + item.confidence);
    final overall = confidenceWeight == 0 ? 0 : (weighted / confidenceWeight).round();
    final confidence = (items.fold<int>(0, (sum, item) => sum + item.confidence) / items.length).round();

    return VehicleHealthModel(
      vehicleName: vehicleName,
      brand: brand,
      brandLogoUrl: null,
      year: year,
      mileage: mileage,
      overallScore: overall,
      overallConfidence: confidence,
      items: items,
    );
  }
}
