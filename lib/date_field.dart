import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A [FormField] that contains a [DateField].
///
/// This is a convenience widget that wraps a [DateField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
class DateFormField extends FormField<DateTime> {

  DateFormField({
    Key key,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    DateTime initialValue,
    bool autovalidate = false,
    bool enabled = true,
    this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.label = 'Select date',
    this.dateFormat,
    this.decoration,
    this.initialDatePickerMode = DatePickerMode.day
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
      return DateField(
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


  @override
  _DateFormFieldState createState() => _DateFormFieldState();
}

class _DateFormFieldState extends FormFieldState<DateTime> {}

/// [DateField]
///
/// Shows an [_InputDropdown] that'll trigger [DateField._selectDate] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateField extends StatelessWidget {

  /// Default constructor
  const DateField({
    @required this.onDateSelected,
    @required this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.decoration,
    this.errorText,
    this.dateFormat,
    this.label = 'Select date',
    this.enabled = true,
  });

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

  /// Shows a dialog asking the user to pick a date !
  Future<void> _selectDate(BuildContext context) async {
    if (Platform.isIOS) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: onDateSelected,
              initialDateTime: selectedDate ?? lastDate ?? DateTime.now(),
              minimumDate: firstDate,
              maximumDate: lastDate,
            ),
          );
        },
      );
    }
    else {

      final DateTime _selectedDate = await showDatePicker(
          context: context,
          initialDatePickerMode: initialDatePickerMode,
          initialDate: selectedDate ?? lastDate ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100));

      if (_selectedDate != null) {
        onDateSelected(_selectedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String text;

    if (selectedDate != null)
      text = (dateFormat ?? DateFormat.yMMMd()).format(selectedDate);

    return _InputDropdown(
      text: text ?? label,
      label: text == null ? null : label,
      errorText: errorText,
      decoration: decoration,
      onPressed: enabled ? () {
        _selectDate(context);
      } : null,
    );
  }
}

///
/// [_InputDropdown]
///
/// Shows a field with a dropdown arrow !
/// It does not show any popup menu, it'll just trigger onPressed whenever the
/// user does click on it !
class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
        @required this.text,
        this.label,
        this.decoration,
        this.textStyle,
        this.onPressed,
        this.errorText,
      }) :
        assert(text != null),
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

    final InputDecoration effectiveDecoration = decoration?.copyWith(
        errorText: errorText
    ) ?? InputDecoration(
      labelText: label,
      errorText: errorText,
      suffixIcon: Icon(Icons.arrow_drop_down),
    ).applyDefaults(Theme.of(context).inputDecorationTheme);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: inkwellBorderRadius,
        onTap: onPressed,
        child: InputDecorator(
          decoration: effectiveDecoration,
          baseStyle: textStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(text, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
