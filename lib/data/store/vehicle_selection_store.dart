import 'package:flutter/foundation.dart';
import 'package:moftah/data/models/app_vehicle_model.dart';
import 'package:moftah/data/models/vehicle_card.dart';
import 'package:moftah/data/models/vehicle_health_model.dart';
import 'package:moftah/domain/vehicle_health/vehicle_health_calculator.dart';

class VehicleSelectionStore extends ChangeNotifier {
  VehicleSelectionStore._();

  static final VehicleSelectionStore instance = VehicleSelectionStore._();

  final List<AppVehicleModel> _vehicles = [
    AppVehicleModel(
      id: 'toyota-corolla-2020',
      card: VehicleCardModel(
        carName: 'Toyota Corolla',
        year: 2020,
        mileage: 100008,
        healthScore: 85,
        maintenanceStatus: MaintenanceStatus.good,
        documentStatus: DocumentStatus.verified,
        brand: 'Toyota',
        brandLogoUrl: null,
        nextMaintenance: 1500,
        lastMaintenance: '15 مارس',
        repairStatus: RepairStatus.good,
      ),
      health: const VehicleHealthCalculator().calculateDemo(
        vehicleName: 'Toyota Corolla',
        brand: 'Toyota',
        year: 2020,
        mileage: 100008,
      ),
    ),
    AppVehicleModel(
      id: 'hyundai-elantra-2018',
      card: VehicleCardModel(
        carName: 'Hyundai Elantra',
        year: 2018,
        mileage: 124500,
        healthScore: 78,
        maintenanceStatus: MaintenanceStatus.needsService,
        documentStatus: DocumentStatus.verified,
        brand: 'Hyundai',
        brandLogoUrl: null,
        nextMaintenance: 700,
        lastMaintenance: '2 فبراير',
        repairStatus: RepairStatus.pending,
      ),
      health: const VehicleHealthModel(
        vehicleName: 'Hyundai Elantra',
        brand: 'Hyundai',
        brandLogoUrl: null,
        year: 2018,
        mileage: 124500,
        overallScore: 78,
        overallConfidence: 69,
        items: [
          VehicleHealthItemModel(
            title: 'المحرك',
            score: 81,
            confidence: 88,
            status: VehicleHealthStatus.good,
            source: VehicleHealthSource.obd,
            reason: 'القراءات مستقرة لكن الصيانة الدورية اقتربت',
          ),
          VehicleHealthItemModel(
            title: 'الزيت والصيانة',
            score: 66,
            confidence: 91,
            status: VehicleHealthStatus.attention,
            source: VehicleHealthSource.maintenanceHistory,
            reason: 'متبقي تقريبًا 700 كم على الصيانة القادمة',
            actionText: 'احجز صيانة قريبًا',
          ),
          VehicleHealthItemModel(
            title: 'الكهرباء والبطارية',
            score: 79,
            confidence: 80,
            status: VehicleHealthStatus.good,
            source: VehicleHealthSource.obd,
            reason: 'الجهد ضمن النطاق المقبول في آخر قراءة',
          ),
          VehicleHealthItemModel(
            title: 'الإطارات',
            score: 73,
            confidence: 58,
            status: VehicleHealthStatus.attention,
            source: VehicleHealthSource.estimated,
            reason: 'يفضل فحص الضغط والتآكل بسبب المسافة المقطوعة',
          ),
          VehicleHealthItemModel(
            title: 'الفرامل',
            score: null,
            confidence: 25,
            status: VehicleHealthStatus.unknown,
            source: VehicleHealthSource.technicianInspection,
            reason: 'لا يوجد فحص حديث كافٍ للفرامل',
            actionText: 'يحتاج فحص فني',
          ),
        ],
      ),
    ),
  ];

  int _selectedIndex = 0;

  List<AppVehicleModel> get vehicles => List.unmodifiable(_vehicles);
  int get selectedIndex => _selectedIndex;
  AppVehicleModel get selectedVehicle => _vehicles[_selectedIndex];

  void selectIndex(int index) {
    if (index < 0 || index >= _vehicles.length || index == _selectedIndex) return;
    _selectedIndex = index;
    notifyListeners();
  }

  void selectById(String id) {
    final index = _vehicles.indexWhere((vehicle) => vehicle.id == id);
    if (index != -1) selectIndex(index);
  }
}
