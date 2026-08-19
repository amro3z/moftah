import 'package:moftah/data/dtc/dtc_catalog.dart';
import 'package:moftah/data/dtc/dtc_info.dart';

class ObdDtcHelper {
  static ObdDtcInfo info(String code) {
    final normalized = code.trim().toUpperCase();
    final exact = DtcCatalog.find(normalized);
    if (exact != null) return exact;

    if (isManufacturerSpecific(normalized)) {
      return ObdDtcInfo(
        title: 'كود خاص بالشركة المصنعة',
        description: 'الكود ده معناه بيتغير حسب ماركة وموديل وسنة العربية. هنحتفظ بالكود ونبعته مع بيانات الفحص لتحليل الـ AI بدل ما نخمن معناه.',
        system: systemName(normalized),
      );
    }

    return ObdDtcInfo(
      title: subsystemName(normalized),
      description: 'العربية سجلت عطل في ${systemName(normalized)}. الكود قياسي، لكن الشرح التفصيلي لسه مش مضاف في القاموس المصري داخل التطبيق.',
      system: systemName(normalized),
    );
  }

  static String systemName(String code) {
    if (code.isEmpty) return 'نظام غير معروف';
    return switch (code[0].toUpperCase()) {
      'P' => 'المحرك والفتيس ونقل الحركة',
      'B' => 'جسم العربية والأنظمة الداخلية',
      'C' => 'الشاسيه والفرامل والتوجيه',
      'U' => 'شبكة الاتصال بين كمبيوترات العربية',
      _ => 'نظام غير معروف',
    };
  }

  static bool isManufacturerSpecific(String code) {
    if (code.length < 2) return false;
    final second = code[1];
    if (code.startsWith('P')) return second == '1';
    return second == '1' || second == '2';
  }

  static String codeType(String code) =>
      isManufacturerSpecific(code) ? 'كود خاص بالشركة' : 'كود OBD-II قياسي';

  static String subsystemName(String code) {
    if (code.length < 3 || !code.startsWith('P')) return systemName(code);
    return switch (code[2]) {
      '1' => 'قياس الهوا والوقود',
      '2' => 'الوقود والرشاشات',
      '3' => 'الإشعال والتقطيع',
      '4' => 'العادم والانبعاثات',
      '5' => 'السلانسيه وسرعة العربية',
      '6' => 'كمبيوتر العربية ودوائر التحكم',
      '7' || '8' => 'الفتيس ونقل الحركة',
      _ => 'المحرك والفتيس ونقل الحركة',
    };
  }
}
