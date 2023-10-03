import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ),
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
                  children: <Widget>[
                    DateTimeFormField(),
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'My Super Date Time Field',
                      ),
                      firstDate: DateTime.now().add(const Duration(days: 10)),
                      lastDate: DateTime.now().add(const Duration(days: 40)),
                      initialDate: DateTime.now().add(const Duration(days: 20)),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (DateTime? e) => (e?.day ?? 0) == 1
                          ? 'Please not the first day'
                          : null,
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
                      validator: (DateTime? e) {
                        return (e?.day ?? 0) == 1
                            ? 'Please not the first day'
                            : null;
                      },
                      onDateSelected: (DateTime value) {
                        print(value);
                      },
                    ),
                    /*
                  See how after selecting the TextFormField you can press tab
                  then press space or enter to open the date picker
                */
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Use enter or space key after tab key to open date picker",
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: Text(
                          "Select, hit tab key then enter or space key",
                        ),
                      ),
                    ),
                    DateTimeFormField(
                      showDatePickerOnFocus: true,
                      decoration: InputDecoration(
                        label: Text(
                          "Use space or enter key to open when focused",
                        ),
                      ),
                      logicalKeyboardKeyTriggers: [
                        LogicalKeyboardKey.enter,
                        LogicalKeyboardKey.space,
                        LogicalKeyboardKey.at, // @ also :O
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
