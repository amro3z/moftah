import 'package:moftah/data/dtc/dtc_info.dart';

const Map<String, ObdDtcInfo> chassisDtc = {
  'C0035': ObdDtcInfo(
    title: 'مشكلة في حساس سرعة العجلة الأمامية الشمال',
    description:
        'الكود غالبًا مرتبط بإشارة حساس سرعة العجلة الأمامية الشمال أو أسلاكه. ممكن يأثر على ABS ومانع الانزلاق.',
    system: 'الشاسيه - ABS وحساسات العجل',
  ),
  'C0040': ObdDtcInfo(
    title: 'مشكلة في حساس سرعة العجلة الأمامية اليمين',
    description:
        'الكود غالبًا مرتبط بإشارة حساس سرعة العجلة الأمامية اليمين أو أسلاكه.',
    system: 'الشاسيه - ABS وحساسات العجل',
  ),
};
