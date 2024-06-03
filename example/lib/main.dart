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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTimeFieldPickerPlatform platform = DateTimeFieldPickerPlatform.material;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('date_field Showcase'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text(
                  'DateTimeField',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Opacity(
                        opacity:
                            platform == DateTimeFieldPickerPlatform.material
                                ? 1
                                : 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              platform = DateTimeFieldPickerPlatform.material;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Material'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Opacity(
                        opacity:
                            platform == DateTimeFieldPickerPlatform.cupertino
                                ? 1
                                : 0.5,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              platform = DateTimeFieldPickerPlatform.cupertino;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Cupertino'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Fields(platform: platform),
                const SizedBox(height: 32.0),
                FilledButton(
                  onPressed: () async {
                    final DateTime? result = await showAdaptiveDateTimePicker(
                      context: context,
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      pickerPlatform: platform,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                      initialPickerDateTime: DateTime.now(),
                    );

                    if (result != null) {
                      await showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Selected Date and Time'),
                            content: Text(result.toString()),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Show Adaptive Dialog'),
                ),
                const SizedBox(height: 32.0),
                FormFields(dateTimePickerPlatform: platform),
              ],
            ),
          ),
        ),
      );
}

class Fields extends StatefulWidget {
  const Fields({super.key, required this.platform});

  final DateTimeFieldPickerPlatform platform;

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
        DateTimeField(
          pickerPlatform: widget.platform,
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
          pickerPlatform: widget.platform,
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
          pickerPlatform: widget.platform,
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
          pickerPlatform: widget.platform,
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
  const FormFields({super.key, required this.dateTimePickerPlatform});

  final DateTimeFieldPickerPlatform dateTimePickerPlatform;

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
                pickerPlatform: dateTimePickerPlatform,
                onChanged: null,
                decoration: const InputDecoration(labelText: 'Disabled'),
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: const InputDecoration(labelText: 'Enter Date'),
                mode: DateTimeFieldPickerMode.date,
                pickerPlatform: dateTimePickerPlatform,
                onChanged: (DateTime? value) {
                  print(value);
                },
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: const InputDecoration(labelText: 'Enter Time'),
                mode: DateTimeFieldPickerMode.time,
                pickerPlatform: dateTimePickerPlatform,
                onChanged: (DateTime? value) {
                  print(value);
                },
              ),
              const SizedBox(height: 16),
              DateTimeFormField(
                decoration: const InputDecoration(labelText: 'Enter DateTime'),
                pickerPlatform: dateTimePickerPlatform,
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
