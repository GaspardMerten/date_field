import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateTime _kDefaultFirstSelectableDate = DateTime(1900);
final DateTime _kDefaultLastSelectableDate = DateTime(2100);

const double kCupertinoDatePickerHeight = 216;

/// Constructor tearoff definition that matches [DateTimeField.new]
// Note: This should match the definition of the [DateTimeField] constructor
typedef DateTimeFieldCreator = DateTimeField Function({
  Key? key,
  required ValueChanged<DateTime>? onDateSelected,
  required DateTime? selectedDate,
  DateFormat? dateFormat,
  TextStyle? dateTextStyle,
  InputDecoration? decoration,
  bool? enabled,
  DateTime? firstDate,
  DateTime? initialDate,
  DatePickerMode? initialDatePickerMode,
  DatePickerEntryMode initialEntryMode,
  DateTime? lastDate,
  DateTimeFieldPickerMode mode,
  bool use24hFormat,
});

/// [DateTimeField]
///
/// Shows an [_InputDropdown] that'll trigger [DateTimeField._selectDate] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateTimeField extends StatelessWidget {
  // Note: This should match the definition of the [DateTimeFieldCreator]
  DateTimeField({
    Key? key,
    required this.onDateSelected,
    required this.selectedDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.decoration,
    this.enabled = true,
    this.mode = DateTimeFieldPickerMode.dateAndTime,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.dateTextStyle,
    this.initialDate,
    this.use24hFormat = false,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
  })  : dateFormat = dateFormat ?? getDateFormatFromDateFieldPickerMode(mode),
        firstDate = firstDate ?? _kDefaultFirstSelectableDate,
        lastDate = lastDate ?? _kDefaultLastSelectableDate,
        super(key: key);

  DateTimeField.time({
    Key? key,
    this.onDateSelected,
    this.selectedDate,
    this.decoration,
    this.enabled,
    this.initialDate,
    this.dateTextStyle,
    this.use24hFormat = false,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    DateTime? firstDate,
    DateTime? lastDate,
  })  : initialDatePickerMode = null,
        mode = DateTimeFieldPickerMode.time,
        dateFormat = DateFormat.jm(),
        firstDate = firstDate ?? DateTime(2000),
        lastDate = lastDate ?? DateTime(2001),
        super(key: key);

  /// Callback for whenever the user selects a [DateTime]
  final ValueChanged<DateTime>? onDateSelected;

  /// The current selected date to display inside the field
  final DateTime? selectedDate;

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

  /// Whether the field is usable. If false the user won't be able to select any date
  final bool? enabled;

  /// Whether to use the 24Hr Format
  final bool use24hFormat;

  /// Whether to ask the user to pick only the date, the time or both.
  final DateTimeFieldPickerMode mode;

  /// [TextStyle] of the selected date inside the field.
  final TextStyle? dateTextStyle;

  /// The initial entry mode for the material date picker dialog
  final DatePickerEntryMode initialEntryMode;

  /// Shows a dialog asking the user to pick a date !
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDateTime;

    if (selectedDate != null) {
      initialDateTime = selectedDate!;
    } else {
      final DateTime now = DateTime.now();
      if (firstDate.isAfter(now) || lastDate.isBefore(now)) {
        initialDateTime = initialDate ?? lastDate;
      } else {
        initialDateTime = initialDate ?? now;
      }
    }

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      final DateTime? _selectedDateTime =
          await showCupertinoPicker(context, initialDateTime);
      if (_selectedDateTime != null) {
        onDateSelected!(_selectedDateTime);
      }
    } else {
      DateTime _selectedDateTime = initialDateTime;

      const List<DateTimeFieldPickerMode> modesWithDate =
          <DateTimeFieldPickerMode>[
        DateTimeFieldPickerMode.dateAndTime,
        DateTimeFieldPickerMode.date
      ];

      if (modesWithDate.contains(mode)) {
        final DateTime? _selectedDate =
            await showMaterialDatePicker(context, initialDateTime);

        if (_selectedDate != null) {
          _selectedDateTime = _selectedDate;
        } else {
          return;
        }
      }

      final List<DateTimeFieldPickerMode> modesWithTime =
          <DateTimeFieldPickerMode>[
        DateTimeFieldPickerMode.dateAndTime,
        DateTimeFieldPickerMode.time
      ];

      if (modesWithTime.contains(mode)) {
        final TimeOfDay? _selectedTime =
            await showMaterialTimePicker(context, initialDateTime);

        if (_selectedTime != null) {
          _selectedDateTime = DateTime(
            _selectedDateTime.year,
            _selectedDateTime.month,
            _selectedDateTime.day,
            _selectedTime.hour,
            _selectedTime.minute,
          );
        }
      }

      onDateSelected!(_selectedDateTime);
    }
  }

  /// Launches the Material time picker by invoking [showTimePicker].
  /// Can be @[override]n to allow further customization of the picker options
  Future<TimeOfDay?> showMaterialTimePicker(
    BuildContext context,
    DateTime initialDateTime,
  ) async {
    return showTimePicker(
      initialTime: TimeOfDay.fromDateTime(initialDateTime),
      context: context,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: use24hFormat,
          ),
          child: child!,
        );
      },
    );
  }

  /// Launches the Material time picker by invoking [showDatePicker].
  /// Can be @[override]n to allow further customization of the picker options
  Future<DateTime?> showMaterialDatePicker(
    BuildContext context,
    DateTime initialDateTime,
  ) {
    return showDatePicker(
      context: context,
      initialDatePickerMode: initialDatePickerMode!,
      initialDate: initialDateTime,
      initialEntryMode: initialEntryMode,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  /// Launches the [CupertinoDatePicker] within a [showModalBottomSheet].
  /// Can be @[override]n to allow further customization of the picker options
  Future<DateTime?> showCupertinoPicker(
    BuildContext context,
    DateTime initialDateTime,
  ) async {
    DateTime? pickedDate;
    await showModalBottomSheet<DateTime?>(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: kCupertinoDatePickerHeight,
          child: CupertinoDatePicker(
            mode: cupertinoModeFromPickerMode(mode),
            onDateTimeChanged: (DateTime dt) => pickedDate = dt,
            initialDateTime: initialDateTime,
            minimumDate: firstDate,
            maximumDate: lastDate,
            use24hFormat: use24hFormat,
          ),
        );
      },
    );
    return pickedDate;
  }

  @override
  Widget build(BuildContext context) {
    String? text;

    if (selectedDate != null) {
      text = dateFormat.format(selectedDate!);
    }
    TextStyle? textStyle;

    textStyle = dateTextStyle ?? dateTextStyle;

    return _InputDropdown(
      text: text,
      textStyle: textStyle,
      isEmpty: selectedDate == null,
      decoration: decoration,
      onPressed: enabled! ? () => _selectDate(context) : null,
    );
  }
}

