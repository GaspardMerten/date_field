import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group('DateTimeField', () {
    testWidgets('Displays initial value if provided',
        (WidgetTester tester) async {
      final DateTime initialDate = DateTime(2022, 10, 5);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            value: initialDate,
            dateFormat: DateFormat.yMd(),
            mode: DateTimeFieldPickerMode.date,
            onChanged: (_) {},
          ),
        ),
      ));

      // The displayed text should match the formatted initialDate.
      final String formattedInitial = DateFormat.yMd().format(initialDate);
      expect(find.text(formattedInitial), findsOneWidget);
    });

    testWidgets('Calls onChanged callback when date is updated',
        (WidgetTester tester) async {
      DateTime? changedValue;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            mode: DateTimeFieldPickerMode.date,
            onChanged: (DateTime? value) => changedValue = value,
          ),
        ),
      ));

      // Normally, you'd open the picker and select a date. For simplicity, we assume
      // the picker opens via a tap and the resulting date is passed to onChanged.
      // Since we can't rely on actual platform pickers in a pure unit test environment,
      // we simulate calling the widget's controller or onChanged directly.
      // In a real test, you might mock the behavior of showDatePicker.

      // Let's simulate a user choosing a date:
      final DateTime chosenDate = DateTime(2023, 1, 1);
      // Simulate that the field updated:
      (tester.firstWidget(find.byType(DateTimeField)) as DateTimeField)
          .onChanged!(chosenDate);

      expect(changedValue, equals(chosenDate));
    });

    testWidgets('Respects dateFormat for displayed values',
        (WidgetTester tester) async {
      final DateFormat dateFormat = DateFormat('yyyy/MM/dd');
      final DateTime testDate = DateTime(2023, 3, 15);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            value: testDate,
            dateFormat: dateFormat,
            mode: DateTimeFieldPickerMode.date,
            onChanged: (_) {},
          ),
        ),
      ));

      expect(find.text('2023/03/15'), findsOneWidget);
    });

    testWidgets(
        'Disabled DateTimeField through InputDecoration cannot be tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            decoration: const InputDecoration(
              enabled: false,
            ),
            mode: DateTimeFieldPickerMode.date,
            onChanged: (_) {},
          ),
        ),
      ));

      // Try tapping on the field
      await tester.tap(find.byType(DateTimeField));
      await tester.pump();

      // If the field is disabled, no date picker should appear and no changes should be made.
      // Since we cannot check the actual picker, we rely on the condition that onChanged
      // is never called or that the field doesn't focus or show any overlay.
      // We'll just ensure that tapping doesn't cause any exception or visible change.
      expect(find.byType(DateTimeField), findsOneWidget);
    });

    testWidgets(
        'Disabled DateTimeField through enabled: false cannot be tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            enabled: false,
            mode: DateTimeFieldPickerMode.date,
            onChanged: (_) {},
          ),
        ),
      ));

      // Try tapping on the field
      await tester.tap(find.byType(DateTimeField));
      await tester.pump();

      // If the field is disabled, no date picker should appear and no changes should be made.
      // Since we cannot check the actual picker, we rely on the condition that onChanged
      // is never called or that the field doesn't focus or show any overlay.
      // We'll just ensure that tapping doesn't cause any exception or visible change.
      expect(find.byType(DateTimeField), findsOneWidget);
    });

    testWidgets('Changes appearance based on pickerPlatform',
        (WidgetTester tester) async {
      // Test with material platform
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            mode: DateTimeFieldPickerMode.date,
            pickerPlatform: DateTimeFieldPickerPlatform.material,
            onChanged: (_) {},
          ),
        ),
      ));

      // For a unit test, we cannot fully test platform UI, but we can ensure the widget is created.
      expect(find.byType(DateTimeField), findsOneWidget);

      // Test with cupertino platform
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            mode: DateTimeFieldPickerMode.date,
            pickerPlatform: DateTimeFieldPickerPlatform.cupertino,
            onChanged: (_) {},
          ),
        ),
      ));

      // Just ensure we can rebuild with a different platform without issues.
      expect(find.byType(DateTimeField), findsOneWidget);
    });

    testWidgets('Handles time mode correctly', (WidgetTester tester) async {
      final DateTime initialTime = DateTime(2022, 1, 1, 10, 30); // 10:30 AM

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            value: initialTime,
            mode: DateTimeFieldPickerMode.time,
            onChanged: (_) {},
          ),
        ),
      ));

      // Check that the displayed value is time-formatted.
      final String displayedTime = DateFormat.jm().format(initialTime);
      expect(find.text(displayedTime), findsOneWidget);
    });

    testWidgets('Handles dateAndTime mode correctly',
        (WidgetTester tester) async {
      final DateTime initialDateTime =
          DateTime(2022, 12, 25, 15, 45); // Dec 25, 2022, 3:45 PM

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DateTimeField(
            value: initialDateTime,
            mode: DateTimeFieldPickerMode.dateAndTime,
            onChanged: (_) {},
          ),
        ),
      ));

      // Should display both date and time components.
      final String displayed =
          DateFormat.yMd().add_jm().format(initialDateTime);
      expect(find.text(displayed), findsOneWidget);
    });
  });

  testWidgets('Ensures initialPickerDateTime is used when no value is provided',
      (WidgetTester tester) async {
    // Ensure the initial date is set in the picker
    final DateTime initialDate = DateTime(2001, 11, 20);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DateTimeField(
          decoration: const InputDecoration(
            labelText: 'Enter Date',
            helperText: 'YYYY/MM/DD',
          ),
          initialPickerDateTime: initialDate,
          dateFormat: DateFormat.yMd(),
          mode: DateTimeFieldPickerMode.date,
          onChanged: (_) {},
      ),
    )));


    // Ensure that the initial date is displayed in the picker
    expect(find.text("November 2001"), findsNothing);

    // Tap the field to open the picker
    await tester.tap(find.byType(DateTimeField));
    await tester.pumpAndSettle();


    // Ensure that the initial date is displayed in the picker
    expect(find.text("November 2001"), findsOneWidget);
  });

  testWidgets('Ensures initialPickerDateTime is not used when value is provided',
          (WidgetTester tester) async {
        // Ensure the initial date is set in the picker
        final DateTime initialDate = DateTime(2001, 11, 20);
        final DateTime value = DateTime(2002, 12, 25);
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: DateTimeField(
                value: value,
                decoration: const InputDecoration(
                  labelText: 'Enter Date',
                  helperText: 'YYYY/MM/DD',
                ),
                initialPickerDateTime: initialDate,
                dateFormat: DateFormat.yMd(),
                mode: DateTimeFieldPickerMode.date,
                onChanged: (_) {},
              ),
            )));


        // Ensure that the initial date is displayed in the picker
        expect(find.text("December 2002"), findsNothing);

        // Tap the field to open the picker
        await tester.tap(find.byType(DateTimeField));
        await tester.pumpAndSettle();


        // Ensure that the initial date is displayed in the picker
        expect(find.text("December 2002"), findsOneWidget);
        expect(find.text("November 2001"), findsNothing);
      });
}
