# date_field

Contains DateTimeField and DateTimeFormField which allows the user to pick a DateTime from an input field! Depending on
the mode, it can ask the user the time, the date or both at the same time!

## Getting Started


The best way to discover this package is simply to check the example page!

There are two widgets in this package:

- DateTimeField
- DateTimeFormField

The second one is wrapping the first one with a FormField widget! This way you can integrate it in your form structure flawlessly.

The DateTimeField widget returns an InputDecorator with an Inkwell which will display a date picker (*platform responsive*) which allows the user to select the date and the time he wants!

You can customize the widget a lot thanks to these parameters:

<i>onSaved, validator, initialValue, autovalidate, enabled, firstDate, lastDate, label, dateFormat, decoration, initialDatePickerMode, mode (time, date, time and date)</i>

<img src='https://raw.githubusercontent.com/GaspardMerten/date_field/master/example/example.png' height='150px'></img>

If you want more details, I invite you to check the official documentation.