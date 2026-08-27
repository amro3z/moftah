import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:moftah/data/models/report/problem_report_model.dart';
import 'package:moftah/data/models/car_owner/service_offer_model.dart';

class ServiceRequestStore extends ChangeNotifier {
  ServiceRequestStore._();

  static final ServiceRequestStore instance = ServiceRequestStore._();

  ProblemReportModel? _activeReport;
  bool _waitingForOffers = false;
  final List<ServiceOfferModel> _offers = [];
  ServiceOfferModel? _acceptedOffer;
  int _requestVersion = 0;

  ProblemReportModel? get activeReport => _activeReport;
  bool get waitingForOffers => _waitingForOffers;
  List<ServiceOfferModel> get offers => List.unmodifiable(_offers);
  bool get hasOffers => _offers.isNotEmpty;
  ServiceOfferModel? get acceptedOffer => _acceptedOffer;
  bool get hasAcceptedOffer => _acceptedOffer != null;
  bool get shouldShowOffersBanner => _offers.isNotEmpty && _acceptedOffer == null;

  /// Demo store until the backend/socket is connected.
  /// Returns immediately so the user can go back Home while offers arrive later.
  Future<void> submitRequest(ProblemReportModel report) async {
    _requestVersion++;
    final version = _requestVersion;
    _activeReport = report;
    _waitingForOffers = true;
    _acceptedOffer = null;
    _offers.clear();
    notifyListeners();

    unawaited(_simulateIncomingOffers(version));
  }

  Future<void> _simulateIncomingOffers(int version) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (version != _requestVersion || _activeReport == null) return;

    _offers.add(const ServiceOfferModel(
      id: 'offer-1',
      providerName: 'محمد أحمد',
      providerType: 'فني',
      specialty: 'فني محركات وإشعال',
      rating: 4.9,
      distanceKm: 2.1,
      inspectionFee: 200,
      minEstimatedCost: 900,
      maxEstimatedCost: 1400,
      estimatedDuration: '1–2 ساعة',
      availability: 'متاح اليوم',
      note: 'أقدر أوصل خلال وقت قصير وأبدأ بفحص شامل للمحرك ونظام الإشعال.',
    ));
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 1));
    if (version != _requestVersion) return;
    _offers.add(const ServiceOfferModel(
      id: 'offer-2',
      providerName: 'أحمد سالم',
      providerType: 'فني',
      specialty: 'فني إشعال وكهرباء',
      rating: 4.7,
      distanceKm: 3.4,
      inspectionFee: 150,
      minEstimatedCost: 800,
      maxEstimatedCost: 1200,
      estimatedDuration: '2–3 ساعات',
      availability: 'متاح اليوم',
      note: 'العرض يشمل الفحص المبدئي، وبعد المعاينة أوضح التكلفة النهائية قبل أي إصلاح.',
    ));
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (version != _requestVersion) return;
    _offers.add(const ServiceOfferModel(
      id: 'offer-3',
      providerName: 'Auto Pro Center',
      providerType: 'ورشة',
      specialty: 'محركات وكهرباء',
      rating: 4.8,
      distanceKm: 4.0,
      inspectionFee: 100,
      minEstimatedCost: 700,
      maxEstimatedCost: 1250,
      estimatedDuration: '2–4 ساعات',
      availability: 'غدًا',
      note: 'يمكن استقبال السيارة في المركز مع فحص كمبيوتر قبل بدء الإصلاح.',
    ));
    _waitingForOffers = false;
    notifyListeners();
  }

  void acceptOffer(ServiceOfferModel offer) {
    _requestVersion++;
    _acceptedOffer = offer;
    _waitingForOffers = false;
    _offers.clear();
    notifyListeners();
  }

  void rejectOffer(ServiceOfferModel offer) {
    _offers.removeWhere((item) => item.id == offer.id);
    if (_offers.isEmpty) {
      _waitingForOffers = false;
    }
    notifyListeners();
  }

  void clear() {
    _requestVersion++;
    _activeReport = null;
    _acceptedOffer = null;
    _waitingForOffers = false;
    _offers.clear();
    notifyListeners();
  }
}
