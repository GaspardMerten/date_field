# date_field

Contains DateField and DateFormField!

## Getting Started

Just to let you know, this is how it looks like without any customization:

<img src=''></img>

The best way to discover this package is simply to check the example page!

There are two widgets in this package:

- DateField
- DateFormField

The second one is wrapping the first one with a FormField widget! This way you can integrate it in your form structure flawlessly.

The DateField widget returns an InputDecorator with an Inkwell which will display a date picker (*platform responsive*) which allows the user to select the date he wants!

You can customize the widget a lot thanks to these parameters:

<pre><code>
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

</code></pre>