import 'dart:math' as math;

import 'package:date_field/src/constants.dart';
import 'package:date_field/src/models/cupertino_date_picker_options.dart';
import 'package:date_field/src/models/material_date_picker_options.dart';
import 'package:date_field/src/models/material_time_picker_options.dart';
import 'package:date_field/src/widgets/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'form_field.dart';

const double _kDenseButtonHeight = 24.0;

/// The mode of the [DateTimeField].
///
/// Depending on the mode and pickerPlatform, [DateTimeField] will show:
/// A [CupertinoDatePicker] with the according [CupertinoDatePickerMode],
/// or a [MaterialDatePicker], or a [MaterialTimePicker], or both.
enum DateTimeFieldPickerMode {
  time,
  date,
  dateAndTime;

  DateFormat toDateFormat() => switch (this) {
        DateTimeFieldPickerMode.time => DateFormat.jm(),
        DateTimeFieldPickerMode.date => DateFormat.yMMMMd(),
        DateTimeFieldPickerMode.dateAndTime => DateFormat.yMd().add_jm(),
      };

  CupertinoDatePickerMode toCupertinoDatePickerMode() => switch (this) {
        DateTimeFieldPickerMode.time => CupertinoDatePickerMode.time,
        DateTimeFieldPickerMode.date => CupertinoDatePickerMode.date,
        DateTimeFieldPickerMode.dateAndTime =>
          CupertinoDatePickerMode.dateAndTime,
      };
}

/// The platform to use for the pickers.
enum DateTimeFieldPickerPlatform {
  material,
  cupertino,
  adaptive;

  TargetPlatform toTargetPlatform(BuildContext context) => switch (this) {
        DateTimeFieldPickerPlatform.material => TargetPlatform.android,
        DateTimeFieldPickerPlatform.cupertino => TargetPlatform.iOS,
        DateTimeFieldPickerPlatform.adaptive => Theme.of(context).platform,
      };
}

