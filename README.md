# date_field

Contains DateField and DateFormField which allows the user to pick a DateTime from an input field!

## Getting Started

Just to let you know, this is how it looks like without any customization:

<img src='https://raw.githubusercontent.com/GaspardMerten/date_field/master/example/example.png' height='150px'></img>

The best way to discover this package is simply to check the example page!

There are two widgets in this package:

- DateField
- DateFormField

The second one is wrapping the first one with a FormField widget! This way you can integrate it in your form structure flawlessly.

The DateField widget returns an InputDecorator with an Inkwell which will display a date picker (*platform responsive*) which allows the user to select the date he wants!

You can customize the widget a lot thanks to these parameters:

<i>onSaved, validator, initialValue, autovalidate, enabled, firstDate, lastDate, label, dateFormat, decoration, initialDatePickerMode</i>