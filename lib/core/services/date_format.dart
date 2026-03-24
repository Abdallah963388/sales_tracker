import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatToTime(String? dateTimeString, String locale) {
  if (dateTimeString == null || dateTimeString.isEmpty) {
    return '--';
  }

  try {
    final dt = DateTime.parse(dateTimeString);

    final formatted = DateFormat('hh:mm', locale).format(dt);

    return formatted;
  } catch (_) {
    return '--';
  }
}

String formatToDate(String? dateTimeString, String locale) {
  if (dateTimeString == null || dateTimeString.isEmpty) {
    return '--';
  }

  try {
    final dt = DateTime.parse(dateTimeString);

    final formatted = DateFormat('dd-MM-yyyy', locale).format(dt);

    return formatted;
  } catch (_) {
    return '--';
  }
}

String formatToDateTime(String? dateTimeString, String locale) {
  if (dateTimeString == null || dateTimeString.isEmpty) {
    return '--';
  }

  try {
    final dt = DateTime.parse(dateTimeString);

    final formatted = DateFormat(
      'hh:mm a, dd-MM-yyyy ',
      locale,
    ).format(dt);

    return formatted;
  } catch (_) {
    return '--';
  }
}

String formatDatePicker(DateTime? date, String locale) {
  return date != null ? DateFormat('yyyy-MM-dd', locale).format(date) : '';
}

String formatTimePicker(TimeOfDay? date, String locale) {
  return date != null
      ? DateFormat(
          'hh:mm a',
          locale,
        ).format(DateTime(0, 1, 1, date.hour, date.minute))
      : '';
}

String getGreetingWithEmoji(BuildContext context) {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return '${'صباح الخير'} 🌞';
  } else {
    return '${'مساء الخير'} 🌙';
  }
}

String formattedDate(String locale) {
  return DateFormat('EEEE, d MMM y', locale).format(DateTime.now());
}

String convert24To12({required String start, required String locale}) {
  if (start.trim().isEmpty || start.contains('--')) {
    return '-- : --';
  }
  final time = DateFormat('HH:mm a').parse(start);

  final formatter = DateFormat('h:mm a', locale);

  return formatter.format(time);
}

String format12WithLocale({required String time12, required String locale}) {
  if (time12.trim().isEmpty || time12.contains('--')) {
    return '-- : --';
  }

  try {
    final time = DateFormat('hh:mm a', 'en').parse(time12);
    return DateFormat('h:mm a', locale).format(time);
  } catch (_) {
    return time12; // fallback آمن
  }
}
