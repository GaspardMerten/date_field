import 'package:flutter/material.dart';

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

  final TransitionBuilder? builder;
  final bool useRootNavigator;
  final TimePickerEntryMode initialEntryMode;
  final String? cancelText;
  final String? confirmText;
  final String? helpText;
  final String? errorInvalidText;
  final String? hourLabelText;
  final String? minuteLabelText;
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
