import 'package:flutter/material.dart';

/// Options to configure the [TimePickerDialog].
@immutable
class MaterialTimePickerOptions {
  const MaterialTimePickerOptions({
    this.builder,
    this.useRootNavigator = true,
    this.initialEntryMode = TimePickerEntryMode.dial,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.orientation,
  });

  /// See parameter `builder` in [showTimePicker].
  final TransitionBuilder? builder;

  /// See parameter `useRootNavigator` in [showTimePicker].
  ///
  /// Defaults to `true`.
  final bool useRootNavigator;

  /// See [TimePickerDialog.initialEntryMode].
  ///
  /// Defaults to [TimePickerEntryMode.dial].
  final TimePickerEntryMode initialEntryMode;

  /// See [TimePickerDialog.cancelText].
  final String? cancelText;

  /// See [TimePickerDialog.confirmText].
  final String? confirmText;

  /// See [TimePickerDialog.helpText].
  final String? helpText;

  /// See [TimePickerDialog.errorInvalidText].
  final String? errorInvalidText;

  /// See [TimePickerDialog.hourLabelText].
  final String? hourLabelText;

  /// See [TimePickerDialog.minuteLabelText].
  final String? minuteLabelText;

  /// See [TimePickerDialog.orientation].
  final Orientation? orientation;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialTimePickerOptions &&
          runtimeType == other.runtimeType &&
          builder == other.builder &&
          useRootNavigator == other.useRootNavigator &&
          initialEntryMode == other.initialEntryMode &&
          cancelText == other.cancelText &&
          confirmText == other.confirmText &&
          helpText == other.helpText &&
          errorInvalidText == other.errorInvalidText &&
          hourLabelText == other.hourLabelText &&
          minuteLabelText == other.minuteLabelText &&
          orientation == other.orientation;

  @override
  int get hashCode =>
      builder.hashCode ^
      useRootNavigator.hashCode ^
      initialEntryMode.hashCode ^
      cancelText.hashCode ^
      confirmText.hashCode ^
      helpText.hashCode ^
      errorInvalidText.hashCode ^
      hourLabelText.hashCode ^
      minuteLabelText.hashCode ^
      orientation.hashCode;
}
