# Welcome to the Date Field package! 📅

[![pub package](https://img.shields.io/pub/v/date_field.svg)](https://pub.dev/packages/date_field)

This package provides two widgets, DateTimeField and DateTimeFormField, which allow users to pick a date and/or time from an input field. You can customize the appearance of the widgets using the decoration argument, and specify whether to ask for a date, a time, or both using the mode parameter.

## Here's how to get started 🚀

Add the date_field package to your project's dependencies in pubspec.yaml.

```yaml
dependencies:
  ...
  date_field: ^3.0.0
```


Import the package in your Dart code.

```dart
import 'package:date_field/date_field.dart';
```

Use the DateTimeField or DateTimeFormField widget in your code, and customize it using the available parameters.

## Available Parameters 📝

- <b>onSaved</b>: a callback that is called when the form is saved.
- <b>validator</b>: a callback that is called to validate the value.
- <b>initialValue</b>: the initial value of the field.
- <b>autovalidateMode</b>: when to validate the field.
- <b>enabled</b>: whether the field is enabled or disabled.
- <b>use24hFormat</b>: whether to use a 24-hour format for the time picker.
- <b>dateTextStyle</b>: the text style for the date.
- <b>dateFormat</b>: the format of the date.
- <b>firstDate</b>: the earliest date that can be selected.
- <b>lastDate</b>: the latest date that can be selected.
- <b>initialDate</b>: the initial date that is selected.
- <b>onDateSelected</b>: a callback that is called when a date is selected.
- <b>decoration</b>: the decoration for the field.
- <b>initialEntryMode</b>: the initial entry mode of the date picker.
- <b>initialDatePickerMode</b>: the initial date picker mode.
- <b>mode</b>: the mode of the date and time picker.
- <b>initialTimePickerEntryMode</b>: the initial entry mode of the time picker.
- <b>fieldCreator</b>: the creator of the DateTimeField.

## Example Usage 📖

Here's an example usage of <b>DateTimeFormField</b>:

```dart
DateTimeFormField(
  decoration: const InputDecoration(
    hintStyle: TextStyle(color: Colors.black45),
    errorStyle: TextStyle(color: Colors.redAccent),
    border: OutlineInputBorder(),
    suffixIcon: Icon(Icons.event_note),
    labelText: 'Only time',
  ),
  mode: DateTimeFieldPickerMode.time,
  autovalidateMode: AutovalidateMode.always,
  validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
  onDateSelected: (DateTime value) {
    print(value);
  },
)
```

You can find more examples and a complete example on the GitHub repository. We hope this package is helpful to you!

## License 📜

This package is released under the MIT license.

## Contributing 🤝

Contributions to this package are welcome! If you find a bug or have a feature request, please create an issue on the GitHub repository. If you'd like to contribute code, please create a pull request with your changes.

Before submitting a pull request, please make sure to run the tests and ensure they all pass. Additionally, please follow the existing coding style and make sure your code is well-documented.

Thank you for your contributions!