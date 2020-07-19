## 0.0.1

* Initial version

## 0.0.2

* Fixing README.md
* Updating package description
* Formatting with DartFM

## 0.1.0

* Updating documentation!

## 0.1.1

* Formatting with DartFM!

## 0.1.2

* Fixing an incorrect boolean (iOS picker was inverted with the Android one)

## 0.2.0

* DateFormField now extends FormField. All issues related to this are now fiex
* The style of the DateField (and by extension the one of DateFormField) is now rigorously applying the theme or any customization. 

## 0.2.1

* Adding support for Flutter web

## 0.2.2

* Auto-formatting with dart-fm to meet pub.dev requirements

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
