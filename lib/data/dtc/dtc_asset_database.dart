import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moftah/data/models/obd/dtc_info.dart';

class DtcAssetDatabase {
  DtcAssetDatabase._();
  static final DtcAssetDatabase instance = DtcAssetDatabase._();

  static const _assetPath = 'assets/dtc/generic_dtc.json.gz';
  Map<String, dynamic>? _codes;
  Future<void>? _loading;

  Future<void> ensureLoaded() => _loading ??= _load();

  Future<void> _load() async {
    final bytes = await rootBundle.load(_assetPath);
    final decodedBytes =  GZipCodec().decode(bytes.buffer.asUint8List());
    _codes = jsonDecode(utf8.decode(decodedBytes)) as Map<String, dynamic>;
  }

  Future<ObdDtcInfo?> find(String code) async {
    await ensureLoaded();
    final value = _codes?[code.trim().toUpperCase()];
    if (value is! Map) return null;

    final map = Map<String, dynamic>.from(value);
    final technicalTitle = map['t']?.toString().trim() ?? '';
    final technicalDescription = map['d']?.toString().trim() ?? '';
    final arabicTitle = map['ar_t']?.toString().trim() ?? '';
    final arabicDescription = map['ar_d']?.toString().trim() ?? '';
    final arabicSystem = map['ar_s']?.toString().trim() ?? '';
    final causes = (map['a'] as List?)?.map((e) => e.toString()).where((e) => e.isNotEmpty).toList() ?? const <String>[];

    return ObdDtcInfo(
      title: arabicTitle.isNotEmpty
          ? arabicTitle
          : (technicalTitle.isEmpty ? 'عطل OBD-II مسجل' : technicalTitle),
      description: arabicDescription.isNotEmpty
          ? arabicDescription
          : technicalDescription,
      system: arabicSystem.isNotEmpty
          ? arabicSystem
          : _systemName(map['c']?.toString()),
      possibleCauses: causes,
    );
  }

  String _systemName(String? category) => switch (category) {
        'powertrain' => 'المحرك والفتيس ونقل الحركة',
        'body' => 'جسم العربية وأنظمة الأمان والراحة',
        'chassis' => 'الشاسيه والفرامل والتوجيه',
        'network' => 'شبكة الاتصال بين كمبيوترات العربية',
        _ => 'نظام العربية',
      };
}
