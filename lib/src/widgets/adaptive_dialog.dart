import 'package:date_field/src/constants.dart';
import 'package:date_field/src/models/cupertino_date_picker_options.dart';
import 'package:date_field/src/models/material_date_picker_options.dart';
import 'package:date_field/src/models/material_time_picker_options.dart';
import 'package:date_field/src/widgets/cupertino_date_picker.dart';
import 'package:date_field/src/widgets/field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A function that returns the initial date to be displayed by the picker.
/// If [initialPickerDateTime] is not provided, the function returns the current
/// date if it is within the selectable date range. Otherwise, it returns the
/// [firstDate] or [lastDate] depending on the current date.
DateTime _getInitialDate(
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

/// A function that compares two [TimeOfDay] objects, should be
/// replaced by the [TimeOfDay.compareTo] method when available in more
/// stable Flutter versions.
int _compareTimeOfDayTo(TimeOfDay current, TimeOfDay other) {
  final int hourComparison = current.hour.compareTo(other.hour);
  if (hourComparison == 0) {
    return current.minute.compareTo(other.minute);
  } else {
    return hourComparison;
  }
}

/// A function that returns the initial time to be displayed by the picker.
/// If [initialPickerDateTime] is not provided, the function returns the current
/// time if it is within the selectable time range. Otherwise, it returns the
/// [firstDate] or [lastDate] depending on the current time.
DateTime _getInitialTime(
    DateTime? initialPickerDateTime, DateTime firstDate, DateTime lastDate) {
  if (initialPickerDateTime != null) {
    return initialPickerDateTime;
  }

  final TimeOfDay now = TimeOfDay.now();

  if (_compareTimeOfDayTo(now, TimeOfDay.fromDateTime(firstDate)) < 0) {
    return firstDate;
  }

  if (_compareTimeOfDayTo(now, TimeOfDay.fromDateTime(lastDate)) > 0) {
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

/// A function that returns a boolean value to determine if the 24-hour format
/// should be used based on the current locale.
///
/// If the current platform is iOS or Android, the function returns the value
/// of [MediaQueryData.alwaysUse24HourFormat].
bool detect24HourFormat(BuildContext context) {
  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android) {
    return MediaQuery.of(context).alwaysUse24HourFormat;
  }

  final DateFormat formatter = DateFormat.jm(
    Localizations.localeOf(context).toString(),
  );

  final DateTime now = DateTime.parse('2000-01-01 17:00:00');
  final String formattedTime = formatter.format(now);

  return !formattedTime.contains('PM');
}

/// Displays an adaptive date and time picker based on the current platform.
///
/// On iOS and macOS, it shows a Cupertino-style picker. On other platforms,
/// it shows a Material-style picker.
///
/// The [context] parameter is required to provide the necessary context for
/// the picker. The [mode] parameter specifies whether to show a date, time,
/// or both date and time picker. The [initialPickerDateTime] parameter sets
/// the initial date and time to be displayed by the picker.
///
/// The [pickerPlatform] parameter allows overriding the platform detection to
/// force a specific style of picker. If [pickerPlatform] is not specified,
/// the platform is inferred from the current theme's platform.
///
/// The [firstDate] and [lastDate] parameters set the selectable date range
/// for the picker. If not provided, defaults are used.
///
/// The [cupertinoDatePickerOptions] parameter allows customization of the
/// Cupertino date picker. The  [materialDatePickerOptions] and
/// [materialTimePickerOptions] parameters allow customization of the Material
/// date and time pickers respectively.
///
/// Returns a `Future<DateTime?>` that completes with the selected date and time
/// or null if the user cancels the picker.
///
/// ```dart
/// final DateTime? selectedDateTime = await showAdaptiveDateTimePicker(
///  context,
///  mode: DateTimeFieldPickerMode.dateAndTime,
///  initialPickerDateTime: DateTime.now(),
///  firstDate: DateTime(2011),
///  lastDate: DateTime(2125),
/// );
/// ```
Future<DateTime?> showAdaptiveDateTimePicker({
  required BuildContext context,
  required DateTimeFieldPickerMode mode,
  DateTimeFieldPickerPlatform? pickerPlatform,
  DateTime? initialPickerDateTime,
  DateTime? firstDate,
  DateTime? lastDate,
  CupertinoDatePickerOptions cupertinoDatePickerOptions =
      const CupertinoDatePickerOptions(),
  MaterialDatePickerOptions materialDatePickerOptions =
      const MaterialDatePickerOptions(),
  MaterialTimePickerOptions materialTimePickerOptions =
      const MaterialTimePickerOptions(),
}) async {
  final TargetPlatform platform =
      pickerPlatform?.toTargetPlatform(context) ?? Theme.of(context).platform;

  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return showCupertinoDateTimePicker(
      context: context,
      mode: mode,
      initialPickerDateTime: initialPickerDateTime,
      firstDate: firstDate ?? kDefaultFirstSelectableDate,
      lastDate: lastDate ?? kDefaultLastSelectableDate,
      cupertinoDatePickerOptions: cupertinoDatePickerOptions,
    );
  }

  return showMaterialDateTimePicker(
    context: context,
    mode: mode,
    initialPickerDateTime: initialPickerDateTime,
    firstDate: firstDate,
    lastDate: lastDate,
    materialDatePickerOptions: materialDatePickerOptions,
    materialTimePickerOptions: materialTimePickerOptions,
  );
}

/// Displays a Material-style date and time picker in a modal popup.
/// The [context] parameter is required to provide the necessary context for
/// the picker. The [mode] parameter specifies whether to show a date, time,
/// or both date and time picker. The [initialPickerDateTime] parameter sets
/// the initial date and time to be displayed by the picker.
///
/// The [firstDate] and [lastDate] parameters set the selectable date range
/// for the picker. If not provided, defaults are used.
///
/// The [materialDatePickerOptions] and [materialTimePickerOptions] parameters
/// allow customization of the Material date and time pickers respectively.
///
/// ```dart
/// final DateTime? selectedDateTime = await showMaterialDateTimePicker(
///   context,
///   mode: DateTimeFieldPickerMode.dateAndTime,
///   initialPickerDateTime: DateTime.now(),
///   firstDate: DateTime(2011),
///   lastDate: DateTime(2125),
/// );
Future<DateTime?> showMaterialDateTimePicker({
  required BuildContext context,
  required DateTimeFieldPickerMode mode,
  DateTime? initialPickerDateTime,
  DateTime? firstDate,
  DateTime? lastDate,
  MaterialDatePickerOptions materialDatePickerOptions =
      const MaterialDatePickerOptions(),
  MaterialTimePickerOptions materialTimePickerOptions =
      const MaterialTimePickerOptions(),
}) async {
  DateTime? selectedDateTime = initialPickerDateTime ?? DateTime.now();

  if (mode != DateTimeFieldPickerMode.time) {
    selectedDateTime = _getInitialDate(
      initialPickerDateTime,
      firstDate ?? kDefaultFirstSelectableDate,
      lastDate ?? kDefaultLastSelectableDate,
    );

    final DateTime? newDate = await _showMaterialDatePicker(
      context: context,
      initialPickerDateTime: selectedDateTime,
      firstDate: firstDate ?? kDefaultFirstSelectableDate,
      lastDate: lastDate ?? kDefaultLastSelectableDate,
      materialDatePickerOptions: materialDatePickerOptions,
    );

    if (newDate == null) {
      return null;
    }

    selectedDateTime = newDate;
  }

  if (mode != DateTimeFieldPickerMode.date) {
    final TimeOfDay? selectedTime = await _showMaterialTimePicker(
      context: context,
      initialPickerDateTime: _getInitialTime(
        initialPickerDateTime,
        firstDate ?? kDefaultFirstSelectableDate,
        lastDate ?? kDefaultLastSelectableDate,
      ),
      materialTimePickerOptions: materialTimePickerOptions,
    );

    if (selectedTime == null) {
      return null;
    }

    selectedDateTime = DateTime(
      selectedDateTime.year,
      selectedDateTime.month,
      selectedDateTime.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }

  return selectedDateTime;
}

Future<TimeOfDay?> _showMaterialTimePicker({
  required BuildContext context,
  required DateTime initialPickerDateTime,
  required MaterialTimePickerOptions materialTimePickerOptions,
}) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialPickerDateTime),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          alwaysUse24HourFormat: detect24HourFormat(context),
        ),
        child: materialTimePickerOptions.builder?.call(
              context,
              child,
            ) ??
            child!,
      );
    },
    initialEntryMode: materialTimePickerOptions.initialEntryMode,
    useRootNavigator: materialTimePickerOptions.useRootNavigator,
    helpText: materialTimePickerOptions.helpText,
    errorInvalidText: materialTimePickerOptions.errorInvalidText,
    cancelText: materialTimePickerOptions.cancelText,
    confirmText: materialTimePickerOptions.confirmText,
    hourLabelText: materialTimePickerOptions.hourLabelText,
    minuteLabelText: materialTimePickerOptions.minuteLabelText,
    orientation: materialTimePickerOptions.orientation,
  );
}

