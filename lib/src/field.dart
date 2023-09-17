import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateTime _kDefaultFirstSelectableDate = DateTime(1900);
final DateTime _kDefaultLastSelectableDate = DateTime(2100);

const double kCupertinoDatePickerHeight = 216;

const double _kDenseButtonHeight = 24.0;

/// A [FormField] that contains a [DateTimeField].
///
/// This is a convenience widget that wraps a [DateTimeField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    super.key,
    super.initialValue,
    required this.onChanged,
    VoidCallback? onTap,
    TextStyle? style,
    Color? focusColor,
    FocusNode? focusNode,
    bool autofocus = false,
    InputDecoration? decoration,
    super.onSaved,
    super.validator,
    AutovalidateMode? autovalidateMode,
    bool? enableFeedback,
    EdgeInsetsGeometry? padding,
    bool use24hFormat = false,
    TextStyle? dateTextStyle,
    DateFormat? dateFormat,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
    bool hideDefaultIcon = false,
    bool canReset = true,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DateTimeFieldPickerMode mode = DateTimeFieldPickerMode.dateAndTime,
    TimePickerEntryMode initialTimePickerEntryMode = TimePickerEntryMode.dial,
  }) : super(
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<DateTime> field) {
            final _DateTimeFormFieldState state = field as _DateTimeFormFieldState;

            final bool isEmpty = state.value == null;

            InputDecoration decorationArg = (decoration ?? InputDecoration(focusColor: focusColor))
                .copyWith(errorText: field.errorText);

            if (canReset && !isEmpty && state.value != initialValue) {
              decorationArg = decorationArg.copyWith(
                suffixIcon: Focus(
                  canRequestFocus: false,
                  skipTraversal: true,
                  child: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: field.reset,
                  ),
                ),
              );
            }

            // An unfocusable Focus widget so that this widget can detect if its
            // descendants have focus or not.
            return Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: Builder(builder: (BuildContext context) {
                return DateTimeField._formField(
                  value: state.value,
                  onChanged: onChanged == null ? null : state.didChange,
                  onTap: onTap,
                  style: style,
                  focusColor: focusColor,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  enableFeedback: enableFeedback,
                  decoration: decorationArg,
                  isEmpty: isEmpty,
                  isFocused: Focus.of(context).hasFocus,
                  padding: padding,
                  firstDate: firstDate,
                  initialDate: initialDate,
                  lastDate: lastDate,
                  initialDatePickerMode: initialDatePickerMode,
                  dateFormat: dateFormat,
                  use24hFormat: use24hFormat,
                  mode: mode,
                  initialEntryMode: initialEntryMode,
                  dateTextStyle: dateTextStyle,
                  initialTimePickerEntryMode: initialTimePickerEntryMode,
                  hideDefaultIcon: hideDefaultIcon,
                );
              }),
            );
          },
        );

  final ValueChanged<DateTime?>? onChanged;

  @override
  FormFieldState<DateTime> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  @override
  void didChange(DateTime? value) {
    super.didChange(value);
    final DateTimeFormField dropdownButtonFormField = widget as DateTimeFormField;
    assert(dropdownButtonFormField.onChanged != null);
    dropdownButtonFormField.onChanged!(value);
  }

  @override
  void didUpdateWidget(DateTimeFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}

