import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalWidgetsLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
        ...GlobalCupertinoLocalizations.delegates,
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('date_field Showcase'),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Fields(),
                SizedBox(height: 32.0),
                FormFields(),
              ],
            ),
          ),
        ),
      );
}

class Fields extends StatefulWidget {
  const Fields({super.key});

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  DateTime? selectedDate;
  DateTime? selectedTime;
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'DateTimeField',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        DateTimeField(
          onChanged: null,
          decoration: const InputDecoration(labelText: 'Disabled'),
        ),
        const SizedBox(height: 16),
        DateTimeField(
          decoration: const InputDecoration(
            labelText: 'Enter Date',
            helperText: 'YYYY/MM/DD',
          ),
          value: selectedDate,
          dateFormat: DateFormat.yMd(),
          mode: DateTimeFieldPickerMode.date,
          onChanged: (DateTime? value) {
            setState(() {
              selectedDate = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DateTimeField(
          value: selectedTime,
          decoration: const InputDecoration(labelText: 'Enter Time'),
          mode: DateTimeFieldPickerMode.time,
          onChanged: (DateTime? value) {
            print(value);
            setState(() {
              selectedTime = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DateTimeField(
          value: selectedDateTime,
          decoration: const InputDecoration(labelText: 'Enter DateTime'),
          onChanged: (DateTime? value) {
            print(value);
            setState(() {
              selectedDateTime = value;
            });
          },
        ),
      ],
    );
  }
}

class FormFields extends StatelessWidget {
  const FormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'DateTimeFormField',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Form(
          child: Column(
            children: <Widget>[
              DateTimeFormField(
                onChanged: null,
                decoration: const InputDecoration(labelText: 'Disabled'),
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: const InputDecoration(labelText: 'Enter Date'),
                mode: DateTimeFieldPickerMode.date,
                onChanged: (DateTime? value) {
                  print(value);
                },
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: const InputDecoration(labelText: 'Enter Time'),
                mode: DateTimeFieldPickerMode.time,
                onChanged: (DateTime? value) {
                  print(value);
                },
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: const InputDecoration(labelText: 'Enter DateTime'),
                onChanged: (DateTime? value) {
                  print(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
