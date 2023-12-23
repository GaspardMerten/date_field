# Welcome to the Date Field package! 📅

[![pub package](https://img.shields.io/pub/v/date_field.svg)](https://pub.dev/packages/date_field)

This package provides two widgets, DateTimeField and DateTimeFormField, which allow users to pick a
date and/or time from an input field. You can customize the appearance of the widgets using the
decoration argument, and specify whether to ask for a date, a time, or both using the mode
parameter.

## Getting Started 🚀

1. Add date_field package to your dependencies in pubspec.yaml.
   ```yaml
   dependencies:
     ...
   date_field: ^4.0.0
   ```
2. Run `flutter pub get` to install the package.
3. Initialize your systems locale. If not, users might see AM/PM even when
   they configured their system to use 24h format. Add the following code to your main function:

   ```dart
   import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';

   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await findSystemLocale();
     runApp(const MyApp());
   }
   ```
4. Import the package in your Dart code.
   ```dart
   import 'package:date_field/date_field.dart';
   ```
5. Use the Widget. Example:

```dart
   DateTimeField(
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

Use the DateTimeField or DateTimeFormField widget in your code, and customize it using the available
parameters.

## Migration to 4.0.0 🚀

Version 4.0.0 contains breaking changes. Use `dart fix` to migrate to the latest version.

## Known Issues 🐛

- The pickers and formatted DateTimes adjust only on iOS and Android to the Device Systems Region.
  On all other platforms, the pickers adjust to the locale.
  See [32006](https://github.com/flutter/flutter/issues/32006)

## License 📜

This package is released under the MIT license.

## Contributing 🤝

Contributions to this package are welcome! If you find a bug or have a feature request, please
create an issue on the GitHub repository. If you'd like to contribute code, please create a pull
request with your changes.

Before submitting a pull request, please make sure to run the tests and ensure they all pass.
Additionally, please follow the existing coding style and make sure your code is well-documented.

Thank you for your contributions!