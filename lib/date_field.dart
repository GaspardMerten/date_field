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
class DateFormField extends StatelessWidget {
  /// An optional method to call with the final value when the form is saved via
  /// [FormState.save].
  final FormFieldSetter<DateTime> onSaved;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<DateTime> validator;

  /// An optional value to initialize the form field to, or null otherwise.
  final DateTime initialValue;

  /// If true, this form field will validate and update its error text
  /// immediately after every change. Otherwise, you must call
  /// [FormFieldState.validate] to validate. If part of a [Form] that
  /// auto-validates, this value will be ignored.
  final bool autovalidate;

  /// Whether the form is able to receive user input.
  ///
  /// Defaults to true. If [autovalidate] is true, the field will be validated.
  /// Likewise, if this field is false, the widget will not be validated
  /// regardless of [autovalidate].
  final bool enabled;

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

  const DateFormField(
      {Key key,
        this.onSaved,
        this.validator,
        this.initialValue,
        this.autovalidate = false,
        this.enabled = true,
        this.firstDate,
        this.lastDate,
        this.label = 'Select date',
        this.dateFormat,
        this.decoration,
        this.initialDatePickerMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
        onSaved: onSaved,
        autovalidate: autovalidate,
        validator: validator,
        enabled: enabled,
        initialValue: initialValue,
        builder: (FormFieldState state) {
          return DateField(
            label: label,
            firstDate: firstDate,
            lastDate: lastDate,
            decoration: decoration,
            initialDatePickerMode: initialDatePickerMode,
            dateFormat: dateFormat,
            errorText: state.errorText,
            onDateSelected: (DateTime value) {
              state.didChange(value);
            },
            selectedDate: state.value,
          );
        });
  }
}

///
/// [DateField]
///
/// Shows an [_InputDropdown] that'll trigger [DateField._selectDate] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateField extends StatelessWidget {
  /// Default constructor
  DateField({
    @required this.onDateSelected,
    @required this.selectedDate,
    this.firstDate,
    this.lastDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.decoration,
    this.label = 'Select date',
    this.errorText,
    this.dateFormat,
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

  /// Shows a dialog asking the user to pick a date !
  Future<void> _selectDate(BuildContext context) async {

    TextFormField();
    if (!Platform.isIOS) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 4,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime dateTime) =>
                  onDateSelected(dateTime),
              initialDateTime: selectedDate ?? lastDate ?? DateTime.now(),
              minimumDate: firstDate,
              maximumDate: lastDate,
            ),
          );
        },
      );
    } else {
      DateTime _selectedDate = await showDatePicker(
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
      onPressed: () {
        _selectDate(context);
      },
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
        this.label,
        this.text,
        this.decoration,
        this.textStyle,
        this.onPressed,
        this.errorText})
      : super(key: key);

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
    assert(text != null);

    BorderRadius inkwellBorderRadius;

    if (decoration?.border?.runtimeType == OutlineInputBorder) {
      inkwellBorderRadius = BorderRadius.circular(8);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: inkwellBorderRadius,
        onTap: onPressed,
        child: InputDecorator(
          decoration: decoration ??  InputDecoration(
              labelText: label,
              errorText: errorText,
              border: UnderlineInputBorder(borderSide: BorderSide()),
              contentPadding: EdgeInsets.only(bottom: 2.0)),
          baseStyle: textStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(text, style: textStyle),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
