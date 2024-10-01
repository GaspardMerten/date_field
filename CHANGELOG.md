# 5.3.0

- Fixing material dialogs returning the initial value on cancel instead of null. This caused updates
  to the `DateTimeFormField` even if it should not. Solution to issue #79

# 5.2.2

- Localization assertions depend now on the picker platform. See #77

# 5.2.1

- Fixing issue #72, some dependencies are not exported.

# 5.2.0

- Extracting the display of the adaptive picker dialog to a separate public
  function `showAdaptiveDateTimePickerDialog`
  to allow displaying the dialog without the need to use the `DateTimeField` widget.
- Updating the example to demonstrate the usage of the new function, and adding a toggle button to
  switch between
  cupertino
  and material pickers.
- Refactoring the structure of the library to make it more readable and maintainable.

# 5.1.0

- Added option pickerPlatform to fix the picker type to material, or cupertino, or keep it adaptive.
- Replacing the placeholder by an empty Text widget instead of a SizedBox.

# 5.0.1

- DartFmt the code

# 5.0.0

- Removed deprecated parameters

# 4.1.0

- Adding better styling options for the iOS and MacOS modal sheet. It is now possible to specify the
  text style of the
  save and cancel buttons, as well as the title of the modal sheet. Solution to issue #59

# 4.0.2

- Making the package compatible with Dart 3.3.3 (allowing intl to be between 0.18.0 and < 0.20.0)
  Solution for issue #61

# 4.0.1

- Fix clear button disappearing on rebuild

# 4.0.0

- Removing override of MediaQuery.alwaysUse24HourFormat from the time picker dialog

## Breaking changes

### DateTimeField

- `onDateSelected` got deprecated. Use `onChanged` instead. `onDateSelected` will be removed in
  v5.0.0.
- `onChange` is required

### DateTimeField.time

- `onDateSelected` got deprecated. Use `onChanged` instead. `onDateSelected` will be removed in
  v5.0.0.
- `onChange` is required

### DateTimeFormField

- `onDateSelected` got deprecated. Use `onChanged` instead. `onDateSelected` will be removed in
  v5.0.0.
- `onChange` is required.
- removed `fieldCreator`.

## New features

### DateTimeField

- Parameter namings are now similar as in flutter widgets.
- The widget is now fully accessible and controllable with a keyboard.
- The iOS and MacOS modal sheet has now a save and cancel button
- `onChanged` accepts now also `null` values. DateTimeFormField uses this to implement a clear
  button.
- All texts and interesting settings of `DatePickerDialog`, `TimePickerDialog`
  and `CupertinoDatePicker` are now
  changeable

_Thank you, @torbenkeller, for this well-needed PR._

# 3.0.6

- Fixing issue #42 dense empty form field

# 3.0.5

- Bumping intl to 0.18.0

# 3.0.4

- Updating Changelog.md

# 3.0.3

- Updating the README.md file. Adding more information about the package, rewriting the text to make
  it more appealing.
- Adding support for providing a different initial time mode for the material time picker dialog (
  thanks to @schalky).

# 3.0.2

Added support for clickable pointer on desktop and web.

# 3.0.1

Fixed issue #29 by adding 24-hour format support for the material time picker dialog.

# 3.0.0

- Upgraded the minimum Dart version to 2.15 for constructor tear-off support, which is a breaking change.
- Added an optional DateTimeFieldCreator argument to DateTimeFormField for specifying custom implementations of
  DateTimeField.
- Refactored DateTimeField to expose showMaterialTimePicker, showMaterialDatePicker, and showMaterialTimePicker as
  separate overrideable methods.
- Made kCupertinoDatePickerHeight and cupertinoModeFromPickerMode public for convenience.
- Removed DateTimeFormFieldState and replaced it with an instance of FormFieldState<DateTime>.
- Fixed the behavior of the initialDate parameter.

# 2.1.3

- Added the possibility to use the 24-hour format for the time picker. Default is set to false.

# 2.1.2

- Added the ability to specify the initial date selected in the date picker dialog.

# 2.1.1

- Formatted code with Dart FM.

# 2.1.0

- Fixed label and hint style issues.
- Moved to a more generic architecture.
- Updated the analysis_options.yaml file.

# 2.0.1

- Added the ability to specify the entry mode for the material date picker.

# 2.0.0

- Migrated to null-safety.

# 1.0.5

- Removed unused variables and improved the description.

# 1.0.4

- Fixed a critical issue.

# 1.0.3

- Improved the package description.

# 1.0.2

- Improved the package description.

# 1.0.1

- Removed the ripple effect.

# 1.0.0

- Added full support for input decoration.
- Adopted a new standardized usage, with many deprecations.

# 0.3.3

- Changed support from Intl to any, which is a breaking change.
- Removed the label property, and suggested using the InputDecoration to customize the label.

# 0.3.2

- Formatted the code with Dart FM.

# 0.3.1

- Added the possibility to style the text with TextStyle.

# 0.3.0

- Removed the const constructor, which is a breaking change.
- Deprecated DateField and DateFormField, and added support for time.
- Improved performance by setting the default value in the constructor.
- Added a .time constructor for the DateField widget only.

# 0.2.2

- Formatted the code with dart-fm to meet pub.dev requirements.

# 0.2.1

- Added support for Flutter web.

# 0.2.0

- Changed DateFormField to extend FormField, and rigorously applied the style to match the theme or
  any customization.

# 0.1.2

- Fixed an incorrect boolean value (the iOS picker was inverted with the Android one).

# 0.1.1

- Formatted the code with DartFM.

# 0.1.0

- Updated the documentation.

# 0.0.2

- Fixed the README.md and updated the package description.
- Formatted the code with DartFM.

# 0.0.1

- Initial version
