##3.0.1

* Fixing [issue #29](https://github.com/GaspardMerten/date_field/issues/29) -> adding 24h format support for material time picker dialog

##3.0.0

* Breaking Upgraded minimum Dart version to 2.15 for Constructor Tearoff support
* Added optional `DateTimeFieldCreator` argument to `DateTimeFormField` to allow specifying custom implementations of `DateTimeField`
* Refactored `DateTimeField` to expose `showMaterialTimePicker`, `showMaterialDatePicker`, and `showMaterialTimePicker` as separate overrideable methods
* Made `kCupertinoDatePickerHeight` and `cupertinoModeFromPickerMode` public for convenience
* Removed `DateTimeFormFieldState`, replaced by an instance of `FormFieldState<DateTime>`
* Fixed the behaviour of the `initialDate' parameter.

##2.1.3

* [TheGlorySaint](https://github.com/TheGlorySaint) added the possibility to use the 24Hour Format at the Timepicker. Default it is set to false

##2.1.2

* Adding the possibility to specify the initial date selected in the date picker dialog.

##2.1.1

* Formatting with Dart FM

##2.1.0

* Fixing label & hint style issues
* Moving to a more generic architecture
* Updating the analysis_options.yaml file

##2.0.1

* Adding the ability to specify the entry mode for the material date picker.

##2.0.0

* Migrating to null-safety


##1.0.5

* Removing unused variables
* Improving description


##1.0.4

* Fixing critical issue

##1.0.3

* Improving package description

##1.0.2

* Improving package description

##1.0.1

* Removing the ripple effect

##1.0.0

* Full support for input decoration
* New standardized usage, many deprecations

##0.3.3

* Intl => any support

Breaking change:
* Removing the label property, please consider using the InputDecoration to customize the label.

##0.3.2

* Formating with dartfm

##0.3.1

* Adding the possibility to style the text with TextStyle

## 0.3.0

Breaking changes:
* No more const constructor.

Deprecated:
* DateField and DateFormField are now deprecated and will be removed in the next version, please consider switching to
  DateTimeField and DateTimeFormField.

Improvements:
* Adding support for time. Now you can ask the user for a time, a date or both.
* Improving performances by setting default value in the constructor.
* Adding .time constructor for the DateField widget only.

## 0.2.2

* Auto-formatting with dart-fm to meet pub.dev requirements

## 0.2.1

* Adding support for Flutter web

## 0.2.0

* DateFormField now extends FormField. All issues related to this are now fiex
* The style of the DateField (and by extension the one of DateFormField) is now rigorously applying the theme or any customization.

## 0.1.2

* Fixing an incorrect boolean (iOS picker was inverted with the Android one)

## 0.1.1

* Formatting with DartFM!

## 0.1.0

* Updating documentation!

## 0.0.2

* Fixing README.md
* Updating package description
* Formatting with DartFM

## 0.0.1

* Initial version
