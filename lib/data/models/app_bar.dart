import 'package:moftah/data/models/car_owner/profile_history_models.dart';
import 'package:moftah/data/models/vehicle_card/vehicle_card.dart';
import 'package:moftah/data/models/technician/technician_models.dart';

class CarOwnerAppBarModel {
  final UserProfileModel userProfile;
  final VehicleCardModel car;
  final String phoneNumber;
  CarOwnerAppBarModel({required this.userProfile, required this.car, required this.phoneNumber});
}

/// مودل موحد للهوم. وجود carOwner يعني هوم صاحب العربية،
/// ولو carOwner == null و technician != null نرسم AppBar الفني.
class HomeAppBarModel {
  final CarOwnerAppBarModel? carOwner;
  final TechnicianAppBarModel? technician;

  const HomeAppBarModel({this.carOwner, this.technician})
      : assert(carOwner != null || technician != null);

  bool get isCarOwner => carOwner != null;
  bool get isTechnician => carOwner == null && technician != null;
}
