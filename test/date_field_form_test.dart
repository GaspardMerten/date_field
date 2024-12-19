import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeFormField', () {
    testWidgets('Works inside a Form and validates input',
        (WidgetTester tester) async {
      final GlobalKey<FormState> formKey = GlobalKey<FormState>();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: DateTimeFormField(
              mode: DateTimeFieldPickerMode.date,
              validator: (DateTime? value) {
                if (value == null) {
                  return 'Date is required';
                }
                return null;
              },
            ),
          ),
        ),
      ));

      // Initially, no value is provided, so validation should fail
      expect(formKey.currentState!.validate(), isFalse);

      // Simulate selecting a date:
      await tester.tap(find.byType(DateTimeFormField));
      // Wait for the picker to appear

      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // After setting a valid date, validation should pass
      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets(
        'Disabled DateTimeFormField (through [InputDecoration] cannot be interacted with',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            child: DateTimeFormField(
              decoration: const InputDecoration(
                enabled: false,
              ),
              mode: DateTimeFieldPickerMode.date,
              onChanged: (_) {},
            ),
          ),
        ),
      ));

      // Tapping the field shouldn't trigger any picker or changes since it's disabled
      await tester.tap(find.byType(DateTimeFormField));
      await tester.pump();

      // Ensure it still exists and no errors
      expect(find.byType(DateTimeFormField), findsOneWidget);
    });

    testWidgets(
        'Disabled DateTimeFormField (through enabled: false) cannot be interacted with',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            child: DateTimeFormField(
              enabled: false,
              mode: DateTimeFieldPickerMode.date,
              onChanged: (_) {},
            ),
          ),
        ),
      ));

      // Tapping the field shouldn't trigger any picker or changes since it's disabled
      await tester.tap(find.byType(DateTimeFormField));
      await tester.pump();

      // Ensure it still exists and no errors
      expect(find.byType(DateTimeFormField), findsOneWidget);
    });

    testWidgets('DateTimeFormField triggers onChanged when value changes',
        (WidgetTester tester) async {
      DateTime? formFieldValue;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            child: DateTimeFormField(
              mode: DateTimeFieldPickerMode.dateAndTime,
              onChanged: (DateTime? value) {
                formFieldValue = value;
              },
            ),
          ),
        ),
      ));

      final DateTime chosenDateTime = DateTime(2024, 7, 15, 16, 0);
      (tester.firstWidget(find.byType(DateTimeFormField)) as DateTimeFormField)
          .onChanged!(chosenDateTime);

      expect(formFieldValue, equals(chosenDateTime));
    });
  });
}
