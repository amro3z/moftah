enum RoadsideAssistanceType {
  tow,
  battery,
  tire,
  mobileMechanic,
  overheating,
  accident,
  other,
}

extension RoadsideAssistanceTypeX on RoadsideAssistanceType {
  String get label => switch (this) {
        RoadsideAssistanceType.tow => 'ونش',
        RoadsideAssistanceType.battery => 'بطارية',
        RoadsideAssistanceType.tire => 'كاوتش',
        RoadsideAssistanceType.mobileMechanic => 'ميكانيكي متنقل',
        RoadsideAssistanceType.overheating => 'ارتفاع حرارة',
        RoadsideAssistanceType.accident => 'حادث',
        RoadsideAssistanceType.other => 'أخرى',
      };
}

class TowServiceModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final double rating;
  final int reviewsCount;
  final List<String> phones;
  final String? openingHours;
  final bool? isOpen;
  final bool roadsideAssistance;
  final bool vehicleRecovery;

  const TowServiceModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    this.rating = 0,
    this.reviewsCount = 0,
    this.phones = const [],
    this.openingHours,
    this.isOpen,
    this.roadsideAssistance = true,
    this.vehicleRecovery = true,
  });

  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} كم';
  String get primaryPhone => phones.isEmpty ? '' : phones.first;
}

class RoadsideChatModel {
  final String providerId;
  final String providerName;
  final String subtitle;
  final String? imageUrl;
  final String? phone;

  const RoadsideChatModel({
    required this.providerId,
    required this.providerName,
    this.subtitle = 'خدمة مساعدة على الطريق',
    this.imageUrl,
    this.phone,
  });

  factory RoadsideChatModel.fromTowService(TowServiceModel service) {
    return RoadsideChatModel(
      providerId: service.id,
      providerName: service.name,
      subtitle: 'ونش • ${service.distanceLabel}',
      phone: service.primaryPhone.isEmpty ? null : service.primaryPhone,
    );
  }
}


class TowTrackingArguments {
  final TowServiceModel service;
  final double userLatitude;
  final double userLongitude;

  const TowTrackingArguments({
    required this.service,
    required this.userLatitude,
    required this.userLongitude,
  });
}