/// [DateTimeField]
///
/// Shows an [_InputDropdown] that'll trigger [DateTimeField._handleTap] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateTimeField extends StatefulWidget {
  DateTimeField({
    super.key,
    this.value,
    required this.onChanged,
    this.onTap,
    this.style,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.padding,
    this.initialDatePickerMode = DatePickerMode.day,
    this.decoration,
    this.mode = DateTimeFieldPickerMode.dateAndTime,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.dateTextStyle,
    this.initialDate,
    this.use24hFormat = false,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    this.hideDefaultIcon = false,
    this.initialTimePickerEntryMode = TimePickerEntryMode.dial,
  })  : dateFormat = dateFormat ?? getDateFormatFromDateFieldPickerMode(mode),
        firstDate = firstDate ?? _kDefaultFirstSelectableDate,
        lastDate = lastDate ?? _kDefaultLastSelectableDate,
        // TODO(torbenkeller): isEmtpty & isFocused should disable the input
        // decoration when the widget is not used as a form field. Then we need a hint and icon widget + styles
        // and build the widget like the dropdown button from hand.
        _isEmpty = false,
        _isFocused = false;

  DateTimeField._formField({
    super.key,
    this.value,
    required this.onChanged,
    this.onTap,
    this.style,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback,
    this.padding,
    this.initialDatePickerMode = DatePickerMode.day,
    this.decoration,
    this.mode = DateTimeFieldPickerMode.dateAndTime,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.dateTextStyle,
    this.initialDate,
    this.use24hFormat = false,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    this.hideDefaultIcon = false,
    required bool isEmpty,
    required bool isFocused,
    this.initialTimePickerEntryMode = TimePickerEntryMode.dial,
  })  : dateFormat = dateFormat ?? getDateFormatFromDateFieldPickerMode(mode),
        firstDate = firstDate ?? _kDefaultFirstSelectableDate,
        lastDate = lastDate ?? _kDefaultLastSelectableDate,
        _isEmpty = isEmpty,
        _isFocused = isFocused;

  final bool hideDefaultIcon;

  final DateTime? value;

  final ValueChanged<DateTime?>? onChanged;

  final VoidCallback? onTap;

  /// The text style to use for text in the dropdown button and the dropdown
  /// menu that appears when you tap the button.
  ///
  /// To use a separate text style for selected item when it's displayed within
  /// the dropdown button, consider using [selectedItemBuilder].
  ///
  /// {@tool dartpad}
  /// This sample shows a `DropdownButton` with a dropdown button text style
  /// that is different than its menu items.
  ///
  /// ** See code in examples/api/lib/material/dropdown/dropdown_button.style.0.dart **
  /// {@end-tool}
  ///
  /// Defaults to the [TextTheme.titleMedium] value of the current
  /// [ThemeData.textTheme] of the current [Theme].
  final TextStyle? style;

  /// The color for the button's [Material] when it has the input focus.
  final Color? focusColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Padding around the visible portion of the dropdown widget.
  ///
  /// As the padding increases, the size of the [DropdownButton] will also
  /// increase. The padding is included in the clickable area of the dropdown
  /// widget, so this can make the widget easier to click.
  ///
  /// Padding can be useful when used with a custom border. The clickable
  /// area will stay flush with the border, as opposed to an external [Padding]
  /// widget which will leave a non-clickable gap.
  final EdgeInsetsGeometry? padding;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// By default, platform-specific feedback is enabled.
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  final bool _isEmpty;

  final bool _isFocused;

  /// The first date that the user can select (default is 1900)
  final DateTime firstDate;

  /// The last date that the user can select (default is 2100)
  final DateTime lastDate;

  /// The date that will be selected by default in the calendar view.
  final DateTime? initialDate;

  /// Let you choose the [DatePickerMode] for the date picker! (default is [DatePickerMode.day]
  final DatePickerMode? initialDatePickerMode;

  /// Custom [InputDecoration] for the [InputDecorator] widget
  final InputDecoration? decoration;

  /// How to display the [DateTime] for the user (default is [DateFormat.yMMMD])
  final DateFormat dateFormat;

  /// Whether to use the 24Hr Format
  final bool use24hFormat;

  /// Whether to ask the user to pick only the date, the time or both.
  final DateTimeFieldPickerMode mode;

  /// [TextStyle] of the selected date inside the field.
  final TextStyle? dateTextStyle;

  /// The initial entry mode for the material date picker dialog
  final DatePickerEntryMode initialEntryMode;

  /// The initial entry mode for the material time picker dialog
  final TimePickerEntryMode initialTimePickerEntryMode;

  @override
  State<DateTimeField> createState() => _DateTimeFieldState();
}

class _DateTimeFieldState extends State<DateTimeField> {
  FocusNode? _internalNode;

  FocusNode? get focusNode => widget.focusNode ?? _internalNode;

  TextStyle? get _textStyle => widget.style ?? Theme.of(context).textTheme.titleMedium;

  // Only used if needed to create _internalNode.
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  late Map<Type, Action<Intent>> _actionMap;

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

  DateTime get _initialDateTime {
    if (widget.value != null) {
      return widget.value!;
    }

    if (widget.initialDate != null) {
      return widget.initialDate!;
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

  /// Shows a dialog asking the user to pick a date !
  Future<void> _handleTap() async {
    _isSelecting = true;

    focusNode?.requestFocus();

    widget.onTap?.call();

    final TargetPlatform platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      final DateTime? newDateTime = await showCupertinoPicker();
      if (!mounted || newDateTime == null) {
        _isSelecting = false;
        return;
      }

      widget.onChanged?.call(newDateTime);

      return;
    }

    DateTime? selectedDateTime = _initialDateTime;

    if (widget.mode == DateTimeFieldPickerMode.dateAndTime ||
        widget.mode == DateTimeFieldPickerMode.date) {
      final DateTime? newDate = await showMaterialDatePicker();
      if (!mounted || newDate == null) {
        _isSelecting = false;
        return;
      }

      selectedDateTime = newDate;
    }

    if (widget.mode == DateTimeFieldPickerMode.dateAndTime ||
        widget.mode == DateTimeFieldPickerMode.time) {
      final TimeOfDay? selectedTime = await showMaterialTimePicker();

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

  /// Launches the Material time picker by invoking [showTimePicker].
  /// Can be @[override]n to allow further customization of the picker options
  Future<TimeOfDay?> showMaterialTimePicker() async {
    return showTimePicker(
      initialTime: TimeOfDay.fromDateTime(_initialDateTime),
      context: context,
      initialEntryMode: widget.initialTimePickerEntryMode,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: widget.use24hFormat,
          ),
          child: child!,
        );
      },
    );
  }

