import 'package:flutter/material.dart';

/// Options to configure the [DatePickerDialog].
@immutable
class MaterialDatePickerOptions {
  const MaterialDatePickerOptions({
    this.currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.selectableDayPredicate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.locale,
    this.useRootNavigator = true,
    this.textDirection,
    this.builder,
    this.initialDatePickerMode = DatePickerMode.day,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.keyboardType,
    this.switchToInputEntryModeIcon,
    this.switchToCalendarEntryModeIcon,
  });

  /// See [DatePickerDialog.currentDate].
  final DateTime? currentDate;

  /// See [DatePickerDialog.initialEntryMode].
  ///
  /// Defaults to [DatePickerEntryMode.calendar].
  final DatePickerEntryMode initialEntryMode;

  /// See [DatePickerDialog.selectableDayPredicate].
  final SelectableDayPredicate? selectableDayPredicate;

  /// See [DatePickerDialog.helpText].
  final String? helpText;

  /// See [DatePickerDialog.cancelText].
  final String? cancelText;

  /// See [DatePickerDialog.confirmText].
  final String? confirmText;

  /// See parameter `locale` in [showDatePicker].
  final Locale? locale;

  /// See parameter `useRootNavigator` in [showDatePicker].
  ///
  /// Defaults to `true`.
  final bool useRootNavigator;

  /// See parameter `textDirection` in [showDatePicker].
  final TextDirection? textDirection;

  /// See parameter `builder` in [showDatePicker].
  final TransitionBuilder? builder;

  /// See [DatePickerDialog.initialCalendarMode].
  final DatePickerMode initialDatePickerMode;

  /// See [DatePickerDialog.errorFormatText].
  final String? errorFormatText;

  /// See [DatePickerDialog.errorInvalidText].
  final String? errorInvalidText;

  /// See [DatePickerDialog.fieldHintText].
  final String? fieldHintText;

  /// See [DatePickerDialog.fieldLabelText].
  final String? fieldLabelText;

  /// See [DatePickerDialog.keyboardType].
  final TextInputType? keyboardType;

  /// See [DatePickerDialog.switchToInputEntryModeIcon].
  final Icon? switchToInputEntryModeIcon;

  /// See [DatePickerDialog.switchToCalendarEntryModeIcon].
  final Icon? switchToCalendarEntryModeIcon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialDatePickerOptions &&
          runtimeType == other.runtimeType &&
          currentDate == other.currentDate &&
          initialEntryMode == other.initialEntryMode &&
          selectableDayPredicate == other.selectableDayPredicate &&
          helpText == other.helpText &&
          cancelText == other.cancelText &&
          confirmText == other.confirmText &&
          locale == other.locale &&
          useRootNavigator == other.useRootNavigator &&
          textDirection == other.textDirection &&
          builder == other.builder &&
          initialDatePickerMode == other.initialDatePickerMode &&
          errorFormatText == other.errorFormatText &&
          errorInvalidText == other.errorInvalidText &&
          fieldHintText == other.fieldHintText &&
          fieldLabelText == other.fieldLabelText &&
          keyboardType == other.keyboardType &&
          switchToInputEntryModeIcon == other.switchToInputEntryModeIcon &&
          switchToCalendarEntryModeIcon == other.switchToCalendarEntryModeIcon;

  @override
  int get hashCode =>
      currentDate.hashCode ^
      initialEntryMode.hashCode ^
      selectableDayPredicate.hashCode ^
      helpText.hashCode ^
      cancelText.hashCode ^
      confirmText.hashCode ^
      locale.hashCode ^
      useRootNavigator.hashCode ^
      textDirection.hashCode ^
      builder.hashCode ^
      initialDatePickerMode.hashCode ^
      errorFormatText.hashCode ^
      errorInvalidText.hashCode ^
      fieldHintText.hashCode ^
      fieldLabelText.hashCode ^
      keyboardType.hashCode ^
      switchToInputEntryModeIcon.hashCode ^
      switchToCalendarEntryModeIcon.hashCode;
}