Future<DateTime?> _showMaterialDatePicker({
  required BuildContext context,
  required DateTime initialPickerDateTime,
  required DateTime firstDate,
  required DateTime lastDate,
  required MaterialDatePickerOptions materialDatePickerOptions,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialPickerDateTime,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          alwaysUse24HourFormat: detect24HourFormat(context),
        ),
        child:
            materialDatePickerOptions.builder?.call(context, child) ?? child!,
      );
    },
    initialDatePickerMode: materialDatePickerOptions.initialDatePickerMode,
    initialEntryMode: materialDatePickerOptions.initialEntryMode,
    currentDate: materialDatePickerOptions.currentDate,
    locale: materialDatePickerOptions.locale,
    cancelText: materialDatePickerOptions.cancelText,
    confirmText: materialDatePickerOptions.confirmText,
    errorFormatText: materialDatePickerOptions.errorFormatText,
    errorInvalidText: materialDatePickerOptions.errorInvalidText,
    fieldHintText: materialDatePickerOptions.fieldHintText,
    fieldLabelText: materialDatePickerOptions.fieldLabelText,
    helpText: materialDatePickerOptions.helpText,
    keyboardType: materialDatePickerOptions.keyboardType,
    selectableDayPredicate: materialDatePickerOptions.selectableDayPredicate,
    switchToCalendarEntryModeIcon:
        materialDatePickerOptions.switchToCalendarEntryModeIcon,
    switchToInputEntryModeIcon:
        materialDatePickerOptions.switchToInputEntryModeIcon,
    textDirection: materialDatePickerOptions.textDirection,
    useRootNavigator: materialDatePickerOptions.useRootNavigator,
  );
}