/// [DateTimeField]
///
/// Shows an [_InputDropdown] that'll trigger [DateTimeField._handleTap] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateTimeField extends StatefulWidget {
  DateTimeField({
    this.onChanged,
    super.key,
    this.value,
    this.onTap,
    this.enabled,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.padding,
    this.hideDefaultSuffixIcon = false,
    this.decoration,
    this.initialPickerDateTime,
    this.cupertinoDatePickerOptions = const CupertinoDatePickerOptions(),
    this.materialDatePickerOptions = const MaterialDatePickerOptions(),
    this.materialTimePickerOptions = const MaterialTimePickerOptions(),
    this.mode = DateTimeFieldPickerMode.dateAndTime,
    this.pickerPlatform = DateTimeFieldPickerPlatform.adaptive,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
  })  : dateFormat = dateFormat ?? mode.toDateFormat(),
        firstDate = firstDate ?? kDefaultFirstSelectableDate,
        lastDate = lastDate ?? kDefaultLastSelectableDate;


  factory DateTimeField.time({
    Key? key,
    required ValueChanged<DateTime?>? onChanged,
    DateTime? value,
    bool? enabled,
    InputDecoration? decoration,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialPickerDateTime,
    TextStyle? style,
    CupertinoDatePickerOptions cupertinoDatePickerOptions =
        const CupertinoDatePickerOptions(),
    MaterialTimePickerOptions materialTimePickerOptions =
        const MaterialTimePickerOptions(),
    bool autofocus = false,
    DateFormat? dateFormat,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    FocusNode? focusNode,
    bool hideDefaultSuffixIcon = false,
    bool? enableFeedback,
    DateTimeFieldPickerPlatform pickerPlatform =
        DateTimeFieldPickerPlatform.adaptive,
  }) =>
      DateTimeField(
        key: key,
        mode: DateTimeFieldPickerMode.time,
        firstDate: firstDate ?? DateTime(2000, 1, 1, 0, 0),
        lastDate: lastDate ?? DateTime(2000, 1, 1, 23, 59),
        onChanged: onChanged,
        value: value,
        decoration: decoration,
        initialPickerDateTime: initialPickerDateTime,
        style: style,
        autofocus: autofocus,
        enabled: enabled,
        dateFormat: dateFormat,
        padding: padding,
        onTap: onTap,
        focusNode: focusNode,
        hideDefaultSuffixIcon: hideDefaultSuffixIcon,
        enableFeedback: enableFeedback,
        cupertinoDatePickerOptions: cupertinoDatePickerOptions,
        materialTimePickerOptions: materialTimePickerOptions,
        pickerPlatform: pickerPlatform,
      );

  DateTimeField._formField({
    required this.onChanged,
    this.value,
    this.enabled,
    this.onTap,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.padding,
    this.decoration,
    this.mode = DateTimeFieldPickerMode.dateAndTime,
    this.initialPickerDateTime,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    this.hideDefaultSuffixIcon = false,
    this.cupertinoDatePickerOptions = const CupertinoDatePickerOptions(),
    this.materialDatePickerOptions = const MaterialDatePickerOptions(),
    this.materialTimePickerOptions = const MaterialTimePickerOptions(),
    this.pickerPlatform = DateTimeFieldPickerPlatform.adaptive,
  })  : dateFormat = dateFormat ?? mode.toDateFormat(),
        firstDate = firstDate ?? kDefaultFirstSelectableDate,
        lastDate = lastDate ?? kDefaultLastSelectableDate;

  /// The [DateTime] that represents the currently selected date.
  final DateTime? value;

  /// A callback that gets executed when the user changes the [DateTime] in the [DateTimeField].
  final ValueChanged<DateTime?>? onChanged;

  /// Whether the [DateTimeField] is enabled or not, if null uses [InputDecoration.enabled],
  /// if null defaults to true.
  final bool? enabled;

  /// A callback that gets executed when the user taps on the [DateTimeField] and before the
  /// pickers are shown.
  final VoidCallback? onTap;

  /// Options to customize the [CupertinoDatePicker].
  final CupertinoDatePickerOptions cupertinoDatePickerOptions;

  /// Options to customize the [MaterialDatePicker].
  final MaterialDatePickerOptions materialDatePickerOptions;

  /// Options to customize the [MaterialTimePicker].
  final MaterialTimePickerOptions materialTimePickerOptions;

  /// The text style to use for text in the [DateTimeField].
  ///
  /// Defaults to the [TextTheme.titleMedium] value of the current
  /// [ThemeData.textTheme] of the current [Theme].
  final TextStyle? style;

  /// See [Focus.autofocus].
  final FocusNode? focusNode;

  /// See [Focus.autofocus].
  final bool autofocus;

  /// Padding around the visible portion of the [DateTimeField] widget.
  ///
  /// As the padding increases, the size of the [DropdownButton] will also
  /// increase. The padding is included in the clickable area of the dropdown
  /// widget, so this can make the widget easier to click.
  final EdgeInsetsGeometry? padding;

  /// See [InkWell.enableFeedback].
  final bool? enableFeedback;

  /// The first [DateTime] the user can select.
  ///
  /// Defaults to [_kDefaultFirstSelectableDate].
  final DateTime firstDate;

  /// The last [DateTime] the user can select.
  ///
  /// Defaults to [_kDefaultLastSelectableDate].
  final DateTime lastDate;

  /// The initial [DateTime] in the pickers, when no [DateTime] is selected.
  final DateTime? initialPickerDateTime;

  /// The decoration to show around the formatted [DateTime].
  ///
  /// By default [InputDecoration.suffixIcon] will be [Icons.event_note] when not defined and
  /// [hideDefaultSuffixIcon] equals false.
  final InputDecoration? decoration;

  /// Hides the default suffix icon.
  ///
  /// Defaults to false.
  final bool hideDefaultSuffixIcon;

  /// The format of the shown [DateTime].
  ///
  /// Depending on the [mod e] the [dateFormat] defaults to:
  /// - [DateTimeFieldPickerMode.time] => [DateFormat.jm]
  /// - [DateTimeFieldPickerMode.date] => [DateFormat.yMMMMd]
  /// - [DateTimeFieldPickerMode.dateAndTime] => [DateFormat.yMd].add_jm()
  final DateFormat dateFormat;

  /// The mode of the [DateTimeField].
  ///
  /// Depending on the mode, [DateTimeField] will show:
  /// - [TargetPlatform.iOS] or [TargetPlatform.macOS] => a CupertinoDatePicker with the according
  ///   [CupertinoDatePickerMode].
  /// - Else => a [MaterialDatePicker], a [MaterialTimePicker] or both.
  final DateTimeFieldPickerMode mode;

  /// The platform to use for the pickers.
  ///
  /// Defaults to [DateTimeFieldPickerPlatform.adaptive].
  final DateTimeFieldPickerPlatform pickerPlatform;

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  FocusNode? _internalNode;
  late Map<Type, Action<Intent>> _actionMap;
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _handleTap(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _handleTap(),
      ),
    };
  }

  @override
  void dispose() {
    _internalNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DateTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
  }

  bool debugCheckLocalizationsForPlatformAvailable(BuildContext context) {
    assert(() {
      switch (widget.pickerPlatform) {
        case DateTimeFieldPickerPlatform.material:
          assert(debugCheckHasMaterial(context));
          assert(debugCheckHasMaterialLocalizations(context));
          return true;

        case DateTimeFieldPickerPlatform.cupertino:
          assert(debugCheckHasCupertinoLocalizations(context));
          return true;

        case DateTimeFieldPickerPlatform.adaptive:
          assert(debugCheckHasMaterial(context));
          assert(debugCheckHasMaterialLocalizations(context));
          assert(debugCheckHasCupertinoLocalizations(context));
          return true;
      }
    }());

    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckLocalizationsForPlatformAvailable(context));

    final InputDecoration decoration = _getEffectiveDecoration(context);

    final bool isDense = decoration.isDense ?? false;

    Widget result = MediaQuery(
      data: MediaQuery.of(context).copyWith(
        alwaysUse24HourFormat: detect24HourFormat(
          context,
        ),
      ),
      child: DefaultTextStyle(
        style: _enabled
            ? _textStyle!
            : _textStyle!.copyWith(color: Theme.of(context).disabledColor),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: _denseButtonHeight,
            maxHeight: isDense ? _denseButtonHeight : double.infinity,
          ),
          child: widget.value != null
              ? Text(widget.dateFormat.format(widget.value!))
              : const Text(''),
        ),
      ),
    );

    final MouseCursor effectiveMouseCursor =
        WidgetStateProperty.resolveAs<MouseCursor>(
      WidgetStateMouseCursor.clickable,
      <WidgetState>{
        if (!_enabled) WidgetState.disabled,
      },
    );

    final bool isFocused = Focus.maybeOf(context)?.hasFocus ?? false;

    result = InputDecorator(
      decoration: decoration,
      isEmpty: widget.value == null,
      isFocused: isFocused || _isSelecting,
      child: result,
    );

    return Semantics(
      button: true,
      child: Actions(
        actions: _actionMap,
        child: InkWell(
          mouseCursor: effectiveMouseCursor,
          onTap: _enabled ? _handleTap : null,
          customBorder: decoration.border,
          canRequestFocus: _enabled,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          focusColor: decoration.focusColor,
          enableFeedback: widget.enableFeedback,
          child: widget.padding == null
              ? result
              : Padding(
                  padding: widget.padding!,
                  child: result,
                ),
        ),
      ),
    );
  }

  InputDecoration _getEffectiveDecoration(BuildContext context) {
    InputDecoration decoration = widget.decoration ?? const InputDecoration();

    decoration = decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );

    if (!widget.hideDefaultSuffixIcon && decoration.suffixIcon == null) {
      decoration = decoration.copyWith(
        suffixIcon: widget.mode == DateTimeFieldPickerMode.time
            ? const Icon(Icons.access_time)
            : const Icon(Icons.event_note),
      );
    }

    if (!_enabled) {
      decoration = decoration.copyWith(
        enabled: false,
      );
    }

    return decoration;
  }

  Future<void> _handleTap() async {
    _isSelecting = true;
    _focusNode?.requestFocus();
    widget.onTap?.call();

    final DateTime? newDateTime = await showAdaptiveDateTimePicker(
      context: context,
      mode: widget.mode,
      pickerPlatform: widget.pickerPlatform,
      cupertinoDatePickerOptions: widget.cupertinoDatePickerOptions,
      materialDatePickerOptions: widget.materialDatePickerOptions,
      materialTimePickerOptions: widget.materialTimePickerOptions,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      initialPickerDateTime: widget.value ?? widget.initialPickerDateTime
    );

    if (mounted) {
      _isSelecting = false;
    }

    if (newDateTime != null) {
      widget.onChanged?.call(newDateTime);
    }
  }

  double get _denseButtonHeight {
    final double fontSize = _textStyle!.fontSize ??
        Theme.of(context).textTheme.titleMedium!.fontSize!;
    final double scaledFontSize =
        MediaQuery.textScalerOf(context).scale(fontSize);
    return math.max(scaledFontSize, _kDenseButtonHeight);
  }

  bool get _enabled => widget.enabled ?? widget.decoration?.enabled ?? true;

  TextStyle? get _textStyle =>
      widget.style ?? Theme.of(context).textTheme.titleMedium;

  FocusNode? get _focusNode => widget.focusNode ?? _internalNode;

  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }
}
