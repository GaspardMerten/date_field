import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    Key key,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    DateTime initialValue,
    bool autovalidate = false,
    bool enabled = true,
    TextStyle textStyle,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.label = 'Select date',
    this.dateFormat,
    this.decoration,
    this.initialDatePickerMode = DatePickerMode.day,
    this.mode = DateFieldPickerMode.date,
  }) : super(
    key: key,
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    enabled: enabled,
    builder: (FormFieldState<DateTime> field) {
      final _DateFormFieldState state = field;

      void onChangedHandler(DateTime value) {
        if (onDateSelected != null) {
          onDateSelected(value);
        }
        field.didChange(value);
      }

      return DateTimeField(
        label: label,
        firstDate: firstDate,
        lastDate: lastDate,
        decoration: decoration,
        initialDatePickerMode: initialDatePickerMode,
        dateFormat: dateFormat,
        errorText: state.errorText,
        onDateSelected: onChangedHandler,
        selectedDate: state.value,
        enabled: enabled,
        mode: mode,
        textStyle: textStyle,
      );
    },
  );

  /// (optional) A callback that will be triggered whenever a new
  /// DateTime is selected
  final ValueChanged<DateTime> onDateSelected;

  /// (optional) The first date that the user can select (default is 1900)
  final DateTime firstDate;

  /// (optional) The last date that the user can select (default is 2100)
  final DateTime lastDate;

  /// (optional) The label to display for the field (default is 'Select date')
  final String label;

  /// (optional) Custom [InputDecoration] for the [InputDecorator] widget
  final InputDecoration decoration;

  /// (optional) How to display the [DateTime] for the user (default is [DateFormat.yMMMD])
  final DateFormat dateFormat;

  /// (optional) Let you choose the [DatePickerMode] for the date picker! (default is [DatePickerMode.day]
  final DatePickerMode initialDatePickerMode;

  /// Whether to ask the user to pick only the date, the time or both.
  final DateFieldPickerMode mode;

  @override
  _DateFormFieldState createState() => _DateFormFieldState();
}

class _DateFormFieldState extends FormFieldState<DateTime> {}

/// [DateTimeField]
///
/// Shows an [_InputDropdown] that'll trigger [DateTimeField._selectDate] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateTimeField extends StatelessWidget {
  /// Default constructor
  DateTimeField({
    Key key,
    @required this.onDateSelected,
    @required this.selectedDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.decoration,
    this.errorText,
    this.label = 'Select date',
    this.enabled = true,
    this.mode = DateFieldPickerMode.dateAndTime,
    this.textStyle,
    DateTime firstDate,
    DateTime lastDate,
    DateFormat dateFormat,
  })  : dateFormat = dateFormat ?? getDateFormatFromDateFieldPickerMode(mode),
        firstDate = firstDate ?? DateTime(1900),
        lastDate = lastDate ?? DateTime(2100),
        super(key: key);

  DateTimeField.time({
    Key key,
    this.onDateSelected,
    this.selectedDate,
    this.label,
    this.errorText,
    this.decoration,
    this.enabled,
    this.textStyle,
    DateTime firstDate,
    DateTime lastDate,
  })  : initialDatePickerMode = null,
        mode = DateFieldPickerMode.time,
        dateFormat = DateFormat.jm(),
        firstDate = firstDate ?? DateTime(2000),
        lastDate = lastDate ?? DateTime(2001),
        super(key: key);

  /// Callback for whenever the user selects a [DateTime]
  final ValueChanged<DateTime> onDateSelected;

  /// The current selected date to display inside the field
  final DateTime selectedDate;

  /// (optional) The first date that the user can select (default is 1900)
  final DateTime firstDate;

  /// (optional) The last date that the user can select (default is 2100)
  final DateTime lastDate;

  /// Let you choose the [DatePickerMode] for the date picker! (default is [DatePickerMode.day]
  final DatePickerMode initialDatePickerMode;

  /// The label to display for the field (default is 'Select date')
  final String label;

  /// (optional) The error text that should be displayed under the field
  final String errorText;

  /// (optional) Custom [InputDecoration] for the [InputDecorator] widget
  final InputDecoration decoration;

  /// (optional) How to display the [DateTime] for the user (default is [DateFormat.yMMMD])
  final DateFormat dateFormat;

  /// (optional) Whether the field is usable. If false the user won't be able to select any date
  final bool enabled;

  /// Whether to ask the user to pick only the date, the time or both.
  final DateFieldPickerMode mode;

  /// TextStyle of the text inside the button.
  final TextStyle textStyle;

  /// Shows a dialog asking the user to pick a date !
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDateTime = selectedDate ?? lastDate ?? DateTime.now();

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 216,
            child: CupertinoDatePicker(
              mode: _cupertinoModeFromPickerMode(mode),
              onDateTimeChanged: onDateSelected,
              initialDateTime: initialDateTime,
              minimumDate: firstDate,
              maximumDate: lastDate,
            ),
          );
        },
      );
    } else {
      DateTime _selectedDateTime = initialDateTime;

      if ([DateFieldPickerMode.dateAndTime, DateFieldPickerMode.date]
          .contains(mode)) {
        final DateTime _selectedDate = await showDatePicker(
            context: context,
            initialDatePickerMode: initialDatePickerMode,
            initialDate: initialDateTime,
            firstDate: firstDate,
            lastDate: lastDate);

        if (_selectedDate != null) {
          _selectedDateTime = _selectedDate;
        }
      }

      if ([DateFieldPickerMode.dateAndTime, DateFieldPickerMode.time]
          .contains(mode)) {
        final TimeOfDay _selectedTime = await showTimePicker(
          initialTime: TimeOfDay.fromDateTime(initialDateTime),
          context: context,
        );

        if (_selectedTime != null) {
          _selectedDateTime = DateTime(
              _selectedDateTime.year,
              _selectedDateTime.month,
              _selectedDateTime.day,
              _selectedTime.hour,
              _selectedTime.minute);
        }
      }

      onDateSelected(_selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    String text;

    if (selectedDate != null) text = dateFormat.format(selectedDate);

    return _InputDropdown(
      text: text ?? label,
      label: text == null ? null : label,
      errorText: errorText,
      textStyle: textStyle,
      decoration: decoration,
      onPressed: enabled ? () => _selectDate(context) : null,
    );
  }
}

