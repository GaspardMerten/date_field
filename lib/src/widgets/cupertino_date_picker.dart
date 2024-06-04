import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kCupertinoDatePickerHeight = 216;

class CupertinoDatePickerModalSheet extends StatefulWidget {
  const CupertinoDatePickerModalSheet({
    super.key,
    required this.initialPickerDateTime,
    required this.options,
    required this.mode,
    required this.use24hFormat,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialPickerDateTime;

  final CupertinoDatePickerOptions options;

  final DateTimeFieldPickerMode mode;

  final bool use24hFormat;

  final DateTime firstDate;

  final DateTime lastDate;

  @override
  State<CupertinoDatePickerModalSheet> createState() =>
      _CupertinoDatePickerModalSheetState();
}

class _CupertinoDatePickerModalSheetState
    extends State<CupertinoDatePickerModalSheet> {
  DateTime? _pickedDate;

  late Map<Type, Action<Intent>> _cancelActionMap;
  late Map<Type, Action<Intent>> _saveActionMap;

  @override
  void initState() {
    super.initState();
    _pickedDate = widget.initialPickerDateTime;

    _cancelActionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _cancel(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _cancel(),
      ),
    };
    _saveActionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _save(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _save(),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context).removePadding(
      removeTop: true,
      removeBottom: false,
      removeLeft: false,
      removeRight: false,
    );

    return MediaQuery(
      data: mediaQueryData,
      child: CupertinoPopupSurface(
        isSurfacePainted: true,
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            backgroundColor: CupertinoDynamicColor.resolve(
              CupertinoTheme.of(context).barBackgroundColor,
              context,
            ),
            brightness: Theme.of(context).brightness,
            middle: Text(
              widget.options.modalTitleText ??
                  MaterialLocalizations.of(context).dateInputLabel,
              style: widget.options.style.modalTitle ??
                  CupertinoTheme.of(context).textTheme.navTitleTextStyle,
            ),
            leading: FocusableActionDetector(
              actions: _cancelActionMap,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  widget.options.cancelText ??
                      CupertinoLocalizations.of(context)
                          .modalBarrierDismissLabel,
                  style: widget.options.style.cancelButton,
                ),
                onPressed: _cancel,
              ),
            ),
            trailing: FocusableActionDetector(
              actions: _saveActionMap,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(
                  widget.options.saveText ??
                      MaterialLocalizations.of(context).saveButtonLabel,
                  style: widget.options.style.saveButton,
                ),
                onPressed: _save,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // _kNavBarPersistentHeight equals kMinInteractiveDimensionCupertino
              const SizedBox(height: kMinInteractiveDimensionCupertino),
              SizedBox(
                height: _kCupertinoDatePickerHeight,
                child: CupertinoDatePicker(
                  mode: widget.mode.toCupertinoDatePickerMode(),
                  onDateTimeChanged: (DateTime dt) => _pickedDate = dt,
                  initialDateTime: widget.initialPickerDateTime,
                  minimumDate: widget.firstDate,
                  maximumDate: widget.lastDate,
                  use24hFormat: widget.use24hFormat,
                  showDayOfWeek: widget.options.showDayOfWeek,
                  minuteInterval: widget.options.minuteInterval,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    Navigator.of(context).pop(_pickedDate);
  }

  void _cancel() {
    Navigator.of(context).pop(null);
  }
}
