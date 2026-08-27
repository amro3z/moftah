import 'package:flutter/foundation.dart';
import 'package:moftah/data/models/technician/technician_models.dart';

class TechnicianStore extends ChangeNotifier {
  TechnicianStore._();
  static final TechnicianStore instance = TechnicianStore._();

  final profile = const TechnicianProfileModel(
    id: 'tech-1',
    name: 'محمد أحمد',
    phone: '01012345678',
    email: 'mohamed@moftah.app',
    governorate: 'القاهرة',
    specialties: ['ميكانيكا', 'محركات', 'إشعال'],
    rating: 4.9,
    completedJobs: 128,
  );

  final List<TechnicianRequestModel> _requests = [
    const TechnicianRequestModel(
      id: 'req-1', customerName: 'عمرو محمد', vehicleName: 'Hyundai Elantra', vehicleYear: '2018',
      issueTitle: 'صوت غريب عند بدء الإشعال', issueDescription: 'صوت غريب عند تشغيل السيارة + رعشة خفيفة. لمبة المحرك مضاءة.',
      location: 'مدينة نصر', distanceKm: 2.1, createdAt: 'منذ 5 دقائق', riskLabel: 'متوسطة',
      aiAnalysis: 'تحليل: نظام الإشعال (78% احتمالية). يُرجح وجود مشكلة في البوجيهات أو كويل الإشعال.',
      tags: ['صوت غريب', 'رعشة', 'لمبة المحرك'],
    ),
    const TechnicianRequestModel(
      id: 'req-2', customerName: 'أحمد علي', vehicleName: 'Kia Cerato', vehicleYear: '2019',
      issueTitle: 'سخونة أعلى من الطبيعي', issueDescription: 'مؤشر الحرارة يرتفع مع الزحام ويعود لطبيعته على الطريق.',
      location: 'مصر الجديدة', distanceKm: 3.8, createdAt: 'منذ 12 دقيقة', riskLabel: 'منخفضة',
      aiAnalysis: 'قد تكون المشكلة مرتبطة بدائرة التبريد أو المروحة وتحتاج فحصًا مباشرًا.', tags: ['حرارة', 'تبريد'],
    ),
    const TechnicianRequestModel(
      id: 'req-3', customerName: 'محمود حسن', vehicleName: 'Toyota Corolla', vehicleYear: '2020',
      issueTitle: 'اهتزاز أثناء الفرملة', issueDescription: 'اهتزاز في الدركسيون عند الفرملة من سرعة أعلى من 80 كم/س.',
      location: 'التجمع الخامس', distanceKm: 6.4, createdAt: 'منذ 20 دقيقة', riskLabel: 'متوسطة', tags: ['فرامل', 'اهتزاز'],
    ),
    const TechnicianRequestModel(
      id: 'req-4', customerName: 'يوسف سامي', vehicleName: 'Nissan Sunny', vehicleYear: '2021',
      issueTitle: 'تكييف ضعيف', issueDescription: 'التبريد ضعيف خصوصًا وقت الظهر.',
      location: 'العباسية', distanceKm: 4.7, createdAt: 'منذ 31 دقيقة', riskLabel: 'منخفضة', tags: ['تكييف'],
    ),
    const TechnicianRequestModel(
      id: 'job-1', customerName: 'كريم خالد', vehicleName: 'Chevrolet Optra', vehicleYear: '2017',
      issueTitle: 'تغيير طقم بوجيهات', issueDescription: 'صيانة دورية وتغيير بوجيهات.', location: 'مدينة نصر', distanceKm: 1.5,
      createdAt: 'اليوم 10:30 ص', riskLabel: 'منخفضة', status: TechnicianRequestStatus.inProgress,
      minCost: 800, maxCost: 1100, estimatedDuration: '1-2 ساعة', warranty: 'شهر واحد',
    ),
    const TechnicianRequestModel(
      id: 'job-2', customerName: 'سيف عماد', vehicleName: 'Renault Logan', vehicleYear: '2016',
      issueTitle: 'إصلاح دائرة التبريد', issueDescription: 'تم تغيير خرطوم وتنظيف دورة التبريد.', location: 'المعادي', distanceKm: 8.2,
      createdAt: '12 أغسطس', riskLabel: 'متوسطة', status: TechnicianRequestStatus.completed,
      minCost: 1500, maxCost: 1800, estimatedDuration: '3 ساعات', warranty: '3 أشهر',
    ),
  ];

  final conversations = const [
    TechnicianConversationModel(id: 'c1', customerName: 'كريم خالد', subtitle: 'متصل الآن', lastMessage: 'تمام، ابدأ العمل الآن', time: '12:37', requestId: 'job-1'),
    TechnicianConversationModel(id: 'c2', customerName: 'سيف عماد', subtitle: 'آخر ظهور أمس', lastMessage: 'شكرًا يا هندسة', time: 'أمس', requestId: 'job-2'),
  ];

  List<TechnicianRequestModel> get requests => List.unmodifiable(_requests.where((e) => e.status == TechnicianRequestStatus.newRequest || e.status == TechnicianRequestStatus.offerSent));
  List<TechnicianRequestModel> get currentJobs => List.unmodifiable(_requests.where((e) => e.status == TechnicianRequestStatus.accepted || e.status == TechnicianRequestStatus.inProgress));
  List<TechnicianRequestModel> get previousJobs => List.unmodifiable(_requests.where((e) => e.status == TechnicianRequestStatus.completed));
  TechnicianRequestModel byId(String id) => _requests.firstWhere((e) => e.id == id);

  TechnicianAppBarModel get appBar => TechnicianAppBarModel(
    technician: profile,
    newRequests: requests.where((e) => e.status == TechnicianRequestStatus.newRequest).length,
    pendingOffers: requests.where((e) => e.status == TechnicianRequestStatus.offerSent).length,
    todayJobs: currentJobs.length,
    todayEarnings: 4200,
  );

  void reject(String id) {
    final i = _requests.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _requests[i] = _requests[i].copyWith(status: TechnicianRequestStatus.rejected);
    notifyListeners();
  }

  void sendOffer(String id, {required double inspectionFee, required double minCost, required double maxCost, required String duration, required String warranty, String? notes}) {
    final i = _requests.indexWhere((e) => e.id == id);
    if (i < 0) return;
    _requests[i] = _requests[i].copyWith(status: TechnicianRequestStatus.offerSent, inspectionFee: inspectionFee, minCost: minCost, maxCost: maxCost, estimatedDuration: duration, warranty: warranty, offerNotes: notes);
    notifyListeners();
  }
}
