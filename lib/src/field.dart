import 'dart:io';
import 'dart:math' as math;

import 'package:date_field/src/cupertino_date_picker_options.dart';
import 'package:date_field/src/material_date_picker_options.dart';
import 'package:date_field/src/material_time_picker_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'form_field.dart';

final DateTime _kDefaultFirstSelectableDate = DateTime(1900);
final DateTime _kDefaultLastSelectableDate = DateTime(2100);

const double _kCupertinoDatePickerHeight = 216;
const double _kDenseButtonHeight = 24.0;

/// The mode of the [DateTimeField].
///
/// Depending on the mode, [DateTimeField] will show:
/// On iOS & macOS: a CupertinoDatePicker with the according [CupertinoDatePickerMode].
/// On all other platforms: a [MaterialDatePicker], a [MaterialTimePicker] or both.
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

/// [DateTimeField]
///
/// Shows an [_InputDropdown] that'll trigger [DateTimeField._handleTap] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateTimeField extends StatefulWidget {
  DateTimeField({
    required this.onChanged,
    super.key,
    DateTime? value,
    this.onTap,
    TextStyle? style,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.padding,
    this.hideDefaultSuffixIcon = false,
    this.decoration,
    DateTime? initialPickerDateTime,
    this.cupertinoDatePickerOptions = const CupertinoDatePickerOptions(),
    MaterialDatePickerOptions? materialDatePickerOptions,
    MaterialTimePickerOptions? materialTimePickerOptions,
    this.mode = DateTimeFieldPickerMode.dateAndTime,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    this.use24hFormat,
    @Deprecated('''
    enabled has no effect anymore. It gets evaluated from onChanged != null.
    Will be removed in v5.0.0.
    ''') bool? enabled,
    @Deprecated('''
    Use value instead.
    Will be removed in v5.0.0.
    ''') DateTime? selectedDate,
    @Deprecated('''
    Use style instead.
    Will be removed in v5.0.0.
    ''') TextStyle? dateTextStyle,
    @Deprecated('''
    Use onChanged instead.
    Will be removed in v5.0.0.
    ''') ValueChanged<DateTime>? onDateSelected,
    @Deprecated('''
    Use materialDatePickerOptions.initialDatePickerMode instead.
    Will be removed in v5.0.0
    ''') DatePickerMode? initialDatePickerMode,
    @Deprecated('''
    Use materialDatePickerOptions.initialEntryMode instead.
    Will be removed in v5.0.0
    ''') DatePickerEntryMode? initialEntryMode,
    @Deprecated('''
    Use initialPickerDateTime instead.
    Will be removed in v5.0.0
    ''') DateTime? initialDate,
    @Deprecated('''
    Use materialTimePickerOptions.initialEntryMode instead.
    Will be removed in v5.0.0
    ''') TimePickerEntryMode? initialTimePickerEntryMode,
  })  : assert(enabled == null || enabled == (onChanged != null),
            'enabled got deprecated. The new behavior uses `onChanged != null`'),
        dateFormat = dateFormat ?? mode.toDateFormat(),
        style = style ?? dateTextStyle,
        firstDate = firstDate ?? _kDefaultFirstSelectableDate,
        lastDate = lastDate ?? _kDefaultLastSelectableDate,
        initialPickerDateTime = initialPickerDateTime ?? initialDate,
        value = value ?? selectedDate,
        materialDatePickerOptions = materialDatePickerOptions ??
            MaterialDatePickerOptions(
              initialEntryMode:
                  initialEntryMode ?? DatePickerEntryMode.calendar,
              initialDatePickerMode:
                  initialDatePickerMode ?? DatePickerMode.day,
            ),
        materialTimePickerOptions = materialTimePickerOptions ??
            MaterialTimePickerOptions(
              initialEntryMode:
                  initialTimePickerEntryMode ?? TimePickerEntryMode.dial,
            );

  factory DateTimeField.time({
    Key? key,
    required ValueChanged<DateTime?>? onChanged,
    DateTime? value,
    InputDecoration? decoration,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialPickerDateTime,
    TextStyle? style,
    CupertinoDatePickerOptions cupertinoDatePickerOptions =
        const CupertinoDatePickerOptions(),
    MaterialTimePickerOptions? materialTimePickerOptions,
    bool autofocus = false,
    DateFormat? dateFormat,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    FocusNode? focusNode,
    bool hideDefaultSuffixIcon = false,
    bool? enableFeedback,
    @Deprecated('''
    Use onChanged instead.
    Will be removed in v5.0.0.
    ''') ValueChanged<DateTime>? onDateSelected,
    @Deprecated('''
    Use value instead.
    Will be removed in v5.0.0.
    ''') DateTime? selectedDate,
    @Deprecated('''
    enabled has no effect anymore. It gets evaluated from onChanged != null.
    Will be removed in v5.0.0.''') bool? enabled,
    @Deprecated('''
    Use initialPickerDateTime instead.
    Will be removed in v5.0.0
    ''') DateTime? initialDate,
    @Deprecated('''
    Uses now by default MediaQuery.of(context).alwaysUse24HourFormat.
    Will be removed in v5.0.0.
    ''') bool? use24hFormat,
    @Deprecated('''
    Use style instead.
    Will be removed in v5.0.0.
    ''') TextStyle? dateTextStyle,
    @Deprecated('''
    Has no effect anymore.
    Will be removed in v5.0.0
    ''') DatePickerEntryMode? initialEntryMode,
    @Deprecated('''
    Use materialTimePickerOptions.initialEntryMode instead.
    Will be removed in v5.0.0
    ''') TimePickerEntryMode? initialTimePickerEntryMode,
  }) =>
      DateTimeField(
        key: key,
        mode: DateTimeFieldPickerMode.time,
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2001),
        onChanged: onChanged,
        value: value ?? selectedDate,
        decoration: decoration,
        initialPickerDateTime: initialPickerDateTime ?? initialDate,
        use24hFormat: use24hFormat,
        style: style ?? dateTextStyle,
        autofocus: autofocus,
        dateFormat: dateFormat,
        padding: padding,
        onTap: onTap,
        focusNode: focusNode,
        hideDefaultSuffixIcon: hideDefaultSuffixIcon,
        enableFeedback: enableFeedback,
        cupertinoDatePickerOptions: cupertinoDatePickerOptions,
        materialTimePickerOptions: materialTimePickerOptions,
        initialTimePickerEntryMode: initialTimePickerEntryMode,
      );

  DateTimeField._formField({
    required this.onChanged,
    this.value,
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
    this.use24hFormat,
    this.cupertinoDatePickerOptions = const CupertinoDatePickerOptions(),
    this.materialDatePickerOptions = const MaterialDatePickerOptions(),
    this.materialTimePickerOptions = const MaterialTimePickerOptions(),
  })  : dateFormat = dateFormat ?? mode.toDateFormat(),
        firstDate = firstDate ?? _kDefaultFirstSelectableDate,
        lastDate = lastDate ?? _kDefaultLastSelectableDate;

  /// The [DateTime] that represents the currently selected date.
  final DateTime? value;

  /// A callback that gets executed when the user changes the [DateTime] in the [DateTimeField].
  final ValueChanged<DateTime?>? onChanged;

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
  /// Depending on the [mode] the [dateFormat] defaults to:
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

  @Deprecated('''
  Uses now by default MediaQuery.of(context).alwaysUse24HourFormat.
  Will be removed in v5.0.0.
  ''')
  final bool? use24hFormat;

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

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasCupertinoLocalizations(context));

    InputDecoration decoration = widget.decoration ?? const InputDecoration();

    decoration = decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );

    if (!widget.hideDefaultSuffixIcon && decoration.suffixIcon == null) {
      decoration = decoration.copyWith(
        suffixIcon: const Icon(Icons.event_note),
      );
    }

    if (!_enabled) {
      decoration = decoration.copyWith(
        prefixIconColor: Theme.of(context).disabledColor,
        suffixIconColor: Theme.of(context).disabledColor,
      );
    }

    final bool isDense = decoration.isDense ?? false;

    Widget result = MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(alwaysUse24HourFormat: _use24HourFormat),
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
              : const SizedBox.shrink(),
        ),
      ),
    );

    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!_enabled) MaterialState.disabled,
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

  Future<void> _handleTap() async {
    _isSelecting = true;

    _focusNode?.requestFocus();

    widget.onTap?.call();

    final TargetPlatform platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      final DateTime? newDateTime = await _showCupertinoPicker();
      _isSelecting = false;

      if (!mounted || newDateTime == null) {
        return;
      }

      widget.onChanged?.call(newDateTime);

      return;
    }

    DateTime? selectedDateTime = _initialPickerDateTime;

    if (widget.mode == DateTimeFieldPickerMode.dateAndTime ||
        widget.mode == DateTimeFieldPickerMode.date) {
      final DateTime? newDate = await _showMaterialDatePicker();
      if (!mounted || newDate == null) {
        _isSelecting = false;
        return;
      }

      selectedDateTime = newDate;
    }

    if (widget.mode == DateTimeFieldPickerMode.dateAndTime ||
        widget.mode == DateTimeFieldPickerMode.time) {
      final TimeOfDay? selectedTime = await _showMaterialTimePicker();

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

    if (mounted) {
      _isSelecting = false;
    }

    widget.onChanged?.call(selectedDateTime);
  }

  Future<TimeOfDay?> _showMaterialTimePicker() async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_initialPickerDateTime),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: _use24HourFormat),
          child:
              widget.materialTimePickerOptions.builder?.call(context, child) ??
                  child!,
        );
      },
      initialEntryMode: widget.materialTimePickerOptions.initialEntryMode,
      useRootNavigator: widget.materialTimePickerOptions.useRootNavigator,
      helpText: widget.materialTimePickerOptions.helpText,
      errorInvalidText: widget.materialTimePickerOptions.errorInvalidText,
      cancelText: widget.materialTimePickerOptions.cancelText,
      confirmText: widget.materialTimePickerOptions.confirmText,
      hourLabelText: widget.materialTimePickerOptions.hourLabelText,
      minuteLabelText: widget.materialTimePickerOptions.minuteLabelText,
      orientation: widget.materialTimePickerOptions.orientation,
    );
  }

  Future<DateTime?> _showMaterialDatePicker() {
    return showDatePicker(
      context: context,
      initialDate: _initialPickerDateTime,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: _use24HourFormat),
          child:
              widget.materialDatePickerOptions.builder?.call(context, child) ??
                  child!,
        );
      },
      initialDatePickerMode:
          widget.materialDatePickerOptions.initialDatePickerMode,
      initialEntryMode: widget.materialDatePickerOptions.initialEntryMode,
      currentDate: widget.materialDatePickerOptions.currentDate,
      locale: widget.materialDatePickerOptions.locale,
      cancelText: widget.materialDatePickerOptions.cancelText,
      confirmText: widget.materialDatePickerOptions.confirmText,
      errorFormatText: widget.materialDatePickerOptions.errorFormatText,
      errorInvalidText: widget.materialDatePickerOptions.errorInvalidText,
      fieldHintText: widget.materialDatePickerOptions.fieldHintText,
      fieldLabelText: widget.materialDatePickerOptions.fieldLabelText,
      helpText: widget.materialDatePickerOptions.helpText,
      keyboardType: widget.materialDatePickerOptions.keyboardType,
      selectableDayPredicate:
          widget.materialDatePickerOptions.selectableDayPredicate,
      switchToCalendarEntryModeIcon:
          widget.materialDatePickerOptions.switchToCalendarEntryModeIcon,
      switchToInputEntryModeIcon:
          widget.materialDatePickerOptions.switchToInputEntryModeIcon,
      textDirection: widget.materialDatePickerOptions.textDirection,
      useRootNavigator: widget.materialDatePickerOptions.useRootNavigator,
    );
  }

  Future<DateTime?> _showCupertinoPicker() async {
    final DateTime initialDateTime = switch (widget.mode) {
      DateTimeFieldPickerMode.time => _initialPickerDateTime,
      DateTimeFieldPickerMode.date =>
        DateUtils.dateOnly(_initialPickerDateTime),
      DateTimeFieldPickerMode.dateAndTime => _initialPickerDateTime,
    };

    final DateTime firstDate = switch (widget.mode) {
      DateTimeFieldPickerMode.time => widget.firstDate,
      DateTimeFieldPickerMode.date => DateUtils.dateOnly(widget.firstDate),
      DateTimeFieldPickerMode.dateAndTime => widget.firstDate,
    };

    final DateTime lastDate = switch (widget.mode) {
      DateTimeFieldPickerMode.time => widget.lastDate,
      DateTimeFieldPickerMode.date => DateUtils.dateOnly(widget.lastDate),
      DateTimeFieldPickerMode.dateAndTime => widget.lastDate,
    };

    return showCupertinoModalPopup<DateTime?>(
      useRootNavigator: widget.cupertinoDatePickerOptions.useRootNavigator,
      context: context,
      builder: (BuildContext context) {
        final Widget modal = _CupertinoDatePickerModalSheet(
          initialPickerDateTime: initialDateTime,
          options: widget.cupertinoDatePickerOptions,
          use24hFormat: _use24HourFormat,
          firstDate: firstDate,
          lastDate: lastDate,
          mode: widget.mode,
        );

        return widget.cupertinoDatePickerOptions.builder
                ?.call(context, modal) ??
            modal;
      },
    );
  }

  DateTime get _initialPickerDateTime {
    if (widget.value != null) {
      return widget.value!;
    }

    if (widget.initialPickerDateTime != null) {
      return widget.initialPickerDateTime!;
    }

    final DateTime now = DateTime.now();

    // when now is not between `firstDate` and `lastDate` return the closest to now.
    if (widget.firstDate.isAfter(now)) {
      return widget.firstDate;
    }

    if (widget.lastDate.isBefore(now)) {
      return widget.lastDate;
    }

    return now;
  }

  bool get _use24HourFormat {
    if (widget.use24hFormat != null) {
      return widget.use24hFormat!;
    }

    final DateFormat formatter =
        DateFormat.jm(Localizations.localeOf(context).toString());
    final DateTime now = DateTime.parse('2000-01-01 17:00:00');
    final String formattedTime = formatter.format(now);
    final bool localeBasedUse24HourFormat = !formattedTime.contains('PM');

    if (kIsWeb) {
      return localeBasedUse24HourFormat;
    }

    if (Platform.isIOS || Platform.isAndroid) {
      return MediaQuery.of(context).alwaysUse24HourFormat;
    }

    return localeBasedUse24HourFormat;
  }

  // When isDense is true, reduce the height of the content to _kDenseButtonHeight,
  // but don't make it smaller than the text that it contains. Similarly, we don't
  // reduce the height of the button so much that its icon would be clipped.
  double get _denseButtonHeight {
    final double fontSize = _textStyle!.fontSize ??
        Theme.of(context).textTheme.titleMedium!.fontSize!;
    final double scaledFontSize =
        MediaQuery.textScalerOf(context).scale(fontSize);
    return math.max(scaledFontSize, _kDenseButtonHeight);
  }

  bool get _enabled => widget.onChanged != null;

  TextStyle? get _textStyle =>
      widget.style ?? Theme.of(context).textTheme.titleMedium;

  FocusNode? get _focusNode => widget.focusNode ?? _internalNode;

  /// Only used if needed to create _internalNode.
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }
}

