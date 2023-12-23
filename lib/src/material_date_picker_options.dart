import 'package:flutter/material.dart';

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

  final DateTime? currentDate;
  final DatePickerEntryMode initialEntryMode;
  final SelectableDayPredicate? selectableDayPredicate;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final Locale? locale;
  final bool useRootNavigator;
  final TextDirection? textDirection;
  final TransitionBuilder? builder;
  final DatePickerMode initialDatePickerMode;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final TextInputType? keyboardType;
  final Icon? switchToInputEntryModeIcon;
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
