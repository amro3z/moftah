import 'package:flutter/foundation.dart';
import 'package:moftah/data/models/car_owner/profile_history_models.dart';
import 'package:moftah/data/models/car_owner/spare_part_model.dart';

class ProfileHistoryStore extends ChangeNotifier {
  ProfileHistoryStore._();

  static final ProfileHistoryStore instance = ProfileHistoryStore._();

  final UserProfileModel profile = const UserProfileModel(
    id: 'user-1',
    name: 'عمرو محمد',
    phone: '01012345678',
    email: 'amr.mohamed@example.com',
    city: 'القاهرة',
    memberSince: 'عضو منذ 2026',
  );

  final List<SparePartOrderModel> _sparePartOrders = [
    const SparePartOrderModel(
      id: 'SP-1024',
      dateLabel: '24 أغسطس 2026',
      status: 'في الطريق',
      items: [
        SparePartOrderItemModel(
          id: 'bosch-coil',
          name: 'Bosch Ignition Coil',
          quantity: 1,
          unitPrice: 1250,
        ),
      ],
      total: 1310,
      centerName: 'Auto Parts Store - مدينة نصر',
      centerAddress: 'مدينة نصر، القاهرة',
      centerDistanceKm: 3.2,
      courierName: 'أحمد حسام',
      courierPhone: '01098765432',
      estimatedArrivalMinutes: 18,
    ),
    const SparePartOrderModel(
      id: 'SP-1018',
      dateLabel: '18 أغسطس 2026',
      status: 'تم التوصيل',
      items: [
        SparePartOrderItemModel(
          id: 'bosch-filter',
          name: 'فلتر زيت بوش',
          quantity: 2,
          unitPrice: 180,
        ),
      ],
      total: 420,
      centerName: 'Auto Parts Store - مدينة نصر',
      centerAddress: 'مدينة نصر، القاهرة',
      centerDistanceKm: 3.2,
      courierName: 'كريم سامح',
      courierPhone: '01122334455',
      estimatedArrivalMinutes: 0,
    ),
  ];

  final List<WorkerRequestHistoryModel> _workerRequests = const [
    WorkerRequestHistoryModel(
      id: 'WK-88',
      serviceTitle: 'ميكانيكي متنقل',
      providerName: 'محمد أحمد',
      providerPhone: '01011112222',
      centerName: 'Auto Pro Center',
      distanceKm: 4.3,
      estimatedArrivalMinutes: 12,
      status: 'في الطريق',
      dateLabel: 'اليوم، 8:20 م',
    ),
    WorkerRequestHistoryModel(
      id: 'WK-76',
      serviceTitle: 'فني كهرباء سيارات',
      providerName: 'محمود إبراهيم',
      providerPhone: '01144445555',
      centerName: 'Car Fix Hub',
      distanceKm: 6.1,
      estimatedArrivalMinutes: 22,
      status: 'مكتمل',
      dateLabel: '20 أغسطس 2026',
    ),
  ];

  final List<ConversationHistoryModel> _conversations = const [
    ConversationHistoryModel(
      id: 'CH-1',
      participantId: 'technician-1',
      participantName: 'محمد أحمد',
      subtitle: 'فني سيارات',
      lastMessage: 'تمام، أنا في الطريق إليك.',
      timeLabel: 'منذ 5 دقائق',
      phone: '01011112222',
      kind: ConversationKind.technician,
    ),
    ConversationHistoryModel(
      id: 'CH-2',
      participantId: 'courier-1',
      participantName: 'أحمد حسام',
      subtitle: 'مندوب توصيل قطع الغيار',
      lastMessage: 'الطلب خرج من المركز.',
      timeLabel: 'منذ 20 دقيقة',
      phone: '01098765432',
      kind: ConversationKind.delivery,
    ),
    ConversationHistoryModel(
      id: 'CH-3',
      participantId: 'tow-1',
      participantName: 'كابتن وليد',
      subtitle: 'ونش إنقاذ سيارات',
      lastMessage: 'متاح داخل القاهرة والجيزة.',
      timeLabel: 'أمس',
      phone: '01033334444',
      kind: ConversationKind.emergency,
    ),
  ];

  List<SparePartOrderModel> get sparePartOrders =>
      List.unmodifiable(_sparePartOrders);

  List<WorkerRequestHistoryModel> get workerRequests =>
      List.unmodifiable(_workerRequests);

  List<ConversationHistoryModel> get conversations =>
      List.unmodifiable(_conversations);

  void addSparePartOrder({
    required List<SparePartModel> products,
    required Map<String, int> quantities,
    required double total,
  }) {
    if (products.isEmpty) return;

    final items = products
        .map(
          (part) => SparePartOrderItemModel(
            id: part.id,
            name: part.name,
            quantity: quantities[part.id] ?? 1,
            unitPrice: part.price,
          ),
        )
        .toList();

    _sparePartOrders.insert(
      0,
      SparePartOrderModel(
        id: 'SP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        dateLabel: 'اليوم',
        status: 'جاري التجهيز',
        items: items,
        total: total,
        centerName: products.first.seller,
        centerAddress: products.first.location,
        centerDistanceKm: products.first.distanceKm,
        courierName: 'سيتم تعيين المندوب',
        courierPhone: '',
        estimatedArrivalMinutes: 30,
      ),
    );

    notifyListeners();
  }

  void addConversation(ConversationHistoryModel conversation) {
    _conversations.removeWhere((item) => item.id == conversation.id);
    _conversations.insert(0, conversation);
    notifyListeners();
  }

  // Logout intentionally left as a no-op until authentication is connected.
  void logout() {}
}
