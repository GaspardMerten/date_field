import 'package:flutter/cupertino.dart';

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

  final bool useRootNavigator;

  final int minuteInterval;

  final bool showDayOfWeek;

  final String? saveText;

  final String? cancelText;

  final String? modalTitleText;
}
