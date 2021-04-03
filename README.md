# date_field

[![pub package](https://img.shields.io/pub/v/date_field.svg)](https://pub.dartlang.org/packages/date_field)


Contains DateTimeField and DateTimeFormField which allows the user to pick a DateTime from an input field! Depending on
the mode, it can ask the user the time, the date or both at the same time ;) !

<img src='https://raw.githubusercontent.com/GaspardMerten/date_field/master/example/demo.gif' height='250px'></img>

## Usage

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  date_field: ^2.0.1
```

In your library add the following import:

```dart
import 'package:date_field/date_field.dart';
```


## Getting Started

There are two widgets in this package:

- DateTimeField
- DateTimeFormField

It follows the usual Flutter patterns convention, meaning the DateTimeFormField extends the FormField widget and wraps a DateTimeField widget.

You can customize both of these widgets with the decoration argument which is fully supported.

You can also specify whether you would like to ask the user for a date, a time or both using the mode parameter. 

## Example

The following picture illustrates some things you can do with this package.

<img src='https://raw.githubusercontent.com/GaspardMerten/date_field/master/example/demo.gif' height='250px'></img>


``` dart
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
),
```

You can check the Github repo for a complete example. 