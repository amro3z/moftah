import 'package:flutter/material.dart';
import 'package:moftah/data/models/map/route_path_model.dart';

class NavigationInstructionHelper {
  NavigationInstructionHelper._();

  static String instruction(RouteNavigationStep step) {
    final road = step.roadName.trim();
    final roadSuffix = road.isEmpty ? '' : ' إلى $road';

    switch (step.type) {
      case 'arrive':
        return 'وصلت لوجهتك';
      case 'roundabout':
      case 'rotary':
        return 'ادخل الميدان واتبع المخرج المناسب$roadSuffix';
      case 'merge':
        return 'اندمج مع الطريق$roadSuffix';
      case 'fork':
        return _modifierText(step.modifier, prefix: 'خليك');
      case 'end of road':
        return _modifierText(step.modifier, prefix: 'في نهاية الطريق اتجه');
      case 'new name':
      case 'continue':
        return 'استمر مستقيم$roadSuffix';
      case 'turn':
        return _modifierText(step.modifier, roadSuffix: roadSuffix);
      default:
        return _modifierText(step.modifier, roadSuffix: roadSuffix);
    }
  }

  static IconData icon(RouteNavigationStep step) {
    if (step.type == 'arrive') return Icons.flag_rounded;
    if (step.type == 'roundabout' || step.type == 'rotary') {
      return Icons.sync_rounded;
    }

    switch (step.modifier) {
      case 'left':
      case 'sharp left':
      case 'slight left':
        return Icons.turn_left_rounded;
      case 'right':
      case 'sharp right':
      case 'slight right':
        return Icons.turn_right_rounded;
      case 'uturn':
        return Icons.u_turn_left_rounded;
      case 'straight':
      default:
        return Icons.straight_rounded;
    }
  }

  static String distanceText(double meters) {
    if (meters < 1000) {
      final rounded = (meters / 10).round() * 10;
      return 'بعد $rounded متر';
    }

    final km = meters / 1000;
    return 'بعد ${km.toStringAsFixed(km < 10 ? 1 : 0)} كم';
  }

  static String _modifierText(
    String? modifier, {
    String prefix = 'اتجه',
    String roadSuffix = '',
  }) {
    switch (modifier) {
      case 'sharp left':
        return '$prefix يسار حاد$roadSuffix';
      case 'slight left':
        return '$prefix يسار خفيف$roadSuffix';
      case 'left':
        return '$prefix يسار$roadSuffix';
      case 'sharp right':
        return '$prefix يمين حاد$roadSuffix';
      case 'slight right':
        return '$prefix يمين خفيف$roadSuffix';
      case 'right':
        return '$prefix يمين$roadSuffix';
      case 'uturn':
        return 'ارجع للخلف$roadSuffix';
      case 'straight':
      default:
        return 'استمر مستقيم$roadSuffix';
    }
  }
}
