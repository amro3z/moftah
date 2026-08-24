  import 'package:moftah/data/models/emergency_tow_provider_model.dart';

const providers = [
    EmergencyTowProviderModel(
      id: 'tow-1',
      driverName: 'كابتن وليد',
      phone: '01033334444',
      governorate: 'القاهرة',
      coverageArea: 'القاهرة والجيزة',
      startingPrice: 650,
      maxDestination: 'حتى 80 كم من نقطة التحميل',
      rating: 4.8,
    ),
    EmergencyTowProviderModel(
      id: 'tow-2',
      driverName: 'أحمد صبري',
      phone: '01177778888',
      governorate: 'الجيزة',
      coverageArea: 'الجيزة - أكتوبر - الشيخ زايد',
      startingPrice: 700,
      maxDestination: 'حتى 100 كم من نقطة التحميل',
      rating: 4.7,
    ),
    EmergencyTowProviderModel(
      id: 'tow-3',
      driverName: 'محمود عادل',
      phone: '01255556666',
      governorate: 'القليوبية',
      coverageArea: 'القليوبية والقاهرة الكبرى',
      startingPrice: 600,
      maxDestination: 'حتى 70 كم من نقطة التحميل',
      rating: 4.6,
    ),
  ];