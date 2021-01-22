import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme:
            const InputDecorationTheme(border: OutlineInputBorder()),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FlutterLogo(size: 100),
          const SizedBox(height: 20),
          const Text('DateField package showcase'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text('DateTimeField'),
          ),
          DateTimeField(
              decoration: const InputDecoration(
                  hintText: 'Please select your birthday date and time'),
              selectedDate: selectedDate,
              onDateSelected: (DateTime value) {
                setState(() {
                  selectedDate = value;
                });
              }),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text('DateTimeFormField'),
          ),
          Form(
            child: Column(
              children: [
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'My Super Date Time Field',
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) =>
                      (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                  onDateSelected: (DateTime value) {
                    print(value);
                  },
                ),
                const SizedBox(height: 50),
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
                  validator: (e) =>
                      (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                  onDateSelected: (DateTime value) {
                    print(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
