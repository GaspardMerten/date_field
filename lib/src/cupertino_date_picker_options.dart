import 'package:flutter/cupertino.dart';

/// Options to customize the [CupertinoDatePicker].
@immutable
class CupertinoDatePickerOptions {
  const CupertinoDatePickerOptions({
    this.builder,
    this.useRootNavigator = true,
    this.minuteInterval = 1,
    this.showDayOfWeek = false,
    this.saveText,
    this.cancelText,
    this.modalTitleText,
  });

  /// The builder around the [CupertinoPageScaffold]. You can use
  /// it to override e.g. Localizations.
  final TransitionBuilder? builder;

  /// Whether to use the root navigator or not when pushing the dialog.
  ///
  /// Defaults to `true`.
  final bool useRootNavigator;

  /// See [CupertinoDatePicker.minuteInterval].
  final int minuteInterval;

  /// See [CupertinoDatePicker.showDayOfWeek].
  final bool showDayOfWeek;

  /// The text to display on the save button.
  ///
  /// Defaults to [MaterialLocalizations.saveButtonLabel].
  final String? saveText;

  /// The text to display on the cancel button.
  ///
  /// Defaults to [CupertinoLocalizations.modalBarrierDismissLabel].
  final String? cancelText;

  /// The text to display on the modal title.
  ///
  /// Defaults to [MaterialLocalizations.dateInputLabel].
  final String? modalTitleText;
}
