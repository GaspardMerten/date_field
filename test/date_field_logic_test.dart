import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// If private functions are in the same file as tested code, you can't directly import them.
// For testing, consider moving these helper functions into a separate file or removing the underscore.
// Here, we replicate the logic of the private functions for demonstration.
// In a real scenario, you might adjust the code to make them accessible, or place tests in the same file.

DateTime testGetInitialDate(
    DateTime? initialPickerDateTime, DateTime firstDate, DateTime lastDate) {
  if (initialPickerDateTime != null) {
    return initialPickerDateTime;
  }

  final DateTime now = DateTime.now();

  if (now.isBefore(firstDate)) {
    return firstDate;
  }

  if (now.isAfter(lastDate)) {
    return lastDate;
  }

  return now;
}

int testCompareTimeOfDayTo(TimeOfDay current, TimeOfDay other) {
  final int hourComparison = current.hour.compareTo(other.hour);
  if (hourComparison == 0) {
    return current.minute.compareTo(other.minute);
  } else {
    return hourComparison;
  }
}

DateTime testGetInitialTime(
    DateTime? initialPickerDateTime, DateTime firstDate, DateTime lastDate) {
  if (initialPickerDateTime != null) {
    return initialPickerDateTime;
  }

  final TimeOfDay now = TimeOfDay.now();

  int compareFirst =
      testCompareTimeOfDayTo(now, TimeOfDay.fromDateTime(firstDate));
  if (compareFirst < 0) {
    return firstDate;
  }

  int compareLast =
      testCompareTimeOfDayTo(now, TimeOfDay.fromDateTime(lastDate));
  if (compareLast > 0) {
    return lastDate;
  }

  return DateTime(
    firstDate.year,
    firstDate.month,
    firstDate.day,
    now.hour,
    now.minute,
  );
}

void main() {
  group('Helper functions', () {
    test('testGetInitialDate returns initialPickerDateTime if provided', () {
      final DateTime initial = DateTime(2022, 1, 1);
      final DateTime result = testGetInitialDate(
        initial,
        DateTime(2021, 1, 1),
        DateTime(2023, 1, 1),
      );
      expect(result, equals(initial));
    });

    test('testGetInitialDate returns firstDate if now is before firstDate', () {
      final DateTime firstDate = DateTime.now().add(Duration(days: 1));
      final DateTime lastDate = DateTime.now().add(Duration(days: 10));
      final DateTime result = testGetInitialDate(null, firstDate, lastDate);
      expect(result, equals(firstDate));
    });

    test('testGetInitialDate returns lastDate if now is after lastDate', () {
      final DateTime firstDate = DateTime.now().subtract(Duration(days: 10));
      final DateTime lastDate = DateTime.now().subtract(Duration(days: 1));
      final DateTime result = testGetInitialDate(null, firstDate, lastDate);
      expect(result, equals(lastDate));
    });

    test('testGetInitialDate returns now if within range', () {
      final DateTime firstDate = DateTime.now().subtract(Duration(days: 10));
      final DateTime lastDate = DateTime.now().add(Duration(days: 10));
      final DateTime result = testGetInitialDate(null, firstDate, lastDate);
      // result should be close to now
      final DateTime now = DateTime.now();
      expect(
        result.isAfter(now.subtract(Duration(minutes: 1))) &&
            result.isBefore(now.add(Duration(minutes: 1))),
        isTrue,
      );
    });

    test('testCompareTimeOfDayTo returns 0 if times are equal', () {
      final TimeOfDay t1 = TimeOfDay(hour: 10, minute: 30);
      final TimeOfDay t2 = TimeOfDay(hour: 10, minute: 30);
      expect(testCompareTimeOfDayTo(t1, t2), 0);
    });

    test('testCompareTimeOfDayTo returns negative if current is before other',
        () {
      final TimeOfDay t1 = TimeOfDay(hour: 9, minute: 30);
      final TimeOfDay t2 = TimeOfDay(hour: 10, minute: 00);
      expect(testCompareTimeOfDayTo(t1, t2) < 0, isTrue);
    });

    test('testCompareTimeOfDayTo returns positive if current is after other',
        () {
      final TimeOfDay t1 = TimeOfDay(hour: 11, minute: 00);
      final TimeOfDay t2 = TimeOfDay(hour: 10, minute: 30);
      expect(testCompareTimeOfDayTo(t1, t2) > 0, isTrue);
    });

    test('testGetInitialTime returns initialPickerDateTime if provided', () {
      final DateTime initial = DateTime(2022, 3, 3, 15, 0);
      final DateTime result = testGetInitialTime(
        initial,
        DateTime(2022, 3, 3, 10, 0),
        DateTime(2022, 3, 3, 20, 0),
      );
      expect(result, equals(initial));
    });

    test('testGetInitialTime returns firstDate if now is before firstDate time',
        () {
      final TimeOfDay now = TimeOfDay.now();
      // make firstDate one hour after now, ensuring now < firstDate
      final DateTime firstDate = DateTime(2022, 3, 3, now.hour + 1, now.minute);
      final DateTime lastDate = DateTime(2022, 3, 3, now.hour + 5, now.minute);

      final DateTime result = testGetInitialTime(null, firstDate, lastDate);
      expect(result, equals(firstDate));
    });

    test('testGetInitialTime returns lastDate if now is after lastDate time',
        () {
      final TimeOfDay now = TimeOfDay.now();
      // make lastDate one hour before now, ensuring now > lastDate
      final DateTime lastDate = DateTime(2022, 3, 3, now.hour - 1, now.minute);
      final DateTime firstDate = DateTime(2022, 3, 3, now.hour - 5, now.minute);

      final DateTime result = testGetInitialTime(null, firstDate, lastDate);
      expect(result, equals(lastDate));
    });

    test('testGetInitialTime returns current time within range', () {
      final TimeOfDay now = TimeOfDay.now();
      final DateTime firstDate = DateTime(2022, 3, 3, now.hour - 1, now.minute);
      final DateTime lastDate = DateTime(2022, 3, 3, now.hour + 1, now.minute);

      final DateTime result = testGetInitialTime(null, firstDate, lastDate);

      expect(result.year, equals(firstDate.year));
      expect(result.month, equals(firstDate.month));
      expect(result.day, equals(firstDate.day));
      expect(result.hour, equals(now.hour));
      expect(result.minute, equals(now.minute));
    });
  });
}
