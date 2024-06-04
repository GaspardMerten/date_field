part of 'field.dart';

/// A [FormField] that contains a [DateTimeField].
///
/// This is a convenience widget that wraps a [DateTimeField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    required this.onChanged,
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
    super.restorationId,
    super.autovalidateMode = AutovalidateMode.disabled,
    this.canClear = true,
    this.clearIconData = Icons.clear,
    TextStyle? style,
    VoidCallback? onTap,
    FocusNode? focusNode,
    bool autofocus = false,
    bool? enableFeedback,
    EdgeInsetsGeometry? padding,
    bool hideDefaultSuffixIcon = false,
    DateTime? initialPickerDateTime,
    CupertinoDatePickerOptions cupertinoDatePickerOptions =
        const CupertinoDatePickerOptions(),
    MaterialDatePickerOptions materialDatePickerOptions =
        const MaterialDatePickerOptions(),
    MaterialTimePickerOptions materialTimePickerOptions =
        const MaterialTimePickerOptions(),
    InputDecoration? decoration,
    DateFormat? dateFormat,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTimeFieldPickerMode mode = DateTimeFieldPickerMode.dateAndTime,
    DateTimeFieldPickerPlatform pickerPlatform =
        DateTimeFieldPickerPlatform.adaptive,
  }) : super(
          enabled: decoration?.enabled ?? true,
          builder: (FormFieldState<DateTime> field) {
            final _DateTimeFormFieldState state =
                field as _DateTimeFormFieldState;

            final bool isEmpty = state.value == null;

            InputDecoration decorationArg =
                (decoration ?? const InputDecoration())
                    .copyWith(errorText: field.errorText);

            if (canClear && !isEmpty) {
              decorationArg = decorationArg.copyWith(
                suffixIcon: IconButton(
                  icon: Icon(clearIconData),
                  onPressed: () => field.didChange(null),
                ),
              );
            }

            // An un-focusable Focus widget so that this widget can detect if its
            // descendants have focus or not.
            return Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: Builder(
                builder: (BuildContext context) {
                  return DateTimeField._formField(
                    value: state.value,
                    onChanged: onChanged == null ? null : state.didChange,
                    onTap: onTap,
                    style: style,
                    focusNode: focusNode,
                    autofocus: autofocus,
                    enableFeedback: enableFeedback,
                    decoration: decorationArg,
                    padding: padding,
                    firstDate: firstDate,
                    initialPickerDateTime: initialPickerDateTime,
                    lastDate: lastDate,
                    dateFormat: dateFormat,
                    mode: mode,
                    hideDefaultSuffixIcon: hideDefaultSuffixIcon,
                    cupertinoDatePickerOptions: cupertinoDatePickerOptions,
                    materialDatePickerOptions: materialDatePickerOptions,
                    materialTimePickerOptions: materialTimePickerOptions,
                    pickerPlatform: pickerPlatform,
                  );
                },
              ),
            );
          },
        );

  /// See [DateTimeField.onChanged].
  final ValueChanged<DateTime?>? onChanged;

  /// Whether to add an [IconButton] that clears the field or not.
  ///
  /// Defaults to true.
  final bool canClear;

  /// The icon to use for the clear button.
  final IconData clearIconData;

  @override
  FormFieldState<DateTime> createState() => _DateTimeFormFieldState();
}

class _DateTimeFormFieldState extends FormFieldState<DateTime> {
  @override
  void didChange(DateTime? value) {
    super.didChange(value);
    final DateTimeFormField dateTimeFormField = widget as DateTimeFormField;
    dateTimeFormField.onChanged?.call(value);
  }

  @override
  void didUpdateWidget(DateTimeFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
