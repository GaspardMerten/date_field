import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
      ),
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('de'),
        Locale('es'),
        Locale('it'),
        Locale('ja'),
        Locale('ko'),
        Locale('pt'),
        Locale('ru'),
        Locale('zh'),
      ],
      localizationsDelegates: const [
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? selectedDate;
  int? dropdownValue;

  @override
  Widget build(BuildContext context) {
    print(Localizations.localeOf(context).toString());
    return Scaffold(
      body: SingleChildScrollView(
        padding: MediaQuery.of(context).padding,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const FlutterLogo(size: 100),
              const SizedBox(height: 20),
              const Text('DateField package showcase'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('DateTimeField'),
              ),
// DateTimeField(
//   decoration: const InputDecoration(
//     hintText: 'Please select your birthday date and time',
//     helperText: 'YYYY-MM-DD',
//   ),
//   value: selectedDate,
//   onChanged: (DateTime? value) {
//     setState(() {
//       selectedDate = value;
//     });
//   },
// ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('DateTimeFormField'),
              ),
              Form(
                child: Column(
                  children: <Widget>[
// DateTimeFormField(
//   onChanged: null,
//   decoration: InputDecoration(
//     hintText: 'Disabled',
//   ),
// ),
// const SizedBox(height: 16),
// DateTimeFormField(
//   decoration: const InputDecoration(
//     hintText: 'My Super Date Time Field',
//     labelText: 'My Super Date Time Field',
//   ),
//   firstDate: DateTime.now().add(const Duration(days: 10)),
//   lastDate: DateTime.now().add(const Duration(days: 40)),
//   initialDate: DateTime.now().add(const Duration(days: 20)),
//   autovalidateMode: AutovalidateMode.always,
//   validator: (DateTime? e) =>
//       (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
//   onChanged: (DateTime? value) {
//     print(value);
//   },
// ),
                    DateTimeField.time(
                      // initialDate: selectedDate,
                      decoration: const InputDecoration(
                        labelText: 'My Super Date',
                      ),
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialTimePickerEntryMode: TimePickerEntryMode.dial,
                      firstDate: DateTime.now().add(const Duration(days: 10)),
                      lastDate: DateTime.now().add(const Duration(days: 40)),
                      initialPickerDateTime: DateTime.now().add(const Duration(days: 20)),
// autovalidateMode: AutovalidateMode.always,
// validator: (DateTime? e) =>
//     (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                      onChanged: (DateTime? value) {
                        print(value);
                        setState(() {
                          selectedDate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
// const SizedBox(height: 50),
// DateTimeFormField(
//   decoration: const InputDecoration(
//     alignLabelWithHint: false,
//     labelText: 'label',
//     hintText: 'Only time',
//   ),
//   canClear: true,
//   initialValue: DateTime.parse('2020-10-15'),
//   initialPickerDateTime: DateTime.parse('2020-10-15'),
//   mode: DateTimeFieldPickerMode.dateAndTime,
//   autovalidateMode: AutovalidateMode.always,
//   validator: (DateTime? e) {
//     return (e?.day ?? 0) == 1 ? 'Please not the first day' : null;
//   },
//   onChanged: (DateTime? value) {
//     print(value);
//   },
// ),
            ],
          ),
        ),
      ),
    );
  }
}
