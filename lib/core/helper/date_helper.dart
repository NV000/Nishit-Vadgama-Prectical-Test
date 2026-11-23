import 'package:intl/intl.dart';

class DateHelper {
  DateHelper._();

  static const String defaultPattern = 'dd MMM yyyy';

  static DateTime? parse(dynamic input) {
    if (input == null) return null;
    if (input is DateTime) return input;

    if (input is int) {
      if (input < 10000000000) {
        return DateTime.fromMillisecondsSinceEpoch(input * 1000);
      }
      return DateTime.fromMillisecondsSinceEpoch(input);
    }

    if (input is String) {
      final trimmed = input.trim();
      if (trimmed.isEmpty) return null;

      final intVal = int.tryParse(trimmed);
      if (intVal != null && trimmed.length >= 10) {
        return parse(intVal);
      }

      final isoParsed = DateTime.tryParse(trimmed);
      if (isoParsed != null) return isoParsed;

      final patterns = [
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-dd HH:mm:ss.SSS',
        'yyyy-MM-dd',
        'dd-MM-yyyy',
        'dd/MM/yyyy',
        'MM/dd/yyyy',
        'yyyy/MM/dd',
        'dd MMM yyyy',
      ];

      for (final pattern in patterns) {
        try {
          return DateFormat(pattern).parseLoose(trimmed);
        } catch (_) {
          continue;
        }
      }
    }

    return null;
  }

  static String format(
    dynamic input, {
    String pattern = defaultPattern,
    String fallback = '',
    String? locale,
  }) {
    if (input == null) return fallback;

    final dateTime = parse(input);
    if (dateTime == null) {
      if (input is String && input.trim().isNotEmpty) {
        return input;
      }
      return fallback;
    }

    try {
      return DateFormat(pattern, locale).format(dateTime);
    } catch (_) {
      return fallback;
    }
  }

  static String day(dynamic input, {String fallback = ''}) {
    return format(input, pattern: 'dd', fallback: fallback);
  }

  static String month(
    dynamic input, {
    String fallback = '',
    bool upperCase = true,
  }) {
    final m = format(input, pattern: 'MMM', fallback: fallback);
    return upperCase ? m.toUpperCase() : m;
  }

  static String year(dynamic input, {String fallback = ''}) {
    return format(input, pattern: 'yyyy', fallback: fallback);
  }
}

extension DateHelperExtension on DateTime {
  String toDisplayDate({String pattern = DateHelper.defaultPattern}) =>
      DateHelper.format(this, pattern: pattern);
}

extension DateStringHelperExtension on String {
  String toDisplayDate({String pattern = DateHelper.defaultPattern}) =>
      DateHelper.format(this, pattern: pattern);

  DateTime? toDateTime() => DateHelper.parse(this);
}