  /// Launches the Material time picker by invoking [showDatePicker].
  /// Can be @[override]n to allow further customization of the picker options
  Future<DateTime?> showMaterialDatePicker() {
    return showDatePicker(
      context: context,
      initialDatePickerMode: widget.initialDatePickerMode!,
      initialDate: _initialDateTime,
      initialEntryMode: widget.initialEntryMode,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
  }

  /// Launches the [CupertinoDatePicker] within a [showModalBottomSheet].
  /// Can be @[override]n to allow further customization of the picker options
  Future<DateTime?> showCupertinoPicker() async {
    return showCupertinoModalPopup<DateTime?>(
      context: context,
      builder: (BuildContext context) {
        DateTime? _pickedDate = _initialDateTime;
        return Container(
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        child: Text(
                          MaterialLocalizations.of(context).cancelButtonLabel,
                          style: const TextStyle(
                            color: CupertinoColors.destructiveRed,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                      ),
                      CupertinoButton(
                        child: Text(
                          MaterialLocalizations.of(context).saveButtonLabel,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(_pickedDate);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: kCupertinoDatePickerHeight,
                  child: CupertinoDatePicker(
                    mode: cupertinoModeFromPickerMode(widget.mode),
                    onDateTimeChanged: (DateTime dt) => _pickedDate = dt,
                    initialDateTime: _initialDateTime,
                    minimumDate: widget.firstDate,
                    maximumDate: widget.lastDate,
                    use24hFormat: widget.use24hFormat,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // When isDense is true, reduce the height of this button from _kMenuItemHeight to
  // _kDenseButtonHeight, but don't make it smaller than the text that it contains.
  // Similarly, we don't reduce the height of the button so much that its icon
  // would be clipped.
  double get _denseButtonHeight {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final double fontSize =
        _textStyle!.fontSize ?? Theme.of(context).textTheme.titleMedium!.fontSize!;
    final double scaledFontSize = textScaleFactor * fontSize;
    return math.max(scaledFontSize, _kDenseButtonHeight);
  }

  bool _isSelecting = false;

  bool get _enabled => widget.onChanged != null;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));

    InputDecoration decoration =
        widget.decoration ?? InputDecoration(focusColor: widget.focusColor);

    decoration = decoration.applyDefaults(
      Theme.of(context).inputDecorationTheme,
    );

    if (!widget.hideDefaultIcon && decoration.suffixIcon == null) {
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

    Widget result = DefaultTextStyle(
      style: _enabled ? _textStyle! : _textStyle!.copyWith(color: Theme.of(context).disabledColor),
      child: SizedBox(
        height: isDense ? _denseButtonHeight : null,
        child: widget.value != null
            ? Text(widget.dateFormat.format(widget.value!))
            : const SizedBox.shrink(),
      ),
    );
    //
    // if (!DropdownButtonHideUnderline.at(context)) {
    //   result = Stack(
    //     children: <Widget>[
    //       result,
    //       Positioned(
    //         left: 0.0,
    //         right: 0.0,
    //         bottom: 0.0,
    //         child: widget.underline ??
    //             Container(
    //               height: 1.0,
    //               decoration: const BoxDecoration(
    //                 border: Border(
    //                   bottom: BorderSide(
    //                     color: Color(0xFFBDBDBD),
    //                     width: 0.0,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //       ),
    //     ],
    //   );
    // }

    final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor>(
      MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!_enabled) MaterialState.disabled,
      },
    );

    result = InputDecorator(
      decoration: decoration,
      isEmpty: widget._isEmpty,
      isFocused: widget._isFocused || _isSelecting,
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
          focusNode: focusNode,
          autofocus: widget.autofocus,
          focusColor: widget.focusColor ?? Theme.of(context).focusColor,
          enableFeedback: widget.enableFeedback,
          child: widget.padding == null ? result : Padding(padding: widget.padding!, child: result),
        ),
      ),
    );
  }
}

/// Those values are used by the [DateTimeField] widget to determine whether to ask
/// the user for the time, the date or both.
enum DateTimeFieldPickerMode { time, date, dateAndTime }

/// Returns the [CupertinoDatePickerMode] corresponding to the selected
/// [DateTimeFieldPickerMode]. This exists to prevent redundancy in the [DateTimeField]
/// widget parameters.
CupertinoDatePickerMode cupertinoModeFromPickerMode(DateTimeFieldPickerMode mode) {
  switch (mode) {
    case DateTimeFieldPickerMode.time:
      return CupertinoDatePickerMode.time;
    case DateTimeFieldPickerMode.date:
      return CupertinoDatePickerMode.date;
    default:
      return CupertinoDatePickerMode.dateAndTime;
  }
}

/// Returns the corresponding default [DateFormat] for the selected [DateTimeFieldPickerMode]
DateFormat getDateFormatFromDateFieldPickerMode(DateTimeFieldPickerMode mode) {
  switch (mode) {
    case DateTimeFieldPickerMode.time:
      return DateFormat.jm();
    case DateTimeFieldPickerMode.date:
      return DateFormat.yMMMMd();
    default:
      return DateFormat.yMd().add_jm();
  }
}
