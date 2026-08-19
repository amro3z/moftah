import 'package:moftah/data/dtc/body_dtc.dart';
import 'package:moftah/data/dtc/chassis_dtc.dart';
import 'package:moftah/data/dtc/dtc_info.dart';
import 'package:moftah/data/dtc/network_dtc.dart';
import 'package:moftah/data/dtc/powertrain_dtc.dart';

class DtcCatalog {
  static ObdDtcInfo? find(String code) {
    final normalized = code.trim().toUpperCase();
    if (normalized.isEmpty) return null;
    return switch (normalized[0]) {
      'P' => powertrainDtc[normalized],
      'B' => bodyDtc[normalized],
      'C' => chassisDtc[normalized],
      'U' => networkDtc[normalized],
      _ => null,
    };
  }
}