class _CupertinoDatePickerModalSheet extends StatefulWidget {
  const _CupertinoDatePickerModalSheet({
    required this.initialPickerDateTime,
    required this.options,
    required this.mode,
    required this.use24hFormat,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialPickerDateTime;

  final CupertinoDatePickerOptions options;

  final DateTimeFieldPickerMode mode;

  final bool use24hFormat;

  final DateTime firstDate;

  final DateTime lastDate;

  @override
  State<_CupertinoDatePickerModalSheet> createState() =>
      _CupertinoDatePickerModalSheetState();
}

class _CupertinoDatePickerModalSheetState
    extends State<_CupertinoDatePickerModalSheet> {
  DateTime? _pickedDate;

  late Map<Type, Action<Intent>> _cancelActionMap;
  late Map<Type, Action<Intent>> _saveActionMap;

  @override
  void initState() {
    super.initState();
    _pickedDate = widget.initialPickerDateTime;

    _cancelActionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _cancel(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _cancel(),
      ),
    };
    _saveActionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _save(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _save(),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context).removePadding(
      removeTop: true,
      removeBottom: false,
      removeLeft: false,
      removeRight: false,
    );

    return MediaQuery(
      data: mediaQueryData,
      child: CupertinoPopupSurface(
        isSurfacePainted: true,
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoDynamicColor.resolve(
              CupertinoTheme.of(context).barBackgroundColor,
              context,
            ),
            brightness: Theme.of(context).brightness,
            middle: Text(
              widget.options.modalTitleText ??
                  MaterialLocalizations.of(context).dateInputLabel,
              style: widget.options.style.modalTitle ??
                  CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            leading: FocusableActionDetector(
              actions: _cancelActionMap,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  widget.options.cancelText ??
                      CupertinoLocalizations.of(context)
                          .modalBarrierDismissLabel,
                  style: widget.options.style.cancelButton,
                ),
                onPressed: _cancel,
              ),
            ),
            trailing: FocusableActionDetector(
              actions: _saveActionMap,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  widget.options.saveText ??
                      MaterialLocalizations.of(context).saveButtonLabel,
                  style: widget.options.style.saveButton,
                ),
                onPressed: _save,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // _kNavBarPersistentHeight equals kMinInteractiveDimensionCupertino
              const SizedBox(height: kMinInteractiveDimensionCupertino),
              SizedBox(
                height: _kCupertinoDatePickerHeight,
                child: CupertinoDatePicker(
                  mode: widget.mode.toCupertinoDatePickerMode(),
                  onDateTimeChanged: (DateTime dt) => _pickedDate = dt,
                  initialDateTime: widget.initialPickerDateTime,
                  minimumDate: widget.firstDate,
                  maximumDate: widget.lastDate,
                  use24hFormat: widget.use24hFormat,
                  showDayOfWeek: widget.options.showDayOfWeek,
                  minuteInterval: widget.options.minuteInterval,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    Navigator.of(context).pop(_pickedDate);
  }

  void _cancel() {
    Navigator.of(context).pop(null);
  }
}
