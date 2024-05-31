import 'package:date_field/src/models/cupertino_date_picker_options.dart';
import 'package:date_field/src/models/material_date_picker_options.dart';
import 'package:date_field/src/models/material_time_picker_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'cupertino_date_picker.dart';
import 'field.dart';

/// Shows an adaptive date and/or time picker dialog.
///
/// The dialog will be adaptive to the platform and will show a Cupertino or
/// Material date and/or time picker.
///
/// The [mode] parameter can be used to show only a date picker, only a time
/// picker, or both.
///
/// The [pickerPlatform] parameter can be used to force the platform to show a
/// Cupertino or Material picker.
///
/// The [initialPickerDateTime] parameter is the initial date and time that will
/// be shown in the picker.
///
/// The [firstDate] and [lastDate] parameters are used to set the range of
/// selectable dates.
///
/// The [cupertinoDatePickerOptions] parameter can be used to customize the
/// Cupertino date picker.
///
/// The [materialDatePickerOptions] parameter can be used to customize the
/// Material date picker.
///
/// The [materialTimePickerOptions] parameter can be used to customize the
/// Material time picker.
Future<DateTime?> showAdaptiveDateTimePickerDialog(
  BuildContext context, {
  required DateTimeFieldPickerMode mode,
  DateTimeFieldPickerPlatform? pickerPlatform,
  required DateTime initialPickerDateTime,
  DateTime? firstDate,
  DateTime? lastDate,
  CupertinoDatePickerOptions cupertinoDatePickerOptions =
      const CupertinoDatePickerOptions(),
  MaterialDatePickerOptions materialDatePickerOptions =
      const MaterialDatePickerOptions(),
  MaterialTimePickerOptions materialTimePickerOptions =
      const MaterialTimePickerOptions(),
}) async {
  DateTime? selectedDateTime = initialPickerDateTime;
  final TargetPlatform platform =
      pickerPlatform?.toTargetPlatform(context) ?? Theme.of(context).platform;

  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    selectedDateTime = await _showCupertinoPicker(
      context: context,
      mode: mode,
      initialPickerDateTime: initialPickerDateTime,
      firstDate: firstDate ?? kDefaultFirstSelectableDate,
      lastDate: lastDate ?? kDefaultLastSelectableDate,
      cupertinoDatePickerOptions: cupertinoDatePickerOptions,
    );
  } else {
    if (mode == DateTimeFieldPickerMode.dateAndTime ||
        mode == DateTimeFieldPickerMode.date) {
      final DateTime? newDate = await showMaterialDatePicker(
        context: context,
        initialPickerDateTime: initialPickerDateTime,
        firstDate: firstDate ?? kDefaultFirstSelectableDate,
        lastDate: lastDate ?? kDefaultLastSelectableDate,
        materialDatePickerOptions: materialDatePickerOptions,
      );
      if (newDate != null) {
        selectedDateTime = newDate;
      }
    }
    if (mode == DateTimeFieldPickerMode.dateAndTime ||
        mode == DateTimeFieldPickerMode.time) {
      final TimeOfDay? selectedTime = await showMaterialTimePicker(
        context: context,
        initialPickerDateTime: initialPickerDateTime,
        materialTimePickerOptions: materialTimePickerOptions,
      );
      if (selectedTime != null) {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }
  }
  return selectedDateTime;
}

Future<TimeOfDay?> showMaterialTimePicker({
  required BuildContext context,
  required DateTime initialPickerDateTime,
  required MaterialTimePickerOptions materialTimePickerOptions,
}) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialPickerDateTime),
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child:
            materialTimePickerOptions.builder?.call(context, child) ?? child!,
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

Future<DateTime?> showMaterialDatePicker({
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
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
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

Future<DateTime?> _showCupertinoPicker({
  required BuildContext context,
  required DateTimeFieldPickerMode mode,
  required DateTime initialPickerDateTime,
  required DateTime firstDate,
  required DateTime lastDate,
  required CupertinoDatePickerOptions cupertinoDatePickerOptions,
}) async {
  return showCupertinoModalPopup<DateTime?>(
    useRootNavigator: cupertinoDatePickerOptions.useRootNavigator,
    context: context,
    builder: (BuildContext context) {
      return CupertinoDatePickerModalSheet(
        initialPickerDateTime: initialPickerDateTime,
        options: cupertinoDatePickerOptions,
        use24hFormat: true,
        firstDate: firstDate,
        lastDate: lastDate,
        mode: mode,
      );
    },
  );
}
