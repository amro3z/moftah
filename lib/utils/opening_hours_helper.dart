class OpeningHoursHelper {
  OpeningHoursHelper._();

  static bool? isOpenNow(String? openingHours, {DateTime? now}) {
    final value = openingHours?.trim();
    if (value == null || value.isEmpty) return null;

    if (value == '24/7') return true;

    final current = now ?? DateTime.now();
    final currentDay = _dayCode(current.weekday);
    final currentMinutes = current.hour * 60 + current.minute;

    try {
      final rules = value.split(';');
      var matchedKnownRule = false;

      for (final rawRule in rules) {
        final rule = rawRule.trim();
        if (rule.isEmpty) continue;

        if (rule.toLowerCase().endsWith(' off')) {
          final dayPart = rule.substring(0, rule.length - 4).trim();
          final days = _parseDays(dayPart);
          if (days == null) continue;
          matchedKnownRule = true;
          if (days.contains(currentDay)) return false;
          continue;
        }

        final firstSpace = rule.indexOf(' ');
        String dayPart;
        String timePart;

        if (firstSpace <= 0) {
          dayPart = 'Mo-Su';
          timePart = rule;
        } else {
          dayPart = rule.substring(0, firstSpace).trim();
          timePart = rule.substring(firstSpace + 1).trim();
        }

        final days = _parseDays(dayPart);
        if (days == null) continue;

        final ranges = timePart.split(',');
        var hasValidRange = false;

        for (final rawRange in ranges) {
          final range = rawRange.trim();
          final parts = range.split('-');
          if (parts.length != 2) continue;

          final start = _parseTime(parts[0]);
          final end = _parseTime(parts[1]);
          if (start == null || end == null) continue;

          hasValidRange = true;

          if (days.contains(currentDay) && _isInsideRange(currentMinutes, start, end)) {
            return true;
          }
        }

        if (hasValidRange) {
          matchedKnownRule = true;
        }
      }

      if (matchedKnownRule) return false;
      return null;
    } catch (_) {
      return null;
    }
  }

  static String displayText(String? openingHours) {
    final value = openingHours?.trim();
    if (value == null || value.isEmpty) return 'المواعيد غير متاحة';
    if (value == '24/7') return 'مفتوح 24 ساعة';
    return value;
  }

  static bool _isInsideRange(int now, int start, int end) {
    if (end >= start) {
      return now >= start && now < end;
    }
    return now >= start || now < end;
  }

  static int? _parseTime(String value) {
    final parts = value.trim().split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 24 || minute < 0 || minute > 59) return null;

    return hour * 60 + minute;
  }

  static Set<String>? _parseDays(String value) {
    final result = <String>{};

    for (final rawPart in value.split(',')) {
      final part = rawPart.trim();
      if (part.isEmpty) continue;

      if (part.contains('-')) {
        final bounds = part.split('-');
        if (bounds.length != 2) return null;

        final startIndex = _days.indexOf(bounds[0]);
        final endIndex = _days.indexOf(bounds[1]);
        if (startIndex == -1 || endIndex == -1) return null;

        if (startIndex <= endIndex) {
          result.addAll(_days.sublist(startIndex, endIndex + 1));
        } else {
          result.addAll(_days.sublist(startIndex));
          result.addAll(_days.sublist(0, endIndex + 1));
        }
      } else {
        if (!_days.contains(part)) return null;
        result.add(part);
      }
    }

    return result.isEmpty ? null : result;
  }

  static String _dayCode(int weekday) {
    return _days[weekday - 1];
  }

  static const List<String> _days = [
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];
}