/// Those values are used by the [DateTimeField] widget to determine whether to ask
/// the user for the time, the date or both.
enum DateTimeFieldPickerMode { time, date, dateAndTime }

/// Returns the [CupertinoDatePickerMode] corresponding to the selected
/// [DateTimeFieldPickerMode]. This exists to prevent redundancy in the [DateTimeField]
/// widget parameters.
CupertinoDatePickerMode cupertinoModeFromPickerMode(
    DateTimeFieldPickerMode mode) {
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

///
/// [_InputDropdown]
///
/// Shows a field with a dropdown arrow !
/// It does not show any popup menu, it'll just trigger onPressed whenever the
/// user does click on it !
class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key? key,
    required this.text,
    this.decoration,
    this.textStyle,
    this.onPressed,
    required this.isEmpty,
  }) : super(key: key);

  /// The text that should be displayed inside the field
  final String? text;

  /// Custom [InputDecoration] for the [InputDecorator] widget
  final InputDecoration? decoration;

  /// TextStyle for the field
  final TextStyle? textStyle;

  /// Callbacks triggered whenever the user presses on the field!
  final VoidCallback? onPressed;

  /// Whether the input field is empty.
  ///
  /// Determines the position of the label text and whether to display the hint
  /// text.
  ///
  /// Defaults to false.
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    final InputDecoration effectiveDecoration = decoration ??
        const InputDecoration(
          suffixIcon: Icon(Icons.arrow_drop_down),
        );

    return GestureDetector(
      onTap: onPressed,
      child: InputDecorator(
        decoration: effectiveDecoration.applyDefaults(
          Theme.of(context).inputDecorationTheme,
        ),
        isEmpty: isEmpty,
        child: text == null ? null : Text(text!, style: textStyle),
      ),
    );
  }
}