/// Those values are used by the [DateTimeField] widget to determine whether to ask
/// the user for the time, the date or both.
enum DateFieldPickerMode { time, date, dateAndTime }

/// Returns the [CupertinoDatePickerMode] corresponding to the selected
/// [DateFieldPickerMode]. This exists to prevent redundancy in the [DateTimeField]
/// widget parameters.
CupertinoDatePickerMode _cupertinoModeFromPickerMode(DateFieldPickerMode mode) {
  switch (mode) {
    case DateFieldPickerMode.time:
      return CupertinoDatePickerMode.time;
    case DateFieldPickerMode.date:
      return CupertinoDatePickerMode.date;
    default:
      return CupertinoDatePickerMode.dateAndTime;
  }
}

/// Returns the corresponding default [DateFormat] for the selected [DateFieldPickerMode]
DateFormat getDateFormatFromDateFieldPickerMode(DateFieldPickerMode mode) {
  switch (mode) {
    case DateFieldPickerMode.time:
      return DateFormat.jm();
    case DateFieldPickerMode.date:
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
    Key key,
    @required this.text,
    this.label,
    this.decoration,
    this.textStyle,
    this.onPressed,
    this.errorText,
  })  : assert(text != null),
        super(key: key);

  /// The label to display for the field (default is 'Select date')
  final String label;

  /// The text that should be displayed inside the field
  final String text;

  /// (optional) The error text that should be displayed under the field
  final String errorText;

  /// (optional) Custom [InputDecoration] for the [InputDecorator] widget
  final InputDecoration decoration;

  /// TextStyle for the field
  final TextStyle textStyle;

  /// Callbacks triggered whenever the user presses on the field!
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    BorderRadius inkwellBorderRadius;

    if (decoration?.border?.runtimeType == OutlineInputBorder) {
      inkwellBorderRadius = BorderRadius.circular(8);
    }

    final InputDecoration effectiveDecoration =
        decoration?.copyWith(errorText: errorText) ??
            InputDecoration(
              labelText: label,
              errorText: errorText,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ).applyDefaults(Theme.of(context).inputDecorationTheme);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: inkwellBorderRadius,
        onTap: onPressed,
        child: InputDecorator(
          decoration: effectiveDecoration,
          baseStyle: textStyle,
          child: Text(text, style: textStyle),
        ),
      ),
    );
  }
}