/// Displays a Cupertino-style date and time picker in a modal popup.
///
/// The [context] parameter is required to provide the necessary context for
/// the picker. The [mode] parameter specifies whether to show a date, time,
/// or both date and time picker. The [initialPickerDateTime] parameter sets
/// the initial date and time to be displayed by the picker.
///
/// The [firstDate] and [lastDate] parameters set the selectable date range
/// for the picker. If not provided, defaults are used.
///
/// The [cupertinoDatePickerOptions] parameter allows customization of the
/// Cupertino date picker.
///
/// ```dart
/// final DateTime? selectedDateTime = await showCupertinoDateTimePicker(
///  context,
///  mode: DateTimeFieldPickerMode.dateAndTime,
///  initialPickerDateTime: DateTime.now(),
///  firstDate: DateTime(2011),
///  lastDate: DateTime(2125),
///  cupertinoDatePickerOptions: CupertinoDatePickerOptions(
///  minuteInterval: 2,
///  ),
///  );
Future<DateTime?> showCupertinoDateTimePicker({
  required BuildContext context,
  required DateTimeFieldPickerMode mode,
  DateTime? initialPickerDateTime,
  DateTime? firstDate,
  DateTime? lastDate,
  CupertinoDatePickerOptions cupertinoDatePickerOptions =
      const CupertinoDatePickerOptions(),
}) async {
  return showCupertinoModalPopup<DateTime?>(
    useRootNavigator: cupertinoDatePickerOptions.useRootNavigator,
    context: context,
    builder: (BuildContext context) {
      final DateTime dateTime;

      if (mode == DateTimeFieldPickerMode.time) {
        dateTime = _getInitialTime(
          initialPickerDateTime,
          firstDate ?? kDefaultFirstSelectableDate,
          lastDate ?? kDefaultLastSelectableDate,
        );
      } else {
        dateTime = _getInitialDate(
          initialPickerDateTime,
          firstDate ?? kDefaultFirstSelectableDate,
          lastDate ?? kDefaultLastSelectableDate,
        );
      }

      return CupertinoDatePickerModalSheet(
        initialPickerDateTime: dateTime,
        options: cupertinoDatePickerOptions,
        use24hFormat: detect24HourFormat(context),
        firstDate: firstDate ?? kDefaultFirstSelectableDate,
        lastDate: lastDate ?? kDefaultLastSelectableDate,
        mode: mode,
      );
    },
  );
}
