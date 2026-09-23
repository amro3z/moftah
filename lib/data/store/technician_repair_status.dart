import 'package:moftah/data/models/technician/repair_status.dart';

class TechnicianRepairStatus {
  TechnicianRepairStatus._();
  static List<RepairStageItem> stages = [
    RepairStageItem(
      title: 'تم استلام السيارة',
      description: 'تم استلام السيارة وبدء العمل',
      time: '11:45 ص',
      status: RepairStageStatus.completed,
      actionText: 'انهاء',
    ),
    RepairStageItem(
      title: 'جاري الفحص',
      description: 'يتم الآن فحص السيارة وتحديد العطل',
      time: '2:00 م',
      status: RepairStageStatus.current,
      actionText: 'إنهاء الفحص وإضافة النتيجة',
      // onActionPath: '/technician/finish_inspection',
    ),
    const RepairStageItem(
      title: 'بانتظار موافقة العميل',
      status: RepairStageStatus.upcoming,
    ),
    const RepairStageItem(
      title: 'جاري الإصلاح',
      status: RepairStageStatus.upcoming,
      actionText: 'انهاء',
    ),
    const RepairStageItem(
      title: 'الاختبار',
      status: RepairStageStatus.upcoming,
      actionText: 'انهاء',
    ),
    const RepairStageItem(
      title: 'تم الإصلاح',
      status: RepairStageStatus.upcoming,
    ),
  ];
}
