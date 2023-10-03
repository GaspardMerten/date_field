# 3.1.0

- added ```logicalKeyboardKeyTriggers```
    - ```List<LogicalKeyboardKey>```
    - these triggers are used to open the date picker if the user presses one of
      them
    - only works when a physical keyboard is present
- added ```showDatePickerOnFocus```
    - ```bool```
    - when true the date picker is shown when the form field is focused
        - by tab, or next

# 3.0.6

- Fixing issue #42 dense empty form field

# 3.0.5

- Bumping intl to 0.18.0

# 3.0.4

- Updating Changelog.md

# 3.0.3

- Updating the README.md file. Adding more information about the package,
  rewriting the text to make it more appealing.
- Adding support for providing a different initial time mode for the material
  time picker dialog (thanks to @schalky).

# 3.0.2

Added support for clickable pointer on desktop and web.

# 3.0.1

Fixed issue #29 by adding 24-hour format support for the material time picker
dialog.

# 3.0.0

Upgraded the minimum Dart version to 2.15 for constructor tear-off support,
which is a breaking change.
Added an optional DateTimeFieldCreator argument to DateTimeFormField for
specifying custom implementations of DateTimeField.
Refactored DateTimeField to expose showMaterialTimePicker,
showMaterialDatePicker, and showMaterialTimePicker as separate overrideable
methods.
Made kCupertinoDatePickerHeight and cupertinoModeFromPickerMode public for
convenience.
Removed DateTimeFormFieldState and replaced it with an instance of
FormFieldState<DateTime>.
Fixed the behavior of the initialDate parameter.

# 2.1.3

Added the possibility to use the 24-hour format for the time picker. Default is
set to false.

# 2.1.2

Added the ability to specify the initial date selected in the date picker
dialog.

# 2.1.1

Formatted code with Dart FM.

# 2.1.0

Fixed label and hint style issues.
Moved to a more generic architecture.
Updated the analysis_options.yaml file.

# 2.0.1

Added the ability to specify the entry mode for the material date picker.

# 2.0.0

Migrated to null-safety.

# 1.0.5

Removed unused variables and improved the description.

# 1.0.4

Fixed a critical issue.

# 1.0.3

Improved the package description.

# 1.0.2

Improved the package description.

# 1.0.1

Removed the ripple effect.

# 1.0.0

Added full support for input decoration.
Adopted a new standardized usage, with many deprecations.

# 0.3.3

Changed support from Intl to any, which is a breaking change.
Removed the label property, and suggested using the InputDecoration to customize
the label.

# 0.3.2

Formatted the code with Dart FM.

# 0.3.1

Added the possibility to style the text with TextStyle.

# 0.3.0

Removed the const constructor, which is a breaking change.
Deprecated DateField and DateFormField, and added support for time.
Improved performance by setting the default value in the constructor.
Added a .time constructor for the DateField widget only.

# 0.2.2

Formatted the code with dart-fm to meet pub.dev requirements.

# 0.2.1

Added support for Flutter web.

# 0.2.0

Changed DateFormField to extend FormField, and rigorously applied the style to
match the theme or any customization.

# 0.1.2

Fixed an incorrect boolean value (the iOS picker was inverted with the Android
one).

# 0.1.1

Formatted the code with DartFM.

# 0.1.0

Updated the documentation.

# 0.0.2

Fixed the README.md and updated the package description.
Formatted the code with DartFM.

# 0.0.1

* Initial version
