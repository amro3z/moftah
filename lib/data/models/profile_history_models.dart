class UserProfileModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String city;
  final String memberSince;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.memberSince,
  });
}

class SparePartOrderItemModel {
  final String id;
  final String name;
  final int quantity;
  final double unitPrice;

  const SparePartOrderItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => unitPrice * quantity;
}

class SparePartOrderModel {
  final String id;
  final String dateLabel;
  final String status;
  final List<SparePartOrderItemModel> items;
  final double total;
  final String centerName;
  final String centerAddress;
  final double centerDistanceKm;
  final String courierName;
  final String courierPhone;
  final int estimatedArrivalMinutes;

  const SparePartOrderModel({
    required this.id,
    required this.dateLabel,
    required this.status,
    required this.items,
    required this.total,
    required this.centerName,
    required this.centerAddress,
    required this.centerDistanceKm,
    required this.courierName,
    required this.courierPhone,
    required this.estimatedArrivalMinutes,
  });
}

class WorkerRequestHistoryModel {
  final String id;
  final String serviceTitle;
  final String providerName;
  final String providerPhone;
  final String centerName;
  final double distanceKm;
  final int estimatedArrivalMinutes;
  final String status;
  final String dateLabel;

  const WorkerRequestHistoryModel({
    required this.id,
    required this.serviceTitle,
    required this.providerName,
    required this.providerPhone,
    required this.centerName,
    required this.distanceKm,
    required this.estimatedArrivalMinutes,
    required this.status,
    required this.dateLabel,
  });
}

enum ConversationKind {
  technician,
  delivery,
  emergency,
  general,
}

class ConversationHistoryModel {
  final String id;
  final String participantId;
  final String participantName;
  final String subtitle;
  final String lastMessage;
  final String timeLabel;
  final String? phone;
  final ConversationKind kind;

  const ConversationHistoryModel({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.subtitle,
    required this.lastMessage,
    required this.timeLabel,
    required this.kind,
    this.phone,
  });
}
